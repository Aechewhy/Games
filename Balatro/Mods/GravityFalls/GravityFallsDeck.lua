--- STEAMODDED HEADER
--- MOD_NAME: Gravity Falls
--- MOD_ID: GravityFalls
--- PREFIX: GravityFalls
--- MOD_AUTHOR: [therealdan55]
--- MOD_DESCRIPTION: Gravity Falls Cards
--- LOADER_VERSION_GEQ: 1.0.0
--- VERSION: 1.0.1
--- BADGE_COLOR: EBCF34

local atlas_key = 'GravityFalls'-- Format: PREFIX_KEY
-- See end of file for notes
local atlas_path = 'GravityFalls.png' -- Filename for the image in the asset folder
local atlas_path_hc = 'GravityFalls_hc.png' -- Filename for the high-contrast version of the texture, if existing

local suits = {'spades', 'diamonds', 'hearts', 'clubs'} -- Which suits to replace
local ranks = {'Jack', 'Queen', "King", 'Ace'} -- Which ranks to replace

local description = 'Gravity Falls' -- English-language description, also used as default


SMODS.Atlas { -- modicon
  key = 'modicon',
  px = 32,
  py = 32,
  path = 'modicon.png'
}

SMODS.Atlas{  
    key = atlas_key..'_lc',
    px = 71,
    py = 95,
    path = atlas_path,
    prefix_config = {key = false}, -- See end of file for notes
}

if atlas_path_hc then
    SMODS.Atlas{  
        key = atlas_key..'_hc',
        px = 71,
        py = 95,
        path = atlas_path_hc,
        prefix_config = {key = false}, -- See end of file for notes
    }
end

for _, suit in ipairs(suits) do
    SMODS.DeckSkin{
        key = suit.."_skin",
        suit = suit:gsub("^%l", string.upper),
        ranks = ranks,
        lc_atlas = atlas_key..'_lc',
        hc_atlas = (atlas_path_hc and atlas_key..'_hc') or atlas_key..'_lc',
        loc_txt = {
            ['en-us'] = description
        },
        posStyle = 'deck'
    }
end