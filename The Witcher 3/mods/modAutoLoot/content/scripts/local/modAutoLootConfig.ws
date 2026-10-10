/***********************************************************************/
/** 	AutoLoot Next-Gen Mod - Configuration Manager
/** 	Provides typed access and safe defaults to user options.
/***********************************************************************/
struct SAutoLootFeedItem
{
	var itemName : name;
	var quantity : int;
};

class W3AutoLootConfig
{
	private var inGameConfig : CInGameConfigWrapper;
	
	public function UpdateConfig()
	{
		inGameConfig = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		if ( inGameConfig )
		{
			CheckAndSeedDefaults();
		}
	}
	
	private function GetConfig() : CInGameConfigWrapper
	{
		if (!inGameConfig)
		{
			UpdateConfig();
		}
		return inGameConfig;
	}

	private function CheckAndSeedDefaults()
	{
		var changed : bool;
		changed = false;

		if ( EnsureVar( 'AutoLoot', 'AutoLootEnabled', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'AutoLootMode', "0" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'PassiveHerbs', "false" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'AutoLootRadius', "12.0" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'AutoLootInterval', "0.5" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudStyle', "4" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudGroupItems', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudFeedHerbs', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudFeedEquipment', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudFeedAlchemy', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudFeedBooks', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudFeedJunk', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudFeedMoney', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'TheftMode', "0" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'TheftRadius', "16.0" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'TheftCheckLoS', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'TheftCheckAngle', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'TheftNotify', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootHerbs', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootCorpses', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootChests', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootContainers', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootPoICaches', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootQuest', "false" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootEquipment', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootAlchemyCrafting', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootBooks', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootJunk', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'LootMoney', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'DisableInCombat', "false" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'DisableOnHorse', "false" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'StopIfOverweight', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'InstantInteract', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'PlayLootSound', "true" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'PlayHerbAnim', "false" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'CustomRadiiEnabled', "false" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'RadiusHerbs', "15.0" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'RadiusCorpses', "8.0" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'RadiusContainers', "3.0" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudItemScale', "100" ) ) changed = true;
		if ( EnsureVar( 'AutoLoot', 'HudOpacity', "100" ) ) changed = true;

		if ( changed )
		{
			theGame.SaveUserSettings();
		}
	}

	private function EnsureVar( grp : name, varName : name, defaultVal : string ) : bool
	{
		if ( inGameConfig.GetVarValue( grp, varName ) == "" )
		{
			inGameConfig.SetVarValue( grp, varName, defaultVal );
			return true;
		}
		return false;
	}
	
	// Master toggle
	public function IsEnabled() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'AutoLootEnabled');
		if (val == "") return true;
		return val == "true";
	}
	
