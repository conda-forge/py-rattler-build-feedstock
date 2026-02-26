@echo on
set "PYO3_PYTHON=%PYTHON%"

set CARGO_PROFILE_RELEASE_STRIP=symbols

set "CMAKE_GENERATOR=NMake Makefiles"
set "MATURIN_PEP517_ARGS=--no-default-features --features=native-tls"

%PYTHON% -m pip install . -vv || exit 1

cd py-rattler-build/rust
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml || exit 1
copy THIRDPARTY.yml %SRC_DIR%\THIRDPARTY.yml || exit 1
