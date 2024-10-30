--- STEAMODDED HEADER
--- MOD_NAME: DeckSkinsPlus
--- MOD_ID: DSplus
--- MOD_AUTHOR: [Keku]
--- MOD_DESCRIPTION: Enables full deck customization for the Customize Deck menu, allowing new textures for not just the face cards, but every card in your deck. This mod will find all .lua files inside the /skins/ directory in this mod's folder and load each of them as an additional option in the Customize Decks menu.
--- VERSION: 0.2.0
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-1030f]
--- BADGE_COLOR: 52d49f
--- PRIORITY: 0
----------------------------------------------
---------------- MOD CODE --------------------
function debugMessage(message)
	sendDebugMessage('[DSPlus] ' .. message)
end

debugMessage("Launching")

local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local usable_path = mod_path:match("Mods/[^/]+")

debugMessage("Mod Path: " .. usable_path)

----------------------------------------------
------------ load utility --------------------
local function recursiveEnumerate(folder)
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

local function sendSkinFailMessage(file, message)
	sendWarnMessage('[DSPlus] ' .. 'Failed to load skin from ' .. file .. '. ' .. message)
end

local function toTable(value)
	if value == nil then
		return {}
	elseif type(value) == "string" then
		return {value}
	elseif type(value) == "table" then
		return value
	end
end

local standardRanks = { '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace" }
local standardSuits = {'Hearts', 'Clubs', 'Diamonds', 'Spades'}

local function isStandard(input)
	return input == 'Standard' or input == 'standard' or input == 'S' or input == 's'
end

------------------
--- Load Skins ---
------------------
local files = {}
for s in recursiveEnumerate(usable_path .. "/skins"):gmatch("[^\r\n]+") do
	files[#files + 1] = s:gsub(usable_path .. "/skins/", "")
end
debugMessage(tprint(files))

for _, file in ipairs(files) do
	debugMessage(file .. " found!")

	if file:match("%.lua$") then
		local loaded = SMODS.load_file("skins/" .. file)
		
		if loaded == nil then
			sendSkinFailMessage(file, 'file failed to load.')
			break
		end
		
		local skin = loaded()
		
		--validate
		if skin == nil then
			sendSkinFailMessage(file, 'skin was nil.')
			break
		elseif skin.suits == nil then
			sendSkinFailMessage(file, 'required entry \'suits\' was nil.')
			break
		elseif skin.texture == nil then
			sendSkinFailMessage(file, 'required entry \'texture\' was nil.')
			break
		end
		
		--standards
		if isStandard(skin.suits) then
			skin.suits = standardSuits
		end
		
		if skin.ranks == nil or isStandard(skin.ranks) then
			skin.ranks = standardRanks
		end
		
		--textures
		local id = file:sub(1, -5)
		debugMessage(skin.pixelsX .. ' ' .. id)
		local pixelsX = skin.pixelsX or 71
		local pixelsY = skin.pixelsY or 95
		
		local lc_atlas = id .. "_1"
		SMODS.Atlas {
			key = lc_atlas,
			path = skin.texture,
			px = pixelsX,
			py = pixelsY,
			atlas_table = 'ASSET_ATLAS'
		}
		
		local hc_atlas = nil
		if skin.highContrastTexture then
			hc_atlas = id .. "_2"
			SMODS.Atlas {
				key = hc_atlas,
				path = skin.highContrastTexture,
				px = pixelsX,
				py = pixelsY,
				atlas_table = 'ASSET_ATLAS'
			}
		end
		
		local posStyle = skin.posStyle or 'suit'
		
		--skins
		local ranks = toTable(skin.ranks)
		
		for _, suit in ipairs(toTable(skin.suits)) do
			SMODS.DeckSkin{
				key = id .. suit,
				suit = suit,
				ranks = ranks,
				hc_atlas = hc_atlas,
				lc_atlas = lc_atlas,
				loc_txt = skin.loc_text,
				posStyle = posStyle
			}
		end
		
		debugMessage(file .. " loaded as " .. id)
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
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'OneSuchKeeper', scale = text_scale * 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
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
							{ n = G.UIT.T, config = { text = 'Lovely Patching by', scale = text_scale * 0.6, colour = G.C.RED, shadow = true } },
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
