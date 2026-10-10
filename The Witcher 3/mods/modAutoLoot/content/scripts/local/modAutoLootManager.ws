/***********************************************************************/
/** 	AutoLoot Next-Gen Mod - Main Manager
/** 	Coordinates area scanning, filtered loot transfers, theft safety,
/** 	and the minimalist HUD display.
/***********************************************************************/
class W3AutoLootManager
{
	private var m_player 			: W3PlayerWitcher;
	public  var config 				: W3AutoLootConfig;
	private var lastTheftWarnTime 	: float;
	private var isScanning 			: bool;
	private var m_collectedPulseItems : array<SAutoLootFeedItem>;
	
	default lastTheftWarnTime 		= 0.0f;
	default isScanning 				= false;

	public function RecordLootedItem( itemName : name, quantity : int )
	{
		var i : int;
		var feedItem : SAutoLootFeedItem;

		for ( i = 0; i < m_collectedPulseItems.Size(); i += 1 )
		{
			if ( m_collectedPulseItems[i].itemName == itemName )
			{
				m_collectedPulseItems[i].quantity += quantity;
				return;
			}
		}

		feedItem.itemName = itemName;
		feedItem.quantity = quantity;
		m_collectedPulseItems.PushBack( feedItem );
	}

	public function ShowAutoLootBox( items : array<SAutoLootFeedItem> )
	{
		var lootPopup : CR4LootPopup;
		var lootData : W3LootPopupData;
		var player : W3PlayerWitcher;

		if ( items.Size() == 0 )
			return;

		player = GetWitcherPlayer();
		if ( !player )
			return;

		lootPopup = (CR4LootPopup)theGame.GetGuiManager().GetPopup( 'LootPopup' );
		if ( lootPopup && lootPopup.IsAutoLootPopup() )
		{
			lootPopup.AppendAutoLootItems( items );
			player.RemoveTimer( 'AutoLootClosePopupTimer' );
			player.AddTimer( 'AutoLootClosePopupTimer', 2.5, false );
		}
		else
		{
			lootData = new W3LootPopupData in this;
			lootData.isAutoLootPopup = true;
			lootData.autoLootItems = items;

			theGame.RequestPopup( 'LootPopup', lootData );
			player.RemoveTimer( 'AutoLootClosePopupTimer' );
			player.AddTimer( 'AutoLootClosePopupTimer', 2.5, false );
		}
	}

	public function Init( witcherPlayer : W3PlayerWitcher )
	{
		m_player = witcherPlayer;
		config = new W3AutoLootConfig in this;
		config.UpdateConfig();
	}

	public function GetConfig() : W3AutoLootConfig
	{
		return config;
	}


	public function StartTimer()
	{
		if ( !m_player )
		{
			m_player = GetWitcherPlayer();
		}

		if ( m_player )
		{
			m_player.RemoveTimer( 'AutoLootPulseTimer' );
			m_player.AddTimer( 'AutoLootPulseTimer', config.GetInterval(), true );
		}
	}

	public function OnTimerPulse()
	{
		if ( isScanning )
			return;

		if ( !m_player )
		{
			m_player = GetWitcherPlayer();
		}

		if ( !config.IsEnabled() )
			return;

		// If in Mode 2 (Single interact) or Mode 3 (AoE interact), only pulse if PassiveHerbs is enabled
		if ( ( config.GetMode() == 2 || config.GetMode() == 3 ) && !config.GetPassiveHerbs() )
			return;

		if ( !m_player || !m_player.IsAlive() )
			return;

		if ( theGame.IsBlackscreenOrFading() || theGame.IsDialogOrCutscenePlaying() )
			return;

		if ( config.GetDisableInCombat() && m_player.IsInCombat() )
			return;

		if ( config.GetDisableOnHorse() && m_player.IsUsingHorse() )
			return;

		isScanning = true;
		PulseAreaLoot( m_player, NULL, ( ( config.GetMode() == 2 || config.GetMode() == 3 ) && config.GetPassiveHerbs() ) );
		isScanning = false;
	}

	public function PulseAreaLoot( player : CR4Player, optional skipContainer : W3Container, optional onlyHerbs : bool )
	{
		var entities 	: array<CGameplayEntity>;
		var i 			: int;
		var container 	: W3Container;
		var scanRadius 	: float;
		var effRadius 	: float;

		if ( !player )
		{
			player = thePlayer;
		}

		if ( onlyHerbs && config.GetCustomRadiiEnabled() )
		{
			scanRadius = config.GetRadiusHerbs();
		}
		else
		{
			scanRadius = config.GetMaxEffectiveRadius();
		}

		FindGameplayEntitiesInRange( entities, player, scanRadius, 200 );

		for ( i = 0; i < entities.Size(); i += 1 )
		{
			container = (W3Container)entities[i];
			if ( container && container != skipContainer )
			{
				if ( container.IsEmpty() )
				{
					continue;
				}

				// When onlyHerbs is true (e.g. Passive Herbs toggle active in Mode 2 or 3), skip non-herbs
				if ( onlyHerbs && !((W3Herb)container) )
				{
					continue;
				}

				// Check per-category effective radius if custom radii are enabled
				if ( config.GetCustomRadiiEnabled() )
				{
					effRadius = config.GetEffectiveRadiusForContainer( container );
					if ( VecDistance( player.GetWorldPosition(), container.GetWorldPosition() ) > effRadius )
					{
						continue;
					}
				}

				ProcessSingleContainer( container, player, false );
			}
		}

		if ( config.GetHudStyle() == 5 && m_collectedPulseItems.Size() > 0 )
		{
			ShowAutoLootBox( m_collectedPulseItems );
			m_collectedPulseItems.Clear();
		}
	}

