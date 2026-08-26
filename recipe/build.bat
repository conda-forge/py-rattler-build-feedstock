@echo on
set "PYO3_PYTHON=%PYTHON%"

set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"

REM Avoid long path issues
set CARGO_HOME=C:\.cargo
md %CARGO_HOME%
set CARGO_TARGET_DIR=C:\.ct

set CARGO_PROFILE_RELEASE_STRIP=symbols

if "%target_platform%"=="win-arm64" (
    @rem Use CMake for aws-lc-sys and clang-cl for its ARM64 assembly.
    set "AWS_LC_SYS_CMAKE_BUILDER=1"
    set "CC_aarch64_pc_windows_msvc=clang-cl.exe"
    set "CXX_aarch64_pc_windows_msvc=clang-cl.exe"
    set "ASM_aarch64_pc_windows_msvc=clang-cl.exe"
)

set "CMAKE_GENERATOR=Ninja"
set "MATURIN_PEP517_ARGS=--no-default-features --features=native-tls"

%PYTHON% -m pip install . -vv || exit 1

cd py-rattler-build/rust
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml || exit 1
copy THIRDPARTY.yml %SRC_DIR%\THIRDPARTY.yml || exit 1
