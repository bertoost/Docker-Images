# Build images

To build the images, based on the configuration, and overwrite used tags, use the build script, like;

```
sh scripts/build.sh <path to Dockerfile> [options]
```

Option    | Description
--------- | ------------------------------
`--build` | To trigger building the image
`--push`  | To trigger pushing the image

__Example usage__

Just build images

```bash
sh scripts/build.sh stack/php/7.3/Dockerfile.fpm --build
```

This will build the image `{username}/php:7.3-fpm`
Using a path is possible too;

```bash
sh scripts/build.sh stack/php/7.3 --build
```

This will scan the directory for any `Dockerfile*`'s and will ask you to continue or not.

## Pushing images

Before you can push images, you have to login in Docker. This can be achieved by using `docker login`. Even on your own registry.

## Change vendor name

If you want to change my name into your own you can easily configure it in the projects root `.env` file like this;

```bash
DOCKER_USERNAME=yourname
```