FROM cimg/rust:1.78-browsers

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

RUN sudo chown -R $USER /usr/local/lib/node_modules
RUN sudo npm install @openapitools/openapi-generator-cli -g
RUN openapi-generator-cli version

RUN cargo install typeshare-cli sccache
