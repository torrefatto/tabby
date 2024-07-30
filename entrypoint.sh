#!/usr/bin/bash

CMDLINE=("/usr/local/bin/tabby" "serve")

export TABBY_ROOT=/tabby

if [ -z $ENABLE_TELEMETRY ]; then
    export TABBY_DISABLE_USAGE_COLLECTION=1
fi

if [ "${MODEL}" == "" ]; then
    MODEL="StarCoder-1B"
fi
CMDLINE=("${CMDLINE[@]}" "--model" "${MODEL}")

if [ "${CHAT_MODEL}" != "" ]; then
    CMDLINE=("${CMDLINE[@]}" "--chat-model" "${CHAT_MODEL}")
fi

if [ "${PORT}" != "" ]; then
    CMDLINE=("${CMDLINE[@]}" "--port" "${PORT}")
fi

CMDLINE=("${CMDLINE[@]}" "--device" "cuda")

${CMDLINE[@]}
