FROM archlinux/archlinux
LABEL maintainer="Wes Gill"

ENV pip_packages "ansible"

# Install dependencies.
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm \
      python3 \
      python-setuptools \
      python-pip \
      python-yaml \
      sudo

# Install Ansible via Pip.
RUN pip3 install $pip_packages

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
