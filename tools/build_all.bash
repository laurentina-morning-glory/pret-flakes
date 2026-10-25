#!/usr/bin/env bash

set -e

nix-build() {
	nix build --no-link --quiet --print-out-paths "$@"
}

installables=(

	'.#metroskrew'
	'.#mw-libraries'
	'.#rgbds'

	'.#pokegold'
	'.#pokesilver'
	'.#pokegold-debug'
	'.#pokesilver-debug'

	'.#pokeheartgold'
	'.#pokesoulsilver'

	'.#pokeplatinum'

	'.#pokered'
	'.#pokeblue'
	'.#pokeblue-debug'

	'.#pokeyellow'
	'.#pokeyellow-debug'

);

nix-build ${installables[@]}
