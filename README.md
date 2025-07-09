# UMEA Neo4J Wrapper
This repository contains a portable, deployable, wrapper for a Neo4J database of the Swedish UMEA dataset. To use this container, you must have an existing JAR file of the Swedish UMEA dataset and an authorised key-pair to access it.

## 1. Prerequisites
The following tools must be installed on your system to follow this guide:
- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/), [Podman](https://podman.io/) or any other container management tool
- A valid umea-data JAR file.

## 2. Installation
Due to the requirement of providing your own JAR file for the container, you must build your own Docker image for the UMEA wrapper. 

### 2.1. Installing the repository
You will need the repository installed on your system to build the image. To install this, run the following command:

```sh
# In a terminal (Windows/macOS/Linux)
git clone https://github.com/jamesross03/umea-neo4j-wrapper.git
```

### 2.2. Installing the JAR file
To build the container, you must place your own JAR file for the UMEA dataset in the root of the repository. The [Dockerfile](./Dockerfile) assume this JAR has the following name (either modify the Dockerfile or rename the file if this is not the case):

```txt
data-umea-1.0-SNAPSHOT-jar-with-dependencies.jar
```

### 2.3. Building the Docker image
To build the image, run the following command in the root of the repository:

```sh
# In a terminal (Windows/macOS/Linux)
docker build . -t umea-neo4j-wrapper:latest
```

## 3. Running
### 3.1. Creating a Docker Network (optional)
If you intend to use the Neo4J database in conjunction with another dockerised application, for example the [population-linkage repository](https://github.com/stacs-srg/population-linkage), you will likely need to setup a Docker network to allow the second container to interact with the Neo4J database. To do this, run the following command:

```sh
# In a terminal (Windows/macOS/Linux)
docker network create umea-neo4j-net
```

Where `umea-neo4j-net` is the name of the Docker network.

To connect to this with another container, simply add the following flag when running your second container:

```sh
--network umea-neo4j-net
```

### 3.2. Running the image
To run the umea-neo4j-wrapper image, we must also mount bind a number of ports and storage locations within the container to those outside the container. To run the image, use the following command (substituting in your choice of output locations for data and logs):

```sh
# In a terminal (Windows/macOS/Linux)
docker run --rm --name umea-neo4j --network umea-neo4j-net -p 7474:7474 -p 7687:7687 -v <data_dir>:/data -v <logs_dir>:/logs  -v ~/.ssh:/root/.ssh umea-neo4j-wrapper:latest
```

Where:
- `7474` - port for HTTP connections.
- `7687` - port for Bolt connections.
- `<data_dir>` - directory to store DB data.
    - This mount can be ommitted if you do not intend for the database to persist beyond an initial run.
- `<logs_dir>` - directory containing log files for Neo4J.
    - Once again, can be ommitted if no intention to access or persist beyond initial run.
- `--rm` - instructs to remove the container files after container finishes running.
- `--network umea-neo4j-net` - makes the container accessible on the `umea-neo4j-net` Docker network.
- `--name umea-neo4j` - sets name of container to `umea-neo4j`
    - Note: If using with the [population-linkage repository](https://github.com/stacs-srg/population-linkage), this will by default expect the name to be `umea-neo4j`. If you change this, you'll need to pass the name of this container as an environment variable to the population-linkage container.
- Assumes your RSA encrypted PEM private key is installed in the default ssh directory (`~/.ssh`).