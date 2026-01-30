--- STEAMODDED HEADER
--- MOD_NAME: RPG Classes
--- MOD_ID: ADeckCreatorModule
--- MOD_AUTHOR: [playfulrainbow]
--- MOD_DESCRIPTION: Starter Class Decks based on various different RPG classes! Special thanks to Nyoxide as this mod wouldn't be possible without him.

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.RPGClassDeck()

    local rpg_class_deck = SMODS.findModByID("ADeckCreatorModule")
    local sprite_enhancer = SMODS.Sprite:new("centers", rpg_class_deck.path, "RPGClassDecks.png", 71, 95, "asset_atli")
 
    sprite_enhancer:register()
    
end

DKC = SMODS.current_mod
local moduleCache = {}

local function customLoader(moduleName)
    local filename = moduleName:gsub("%.", "/") .. ".lua"
    if moduleCache[filename] then
        return moduleCache[filename]
    end

    local filePath = "Mods/RPG Classes/" .. filename
    local fileContent = love.filesystem.read(filePath)
    if fileContent then
        local moduleFunc = assert(load(fileContent, "@"..filePath))
        moduleCache[filename] = moduleFunc
        return moduleFunc
    end

    return "\nNo module found: " .. moduleName
end

-- Balamod
if mods ~= nil then
    table.insert(package.loaders, 1, customLoader)
    local mod = require "DeckCreator"
    require "ModloaderHelper".BalamodLoaded = true
    table.insert(mods, {
        mod_id = "ADeckCreatorModule",
        name = "RPG Classes",
        version = "1.2.2",
        author = "playfulrainbow",
        menu = "DeckCreatorModuleOpenMainMenu",
        description = require "Utils".modDescription(),
        enabled = true,
        on_enable = function()
            mod.Enable()
        end,
        on_disable = function()
            mod.Disable()
        end
    })
end
if SMODS == nil or SMODS.INIT == nil then
    SMODS = {}
    SMODS.INIT = {}
end

-- Steamodded
function SMODS.INIT.DeckCreatorModule()
    table.insert(package.loaders, 1, customLoader)
    local Loader = require "ModloaderHelper"
    Loader.SteamoddedLoaded = true
    if Loader.BalamodLoaded == false then
        require "DeckCreator".Enable(DKC)
    end
end

----------------------------------------------
------------MOD CODE END----------------------
