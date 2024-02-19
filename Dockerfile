FROM node:lts-slim

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Install sudo, curl, and build-essential since it's not included in slim images by default
RUN apt-get update && apt-get install -y curl build-essential default-jre-headless apt-utils locales \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8

ENV SHELL sh
# SHELL ["/bin/bash", "-c"]

ENV LANG en_US.UTF-8
# ENV LANGUAGE en_US:en
# ENV LC_ALL en_US.UTF-8

# ENV HOME /root
ENV PATH="${HOME}/.npm/bin:${PATH}"

ENV PNPM_HOME="${HOME}/.pnpm"
RUN export PATH="${PNPM_HOME}:${HOME}/.npm/bin:${PATH}"
ENV PATH="${PNPM_HOME}:${HOME}/.npm/bin:${PATH}"


# Set npm configuration for the user and update PATH
RUN mkdir -p "${HOME}/.npm" \
    && npm config set prefix "${HOME}/.npm"

# https://pnpm.io/docker#example-2-build-multiple-docker-images-in-a-monorepo
RUN corepack enable

# RUN pnpm --help
# RUN pnpm setup

RUN npm install @openapitools/openapi-generator-cli -g
# RUN which openapi-generator-cli

# it's strange with sudo but otherwise it would exit with 1 and no explanation
RUN /root/.npm/bin/openapi-generator-cli version

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# RUN sed -i '1s|^#!/bin/sh|#!/bin/bash|' $HOME/.cargo/env
# RUN rm -rf ~/.profile

# Install typeshare-cli using Cargo
RUN /root/.cargo/bin/cargo install typeshare-cli

# https://gitlab.com/gitlab-org/gitlab-runner/-/issues/2109#note_47480476
# ENTRYPOINT ["/bin/bash", "-l", "-c"]
