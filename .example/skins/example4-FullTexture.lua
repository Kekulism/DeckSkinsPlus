--- This file should be placed in the 'DeckSkinsPlus/skins directory'
--- The file name of this lua file is important, it will act as the skin's ID.
--- Make sure to name it something that another modder is unlikely to use!

local skin = {
	--- Suits - REQUIRED - string or array of strings
	---    This is the id(s) of the suit(s) your skin is applied to. 
	---    Use a string for a single suit or an array of strings if your texture contains multiple.
	---    The default suit keys are: 'Hearts', 'Clubs', 'Diamonds', 'Spades'
	suits = {'Hearts', 'Clubs', 'Diamonds', 'Spades'},

	--- Ranks - REQUIRED - string or array of strings
	---    This is the id(s) of the rank(s) your skin is applied to.
	---    Use a string for a single rank or an array of string if your texture contains multiple
	---    The default rank keys are: '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"
	---
	---    To see more specific suits in action, see example3-SpecificCards.lua.
	ranks = { '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace" },
	
	--- Texture - REQUIRED - string 
	---    This is the path to the texture used for the low contrast version of your skin.
	---    It should correspond to two files of the same name in the DeckSkinsPlus/assets/1x/ and DeckSkinsPlus/assets/2x/ folders.
    ---    Like the lua file, make sure its filename is unique!
	texture = 'exampleFT.png',
	
	--- High Contrast Texture - OPTIONAL - string
	---    This is the path to the texture used for the high contrast version of your skin.
    ---    If this value is nil the low contrast texture will be used instead
	---    It should correspond to two files of the same name in the DeckSkinsPlus/assets/1x/ and DeckSkinsPlus/assets/2x/ folders.
    ---    Like the lua file, make sure its filename is unique!
	---
	---    To see the highContrastTexture value in action, see example2-HighContrast.lua.
    highContrastTexture = nil,
	
	--- Pixels X - OPTIONAL - int
	---    The width of a card in your texture in pixels.
	---    Will default to '71' if nil
	pixelsX = 71,
	
	--- Pixels Y - OPTIONAL - int
	---    The height of a card in your texture in pixels.
	---    Will default to '95' if nil
	pixelsY = 95,
	
	--- Position Style - OPTIONAL - string
	---    This determines the order cards are taken from your texture.
	---    If this value is nil will default to 'suit'
	---    Use 'collab' if your texture matches collab skin layout (Jack-King). See example3-SpecificCards.lua
	---    Use 'suit' if your texture matches a full rank layout (2-Ace)
	---    Use 'deck' if your texture matches a deck layout (full ranks for top to bottom (Hearts, Clubs, Diamonds, Spades), you will likely need to use this if your texture contains multiple suits).
	posStyle = 'deck',
	
	--- loc_text - OPTIONAL - Table of language ids to string
	---    This is the name of your skin
	---    If this value is nil the ID will be used instead
	loc_text = {
		['en-us'] = 'Full Texture!'
	}
}

return skin
