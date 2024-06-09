#!/usr/bin/env bash

cosign sign --key secret/cosign.key harbor.eseidinger.de/public/cloud-tools@sha256:2617d1b76825ef75f6549f0d4e950edfdf78718405ae2ac469ee5e0d308896ec
cosign sign --key secret/cosign.key harbor.eseidinger.de/public/cloud-tools@sha256:e62f082f4f8c98112aa6d7022481c75138b77c4d3cb912a57a97c3b62bd97f0b
cosign sign --key secret/cosign.key harbor.eseidinger.de/public/cloud-tools@sha256:586c59360ea7c03729ca2f4e6b01d65ffe0c226c6c064aa28e60685c77386a55
