--- STEAMODDED HEADER
--- MOD_NAME: DeckSkinsLite
--- MOD_ID: DSplus
--- MOD_AUTHOR: [Keku]
--- MOD_DESCRIPTION: A compatibility mod that allows old DeckSkins+ skins to be loaded by Steammodded's DeckSkin object! This mod will find all .lua files inside the /skins/ directory in this mod's folder and load each of them as an additional option in the Customize Decks menu.
--- BADGE_COLOR: 52d49f
--- PRIORITY: 999999999999999
----------------------------------------------
------------MOD CODE -------------------------
sendDebugMessage("Launching DeckSkinsLite")

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

local function findExistingSuit(smods_suit)
	for suit, short in pairs(suits) do
		if smods_suit.key == suit and smods_suit.card_key == short then
			return true
		end
	end
	return false
end

local suits = {
	Hearts = "H",
	Clubs = "C",
	Diamonds = "D",
	Spades = "S"
}

local loadCounts = {
	Hearts = 0,
	Clubs = 0,
	Diamonds = 0,
	Spades = 0
}

local LANGS = {}
for lang, tbl in pairs(G.LANGUAGES) do
	if not tbl.omit then
		table.insert(LANGS, lang)
	end
end

for _, smods_suit in ipairs(SMODS.Suits) do
	if not findExistingSuit(smods_suit) then
		suits[smods_suit.key] = smods_suit.card_key
		loadCounts[smods_suit.key] = 0
	end
end

local EXTRA_SKINS = {}
for suit in pairs(suits) do
	EXTRA_SKINS[suit] = {}
end

local function findExistingKey(inputString, tbl)
	for key, value in pairs(tbl) do
		if key == inputString then
			return true
		end
	end
	return false
end

function isInt(n)
	return type(n) == "number" and n % 1 == 0
end

local function loadAtlas(id, texture, contrast, _px, _py)
	if not findExistingKey(id.."_"..contrast, SMODS.Atlases) then
		SMODS.Atlas{
			key = id.."_"..contrast,
			path = texture,
			px = _px,
			py = _py,
			atlas_table = 'ASSET_ATLAS'
		}
	end
end

local function langInTable(lang, names)
	for skin_lang, lang_name in names do
		if skin_lang == lang then
			return lang_name
		end
	end
	return nil
end

local function makeLocTXT(skin)
	local loc_txt = {}
	local names = skin.name
	if type(names) == 'string' then
		for _, lang in ipairs(LANGS) do
			loc_txt[lang] = names
		end
	elseif type(names) == 'table' then
		for _, lang in ipairs(LANGS) do
			local lang_name = langInTable(lang, names)
			if lang_name then
				loc_txt[lang] = lang_name
			end
		end
	end
	return loc_txt
end

local function getIcon(texture, suit, suitIcons, allSuitIcons)
	if allSuitIcons then
		if type(texture) == 'string' then
			local _x = 0
			if suit == "Hearts" then _x = 0 elseif suit == "Diamonds" then _x = 1 elseif suit == "Clubs" then _x = 2 elseif suit == "Spades" then _x = 3 end
			return texture, { x = _x, y = 0}
		elseif type(texture) == 'table' then
			for icon_suit, icon in pairs(texture) do
				for _suit, _short in pairs(suits) do
					if icon_suit:lower() == _suit:lower() or icon_suit:lower() == _short:lower() then
						return icon, { x = 0, y = 0}
					end
				end
			end
		end
	else
		if type(suitIcons) == 'table' then
			for i, icon_suit in ipairs(suitIcons) do
				for _suit, _short in pairs(suits) do
					if icon_suit:lower() == _suit:lower() or icon_suit:lower() == _short:lower() then
						if type(texture) == 'string' then
							return texture, { x = i-1, y = 0}
						elseif type(texture) == 'table' then
							if texture[_suit] then
								return texture[_suit], { x = i-1, y = 0}
							end
						end
					end
				end
			end
		elseif type(suitIcons) == 'string' then
			return suitIcons, { x = 0, y = 0}
		end
	end
end

