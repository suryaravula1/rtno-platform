# rtno-platform

Local infrastructure and developer experience for the Real-Time Network Observability Engine.

This repository owns Docker Compose, ClickHouse configuration, Grafana provisioning wiring, setup scripts, and operational docs for booting the local stack.

It composes the system but does not own business logic.

Repository boundaries and build order are documented in [`docs/repository-architecture.md`](docs/repository-architecture.md).

## Prerequisites

- Docker Desktop or Docker Engine with Compose v2
- `make` (optional, recommended)
- Ports `8123`, `9000`, and `3000` available locally

## Boot the local stack

From this repository:

```bash
make up
```

Or without Make:

```bash
docker compose up -d
```

Check service health:

```bash
make ps
```

Expected healthy services:

- `rtno-clickhouse`
- `rtno-grafana`

## Makefile commands

| Command | Purpose |
|---|---|
| `make up` | Start ClickHouse and Grafana |
| `make down` | Stop containers and keep data |
| `make logs` | Follow container logs |
| `make reset` | Stop containers and delete volumes |
| `make ps` | Show container status |
| `make ping` | Check ClickHouse and Grafana HTTP health |
| `make verify` | Describe `rtno.packet_window_events` table |

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

## Grafana ClickHouse datasource

Grafana auto-provisions a ClickHouse datasource from [`grafana/provisioning/datasources/clickhouse.yml`](grafana/provisioning/datasources/clickhouse.yml).

- Name: `RTNO ClickHouse`
- Database: `rtno`
- Server: `clickhouse:8123` inside the Docker network

After `make up`, open Grafana → **Connections → Data sources** and confirm **RTNO ClickHouse** is present.

If Grafana was already running before this provisioning was added, recreate it:

```bash
docker compose up -d --force-recreate grafana
```

## Verify ClickHouse

```bash
make ping
make verify
```

Or manually:

```bash
curl http://127.0.0.1:8123/ping
docker compose exec clickhouse clickhouse-client --query "SELECT 1"
```

## Verify Grafana

```bash
curl http://localhost:3000/api/health
```

Then open http://localhost:3000 in a browser.

## ClickHouse schema

On first boot, ClickHouse applies init SQL from [`clickhouse/initdb.d/`](clickhouse/initdb.d/) and creates:

- Database: `rtno`
- Table: `rtno.packet_window_events`

Column names match [`rtno-contracts` v1 packet window event schema](https://github.com/suryaravula1/rtno-contracts/blob/main/schemas/v1/packet-window-event.schema.json).

Migration notes live in [`clickhouse/migrations/README.md`](clickhouse/migrations/README.md).

To recreate schema from scratch:

```bash
make reset
make up
```

## What comes next

- RTNO-008: Scaffold Go simulator project
- RTNO-012: Scaffold Go collector project
- RTNO-020: Grafana dashboards in `rtno-dashboards`
