#!/bin/bash

# Script to install pyenv dependencies
# Usage: ./install_pyenv_deps.sh

# Load env variables
export DESIGNS="$(pwd)/designs"
ENVFILE=".env"

if [ -f "${ENVFILE}" ]; then
	source "${ENVFILE}"
fi

if [ -z ${CONTAINER_NAME+z} ]; then
	CONTAINER_NAME="iic-osic-tools_chipathon_xvnc_uid_"$(id -u)
fi

function docker_exec() {
    docker exec -it  --user root ${CONTAINER_NAME} "$@"
}

docker_exec sudo apt update
docker_exec sudo apt install -y libssl-dev libreadline-dev libbz2-dev libsqlite3-dev 
