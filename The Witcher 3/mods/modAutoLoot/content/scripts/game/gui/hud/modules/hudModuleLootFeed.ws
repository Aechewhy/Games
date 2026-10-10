/***********************************************************************/
/** 	AutoLoot Next-Gen Mod - Custom HUD Loot Feed Module
/** 	Displays item icons, names, and quantities in bottom-right or bottom-left corner.
/***********************************************************************/
class CR4HudModuleLootFeed extends CR4HudModuleBase
{	
	private var m_flashValueStorage 	: CScriptedFlashValueStorage;
	private var m_feedQueue 			: array< SAutoLootFeedItem >;
	private var m_flushTimer 			: float; default m_flushTimer = 0.0;

	private	var m_fxSetMaxShowerCount	: CScriptedFlashFunction;
	private	var m_fxSetTimes			: CScriptedFlashFunction;
	private	var m_fxSetElemScale		: CScriptedFlashFunction;
	private	var m_fxSetYGap				: CScriptedFlashFunction;
	private var m_currentHudStyle 		: int; default m_currentHudStyle = -1;
	private var m_currentScale 			: float; default m_currentScale = -1.0;
	private var m_currentOpacity 		: float; default m_currentOpacity = -1.0;

	private var m_panelDrawn 			: bool; default m_panelDrawn = false;
	private var m_panelRows 			: float; default m_panelRows = 0.0;
	private var m_panelAlpha 			: float; default m_panelAlpha = 0.0;
	private var m_panelShown 			: float; default m_panelShown = -1.0;

	event OnConfigUI()
	{
		var flashModule : CScriptedFlashSprite;
		var hud : CR4ScriptedHud;
		
		m_anchorName = "mcAnchorLootFeed";
		
		flashModule 			= GetModuleFlash();
		m_flashValueStorage 	= GetModuleFlashValueStorage();

		m_fxSetMaxShowerCount	= flashModule.GetMemberFlashFunction( "setMaxShowerCount" );
		m_fxSetTimes			= flashModule.GetMemberFlashFunction( "setTimes" );
		m_fxSetElemScale		= flashModule.GetMemberFlashFunction( "setElemScale" );
		m_fxSetYGap				= flashModule.GetMemberFlashFunction( "setYGap" );

		SetDefaultParams();
		
		super.OnConfigUI();
		
		hud = (CR4ScriptedHud)theGame.GetHud();
		if (hud)
		{
			hud.UpdateHudConfig('LootFeedModule', true);
		}
	}

	function SetDefaultParams() : void
	{
		var inGameConfig 	: CInGameConfigWrapper;
		var valScale 		: string;
		var scale 			: float;

		scale = 0.8;
		inGameConfig = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		if ( inGameConfig )
		{
			valScale = inGameConfig.GetVarValue( 'AutoLoot', 'HudItemScale' );
			if ( valScale != "" )
			{
				scale = ( StringToFloat( valScale ) / 100.0 ) * 0.8;
				if ( scale < 0.4 ) scale = 0.8;
			}
		}
		m_currentScale = scale;

		m_fxSetMaxShowerCount.InvokeSelfOneArg( FlashArgInt( 5 ) );
		m_fxSetTimes.InvokeSelfFiveArgs( FlashArgNumber( 0.4 ), FlashArgNumber( 2.8 ), FlashArgNumber( 0.4 ), FlashArgNumber( 0.4 ), FlashArgNumber( 0.25 ) );
		m_fxSetElemScale.InvokeSelfOneArg( FlashArgNumber( scale ) );
		m_fxSetYGap.InvokeSelfOneArg( FlashArgNumber( 2 ) );
	}

