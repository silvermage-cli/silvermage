#!/usr/bin/env sh
# Silvermage installer for Unix (Linux + macOS).
#
# Usage:
#   curl -sSf https://raw.githubusercontent.com/silvermage-cli/silvermage/main/install.sh | sh
#
# Environment overrides:
#   SILVERMAGE_VERSION     — tag to install (default: latest release)
#   SILVERMAGE_INSTALL_DIR — install directory (default: $HOME/.local/bin)
#   SILVERMAGE_NO_VERIFY   — set to any value to skip SHA256 verification
#
# Exit codes:
#   0  success
#   1  generic error (missing tool, unsupported platform, network, etc.)

set -eu

readonly REPO="silvermage-cli/silvermage"
readonly BIN_NAME="silvermage"

say() {
    printf '[silvermage] %s\n' "$1"
}

err() {
    printf '[silvermage] error: %s\n' "$1" >&2
    exit 1
}

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        err "required command '$1' not found in PATH"
    fi
}

# --- platform detection ------------------------------------------------------

detect_target() {
    local os arch
    os="$(uname -s 2>/dev/null || echo unknown)"
    arch="$(uname -m 2>/dev/null || echo unknown)"

    case "$os" in
        Linux)
            case "$arch" in
                x86_64|amd64)  echo "x86_64-unknown-linux-musl" ;;
                aarch64|arm64) echo "aarch64-unknown-linux-musl" ;;
                *) err "unsupported Linux architecture: $arch" ;;
            esac
            ;;
        Darwin)
            case "$arch" in
                x86_64)        echo "x86_64-apple-darwin" ;;
                arm64|aarch64) echo "aarch64-apple-darwin" ;;
                *) err "unsupported macOS architecture: $arch" ;;
            esac
            ;;
        *)
            err "unsupported OS: $os (this installer supports Linux and macOS; Windows users: see install.ps1)"
            ;;
    esac
}

# --- download helpers --------------------------------------------------------

download() {
    # $1 = URL, $2 = output path
    if command -v curl >/dev/null 2>&1; then
        curl -sSfL "$1" -o "$2"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$1" -O "$2"
    else
        err "neither curl nor wget is installed"
    fi
}

sha256_of() {
    # Print the SHA256 hex digest of $1 (portable across linux/macos).
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{ print $1 }'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | awk '{ print $1 }'
    else
        err "no SHA256 tool available (need sha256sum or shasum)"
    fi
}

# --- main --------------------------------------------------------------------

main() {
    require_cmd tar
    require_cmd uname

    local target version asset_url sha_url tmpdir tarball sha_file
    target="$(detect_target)"
    version="${SILVERMAGE_VERSION:-latest}"

    local install_dir
    install_dir="${SILVERMAGE_INSTALL_DIR:-$HOME/.local/bin}"

    local base_url
    if [ "$version" = "latest" ]; then
        base_url="https://github.com/${REPO}/releases/latest/download"
    else
        base_url="https://github.com/${REPO}/releases/download/${version}"
    fi

    local archive="${BIN_NAME}-${target}.tar.gz"
    asset_url="${base_url}/${archive}"
    sha_url="${asset_url}.sha256"

    say "target:   ${target}"
    say "version:  ${version}"
    say "dest:     ${install_dir}/${BIN_NAME}"

    tmpdir="$(mktemp -d 2>/dev/null || mktemp -d -t silvermage)"
    # shellcheck disable=SC2064
    trap "rm -rf '$tmpdir'" EXIT INT TERM

    tarball="${tmpdir}/${archive}"
    sha_file="${tarball}.sha256"

    say "downloading ${archive}"
    download "$asset_url" "$tarball"

    if [ -z "${SILVERMAGE_NO_VERIFY:-}" ]; then
        say "verifying checksum"
        download "$sha_url" "$sha_file"
        local expected actual
        expected="$(awk '{ print $1 }' "$sha_file")"
        actual="$(sha256_of "$tarball")"
        if [ "$expected" != "$actual" ]; then
            err "checksum mismatch — refusing to install (expected $expected, got $actual)"
        fi
    else
        say "SILVERMAGE_NO_VERIFY set — skipping checksum (not recommended)"
    fi

    say "extracting"
    tar -xzf "$tarball" -C "$tmpdir"

    # The tarball may ship the binary at its root or inside a directory.
    local src
    if [ -f "${tmpdir}/${BIN_NAME}" ]; then
        src="${tmpdir}/${BIN_NAME}"
    else
        src="$(find "$tmpdir" -type f -name "$BIN_NAME" -perm -u+x 2>/dev/null | head -n 1)"
        if [ -z "$src" ]; then
            err "binary '${BIN_NAME}' not found inside tarball"
        fi
    fi

    mkdir -p "$install_dir"
    install -m 0755 "$src" "${install_dir}/${BIN_NAME}" 2>/dev/null || {
        # `install` isn't on every minimal image; fall back to cp+chmod.
        cp "$src" "${install_dir}/${BIN_NAME}"
        chmod 0755 "${install_dir}/${BIN_NAME}"
    }

    say "installed: ${install_dir}/${BIN_NAME}"

    case ":${PATH}:" in
        *":${install_dir}:"*) ;;
        *)
            printf '\n'
            say "note: ${install_dir} is not on your PATH"
            say "      add this to your shell profile:"
            printf '\n        export PATH="%s:$PATH"\n\n' "$install_dir"
            ;;
    esac

    say "run '${BIN_NAME} --help' to get started"
}

main "$@"
