# Arch Linux Ansible Test Image

[![Build](https://github.com/jahrik/docker-archlinux-ansible/actions/workflows/build.yml/badge.svg)](https://github.com/jahrik/docker-archlinux-ansible/actions/workflows/build.yml) [![Docker pulls](https://img.shields.io/docker/pulls/jahrik/docker-archlinux-ansible)](https://hub.docker.com/r/jahrik/docker-archlinux-ansible/)

Arch Linux Docker container for Ansible playbook and role testing.

## Build

The github workflow in this repo will build this image nightly, but if you need to build it locally, you can do so.

    docker build -t docker-archlinux-ansible .

## Usage

    docker exec -it jahrik/docker-archlinux-ansible bash

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

Has user "ansible" with password-less sudo access for testing Ansible roles as a non root user. Adjust provisioner in molecule.yml.

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

## Notes

Inspired by [Jeff Geerling](https://www.jeffgeerling.com/)
I copy pasted his [ubuntu 20.04 container](https://github.com/geerlingguy/docker-ubuntu2004-ansible) and went from there :)