	public function OnContainerInteracted( container : W3Container ) : bool
	{
		var res : bool;
		var shouldInstant : bool;

		if ( !config.IsEnabled() )
		{
			return false;
		}

		if ( !m_player )
		{
			m_player = GetWitcherPlayer();
		}

		shouldInstant = config.GetInstantInteract();

		// Corvo Bianco weapon/armor stands and display mounts: never instant-loot, open normal interaction
		if ( (W3HouseDecorationBase)container || (W3DisplayMount)container )
		{
			shouldInstant = false;
		}

		// Dropped item bag: always open normally so player can inspect and manage dropped loot manually
		if ( container.HasTag( 'lootbag' ) )
		{
			shouldInstant = false;
		}

		// If quest container and quest looting is disabled, do not instant loot - let player open container normally
		if ( !config.GetLootQuest() && IsContainerQuestRelated( container ) )
		{
			shouldInstant = false;
		}

		// Containers locked by a key: always open normally so the vanilla Unlock interaction,
		// key consumption, and quest scripts (e.g. "Tough Luck") execute in proper sequence!
		if ( container.lockedByKey )
		{
			shouldInstant = false;
		}

		// Bounty monster remains with trophies: always open normally to play cutscene/dismemberment and advance contract
		if ( (W3ActorRemains)container && ( ((W3ActorRemains)container).HasTrophyItems() || ((W3ActorRemains)container).dismemberOnLoot ) )
		{
			shouldInstant = false;
		}

		// If PoI cache and PoI looting is disabled, do not instant loot
		if ( !config.GetLootPoICaches() && IsPoICache( container ) )
		{
			shouldInstant = false;
		}

		// If chests looting is disabled, do not instant loot chests
		if ( !config.GetLootChests() && IsChestContainer( container ) )
		{
			shouldInstant = false;
		}

		// If general containers looting is disabled, do not instant loot sacks/barrels
		if ( !config.GetLootContainers() && !IsChestContainer( container ) && !((W3Herb)container) && !((W3ActorRemains)container) )
		{
			shouldInstant = false;
		}

		if ( shouldInstant )
		{
			res = ProcessSingleContainer( container, m_player, true );
		}
		else
		{
			res = false;
		}

		// If mode includes area looting on interaction (Mode 0 = Both, Mode 3 = AoE on interact)
		if ( config.GetMode() == 0 || config.GetMode() == 3 )
		{
			isScanning = true;
			// If we didn't instant-loot this container, skip it in the AoE sweep so its GUI window opens cleanly
			if ( !res )
			{
				PulseAreaLoot( m_player, container, false );
			}
			else
			{
				PulseAreaLoot( m_player, NULL, false );
			}
			isScanning = false;
		}

		if ( config.GetHudStyle() == 5 && m_collectedPulseItems.Size() > 0 )
		{
			ShowAutoLootBox( m_collectedPulseItems );
			m_collectedPulseItems.Clear();
		}

		return res;
	}

	public function IsPlayerOverweight( optional extraEncumbrance : float ) : bool
	{
		var witcher : W3PlayerWitcher;
		var hasHorseBonus : bool;
		var maxEnc : float;

		witcher = GetWitcherPlayer();
		if ( !witcher )
		{
			return false;
		}

		maxEnc = witcher.GetMaxRunEncumbrance( hasHorseBonus );
		return ( witcher.GetEncumbrance() + extraEncumbrance ) >= maxEnc;
	}

	public function IsPoICache( container : W3Container ) : bool
	{
		var cInv 		: CInventoryComponent;
		var allItems 	: array<SItemUniqueId>;
		var i 			: int;
		var itemName 	: string;
		var factName 	: string;
		var cName 		: string;
		var mapPins 	: array<CGameplayEntity>;

		if ( !container )
		{
			return false;
		}

		// Witcher gear diagrams / Scavenger Hunts should NEVER be treated as open-world PoI caches
		if ( ContainerContainsWitcherDiagram( container ) )
		{
			return false;
		}

		// Explicitly typed treasure hunt containers (W3 internal class)
		if ( (W3treasureHuntContainer)container )
		{
			return true;
		}

		// Explicit PoI tags used by the world design team for exploration caches
		if ( container.HasTag( 'BanditCamp' ) || container.HasTag( 'bandit_camp' ) ||
			 container.HasTag( 'BanditCampfire' ) || container.HasTag( 'bandit_campfire' ) ||
			 container.HasTag( 'BossAndTreasure' ) || container.HasTag( 'TreasureHunt' ) ||
			 container.HasTag( 'Contraband' ) || container.HasTag( 'SpoilsOfWar' ) ||
			 container.HasTag( 'Treasure' ) || container.HasTag( 'treasure' ) ||
			 container.HasTag( 'poi' ) || container.HasTag( 'PoI' ) || container.HasTag( 'POI' ) ||
			 container.HasTag( 'bandit' ) || container.HasTag( 'Bandit' ) ||
			 container.HasTag( 'LivingWorld' ) || container.HasTag( 'living_world' ) ||
			 container.HasTag( 'exploration' ) || container.HasTag( 'Exploration' ) )
		{
			return true;
		}

		// Check container entity name
		cName = StrLower( container.GetName() );
		if ( StrFindFirst( cName, "bandit" ) >= 0 ||
			 StrFindFirst( cName, "camp" ) >= 0 ||
			 StrFindFirst( cName, "treasure" ) >= 0 ||
			 StrFindFirst( cName, "poi" ) >= 0 ||
			 StrFindFirst( cName, "spoils" ) >= 0 ||
			 StrFindFirst( cName, "contraband" ) >= 0 ||
			 StrFindFirst( cName, "deserter" ) >= 0 ||
			 StrFindFirst( cName, "pirate" ) >= 0 )
		{
			return true;
		}

		// Check factOnContainerOpened for open-world exploration patterns
		factName = StrLower( container.factOnContainerOpened );
		if ( StrLen( factName ) > 0 )
		{
			if ( StrFindFirst( factName, "bandit" ) >= 0 ||
				 StrFindFirst( factName, "camp" ) >= 0 ||
				 StrFindFirst( factName, "boss" ) >= 0 ||
				 StrFindFirst( factName, "treasure" ) >= 0 ||
				 StrFindFirst( factName, "spoils" ) >= 0 ||
				 StrFindFirst( factName, "contraband" ) >= 0 ||
				 StrFindFirst( factName, "poi" ) >= 0 ||
				 StrFindFirst( factName, "lw_" ) >= 0 ||
				 StrFindFirst( factName, "lw" ) >= 0 ||
				 StrFindFirst( factName, "bc_" ) >= 0 ||
				 StrFindFirst( factName, "bc" ) >= 0 ||
				 StrFindFirst( factName, "bcf_" ) >= 0 ||
				 StrFindFirst( factName, "bcf" ) >= 0 ||
				 StrFindFirst( factName, "deserter" ) >= 0 ||
				 StrFindFirst( factName, "cannibal" ) >= 0 ||
				 StrFindFirst( factName, "pirate" ) >= 0 ||
				 StrFindFirst( factName, "smuggl" ) >= 0 ||
				 StrFindFirst( factName, "ruin" ) >= 0 ||
				 StrFindFirst( factName, "outpost" ) >= 0 ||
				 StrFindFirst( factName, "stash" ) >= 0 ||
				 StrFindFirst( factName, "cache" ) >= 0 )
			{
				return true;
			}
		}

		// Check if container contains exploration treasure note or bandit order
		cInv = container.GetInventory();
		if ( cInv )
		{
			cInv.GetAllItems( allItems );
			for ( i = 0; i < allItems.Size(); i += 1 )
			{
				itemName = StrLower( NameToString( cInv.GetItemName( allItems[i] ) ) );
				if ( StrFindFirst( itemName, "treasure_map" ) >= 0 ||
					 StrFindFirst( itemName, "treasure_note" ) >= 0 ||
					 StrFindFirst( itemName, "poi_treasure" ) >= 0 ||
					 StrFindFirst( itemName, "bandit" ) >= 0 ||
					 StrFindFirst( itemName, "order" ) >= 0 ||
					 StrFindFirst( itemName, "letter" ) >= 0 ||
					 StrFindFirst( itemName, "note" ) >= 0 ||
					 StrFindFirst( itemName, "rozkaz" ) >= 0 ||
					 StrFindFirst( itemName, "list" ) >= 0 ||
					 StrFindFirst( itemName, "zapiski" ) >= 0 )
				{
					if ( StrLen( factName ) > 0 || (W3AnimatedContainer)container )
					{
						return true;
					}
				}
			}
		}

		// Check if container is located near a MapPin PoI entity (within 60 meters)
		FindGameplayEntitiesInRange( mapPins, container, 60.0f, 5, '', 0, NULL, 'CR4MapPinEntity' );
		if ( mapPins.Size() > 0 )
		{
			for ( i = 0; i < mapPins.Size(); i += 1 )
			{
				if ( (W3POI_BanditCampEntity)mapPins[i] ||
					 (W3POI_BanditCampfireEntity)mapPins[i] ||
					 (W3POI_BossAndTreasureEntity)mapPins[i] ||
					 (W3POI_ContrabandEntity)mapPins[i] ||
					 (W3POI_ContrabandShipEntity)mapPins[i] ||
					 (W3POI_SpoilsOfWarEntity)mapPins[i] ||
					 (W3POI_DungeonCrawlEntity)mapPins[i] ||
					 (W3POI_HideoutEntity)mapPins[i] ||
					 (W3POI_KnightErrantEntity)mapPins[i] ||
					 (W3POI_PlegmundEntity)mapPins[i] ||
					 (W3POI_RescuingTownEntity)mapPins[i] )
				{
					return true;
				}
			}
		}

		return false;
	}

