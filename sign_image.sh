#!/usr/bin/env bash

cosign sign --key secret/cosign.key harbor.eseidinger.de/public/cloud-tools@sha256:c4fa3c447cf489522a91908ea3a1c36e556a518b5f1d36a8e3f5b48338224a45
cosign sign --key secret/cosign.key harbor.eseidinger.de/public/cloud-tools@sha256:00dcc32cdfd41c4f833da37dadaa25882b3beba15a1319bfd4f5d969d49738e2
cosign sign --key secret/cosign.key harbor.eseidinger.de/public/cloud-tools@sha256:01b865b954a201584f46fa01542a7dace163388000ebf8628fb4b45ca98a3e79
