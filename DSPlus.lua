--- STEAMODDED HEADER
--- MOD_NAME: DeckSkinsPlus
--- MOD_ID: DSplus
--- MOD_AUTHOR: [Keku]
--- MOD_DESCRIPTION: Enables full deck customization for the Customize Deck menu, allowing new textures for not just the face cards, but every card in your deck. This mod will find all .lua files inside the /skins/ directory in this mod's folder and load each of them as an additional option in the Customize Decks menu.
--- BADGE_COLOR: 52d49f
--- PRIORITY: 50
----------------------------------------------
------------MOD CODE -------------------------
sendDebugMessage("Launching DeckSkins+")

local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local usable_path = mod_path:match("Mods/[^/]+")

sendDebugMessage("Mod Path: " .. usable_path)

function recursiveEnumerate(folder)
	local fileTree = ""
	for _, file in ipairs(love.filesystem.getDirectoryItems(folder)) do
		local path = folder .. "/" .. file
		local info = love.filesystem.getInfo(path)
		fileTree = fileTree .. "\n" .. path .. (info.type == "directory" and " (DIR)" or "")
		if info.type == "directory" then
			fileTree = fileTree .. recursiveEnumerate(path)
		end
	end
	return fileTree
end

local files = {}
for s in recursiveEnumerate(usable_path .. "/skins"):gmatch("[^\r\n]+") do
	files[#files + 1] = s:gsub(usable_path .. "/skins/", "")
end
sendDebugMessage(tprint(files))

------------------
--- Load Skins ---
------------------
local loadCounts = {
	Hearts = 0,
	Clubs = 0,
	Diamonds = 0,
	Spades = 0
}

local suits = {
	Hearts = {"Hearts", "hearts", "H", "h"},
	Clubs = {"Clubs", "clubs", "C", "c"},
	Diamonds = {"Diamonds", "diamonds", "D", "d"},
	Spades = {"Spades", "spades", "S", "s"}
}

G.EXTRA_SKINS, G.EXTRA_SKINS_NAMES = {}, {}
for suit in pairs(suits) do
	G.EXTRA_SKINS[suit], G.EXTRA_SKINS_NAMES[suit] = {}, {}
end

local function suitMatches(skinSuit, suitAliases)
	for _, alias in ipairs(suitAliases) do
		if skinSuit:lower() == alias:lower() then
			return true
		end
	end
end

local function getSkinName(skin, suit)
	if type(skin.name) == "string" then
		return skin.name
	end

	if type(skin.name) == "table" then
		local aliases = suits[suit]
		for _, alias in ipairs(aliases) do
			if skin.name[alias] then
				return skin.name[alias]
			end
		end
	end
end

local function loadSkin(skin, id, suit, cards)
	local skinName = getSkinName(skin, suit)
	if not skinName then
		return false
	end

	G.COLLABS.options[suit][id] = cards
	G.COLLABS.list[suit][#G.COLLABS.list[suit] + 1] = id
	loadCounts[suit] = loadCounts[suit] + 1
	G.EXTRA_SKINS[suit][loadCounts[suit]] = id
	G.EXTRA_SKINS_NAMES[suit][loadCounts[suit]] = skinName
	sendDebugMessage(tprint(G.EXTRA_SKINS_NAMES[suit]))

	return true
end

for _, file in ipairs(files) do
	sendDebugMessage(file .. " found!")

	if file:match("%.lua$") then
		local skin = SMODS.load_file("skins/" .. file)()
		local id = file:sub(1, -5)

		sendDebugMessage(file .. " loaded as " .. id)

		local defaultCards = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"}
		local cardShorts = {
			J = "Jack",
			Q = "Queen",
			K = "King",
			A = "Ace"
		}

		local cards = skin.cards or defaultCards
		for i, card in ipairs(cards) do
			local normalized = card:lower():gsub("^%l", string.upper)
			cards[i] = cardShorts[card:sub(1, 1)] or normalized
		end

		local allSuits = skin.suit:lower() == "all" or skin.suit:lower() == "a" or skin.suit == "*"
		for suit, aliases in pairs(suits) do
			if allSuits or suitMatches(skin.suit, aliases) then
				local loaded = loadSkin(skin, id, suit, cards)

				if loaded and allSuits then
					G.COLLABS.options[suit][id].ALL_SUITS = true
				end
			end
		end

		local texture1, texture2 = skin.texture, skin.highContrastTexture or skin.texture
		SMODS.Atlas {
			key = id .. "_1",
			path = texture1,
			px = 71,
			py = 95,
			atlas_table = 'ASSET_ATLAS',
			prefix_config = {
				key = false
			}
		}
		SMODS.Atlas {
			key = id .. "_2",
			path = texture2,
			px = 71,
			py = 95,
			atlas_table = 'ASSET_ATLAS',
			prefix_config = {
				key = false
			}
		}
	end
end

----------------------------
--- Skin Existence Check ---
----------------------------
local splash_screenRef = Game.splash_screen
local function containsValue(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end
function Game:splash_screen()
	splash_screenRef(self)
	sendDebugMessage("Checking for missing selected skins...")

	for suit, skin_ids in pairs(G.EXTRA_SKINS) do
		local selected_skin = self.SETTINGS.CUSTOM_DECK.Collabs[suit]
		if not containsValue(skin_ids, selected_skin) and selected_skin ~= "default" then
			self.SETTINGS.CUSTOM_DECK.Collabs[suit] = "default"
			sendDebugMessage(suit .. " has a missing skin, setting to default.")
		end
	end
end

-------------------
--- Credits Tab ---
-------------------
SMODS.current_mod.credits_tab = function()

	local text_scale = 0.9
	chosen = true
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 10 },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1 },
				nodes = {
					{
				n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'Programming by', scale = text_scale * 0.6, colour = G.C.GOLD, shadow = true } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'Keku', scale = text_scale * 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = '#Guigui', scale = text_scale * 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'Sbax', scale = text_scale * 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
						}
					},
				}
			},
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1 },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'lovely.toml Patch File by', scale = text_scale * 0.6, colour = G.C.RED, shadow = true } },
					}
					},
					{
				n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = '#Guigui & OneSuchKeeper', scale = text_scale * 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
					}
					},
				}
			},
		}
	}
end
----------------------------------------------
------------MOD CODE END----------------------