	public function SnapToAnchorPosition()
	{
		var l_hud 				: CR4ScriptedHud;
		var l_hudModuleAnchors	: CR4HudModuleAnchors;
		var l_mcAnchor			: CScriptedFlashSprite;
		var l_flashModule 		: CScriptedFlashSprite;
		var l_scale 			: float;	
		var anchorX				: float;
		var anchorY				: float;
		var inGameConfig 		: CInGameConfigWrapper;
		var val 				: string;
		var valScale 			: string;
		var valOpacity 			: string;
		var userScale 			: float;
		var userOpacity 		: float;
		var hudStyle 			: int;

		inGameConfig = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		if ( inGameConfig )
		{
			val = inGameConfig.GetVarValue('AutoLoot', 'HudStyle');
		}

		if ( val != "" )
		{
			hudStyle = StringToInt( val );
		}
		else
		{
			hudStyle = 4; // Default: Prawa krawedz ekranu z tlem
		}

		m_currentHudStyle = hudStyle;

		if ( hudStyle == 2 || hudStyle == 3 || hudStyle == 5 )
		{
			return;
		}

		l_hud = (CR4ScriptedHud)theGame.GetHud();
		if ( !l_hud ) return;

		l_hudModuleAnchors = (CR4HudModuleAnchors)l_hud.GetHudModule( "AnchorsModule" );
		if ( !l_hudModuleAnchors ) return;

		if ( hudStyle == 0 )
		{
			// Prawy dolny róg (Bottom-Right) - nad podpowiedziami sterowania
			l_mcAnchor = l_hudModuleAnchors.GetAnchorSprite( "mcAnchorControlsFeedback" );
			if ( l_mcAnchor )
			{
				anchorX = l_mcAnchor.GetX() - 320.0;
				anchorY = l_mcAnchor.GetY() - 250.0;
			}
			else
			{
				anchorX = 1550.0;
				anchorY = 750.0;
			}
		}
		else if ( hudStyle == 4 )
		{
			// Prawa krawedz ekranu (Right Edge - pod minimapa i zadaniami)
			anchorX = 1450.0;
			anchorY = 565.0;
		}
		else
		{
			// Lewy dolny róg (Bottom-Left) - nad paskiem mikstur
			l_mcAnchor = l_hudModuleAnchors.GetAnchorSprite( "mcAnchorLootFeed" );
			if ( l_mcAnchor )
			{
				anchorX = l_mcAnchor.GetX();
				anchorY = l_mcAnchor.GetY();
			}
			else
			{
				anchorX = 80.0;
				anchorY = 650.0;
			}
		}

		l_flashModule = GetModuleFlash();

		userOpacity = 1.0;
		if ( inGameConfig )
		{
			valOpacity = inGameConfig.GetVarValue( 'AutoLoot', 'HudOpacity' );
			if ( valOpacity != "" )
			{
				userOpacity = ( StringToFloat( valOpacity ) / 100.0 ) * theGame.GetUIOpacity();
				if ( userOpacity < 0.2 ) userOpacity = 1.0 * theGame.GetUIOpacity();
			}
		}
		m_currentOpacity = userOpacity;
		m_fxSetMaxOpacitySFF.InvokeSelfOneArg( FlashArgNumber( userOpacity ) );

		userScale = 1.0;
		if ( inGameConfig )
		{
			valScale = inGameConfig.GetVarValue( 'AutoLoot', 'HudItemScale' );
			if ( valScale != "" )
			{
				userScale = StringToFloat( valScale ) / 100.0;
				if ( userScale < 0.5 ) userScale = 1.0;
			}
		}
		m_currentScale = userScale;
		if ( m_fxSetElemScale )
		{
			m_fxSetElemScale.InvokeSelfOneArg( FlashArgNumber( userScale ) );
		}
		
		l_scale = theGame.GetUIScale() + theGame.GetUIGamepadScaleGain();
		if ( UpdateScale( l_scale, l_flashModule ) )	
		{
			UpdatePosition( anchorX, anchorY );
		}
	}

	protected function UpdatePosition( anchorX : float, anchorY : float ) : void
	{
		var tempX				: float;
		var tempY				: float;
		var l_flashModule 		: CScriptedFlashSprite;
		
		l_flashModule = GetModuleFlash();
		
		if ( m_currentHudStyle == 0 )
		{
			// Prawy dolny róg
			tempX = anchorX - ( 300.0 * ( 1.0 - theGame.GetUIHorizontalFrameScale() ) );
			tempY = anchorY - ( 200.0 * ( 1.0 - theGame.GetUIVerticalFrameScale() ) );
		}
		else if ( m_currentHudStyle == 4 )
		{
			// Prawa krawedz ekranu pod minimapa
			tempX = ( anchorX - curResolutionWidth / 2 ) * theGame.GetUIHorizontalFrameScale() + curResolutionWidth / 2;
			tempY = ( anchorY - curResolutionHeight / 2 ) * theGame.GetUIVerticalFrameScale() + curResolutionHeight / 2;
		}
		else
		{
			// Lewy dolny róg
			tempX = ( anchorX - curResolutionWidth / 2 ) * theGame.GetUIHorizontalFrameScale() + curResolutionWidth / 2;
			tempY = ( anchorY - curResolutionHeight / 2 ) * theGame.GetUIVerticalFrameScale() + curResolutionHeight / 2;
		}

		l_flashModule.SetX( tempX );
		l_flashModule.SetY( tempY );	
	}

