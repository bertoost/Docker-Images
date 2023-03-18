# Build multi-arch commands

```bash
docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/nginx:1.23.3-dev \
  --target dev .

docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/nginx:1.23.3-symfony \
  --target symfony .

docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/nginx:1.23.3-symfony-dev \
  --target symfony-dev .

docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/nginx:1.23.3-craft \
  --target craft .

docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/nginx:1.23.3-modx \
  --target modx .

docker buildx build --push \
  --platform linux/arm64/v8,linux/amd64 \
  --tag bertoost/nginx:1.23.3-laravel \
  --target laravel .
```
