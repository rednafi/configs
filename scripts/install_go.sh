#!/usr/bin/env bash

# Bash strict mode
set -euo pipefail

GO_BINARY="go1.16.4.linux-amd64.tar.gz"

curl -OJL https://golang.org/dl/$GO_BINARY

sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $GO_BINARY

export PATH=$PATH:/usr/local/go/bin

go version

sudo rm -rf $GO_BINARY
