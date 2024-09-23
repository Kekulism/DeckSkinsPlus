--- The file name of this lua file is important, it will act as the skin's ID.
--- Make sure to name it something that another modder is unlikely to use!

local skin = {
    --- Name - The name of your custom skin. This will be shown on the Customize Deck UI in-game.
    name = "New Skin!",
    --- Suit - This is the suit that your skin is assigned to-- Hearts, Clubs, Diamonds, or Spades.
    ---        For this example, the skin is set to "C", so the suit is Clubs.
    ---        The code will also accept a lowercase letter (like "c"),
    ---        or the suit name in all lowercase or with the first letter capitalized (like "Clubs" or "clubs")
	---
	---        This value can also be set to all suits, indicating to DeckSkins+ that your texture skin's texture
	---        includes all suits. To do this, set the suit value to "A", "a", "All", "all" or "*". To see this
	---        in action, check example4-FullTexture.lua.
    suit = "C",
    --- Texture - This is the name of your texture that will be used for you skin.
    ---           It should correspond to two files of the same name in the /assets/1x/ and /assets/2x/ folders.
    ---           Like the lua file, make sure its filename is unique!
    texture = "example.png",
    --- High Contrast Texture - This is an OPTIONAL value.
    ---                         If you don't want to have an alternate version of your skin with high contrast colors,
    ---                         Then keep this value set to nil, or delete the entire line. If you do want that, then replace
    ---                         the nil with another texture file name, like "example_2.png". Make sure its wrapped in quotes!
	---
	---                         To see the highContrastTexture value in action, see example2-HighContrast.lua.
    highContrastTexture = nil,
	--- Cards - This an OPTIONAL value.
	---         This line, the cards table, should only be declared if your texture file(s) do not contain every card. If your
	---         texture only includes face cards, face cards and ace, or any other combination of cards that isn't the normal
	---         spritesheet format, then this line should kept as nil, or you could alternatively remove the entire line.
	---
	---         To see the cards table in action, and how to format the cards table, see example3-SpecificCards.lua.
	cards = nil
}

return skin