	public function IsContainerQuestRelated( container : W3Container ) : bool
	{
		var remains : W3ActorRemains;

		if ( !container )
		{
			return false;
		}

		// Witcher gear diagrams (Bear, Griffin, Feline/Lynx, Wolf, Viper, Manticore) are associated
		// with Scavenger Hunt quests. Always protect them from passive radius looting through cave ceilings/ruins!
		if ( ContainerContainsWitcherDiagram( container ) )
		{
			return true;
		}

		// Containers locked by a key require the player to unlock them (e.g. "Tough Luck")
		if ( container.lockedByKey )
		{
			return true;
		}

		// Contract / bounty monster remains with trophy or dismemberment
		remains = (W3ActorRemains)container;
		if ( remains )
		{
			if ( remains.HasTrophyItems() || remains.dismemberOnLoot || remains.HasQuestItem() )
			{
				return true;
			}
		}

		// Explicit story quest entities and tags on the container itself
		if ( container.HasTag( 'Quest' ) || container.HasTag( 'quest' ) || container.HasTag( 'QuestItem' ) || container.HasTag( 'quest_item' ) )
		{
			return true;
		}

		// Clue stashes and investigation objects
		if ( container.HasTag( 'Clue' ) || container.HasTag( 'clue' ) )
		{
			return true;
		}

		// Exploration PoI caches (Bandit Camps, Guarded Treasures, etc.) are open-world exploration points,
		// NOT protected story quests! Even if they contain a letter/note tagged with 'Quest'.
		if ( IsPoICache( container ) )
		{
			return false;
		}

		// Containers holding quest items (e.g. quest chests, corpses with quest notes/letters)
		if ( container.HasQuestItem() )
		{
			return true;
		}

		return false;
	}

	public function ContainerContainsWitcherDiagram( container : W3Container ) : bool
	{
		var cInv : CInventoryComponent;
		var allItems : array<SItemUniqueId>;
		var i : int;
		var itemName : string;
		var itemCategory : name;

		if ( !container )
		{
			return false;
		}

		cInv = container.GetInventory();
		if ( !cInv )
		{
			return false;
		}

		cInv.GetAllItems( allItems );
		for ( i = 0; i < allItems.Size(); i += 1 )
		{
			// Check direct item tags
			if ( cInv.ItemHasTag( allItems[i], 'WitcherGear' ) || cInv.ItemHasTag( allItems[i], 'witcher_gear' ) ||
				 cInv.ItemHasTag( allItems[i], 'WitcherSet' ) || cInv.ItemHasTag( allItems[i], 'ScavengerHunt' ) )
			{
				return true;
			}

			itemCategory = cInv.GetItemCategory( allItems[i] );
			if ( itemCategory == 'crafting_schematic' || itemCategory == 'alchemy_recipe' || cInv.ItemHasTag( allItems[i], 'Quest' ) || cInv.IsItemQuest( allItems[i] ) )
			{
				itemName = StrLower( NameToString( cInv.GetItemName( allItems[i] ) ) );
				if ( StrFindFirst( itemName, "bear" ) >= 0 ||
					 StrFindFirst( itemName, "ursine" ) >= 0 ||
					 StrFindFirst( itemName, "lynx" ) >= 0 ||
					 StrFindFirst( itemName, "feline" ) >= 0 ||
					 StrFindFirst( itemName, "cat" ) >= 0 ||
					 StrFindFirst( itemName, "gryphon" ) >= 0 ||
					 StrFindFirst( itemName, "griffin" ) >= 0 ||
					 StrFindFirst( itemName, "wolf" ) >= 0 ||
					 StrFindFirst( itemName, "wolven" ) >= 0 ||
					 StrFindFirst( itemName, "viper" ) >= 0 ||
					 StrFindFirst( itemName, "manticore" ) >= 0 ||
					 StrFindFirst( itemName, "crane" ) >= 0 ||
					 StrFindFirst( itemName, "witcher" ) >= 0 )
				{
					return true;
				}
			}
		}

		return false;
	}

	public function IsUnderwaterContainer( container : W3Container ) : bool
	{
		var cPos : Vector;
		var cName : string;

		if ( !container )
		{
			return false;
		}

		if ( container.HasTag( 'underwater' ) || container.HasTag( 'Underwater' ) ||
		     container.HasTag( 'sunken' ) || container.HasTag( 'Sunken' ) )
		{
			return true;
		}

		cName = StrLower( container.GetName() );
		if ( StrFindFirst( cName, "underwater" ) >= 0 || StrFindFirst( cName, "sunken" ) >= 0 )
		{
			return true;
		}

		cPos = container.GetWorldPosition();
		if ( theGame.GetWorld().GetWaterLevel( cPos, true ) > cPos.Z + 0.1 )
		{
			return true;
		}

		return false;
	}

