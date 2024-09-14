# DeckSkins+

A mod for Balatro that unlocks the Customize Deck menu's potential, allowing users to create new skins and implement them in-game with ease.

## Skin Creation

Check the /.examples/ folder in this repo to see how skin add-ons are formatted!

Each skin has one .lua file and 1-2 texture pairs depending on if the skin supports high contrast colors or not.
Skin textures must have all 13 cards in them, like in the example skin assets. The texture must be a spritesheet of all the cards sorted in 2-Ace format, starting from the left going from 2 to 10, then Jack, Queen, King, and Ace.

When distrubiting you skins for this mod, I'd reccomend making a folder formatted like the /.examples/ folder to store your edited .lua and .png files, just make sure the subfolders match the mod! Then simply take that directory and compress it into a zip file.

## Installation

This mod requires [Lovely](https://github.com/ethangreen-dev/lovely-injector) and [Steammodded](https://github.com/Steamopollys/Steamodded), without these dependencies this mod will not function.

To install DeckSkins+, download the contents of this repo as a zip file and extract it into your Balatro mods folder.
