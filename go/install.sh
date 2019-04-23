#!/usr/bin/env bash

#Keep all Go packages that we want globally installed here.
go get -u github.com/golangci/golangci-lint/cmd/golangci-lint
go get -u golang.org/x/tools/cmd/gopls

echo "Golang tools installed!"
