client_dir := client
server_dir := server
uv := $(shell which uv)
pnpm := $(shell which pnpm)

.PHONY: init start tests build serve clean check write

init:
	cd $(client_dir) && $(pnpm) i --frozen-lockfile
	cd $(server_dir) && $(uv) sync --frozen --all-groups

start: init
	@trap 'kill 0' EXIT; \
	(cd $(client_dir) && $(pnpm) start) & \
	(cd $(server_dir) && . .venv/bin/activate && server) & \
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

clean:
	cd $(client_dir) && rm -rf dist/ node_modules/ .tanstack/
	cd $(server_dir) && rm -f .coverage && rm -rf dist/ htmlcov/ logs/ .venv/ && find . -name "__pycache__" -type d -exec rm -rf {} +

check: init
	cd $(client_dir) && $(pnpm) eslint && $(pnpm) prettier -c .
	cd $(server_dir) && . .venv/bin/activate && ruff check --no-cache

write: init
	cd $(client_dir) && $(pnpm) eslint --fix && $(pnpm) prettier -w .
	cd $(server_dir) && . .venv/bin/activate && ruff format --no-cache
