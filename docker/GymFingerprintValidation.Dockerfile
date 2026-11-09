# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0
# Runtime-only dependency cache; not part of the product PR.
# Native setup inputs at f49b582a10321a8e9277bfdf9fe781bead47c73c:
# pyproject.toml 4432400529e663b539e22fdf264ff8b74a5ccfb7
# uv.lock dc174cd39a21eb2bb0938be9ce1f5036b2ee16f1
# .python-version 0cf960df58f3c12fadffb149e0ee06bb63111f41
# scripts/ci/setup_dev.sh 1fc9d9839b03d410a3aeb7c1236a6e52b4c6a0da
# nemo_gym/cli/env.py a29b93b067b94ddca202555e8b65278a0213ffee
# nemo_gym/cli/_locked_env.py b2551aa32b818f7e13ac3c38a8e43515964c5836
# nemo_gym/orchestration/server_venv.py 7e92e7f39d9ba6175d0393a4371bee10ce90938f
# environment_servers/nemo_user_sim/pyproject.toml 7e315864329a1869b5c0c09a01975ffce09c3a74
# environment_servers/nemo_user_sim/uv.lock e4c62b4ae459fd1c379ffee78267afcb4325ffc8
# resources_servers/circle_count/pyproject.toml f0bf3205ba287c4677e1579ed17ae7fada017ace
# resources_servers/circle_count/uv.lock 64cef2479779018e1b4efa2350efd19a417f5db7
# resources_servers/gdpval/pyproject.toml 8eb149cba99ab7f1ea0211e6d8170209c85d3237
# resources_servers/gdpval/uv.lock 9b9d2f628c3fed45510682b701102c141ccda119
# resources_servers/math_formal_lean/pyproject.toml c2a093187bf48303b4acc9e00476c2691707fcbc
# resources_servers/math_formal_lean/uv.lock 03ba22792fc3a3cc6bb17e3f65a501e8bcd99093
# resources_servers/reasoning_gym/pyproject.toml 710487e9ba537b8d961791fdb7145a3aa87d7c14
# resources_servers/reasoning_gym/uv.lock b43198c36ed0b3986e55cdf110dc90105b963e9b
# resources_servers/swerl_llm_judge/pyproject.toml bc33cff78f22008ac354fc944fee6441c597c8c7
# resources_servers/swerl_llm_judge/uv.lock 8ccf0346cfbf84cf9fbf4d637cbf200984eda439
# responses_api_agents/conversational_tool_use_scenario_generation/pyproject.toml 3d51974f21170e13781d7389346191e42743ecc5
# responses_api_agents/conversational_tool_use_scenario_generation/uv.lock 29dfa3a5dae2193b062bd832e2dfe94027ce3776
# responses_api_agents/pi_sandboxed_agent/pyproject.toml 9a3073db1e98cf84c798c8d244f92d198e5382e3
# responses_api_agents/pi_sandboxed_agent/uv.lock 6a1bc2a9f2371ad72cbe4b6b286feb1c42262fd0
# responses_api_models/vllm_model_with_compaction/pyproject.toml 7b8e4833726671f104e60e658c7cfb2fef3d1d21
# responses_api_models/vllm_model_with_compaction/uv.lock fcb364ccbd0b635c905cfc39859c97c52e55fc21
# resources_servers/agentic_if_realworld/pyproject.toml 99ef6fbd0b602f816f0c9a75bd841fe951960cc9
# resources_servers/agentic_if_realworld/uv.lock dc32674e0ebc9b195b90f4691428fbe158ab21b9
# resources_servers/cvdp/pyproject.toml c4157ee935d891ae9e5c0b0cfc76a23ed7dd2805
# resources_servers/cvdp/uv.lock a79dc36c961315901c5d6ab417dd54cc2fb95d1e
# resources_servers/grl_tetris/pyproject.toml 60ad90556fdd2df43909722d450b6573d959908d
# resources_servers/grl_tetris/uv.lock a7364269a145dc9495b1bc5ffbdb7d4c3fb2a2e1
# resources_servers/mrcr/pyproject.toml fc6d3c4ada1c3ffc553780833c36d11c89f26dfe
# resources_servers/mrcr/uv.lock 0d1b2862b248a1473d6ce319921bfcefa076284d
# resources_servers/scicodepile/pyproject.toml 4a57dd8e19ddcba42df5d44f159d7798b43d3db1
# resources_servers/scicodepile/uv.lock e24872ac2dc0288d18833268b1b170e29a954a2f
# resources_servers/toolsandbox/pyproject.toml df5164ef7c1536bd42103bb6fbe607b0aa4fa9ea
# resources_servers/toolsandbox/uv.lock 3a60ad5e0873d38fe2894392dd18affec4e88259
# responses_api_agents/harbor_agent_general/pyproject.toml 7576fb908d92a4281f4dc3b4b1abfc0a81559911
# responses_api_agents/harbor_agent_general/uv.lock 87daa637631168ff4d8458fce1ad5c40f25922c9
# responses_api_agents/simple_agent/pyproject.toml 74e18f81ff2df0da673d4a37dfada03875c8fd6c
# responses_api_agents/simple_agent/uv.lock 065a0d405d76cd517a5e7ffa82fc59f589a3872d
# resources_servers/assaybench/pyproject.toml f7793e1b10a8d6834ce6f6635b484cfa0e27db30
# resources_servers/assaybench/uv.lock 23ddd0ff527354d4ca175be9a582909d83459263
# resources_servers/ether0/pyproject.toml 30de1cbe331799a5b5125864927286535a857bd5
# resources_servers/ether0/uv.lock 037e390d9391909a319c374b3049f66749cb1051
# resources_servers/imo_proofbench_judge/pyproject.toml 8113a5f8475388bc9a6fa544cd461df452c7ac18
# resources_servers/imo_proofbench_judge/uv.lock 78780688fbf88a367bea5b120c4903416d27df2d
# resources_servers/officeqa/pyproject.toml 429c710d55ffb7acbc0b60781f0dd4d4fc1de9cb
# resources_servers/officeqa/uv.lock 472030c0ff69dbab901d1f5275f3082762eccb8c
# resources_servers/string_match/pyproject.toml 06071a78607744cd134a05d1454e598189f8d0ef
# resources_servers/string_match/uv.lock 4e021b444e86daefb3466d66748f9df9cf735c69
# resources_servers/wordle/pyproject.toml 3918448de2cb4eae93eb0e232dc2f81a2f946c41
# resources_servers/wordle/uv.lock 6f89bd8a61bdb17831d23880876d07dc5a05fa0d
# responses_api_agents/kilocode_agent/pyproject.toml 3eab8b46a4b96cc15fe08451c79a1e3476a3bf68
# responses_api_agents/kilocode_agent/uv.lock 1880b2c388c76071eaf69b0d5676a4b69103f1af
# responses_api_agents/terminus_2_sandboxed_agent/pyproject.toml 4539076b357caaf2a4b81f5b939e4e6912bb6e7c
# responses_api_agents/terminus_2_sandboxed_agent/uv.lock ee23aa24a9b9be734b7f644e7b9c4b4c9d8d0412
# resources_servers/browsecomp_advanced_harness/pyproject.toml cb043b42fc3a7d7089acae6d2e988593ab729849
# resources_servers/browsecomp_advanced_harness/uv.lock f5caeecc3a1cdfaa108c03b28ccb93622ac9a8fa
# resources_servers/false_statement_judge/pyproject.toml 7703232c01937dd7ee3492dc147001c7ff748c82
# resources_servers/false_statement_judge/uv.lock 308672ca494f5b5353cc38001b39014f815a1ac2
# resources_servers/labbench2_vlm/pyproject.toml 5b43b0d0e8d69e31dc1e8b24de664eb054a81979
# resources_servers/labbench2_vlm/uv.lock 0bc0d833a7fa2c9fba9a46613067e0f453a831e3
# resources_servers/physics_judge/pyproject.toml 60f6f58370adbbe412a5406ef4997a345766ac6e
# resources_servers/physics_judge/uv.lock 4d306b20eae273ad6cdeeddf4ea2ca674c75fdd3
# resources_servers/swe_rebench/pyproject.toml 34265e7f11492d0df915a674ee0d5330aa692244
# resources_servers/swe_rebench/uv.lock 56368daec24ade3026d3e6430d54faac52e559cb
# responses_api_agents/anyterminal_agent/pyproject.toml 305b8467c192bbb179ce4dace6c0c0bb356cbcd9
# responses_api_agents/anyterminal_agent/uv.lock 81816a94039f9be768f5382891be45e966b9b4d5
# responses_api_agents/non_executing_simple_agent/pyproject.toml 51136972213b66a35811a6d5178c7f8984ad45b7
# responses_api_agents/non_executing_simple_agent/uv.lock 04c3e8a4171bc2df1aceef9b85a342479d713515
# responses_api_models/genrm_model/pyproject.toml 72b5d12c10c4648920573785bf3564d1288d9068
# responses_api_models/genrm_model/uv.lock 877636fbe515d207da29b768095e8e6a26266def
FROM 766267172432.dkr.ecr.us-east-1.amazonaws.com/nemo-autobot/agent-sandbox@sha256:b16ba15766eb33466f6bac0807779a6bdd2c3e21333b00577a3da900db749b82 AS seeded
COPY --chown=65532:65532 . /opt/nemo-gym
USER 65532:65532
WORKDIR /opt/nemo-gym
# Publish this cache stage separately; offline lazy consumers still need verification.
RUN HOME=/home/nemo-runtime UV_LINK_MODE=copy /opt/nemo_gym_venv/bin/python -u - <<'PYSEED'
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from nemo_gym.config import get_global_config_dict
from nemo_gym.orchestration.server_venv import get_venv_path, setup_env_command

