app_version = 0.0.0
client_dir = client
docker_dir = docker
server_dir = server

uv = $(shell which uv)
pnpm = $(shell which pnpm)
docker = $(shell which docker)

# Targets
init:
	cd $(client_dir) && $(pnpm) i --frozen-lockfile
	cd $(server_dir) && $(uv) sync --frozen --all-groups

start: init
	@trap 'kill 0' EXIT; \
	(cd $(client_dir) && $(pnpm) start) & \
	(cd $(server_dir) && . .venv/bin/activate && DEBUG=True RELOAD=True LOGS_LEVEL=DEBUG server) & \
	wait

tests: init
	cd $(server_dir) && . .venv/bin/activate && pytest

build: init
	cd $(client_dir) && $(pnpm) build
	cd $(server_dir) && $(uv) build

serve: build
	@trap 'kill 0' EXIT; \
	(cd $(client_dir) && $(pnpm) serve) & \
	(cd $(server_dir) && . .venv/bin/activate && server) & \
	wait

check: init
	cd $(client_dir) && $(pnpm) eslint && $(pnpm) prettier -c .
	cd $(server_dir) && . .venv/bin/activate && ruff check --no-cache

write: init
	cd $(client_dir) && $(pnpm) eslint --fix && $(pnpm) prettier -w .
	cd $(server_dir) && . .venv/bin/activate && ruff format --no-cache

clean:
	cd $(client_dir) && rm -rf dist/ node_modules/ .tanstack/
	cd $(server_dir) && rm -f .coverage && rm -rf dist/ htmlcov/ logs/ .venv/ && find . -name "__pycache__" -type d -exec rm -rf {} +

docker_build:
	$(docker) build -t client:$(app_version) -f docker/$(client_dir)/Dockerfile $(client_dir)
	$(docker) build -t server:$(app_version) -f docker/$(server_dir)/Dockerfile $(server_dir)

docker_serve: docker_build
	cd $(docker_dir) && docker compose up

docker_clean:
	cd $(docker_dir) && docker compose down
