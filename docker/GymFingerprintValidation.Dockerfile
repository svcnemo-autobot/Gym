# syntax=docker/dockerfile:1
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# Runtime-only prerequisite extension; not part of the product PR.
# Probe530ce854 confirmed Node and tmux absent; selected native plugin/terminal tests use them.
# Builder PTY creation denied; the actual tmux session probe remains required in the runtime Sandbox.
# Kilo CLI remains opt-in; no model or CLI downloads added. Python sqlite3 uses stdlib.
# Base cache stage7361426f succeeded with all33 native component setups.
# Missing libraries proved in workload741de84b: libXrender.so.1, libX11.so.6, libXext.so.6.
# Labbench PIL failure was a probe defect: native tests use raw PNG bytes, not Pillow.
# Ether0 native helper source prepared at b77e0d8eb06f62c8528da72bff22d4c7fee11371.
# resources_servers/ether0/setup_ether0.py 90538b65263c77698769ea15519426227e413741
# resources_servers/ether0/app.py e1df07c86efe336fc4d9a6e4b2bc31579759033a
# resources_servers/ether0/pyproject.toml 30de1cbe331799a5b5125864927286535a857bd5
# resources_servers/ether0/uv.lock 037e390d9391909a319c374b3049f66749cb1051
# resources_servers/labbench2_vlm/prepare_data.py 61b38f8d10edcd4ad6ed4c26d6b394b34b2f8b98
# resources_servers/labbench2_vlm/tests/test_app.py e476b5b181844ce8e1842ccc17818cd75fc34071
# resources_servers/labbench2_vlm/pyproject.toml 5b43b0d0e8d69e31dc1e8b24de664eb054a81979
# resources_servers/labbench2_vlm/uv.lock 0bc0d833a7fa2c9fba9a46613067e0f453a831e3
# nemo_gym/orchestration/server_venv.py 7e92e7f39d9ba6175d0393a4371bee10ce90938f

# responses_api_agents/kilocode_agent/install_kilo_runtime.sh beffa1b619de26f3b6e191faac8ca56ad02518da
# responses_api_agents/kilocode_agent/task_environment.mjs d50c5ba28692c0a6c63c3977b202f0667eef5268
# responses_api_agents/opencode_agent/assistant_message_header.js 1964e1cfc30471a8407a1d87ad56685bf9956230
# responses_api_agents/terminus_2_sandboxed_agent/terminal.py a61a63756cba42218bd889dcc4fa05dfb03d4a91
FROM 766267172432.dkr.ecr.us-east-1.amazonaws.com/nemo-autobot/agent-sandbox@sha256:c64a20ecc9ff60e146ee5fe7c4c755975d02da054f097dae953ed12d6f22738a AS native-libraries
USER root
# Preserve the base's signed Ubuntu repository resolution rather than inventing direct-package pins.
RUN set -eux; \
    dpkg-query -W libxrender1 libx11-6 libxext6 tmux 2>/dev/null || true
