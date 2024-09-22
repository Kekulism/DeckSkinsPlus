--- The file name of this lua file is important, it will act as the skin's ID.
--- Make sure to name it something that another modder is unlikely to use!

local skin = {
    --- Name - The name of your custom skin. This will be shown on the Customize Deck UI in-game.
	name = "Just Faces",
    --- Suit - This is the suit that your skin is assigned to-- Hearts, Clubs, Diamonds, or Spades.
    ---        For this example, the skin is set to "C", so the suit is Clubs.
    ---        The code will also accept a lowercase letter (like "c"),
    ---        or the suit name in all lowercase or with the first letter capitalized (like "Clubs" or "clubs")
    suit = "S",
    --- Texture - This is the name of your texture that will be used for you skin.
    ---           It should correspond to two files of the same name in the /assets/1x/ and /assets/2x/ folders.
    ---           Like the lua file, make sure its filename is unique!
    texture = "exampleJF.png",
    --- High Contrast Texture - This is an OPTIONAL value.
    ---                         If you don't want to have an alternate version of your skin with high contrast colors,
    ---                         Then keep this value set to nil. If you do want to support high contrast, then replace
    ---                         the nil with another texture file name, like "example_2.png". Make sure its wrapped in quotes!
    highContrastTexture = nil,
	--- Cards - This an OPTIONAL value.
	---         This line, the cards table, should only be declared if your texture file(s) do not contain every card. If your
	---         texture only includes face cards, face cards and ace, or any other combination of cards that isn't the normal
	---         spritesheet format, then this line should be set to nil, or you could alternatively remove the entire line.
	---
	---         By default, the value of cards will be set to the following if the table is set to nil or if the line is removed:
	---         { "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace" }
	---
	---         By setting the values of this table ourselves, we are specifying to DeckSkins+ which cards are in your texture file,
	---         and what order they appear in. In the texture file for this skin, "exampleJF.png", you'll notice that it only has
	---         3 cards in it, and from left to right, the order matches what is specified below in the cards table. The order of
	---         these cards is VERY important-- make sure they match, because if they don't you'll get fake cards that have the
	---         appearance of one card but in reality are actually a completely different card.
	---
	---         Also, as you can see below, we've specified the Jack, Queen, and King with just the letters they begin with.
	---         The code will accept either the first letters of the Jack, Queen, King, or Ace whether or not they are capitalized.
	---         (like "J" or "j", "Q" or "q", "K", or "k", and "A" or "a")
	---         The code will also accept the full names of the cards, whether or not their first letters are capitalized.
	---         (like "Jack" or "jack", "Queen" or "queen", "King" or "king", and "Ace" or "ace")
	cards = { "J", "Q", "K" }
}

return skin