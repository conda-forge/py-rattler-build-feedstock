#!/bin/bash

set -euxo pipefail

export CARGO_PROFILE_RELEASE_STRIP=symbols
export OPENSSL_DIR=$PREFIX
# Use cmake to build aws-lc-sys, because conda's CFLAGS inject -O2 which
# overrides the -O0 required by jitterentropy-base.c, causing a build failure.
export AWS_LC_SYS_CMAKE_BUILDER=1

# Use native-tls on conda-forge
export MATURIN_PEP517_ARGS="--no-default-features --features=native-tls"


# Run the maturin build via pip which works for direct and
# cross-compiled builds.
$PYTHON -m pip install . -vv

cd py-rattler-build/rust
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
cp THIRDPARTY.yml $SRC_DIR/THIRDPARTY.yml
