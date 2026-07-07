# ClickHouse migrations

SQL init scripts in [`initdb.d/`](initdb.d/) run automatically on first ClickHouse container startup when the data volume is empty.

## v1 schema

| Migration | Table | Contract |
|---|---|---|
| `002_create_packet_window_events.sql` | `rtno.packet_window_events` | [`rtno-contracts` packet window event v1](https://github.com/suryaravula1/rtno-contracts/blob/main/schemas/v1/packet-window-event.schema.json) |

## Column mapping

| Contract field | ClickHouse column | Type |
|---|---|---|
| `event_time` | `event_time` | `DateTime64(3, 'UTC')` |
| `router_id` | `router_id` | `String` |
| `interface_id` | `interface_id` | `String` |
| `region` | `region` | `LowCardinality(String)` |
| `packet_count` | `packet_count` | `UInt64` |
| `drop_count` | `drop_count` | `UInt64` |
| `latency_ms_p50` | `latency_ms_p50` | `Float64` |
| `latency_ms_p95` | `latency_ms_p95` | `Float64` |
| `jitter_ms` | `jitter_ms` | `Float64` |
| `protocol` | `protocol` | `LowCardinality(String)` |
| `source` | `source` | `LowCardinality(String)` |

## Reset local schema

To rerun init scripts from scratch:

```bash
docker compose down -v
docker compose up -d
```

This removes ClickHouse data volumes and reapplies init SQL on the next boot.
