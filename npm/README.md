# Build multi-arch commands

```bash
docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/npm:19.7 \
  .
```
