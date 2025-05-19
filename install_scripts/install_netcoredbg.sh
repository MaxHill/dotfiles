#!/bin/bash

set -e

# -------- CONFIG --------
REPO_URL="https://github.com/Samsung/netcoredbg.git"
CLONE_DIR="/tmp/netcoredbg"
BUILD_DIR="$CLONE_DIR/build"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="netcoredbg"

# -------- FUNCTIONS --------

function install_prerequisites() {
    echo "🔧 Installing prerequisites using Homebrew..."
    if ! command -v brew &>/dev/null; then
        echo "❌ Homebrew is not installed. Please install it from https://brew.sh/"
        exit 1
    fi

    brew update
    brew install cmake git
}

function clone_repo() {
    echo "📥 Cloning NetCoreDbg repository into $CLONE_DIR..."
    rm -rf "$CLONE_DIR"
    git clone --recursive "$REPO_URL" "$CLONE_DIR"
}


function patch_cmakelists() {
    echo "🩹 Patching CMakeLists.txt for CMake 4 compatibility..."

    # Patch main CMakeLists
    sed -i '' 's/cmake_minimum_required(VERSION .*)/cmake_minimum_required(VERSION 3.5)/' "$CLONE_DIR/CMakeLists.txt"

    # Patch third_party/linenoise-ng
    sed -i '' 's/cmake_minimum_required(VERSION .*)/cmake_minimum_required(VERSION 3.5)/' \
        "$CLONE_DIR/third_party/linenoise-ng/CMakeLists.txt"
}

function build_netcoredbg() {
    echo "⚙️ Building NetCoreDbg..."
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"
    CC=clang CXX=clang++ cmake .. -DCMAKE_INSTALL_PREFIX="$BUILD_DIR/output"
    make -j$(sysctl -n hw.logicalcpu)
    make install
}

function move_binary() {
    echo "🚚 Installing NetCoreDbg to $INSTALL_DIR..."

    BIN_PATH=$(find "$BUILD_DIR" -type f -name netcoredbg | head -n 1)
    SHIM_PATH=$(find "$BUILD_DIR" -type f -name libdbgshim.dylib | head -n 1)

    if [[ -z "$BIN_PATH" ]]; then
        echo "❌ NetCoreDbg binary not found."
        exit 1
    fi

    cp "$BIN_PATH" "$INSTALL_DIR/$BINARY_NAME"
    chmod +x "$INSTALL_DIR/$BINARY_NAME"

    if [[ -n "$SHIM_PATH" ]]; then
        echo "📦 Installing libdbgshim.dylib..."
        cp "$SHIM_PATH" "$INSTALL_DIR/"
    else
        echo "⚠️ libdbgshim.dylib not found — NetCoreDbg may not run properly."
    fi
}

function verify_install() {
    echo "🔎 Verifying installation..."
    "$INSTALL_DIR/$BINARY_NAME" --version || {
        echo "❌ Something went wrong. NetCoreDbg not found at $INSTALL_DIR/$BINARY_NAME"
        exit 1
    }
}

# -------- MAIN --------

# install_prerequisites
# clone_repo
# patch_cmakelists
# build_netcoredbg
move_binary
verify_install

echo "✅ NetCoreDbg installed successfully to $INSTALL_DIR/$BINARY_NAME"
