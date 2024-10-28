--- STEAMODDED HEADER
--- MOD_NAME: DeckSkinsPlus
--- MOD_ID: DSplus
--- MOD_AUTHOR: [Keku]
--- MOD_DESCRIPTION: Enables full deck customization for the Customize Deck menu, allowing new textures for not just the face cards, but every card in your deck. This mod will find all .lua files inside the /skins/ directory in this mod's folder and load each of them as an additional option in the Customize Decks menu.
--- VERSION: 0.2.0
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
---------------- API -------------------------
DSP = {}

local deck_skin_count_by_suit = {}
DSP.DeckSkins = {}
DSP.DeckSkin = SMODS.GameObject:extend {
	obj_table = DSP.DeckSkins,
	obj_buffer = {},
	required_params = {
		'key',
		'suit',
		'ranks',
		'lc_atlas',
	},
	set = 'DeckSkin',
	process_loc_text = function(self)
		if G.localization.misc.collabs[self.suit] == nil then
			G.localization.misc.collabs[self.suit] = {["1"] = 'default'}
		end

		if self.loc_txt and self.loc_txt[G.SETTINGS.language] then
			G.localization.misc.collabs[self.suit][self.suit_index .. ''] = self.loc_txt[G.SETTINGS.language]
		elseif G.localization.misc.collabs[self.suit][self.suit_index .. ''] == nil then
			G.localization.misc.collabs[self.suit][self.suit_index .. ''] = self.key
		end
	end,
	register = function (self)
		if self.registered then
			sendWarnMessage(('Detected duplicate register call on DeckSkin %s'):format(self.key), self.set)
			return
		end
		if self:check_dependencies() then
			if self.hc_atals == nil then self.hc_atals = self.lc_atlas end
			if self.posStyle == nil then self.posStyle = 'deck' end

			if not (self.posStyle == 'collab' or self.posStyle == 'suit' or self.posStyle == 'deck') then
				sendWarnMessage(('%s is not a valid posStyle on DeckSkin %s. Supported posStyle values are \'collab\', \'suit\' and \'deck\''):format(self.posStyle, self.key), self.set)
			end

			self.obj_table[self.key] = self

			if deck_skin_count_by_suit[self.suit] then
				self.suit_index  = deck_skin_count_by_suit[self.suit] + 1
			else
				--start at 2 for default
				self.suit_index = 2
			end
			deck_skin_count_by_suit[self.suit] = self.suit_index

			self.obj_buffer[#self.obj_buffer + 1] = self.key
			self.registered = true
		end
	end,
	inject = function (self)
		local options = G.COLLABS.options[self.suit]
		options[#options + 1] = self.key
	end
}

for suitName, options in pairs(G.COLLABS.options) do
	--start at 2 to skip default
	for i = 2, #options do
		DSP.DeckSkin{
			key = options[i],
			suit = suitName,
			ranks = {'Jack', 'Queen', 'King'},
			lc_atlas = options[i] .. '_1',
			hc_atlas = options[i] .. '_2',
			posStyle = 'collab',
			prefix_config = {
				key = false,
				atlas = false
			}
		}
	end
end

--Clear 'Friends of Jimbo' skins so they can be handled via the same pipeline
G.COLLABS.options['Spades'] = {'default'}
G.COLLABS.options['Hearts'] = {'default'}
G.COLLABS.options['Clubs'] = {'default'}
G.COLLABS.options['Diamonds'] = {'default'}

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
		elseif skin.ranks == nil then
			sendSkinFailMessage(file, 'required entry \'ranks\' was nil.')
			break
		elseif skin.texture == nil then
			sendSkinFailMessage(file, 'required entry \'texture\' was nil.')
			break
		end
		
		--textures
		local id = file:sub(1, -5)
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
			DSP.DeckSkin{
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

----------------------------
--- Skin Existence Check ---
----------------------------
local splash_screenRef = Game.splash_screen
function Game:splash_screen()
	splash_screenRef(self)
	debugMessage("Checking for missing selected skins...")
	
	for _, suit in pairs(SMODS.Suits) do
		local currentSkin = G.SETTINGS.CUSTOM_DECK.Collabs[suit.key]
		if currentSkin == nil then break end
		
		debugMessage(suit.key..' is set to '..currentSkin)
		
		local options = G.COLLABS.options[suit.key]
		if options == nil then break end
		
		local invalid = true
		for i = 1, #options do
			if options[i] == currentSkin then
				invalid = false
				break
			end
		end
		
		if invalid then
			G.SETTINGS.CUSTOM_DECK.Collabs[suit.key] = 'default'
			debugMessage(suit.key .. " set to a missing skin, setting to default.")
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
							{ n = G.UIT.T, config = { text = 'Lua Programming by', scale = text_scale * 0.6, colour = G.C.GOLD, shadow = true } },
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
