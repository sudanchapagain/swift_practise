```sh
docker run -it --rm \
  --dns=1.1.1.1 \
  --dns=8.8.8.8 \
  -v "$PWD:/workspace" \
  -w /workspace \
  swift:latest bash
```
