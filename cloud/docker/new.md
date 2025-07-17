# Base Image
FROM ubuntu:24.04 AS codexion

LABEL maintainer="codexion"
LABEL author="Sundar <sundar@sundar.com>"
LABEL version="1.0"
LABEL description="Codexion - Custom Ubuntu 24.04 image for ERP + FastAPI + React development"

# -------------------------
# Environment Setup
# -------------------------
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV PYENV_ROOT="/home/devops/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
ENV NVM_DIR="/home/devops/.nvm"
ENV NODE_VERSION=20.19.2

# -------------------------
# Install Base System Packages
# -------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential curl wget git sudo nano unzip ca-certificates bash-completion \
  software-properties-common net-tools iputils-ping tree less watch file rlwrap make \
  htop lsof rsync gnupg2 tar gzip zip bzip2 xz-utils \
  openssh-server openssh-client vsftpd rsync openssl \
  vim locales lsb-release cron supervisor nginx \
  mariadb-client libmariadb-dev mysql-client \
  postgresql-client libpq-dev \
  redis redis-server redis-tools \
  libssl-dev libffi-dev libpq-dev libldap2-dev libsasl2-dev \
  zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  libncursesw5-dev xz-utils tk-dev liblzma-dev \
  python3.12 python3.12-dev python3.12-venv python3-pip python3 python3-distutils \
  fonts-cantarell xfonts-75dpi xfonts-base \
  libpango-1.0-0 libharfbuzz0b libpangoft2-1.0-0 libpangocairo-1.0-0 \
  glances iftop psutils gh \
  && ln -sf /usr/bin/python3.12 /usr/bin/python3 \
  && ln -sf /usr/bin/pip3 /usr/bin/pip \
  && locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8 \
  && mkdir -p /var/run/sshd \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# -------------------------
# Create devops User
# -------------------------
RUN groupadd devops && \
    useradd -m -g devops -s /bin/bash devops && \
    echo 'devops:sundar' | chpasswd && \
    echo 'devops ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# -------------------------
# Switch to devops User
# -------------------------
USER devops
WORKDIR /home/devops

# -------------------------
# Create Workspace Directories
# -------------------------
RUN mkdir -p /home/devops/workspace /home/devops/frappe

# -------------------------
# Install pyenv + Python 3.12.3
# -------------------------
RUN git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT" && \
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv" && \
    $PYENV_ROOT/bin/pyenv install 3.12.3 && \
    $PYENV_ROOT/bin/pyenv global 3.12.3 && \
    $PYENV_ROOT/versions/3.12.3/bin/pip install --upgrade pip setuptools wheel && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# -------------------------
# Install Node.js + Yarn via NVM
# -------------------------
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    npm install -g yarn && \
    echo 'export NVM_DIR="$NVM_DIR"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \\. "$NVM_DIR/nvm.sh"' >> ~/.bashrc

# -------------------------
# Install Bench CLI
# -------------------------
RUN git clone --depth 1 -b v5.x https://github.com/frappe/bench ~/.bench && \
    $PYENV_ROOT/shims/pip install --user -e ~/.bench && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && \
    echo 'export BENCH_DEVELOPER=1' >> ~/.bashrc

# -------------------------
# Symlink bench CLI globally
# -------------------------
USER root
RUN ln -sf /home/devops/.local/bin/bench /usr/local/bin/bench

# -------------------------
# Back to devops User
# -------------------------
USER devops
WORKDIR /home/devops

# -------------------------
# Install code-server (VS Code in browser)
# -------------------------
RUN curl -fsSL https://code-server.dev/install.sh | sh

# -------------------------
# Copy Applications
# -------------------------
COPY ./cloud/backend/ /home/devops/workspace/backend
COPY ./cloud/frontend/ /home/devops/workspace/frontend
COPY ./cloud/frappe/ /home/devops/frappe

# -------------------------
# CLI Script for DevOps
# -------------------------
COPY ./cloud/backend/setup/init.sh /usr/local/bin/codexion
RUN chmod +x /usr/local/bin/codexion

# -------------------------
# Expose Ports
# -------------------------
EXPOSE 22 8000 8080 3000 8088 8888 9000 6787 21

# -------------------------
# Start supervisor for services
# -------------------------
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# -------------------------
# Set shell to bash
# -------------------------
SHELL ["/bin/bash", "-c"]
