# Evolutionary Deck

A small [Steamodded](https://github.com/Steamodded/smods) mod for Balatro. Each physical playing card earns one XP whenever it scores. XP is stored on that card in the run save.

| Scored uses | Evolution, if the slot is empty |
| --- | --- |
| 3 | Random vanilla enhancement |
| 7 | Random vanilla seal |
| 12 | Random vanilla edition |

Each threshold triggers once. Evolution uses SMODS seeded polls and normal card setters.

## Install

1. Install Lovely and Steamodded for your Balatro version.
2. Put this repository's folder in `%AppData%\Balatro\Mods\` on Windows. Keep `mod.json`, `main.lua`, and `lovely.toml` directly inside the folder.
3. Launch Balatro and enable **Evolutionary Deck** in the Mods menu.
4. Score the same card repeatedly. Debug lines are tagged `EvolutionaryDeck` in the Lovely log under `%AppData%\Balatro\Mods\lovely\log\`.

Scoring also shows a brief XP status using Balatro's existing card feedback. A row of 12 pips appears along the bottom of each playing card. Each filled pip is one scored use. The pip at the end of each group is ringed.

| Pips | Color | Evolution |
| --- | --- | --- |
| 1–3 | Blue | Enhancement at 3 |
| 4–7 | Red | Seal at 7 |
| 8–12 | Purple | Edition at 12 |

## Roadmap

### 1. Finish validating v0.2.0

- Check that the pip row is readable on cards during a run.
- Follow one physical card through XP 3, 7, and 12; confirm its enhancement, seal, and edition.
- Save and reload mid-run to confirm XP and threshold flags persist.
- Confirm an existing enhancement, seal, or edition is never replaced.
- Fix bugs found in these checks without adding more content.

### 2. Make installation reproducible

- Test a clean install with a current supported Balatro and Steamodded pair.
- Remove or clearly scope the old-build Lovely patches and local Steamodded adjustments.
- Publish a small versioned ZIP release with the tested requirements.

### 3. Keep later changes optional

- Add XP to the card tooltip only if the pip row proves insufficient.
- Consider balance changes only after the basic experiment is fully verified.
- Keep custom art, extra content, and larger frameworks out of scope for this experiment.

## Verification and compatibility

Locally, the mod loaded and a card reached XP 3 and gained a Mult enhancement. The seal and edition thresholds have not been observed in live play yet.

On v0.2.0, Steamodded registered the on-card XP draw step at startup. The overlay has not yet been visually inspected in a live run.

The local game was Balatro 1.0.0i with Steamodded 26.829.0 and separate compatibility adjustments to the installed Steamodded files. Those adjustments are not included here. `lovely.toml` contains small patches for that older game build. A clean install on a newer Balatro/Steamodded pairing has not been verified.
