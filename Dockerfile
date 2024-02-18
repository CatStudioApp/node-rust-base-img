FROM node:20-slim

# Install sudo, curl, and build-essential since it's not included in slim images by default
RUN apt-get update && apt-get install -y sudo curl build-essential xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Check if the sudoers.d directory exists; if not, create it
RUN if [ ! -d /etc/sudoers.d ]; then mkdir /etc/sudoers.d; fi

# Add user and group with specified GID/UID, add to sudoers
RUN groupadd --gid 3434 ciuser \
    && useradd --uid 3434 --gid ciuser --shell /bin/bash --create-home ciuser \
    && echo 'ciuser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/50-ciuser \
    && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' > /etc/sudoers.d/env_keep

USER ciuser

WORKDIR /home/ciuser


# Set npm configuration for the user
RUN mkdir -p "${HOME}/.npm" \
    && npm config set prefix "${HOME}/.npm"

# Install pnpm if not already installed
RUN command -v pnpm || npm install -g pnpm

# Create a directory for the binary explicitly and set it as working directory
RUN mkdir -p "${HOME}/bin"
WORKDIR ${HOME}/bin

RUN curl -L https://github.com/1Password/typeshare/releases/download/v1.7.0/typeshare-cli-v1.7.0-x86_64-unknown-linux-gnu.tar.xz | tar -xJ -C ./


# Add the bin directory to the PATH
ENV PATH="${HOME}/bin:${PATH}"