	public function IsSackOrBarrel( container : W3Container ) : bool
	{
		var cName     : string;
		var dName     : string;
		var comps     : array<CComponent>;
		var compName  : string;
		var i         : int;

		if ( !container )
		{
			return false;
		}

		// Submerged containers in water are never sacks or barrels
		if ( IsUnderwaterContainer( container ) )
		{
			return false;
		}

		if ( container.HasTag( 'barrel' ) || container.HasTag( 'Barrel' ) ||
		     container.HasTag( 'sack' ) || container.HasTag( 'Sack' ) ||
		     container.HasTag( 'basket' ) || container.HasTag( 'Basket' ) ||
		     container.HasTag( 'bag' ) || container.HasTag( 'Bag' ) ||
		     container.HasTag( 'pouch' ) || container.HasTag( 'Pouch' ) )
		{
			return true;
		}

		// Check localized in-game display name (what the player sees on the HUD / loot window title)
		dName = StrLower( container.GetDisplayName( true ) );
		if ( StrLen( dName ) == 0 )
		{
			dName = StrLower( container.GetDisplayName( false ) );
		}

		if ( StrLen( dName ) > 0 )
		{
			if ( StrFindFirst( dName, "barrel" ) >= 0 || StrFindFirst( dName, "sack" ) >= 0 ||
			     StrFindFirst( dName, "basket" ) >= 0 || StrFindFirst( dName, "bag" ) >= 0 ||
			     StrFindFirst( dName, "pouch" ) >= 0 || StrFindFirst( dName, "package" ) >= 0 ||
			     StrFindFirst( dName, "parcel" ) >= 0 ||
			     StrFindFirst( dName, "beczk" ) >= 0 || StrFindFirst( dName, "worek" ) >= 0 ||
			     StrFindFirst( dName, "kosz" ) >= 0 || StrFindFirst( dName, "sakiew" ) >= 0 ||
			     StrFindFirst( dName, "torb" ) >= 0 || StrFindFirst( dName, "paczk" ) >= 0 ||
			     StrFindFirst( dName, "fass" ) >= 0 || StrFindFirst( dName, "beutel" ) >= 0 ||
			     StrFindFirst( dName, "paket" ) >= 0 || StrFindFirst( dName, "tonneau" ) >= 0 ||
			     StrFindFirst( dName, "panier" ) >= 0 || StrFindFirst( dName, "bourse" ) >= 0 ||
			     StrFindFirst( dName, "paquet" ) >= 0 || StrFindFirst( dName, "cesta" ) >= 0 ||
			     StrFindFirst( dName, "bolsa" ) >= 0 || StrFindFirst( dName, "barile" ) >= 0 ||
			     StrFindFirst( dName, "botte" ) >= 0 || StrFindFirst( dName, "мешок" ) >= 0 ||
			     StrFindFirst( dName, "бочка" ) >= 0 || StrFindFirst( dName, "корзина" ) >= 0 ||
			     StrFindFirst( dName, "сумка" ) >= 0 )
			{
				return true;
			}
		}

		// Check internal entity template name
		cName = StrLower( container.GetName() );
		if ( StrFindFirst( cName, "barrel" ) >= 0 || StrFindFirst( cName, "sack" ) >= 0 ||
		     StrFindFirst( cName, "basket" ) >= 0 || StrFindFirst( cName, "bag" ) >= 0 ||
		     StrFindFirst( cName, "pouch" ) >= 0 || StrFindFirst( cName, "beczk" ) >= 0 ||
		     StrFindFirst( cName, "worek" ) >= 0 || StrFindFirst( cName, "kosz" ) >= 0 )
		{
			return true;
		}

		// Check component names
		comps = container.GetComponentsByClassName( 'CComponent' );
		for ( i = 0; i < comps.Size(); i += 1 )
		{
			compName = StrLower( comps[i].GetName() );
			if ( StrFindFirst( compName, "barrel" ) >= 0 || StrFindFirst( compName, "sack" ) >= 0 ||
			     StrFindFirst( compName, "basket" ) >= 0 || StrFindFirst( compName, "bag" ) >= 0 ||
			     StrFindFirst( compName, "pouch" ) >= 0 || StrFindFirst( compName, "beczk" ) >= 0 ||
			     StrFindFirst( compName, "worek" ) >= 0 || StrFindFirst( compName, "kosz" ) >= 0 )
			{
				return true;
			}
		}

		return false;
	}

	public function IsChestContainer( container : W3Container ) : bool
	{
		var cName     : string;
		var dName     : string;
		var cPos      : Vector;
		var animComp  : CAnimatedComponent;
		var comps     : array<CComponent>;
		var compName  : string;
		var i         : int;

		if ( !container )
		{
			return false;
		}

		// Monster and actor remains are never chests
		if ( (W3ActorRemains)container )
		{
			return false;
		}

		// Submerged containers in water bodies are always underwater / sunken chests
		if ( IsUnderwaterContainer( container ) )
		{
			return true;
		}

		// Sacks, barrels, baskets, and pouches are never chests
		if ( IsSackOrBarrel( container ) )
		{
			return false;
		}

		// Treasure hunt containers are always chests
		if ( (W3treasureHuntContainer)container )
		{
			return true;
		}

		// Locked containers requiring a key are always chests
		if ( container.IsLocked() || IsNameValid( container.GetKeyName() ) )
		{
			return true;
		}

		if ( container.HasTag( 'Chest' ) || container.HasTag( 'chest' ) ||
		     container.HasTag( 'Coffer' ) || container.HasTag( 'coffer' ) ||
		     container.HasTag( 'Trunk' ) || container.HasTag( 'trunk' ) ||
		     container.HasTag( 'Box' ) || container.HasTag( 'box' ) ||
		     container.HasTag( 'Crate' ) || container.HasTag( 'crate' ) ||
		     container.HasTag( 'Treasure' ) || container.HasTag( 'treasure' ) ||
		     container.HasTag( 'Sunken' ) || container.HasTag( 'sunken' ) ||
		     container.HasTag( 'Underwater' ) || container.HasTag( 'underwater' ) )
		{
			return true;
		}

		// Check localized in-game display name (covers Novigrad chests, underwater chests, furniture, etc.)
		dName = StrLower( container.GetDisplayName( true ) );
		if ( StrLen( dName ) == 0 )
		{
			dName = StrLower( container.GetDisplayName( false ) );
		}

		if ( StrLen( dName ) > 0 )
		{
			if ( StrFindFirst( dName, "chest" ) >= 0 || StrFindFirst( dName, "coffer" ) >= 0 ||
			     StrFindFirst( dName, "trunk" ) >= 0 || StrFindFirst( dName, "box" ) >= 0 ||
			     StrFindFirst( dName, "crate" ) >= 0 || StrFindFirst( dName, "nightstand" ) >= 0 ||
			     StrFindFirst( dName, "cupboard" ) >= 0 || StrFindFirst( dName, "wardrobe" ) >= 0 ||
			     StrFindFirst( dName, "cabinet" ) >= 0 || StrFindFirst( dName, "drawer" ) >= 0 ||
			     StrFindFirst( dName, "dresser" ) >= 0 || StrFindFirst( dName, "stash" ) >= 0 ||
			     StrFindFirst( dName, "skrzyn" ) >= 0 || StrFindFirst( dName, "kufer" ) >= 0 ||
			     StrFindFirst( dName, "szkatuł" ) >= 0 || StrFindFirst( dName, "szkatul" ) >= 0 ||
			     StrFindFirst( dName, "szaf" ) >= 0 || StrFindFirst( dName, "komod" ) >= 0 ||
			     StrFindFirst( dName, "schowek" ) >= 0 || StrFindFirst( dName, "truhe" ) >= 0 ||
			     StrFindFirst( dName, "kiste" ) >= 0 || StrFindFirst( dName, "kasten" ) >= 0 ||
			     StrFindFirst( dName, "schrank" ) >= 0 || StrFindFirst( dName, "coffre" ) >= 0 ||
			     StrFindFirst( dName, "boîte" ) >= 0 || StrFindFirst( dName, "boite" ) >= 0 ||
			     StrFindFirst( dName, "malle" ) >= 0 || StrFindFirst( dName, "armoire" ) >= 0 ||
			     StrFindFirst( dName, "baúl" ) >= 0 || StrFindFirst( dName, "baul" ) >= 0 ||
			     StrFindFirst( dName, "caja" ) >= 0 || StrFindFirst( dName, "armario" ) >= 0 ||
			     StrFindFirst( dName, "baule" ) >= 0 || StrFindFirst( dName, "forziere" ) >= 0 ||
			     StrFindFirst( dName, "cassa" ) >= 0 || StrFindFirst( dName, "сундук" ) >= 0 ||
			     StrFindFirst( dName, "шкаф" ) >= 0 || StrFindFirst( dName, "ящик" ) >= 0 )
			{
				return true;
			}
		}

		// Check internal entity template name
		cName = StrLower( container.GetName() );
		if ( StrFindFirst( cName, "chest" ) >= 0 || StrFindFirst( cName, "coffer" ) >= 0 ||
		     StrFindFirst( cName, "trunk" ) >= 0 || StrFindFirst( cName, "skrzyn" ) >= 0 ||
		     StrFindFirst( cName, "underwater" ) >= 0 || StrFindFirst( cName, "sunken" ) >= 0 ||
		     StrFindFirst( cName, "box" ) >= 0 || StrFindFirst( cName, "crate" ) >= 0 )
		{
			return true;
		}

		// Check component names (mesh names, lid names)
		comps = container.GetComponentsByClassName( 'CComponent' );
		for ( i = 0; i < comps.Size(); i += 1 )
		{
			compName = StrLower( comps[i].GetName() );
			if ( StrFindFirst( compName, "chest" ) >= 0 || StrFindFirst( compName, "coffer" ) >= 0 ||
			     StrFindFirst( compName, "trunk" ) >= 0 || StrFindFirst( compName, "lid" ) >= 0 ||
			     StrFindFirst( compName, "skrzyn" ) >= 0 || StrFindFirst( compName, "box" ) >= 0 )
			{
				return true;
			}
		}

		// Any container with an animated skeletal component (opening lid) is a chest or coffer!
		animComp = container.GetRootAnimatedComponent();
		if ( !animComp )
		{
			animComp = (CAnimatedComponent)container.GetComponentByClassName( 'CAnimatedComponent' );
		}
		if ( animComp )
		{
			return true;
		}

		return false;
	}

