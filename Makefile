.DEFAULT_GOAL := help

.PHONY: help install install-dev run dev test test-cov lint format typecheck \
        docker-build docker-up docker-down docker-logs docker-ps \
        migrate migrate-new db-reset clean


install:
	pipenv install

install-dev:
	pipenv install --dev

run:
	pipenv run uvicorn app.main:app --host 0.0.0.0 --port 8000

dev:
	pipenv run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

worker:
	pipenv run celery -A app.workers worker --loglevel=info


test:
	pipenv run pytest tests/ -v

test-cov:
	pipenv run pytest tests/ -v --cov=app --cov-report=term-missing --cov-report=html


lint:
	pipenv run ruff check app/ tests/

format:
	pipenv run ruff format app/ tests/

typecheck:
	pipenv run mypy app/

check: lint typecheck


docker-build:
	docker compose -f docker/docker-compose.yml build

docker-up:
	docker compose -f docker/docker-compose.yml up -d

docker-down:
	docker compose -f docker/docker-compose.yml down

docker-logs:
	docker compose -f docker/docker-compose.yml logs -f $(s)

docker-ps:
	docker compose -f docker/docker-compose.yml ps


migrate:
	pipenv run alembic upgrade head

migrate-new:
	pipenv run alembic revision --autogenerate -m "$(m)"

db-reset:
	pipenv run alembic downgrade base && pipenv run alembic upgrade head


clean:
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .mypy_cache .ruff_cache .pytest_cache htmlcov .coverage

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'