	function CreateGFXElement( data : SItemChangedData, out gfxDataObj : CScriptedFlashObject )
	{
		CreateGFXElementInternal( data.itemName, data.quantity, gfxDataObj );
	}

	function CreateGFXElementInternal( itemName : name, quantity : int, out gfxDataObj : CScriptedFlashObject )
	{
		var locKey 			: string;
		var itemNameLocale 	: string;
		var itemPath 		: string;
		var itemQuantity 	: string;
		var dm 				: CDefinitionsManagerAccessor;

		dm = theGame.GetDefinitionsManager();

		locKey = dm.GetItemLocalisationKeyName( itemName );
		if ( locKey == "" && itemName == 'Crowns' )
		{
			locKey = thePlayer.inv.GetItemLocalizedNameByName( 'Crowns' );
			if ( locKey == "" )
			{
				locKey = "item_name_crowns";
			}
		}
		itemNameLocale = "[[" + locKey + "]]";

		itemPath = dm.GetItemIconPath( itemName );
		if ( itemPath == "" && itemName == 'Crowns' )
		{
			itemPath = "icons/hud/quest/icon_coins.png";
		}
		itemQuantity = "x" + quantity;

		gfxDataObj = m_flashValueStorage.CreateTempFlashObject();

		gfxDataObj.SetMemberFlashString( "name", itemNameLocale );
		gfxDataObj.SetMemberFlashString( "iconPath", itemPath );
		gfxDataObj.SetMemberFlashString( "quantityText", itemQuantity );
	}

	function ProcessQueue() : void
	{
		var i : int;
		var gfxDataArray : CScriptedFlashArray;
		var gfxDataObj : CScriptedFlashObject;

		gfxDataArray = m_flashValueStorage.CreateTempFlashArray();

		for( i = 0; i < m_feedQueue.Size(); i += 1 )
		{
			CreateGFXElementInternal( m_feedQueue[i].itemName, m_feedQueue[i].quantity, gfxDataObj );
			gfxDataArray.PushBackFlashObject( gfxDataObj );
		}

		m_feedQueue.Clear();
		m_flashValueStorage.SetFlashArray( "hud.lootfeed.add", gfxDataArray );
	}
		
	event OnTick( timeDelta : float )
	{
		var inGameConfig 	: CInGameConfigWrapper;
		var val 			: string;
		var hudStyle 		: int;
		var needsUpdate 	: bool;

		needsUpdate = false;
		inGameConfig = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		if ( inGameConfig )
		{
			val = inGameConfig.GetVarValue( 'AutoLoot', 'HudStyle' );
			if ( val != "" )
			{
				hudStyle = StringToInt( val );
				if ( hudStyle != m_currentHudStyle )
				{
					needsUpdate = true;
				}
			}

			val = inGameConfig.GetVarValue( 'AutoLoot', 'HudItemScale' );
			if ( val != "" && ( StringToFloat( val ) / 100.0 ) != m_currentScale )
			{
				needsUpdate = true;
			}

			val = inGameConfig.GetVarValue( 'AutoLoot', 'HudOpacity' );
			if ( val != "" && ( ( StringToFloat( val ) / 100.0 ) * theGame.GetUIOpacity() ) != m_currentOpacity )
			{
				needsUpdate = true;
			}

			if ( needsUpdate )
			{
				SnapToAnchorPosition();
			}
		}

		if ( m_feedQueue.Size() > 0 )
		{
			m_flushTimer += timeDelta;
			if ( m_flushTimer >= 0.4 || m_feedQueue.Size() >= 5 )
			{
				ProcessQueue();
				m_flushTimer = 0.0;
			}
		}
		else
		{
			m_flushTimer = 0.0;
		}

		UpdateBackgroundPanel( timeDelta );
	}

