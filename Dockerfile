# Use Neo4J image (5+ for cleaner commands)
FROM neo4j:5.20

# Set working directory inside the container
WORKDIR /app

# Disable Neo4J auth
ENV NEO4J_AUTH=none

# Copy source code, umea jar and entrypoint
COPY data-umea-1.0-SNAPSHOT-jar-with-dependencies.jar ./data-umea.jar
COPY src ./src
COPY docker/entrypoint.sh .

# Ports which should be bound when running
EXPOSE 7474
EXPOSE 7687

ENTRYPOINT ["./entrypoint.sh"]
