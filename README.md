# full-stack template

Yet another template.

## Setup

Install the dependencies.

```bash
make init
```

## Usage

### Development

Start the application in development mode.

```bash
make start
```

Run the tests.

```bash
make tests
```

### Production

Build the application for production.

```bash
make build
```

Start the application in production mode.

```bash
make serve
```

### Deployment

Build the docker images.

```bash
make docker_build
```

Start the deployment.

```bash
make docker_serve
```

Clean the deployment.

```bash
make docker_clean
```

## Miscellaneous

Lint the codebase.

```bash
make check
```

Format the codebase.

```bash
make write
```

Clean the application.

```bash
make clean
```
