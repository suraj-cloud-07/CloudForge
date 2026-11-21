#!/usr/bin/env bash

set -Eeuo pipefail

# CloudForge local deployment script
# Usage: ./scripts/deploy-local.sh IMAGE_TAG [HOST_PORT]

IMAGE_TAG="${1:-}"
HOST_PORT="${2:-5002}"

if [[ -z "$IMAGE_TAG" ]]; then
    echo "Usage: $0 IMAGE_TAG [HOST_PORT]"
    exit 1
fi

if [[ ! "$HOST_PORT" =~ ^[0-9]+$ ]] || (( HOST_PORT < 1 || HOST_PORT > 65535 )); then
    echo "ERROR: HOST_PORT must be a valid port between 1 and 65535."
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker CLI is not installed or not in PATH."
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Cannot connect to Docker Engine."
    exit 1
fi

if ! docker image inspect "cloudforge:${IMAGE_TAG}" >/dev/null 2>&1; then
    echo "ERROR: Image cloudforge:${IMAGE_TAG} does not exist."
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "ERROR: curl is required for the host-side health check."
    exit 1
fi

SAFE_TAG="${IMAGE_TAG//[^a-zA-Z0-9_.-]/-}"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
CONTAINER_NAME="cloudforge-local-${SAFE_TAG}-${TIMESTAMP}"

if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    echo "ERROR: Container name already exists: $CONTAINER_NAME"
    exit 1
fi

if docker ps --format '{{.Ports}}' | grep -qE "127\\.0\\.0\\.1:${HOST_PORT}->"; then
    echo "ERROR: Host port ${HOST_PORT} is already in use by a Docker container."
    exit 1
fi

echo "Deploying cloudforge:${IMAGE_TAG}"
echo "Container: ${CONTAINER_NAME}"
echo "Host port: ${HOST_PORT}"

if ! docker run --detach \
    --name "$CONTAINER_NAME" \
    --publish "127.0.0.1:${HOST_PORT}:5000" \
    --memory 256m \
    --cpus 1 \
    --pids-limit 100 \
    --cap-drop ALL \
    --security-opt no-new-privileges:true \
    --read-only \
    --tmpfs /tmp:rw,noexec,nosuid,size=64m \
    --restart no \
    "cloudforge:${IMAGE_TAG}"; then

    echo "ERROR: Docker could not start the new container."
    exit 1
fi

echo "Waiting for the container health check..."

HEALTH_STATUS="starting"

for attempt in $(seq 1 30); do
    HEALTH_STATUS="$(docker inspect \
        --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}missing{{end}}' \
        "$CONTAINER_NAME")"

    if [[ "$HEALTH_STATUS" == "healthy" ]]; then
        break
    fi

    if [[ "$HEALTH_STATUS" == "unhealthy" || "$HEALTH_STATUS" == "missing" ]]; then
        break
    fi

    sleep 2
done

if [[ "$HEALTH_STATUS" != "healthy" ]]; then
    echo "ERROR: Deployment health check failed: ${HEALTH_STATUS}"
    echo "Recent container logs:"
    docker logs --tail 30 "$CONTAINER_NAME" || true
    echo "Removing only the failed candidate container..."
    docker rm --force "$CONTAINER_NAME" >/dev/null
    echo "Previous CloudForge containers and images were not modified."
    exit 1
fi

if ! curl --fail --silent --show-error \
    "http://127.0.0.1:${HOST_PORT}/health"; then

    echo
    echo "ERROR: Host-side health check failed."
    docker logs --tail 30 "$CONTAINER_NAME" || true
    echo "Removing only the failed candidate container..."
    docker rm --force "$CONTAINER_NAME" >/dev/null
    echo "Previous CloudForge containers and images were not modified."
    exit 1
fi

echo
echo "CloudForge deployment successful!"
echo "Container: ${CONTAINER_NAME}"
echo "Image: cloudforge:${IMAGE_TAG}"
echo "Application: http://127.0.0.1:${HOST_PORT}"
echo "Health: http://127.0.0.1:${HOST_PORT}/health"
echo
echo "Previous containers and images have been preserved."
