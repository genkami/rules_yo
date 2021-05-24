#!/bin/bash

export PATH="$(pwd)/${GODIR}:${PATH}"
source <("$(pwd)/${GODIR}/go" env)
"${YO}" generate "${SCHEMA_FILE}" \
    --from-ddl \
    -o "${OUT}" \
    --package "${PACKAGE}" \
    --single-file
