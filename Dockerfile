FROM archlinux/archlinux
LABEL maintainer="Wes Gill"
ENV ANSIBLE_USER=ansible
USER root

# Install dependencies.
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm \
        python3 \
        python-setuptools \
        python-pip \
        base-devel \
        ansible \
        sudo \
        git

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Create ansible user with sudo permissions
RUN set -xe \
    && groupadd -r ${ANSIBLE_USER} \
    && useradd -m -g ${ANSIBLE_USER} ${ANSIBLE_USER} \
    && echo "${ANSIBLE_USER}  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible

USER ${ANSIBLE_USER}

# Install yay for easy package management.
RUN git clone https://aur.archlinux.org/yay.git /tmp/yay && \
    cd /tmp/yay && \
    makepkg --noconfirm -si && \
    rm -rf /tmp/yay

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
