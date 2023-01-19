#!/usr/bin/env bash

echo "GOROOT=\"\${HOME}/tools/go\"" >> ~/.bashrc
echo "PATH=\"\${HOME}/tools/go/bin:\${GOROOT}/bin:\${PATH}\"" >> ~/.bashrc
