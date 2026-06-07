# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo produces `jahrik/docker-archlinux-ansible`, an Arch Linux Docker image for testing Ansible playbooks and roles with [Molecule](https://molecule.readthedocs.io/). It ships a non-root `ansible` user with passwordless sudo, a local Ansible inventory, and `yay` for AUR package access.

## Build & Push

```bash
make build          # docker build with ulimit workaround for fakeroot
make push           # push to DockerHub as jahrik/docker-archlinux-ansible:latest
```

The `--ulimit nofile=1024:524288` flag is required — without it, `fakeroot` hangs during `makepkg` ([moby/moby#27195](https://github.com/moby/moby/issues/27195)).

## CI

GitHub Actions runs on every push to `main`, every PR, and nightly. The pipeline:
1. Builds the image and verifies `ansible --version` works inside a running container.
2. On `main` only, pushes a multi-arch (`amd64` + `arm64`) image to DockerHub using `DOCKERHUB_USERNAME` / `DOCKERHUB_TOKEN` secrets.

## Image internals

- Base: `archlinux/archlinux`
- Packages installed via `pacman`: `python3`, `python-pip`, `base-devel`, `ansible`, `sudo`, `git`
- `yay` built from AUR source at image build time (left in `/tmp/yay` — cleanup is currently commented out)
- Ansible inventory at `/etc/ansible/hosts` points to `localhost` via local connection
- Default `CMD` is `systemd`, but the CI test overrides it with `tail -f /dev/null`

## Molecule usage

```yaml
platforms:
  - name: arch
    image: jahrik/docker-archlinux-ansible
    pre_build_image: true
provisioner:
  name: ansible
  inventory:
    host_vars:
      arch:
        ansible_user: ansible
```