local function getColor(skin_color, suit)
	if type(skin_color) == "string" then
		return skin_color
	elseif type(skin_color) == "table" then
		for suit_color, color in pairs(skin_color) do
			for _suit, short in pairs(suits) do
				if suit_color:lower() == _suit:lower() or suit_color:lower() == short:lower() then
					if _suit == suit then
						return skin_color[suit_color]
					end
				end
			end
		end
	end
end

local function loadSkin(skin, suit, short, allSuits, cards, twoAce, allSuitIcons, suitIcons)
	if skin.texture then
		local cardW, cardH = 71, 95
		if skin.cardWidth then
			if isInt(skin.cardWidth) then cardW = skin.cardWidth
			else sendErrorMessage("[DeckSkinsLite] Invalid cardWidth value for skin "..skin.id.."! cardWidth must be an integer.") end
		end
		if skin.cardHeight then
			if isInt(skin.cardHeight) then cardH = skin.cardHeight
			else sendErrorMessage("[DeckSkinsLite] Invalid cardHeight value for skin "..skin.id.."! cardHeight must be an integer.") end
		end
		loadAtlas(skin.id, skin.texture, 1, cardW, cardH)
		local style, loc, hc
		local key = skin.id
		local lcColor, hcColor, lcUI, hcUI, hcUI_atlas = nil, nil, nil, nil, nil
		local uiPos = nil
		if skin.highContrastTexture then
			loadAtlas(skin.id, skin.highContrastTexture, 2, cardW, cardH)
			hc = skin.id.."_2"
		else
			hc = skin.id.."_1"
		end
		if allSuits then
			style = 'deck'
			key = skin.id.."_"..short
		else
			if twoAce then
				style = 'suit'
			else
				style = 'collab'
			end
		end
		if skin.name then
			loc = makeLocTXT(skin)
		else
			loc = nil
		end
		if skin.color then lcColor = getColor(skin.color, suit) end
		if skin.highContrastColor then hcColor = getColor(skin.highContrastColor, suit) else hcColor = lcColor end
		if skin.suitIcon and skin.suitIconTexture then
			lcUI, uiPos = getIcon(skin.suitIconTexture, suit, suitIcons, allSuitIcons)
			loadAtlas(skin.id.."_UI", lcUI, 1, 18, 18)
			if skin.highContrastSuitIconTexture then
				hcUI, uiPos = getIcon(skin.highContrastSuitIconTexture, suit, suitIcons, allSuitIcons)
				loadAtlas(skin.id.."_UI", hcUI, 2, 18, 18)
				hcUI_atlas = skin.id.."_UI_2"
			else
				hcUI = lcUI
				hcUI_atlas = skin.id.."_UI_1"
			end
		end
		sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - key: "..key)
		sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - suit: "..suit)
		sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - cards:")
		sendDebugMessage(tprint(cards))
		if cardW ~= 71 then
			sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - px: "..cardW)
		end
		if cardH ~= 95 then
			sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - py: "..cardH)
		end
		sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - lc_atlas: "..skin.id.."_1")
		sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - hc_atlas:"..hc)
		sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - loc_txt:")
		sendDebugMessage(tprint(loc))
		sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - style:"..style)
		if lcColor then
			sendDebugMessage("[DeckSkinsMinus] "..skin.id.." - lcColor:")
			if type(lcColor) == 'table' then
				sendDebugMessage(tprint(lcColor))
			else
				sendDebugMessage(lcColor)
			end
		end
		if hcColor then
			sendDebugMessage("[DeckSkinsMinus] "..skin.id.." hcColor:")
			if type(hcColor) == 'table' then
				sendDebugMessage(tprint(hcColor))
			else
				sendDebugMessage(hcColor)
			end
		end
		if lcUI then
			if type(lcUI) == 'table' then
				sendDebugMessage(tprint(lcUI))
			else
				sendDebugMessage(lcUI)
			end
		end
		if hcUI then
			if type(hcUI) == 'table' then
				sendDebugMessage(tprint(hcUI))
			else
				sendDebugMessage(hcUI)
			end
		end
		if uiPos then
			sendDebugMessage("[DeckSkinsMinus] "..skin.id.." uiPos: ")
			sendDebugMessage(tprint(uiPos))
		end
		SMODS.DeckSkin{
			key = key,
			suit = suit,
			ranks = cards,
			hc_atlas = skin.id.."_1",
			lc_atlas = hc,
			loc_txt = loc,
			posStyle = style,
			lc_colour = lcColor,
			hc_colour = hcColor,
			lc_ui_atlas = skin.id.."_UI_1",
			hc_ui_atlas = hcUI_atlas,
			ui_pos = uiPos
		}
		loadCounts[suit] = loadCounts[suit] + 1
		table.insert(EXTRA_SKINS[suit], skin.id)
	end
