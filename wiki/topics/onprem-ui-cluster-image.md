# On-prem UI cluster image (build + rollout)

**Skill:** [`.cursor/skills/koku-ui-onprem-cluster-image/`](../../.cursor/skills/koku-ui-onprem-cluster-image/SKILL.md)

Build **linux/amd64** `koku-ui-onprem` images for OpenShift without `podman build --platform linux/amd64` on Apple Silicon (QEMU TLS breaks `npm ci` in the builder). Roll out with Helm on your cluster from the Mac.

## Two on-demand steps

| Step | Where | When |
| ---- | ----- | ---- |
| **Build** new UI version | GitHub Actions `workflow_dispatch` only | After `koku-ui` gitlink is on `main` and pushed |
| **Roll out** UI to cluster | Local `rollout-ui-image.sh` + `verify-ui-pod.sh` | When Quay already has the tag |

No automatic builds on git push, tags, or branch names. The workflow builds the **`koku-ui` submodule SHA** pinned at the dispatched workspace `ref` (default `main`).

## Build (GHA)

1. Commit submodule pointer on workspace `main`; push to `origin`.
2. `bash .cursor/skills/koku-ui-onprem-cluster-image/scripts/trigger-build.sh <tag> [ref]`
3. Secrets on GitHub: `QUAY_USERNAME`, `QUAY_PASSWORD` — see skill [references/secrets.md](../../.cursor/skills/koku-ui-onprem-cluster-image/references/secrets.md).
4. Workflow: [`.github/workflows/build-koku-ui-onprem.yml`](../../.github/workflows/build-koku-ui-onprem.yml)
5. Image: `quay.io/jkilzi/koku-ui-onprem:<tag>` (adjust org in local values if needed).

**Container recipe:** upstream [`submodules/koku-ui/apps/koku-ui-onprem/Containerfile`](../../submodules/koku-ui/apps/koku-ui-onprem/Containerfile).

## Rollout (local Helm)

1. Copy [`ui-image-values.example.yaml`](../../.cursor/skills/koku-ui-onprem-cluster-image/references/ui-image-values.example.yaml) → `ui-image-values.local.yaml` (gitignored).
2. Set `ui.app.image.tag` to an **existing** Quay tag.
3. `bash .cursor/skills/koku-ui-onprem-cluster-image/scripts/rollout-ui-image.sh`
4. `bash .cursor/skills/koku-ui-onprem-cluster-image/scripts/verify-ui-pod.sh` — `/rbac/plugin-manifest.json` → **200**.

Uses [`install-helm-chart.sh`](../../submodules/cost-onprem-chart/scripts/install-helm-chart.sh) with `VALUES_FILE` — same chart path as [cost-onprem-chart-install](../../.cursor/skills/cost-onprem-chart-install/SKILL.md).

**SSA / `oc set image`:** UI rollouts set `HELM_FORCE_CONFLICTS=true` so Helm passes `--force-conflicts` and reclaims fields previously patched outside Helm (e.g. emergency `oc set image` on `cost-onprem-ui`).

## Mac amd64 limitation

Do not rely on local `podman build --platform linux/amd64` for cluster tags. See [containers/podman#18271](https://github.com/containers/podman/issues/18271), [#18301](https://github.com/containers/podman/issues/18301).

## Related

- [FLPATH-4164 entity](../entities/flpath-4164-rbac-mfe-poc.md) — cluster image record and acceptance checks
- [ui-verification-and-e2e.md](ui-verification-and-e2e.md) — local Cypress before build
- [public-repo-hygiene.md](../workspace/public-repo-hygiene.md) — redact personal Quay/cluster URLs in committed docs
