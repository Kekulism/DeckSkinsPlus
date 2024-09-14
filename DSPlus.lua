--- STEAMODDED HEADER
--- MOD_NAME: DeckSkinsPlus
--- MOD_ID: DSplus
--- MOD_AUTHOR: [Keku]
--- MOD_DESCRIPTION: Enables full deck customization for the Customize Deck menu, allowing new textures for not just the face cards, but every card in your deck. This mod will find all .lua files inside the /skins/ directory in this mod's folder and load each of them as an additional option in the Customize Decks menu.
--- BADGE_COLOR: 52d49f
----------------------------------------------
------------MOD CODE -------------------------

sendDebugMessage("Launching DeckSkins+")

local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local usable_path = mod_path:gsub("[/\\]", "//")
local loadNumC, loadNumH, loadNumD, loadNumS = 2, 2, 2, 2


sendDebugMessage ("Mod Path: "..usable_path)
local p = io.popen('dir /b "'..usable_path..'skins//"')

------------------
--- Load Skins ---
------------------
for file in p:lines() do
    sendDebugMessage(file .. " found!")
    if file:match("%.lua$") then
        local skin = SMODS.load_file("skins/" .. file)()
        local id = file:sub(1, -5)

        if skin.suit == "C" or skin.suit == "c" or skin.suit == "clubs" or skin.suit == "Clubs" then
            G.COLLABS.options.Clubs[#G.COLLABS.options.Clubs + 1] = id
            loadNumC = loadNumC + 1
            G.localization.misc.collabs.Clubs[tostring(loadNumC)] = skin.name
        end
        if skin.suit == "H" or skin.suit == "h" or skin.suit == "hearts" or skin.suit == "Hearts" then
            G.COLLABS.options.Hearts[#G.COLLABS.options.Hearts + 1] = id
            loadNumH = loadNumH + 1
            G.localization.misc.collabs.Hearts[tostring(loadNumH)] = skin.name
        end
        if skin.suit == "D" or skin.suit == "d" or skin.suit == "diamonds" or skin.suit == "Diamonds" then
            G.COLLABS.options.Diamonds[#G.COLLABS.options.Diamonds + 1] = id
            loadNumD = loadNumD + 1
            G.localization.misc.collabs.Diamonds[tostring(loadNumD)] = skin.name
        end
        if skin.suit == "S" or skin.suit == "s" or skin.suit == "spades" or skin.suit == "Spades" then
            G.COLLABS.options.Spades[#G.COLLABS.options.Spades + 1] = id
            loadNumS = loadNumS + 1
            G.localization.misc.collabs.Spades[tostring(loadNumS)] = skin.name
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

        SMODS.Atlas{
            key = id .. "_1",
            path = texture1,
            px = 71,
            py = 95,
            atlas_table = 'ASSET_ATLAS',
            raw_key = true,
        }
        SMODS.Atlas{
            key = id .. "_2",
            path = texture2,
            px = 71,
            py = 95,
            atlas_table = 'ASSET_ATLAS',
            raw_key = true,
        }
    end
end

-----------------------------------
--- Full Friends of Jimbo Decks ---
-----------------------------------
SMODS.Atlas{
    key = "collab_AU_1",
    path = "collabs/collab_AU_Full_1.png",
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
    raw_key = true,
}

SMODS.Atlas{
    key = "collab_AU_2",
    path = "collabs/collab_AU_Full_2.png",
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
    raw_key = true,
}

SMODS.Atlas{
    key = "collab_TW_1",
    path = "collabs/collab_TW_Full_1.png",
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
    raw_key = true,
}

SMODS.Atlas{
    key = "collab_TW_2",
    path = "collabs/collab_TW_Full_2.png",
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
    raw_key = true,
}

SMODS.Atlas{
    key = "collab_VS_1",
    path = "collabs/collab_VS_Full_1.png",
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
    raw_key = true,
}

SMODS.Atlas{
    key = "collab_VS_2",
    path = "collabs/collab_VS_Full_2.png",
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
    raw_key = true,
}
SMODS.Atlas{
    key = "collab_DTD_1",
    path = "collabs/collab_DTD_Full_1.png",
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
    raw_key = true,
}

SMODS.Atlas{
    key = "collab_DTD_2",
    path = "collabs/collab_DTD_Full_2.png",
    px = 71,
    py = 95,
    atlas_table = 'ASSET_ATLAS',
    raw_key = true,
}

-------------------
--- Credits Tab ---
-------------------
SMODS.current_mod.credits_tab = function()
    local text_scale = 0.9
    chosen = true
    return {n=G.UIT.ROOT, config={align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 10}, nodes={
        {n=G.UIT.R, config={align = "cm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Created by', scale = text_scale*0.6, colour = G.C.GOLD, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'Keku', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.T, config={text = 'lovely.toml Patch File by', scale = text_scale*0.6, colour = G.C.RED, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.T, config={text = '#Guigui & OneSuchKeeper', scale = text_scale*0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
        }},
    }}
end
----------------------------------------------
------------MOD CODE END----------------------