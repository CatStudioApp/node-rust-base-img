FROM node:20-slim

# Install sudo, curl, and build-essential since it's not included in slim images by default
RUN apt-get update && apt-get install -y sudo curl build-essential \
    && rm -rf /var/lib/apt/lists/*

# Check if the sudoers.d directory exists; if not, create it
RUN if [ ! -d /etc/sudoers.d ]; then mkdir /etc/sudoers.d; fi

# Add user and group with specified GID/UID, add to sudoers
RUN groupadd --gid 3434 ciuser \
    && useradd --uid 3434 --gid ciuser --shell /bin/bash --create-home ciuser \
    && echo 'ciuser ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/50-ciuser \
    && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' > /etc/sudoers.d/env_keep

ENV PATH="${HOME}/.npm/bin:${PATH}"
RUN export PATH="${HOME}/.npm/bin:${PATH}"

ENV PNPM_HOME="${HOME}/.pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# Set SHELL directive to use bash for subsequent commands
SHELL ["/bin/bash", "-c"]

ENV SHELL bash

USER ciuser

# Set npm configuration for the user and update PATH
RUN mkdir -p "${HOME}/.npm" \
    && npm config set prefix "${HOME}/.npm"

# Update PATH to include the .npm/bin directory



# https://pnpm.io/docker#example-2-build-multiple-docker-images-in-a-monorepo
RUN sudo corepack enable

RUN pnpm -v

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN pnpm install @openapitools/openapi-generator-cli -g
RUN pushd -h
RUN openapi-generator-cli -h
# Install typeshare-cli using Cargo
RUN /home/ciuser/.cargo/bin/cargo install typeshare-cli

ENTRYPOINT [ "/bin/bash" ]