	public function ResetNearbyQuestPins( optional radius : float )
	{
		var entities : array<CGameplayEntity>;
		var i : int;
		var mapPin : CR4MapPinEntity;
		var mapManager : CCommonMapManager;

		mapManager = theGame.GetCommonMapManager();
		if ( !mapManager )
		{
			return;
		}

		if ( !m_player )
		{
			m_player = GetWitcherPlayer();
		}

		if ( radius <= 0.0f )
		{
			radius = 250.0f;
		}

		FindGameplayEntitiesInRange( entities, m_player, radius, 200, '', 0, NULL, 'CR4MapPinEntity' );
		for ( i = 0; i < entities.Size(); i += 1 )
		{
			mapPin = (CR4MapPinEntity)entities[i];
			if ( mapPin && IsNameValid( mapPin.entityName ) )
			{
				if ( !( (CR4FastTravelEntity)mapPin ) )
				{
					mapManager.SetEntityMapPinDisabled( mapPin.entityName, true );
				}
			}
		}
		thePlayer.DisplayHudMessage( "Quest pins cleaned." );
	}

	public function ProcessSingleContainer( container : W3Container, player : CR4Player, isFromInteract : bool ) : bool
	{
		var isTheft 	: bool;
		var itemsLooted : int;
		var remains 	: W3ActorRemains;
		var isQuest 	: bool;

		if ( !container || !container.AutoLootCanOpen( player, isFromInteract ) )
		{
			return false;
		}

		// Corvo Bianco weapon/armor stands and display mounts: NEVER auto-loot
		if ( (W3HouseDecorationBase)container || (W3DisplayMount)container )
		{
			return false;
		}

		// Player dropped items (loot bag on ground): NEVER auto-loot dropped items!
		if ( container.HasTag( 'lootbag' ) )
		{
			return false;
		}

		// Bounty monster remains with trophies: NEVER auto-loot via radius or bypass contract sequences
		remains = (W3ActorRemains)container;
		if ( remains && ( remains.HasTrophyItems() || remains.dismemberOnLoot ) )
		{
			return false;
		}

		// Initialize/populate container inventory first so items (e.g. Witcher gear schematics, quest notes) are available for inspection
		container.AutoLootUpdateContainer();

		isQuest = IsContainerQuestRelated( container );

		// Quest protection:
		// 1) If passive pulse (!isFromInteract), NEVER vacuum quest containers or Witcher gear diagrams from afar
		// 2) If from interact, only loot if GetLootQuest() is enabled
		if ( isQuest )
		{
			if ( !isFromInteract || !config.GetLootQuest() )
			{
				return false;
			}
		}

		// Check source type filters
		if ( (W3Herb)container && !config.GetLootHerbs() )
			return false;

		if ( (W3ActorRemains)container && !config.GetLootCorpses() )
			return false;

		// Exploration Caches & PoIs filter
		if ( IsPoICache( container ) && !config.GetLootPoICaches() )
			return false;

		// Chests vs Sacks/Barrels/Crates source filters
		if ( !((W3Herb)container) && !((W3ActorRemains)container) )
		{
			if ( IsChestContainer( container ) )
			{
				if ( !config.GetLootChests() )
					return false;
			}
			else
			{
				if ( !config.GetLootContainers() )
					return false;
			}
		}

		if ( container.IsEmpty() )
		{
			container.OnContainerClosed();
			return false;
		}

		// Stealing & Consequences check
		isTheft = !container.disableStealing && !container.HasQuestItem() && !((W3Herb)container) && !((W3ActorRemains)container);
		if ( isTheft )
		{
			if ( WillStealingBeWitnessedWithConsequences( container, player ) )
			{
				if ( config.GetTheftNotify() )
				{
					ShowTheftWarning();
				}
				return false;
			}
		}

		// Overweight limit check
		if ( config.GetStopIfOverweight() && IsPlayerOverweight() )
		{
			return false;
		}

		// Execute filtered item transfer
		itemsLooted = TransferFilteredItems( container, player );
		if ( itemsLooted > 0 )
		{
			// If container had a completion fact (PoI, bandit camp, guarded treasure), add it now
			if ( StrLen( container.factOnContainerOpened ) > 0 && !FactsDoesExist( container.factOnContainerOpened ) )
			{
				FactsAdd( container.factOnContainerOpened, 1, -1 );
			}

			if ( container.IsEmpty() )
			{
				container.OnContainerClosed();
			}
			return true;
		}

		return false;
	}

