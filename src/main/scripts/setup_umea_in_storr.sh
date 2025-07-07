#!/usr/bin/env bash
#
# Copyright 2022 Systems Research Group, University of St Andrews:
# <https://github.com/stacs-srg>
#
# This file is adapted from the module data-umea.
#
set -e

JAR_PATH="$1"

if [ -z "$JAR_PATH" ]; then
  echo "Setup error: UMEA JAR path not provided."
  exit 1
fi

# Wait until neo4j is ready
echo "Setup: Waiting for Neo4J to be ready..."
until cypher-shell -a bolt://localhost:7687 -u neo4j -p "" "RETURN 1" >/dev/null 2>&1; do
  sleep 1
done

echo "Setup: Creating indices..."
java -cp $JAR_PATH uk.ac.standrews.cs.data.umea.store.CreateIndices

echo "Setup: Loading event records..."
java -cp $JAR_PATH uk.ac.standrews.cs.data.umea.store.ImportUmeaRecordsToStore

echo "Setup complete!"