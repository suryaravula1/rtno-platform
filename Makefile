.PHONY: up down logs reset ps ping verify

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

reset:
	docker compose down -v

ps:
	docker compose ps

ping:
	curl -fsS http://127.0.0.1:8123/ping
	@echo ""
	curl -fsS http://127.0.0.1:3000/api/health
	@echo ""

verify:
	docker compose exec clickhouse clickhouse-client --query "DESCRIBE TABLE rtno.packet_window_events"
