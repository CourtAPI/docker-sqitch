# Docker Sqitch

A Docker image containing [Sqitch](https://sqitch.org/) database change management tool with support for PostgreSQL and MySQL/MariaDB.

## Building and Deploying

This repository includes a Makefile to simplify building and deploying the Docker image.

### Prerequisites

- Docker installed and running
- Docker Hub account with push access to `courtapi/docker-sqitch`
- Git repository with proper tagging

### Available Commands

```bash
# Show available commands
make help

# Show the current git tag that would be used
make tag

# Build the Docker image locally
make build

# Push the image to Docker Hub
make push

# Build and push in one command
make deploy

# Remove local Docker images
make clean
```

### Tagging Strategy

The image is automatically tagged using `git describe --tags --always --dirty`:

- If on an annotated tag: uses the tag name (e.g., `v1.0.0`)
- If commits ahead of a tag: uses tag + distance + commit hash (e.g., `v1.0.0-5-g1234567`)
- If no tags exist: uses the commit hash (e.g., `1234567`)
- If working directory is dirty: appends `-dirty`

Both the specific tag and `latest` are pushed to Docker Hub.

### Usage Example

```bash
# Tag your release
git tag -a v1.5.2 -m "Release v1.5.2"

# Build and deploy
make deploy
```

This will create and push:
- `courtapi/docker-sqitch:v1.5.2`
- `courtapi/docker-sqitch:latest`

## Using the Docker Image

```bash
# Run sqitch commands
docker run --rm -v $(pwd):/repo -w /repo courtapi/docker-sqitch sqitch status

# Interactive shell
docker run --rm -it -v $(pwd):/repo -w /repo courtapi/docker-sqitch bash
```

## Included Tools

- Sqitch v1.5.2
- PostgreSQL client (psql)
- MySQL/MariaDB client
- Perl with required database drivers
- bash, zsh, pv