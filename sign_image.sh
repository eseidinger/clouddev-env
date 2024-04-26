#!/usr/bin/env bash

cosign sign --key secret/cosign.key harbor.eseidinger.de/public/cloud-tools@sha256:3871c4cf5fdfb2457dad17c658752c21d3d135d51ec535c2a7803d96cb12614f
docker pull harbor.eseidinger.de/public/cloud-tools@sha256:3871c4cf5fdfb2457dad17c658752c21d3d135d51ec535c2a7803d96cb12614f