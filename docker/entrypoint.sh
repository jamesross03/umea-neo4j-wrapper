#!/bin/bash
set -m

JAR_PATH="/app/data-umea.jar"

# Start the primary process and put it in the background
/startup/docker-entrypoint.sh neo4j &

/app/src/main/scripts/setup_umea_in_storr.sh "$JAR_PATH"

# Bring neo4j process back into the foreground
fg %1