image := "jahrik/docker-archlinux-ansible"
tag := "latest"
platforms := "linux/amd64,linux/arm64"

# Build the image locally (fakeroot hangs without a raised nofile ulimit: https://github.com/moby/moby/issues/27195)
[group('build')]
build image_name=image image_tag=tag:
    docker build --ulimit nofile=1024:524288 -t {{ image_name }}:{{ image_tag }} .

# Push the image to its default registry
[group('build')]
push image_name=image image_tag=tag:
    docker push {{ image_name }}:{{ image_tag }}

# Log in to a container registry (used by CI before release)
[group('release')]
login registry="docker.io" username="" password="":
    echo "{{ password }}" | docker login {{ registry }} -u "{{ username }}" --password-stdin

# Multi-arch build and push (used by CI release job)
[group('release')]
release tags=(image + ":" + tag):
    docker buildx build --ulimit nofile=1024:524288 --platform {{ platforms }} -t {{ tags }} --push .
