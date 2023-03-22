# Build multi-arch commands

```bash
docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/php:8.2-fpm \
  --tag bertoost/php:8.2.4-fpm \
  --target production .

docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/php:8.2-fpm-dev \
  --tag bertoost/php:8.2.4-fpm-dev \
  --target development .
```
