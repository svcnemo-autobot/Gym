# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# Runtime-only extension; never part of the product PR.
# Native inputs at c442d05689f7b3ef7429014cf484b86f898f6a77:
# nemo_gym/cli/_locked_env.py b2551aa32b818f7e13ac3c38a8e43515964c5836
# tests/unit_tests/cli/test_locked_env.py f5941cd791256d6e2a9420e0c77a5878122ef415
# pyproject.toml 4432400529e663b539e22fdf264ff8b74a5ccfb7
# uv.lock dc174cd39a21eb2bb0938be9ce1f5036b2ee16f1
# responses_api_agents/simple_agent/pyproject.toml 74e18f81ff2df0da673d4a37dfada03875c8fd6c
# responses_api_agents/simple_agent/uv.lock 065a0d405d76cd517a5e7ffa82fc59f589a3872d
FROM 766267172432.dkr.ecr.us-east-1.amazonaws.com/nemo-autobot/agent-sandbox@sha256:fac869508cb2d77d71a3734c6694e4e0082163b885de4b30e348268f331feb19
USER 65532:65532
WORKDIR /opt/nemo-gym
# Populate the complete native mirror consumer, including compatibility resolution,
# then repeat offline with a fresh venv and local primary endpoint. Keep only caches.
RUN /opt/nemo_gym_venv/bin/python -u - <<'PY'
import os
import subprocess
import sys
import tempfile
import zipfile
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from threading import Thread
from nemo_gym.cli._locked_env import INDEX_VARIABLES, sync_environment

assert os.getuid() == 65532
project = Path.cwd() / 'responses_api_agents/simple_agent'
lock = (project / 'uv.lock').read_bytes()
for offline in (False, True):
    for key in INDEX_VARIABLES:
        os.environ.pop(key, None)
    if offline:
        os.environ['UV_OFFLINE'] = '1'
    else:
        os.environ.pop('UV_OFFLINE', None)
    with tempfile.TemporaryDirectory(prefix='gym-mirror-cache-') as directory:
        root = Path(directory)
        wheel = root / 'nemo_gym_lock_provider-1.0-py3-none-any.whl'
        with zipfile.ZipFile(wheel, 'w') as archive:
            archive.writestr('lock_provider.py', 'value = 42\n')
            metadata = 'nemo_gym_lock_provider-1.0.dist-info/'
            archive.writestr(metadata + 'METADATA', 'Metadata-Version: 2.1\nName: nemo-gym-lock-provider\nVersion: 1.0\n\n')
            archive.writestr(metadata + 'WHEEL', 'Wheel-Version: 1.0\nRoot-Is-Purelib: true\nTag: py3-none-any\n\n')
            archive.writestr(metadata + 'RECORD', '')
        server = ThreadingHTTPServer(('localhost', 0), partial(SimpleHTTPRequestHandler, directory=directory))
        thread = Thread(target=server.serve_forever, daemon=True)
        thread.start()
        try:
            host, port = server.server_address
            os.environ['UV_INDEX_URL'] = f'http://{host}:{port}/'
            os.environ['UV_EXTRA_INDEX_URL'] = 'https://pypi.org/simple/'
            venv = root / 'component-venv'
            requirements = [f'nemo-gym-lock-provider @ {wheel.as_uri()}']
            print('native_mirror_start offline=', offline, flush=True)
            sync_environment(project, venv, sys.executable, requirements, [])
            site = next((venv / 'lib').glob('python*/site-packages'))
            (site / 'manual_helper.py').write_text('value = 7\n')
            sync_environment(project, venv, sys.executable, requirements, [])
            result = subprocess.check_output([str(venv / 'bin/python'), '-c', 'import lock_provider, manual_helper; print(lock_provider.value, manual_helper.value)'], text=True)
            assert result.strip() == '42 7'
            assert (project / 'uv.lock').read_bytes() == lock
            print('native_mirror_pass offline=', offline, flush=True)
        finally:
            server.shutdown()
            server.server_close()
            thread.join(timeout=5)
PY
USER root
