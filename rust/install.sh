#!/usr/bin/env bash

if ! command -v cargo; then
    echo "Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh
    rustup component add rls rust-analysis rust-src clippy rustfmt
    # TODO need to figure out a way to manage these better.
    cargo install cargo-watch
    cargo install cargo-release
    # TODO ANOTHER>>>> Really need to figure this out today.
    #probably bake this into Rust in Dot. Maybe have a "Globals" section.
    cargo install --force cargo-make
    cargo install cargo-udeps --locked
    cargo install --version=0.2.0 sqlx-cli
else
    echo "Rust already installed"
fi;

echo "Rust install complete"
