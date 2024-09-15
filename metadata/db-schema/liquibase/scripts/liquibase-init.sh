#!/usr/bin/env bash
set -euo pipefail
sleep 15
liquibase update
echo "liquibase-init.sh: complete"
