FROM node:20-slim

RUN command -v pnpm || npm install -g pnpm

RUN apt-get update && apt-get install curl -y

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN source "$HOME/.cargo/env"

RUN cargo install typeshare-cli

