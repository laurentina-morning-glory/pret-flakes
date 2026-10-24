#!/usr/bin/env bash

set -e

nix-build() {
	nix build --no-link --quiet --print-out-paths "$@"
}

pushd pokeheartgold >/dev/null
nix-build
nix-build '.#pokesoulsilver'
popd >/dev/null

pushd pokeplatinum >/dev/null
nix-build
popd >/dev/null

pushd pokered >/dev/null
nix-build
nix-build '.#pokeblue'
nix-build '.#pokeblue-debug'
popd >/dev/null
