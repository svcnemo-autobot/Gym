# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# Runtime-only extension; excluded from the product PR.
# Reuses the Session-owned core-extra cache; native inputs at c442d05689f7b3ef7429014cf484b86f898f6a77:
# responses_api_agents/simple_agent/pyproject.toml 74e18f81ff2df0da673d4a37dfada03875c8fd6c
# responses_api_agents/simple_agent/uv.lock 065a0d405d76cd517a5e7ffa82fc59f589a3872d
# nemo_gym/cli/_locked_env.py b2551aa32b818f7e13ac3c38a8e43515964c5836
# tests/unit_tests/cli/test_locked_env.py f5941cd791256d6e2a9420e0c77a5878122ef415
FROM 766267172432.dkr.ecr.us-east-1.amazonaws.com/nemo-autobot/agent-sandbox@sha256:30f7b37766cc741174149fa8ec3ae0b95d1c326cca9d480ed8d6345e55e6cc6a
USER 65532:65532
WORKDIR /opt/nemo-gym
# Match the nested locked-component installer and its uv 0.13.4 seed path.
# Preserve caches, but remove both temporary environments in this layer.
RUN HOME=/home/nemo-runtime UV_PROJECT_ENVIRONMENT=/tmp/gym-component-seed \
    uv sync --locked --project responses_api_agents/simple_agent --no-dev --inexact --extra telemetry \
    && HOME=/home/nemo-runtime uv venv --seed --python /opt/nemo_gym_venv/bin/python /tmp/gym-pip-seed \
    && rm -rf /tmp/gym-component-seed /tmp/gym-pip-seed
# Prove both operations work offline as the managed runtime user.
RUN HOME=/home/nemo-runtime UV_PROJECT_ENVIRONMENT=/tmp/gym-component-probe \
    uv sync --offline --locked --project responses_api_agents/simple_agent --no-dev --inexact --extra telemetry \
    && HOME=/home/nemo-runtime uv venv --offline --seed --python /opt/nemo_gym_venv/bin/python /tmp/gym-pip-probe \
    && HOME=/home/nemo-runtime /tmp/gym-component-probe/bin/python -c \
    'import pyarrow, aiohttp, nemo.lens; assert pyarrow.__version__ == "26.0.0"; from nemo_gym.cli._locked_env import sync_environment' \
    && /tmp/gym-pip-probe/bin/python -m pip --version \
    && test -w /home/nemo-runtime && test -w /opt/nemo-gym/cache/uv \
    && rm -rf /tmp/gym-component-probe /tmp/gym-pip-probe
USER root
