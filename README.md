Docker build and push
=====================

```
docker buildx build --push --platform=linux/amd64,linux/arm64 -t nledez/rundeck-cli:2.0.3 .
```
