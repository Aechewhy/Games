--- STEAMODDED HEADER
--- MOD_NAME: Fancy Decks
--- MOD_ID: FancyDecks
--- MOD_AUTHOR: [NoScope1080]
--- MOD_DESCRIPTION: Card Back Textures inspired by real card decks.

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.FancyDecks()

    local fancy_mod = SMODS.findModByID("FancyDecks")
    local sprite_enhancer = SMODS.Sprite:new("centers", fancy_mod.path, "FancyDecks.png", 71, 95, "asset_atli")
 
    sprite_enhancer:register()
    
end

----------------------------------------------
------------MOD CODE END----------------------
