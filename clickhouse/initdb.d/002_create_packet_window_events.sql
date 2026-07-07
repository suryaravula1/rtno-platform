-- Aligned with rtno-contracts/schemas/v1/packet-window-event.schema.json
CREATE TABLE IF NOT EXISTS rtno.packet_window_events
(
    event_time DateTime64(3, 'UTC'),
    router_id String,
    interface_id String,
    region LowCardinality(String),
    packet_count UInt64,
    drop_count UInt64,
    latency_ms_p50 Float64,
    latency_ms_p95 Float64,
    jitter_ms Float64,
    protocol LowCardinality(String),
    source LowCardinality(String)
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(event_time)
ORDER BY (router_id, interface_id, event_time);
