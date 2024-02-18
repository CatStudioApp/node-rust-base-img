FROM node:20-slim

USER ci

RUN mkdir "${HOME}/.npm" \
    && mkdir "${HOME}/.npm/lib" \
    && npm config set prefix "${HOME}/.npm"

RUN command -v pnpm || npm install -g pnpm

RUN apt-get update && apt-get install curl -y

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y


# RUN source "$HOME/.cargo/env"

RUN RUN /home/ci/.cargo/bin/cargo install typeshare-cli

