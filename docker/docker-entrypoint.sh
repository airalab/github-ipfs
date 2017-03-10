#!/bin/sh

export IPFS_PATH=/ipfs

# First init
if [ ! -f /ipfs/config ]; then
    ipfs init
    ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
    ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/80
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "GET", "POST"]'
    ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials '["true"]'
fi

export PORT=${PORT:-8000}
export REGISTRY_PATH=${REGISTRY_PATH:-/registry}
mkdir $REGISTRY_PATH

github-ipfs &

exec ipfs daemon --enable-gc
