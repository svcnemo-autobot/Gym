# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# Runtime-only extension, excluded from the product PR.
# Native consumers at c442d05689f7b3ef7429014cf484b86f898f6a77:
# nemo_gym/cli/_locked_env.py b2551aa32b818f7e13ac3c38a8e43515964c5836
# tests/unit_tests/cli/test_locked_env.py f5941cd791256d6e2a9420e0c77a5878122ef415
# Existing caches cover the component lock; explicit-index pip seed metadata is missing.
FROM 766267172432.dkr.ecr.us-east-1.amazonaws.com/nemo-autobot/agent-sandbox@sha256:2f6c60bfa674fa83025457aae2904e3476790edb9821eb090fe9cfaacf5c6a57
USER 65532:65532
WORKDIR /opt/nemo-gym
# Match the test's literal extra-index URL, including its trailing slash.
# Preserve the native unpinned seed operation and record the resolved version.
RUN HOME=/home/nemo-runtime UV_INDEX_URL=https://pypi.org/simple/ \
    uv venv --seed --python /opt/nemo_gym_venv/bin/python /tmp/gym-explicit-pip-seed \
    && rm -rf /tmp/gym-explicit-pip-seed
# Probe the unchanged native seed operation with the test's alternate-primary shape.
# No server/network is needed offline; uv must consume the cached PyPI metadata.
RUN HOME=/home/nemo-runtime UV_INDEX_URL=http://127.0.0.1:9/ UV_EXTRA_INDEX_URL=https://pypi.org/simple/ \
    uv venv --offline --allow-existing --seed --python /opt/nemo_gym_venv/bin/python /tmp/gym-explicit-pip-probe \
    && /tmp/gym-explicit-pip-probe/bin/python -m pip --version \
    && rm -rf /tmp/gym-explicit-pip-probe
USER root
