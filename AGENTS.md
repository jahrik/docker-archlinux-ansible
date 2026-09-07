# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Purpose

Produces `jahrik/docker-archlinux-ansible` — an Arch Linux Docker image for testing Ansible roles with [Molecule](https://molecule.readthedocs.io/). Ships a non-root `ansible` user with passwordless sudo, a local Ansible inventory, and `yay` for AUR package access.

## Build & Push

```bash
just build   # build locally (requires the --ulimit workaround for fakeroot)
just push    # push to DockerHub as jahrik/docker-archlinux-ansible:latest
```

The `--ulimit nofile=1024:524288` flag is required — without it, `fakeroot` hangs during `makepkg` ([moby/moby#27195](https://github.com/moby/moby/issues/27195)).

## CI

GitHub Actions runs on every push to `main`, every PR, and nightly (`0 0 * * *`). Pipeline:
1. Builds the image and verifies `ansible --version` inside a running container.
2. On `main` only, pushes a multi-arch (`amd64` + `arm64`) image to DockerHub using `DOCKERHUB_USERNAME` / `DOCKERHUB_TOKEN` secrets.

## Image internals

- Base: `archlinux/archlinux`
- Packages via `pacman`: `python3`, `python-pip`, `python-setuptools`, `base-devel`, `ansible`, `sudo`, `git`
- The Arch `ansible` pacman package bundles `community.general` (and other collections) — no separate `ansible-galaxy install` needed
- `yay` built from AUR source at image build time and source cleaned up after
- Ansible inventory at `/etc/ansible/hosts` → `localhost` via local connection
- Default `CMD` is `systemd`; CI test overrides with `tail -f /dev/null`

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

Roles using `community.general.pacman` still need `molecule/default/requirements.yml` to install the collection on the **Molecule controller** (e.g. the `gofrolist/molecule` CI container). The collection being present in this image only matters for running playbooks directly inside the container — it does not help the controller that drives the test.
