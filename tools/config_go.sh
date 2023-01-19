#!/usr/bin/env bash

echo "export GOROOT=\"\${HOME}/tools/go\"" >> ~/.bashrc
echo "export PATH=\"\${GOROOT}/bin:\${HOME}/go/bin:\${PATH}\"" >> ~/.bashrc