RUN set -eux; \
    apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=60 update; \
    apt-get -s install --no-install-recommends libxrender1 libx11-6 libxext6 tmux; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libxrender1 libx11-6 libxext6 tmux; \
    dpkg-query -W libxrender1 libx11-6 libxext6 tmux; \
    rm -rf /var/lib/apt/lists/*
# Use the exact Node distribution/version and checksum producer used by install_kilo_runtime.sh.
RUN set -eux; \
    mkdir -p /opt/gym-node /tmp/gym-node-download; \
    cd /tmp/gym-node-download; \
    curl -fsSL --retry 3 --connect-timeout 30 --max-time 180 https://nodejs.org/dist/v22.19.0/node-v22.19.0-linux-x64.tar.gz -o node-v22.19.0-linux-x64.tar.gz; \
    curl -fsSL --retry 3 --connect-timeout 30 --max-time 180 https://nodejs.org/dist/v22.19.0/SHASUMS256.txt -o SHASUMS256.txt; \
    awk '$2 == "node-v22.19.0-linux-x64.tar.gz"' SHASUMS256.txt | sha256sum -c -; \
    tar -xzf node-v22.19.0-linux-x64.tar.gz --strip-components=1 -C /opt/gym-node; \
    ln -s /opt/gym-node/bin/node /usr/local/bin/node; \
    /usr/local/bin/node --version; \
    rm -rf /tmp/gym-node-download
USER 65532:65532
WORKDIR /opt/nemo-gym
RUN HOME=/home/nemo-runtime /opt/nemo_gym_venv/bin/python -u - <<'PYSOURCE'
import subprocess
from pathlib import Path
root = Path('/opt/nemo-gym/resources_servers/ether0/.ether0')
print('NATIVE_ETHER0_SOURCE_PREPARE_START', flush=True)
if not root.exists():
    subprocess.run(['git', 'clone', '--depth=1', 'https://github.com/Future-House/ether0', str(root)], check=True, timeout=180)
sha = subprocess.check_output(['git', '-C', str(root), 'rev-parse', 'HEAD'], text=True).strip()
assert sha == 'b77e0d8eb06f62c8528da72bff22d4c7fee11371', sha
print('NATIVE_ETHER0_SOURCE_PREPARE_OK', sha, flush=True)
PYSOURCE
RUN HOME=/home/nemo-runtime UV_OFFLINE=1 UV_LINK_MODE=copy /opt/nemo_gym_venv/bin/python -u - <<'PYPROBE'
import json
import os
import shlex
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from nemo_gym.config import get_global_config_dict
from nemo_gym.orchestration.server_venv import setup_env_command, run_command
assert os.getuid() == 65532
assert os.environ['HOME'] == '/home/nemo-runtime'
assert os.environ['UV_PYTHON_INSTALL_DIR'] == '/opt/uv/python'
assert os.access(os.environ['UV_CACHE_DIR'], os.W_OK)
root = Path.cwd()
report = root / 'cache/fingerprint-native-libraries'
report.mkdir(exist_ok=True)
probes = {
    'resources_servers/ether0': "from resources_servers.ether0.setup_ether0 import ensure_ether0,ETHER0_PATH;ensure_ether0();import subprocess;assert subprocess.check_output(['git','-C',str(ETHER0_PATH),'rev-parse','HEAD'],text=True).strip()=='b77e0d8eb06f62c8528da72bff22d4c7fee11371';import app;from ether0.rewards import EVAL_FUNCTIONS;assert EVAL_FUNCTIONS['str_eval']('CCO','CCO')==1.0;print('ETHER0_NATIVE_IMPORT_REWARD_OK')",
}
results = []
with tempfile.TemporaryDirectory(prefix='gym-native-libs-') as temp:
    sys.argv = ['native-prerequisites', '+uv_cache_dir=' + os.environ['UV_CACHE_DIR'], '+uv_venv_dir=' + temp]
    config = get_global_config_dict()
    for name, code in probes.items():
        print('OFFLINE_NATIVE_CONSUMER_START', name, flush=True)
        log = report / (name.replace('/', '__') + '.log')
        command = setup_env_command(root / name, config, name.replace('/', r'\/')) + ' && python -u -c ' + shlex.quote(code)
        with log.open('w') as stream:
            proc = run_command(command, root / name, project_root=root, global_config_dict=config, stdout_target=stream, stderr_target=subprocess.STDOUT)
            try:
                status = proc.wait(timeout=600)
            except subprocess.TimeoutExpired:
                proc.kill()
                proc.wait()
                status = 124
        results.append({'component': name, 'exit': status})
        print('OFFLINE_NATIVE_CONSUMER_RESULT', json.dumps(results[-1]), flush=True)
        print(log.read_text()[-5000:], flush=True)
        (report / 'results.json').write_text(json.dumps(results, indent=2))
with tempfile.TemporaryDirectory(prefix='gym-native-tools-') as temp:
    d = Path(temp)
    agent = root / 'responses_api_agents/kilocode_agent'
    shutil.copyfile(agent / 'task_environment.mjs', d / 'task_environment.mjs')
    shutil.copyfile(root / 'responses_api_agents/opencode_agent/assistant_message_header.js', d / 'assistant_message_header.mjs')
    (d / 'input.json').write_text('{}')
    (d / 'task-env.json').write_text(json.dumps({'HOME': str(d / 'task-home'), 'XDG_DATA_HOME': str(d / 'data'), 'XDG_CONFIG_HOME': str(d / 'config'), 'XDG_CACHE_HOME': str(d / 'cache'), 'XDG_STATE_HOME': str(d / 'state')}))
    script = "import {TaskEnvironment} from './task_environment.mjs';const hooks=await TaskEnvironment();const args={action:'start',command:'echo ready'};await hooks['tool.execute.before']({tool:'background_process'},{args});if(args.persistent!==true)throw Error('native plugin failed');console.log('NATIVE_NODE_PLUGIN_OK');"
    subprocess.run(['node', '--input-type=module', '-e', script], cwd=d, check=True, timeout=30)
    print('TMUX_RUNTIME_PTY_PROBE_REQUIRED: builder new-session returned fork Permission denied', flush=True)
shutil.rmtree(root / 'resources_servers/ether0/.ether0', ignore_errors=True)
if any(r['exit'] for r in results):
    raise SystemExit(1)
print('ROOTLESS_NATIVE_LIBRARY_CONSUMERS_OK', flush=True)
PYPROBE
USER root
