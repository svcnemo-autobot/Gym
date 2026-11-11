FROM python:3.11-slim
WORKDIR /w
COPY . /w/
RUN pip install --no-cache-dir --quiet "detect-secrets==1.5.0" \
 && detect-secrets scan --exclude-files 'pyproject\.toml|\.github/workflows/config/\.secrets\.baseline' --disable-plugin KeywordDetector > /tmp/new.baseline \
 && python -c "import base64; d=open('/tmp/new.baseline','rb').read(); b=base64.b64encode(d).decode(); print('BASELINE_B64_BEGIN'); [print(b[i:i+76]) for i in range(0,len(b),76)]; print('BASELINE_B64_END'); print('BYTES=%d'%len(d))"
