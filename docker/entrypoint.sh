#!/bin/bash
set -euo pipefail

JAR_PATH="/app/data-umea.jar"
NEO4J_CMD="/startup/docker-entrypoint.sh neo4j"

# Add shutdown handlers
cleanup() {
  echo "Shutting down processes..."
  kill "$NEO4J_PID" 2>/dev/null || true
  wait "$NEO4J_PID"
  exit
}

trap cleanup SIGINT SIGTERM

# Start Neo4J in the background
/startup/docker-entrypoint.sh neo4j &
NEO4J_PID=$!

# Run setup script in foreground
/app/src/main/scripts/setup_umea_in_storr.sh "$JAR_PATH"

# Wait for Neo4J to exit or SIGINT
wait "$NEO4J_PID"