---
name: koku-ui-onprem-cluster-image
description: >-
  Build and roll out koku-ui-onprem cluster images for Cost Management on-prem.
  Build: on-demand GitHub Actions (workflow_dispatch) pushes amd64 to personal
  Quay from the committed koku-ui submodule gitlink — not Mac podman amd64.
  Rollout: local Helm upgrade via ui-image-values.local.yaml and
  install-helm-chart.sh. Use when building a new UI version, rolling out UI to
  the cluster, Quay koku-ui-onprem tags, or FLPATH-4164 cluster image updates.
disable-model-invocation: true
---

# koku-ui-onprem cluster image (build + rollout)

## Two on-demand flows

| Flow | Trigger phrases | Where | Script |
| ---- | --------------- | ----- | ------ |
| **A — Build** | build / produce a **new UI version** or image | GitHub Actions only | [`scripts/trigger-build.sh`](scripts/trigger-build.sh) |
| **B — Rollout** | **roll out** / deploy UI to the **cluster** | Local Mac (`oc` + Helm) | [`scripts/rollout-ui-image.sh`](scripts/rollout-ui-image.sh) |

GHA **never** deploys to OpenShift. Rollout **does not** start a build unless you run flow A first.

## Authority and paths

- **Container recipe:** [`submodules/koku-ui/apps/koku-ui-onprem/Containerfile`](../../../submodules/koku-ui/apps/koku-ui-onprem/Containerfile) (upstream; `RUN npm ci`, multi-app build)
- **GHA workflow:** [`.github/workflows/build-koku-ui-onprem.yml`](../../../.github/workflows/build-koku-ui-onprem.yml)
- **Chart / Helm:** [`submodules/cost-onprem-chart/`](../../../submodules/cost-onprem-chart/) — see [cost-onprem-chart-install](../cost-onprem-chart-install/SKILL.md)
- **Wiki:** [wiki/topics/onprem-ui-cluster-image.md](../../../wiki/topics/onprem-ui-cluster-image.md)

Default image: `quay.io/jkilzi/koku-ui-onprem:<tag>` (override repository in local values if needed).

## Mac limitation (cluster tags)

Do **not** use `podman build --platform linux/amd64` on Apple Silicon for production cluster images — `npm ci` fails with ECDSA TLS errors under QEMU ([podman#18271](https://github.com/containers/podman/issues/18271), [#18301](https://github.com/containers/podman/issues/18301)). Native **arm64** builds are optional Dockerfile smoke only.

## A — Build new UI version (GHA)

### Prerequisites

1. Changes landed in `submodules/koku-ui` (any task branch).
2. Workspace **`koku-ui` gitlink** updated on `main` and **pushed** to `origin`.
3. GitHub repo secrets: `QUAY_USERNAME`, `QUAY_PASSWORD` (robot with push to `jkilzi/koku-ui-onprem`) — see [references/secrets.md](references/secrets.md).

### Run

From workspace root:

```bash
bash .cursor/skills/koku-ui-onprem-cluster-image/scripts/trigger-build.sh <image_tag> [ref]
```

- **`image_tag`** (required) — e.g. `flpath-4164-rc22`
- **`ref`** (optional) — workspace branch or SHA on GitHub (default `main`); selects which **submodule gitlink** to build, not a `koku-ui` branch inside the workflow

Or: **Actions → Build koku-ui-onprem → Run workflow**.

### Output

Image `quay.io/jkilzi/koku-ui-onprem:<image_tag>` on Quay. Confirm the tag exists before rollout.

## B — Roll out UI to cluster (local)

### Prerequisites

1. `oc login`; chart already installed (`cost-onprem` namespace).
2. Image **already on Quay** with the tag you will deploy.
3. Local values file: copy [references/ui-image-values.example.yaml](references/ui-image-values.example.yaml) → [references/ui-image-values.local.yaml](references/ui-image-values.local.yaml) (gitignored) and set `ui.app.image.tag` (and `repository` if not `jkilzi`).
4. If the cluster cannot pull private Quay: `global.imagePullSecrets` with `<quay-pull-secret>` in the same file.

### Run

```bash
bash .cursor/skills/koku-ui-onprem-cluster-image/scripts/rollout-ui-image.sh
bash .cursor/skills/koku-ui-onprem-cluster-image/scripts/verify-ui-pod.sh
```

`rollout-ui-image.sh` runs `VALUES_FILE=<local yaml>` + [`install-helm-chart.sh`](../../../submodules/cost-onprem-chart/scripts/install-helm-chart.sh) from `submodules/cost-onprem-chart/`.

### Verify

- In-pod: `GET /rbac/plugin-manifest.json` → **200** (`verify-ui-pod.sh`)
- Optional: UI smoke behind oauth2-proxy on cluster route

## Tag conventions

- Scoped work: `flpath-4164-rc<N>`
- Ad-hoc: `onprem-<short-sha>` or any unique tag you pass to `trigger-build.sh`

## npm / Containerfile notes

If GHA build fails on **EBADENGINE** (UBI npm vs `engines.npm >=11.6.2`), prefer fixing the builder base upstream. Documented fallback (SKILL only, not default Containerfile): replace `RUN npm ci` with `RUN npm install` on a clean layer.

## Submodule Git reminder

`koku-ui` changes belong on a task branch per [submodule-git-workflow.mdc](../../rules/submodule-git-workflow.mdc); bump the superproject gitlink on `main` before dispatching a build.