	private function UpdateBackgroundPanel( dt : float ) : void
	{
		var flash  : CScriptedFlashSprite;
		var pen    : CScriptedFlashObject;
		var fx     : CScriptedFlashFunction;
		var lines  : int;
		var rows, alpha, step, unit, targetOpacity : float;

		if ( m_currentHudStyle == 2 || m_currentHudStyle == 3 || m_currentHudStyle == 5 )
		{
			if ( m_panelDrawn )
			{
				flash = GetModuleFlash();
				if ( flash )
				{
					pen = flash.GetMemberFlashObject( "graphics" );
					if ( pen )
					{
						fx = pen.GetMemberFlashFunction( "clear" );
						if ( fx ) fx.InvokeSelf();
					}
				}
				m_panelDrawn = false;
			}
			return;
		}

		flash = GetModuleFlash();
		if ( !flash ) return;

		lines = flash.GetMemberFlashInt( "numChildren" );

		targetOpacity = 0.65;
		if ( m_currentOpacity > 0.0 )
		{
			targetOpacity = m_currentOpacity * 0.7;
		}

		rows = m_panelRows;
		alpha = m_panelAlpha;

		if ( lines > 0 )
		{
			if ( alpha <= 0.0f )
				rows = (float)lines;
			else
				rows += ( (float)lines - rows ) * MinF( 1.0f, dt * 10.0f );
			alpha = MinF( targetOpacity, alpha + dt * 3.0f );
		}
		else
		{
			alpha = MaxF( 0.0f, alpha - dt * 3.0f );
		}

		m_panelRows = rows;
		m_panelAlpha = alpha;

		if ( AbsF( rows * 100.0f + alpha - m_panelShown ) < 0.004f )
			return;
		m_panelShown = rows * 100.0f + alpha;

		pen = flash.GetMemberFlashObject( "graphics" );
		if ( !pen )
		{
			m_panelDrawn = false;
			return;
		}

		fx = pen.GetMemberFlashFunction( "clear" );
		if ( fx ) fx.InvokeSelf();

		m_panelDrawn = ( alpha > 0.0f );
		if ( alpha <= 0.0f )
			return;

		unit = m_currentScale;
		if ( unit < 0.4 ) unit = 0.8;
		step = 82.0f * unit + 2.0f;

		// Subtelny obrys (kolor UI wiedzmina 0xB4A384 = 11838340)
		fx = pen.GetMemberFlashFunction( "lineStyle" );
		if ( fx )
			fx.InvokeSelfThreeArgs( FlashArgNumber( 1.5f ), FlashArgUInt( 11838340 ), FlashArgNumber( alpha * 0.6f ) );

		// Ciemne tlo panelu (0x0B0908 = 723208)
		fx = pen.GetMemberFlashFunction( "beginFill" );
		if ( fx )
			fx.InvokeSelfTwoArgs( FlashArgUInt( 723208 ), FlashArgNumber( alpha ) );

		// Zaokraglony prostokat
		fx = pen.GetMemberFlashFunction( "drawRoundRect" );
		if ( fx )
			fx.InvokeSelfSixArgs( FlashArgNumber( -12.0f * unit ), FlashArgNumber( -5.0f * unit ),
				FlashArgNumber( 496.0f * unit ), FlashArgNumber( rows * step - 2.0f + 20.0f * unit ),
				FlashArgNumber( 14.0f * unit ), FlashArgNumber( 14.0f * unit ) );

		fx = pen.GetMemberFlashFunction( "endFill" );
		if ( fx ) fx.InvokeSelf();
	}	

	public function AddItemToQueue( item : SItemChangedData )
	{
		var i : int;
		var feedItem : SAutoLootFeedItem;
		var inGameConfig : CInGameConfigWrapper;
		var groupItems : bool;

		if ( m_currentHudStyle == 2 || m_currentHudStyle == 3 || m_currentHudStyle == 5 )
		{
			return;
		}

		if ( !m_bEnabled )
		{
			SetEnabled( true );
		}

		groupItems = true;
		inGameConfig = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		if ( inGameConfig )
		{
			groupItems = ( inGameConfig.GetVarValue( 'AutoLoot', 'HudGroupItems' ) != "false" );
		}

		if ( groupItems )
		{
			for ( i = 0; i < m_feedQueue.Size(); i += 1 )
			{
				if ( m_feedQueue[i].itemName == item.itemName )
				{
					m_feedQueue[i].quantity += item.quantity;
					return;
				}
			}
		}

		feedItem.itemName = item.itemName;
		feedItem.quantity = item.quantity;
		m_feedQueue.PushBack( feedItem );
	}
}

function GetLootFeedHUDElement() : CR4HudModuleLootFeed
{
	var hud : CR4ScriptedHud;
	var chainModule : CR4HudModuleLootFeed;
	
	hud = (CR4ScriptedHud)theGame.GetHud();
					
	if ( hud )
	{
		chainModule = (CR4HudModuleLootFeed)hud.GetHudModule( "LootFeedModule" );
	}
	
	return chainModule;
}