end

local SKINS = {}
for _, file in ipairs(files) do
	if file:match("%.lua$") then
		local skin = SMODS.load_file("skins/" .. file)()
		if not skin.id then
			skin.id = file:sub(1, -5)
		end
		table.insert(SKINS, skin)
	end
end

for index, skin in ipairs(SKINS) do
	if skin.priority then
		if type(skin.priority) == 'string' then
			skin.priority = tonumber(skin.priority)
			if not skin.priority then
				sendWarnMessage("[DeckSkinsMinus] Invalid string at priority value for "..skin.id..", could not convert! Defaulting priority to 1000.")
				skin.priority = 1000
			end
		elseif type(skin.priority) ~= 'number' then
			sendWarnMessage("[DeckSkinsMinus] Invalid/Unknown value at priority value for "..skin.id.."! Defaulting priority to 1000.")
			skin.priority = 1000
		end
	else
		skin.priority = 1000
	end
	skin.priority = skin.priority or 1000
	skin.original_index = index
end

table.sort(SKINS, function(a, b)
	if a.priority ~= b.priority then
		return a.priority < b.priority
	end
	return a.original_index < b.original_index
end)

local function vanillaSuit(tbl, short)
	for _, v in ipairs(tbl) do
		if short:lower() == v:lower() then
			return true
		end
	end
	return false
end

local notLoadedFlag = false
for _, skin in ipairs(SKINS) do
	local defaultCards = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"}
	local defaultSuits = { "H", "D", "C", "S"}
	local cardShorts = {
		J = "Jack",
		Q = "Queen",
		K = "King",
		A = "Ace"
	}
	local cards = skin.cards or defaultCards
	local suitIcons, allSuitIcons = nil, nil
	if skin.suitIcon then
		allSuitIcons = skin.suit:lower() == "all" or skin.suit:lower() == "a" or skin.suit == "*" or false
		if allSuitIcons then
			suitIcons = defaultSuits
		else
			suitIcons = skin.suitIcon or defaultSuits
		end
	end
	for i, card in ipairs(cards) do
		local normalized = card:lower():gsub("^%l", string.upper)
		cards[i] = cardShorts[card:sub(1, 1)] or normalized
	end
	local allSuits = skin.suit:lower() == "all" or skin.suit:lower() == "a" or skin.suit == "*"
	local twoAce = cards == defaultCards
	notLoadedFlag = true
	for suit, short in pairs(suits) do
		if (allSuits and vanillaSuit(defaultSuits, short)) or (skin.suit:lower() == short:lower() or skin.suit:lower() == suit:lower()) then
			loadSkin(skin, suit, short, allSuits, cards, twoAce, allSuitIcons, suitIcons)
			notLoadedFlag = false
		end
	end
	if notLoadedFlag then
		sendWarnMessage("[DeckSkinsLite] Missing or Invalid suit value at skin ".. skin.id.."! Skin was not loaded...")
	end
end
sendInfoMessage("Successfully loaded "..loadCounts.Hearts+loadCounts.Clubs+loadCounts.Diamonds+loadCounts.Spades.." skins as SMODS Objects with DeckSkinsLite:")
sendInfoMessage(tprint(EXTRA_SKINS))

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
			}
		}
	}
end
----------------------------------------------
------------MOD CODE END----------------------
----------------------------------------------
