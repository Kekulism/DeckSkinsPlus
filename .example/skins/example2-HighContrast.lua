--- This file should be placed in the 'DeckSkinsPlus/skins directory'
--- The file name of this lua file is important, it will act as the skin's ID.
--- Make sure to name it something that another modder is unlikely to use!

local skin = {
	--- Suits - REQUIRED - string or array of strings
	---    This is the id(s) of the suit(s) your skin is applied to. 
	---    Use a string for a single suit or an array of strings if your texture contains multiple.
	---    The string 'Standard' may be used to apply you skin to the four standard suits:
	---    'Hearts', 'Clubs', 'Diamonds', 'Spades'
	---	   If your skin applies to multiple suits, you'll likely want to use the 'deck' posStyle. See posStyle below.
	---
	---    To see multiple suits in action, see example4-FullTexture.lua.
	suits = 'Hearts',

	--- Ranks - OPTIONAL - string or array of strings
	---    This is the id(s) of the rank(s) your skin is applied to.
	---    Use a string for a single rank or an array of string if your texture contains multiple
	---    The string 'Standard' may be used may be to apply you skin to the 13 standard ranks: 
	---    The default rank keys are: '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace"
	---    If this value is nil, the Standard ranks will be used.
	---
	---    To see more specific suits in action, see example3-SpecificCards.lua.
	ranks = 'Standard',
	
	--- Texture - REQUIRED - string 
	---    This is the path to the texture used for the low contrast version of your skin.
	---    It should correspond to two files of the same name in the DeckSkinsPlus/assets/1x/ and DeckSkinsPlus/assets/2x/ folders.
    ---    Like the lua file, make sure its filename is unique!
	texture = 'exampleHC_1.png',
	
	--- High Contrast Texture - OPTIONAL - string
	---    This is the path to the texture used for the high contrast version of your skin.
    ---    If this value is nil the low contrast texture will be used instead
	---    It should correspond to two files of the same name in the DeckSkinsPlus/assets/1x/ and DeckSkinsPlus/assets/2x/ folders.
    ---    Like the lua file, make sure its filename is unique!
    highContrastTexture = 'exampleHC_2.png',
	
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
	---    Use 'deck' if your texture matches a deck layout (full ranks for each suit top to bottom, you will likely need to use this if your texture contains multiple suits). See example4-FullTexture.lua
	posStyle = 'suit',
	
	--- loc_text - OPTIONAL - Table of language ids to string
	---    This is the name of your skin
	---    If this value is nil the ID will be used instead
	loc_text = {
		['en-us'] = 'High Contrast Skin!'
	}
}

return skin