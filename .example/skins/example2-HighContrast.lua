--- The file name of this lua file is important, it will act as the skin's ID.
--- Make sure to name it something that another modder is unlikely to use!

local skin = {
    --- Name - The name of your custom skin. This will be shown on the Customize Deck UI in-game.
    name = "High Contrast Skin!",
    --- Suit - This is the suit that your skin is assigned to-- Hearts, Clubs, Diamonds, or Spades.
    ---        For this example, the skin is set to "H", so the suit is Hearts.
    ---        The code will also accept a lowercase letter (like "h"),
    ---        or the suit name in all lowercase or with the first letter capitalized (like "Hearts" or "hearts")
    suit = "H",
    --- Texture - This is the name of your texture that will be used for you skin.
    ---           It should correspond to two files of the same name in the /assets/1x/ and /assets/2x/ folders.
    ---           Like the lua file, make sure its filename is unique!
    texture = "exampleHC_1.png",
    --- High Contrast Texture - This is an OPTIONAL value.
    ---                         If you don't want to have an alternate version of your skin with high contrast colors,
    ---                         Then set this value to nil. If you do want to support high contrast, then keep it
    ---                         looking like this, where it's set to the name of another pair of textures.
    highContrastTexture = "exampleHC_2.png",
	--- Cards - This an OPTIONAL value.
	---         This line, the cards table, should only be declared if your texture file(s) do not contain every card. If your
	---         texture only includes face cards, face cards and ace, or any other combination of cards that isn't the normal
	---         spritesheet format, then this line should kept as nil, or you could alternatively remove the entire line.
	---
	---         To see the cards table in action, and how to format the cards table, see example3-SpecificCards.lua.
	cards = nil
}

return skin