#!/usr/bin/env bash
#
# Copyright 2022 Systems Research Group, University of St Andrews:
# <https://github.com/stacs-srg>
#
# This file is adapted from the module data-umea.
#
set -e

JAR_PATH="$1"
JAVA_PID=""

# Check JAR file is present
if [ -z "$JAR_PATH" ]; then
  echo "Setup error: UMEA JAR path not provided."
  exit 1
fi

# Interrupt handlers
cleanup() {
  echo "Setup interrupted. Stopping processes..."
  if [ -n "$JAVA_PID" ] && kill -0 "$JAVA_PID" 2>/dev/null; then
    echo "Killing Java process $JAVA_PID"
    kill "$JAVA_PID"
    wait "$JAVA_PID" 2>/dev/null || true
  fi
  exit 1
}
trap cleanup SIGINT SIGTERM

# Wait until neo4j is ready
echo "Setup: Waiting for Neo4J to be ready..."
until cypher-shell -a bolt://localhost:7687 -u neo4j -p "" "RETURN 1" >/dev/null 2>&1; do
  sleep 1
done

echo "Setup: Creating indices..."
java -cp $JAR_PATH uk.ac.standrews.cs.data.umea.store.CreateIndices&
JAVA_PID=$!
wait "$JAVA_PID"
JAVA_PID="

echo "Setup: Loading event records..."
java -cp $JAR_PATH uk.ac.standrews.cs.data.umea.store.ImportUmeaRecordsToStore&
JAVA_PID=$!
wait "$JAVA_PID"
JAVA_PID="

echo "Setup complete!"