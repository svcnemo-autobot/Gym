# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# Runtime-only validation extension; excluded from the product PR.
# Native inputs at c442d05689f7b3ef7429014cf484b86f898f6a77:
# pyproject.toml 4432400529e663b539e22fdf264ff8b74a5ccfb7
# uv.lock dc174cd39a21eb2bb0938be9ce1f5036b2ee16f1
# .python-version 0cf960df58f3c12fadffb149e0ee06bb63111f41
# scripts/ci/core_unit_tests.sh 8d19aa17c43ea1adfd2f23f6f6463ee0c388b19b
# scripts/ci/setup_dev.sh 1fc9d9839b03d410a3aeb7c1236a6e52b4c6a0da
FROM 766267172432.dkr.ecr.us-east-1.amazonaws.com/gym@sha256:1273aca5f51ab8961f59e429deab4da5e83ad36d9fc73a671a5a4b5a2522a45f
USER 65532:65532
WORKDIR /opt/nemo-gym
# Seed the exact native core extras, including their build-isolation inputs, into
# the persistent cache. The temporary environment is removed in this same layer.
RUN HOME=/home/nemo-runtime UV_PROJECT_ENVIRONMENT=/tmp/gym-core-seed \
    uv sync --locked --extra dev --extra ray --extra telemetry --extra mlflow --extra wandb \
    && rm -rf /tmp/gym-core-seed
# A new offline environment must resolve and import the real consumers as the
# runtime user, not merely find wheel files in a root-owned build cache.
RUN HOME=/home/nemo-runtime UV_PROJECT_ENVIRONMENT=/tmp/gym-core-probe \
    uv sync --offline --locked --extra dev --extra ray --extra telemetry --extra mlflow --extra wandb \
    && HOME=/home/nemo-runtime /tmp/gym-core-probe/bin/python -c \
    'import aiohttp, mlflow, wandb, ray, nemo.lens; from nemo_gym.client.openai_client import NeMoGymAsyncOpenAI; from nemo_gym.core.failure_transport import RequestFailureLog; NeMoGymAsyncOpenAI(api_key="test", base_url="http://model.test")' \
    && test -w /home/nemo-runtime && test -w /opt/nemo-gym/cache/uv \
    && touch /opt/nemo-gym/cache/uv/.core-validation-write-probe \
    && rm /opt/nemo-gym/cache/uv/.core-validation-write-probe \
    && rm -rf /tmp/gym-core-probe
# Preserve the published base's default user; the managed profile selects UID 65532.
USER root
