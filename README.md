# rtno-platform

Local infrastructure and developer experience for the Real-Time Network Observability Engine.

This repository owns Docker Compose, ClickHouse configuration, Grafana provisioning wiring, setup scripts, and operational docs for booting the local stack.

It composes the system but does not own business logic.

Repository boundaries and build order are documented in [`docs/repository-architecture.md`](docs/repository-architecture.md).

## Prerequisites

- Docker Desktop or Docker Engine with Compose v2
- Ports `8123`, `9000`, and `3000` available locally

## Boot the local stack

From this repository:

```bash
docker compose up -d
```

Check service health:

```bash
docker compose ps
```

Expected healthy services:

- `rtno-clickhouse`
- `rtno-grafana`

## Service endpoints

| Service | URL / Port | Purpose |
|---|---|---|
| ClickHouse HTTP | http://localhost:8123 | SQL over HTTP, health ping |
| ClickHouse native | localhost:9000 | Native client protocol |
| Grafana | http://localhost:3000 | Dashboards and alerts |

## Default credentials

Grafana local login:

- Username: `admin`
- Password: `admin`

ClickHouse uses the default user with no password for local development only.

## Useful commands

Start stack:

```bash
docker compose up -d
```

Follow logs:

```bash
docker compose logs -f
```

Stop stack:

```bash
docker compose down
```

Stop stack and remove volumes:

```bash
docker compose down -v
```

## Verify ClickHouse

```bash
curl http://localhost:8123/ping
docker compose exec clickhouse clickhouse-client --query "SELECT 1"
```

## Verify Grafana

```bash
curl http://localhost:3000/api/health
```

Then open http://localhost:3000 in a browser.

## What comes next

- RTNO-005: ClickHouse schema migrations aligned with `rtno-contracts`
- RTNO-006: Grafana ClickHouse datasource provisioning
- RTNO-007: Makefile or task runner for common dev commands
