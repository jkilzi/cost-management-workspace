# cost-onprem-chart — constitution

## Upstream repository

https://github.com/insights-onprem/cost-onprem-chart.git

## Mission

Helm chart repository for deploying Cost Management and related on-premise components on OpenShift: a unified `cost-onprem` chart covering the full stack (including ROS, Kruize, Koku with Sources API, PostgreSQL, Valkey, and supporting pipeline pieces) with documentation and scripted install and validation paths.

## Tech stack

- Helm 3 (`apiVersion: v2` charts), Kubernetes / OpenShift targets
- YAML templates and values; optional OpenShift-specific values files
- Python pytest-based end-to-end tests and helper scripts under `scripts/` and `tests/`
- Operational docs alongside the chart (installation, architecture, prerequisites such as Kafka and S3-compatible storage)
