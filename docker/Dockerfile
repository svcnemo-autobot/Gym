# syntax=docker/dockerfile:1
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# Validation-only wrapper: retain the reviewed Gym runtime and seed the optional
# MLflow/W&B dependencies required by scripts/ci/core_unit_tests.sh.
FROM 766267172432.dkr.ecr.us-east-1.amazonaws.com/nemo-autobot/agent-sandbox@sha256:b836d2b9a78c6156ea502ed7fddaa9a0e5036e7121047cf09c3066a95861b9e3 AS release
USER root
WORKDIR /opt/nemo-gym
RUN uv venv /opt/nemo-gym/cache/core-seed && \
    UV_PROJECT_ENVIRONMENT=/opt/nemo-gym/cache/core-seed \
        uv sync --locked --extra dev --extra ray --extra telemetry --extra mlflow --extra wandb && \
    rm -rf /opt/nemo-gym/cache/core-seed && \
    chown -R 65532:65532 /opt/nemo-gym/cache/uv
USER 65532:65532
RUN export HOME=/home/nemo-runtime XDG_CACHE_HOME=/opt/nemo-gym/cache/xdg && \
    test -w "$HOME" && test -w "$XDG_CACHE_HOME" && \
    test -w "$UV_CACHE_DIR" && test -w "$PRE_COMMIT_HOME" && \
    uv venv /opt/nemo-gym/cache/core-offline-probe && \
    UV_PROJECT_ENVIRONMENT=/opt/nemo-gym/cache/core-offline-probe \
        uv sync --offline --locked --no-install-project --extra dev --extra ray --extra telemetry --extra mlflow --extra wandb && \
    /opt/nemo-gym/cache/core-offline-probe/bin/python -c "import mlflow, wandb, ray; print('CORE_OFFLINE_PROBE_PASS')" && \
    rm -rf /opt/nemo-gym/cache/core-offline-probe
USER root