	public function TransferFilteredItems( container : W3Container, player : CR4Player ) : int
	{
		var cInv 			: CInventoryComponent;
		var allItems 		: array<SItemUniqueId>;
		var i, count 		: int;
		var quantity 		: int;
		var category 		: name;
		var lastCategory 	: name;
		var informGUI 		: bool;
		var hudStyle 		: int;
		var itemLocName 	: string;
		var itemEntry 		: string;
		var hudSummary 		: string;
		var isPoICache 		: bool;
		var itemName 		: name;
		var forceTransferNoDrops : bool;

		cInv = container.GetInventory();
		if ( !cInv || !player.inv )
			return 0;

		isPoICache = IsPoICache( container );
		cInv.GetAllItems( allItems );
		count = 0;
		hudStyle = config.GetHudStyle();
		
		// If using icon cards (style 0: bottom-right, style 1: bottom-left, style 4: right-center), informGUI triggers LootFeedModule
		informGUI = ( hudStyle == 0 || hudStyle == 1 || hudStyle == 4 );
		hudSummary = "";

		for ( i = allItems.Size() - 1; i >= 0; i -= 1 )
		{
			if ( CanLootItem( cInv, allItems[i], player, isPoICache ) )
			{
				quantity = cInv.GetItemQuantity( allItems[i] );
				itemName = cInv.GetItemName( allItems[i] );
				if ( cInv.ItemHasTag( allItems[i], 'HerbGameplay' ) || (W3Herb)container ||
				     cInv.ItemHasTag( allItems[i], 'Herb' ) || cInv.ItemHasTag( allItems[i], 'herb' ) ||
				     itemName == 'Buckthorn' || itemName == 'sq101_buckthorn' )
				{
					category = 'herb';
				}
				else
				{
					category = cInv.GetItemCategory( allItems[i] );
				}

				// Check if this item category is allowed to show in the HUD feed
				informGUI = ( hudStyle == 0 || hudStyle == 1 || hudStyle == 4 ) && ShouldShowItemInHudFeed( cInv, allItems[i], category );

				// Build item localized name for text message HUD (style 2) or record item for dark box (style 5)
				if ( ShouldShowItemInHudFeed( cInv, allItems[i], category ) )
				{
					if ( hudStyle == 5 )
					{
						RecordLootedItem( itemName, quantity );
					}
					else if ( hudStyle == 2 )
					{
						itemLocName = GetLocStringByKeyExt( cInv.GetItemLocalizedNameByUniqueID( allItems[i] ) );
						if ( itemLocName == "" )
						{
							if ( itemName == 'Crowns' )
							{
								itemLocName = GetLocStringByKeyExt( "item_name_crowns" );
								if ( itemLocName == "" )
								{
									itemLocName = "Korony";
								}
							}
							else
							{
								itemLocName = NameToString( itemName );
							}
						}

						if ( quantity > 1 )
						{
							itemEntry = itemLocName + " (x" + quantity + ")";
						}
						else
						{
							itemEntry = itemLocName;
						}

						if ( count == 0 )
						{
							hudSummary = itemEntry;
						}
						else if ( count < 3 )
						{
							hudSummary = hudSummary + ", " + itemEntry;
						}
					}
				}

				cInv.NotifyItemLooted( allItems[i] );
				forceTransferNoDrops = ( itemName == 'Crowns' || cInv.ItemHasTag( allItems[i], 'Lootable' ) || cInv.ItemHasTag( allItems[i], 'Money' ) );
				cInv.GiveItemTo( player.inv, allItems[i], quantity, true, forceTransferNoDrops, informGUI );

				// Automatically read quest notes and treasure hunt letters so quest objectives advance immediately
				if ( category == 'book' && ( cInv.IsItemQuest( allItems[i] ) || cInv.ItemHasTag( allItems[i], 'Quest' ) || cInv.ItemHasTag( allItems[i], 'quest' ) ) )
				{
					player.inv.ReadBook( allItems[i], true );
				}

				count += 1;
				lastCategory = category;
			}
		}

		// Direct money fallback: if container has crowns that were not transferred or remained in inv
		if ( config.GetLootMoney() && cInv.GetMoney() > 0 )
		{
			quantity = cInv.GetMoney();
			informGUI = ( hudStyle == 0 || hudStyle == 1 || hudStyle == 4 ) && config.GetHudFeedMoney();
			cInv.GiveMoneyTo( player.inv, quantity, informGUI );
			count += 1;
			if ( config.GetHudFeedMoney() )
			{
				if ( hudStyle == 5 )
				{
					RecordLootedItem( 'Crowns', quantity );
				}
				else if ( hudStyle == 2 )
				{
					itemLocName = GetLocStringByKeyExt( "item_name_crowns" );
					if ( itemLocName == "" )
					{
						itemLocName = "Korony";
					}
					itemEntry = itemLocName + " (" + quantity + ")";
					if ( hudSummary == "" )
					{
						hudSummary = itemEntry;
					}
					else
					{
						hudSummary = hudSummary + ", " + itemEntry;
					}
				}
			}
		}

		if ( count > 0 )
		{
			// Display Minimalist HUD text message only when style 2 is chosen
			if ( hudStyle == 2 && hudSummary != "" )
			{
				if ( count > 3 )
				{
					hudSummary = hudSummary + AutoLoot_GetAndMoreText( count - 3 );
				}
				thePlayer.DisplayHudMessage( "+ " + hudSummary );
			}
			// Display Native Dark Loot Box when style 5 is chosen and not in an active area scan
			else if ( !isScanning && hudStyle == 5 && m_collectedPulseItems.Size() > 0 )
			{
				ShowAutoLootBox( m_collectedPulseItems );
				m_collectedPulseItems.Clear();
			}

			if ( config.GetPlayLootSound() )
			{
				if ( IsNameValid( lastCategory ) )
				{
					PlayItemEquipSound( lastCategory );
				}
				else
				{
					PlayItemEquipSound( 'generic' );
				}
			}

			container.InformClueStash();

			if ( StrLen( container.factOnContainerOpened ) > 0 && !FactsDoesExist( container.factOnContainerOpened ) )
			{
				FactsAdd( container.factOnContainerOpened, 1, -1 );
			}

			if ( (W3Herb)container && !player.IsAnyWeaponHeld() && !player.IsHoldingItemInLHand() )
			{
				if ( config.GetPlayHerbAnim() )
				{
					player.RaiseEvent( 'LootHerb' );
				}
			}
		}

		return count;
	}