	// Mode: 0 = Both (Area + Interact AoE), 1 = Passive Area only, 2 = Single Interact only, 3 = Interact AoE only
	public function GetMode() : int
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'AutoLootMode');
		if (val == "") return 0;
		return StringToInt(val);
	}

	// Dedicated passive herb toggle (works even in Mode 2 and 3)
	public function GetPassiveHerbs() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'PassiveHerbs');
		if (val == "") return false;
		return val == "true";
	}
	
	// Loot radius in meters
	public function GetRadius() : float
	{
		var val : string;
		var r : float;
		val = GetConfig().GetVarValue('AutoLoot', 'AutoLootRadius');
		if (val == "") return 12.0f;
		r = StringToFloat(val);
		if (r <= 0.0f) return 12.0f;
		return r;
	}

	public function GetCustomRadiiEnabled() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'CustomRadiiEnabled');
		if (val == "") return false;
		return val == "true";
	}

	public function GetRadiusHerbs() : float
	{
		var val : string;
		var r : float;
		val = GetConfig().GetVarValue('AutoLoot', 'RadiusHerbs');
		if (val == "") return 15.0f;
		r = StringToFloat(val);
		if (r <= 0.0f) return 15.0f;
		return r;
	}

	public function GetRadiusCorpses() : float
	{
		var val : string;
		var r : float;
		val = GetConfig().GetVarValue('AutoLoot', 'RadiusCorpses');
		if (val == "") return 8.0f;
		r = StringToFloat(val);
		if (r <= 0.0f) return 8.0f;
		return r;
	}

	public function GetRadiusContainers() : float
	{
		var val : string;
		var r : float;
		val = GetConfig().GetVarValue('AutoLoot', 'RadiusContainers');
		if (val == "") return 3.0f;
		r = StringToFloat(val);
		if (r <= 0.0f) return 3.0f;
		return r;
	}

	public function GetMaxEffectiveRadius() : float
	{
		var r : float;
		r = GetRadius();
		if ( GetCustomRadiiEnabled() )
		{
			if ( GetRadiusHerbs() > r ) r = GetRadiusHerbs();
			if ( GetRadiusCorpses() > r ) r = GetRadiusCorpses();
			if ( GetRadiusContainers() > r ) r = GetRadiusContainers();
		}
		return r;
	}

	public function GetEffectiveRadiusForContainer( container : W3Container ) : float
	{
		if ( !GetCustomRadiiEnabled() )
		{
			return GetRadius();
		}

		if ( (W3Herb)container )
		{
			return GetRadiusHerbs();
		}

		if ( (W3ActorRemains)container )
		{
			return GetRadiusCorpses();
		}

		return GetRadiusContainers();
	}
	
	// Interval between scan pulses (seconds)
	public function GetInterval() : float
	{
		var val : string;
		var iv : float;
		val = GetConfig().GetVarValue('AutoLoot', 'AutoLootInterval');
		if (val == "") return 0.5f;
		iv = StringToFloat(val);
		if (iv <= 0.1f) return 0.5f;
		return iv;
	}

	// HUD Style:
	// 0 = Minimalist bottom message (thePlayer.DisplayHudMessage)
	// 1 = Side notification banner (ShowNotification)
	// 2 = Standard game popup
	// 3 = Disabled (silent)
	public function GetHudStyle() : int
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'HudStyle');
		if (val == "") return 0; // Default: Minimalist HUD message
		return StringToInt(val);
	}
	
	public function GetHudGroupItems() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'HudGroupItems');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetHudFeedHerbs() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'HudFeedHerbs');
		if (val == "") return true;
		return val == "true";
	}

	public function GetHudFeedEquipment() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'HudFeedEquipment');
		if (val == "") return true;
		return val == "true";
	}

	public function GetHudFeedAlchemy() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'HudFeedAlchemy');
		if (val == "") return true;
		return val == "true";
	}

	public function GetHudFeedBooks() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'HudFeedBooks');
		if (val == "") return true;
		return val == "true";
	}

	public function GetHudFeedJunk() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'HudFeedJunk');
		if (val == "") return true;
		return val == "true";
	}

	public function GetHudFeedMoney() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'HudFeedMoney');
		if (val == "") return true;
		return val == "true";
	}

	public function GetHudItemScale() : float
	{
		var val : string;
		var s : float;
		val = GetConfig().GetVarValue('AutoLoot', 'HudItemScale');
		if (val == "") return 1.0f;
		s = StringToFloat(val) / 100.0f;
		if (s < 0.5f) return 1.0f;
		return s;
	}

	public function GetHudOpacity() : float
	{
		var val : string;
		var op : float;
		val = GetConfig().GetVarValue('AutoLoot', 'HudOpacity');
		if (val == "") return 1.0f;
		op = StringToFloat(val) / 100.0f;
		if (op < 0.2f) return 1.0f;
		return op;
	}
	
	// Theft Mode:
	// 0 = Smart Safe (Skip if witnessed with consequences)
	// 1 = Never Steal (Always skip containers marked as stealing)
	// 2 = Strict (Skip if any guard is within detection radius, even behind walls)
	// 3 = Always Steal (Ignore guards, steal regardless)
	public function GetTheftMode() : int
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'TheftMode');
		if (val == "") return 0;
		return StringToInt(val);
	}
	
	// Theft guard / witness detection radius
	public function GetTheftRadius() : float
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'TheftRadius');
		if (val == "") return 16.0f;
		return StringToFloat(val);
	}
	
	// Check Line of Sight for witnesses/guards
	public function GetTheftCheckLoS() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'TheftCheckLoS');
		if (val == "") return true;
		return val == "true";
	}
	
	// Check facing angle (FOV) for witnesses/guards
	public function GetTheftCheckAngle() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'TheftCheckAngle');
		if (val == "") return true;
		return val == "true";
	}
	
	// Notify on theft skip
	public function GetTheftNotify() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'TheftNotify');
		if (val == "") return true;
		return val == "true";
	}
	
	// Source Filters
	public function GetLootHerbs() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootHerbs');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetLootCorpses() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootCorpses');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetLootChests() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootChests');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetLootContainers() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootContainers');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetLootPoICaches() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootPoICaches');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetLootQuest() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootQuest');
		if (val == "") return false;
		return val == "true";
	}
	
	// Category Filters
	public function GetLootEquipment() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootEquipment');
		if (val == "") return true;
		return val == "true";
	}

	public function GetIgnoreCommonEquipment() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'IgnoreCommonEquipment');
		if (val == "") return false;
		return val == "true";
	}
	
	public function GetLootAlchemyCrafting() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootAlchemyCrafting');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetLootBooks() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootBooks');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetLootJunk() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootJunk');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetLootMoney() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'LootMoney');
		if (val == "") return true;
		return val == "true";
	}
	
	// Gameplay conditions
	public function GetDisableInCombat() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'DisableInCombat');
		if (val == "") return false;
		return val == "true";
	}
	
	public function GetDisableOnHorse() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'DisableOnHorse');
		if (val == "") return false;
		return val == "true";
	}
	
	public function GetStopIfOverweight() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'StopIfOverweight');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetInstantInteract() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'InstantInteract');
		if (val == "") return true;
		return val == "true";
	}
	
	public function GetPlayLootSound() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'PlayLootSound');
		if (val == "") return true;
		return val == "true";
	}

	public function GetPlayHerbAnim() : bool
	{
		var val : string;
		val = GetConfig().GetVarValue('AutoLoot', 'PlayHerbAnim');
		if (val == "") return false;
		return val == "true";
	}
}

