# Build multi-arch commands

```bash
docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/php:8.1-fpm \
  --tag bertoost/php:8.1.16-fpm \
  --target production .

docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/php:8.1.16-fpm-dev \
  --target development .
```
