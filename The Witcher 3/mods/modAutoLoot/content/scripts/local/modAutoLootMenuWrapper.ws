// -------------------------------------------------------------------------
// Smart AutoLoot - InGameMenu Localization Wrapper
// Uses Next-Gen script wrapper annotations to intercept
// inGameMenu_TryLocalize and IngameMenu_FetchAndGenerateGroupMenuObject
// without conflicting with other mods modifying igmOptions.ws.
// -------------------------------------------------------------------------

@wrapMethod
function inGameMenu_TryLocalize( key : string ) : string
{
	var text : string;

	text = wrappedMethod( key );
	if ( text != "" && !StrBeginsWith( text, "##" ) )
	{
		return text;
	}

	text = AutoLoot_GetLocalizationString( key );
	if ( text != "" )
	{
		return text;
	}

	if ( StrBeginsWith( key, "option_" ) )
	{
		text = AutoLoot_GetLocalizationString( StrAfterFirst( key, "option_" ) );
		if ( text != "" )
		{
			return text;
		}
	}

	return "##" + key;
}

@wrapMethod
function IngameMenu_FetchAndGenerateGroupMenuObject( flashStorageUtility : CScriptedFlashValueStorage, displayNamePrefix : string, groupDisplayName : string, rootFlashArray : CScriptedFlashArray, out optionParentArray : CScriptedFlashArray ) : CScriptedFlashObject
{
	var res : CScriptedFlashObject;
	var modsObj : CScriptedFlashObject;
	var subArray : CScriptedFlashArray;
	var subObj : CScriptedFlashObject;
	var labelStr : string;
	var idStr : string;
	var i, count : int;

	res = wrappedMethod( flashStorageUtility, displayNamePrefix, groupDisplayName, rootFlashArray, optionParentArray );

	// 1. Ensure the top-level "Mods" / "mods" category entry in the Options menu has its label
	if ( GetObjectFromArrayWithLabel( rootFlashArray, "id", "Mods", modsObj ) || GetObjectFromArrayWithLabel( rootFlashArray, "id", "mods", modsObj ) )
	{
		labelStr = modsObj.GetMemberFlashString( "label" );
		if ( labelStr == "" || StrBeginsWith( labelStr, "##" ) )
		{
			labelStr = inGameMenu_TryLocalize( "mods" );
			if ( labelStr == "" || StrBeginsWith( labelStr, "##" ) )
			{
				labelStr = inGameMenu_TryLocalize( "panel_mods" );
			}
			if ( labelStr == "" || StrBeginsWith( labelStr, "##" ) )
			{
				labelStr = "Mods";
			}
			modsObj.SetMemberFlashString( "label", labelStr );
			modsObj.SetMemberFlashString( "listTitle", labelStr );
		}

		// 2. Iterate through all child mod groups registered under "Mods" to ensure none remain blank
		subArray = modsObj.GetMemberFlashArray( "subElements" );
		if ( subArray )
		{
			count = subArray.GetLength();
			for ( i = 0; i < count; i += 1 )
			{
				subObj = subArray.GetElementFlashObject( i );
				if ( subObj )
				{
					labelStr = subObj.GetMemberFlashString( "label" );
					if ( labelStr == "" || StrBeginsWith( labelStr, "##" ) )
					{
						idStr = subObj.GetMemberFlashString( "id" );
						labelStr = inGameMenu_TryLocalize( idStr );
						if ( labelStr != "" && !StrBeginsWith( labelStr, "##" ) )
						{
							subObj.SetMemberFlashString( "label", labelStr );
							subObj.SetMemberFlashString( "listTitle", labelStr );
						}
					}
				}
			}
		}
	}

	// 3. Ensure the returned group object itself has a valid localized label
	if ( res )
	{
		labelStr = res.GetMemberFlashString( "label" );
		if ( labelStr == "" || StrBeginsWith( labelStr, "##" ) )
		{
			idStr = res.GetMemberFlashString( "id" );
			labelStr = inGameMenu_TryLocalize( idStr );
			if ( labelStr == "" || StrBeginsWith( labelStr, "##" ) )
			{
				labelStr = inGameMenu_TryLocalize( groupDisplayName );
			}
			if ( labelStr != "" && !StrBeginsWith( labelStr, "##" ) )
			{
				res.SetMemberFlashString( "label", labelStr );
				res.SetMemberFlashString( "listTitle", labelStr );
			}
		}
	}

	return res;
}
