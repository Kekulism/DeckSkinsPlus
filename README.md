# DeckSkins+

A mod for Balatro that unlocks the Customize Deck menu's potential, allowing users to create new skins for not just face cards, but ALL cards in the Balatro deck, and implement them in-game with ease.
DeckSkins+ dynamically loads new Custom Deck skins from the /skins/ directory and provides an API for dependent mods. In theory, you can add as many as you want!

![Deck Customization Menu](https://i.imgur.com/qoIk2fK.gif)

## Creating New Deck Skins

Making an add-on for DeckSkins+ is super easy!
All you need is a small .lua file that contains a table of variables in the /skins/ folder, and 1-2 pairs of textures in the /assets/ folder.
Check the /.example/ folder for more details on how DeckSkins+ add-ons are formatted.

## Installation

This mod requires [Lovely](https://github.com/ethangreen-dev/lovely-injector) and [Steammodded](https://github.com/Steamopollys/Steamodded), without these dependencies this mod will not function.

To install DeckSkins+, download the contents of this repo as a zip file and extract it into your Balatro mods folder. 
Inside the Balatro mods folder, make sure the folder you place the contents of the repo does not end with `-main`! Name the folder something like "DeckSkinsPlus".

## DeckSkin API

DeckSkins+ includes an API for dependent mods to inject their own DeckSkins

The API accepts:

- **key** - The identifying key.
- **suit** - The suit this DeckSkin applies to.
- **ranks** - The ranks this DeckSkin supports.
- **lc_atlas** - The name of the atlas used for the DeckSkin's low contrast texture.
- **hc_atlas** - Optional - The name of the atlas used for the DeckSkin's low contrast texture. If missing the lc_atlas will be used instead.
- **posStyle** - Optional - Determines the way cards in the textures are accessed. If 'collab' positions will be taken from G.COLLABS.pos, which matches the current layout of Balatro's collabs. If 'deck' positions will be taken from the card's pos, which matches the current - layout of the deck texutre. if 'suit' the y position will be 0 and the x position will be taken from the card's pos. If missing will default to 'deck'.
- **loc_txt** - Optional - The translated name of the DeckSkin. If missing and a translation doesn't already exist, the key will be used.

### Usage Example
```Lua
SMODS.Atlas{
  key = "myLowContrast",
  path = "myLowContrast.png",
  px = 71,
  py = 95,
  atlas_table = 'ASSET_ATLAS'
}

SMODS.Atlas{
  key = "myHighContrast",
  path = "myHighContrast.png",
  px = 71,
  py = 95,
  atlas_table = 'ASSET_ATLAS'
}

DSP.DeckSkin{
  key = "myDeckSkin",
  suit = 'Spades',
  ranks = { '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace" },
  hc_atlas = "myHighContrast",
  lc_atlas = "myLowContrast",
  loc_txt = {
    ['en-us'] = 'My Cool Deck Skin!'
  },
  posStyle = 'suit'
}
```

## Credits

Huge thanks to [#Guigui](https://github.com/HastagGuigui) and OneSuchKeeper for allowing me to use the lovely patches they wrote! Without those patches, this project would not be possible!
