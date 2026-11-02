#!/usr/bin/env bash

set -e

nix-build() {
	nix build --no-link --quiet --print-out-paths "$@"
}

installables=(

	'.#metroskrew'
	'.#rgbds'
	'.#mw-libraries-all'

	'.#pokecrystal'
	'.#pokecrystal11'
	'.#pokecrystal-au'
	'.#pokecrystal-debug'
	'.#pokecrystal11-debug'

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

	'.#poketcg'

	'.#poketcg2'

	'.#pokeyellow'
	'.#pokeyellow-debug'

	'.#ruby-sapphire-all'

);

nix-build ${installables[@]}
