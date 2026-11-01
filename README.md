# pret-flakes

Unofficial Nix flakes and derivations for [pret](https://pret.github.io/) projects.

Each buildable output is represented by a distinct package.

No source code is contained in this repository. This repository only contains build scripting.

| Repo                                                        | Package               |
| :---------------------------------------------------------- | :-------------------- |
| [pret/pokecrystal](https://github.com/pret/pokecrystal)     | `pokecrystal`         |
| pret/pokecrystal                                            | `pokecrystal11`       |
| pret/pokecrystal                                            | `pokecrystal-au`      |
| pret/pokecrystal                                            | `pokecrystal-debug`   |
| pret/pokecrystal                                            | `pokecrystal11-debug` |
| [pret/pokegold](https://github.com/pret/pokegold)           | `pokegold`            |
| pret/pokegold                                               | `pokesilver`          |
| pret/pokegold                                               | `pokegold-debug`      |
| pret/pokegold                                               | `pokesilver-debug`    |
| [pret/pokeheartgold](https://github.com/pret/pokeheartgold) | `pokeheartgold`       |
| pret/pokeheartgold                                          | `pokesoulsilver`      |
| [pret/pokeplatinum](https://github.com/pret/pokeplatinum)   | `pokeplatinum`        |
| [pret/pokered](https://github.com/pret/pokered)             | `pokered`             |
| pret/pokered                                                | `pokeblue`            |
| pret/pokered                                                | `pokeblue-debug`      |
| [pret/pokeyellow](https://github.com/pret/pokeyellow)       | `pokeyellow`          |

The following repositories do not have a flake because their build process is not self-contained:

- [pret/pokerevo](https://github.com/pret/pokerevo)
- [pret/pokestadium](https://github.com/pret/pokestadium)
- [pret/pokestadiumgs](https://github.com/pret/pokestadiumgs)

