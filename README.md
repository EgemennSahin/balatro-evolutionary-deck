# Evolutionary Deck

A small [Steamodded](https://github.com/Steamodded/smods) mod for Balatro. Each physical playing card earns one XP whenever it scores. XP is stored on that card in the run save.

| Scored uses | Evolution, if the slot is empty |
| --- | --- |
| 3 | Random vanilla enhancement |
| 7 | Random vanilla seal |
| 12 | Random vanilla edition |

Each threshold triggers once. Scoring displays a brief XP status using Balatro's existing card feedback. The mod has no art, custom UI, or runtime AI.

## Install

1. Install Lovely and Steamodded for your Balatro version.
2. Put this repository's folder in `%AppData%\Balatro\Mods\` on Windows. `mod.json`, `main.lua`, and `lovely.toml` should sit directly in that folder.
3. Launch Balatro and enable **Evolutionary Deck** in the Mods menu.

Score the same card repeatedly. The card should gain an enhancement on its third scored use. Debug lines are tagged `EvolutionaryDeck` in the Lovely log under `%AppData%\Balatro\Mods\lovely\log\`.

## Verification and compatibility

Locally, the mod loaded and a card reached XP 3 and gained a Mult enhancement. The seal and edition thresholds have not been observed in live play yet.

The local game was Balatro 1.0.0i with Steamodded 26.829.0 and separate compatibility adjustments to the installed Steamodded files. Those adjustments are not included here. `lovely.toml` contains small patches for that older game build. A clean install on a newer Balatro/Steamodded pairing has not been verified.