	public function CanLootItem( cInv : CInventoryComponent, item : SItemUniqueId, player : CR4Player, optional isPoICache : bool ) : bool
	{
		var category : name;
		var itemName : name;
		var locKey : string;

		if ( !cInv.IsIdValid( item ) )
		{
			return false;
		}

		itemName = cInv.GetItemName( item );
		if ( itemName == '' || itemName == 'None' || itemName == 'none' )
		{
			return false;
		}

		category = cInv.GetItemCategory( item );

		// Currency check - handle FIRST so Crowns/Orens/Florens are NEVER blocked by NoDrop, TAG_DONT_SHOW, or ghost checks
		if ( itemName == 'Crowns' || itemName == 'Orens' || itemName == 'Florens' || itemName == 'Money' ||
		     category == 'currency' || category == 'money' || cInv.ItemHasTag( item, 'Money' ) || cInv.ItemHasTag( item, 'Crowns' ) )
		{
			return config.GetLootMoney();
		}

		// Strictly ignore internal, hidden, or non-droppable items
		if ( cInv.ItemHasTag( item, theGame.params.TAG_DONT_SHOW ) ||
			 cInv.ItemHasTag( item, theGame.params.TAG_DONT_SHOW_ONLY_IN_PLAYERS ) ||
			 cInv.ItemHasTag( item, 'NoShow' ) ||
			 cInv.ItemHasTag( item, 'NoShowInPlayersInventory' ) ||
			 cInv.ItemHasTag( item, 'NoDrop' ) ||
			 cInv.ItemHasTag( item, 'Phantom' ) ||
			 cInv.ItemHasTag( item, 'HideInUI' ) ||
			 cInv.ItemHasTag( item, 'Internal' ) )
		{
			if ( !cInv.ItemHasTag( item, 'Lootable' ) )
			{
				return false;
			}
		}

		// Ghost / Dummy item filter:
		// Prevent looting nameless engine dummies or internal markers
		if ( itemName == '' || itemName == 'None' || itemName == 'none' )
		{
			return false;
		}

		// Herbs
		if ( cInv.ItemHasTag( item, 'HerbGameplay' ) || category == 'herb' ||
		     cInv.ItemHasTag( item, 'Herb' ) || cInv.ItemHasTag( item, 'herb' ) ||
		     itemName == 'Buckthorn' || itemName == 'sq101_buckthorn' )
		{
			return config.GetLootHerbs();
		}

		// Schematics and Recipes (including Witcher gear diagrams which CDPR tagged with 'Quest')
		if ( category == 'alchemy_recipe' || category == 'crafting_schematic' )
		{
			return config.GetLootAlchemyCrafting();
		}

		// Keys (always lootable so player can unlock chests / doors)
		if ( category == 'key' || cInv.ItemHasTag( item, 'Key' ) )
		{
			return true;
		}

		// Quest items
		if ( cInv.IsItemQuest( item ) || cInv.ItemHasTag( item, 'Quest' ) || cInv.ItemHasTag( item, 'QuestItem' ) || cInv.ItemHasTag( item, 'quest' ) || category == 'quest' )
		{
			// If inside an exploration PoI cache (Guarded Treasure, Bandit Camp note), allow looting so PoI completes!
			if ( isPoICache )
			{
				return true;
			}
			return config.GetLootQuest();
		}

		// Alchemy ingredients & crafting materials
		if ( category == 'alchem_ingredient' || category == 'alchemy_ingredient' || category == 'crafting_ingredient' )
		{
			return config.GetLootAlchemyCrafting();
		}

		// Equipment
		if ( category == 'armor' || category == 'boots' || category == 'gloves' || category == 'pants' || category == 'trousers' ||
			 category == 'silversword' || category == 'steelsword' || category == 'crossbow' || category == 'bolt' || category == 'weapon' )
		{
			if ( config.GetStopIfOverweight() && IsPlayerOverweight( cInv.GetItemEncumbrance( item ) ) )
			{
				return false;
			}

			// Quality check: 1 = Common (White), 2 = Master (Blue), 3 = Magic (Yellow), 4 = Relic (Orange), 5 = Set (Green)
			if ( config.GetIgnoreCommonEquipment() && cInv.GetItemQuality( item ) <= 1 )
			{
				return false;
			}

			return config.GetLootEquipment();
		}

		// Books
		if ( category == 'book' )
		{
			return config.GetLootBooks();
		}

		// Junk
		if ( category == 'junk' )
		{
			return config.GetLootJunk();
		}

		// Monster trophies
		if ( category == 'trophy' || cInv.ItemHasTag( item, 'Trophy' ) )
		{
			return config.GetLootQuest();
		}

		// Edibles, oils, potions, etc. default allowed
		return true;
	}

	public function ShouldShowItemInHudFeed( cInv : CInventoryComponent, item : SItemUniqueId, category : name ) : bool
	{
		var itemName : name;
		itemName = cInv.GetItemName( item );

		// Herbs
		if ( cInv.ItemHasTag( item, 'HerbGameplay' ) || category == 'herb' ||
		     cInv.ItemHasTag( item, 'Herb' ) || cInv.ItemHasTag( item, 'herb' ) ||
		     itemName == 'Buckthorn' || itemName == 'sq101_buckthorn' )
		{
			return config.GetHudFeedHerbs();
		}

		// Equipment (Weapons, Armor, Crossbows, Bolts)
		if ( category == 'armor' || category == 'boots' || category == 'gloves' || category == 'pants' || category == 'trousers' ||
			 category == 'silversword' || category == 'steelsword' || category == 'crossbow' || category == 'bolt' || category == 'weapon' )
		{
			return config.GetHudFeedEquipment();
		}

		// Alchemy & Crafting
		if ( category == 'alchemy_recipe' || category == 'crafting_schematic' ||
			 category == 'alchem_ingredient' || category == 'alchemy_ingredient' || category == 'crafting_ingredient' )
		{
			return config.GetHudFeedAlchemy();
		}

		// Books
		if ( category == 'book' )
		{
			return config.GetHudFeedBooks();
		}

		// Junk
		if ( category == 'junk' )
		{
			return config.GetHudFeedJunk();
		}

		// Currency / Money
		if ( category == 'currency' || cInv.ItemHasTag( item, 'Money' ) || category == 'money' ||
		     cInv.GetItemName( item ) == 'Crowns' || cInv.ItemHasTag( item, 'Crowns' ) )
		{
			return config.GetHudFeedMoney();
		}

		// Quest items & Keys always shown
		return true;
	}

