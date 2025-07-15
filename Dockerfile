# syntax=docker.io/docker/dockerfile:1.7-labs

FROM ubuntu:22.04

# Set non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install build chain
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    git \
    python2 \
    wget \
    curl \
    unzip \
    make \
    cmake \
    libncurses5 \
    libncurses5-dev \
    && ln -s /usr/bin/python2 /usr/bin/python \
    && apt-get clean

# Set working directory
WORKDIR /opt/parsec

# Copy the repo into the image
COPY --exclude=wrap --exclude=Dockerfile . .

# The next two lines unpack ./configure:
# Configure parsec (install deps, unpack data)
RUN bash -c "./get-inputs"

# Install the dependencies from ./configure
RUN apt-get install -y m4 x11proto-xext-dev libglu1-mesa-dev libxi-dev libxmu-dev libtbb-dev pkg-config gettext

# Source env.sh and build benchmarks
RUN bash -c "source env.sh && ./bin/parsecmgmt -a build -p all"

# Set entrypoint to enable easy invocation of parsecmgmt
ENTRYPOINT ["/bin/bash", "-c", "source env.sh && exec parsecmgmt \"$@\"", "--"]

# Example usage (from outside):
# docker build -t spirals/parsec-3.0 .
# docker run --rm spirals/parsec-3.0 -a run -p canneal -i native -n 4 -c gcc-pthreads
