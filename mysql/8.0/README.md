# Build multi-arch commands

```bash
docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/mysql:8.0 \
  --tag bertoost/mysql:8.0.32 \
  .
```