assert os.getuid() == 65532
assert os.environ['UV_CACHE_DIR'] == '/opt/nemo-gym/cache/uv'
assert os.access(os.environ['UV_CACHE_DIR'], os.W_OK)
assert Path('/opt/uv/python').is_dir()
os.environ.pop('UV_OFFLINE', None)
os.environ['UV_HTTP_TIMEOUT'] = '120'
os.environ['UV_HTTP_RETRIES'] = '3'
root = Path.cwd()
selected = sorted(
    str(p) for kind in ['environment_servers', 'resources_servers', 'responses_api_agents', 'responses_api_models']
    for p in Path(kind).iterdir()
    if p.is_dir() and (p / 'README.md').exists()
    and not p.name.endswith(('.egg-info', '.dist-info')) and 'pycache' not in p.name
)[2::8]
assert len(selected) == 33
report = Path('/opt/nemo-gym/cache/fingerprint-preparation')
report.mkdir(exist_ok=True)
results = []
with tempfile.TemporaryDirectory(prefix='gym-fingerprint-seed-') as temporary:
    sys.argv = ['gym-preparation', '+uv_cache_dir=' + os.environ['UV_CACHE_DIR'], '+uv_venv_dir=' + temporary]
    config = get_global_config_dict()
    for name in selected:
        result = {'component': name}
        logfile = report / (name.replace('/', '__') + '.log')
        for attempt in range(2):
            print('NATIVE_SETUP_START', name, 'attempt', attempt + 1, flush=True)
            command = setup_env_command(root / name, config, name)
            try:
                with logfile.open('a') as stream:
                    process = subprocess.run(['bash', '-lc', command], cwd=root / name, stdout=stream, stderr=subprocess.STDOUT, timeout=600)
                result['setup_exit'] = process.returncode
            except subprocess.TimeoutExpired:
                result['setup_exit'] = 124
            if result['setup_exit'] == 0:
                break
            tail = logfile.read_text()[-8000:]
            print(tail, flush=True)
            transient = result['setup_exit'] == 124 or any(marker in tail.lower() for marker in ['timed out', 'connection reset', 'status code 429', 'status code 502', 'status code 503', 'status code 504'])
            if not transient:
                break
        shutil.rmtree(get_venv_path(root / name, config), ignore_errors=True)
        results.append(result)
        (report / 'results.json').write_text(json.dumps(results, indent=2))
        print('NATIVE_SETUP_RESULT', json.dumps(result), flush=True)
if any(row['setup_exit'] for row in results):
    raise SystemExit(1)
print('NATIVE_COMPONENT_CACHE_SEEDED_CONSUMERS_UNVALIDATED', flush=True)
PYSEED
USER root