	public function WillStealingBeWitnessedWithConsequences( container : W3Container, player : CR4Player ) : bool
	{
		var theftMode 				: int;
		var witnessRadius 			: float;
		var entities 				: array<CGameplayEntity>;
		var i 						: int;
		var npc 					: CNewNPC;
		var isGuard 				: bool;
		var hasGuardNearby 			: bool;
		var hasCivilianWitness 		: bool;

		theftMode = config.GetTheftMode();

		// Mode 1: Never steal
		if ( theftMode == 1 )
		{
			return true;
		}

		// Mode 3: Always steal
		if ( theftMode == 3 )
		{
			return false;
		}

		witnessRadius = config.GetTheftRadius();
		// Scan up to 15 entities (instead of 40) to prevent engine streaming stutters in crowded areas like Novigrad
		FindGameplayEntitiesInRange( entities, player, witnessRadius, 15, '', FLAG_OnlyAliveActors );

		hasGuardNearby = false;

		// First pass: look specifically for guards within detection radius
		for ( i = 0; i < entities.Size(); i += 1 )
		{
			npc = (CNewNPC)entities[i];
			if ( !npc || !npc.IsAlive() || npc.IsKnockedUnconscious() || npc == player )
			{
				continue;
			}

			isGuard = ( npc.GetNPCType() == ENGT_Guard || npc.HasTag( 'Guard' ) || npc.HasTag( 'guard' ) );
			if ( isGuard )
			{
				hasGuardNearby = true;

				// Mode 2: Strict -> any guard in detection radius skips immediately
				if ( theftMode == 2 )
				{
					return true;
				}

				// Mode 0: Smart Safe -> check if guard can witness theft
				if ( CanActorWitnessAction( npc, player, container ) )
				{
					// Guard directly sees/hears theft -> GUARANTEED ATTACK / CONSEQUENCES
					return true;
				}
			}
		}

		// If no guard is anywhere nearby, civilians cannot call guards, so looting is safe!
		if ( !hasGuardNearby )
		{
			return false;
		}

		// Second pass: a guard is nearby, check if any civilian witnesses the theft to alert them
		for ( i = 0; i < entities.Size(); i += 1 )
		{
			npc = (CNewNPC)entities[i];
			if ( !npc || !npc.IsAlive() || npc.IsKnockedUnconscious() || npc == player )
			{
				continue;
			}

			if ( npc.GetNPCType() != ENGT_Guard && !npc.HasTag( 'Guard' ) && !npc.HasTag( 'guard' ) )
			{
				if ( GetAttitudeBetween( player, npc ) != AIA_Friendly && !npc.HasTag( theGame.params.TAG_NPC_IN_PARTY ) )
				{
					if ( CanActorWitnessAction( npc, player, container ) )
					{
						return true;
					}
				}
			}
		}

		return false;
	}

	public function CanActorWitnessAction( npc : CNewNPC, player : CR4Player, container : W3Container ) : bool
	{
		var distPlayer, distCont 	: float;
		var anglePlayer, angleCont 	: float;
		var seePlayer, seeCont 		: bool;

		distPlayer = VecDistance( npc.GetWorldPosition(), player.GetWorldPosition() );
		distCont = VecDistance( npc.GetWorldPosition(), container.GetWorldPosition() );

		// Extreme close proximity (hearing/sensing range)
		if ( distPlayer < 2.5f || distCont < 2.0f )
		{
			return true;
		}

		// Facing angle check (100° FOV)
		if ( config.GetTheftCheckAngle() )
		{
			anglePlayer = AbsF( NodeToNodeAngleDistance( player, npc ) );
			angleCont = AbsF( NodeToNodeAngleDistance( container, npc ) );

			// If both the player and container are behind the NPC's back, NPC cannot see
			if ( anglePlayer > 85.0f && angleCont > 85.0f )
			{
				return false;
			}
		}

		// Line of Sight raycast check
		if ( config.GetTheftCheckLoS() )
		{
			seePlayer = HasClearLineOfSight( npc, player, 1.7f, 1.2f );
			if ( seePlayer )
			{
				return true;
			}

			seeCont = HasClearLineOfSight( npc, container, 1.7f, 0.5f );
			if ( !seeCont )
			{
				return false;
			}
		}

		return true;
	}

	public function HasClearLineOfSight( observer : CNode, target : CNode, obsZ : float, tgtZ : float ) : bool
	{
		var startPos, endPos, traceEffect, normal : Vector;

		startPos = observer.GetWorldPosition();
		startPos.Z += obsZ;
		endPos = target.GetWorldPosition();
		endPos.Z += tgtZ;

		if ( theGame.GetWorld().StaticTrace( startPos, endPos, traceEffect, normal ) )
		{
			if ( VecDistance( traceEffect, endPos ) < 0.6f )
			{
				return true;
			}
			return false;
		}

		return true;
	}

	public function ShowTheftWarning()
	{
		var curTime : float;

		curTime = theGame.GetEngineTimeAsSeconds();
		if ( curTime - lastTheftWarnTime > 3.5f )
		{
			lastTheftWarnTime = curTime;
			thePlayer.DisplayHudMessage( AutoLoot_GetTheftWarnMessage() );
		}
	}

	public function PurgeGhostItemsFromPlayerInventory()
	{
		var items : array<SItemUniqueId>;
		var i : int;
		var count : int;
		var itemName : name;
		var pInv : CInventoryComponent;

		if ( !m_player || !m_player.inv )
		{
			return;
		}

		pInv = m_player.inv;
		pInv.GetAllItems( items );
		count = 0;

		for ( i = 0; i < items.Size(); i += 1 )
		{
			if ( !pInv.IsIdValid( items[i] ) )
			{
				continue;
			}

			if ( pInv.ItemHasTag( items[i], 'Quest' ) || pInv.ItemHasTag( items[i], 'Lootable' ) || pInv.ItemHasTag( items[i], 'HerbGameplay' ) )
			{
				continue;
			}

			itemName = pInv.GetItemName( items[i] );

			// CRITICAL: NEVER touch currency or player money!
			if ( itemName == 'Crowns' || itemName == 'Orens' || itemName == 'Florens' || itemName == 'Money' ||
				 pInv.ItemHasTag( items[i], 'Money' ) || pInv.ItemHasTag( items[i], 'Crowns' ) ||
				 pInv.GetItemCategory( items[i] ) == 'currency' || pInv.GetItemCategory( items[i] ) == 'money' )
			{
				continue;
			}

			// Ghost item is strictly an item with NO name or 'None'
			if ( itemName == '' || itemName == 'None' || itemName == 'none' )
			{
				pInv.RemoveItem( items[i], pInv.GetItemQuantity( items[i] ) );
				count += 1;
			}
		}

		if ( count > 0 )
		{
			LogChannel( 'AutoLoot', "Purged " + count + " ghost/dummy items from player inventory." );
		}
	}
}

function GetAutoLootManager() : W3AutoLootManager
{
	var witcher : W3PlayerWitcher;
	witcher = GetWitcherPlayer();
	if ( witcher )
	{
		return witcher.GetAutoLootManager();
	}
	return NULL;
}

exec function ResetQuestPins()
{
	var witcher : W3PlayerWitcher;
	witcher = GetWitcherPlayer();
	if ( witcher && witcher.GetAutoLootManager() )
	{
		witcher.GetAutoLootManager().ResetNearbyQuestPins( 250.0f );
	}
}

exec function CleanGhostItems()
{
	var witcher : W3PlayerWitcher;
	witcher = GetWitcherPlayer();
	if ( witcher && witcher.GetAutoLootManager() )
	{
		witcher.GetAutoLootManager().PurgeGhostItemsFromPlayerInventory();
		thePlayer.DisplayHudMessage( "AutoLoot: Inventory cleaned of ghost items." );
	}
}

