#!/bin/bash

export PATH="$(pwd)/${GODIR}:${PATH}"
source <("$(pwd)/${GODIR}/go" env)

YO_OPTS=""
if [[ -n "${TEMPLATE_DIR}" ]]; then
    YO_OPTS="${YO_OPTS} --template-path ${TEMPLATE_DIR}"
fi

"${YO}" generate "${SCHEMA_FILE}" \
    --from-ddl \
    -o "${OUT}" \
    --package "${PACKAGE}" \
    --single-file \
    $YO_OPTS
