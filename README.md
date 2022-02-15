# Arch Linux Ansible Test Image

[![Build](https://github.com/jahrik/docker-archlinux-ansible/actions/workflows/build.yml/badge.svg)](https://github.com/jahrik/docker-archlinux-ansible/actions/workflows/build.yml) [![Docker pulls](https://img.shields.io/docker/pulls/jahrik/docker-archlinux-ansible)](https://hub.docker.com/r/jahrik/docker-archlinux-ansible/)

Arch Linux Docker container for Ansible playbook and role testing.

Inspired by [Jeff Geerling](https://www.jeffgeerling.com/)

## Build

    docker build -t docker-archlinux-ansible .

## Example molecule.yml

    ---
    dependency:
      name: galaxy
    driver:
      name: docker
    platforms:
      - name: arch
        image: jahrik/docker-archlinux-ansible
        pre_build_image: true
    provisioner:
      name: ansible
    verifier:
      name: ansible
