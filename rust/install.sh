#!/usr/bin/env bash

if ! command -v cargo; then
    echo "Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh
    rustup component add rls rust-analysis rust-src clippy rustfmt
else
    echo "Rust already installed"
fi;

echo "Rust install complete"
