FROM ubuntu:14.04

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    AVATAO_USER=user

RUN locale-gen en_US.UTF-8 \
    && dpkg --add-architecture i386 \
    && apt-get -qy update \
    && apt-get -qy dist-upgrade \
    && apt-get -qy install \
        autoconf \
        automake \
        autotools-dev \
        build-essential \
        curl \
        flex \
        g++-multilib \
        gcc-multilib \
        git \
        libc6-dev \
        libc6-dev-i386 \
        libffi-dev \
        libpam-script \
        libssl-dev \
        man-db \
        nano \
        netcat \
        openssh-server \
        psmisc \
        python-dev \
        python-flask \
        python-pip \
        python-requests \
        python-urllib3 \
        python3-dev \
        python3-flask \
        python3-pip \
        screen \
        socat \
        sqlite \
        subversion \
        sudo \
        tmux \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Set up the non-privileged user, SSH and pam-script...
# libpam-script must be installed and assumed to be configured as 'sufficient'
# thus traditional unix authentication isn't broken by our custom auth method.

RUN adduser --disabled-password ${AVATAO_USER} \
    && ssh-keygen -f /etc/ssh/ssh_user_ed25519_key -t ed25519 -N '' \
    && ssh-keygen -f /etc/ssh/ssh_user_ecdsa_key -t ecdsa -N '' \
    && ssh-keygen -f /etc/ssh/ssh_user_rsa_key -t rsa -N '' \
    && chown ${AVATAO_USER}: /etc/ssh/ssh_user_* \
    && mkdir -pm 0700 /var/run/sshd # PrivilegeSeparation as root

COPY . /

# Override with --tmpfs since docker 1.10
VOLUME ["/tmp", "/var/tmp"]
