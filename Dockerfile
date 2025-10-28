FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y openssh-server python3 sudo \
 && rm -rf /var/lib/apt/lists/*

# Usuario ansible con sudo sin contraseña
RUN useradd -ms /bin/bash ansible \
 && echo "ansible:ansible" | chpasswd \
 && adduser ansible sudo \
 && echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible \
 && chmod 0440 /etc/sudoers.d/ansible

# Habilitar login por password
RUN mkdir -p /var/run/sshd \
 && sed -ri "s/^#?PasswordAuthentication .*/PasswordAuthentication yes/" /etc/ssh/sshd_config

# Evitar problemas de tmp para Ansible
RUN mkdir -p /home/ansible/.ansible/tmp \
 && chown -R ansible:ansible /home/ansible/.ansible

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
