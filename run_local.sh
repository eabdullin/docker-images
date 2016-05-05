#!/bin/bash
#
# Add this script to your repository to run your code in an
# `everware` environment on your local computer.
#
# This script starts a docker container making your repository
# available to you via your browser just like everware would.
# This is useful for running your analysis locally and testing
# if the Dockerfile you made works.
#
# This script does not build the docker image for you. You can
# do this with a command like:
#
#   docker build -t eabdullin/everware-miniconda .
#
# Then adjust the name of CONTAINER below to match the name and tag
# to match the name of the docker image you built.
#
set -e
WORKDIR=`pwd`

CONTAINER="eabdullin/everware-miniconda"

# Directory inside the container which will contain the analysis code
JUP_DIR="/home/jupyter/analysis"

# Unclear why exactly you need to run the notebook with `sh -c`
# Found this solution from ipython/ipython#7062 and ipython/docker-notebook#6
container_id=`docker run -d -v $WORKDIR:$JUP_DIR -p 8888 $CONTAINER sh -c "ipython notebook --port=8888 --ip=0.0.0.0 --no-browser --notebook-dir=$JUP_DIR"`

if hash docker-machine 2>/dev/null; then
    connect_string=`docker port $container_id 8888 | sed -e 's/0.0.0.0/'$(docker-machine ip)'/'`
elif hash boot2docker 2>/dev/null; then
    connect_string=`docker port $container_id 8888 | sed -e 's/0.0.0.0/'$(boot2docker ip)'/'`
else
    connect_string=`docker port $container_id 8888`
fi

echo "Once you are done run the following two commands to clean up:"
echo
echo "    docker stop "$container_id
echo "    docker rm "$container_id
echo
echo "To get started point your browser at: "$connect_string