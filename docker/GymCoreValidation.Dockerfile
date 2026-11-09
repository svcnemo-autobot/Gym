# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# Runtime-only CPU validation extension; excluded from the product PR.
# The Session-owned base retains native root and Simple Agent dependency caches.
# tests/unit_tests/agents/test_sandbox_supervisor_bootstrap.py exercises restricted PATH shells.
# Gym core CI runs on an Ubuntu host without NGC CUDA shell startup scripts.
FROM 766267172432.dkr.ecr.us-east-1.amazonaws.com/nemo-autobot/agent-sandbox@sha256:b7eff7af7040fe658c24c63a5d6c7628229c0ad8bf6e6844954dcbc944a1ed20
# These image-owned startup settings pass through ordinary OCI review, rather
# than overriding code-loading environment at launch. No test command is changed.
ENV ENV=/dev/null BASH_ENV=/dev/null
USER 65532:65532
WORKDIR /opt/nemo-gym
# The test creates a PATH containing only touch. Neither shell may emit CUDA
# initialization errors or require tools outside that PATH for a fenced launch.
RUN /opt/nemo_gym_venv/bin/python -c \
    'import os, pathlib, shutil, subprocess, tempfile; d = tempfile.TemporaryDirectory(); pathlib.Path(d.name, "touch").symlink_to(shutil.which("touch")); env = os.environ | {"PATH": d.name}; results = [subprocess.run([shell, "-c", ":"], env=env, capture_output=True, text=True) for shell in ("/bin/sh", "/bin/bash")]; assert all(r.returncode == 0 and r.stdout == r.stderr == "" for r in results), results; d.cleanup()'
USER root
