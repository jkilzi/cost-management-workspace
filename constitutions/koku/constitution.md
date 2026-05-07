# Koku — constitution

## Upstream repository

https://github.com/project-koku/koku.git

## Mission

Koku provides an open-source cost management solution for cloud and hybrid cloud environments. It exposes resource consumption and cost data through APIs and supporting experiences, with the goal of making usage easy to filter and understand, surfacing insight, and guiding optimizations that reduce cost and unnecessary resource use.

## Tech stack

- Python 3.11+
- Django (~5.x) and Django REST Framework
- Celery, Redis, PostgreSQL (`psycopg2`), multi-tenant patterns (`django-tenants`)
- Apache Kafka via `confluent-kafka`; optional Trino and cloud data tooling (AWS, Azure, GCP clients) per deployment
- Gunicorn, Prometheus-oriented metrics (`django-prometheus`, `prometheus-client`)
- Dependency and venv workflow: Pipenv and `Pipfile`; Docker-based local development
- Pre-commit hooks; CI via GitHub Actions

Upstream issue tracking: [COST](https://issues.redhat.com/projects/COST/) (see project README).
