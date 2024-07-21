FROM cimg/rust:1.79-browsers

RUN rustup --version; \
    cargo --version; \
    rustc --version; 

RUN rustup update; \
    rustup target add wasm32-unknown-unknown; \
    cargo install cargo-insta; \
    cargo install wasm-pack; \
    rustup component add clippy; \
    corepack enable --install-directory ~/bin

RUN mkdir /home/circleci/store; \
    pnpm config set store-dir /home/circleci/store

# RUN pnpm setup

RUN pnpm config set script-shell /bin/bash

RUN sudo chown -R circleci /usr/local/lib/node_modules
RUN sudo npm install @openapitools/openapi-generator-cli -g
RUN openapi-generator-cli version

RUN cargo install sccache
RUN curl --proto '=https' --tlsv1.2 -LsSf https://github.com/1Password/typeshare/releases/download/v1.9.2/typeshare-cli-v1.9.2-installer.sh | sh
