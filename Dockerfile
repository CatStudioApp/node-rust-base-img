FROM node:20-slim

RUN groupadd --gid 3434 ciuser \
  && useradd --uid 3434 --gid ciuser --shell /bin/bash --create-home ciuser \
  && echo 'ciuser ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-ciuser \
  && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep

USER ciuser

RUN mkdir "${HOME}/.npm" \
    && mkdir "${HOME}/.npm/lib" \
    && npm config set prefix "${HOME}/.npm"

RUN command -v pnpm || npm install -g pnpm

RUN apt-get update && apt-get install curl -y

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y


# RUN source "$HOME/.cargo/env"

RUN RUN /home/ciuser/.cargo/bin/cargo install typeshare-cli

