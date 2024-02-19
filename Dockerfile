FROM node:20-bullseye

# Install sudo, curl, and build-essential since it's not included in slim images by default
RUN apt-get update && apt-get install -y sudo curl build-essential openjdk-17-jre-headless apt-utils locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

# Check if the sudoers.d directory exists; if not, create it
RUN if [ ! -d /etc/sudoers.d ]; then mkdir /etc/sudoers.d; fi

# Add user and group with specified GID/UID, add to sudoers
RUN groupadd --gid 3434 ciuser \
    && useradd --uid 3434 --gid ciuser --shell /bin/bash --create-home ciuser \
    && echo 'ciuser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/50-ciuser \
    && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' > /etc/sudoers.d/env_keep

ENV SHELL bash
# Set SHELL directive to use bash for subsequent commands
SHELL ["/bin/bash", "-c"]

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV HOME /home/ciuser
ENV PATH="${HOME}/.npm/bin:${PATH}"

ENV PNPM_HOME="${HOME}/.pnpm"
RUN export PATH="${PNPM_HOME}:${HOME}/.npm/bin:${PATH}"
ENV PATH="${PNPM_HOME}:${HOME}/.npm/bin:${PATH}"


USER ciuser

# Set npm configuration for the user and update PATH
RUN mkdir -p "${HOME}/.npm" \
    && npm config set prefix "${HOME}/.npm"

# https://pnpm.io/docker#example-2-build-multiple-docker-images-in-a-monorepo
RUN sudo corepack enable

RUN pnpm setup

RUN npm install @openapitools/openapi-generator-cli -g
RUN which openapi-generator-cli

# it's strange with sudo but otherwise it would exit with 1 and no explanation
RUN sudo /home/ciuser/.npm/bin/openapi-generator-cli version

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

RUN sed -i '1s|^#!/bin/sh|#!/bin/bash|' $HOME/.cargo/env
RUN rm -rf ~/.profile

# Install typeshare-cli using Cargo
RUN /home/ciuser/.cargo/bin/cargo install typeshare-cli

# https://gitlab.com/gitlab-org/gitlab-runner/-/issues/2109#note_47480476
# ENTRYPOINT ["/bin/bash", "-l", "-c"]
