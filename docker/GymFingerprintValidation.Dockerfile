# syntax=docker/dockerfile:1
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# Runtime-only CI host-parity extension; excluded from the product PR.
# Reuse the Session-owned image containing the 33 native offline server environments.
# Native functional:2/8 workload abf25642 completed all components; only four host-parity cases failed.
# Same-base CI job129463892742 passed all four cases on the Ubuntu runner host.
# Shell probes a3427ca8/b2e28919: sh-wrap dispatches unlike distro dash for the root-workdir guard.
# Restore Ubuntu /bin/sh dispatch; native setup still explicitly launches /bin/bash.
# DockerProvider construction needs the real docker CLI, but these cases never contact a daemon.
# Native input blob identities at f49b582a10321a8e9277bfdf9fe781bead47c73c:
# responses_api_agents/kilocode_agent/sandbox.py ccb0d6c5b9721306cd91065a2058af8fb147424c
# responses_api_agents/kilocode_agent/tests/test_bootstrap.py 88ca2b2d4dfe46ad25c51f9821a972d3f683b17f
# responses_api_agents/anyterminal_agent/app.py a1b0307a8c3cae32958f8768fd3a52ad1f424401
# responses_api_agents/anyterminal_agent/tests/test_app.py cb369e59f6c199d5c20e32345a65e99de2152ea9
# nemo_gym/sandbox/providers/docker/provider.py 77ff4f60178c120625b3a46d804d836f4835b879
# .github/workflows/unit-tests.yml 75cc074b9308494c60b72087548b1a7bceac4c3e
# nemo_gym/orchestration/server_venv.py 7e92e7f39d9ba6175d0393a4371bee10ce90938f
FROM 766267172432.dkr.ecr.us-east-1.amazonaws.com/nemo-autobot/agent-sandbox@sha256:03da4ac4ad37efaabc34358316d05cd5de1a69ebb528609bde2760631314bc71 AS native-host-parity
USER root
# Keep the distro's signed repository resolution and record its exact candidate and transaction.
# Extract only the genuine CLI from the authenticated Ubuntu package: no daemon/socket is needed.
RUN set -eux; \
    test -x /bin/dash; \
    ln -sfn dash /bin/sh; \
    test "$(readlink -f /bin/sh)" = "$(readlink -f /bin/dash)"; \
    mkdir -p /opt/nemo-gym/cache/fingerprint-host-parity /tmp/gym-docker-package; \
    apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=60 update; \
    apt-cache policy docker.io; \
    apt-get -s install --no-install-recommends docker.io; \
    version="$(apt-cache policy docker.io | awk '/Candidate:/ {print $2}')"; \
    test -n "$version"; test "$version" != '(none)'; \
    cd /tmp/gym-docker-package; \
    apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=60 download "docker.io=$version"; \
    test "$(find . -maxdepth 1 -name '*.deb' | wc -l)" -eq 1; \
    package="$(find . -maxdepth 1 -name '*.deb')"; \
    test "$(dpkg-deb -f "$package" Version)" = "$version"; \
    dpkg-deb -f "$package" Package Version Architecture > /opt/nemo-gym/cache/fingerprint-host-parity/docker-package.txt; \
    sha256sum "$package" >> /opt/nemo-gym/cache/fingerprint-host-parity/docker-package.txt; \
    dpkg-deb -x "$package" extracted; \
    install -m 0755 extracted/usr/bin/docker /usr/local/bin/docker; \
    install -m 0644 extracted/usr/share/doc/docker.io/copyright /opt/nemo-gym/cache/fingerprint-host-parity/docker-copyright; \
    /usr/local/bin/docker --version; \
    rm -rf /tmp/gym-docker-package /var/lib/apt/lists/*
USER 65532:65532
WORKDIR /opt/nemo-gym
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
assert Path('/bin/sh').resolve() == Path('/bin/dash').resolve()
assert os.environ['UV_PYTHON_INSTALL_DIR'] == '/opt/uv/python'
for name in ['HOME', 'UV_CACHE_DIR', 'UV_PYTHON_INSTALL_DIR']:
    with tempfile.NamedTemporaryFile(prefix='host-parity-', dir=os.environ[name]) as stream:
        stream.write(b'rootless native runtime write probe')
        stream.flush()
        os.fsync(stream.fileno())
root = Path.cwd()
probes = {
    'responses_api_agents/kilocode_agent': '''import subprocess,tempfile
from pathlib import Path
from responses_api_agents.kilocode_agent.sandbox import _sandbox_prepare_command
with tempfile.TemporaryDirectory() as temp:
    base=Path(temp)
    workdir=base/'task';workdir.mkdir()
    directory=base/'sessions'/'session'
    rejected=subprocess.run(['/bin/sh','-c',_sandbox_prepare_command('/',str(directory))],capture_output=True,text=True,timeout=30)
    assert rejected.returncode==1 and 'overlaps the task workdir' in rejected.stderr, rejected
    assert not directory.exists()
    accepted=subprocess.run(['/bin/sh','-c',_sandbox_prepare_command(str(workdir),str(directory))],capture_output=True,text=True,timeout=30)
    assert accepted.returncode==0 and directory.is_dir(), accepted
print('NATIVE_ROOT_REJECT_AND_DISJOINT_ACCEPT_OK')
''',
    'responses_api_agents/anyterminal_agent': '''import subprocess,tempfile
from pathlib import Path
from types import SimpleNamespace
from responses_api_agents.anyterminal_agent.app import _build_provider
from nemo_gym.sandbox.providers.docker.provider import DockerProvider
with tempfile.TemporaryDirectory() as temp:
    base=Path(temp)
    for selection in [{},{'docker':{}}]:
        params=SimpleNamespace(sandbox_provider=selection,docker_network=None,persistent_dir=base/'persistent',nemo_gym_root=Path.cwd().parents[1],agent_deps_dir=base/'deps',verifier_dir=base/'verifier')
        provider=_build_provider(params)
        assert isinstance(provider,DockerProvider)
        args=provider._create_config.extra_run_args
        assert str(params.persistent_dir)+':/trajectories_mount' in args
        assert str(params.verifier_dir)+':/logs/verifier' in args
    print(subprocess.check_output(['docker','--version'],text=True).strip())
print('NATIVE_DOCKER_PROVIDER_CONSTRUCTION_OK_NO_DAEMON_REQUESTED')
''',
}
results=[]
with tempfile.TemporaryDirectory(prefix='gym-host-parity-') as temp:
    sys.argv=['native-host-parity','+uv_cache_dir='+os.environ['UV_CACHE_DIR'],'+uv_venv_dir='+temp]
    config=get_global_config_dict()
    for name,code in probes.items():
        print('OFFLINE_NATIVE_CONSUMER_START',name,flush=True)
        log=Path(temp)/(name.replace('/','__')+'.log')
        command=setup_env_command(root/name,config,name.replace('/',r'\/'))+' && python -u -c '+shlex.quote(code)
        with log.open('w') as stream:
            proc=run_command(command,root/name,project_root=root,global_config_dict=config,stdout_target=stream,stderr_target=subprocess.STDOUT)
            try:
                status=proc.wait(timeout=600)
            except subprocess.TimeoutExpired:
                proc.kill();proc.wait();status=124
        results.append({'component':name,'exit':status})
        print('OFFLINE_NATIVE_CONSUMER_RESULT',json.dumps(results[-1]),flush=True)
        print(log.read_text()[-5000:],flush=True)
assert all(result['exit']==0 for result in results), results
print('ROOTLESS_NATIVE_HOST_PARITY_PREREQUISITES_OK',flush=True)
PYPROBE
USER root
