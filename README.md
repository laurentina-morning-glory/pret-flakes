# pret-flakes

Unofficial Nix flakes and derivations for [pret](https://pret.github.io/) projects.

Each buildable output is represented by a distinct package.

No source code is contained in this repository. This repository only contains build scripting.

| Repo                                                        | Package                           |
| :---------------------------------------------------------- | :-------------------------------- |
| [pret/pokecrystal](https://github.com/pret/pokecrystal)     | `pokecrystal11`                   |
| [pret/pokegold](https://github.com/pret/pokegold)           | `pokegold`, `pokesilver`          |
| [pret/pokeheartgold](https://github.com/pret/pokeheartgold) | `pokeheartgold`, `pokesoulsilver` |
| [pret/pokepinball](https://github.com/pret/pokepinball)     | `pokepinball`                     |
| [pret/pokeplatinum](https://github.com/pret/pokeplatinum)   | `pokeplatinum`                    |
| [pret/pokered](https://github.com/pret/pokered)             | `pokered`, `pokeblue`             |
| [pret/pokeruby](https://github.com/pret/pokeruby)           | `ruby-rev2`, `sapphire-rev2`      |
| [pret/poketcg](https://github.com/pret/poketcg)             | `poketcg`                         |
| [pret/poketcg2](https://github.com/pret/poketcg2)           | `poketcg2`                        |
| [pret/pokeyellow](https://github.com/pret/pokeyellow)       | `pokeyellow`                      |

This table is not exhaustive. Use `nix flake show` to see all packages.

The following repositories do not have a flake because their build process is not self-contained at the time of writing:

- [pret/pokepuzzle](https://github.com/pret/pokepuzzle)
- [pret/pokerevo](https://github.com/pret/pokerevo)
- [pret/pokestadiumgs](https://github.com/pret/pokestadiumgs)
- [pret/pokestadium](https://github.com/pret/pokestadium)

