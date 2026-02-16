#!/usr/bin/env bash
# Integration tests for stress-ng Docker image
set -euo pipefail

IMAGE="${TEST_IMAGE:?TEST_IMAGE must be set}"

echo "=== Testing image: ${IMAGE} ==="

# Test 1: Version output
echo "[1/3] Checking --version..."
docker run --rm "${IMAGE}" --version
echo "PASS"

# Test 2: CPU stress (2 workers, 5 seconds)
echo "[2/3] Running CPU stress test (5s)..."
docker run --rm "${IMAGE}" --cpu 2 --timeout 5s --metrics-brief
echo "PASS"

# Test 3: VM stress (1 worker, 32MB, 5 seconds)
echo "[3/3] Running VM stress test (5s)..."
docker run --rm "${IMAGE}" --vm 1 --vm-bytes 32M --timeout 5s --metrics-brief
echo "PASS"

echo "=== All tests passed ==="
