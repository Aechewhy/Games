--- STEAMODDED HEADER
--- MOD_NAME: rusty lake deck
--- MOD_ID: rustydeck
--- PREFIX: rusty
--- MOD_AUTHOR: [pixal]
--- MOD_DESCRIPTION: replaces the entire deck with rusty lake characters and symbols (inspired from the official card deck released by rusty lake)

------------------------------------------------
------------------------------------------------

ranks = {"2","3","4","5","6","7","8","9","10","Jack", "Queen", "King", "Ace"}

SMODS.Atlas {
	key = 'rustyplace',
	px = 71,
	py = 95,
	disable_mipmap = true,
	path = 'rustydeck.png'
    }
	
SMODS.Atlas {
	key = 'rustyplace_hc',
	px = 71,
	py = 95,
	disable_mipmap = true,
	path = 'rustydeck_hc.png'
    }
	

SMODS.DeckSkin ({
	key = 'Hotel',
	suit = "Hearts",
	ranks = ranks,
	lc_atlas = 'rusty_rustyplace',
	hc_atlas = 'rusty_rustyplace_hc',
	loc_txt = {
        ['en-us'] = 'Hotel'
    },
	pos_style = 'deck'
	})

SMODS.DeckSkin ({
	key = 'Past within',
	suit = "Clubs",
	ranks = ranks,
	lc_atlas = 'rusty_rustyplace',
	hc_atlas = 'rusty_rustyplace_hc',
	loc_txt = {
        ['en-us'] = 'Past within'
    },
	pos_style = 'deck'
	})

SMODS.DeckSkin ({
	key = 'Samsara',
	suit = "Spades",
	ranks = ranks,
	lc_atlas = 'rusty_rustyplace',
	hc_atlas = 'rusty_rustyplace_hc',
	loc_txt = {
        ['en-us'] = 'Samsara'
    },
	pos_style = 'deck'
	})

SMODS.DeckSkin ({
	key = 'Paradox',
	suit = "Diamonds",
	ranks = ranks,
	lc_atlas = 'rusty_rustyplace',
	hc_atlas = 'rusty_rustyplace_hc',
	loc_txt = {
        ['en-us'] = 'Paradox'
    },
	pos_style = 'deck'
	})


------------------------------------------------
------------------------------------------------


------------------------------------------------
-----------------------------------------------------------------------------------------------