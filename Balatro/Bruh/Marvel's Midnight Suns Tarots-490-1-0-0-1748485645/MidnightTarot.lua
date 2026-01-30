--- STEAMODDED HEADER
--- MOD_NAME: Marvel's Midnight Suns Tarot Cards
--- MOD_ID: MidnightTs
--- MOD_AUTHOR: [SeijiPuu]
--- MOD_DESCRIPTION: Marvel's Midnight Suns themed tarot cards by bruhhsalt
--- LOADER_VERSION_GEQ: 1.0.0
--- VERSION: 1.0.0
--- BADGE_COLOR: FFA500

function SMODS.INIT.NegateTexturePack()

    local midnight_tarot = SMODS.findModByID("MidnightTs")
    local sprite_trt = SMODS.Sprite:new("Tarot", midnight_tarot.path, "midnight-tarots.png", 71, 95, "asset_atli")


    sprite_trt:register()
end

-----------------------------------------------------------
-- You should only need to change things above this line --
-----------------------------------------------------------

-- Registers the mod icon
SMODS.Atlas { -- modicon
  key = 'modicon',
  px = 32,
  py = 32,
  path = 'modicon.png'
}