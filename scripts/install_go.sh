#!/usr/bin/env bash

# Bash strict mode
set -euo pipefail

echo "Add the go version that you want to download."
echo "You can check it here: https://golang.org/dl/"

read go_version


GO_BINARY=$(echo go{go_version}.linux-amd64.tar.gz | sed s/{go_version}/$go_version/g)

echo $GO_BINARY

curl -OJL https://golang.org/dl/$GO_BINARY

sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $GO_BINARY

export PATH=$PATH:/usr/local/go/bin

go version

sudo rm -rf $GO_BINARY
