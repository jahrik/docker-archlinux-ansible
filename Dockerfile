FROM archlinux/archlinux
LABEL maintainer="Wes Gill"

ENV PIP_PACKAGES "ansible"

# Install dependencies.
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm \
      python3 \
      python-setuptools \
      python-pip \
      python-yaml \
      build-devel \
      sudo \
      git

# Install Ansible via Pip.
RUN pip3 install $PIP_PACKAGES

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Create ansible user with sudo permissions
ENV ANSIBLE_USER=ansible
RUN set -xe \
  && groupadd -r ${ANSIBLE_USER} \
  && useradd -m -g ${ANSIBLE_USER} ${ANSIBLE_USER} \
  && echo "${ANSIBLE_USER}  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
