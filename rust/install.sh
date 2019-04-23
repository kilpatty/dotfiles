if ! command -v cargo; then
    echo "Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh
else
    echo "Rust already installed"
fi;

echo "Rust install complete"
