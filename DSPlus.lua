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
local usable_path = mod_path:gsub("[/\\]", "//")
local loadNumC, loadNumH, loadNumD, loadNumS = 0, 0, 0, 0


sendDebugMessage("Mod Path: " .. usable_path)

function recursiveEnumerate(folder, fileTree)
	local filesTable = love.filesystem.getDirectoryItems(folder)
	for i, v in ipairs(filesTable) do
		local file = folder .. "/" .. v
		local info = love.filesystem.getInfo(file)
		if info then
			if info.type == "file" then
				fileTree = fileTree .. "\n" .. file
			elseif info.type == "directory" then
				fileTree = fileTree .. "\n" .. file .. " (DIR)"
				fileTree = recursiveEnumerate(file, fileTree)
			end
		end
	end
	return fileTree
end

local pp = recursiveEnumerate("Mods/DeckSkinsPlus/skins", "")
local files = {}
for s in pp:gmatch("[^\r\n]+") do
	files[#files + 1] = s:gsub("Mods/DeckSkinsPlus/skins/", "")
end
sendDebugMessage(tprint(files))

------------------
--- Load Skins ---
------------------
G.EXTRA_SKINS = {
	Clubs = {},
	Hearts = {},
	Diamonds = {},
	Spades = {}
}
G.EXTRA_SKINS_NAMES = {
	Clubs = {},
	Hearts = {},
	Diamonds = {},
	Spades = {}
}
for _, file in ipairs(files) do
	sendDebugMessage(file .. " found!")
	if file:match("%.lua$") then
		local skin = SMODS.load_file("skins/" .. file)()
		local id = file:sub(1, -5)

		sendDebugMessage(file .. " loaded as " .. id)

		local cards = { "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace" }
		local cardShorts = {
			J = "Jack",
			Q = "Queen",
			K = "King",
			A = "Ace",
			j = "Jack",
			q = "Queen",
			k = "King",
			a = "Ace",
			jack = "Jack",
			queen = "Queen",
			king = "King",
			ace = "Ace"
		}
		if skin.cards then
			for i, card in ipairs(skin.cards) do
				if cardShorts[card] then
					skin.cards[i] = cardShorts[card]
				end
			end
			cards = skin.cards
		end

		if skin.suit == "C" or skin.suit == "c" or skin.suit == "clubs" or skin.suit == "Clubs" then
			G.COLLABS.options.Clubs[id] = cards
			G.COLLABS.list.Clubs[#G.COLLABS.list.Clubs + 1] = id
			loadNumC = loadNumC + 1
			G.EXTRA_SKINS.Clubs[loadNumC] = id
			G.EXTRA_SKINS_NAMES.Clubs[loadNumC] = skin.name
			sendDebugMessage(tprint(G.EXTRA_SKINS_NAMES.Clubs))
		end
		if skin.suit == "H" or skin.suit == "h" or skin.suit == "hearts" or skin.suit == "Hearts" then
			G.COLLABS.options.Hearts[id] = cards
			G.COLLABS.list.Hearts[#G.COLLABS.list.Hearts + 1] = id
			loadNumH = loadNumH + 1
			G.EXTRA_SKINS.Hearts[loadNumH] = id
			G.EXTRA_SKINS_NAMES.Hearts[loadNumH] = skin.name
			sendDebugMessage(tprint(G.EXTRA_SKINS_NAMES.Hearts))
		end
		if skin.suit == "D" or skin.suit == "d" or skin.suit == "diamonds" or skin.suit == "Diamonds" then
			G.COLLABS.options.Diamonds[id] = cards
			G.COLLABS.list.Diamonds[#G.COLLABS.list.Diamonds + 1] = id
			loadNumD = loadNumD + 1
			G.EXTRA_SKINS.Diamonds[loadNumD] = id
			G.EXTRA_SKINS_NAMES.Diamonds[loadNumD] = skin.name
			sendDebugMessage(tprint(G.EXTRA_SKINS_NAMES.Diamonds))
		end
		if skin.suit == "S" or skin.suit == "s" or skin.suit == "spades" or skin.suit == "Spades" then
			G.COLLABS.options.Spades[id] = cards
			G.COLLABS.list.Spades[#G.COLLABS.list.Spades + 1] = id
			loadNumS = loadNumS + 1
			G.EXTRA_SKINS.Spades[loadNumS] = id
			G.EXTRA_SKINS_NAMES.Spades[loadNumS] = skin.name
			sendDebugMessage(tprint(G.EXTRA_SKINS_NAMES.Spades))
		end

		local texture1 = "nil"
		local texture2 = "nil"
		if skin.highContrastTexture == nil then
			sendDebugMessage(file .. " has High Contrast set to OFF.")
			texture1 = skin.texture
			texture2 = skin.texture
		else
			sendDebugMessage(file .. " has High Contrast set to ON.")
			texture1 = skin.texture
			texture2 = skin.highContrastTexture
		end

		SMODS.Atlas {
			key = id .. "_1",
			path = texture1,
			px = 71,
			py = 95,
			atlas_table = 'ASSET_ATLAS',
			prefix_config = { key = false }
		}
		SMODS.Atlas {
			key = id .. "_2",
			path = texture2,
			px = 71,
			py = 95,
			atlas_table = 'ASSET_ATLAS',
			prefix_config = { key = false }
		}
	end
end

----------------------------
--- Skin Existence Check ---
----------------------------
local splash_screenRef = Game.splash_screen
function Game:splash_screen()
	splash_screenRef(self)
	sendDebugMessage("Checking for missing selected skins...")
	local missing_table = {
		Clubs = true,
		Hearts = true,
		Diamonds = true,
		Spades = true
	}
	
	for suit_name, skin_ids in pairs(G.EXTRA_SKINS) do
		local selected_skin = self.SETTINGS.CUSTOM_DECK.Collabs[suit_name]
		
		if selected_skin ~= "default" and selected_skin ~= "collab_TW" and selected_skin ~= "collab_AU" and selected_skin ~= "collab_DTD" and selected_skin ~= "collab_VS" then
			for _, skin_id in ipairs(skin_ids) do
				if skin_id == selected_skin then
					missing_table[suit_name] = false
					break
				end
			end
		else
			missing_table[suit_name] = false
		end
	end
	
	for missing_suit, is_missing in pairs(missing_table) do
		if is_missing then  -- Check if the value is still true
			self.SETTINGS.CUSTOM_DECK.Collabs[missing_suit] = "default"
			sendDebugMessage(missing_suit.."has a missing skin set to it, setting to default.")
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
