#!/usr/bin/env bash

set -Eeuo pipefail

# CloudForge blue-green deployment with rollback protection
# Usage: ./scripts/deploy-with-rollback.sh CANDIDATE_TAG ROLLBACK_PORT CANDIDATE_PORT

CANDIDATE_TAG="${1:-}"
ROLLBACK_PORT="${2:-}"
CANDIDATE_PORT="${3:-}"

if [[ -z "$CANDIDATE_TAG" || -z "$ROLLBACK_PORT" || -z "$CANDIDATE_PORT" ]]; then
    echo "Usage: $0 CANDIDATE_TAG ROLLBACK_PORT CANDIDATE_PORT"
    exit 1
fi

for COMMAND in docker curl ss grep; do
    if ! command -v "$COMMAND" >/dev/null 2>&1; then
        echo "ERROR: Required command is missing: $COMMAND"
        exit 1
    fi
done

for PORT in "$ROLLBACK_PORT" "$CANDIDATE_PORT"; do
    if [[ ! "$PORT" =~ ^[0-9]+$ ]] || (( PORT < 1 || PORT > 65535 )); then
        echo "ERROR: Invalid port: $PORT"
        exit 1
    fi
done

if [[ "$ROLLBACK_PORT" == "$CANDIDATE_PORT" ]]; then
    echo "ERROR: Rollback and candidate ports must be different."
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Cannot connect to Docker Engine."
    exit 1
fi

if ! docker image inspect "cloudforge:${CANDIDATE_TAG}" >/dev/null 2>&1; then
    echo "ERROR: Candidate image cloudforge:${CANDIDATE_TAG} does not exist."
    exit 1
fi

ROLLBACK_URL="http://127.0.0.1:${ROLLBACK_PORT}"
CANDIDATE_URL="http://127.0.0.1:${CANDIDATE_PORT}"

if ! curl --connect-timeout 2 --max-time 5 --fail --silent "$ROLLBACK_URL/health" >/dev/null; then
    echo "ERROR: Rollback version is not healthy."
    echo "Refusing deployment to protect the working version."
    exit 1
fi

if ss -H -ltn "sport = :${CANDIDATE_PORT}" | grep -q .; then
    echo "ERROR: Candidate port ${CANDIDATE_PORT} is already in use."
    exit 1
fi

SAFE_TAG="${CANDIDATE_TAG//[^a-zA-Z0-9_.-]/-}"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
CONTAINER_NAME="cloudforge-candidate-${SAFE_TAG}-${TIMESTAMP}"

DEPLOYMENT_SUCCESS=0
CANDIDATE_CREATED=0

cleanup_candidate() {
    local exit_code=$?
    trap - EXIT

    if [[ "$CANDIDATE_CREATED" == 1 && "$DEPLOYMENT_SUCCESS" != 1 ]] &&
       docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
        echo
        echo "INTERRUPTION/FAILURE: Cleaning up candidate container only."
        docker rm --force "$CONTAINER_NAME" >/dev/null ||
            echo "WARNING: Could not remove candidate container."
    fi

    exit "$exit_code"
}

trap cleanup_candidate EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

echo "Known-good rollback endpoint: ${ROLLBACK_URL}"
echo "Deploying candidate: cloudforge:${CANDIDATE_TAG}"
echo "Candidate endpoint: ${CANDIDATE_URL}"

docker run --detach \
    --name "$CONTAINER_NAME" \
    --publish "127.0.0.1:${CANDIDATE_PORT}:5000" \
    --memory 256m \
    --cpus 1 \
    --pids-limit 100 \
    --cap-drop ALL \
    --security-opt no-new-privileges:true \
    --read-only \
    --tmpfs /tmp:rw,noexec,nosuid,size=64m \
    --restart no \
    "cloudforge:${CANDIDATE_TAG}"

CANDIDATE_CREATED=1

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

if [[ "$HEALTH_STATUS" == "healthy" ]] &&
   curl --connect-timeout 2 --max-time 5 --fail --silent "$CANDIDATE_URL/health" >/dev/null; then

    DEPLOYMENT_SUCCESS=1

    echo "SUCCESS: Candidate deployment is healthy."
    echo "Candidate container: ${CONTAINER_NAME}"
    echo "Candidate URL: ${CANDIDATE_URL}"
    echo "Rollback version remains available at: ${ROLLBACK_URL}"
    exit 0
fi

echo "FAILURE: Candidate deployment did not pass health checks."
echo "Removing only candidate container: ${CONTAINER_NAME}"

docker rm --force "$CONTAINER_NAME" >/dev/null

if curl --connect-timeout 2 --max-time 5 --fail --silent "$ROLLBACK_URL/health" >/dev/null; then
    echo "ROLLBACK PROTECTION: Previous version remains healthy."
    echo "Rollback URL: ${ROLLBACK_URL}"
else
    echo "CRITICAL: Rollback endpoint is no longer healthy."
    exit 2
fi

exit 1
