if ModUtil ~= nil then
	ModUtil.Path.Wrap( "SetupMap", function(baseFunc)
		LoadPackages({Name = "GUIDDAspects"})
		return baseFunc()
	end)
	ModUtil.Mod.Register("DDAspects")
	ModUtil.LoadOnce(function()

-- Adding new hammers to Ello's Boon Selector
if EllosBoonSelectorMod ~= nil then

EllosBoonSelectorMod.HammerOptions.SwordWeapon5 = {"SwordThrustWaveTrait", "SwordHealthBufferDamageTrait", "SwordSecondaryDoubleAttackTrait", "SwordCriticalTrait", "SwordBackstabTrait", "SwordCursedLifeStealTrait", "SwordAndShieldChargeSpeedTrait", "SwordAndShieldPerfectRushTrait", "SwordAndShieldRushProjectileTrait", "SwordAndShieldBlockEmpowerTrait", "SwordAndShieldDashAOETrait"}
EllosBoonSelectorMod.HammerOptions.SpearWeapon5 = {"SpearReachAttack", "SpearAutoAttack", "SpearThrowBounce", "SpearThrowPenetrate", "SpearSpinDamageRadius", "SpearSpinChargeLevelTime", "SpearThrowElectiveCharge", "SpearSpinChargeAreaDamageTrait", "SpearAttackPhalanxTrait", "SpearJumpSharedTrait"}
EllosBoonSelectorMod.HammerOptions.ShieldWeapon5 = {"ShieldDashAOETrait", "ShieldRushProjectileTrait", "ShieldChargeHealthBufferTrait", "ShieldChargeSpeedTrait", "ShieldBashDamageTrait", "ShieldPerfectRushTrait", "ShieldThrowElectiveCharge", "ShieldBlockEmpowerTrait", "ShieldThrowRushTrait", "ShieldPerfectCatchAoETrait"}
EllosBoonSelectorMod.HammerOptions.BowWeapon5 = {"BowLongRangeDamageTrait", "BowSlowChargeDamageTrait", "BowTapFireTrait", "BowTripleShotTrait", "BowChainShotTrait", "BowAndKickKillTrait", "BowAndKickDefenseTrait", "BowAndKickSpecialLandTrait", "BowAndKickKnockbackTrait", "BowAndKickMarkTrait", "BowAndKickDelayTrait"}
EllosBoonSelectorMod.HammerOptions.FistWeapon5 = {"FistReachAttackTrait", "FistDashAttackHealthBufferTrait", "FistDoubleDashSpecialTrait", "FistKillTrait", "FistSpecialLandTrait", "FistAttackFinisherTrait", "FistConsecutiveAttackTrait", "FistHeavyAttackTrait", "FistRushChargeTrait", "FistRushFireballTrait"}
EllosBoonSelectorMod.HammerOptions.GunWeapon5 = {"GunArmorPenerationTrait", "GunLoadedGrenadeLaserTrait", "GunLoadedGrenadeSpeedTrait", "GunLoadedGrenadeWideTrait", "GunLoadedGrenadeInfiniteAmmoTrait", "GunSharedClusterBombTrait", "GunSharedSingleBombTrait", "GunSharedDeathTrait"}

end

-- Bug "fix" if anyone uses PonyQOL with blood refund on
if PQOL ~= nil then
if PQOL.Config.BloodRefund.Enabled then

function ShowWeaponUpgradeScreen( args )
    local textOffsetX = -50
    OnScreenOpened( { Flag = "WeaponUpgradeScreen", PersistCombatUI = true } )
    FreezePlayerUnit("WeaponUpgradeScreen" )
    EnableShopGamepadCursor()
    local weaponName = args.WeaponName
    ScreenAnchors.WeaponUpgradeScreen = { Components = {}, Name = "WeaponUpgradeScreen", OpenedEquippedIndex = GetEquippedWeaponTraitIndex( weaponName ) }
    local screen = ScreenAnchors.WeaponUpgradeScreen
    screen.StartingIndex = 1
    screen.AspectCount = TableLength(WeaponUpgradeData[weaponName])
    screen.PageCount = math.ceil(screen.AspectCount/4)
    screen.WeaponName = weaponName
    screen.Components.Display = {}
    local components = screen.Components
    EnableShopGamepadCursor(screen.Name)

    components.ShopBackgroundDim = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_Menu" })
    components.ShopBackground = CreateScreenComponent({ Name = "WeaponSelectPanelBox", Group = "Combat_Menu_TraitTray_Backing", X = ScreenCenterX, Y = ScreenHeight/2 - 18})
    components.WeaponImage = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_Menu_TraitTray", X = 335, Y = 435 })
    SetAnimation({ DestinationId = components.WeaponImage.Id, Name = GetWeaponAspectImage( weaponName )})

    SetAlpha({ Id = components.WeaponImage.Id, Fraction = 0 })
    SetThingProperty({ Property = "Ambient", Value = 0.0, DestinationId = components.WeaponImage.Id })
    CreateTextBox({ Id = components.ShopBackground.Id, Text = weaponName.."_Full", FontSize = 38, OffsetX = 0, OffsetY = -480, Color = Color.White, Font = "SpectralSCLightTitling", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center" })
    CreateTextBox({ Id = components.ShopBackground.Id, Text = weaponName.."_Full", UseDescription = true, FontSize = 20, Width = 620, OffsetX = 0, OffsetY = -406, Color = {0.643, 0.635, 0.482, 1.0}, Font = "CrimsonTextItalic", ShadowBlur = 0, ShadowColor = {0,0,0,0}, ShadowOffset={0, 2}, Justification = "Center" })
    SetScale({ Id = components.ShopBackgroundDim.Id, Fraction = 10 })
    SetColor({ Id = components.ShopBackgroundDim.Id, Color = {0.090, 0.055, 0.157, 0.6} })
    wait(0.5)
    local timesCleared = "NoClears"
    local clearTimeText = "NoClearTime"
    local heatClearText = "NoHeatClear"
    local weaponKills = "NoWeaponKills"
    local weaponSelectPanelRightString = "WeaponSelectPanel_Right"

    if GameState.TimesClearedWeapon and GameState.TimesClearedWeapon[weaponName] then
        timesCleared = GameState.TimesClearedWeapon[weaponName]
    end
    if GameState.WeaponRecordsClearTime and GameState.WeaponRecordsClearTime[weaponName] then
        clearTimeText = GetTimerString( GameState.WeaponRecordsClearTime[weaponName])
    end

    if GameState.WeaponRecordsShrinePoints and GameState.WeaponRecordsShrinePoints[weaponName] and GameState.WeaponRecordsShrinePoints[weaponName] > 0 then
        heatClearText = GameState.WeaponRecordsShrinePoints[weaponName]
    else
        weaponSelectPanelRightString = "WeaponSelectPanel_Right_Alt"
    end

    if GameState.WeaponKills and GameState.WeaponKills[weaponName] then
        weaponKills = GameState.WeaponKills[weaponName]
    end

    SetAlpha({ Id = components.WeaponImage.Id, Fraction = 1 })
    local ruScale = 0.75
    local deScale = 0.8
    local cnScale = 0.8
    local plScale = 0.8
    CreateTextBox({ Id = components.ShopBackground.Id, Text = "WeaponSelectPanel_Title", FontSize = 25, Width = 340, OffsetX = -625, OffsetY = 174, Color = {0.749, 0.749, 0.749, 1.0}, Font = "AlegreyaSansSCBold", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center", VerticalJustification = "Top", LineSpacingBottom = -5,
        LangPlScaleModifier = plScale
    })
    CreateTextBox({ Id = components.ShopBackground.Id, Text = "WeaponSelectPanel_Left", FontSize = 20, Width = 340, OffsetX = -795, OffsetY = 230, Color = {0.749, 0.749, 0.749, 1.0}, Font = "AlegreyaSansSCRegular", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Left", VerticalJustification = "Top", LineSpacingBottom = -5,

            LangRuScaleModifier = ruScale,
            LangDeScaleModifier = deScale,
            LangCnScaleModifier = cnScale,
            LangPlScaleModifier = plScale,
            })
    CreateTextBox({ Id = components.ShopBackground.Id, Text = weaponSelectPanelRightString, FontSize = 20, Width = 340, OffsetX = -485, OffsetY = 230, Color = {0.749, 0.749, 0.749, 1.0}, Font = "AlegreyaSansSCRegular", ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Right", VerticalJustification = "Top",
        LineSpacingBottom = -5,
        LangRuScaleModifier = ruScale,
        LangDeScaleModifier = deScale,
        LangCnScaleModifier = cnScale,
        LangPlScaleModifier = plScale,
        LuaKey = "TempTextData",
        LuaValue =
        {
            TimesCleared = timesCleared,
            RecordClearTime = clearTimeText,
            RecordShrinePoints = heatClearText,
            WeaponKills = weaponKills,
        }})
    components.CurrentKeys = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray" })
    CreateTextBox({ Id = components.CurrentKeys.Id,
        Text = "MetaUpgrade_Available_SuperKeys",
        FontSize = 24,
        Width = 0,
        OffsetX = 500,
        OffsetY = -400,
        Color = Color.White,
        Font = "AlegreyaSansSCRegular",
        ShadowBlur = 0,
        ShadowColor = {0,0,0,1},
        ShadowOffset={0, 2},
        Justification = "Right",
        LuaKey = "TempTextData",
        LuaValue = { Amount = tostring(GameState.Resources.SuperLockKeys)}
    })
    PlaySound({ Name = "/SFX/Menu Sounds/GeneralWhooshMENULoud" })
    thread( PlayVoiceLines, GlobalVoiceLines.OpenedWeaponUpgradeMenuVoiceLines, true )

    AspectExtender.WeaponUpgradeScreenLoadPage(screen)

    components.PageUp = CreateScreenComponent({ Name = "ButtonCodexUp", Scale = 0.8, Sound = "/SFX/Menu Sounds/GeneralWhooshMENU", Group = "Combat_Menu_TraitTray_Backing" })
    Attach({ Id = components.PageUp.Id, DestinationId = components.ShopBackground.Id, OffsetX = -400 , OffsetY = -395 })
    components.PageUp.OnPressedFunctionName = "AspectExtender.WeaponUpgradeScreenPrevious"
    components.PageUp.ControlHotkeys = { "MenuUp", "MenuLeft" }

    components.PageDown = CreateScreenComponent({ Name = "ButtonCodexDown", Scale = 0.8, Sound = "/SFX/Menu Sounds/GeneralWhooshMENU", Group = "Combat_Menu_TraitTray_Backing" })
    Attach({ Id = components.PageDown.Id, DestinationId = components.ShopBackground.Id, OffsetX = -400 , OffsetY = 465 })
    components.PageDown.OnPressedFunctionName = "AspectExtender.WeaponUpgradeScreenNext"
    components.PageDown.ControlHotkeys = { "MenuDown", "MenuRight" }

    components.CloseButton = CreateScreenComponent({ Name = "ButtonClose", Scale = 0.7, Group = "Combat_Menu_TraitTray_Overlay" })
    Attach({ Id = components.CloseButton.Id, DestinationId = components.ShopBackground.Id, OffsetX = 0 , OffsetY = 515 })
    components.CloseButton.OnPressedFunctionName = "CloseWeaponUpgradeScreen"
    components.CloseButton.ControlHotkey = "Cancel"

    screen.KeepOpen = true
    screen.CanClose = true
	thread( HandleWASDInput, ScreenAnchors.WeaponUpgradeScreen )
	HandleScreenInput( ScreenAnchors.WeaponUpgradeScreen )
end
end
end

-- There's Olympus Extra stuff all over the code
-- I'm going to forget where I put this...
local gods = {}
if ApolloExtra ~= nil then
	table.insert(gods, "Apollo")
end
if HestiaExtra ~= nil then
	table.insert(gods, "Hestia")
end
if HeraExtra ~= nil then
	table.insert(gods, "Hera")
end
for i, godName in ipairs(gods) do
	table.insert(TraitData[godName .. "WeaponTrait"].PropertyChanges,
	{
		TraitName = "GunSharedTrait",
		WeaponName = "GunWeapon",
		ProjectileProperty = "Graphic",
		ChangeValue = "GunLaser-" .. godName,
		ExcludeLinked = true,
	})
	table.insert(TraitData[godName .. "WeaponTrait"].PropertyChanges,
	{
		TraitName = "GunSharedTrait",
		WeaponName = "GunWeapon",
		ProjectileProperty = "AttachedAnim",
		ChangeValue = "GunLaserOriginFlare-" .. godName,
		ExcludeLinked = true,
	})
	table.insert(TraitData[godName .. "WeaponTrait"].PropertyChanges,
	{
		TraitName = "GunSharedTrait",
		WeaponName = "GunWeapon",
		ProjectileProperty = "TipFx",
		ChangeValue = "GunLaserTipFlare-" .. godName,
		ExcludeLinked = true,
	})
	table.insert(TraitData[godName .. "WeaponTrait"].PropertyChanges,
	{
		TraitName = "GunSharedTrait",
		WeaponName = "GunWeapon",
		ProjectileProperty = "ChargeStartFx",
		ChangeValue = "GunCharge-" .. godName,
		ExcludeLinked = true,
	})
	table.insert(TraitData[godName .. "WeaponTrait"].PropertyChanges,
	{
		TraitName = "GunSharedTrait",
		WeaponNames = { "GunWeapon", "GunWeaponDash" },
		WeaponProperty = "FireFx",
		ChangeValue = "null",
		ExcludeLinked = true,
	})
	table.insert(TraitData[godName .. "WeaponTrait"].PropertyChanges,
	{
		TraitName = "GunSharedTrait",
		WeaponName = "GunWeapon",
		ProjectileProperty = "DissipateGraphic",
		ChangeValue = "GunLaserEnd-" .. godName,
		ExcludeLinked = true,
	})
	table.insert(TraitData[godName .. "SecondaryTrait"].PropertyChanges,
	{
		TraitName = "GunSharedTrait",
		WeaponNames = { "GunGrenadeToss" },
		ProjectileProperty = "Graphic",
		ChangeValue = "GunWeaponProjectile-" .. godName,
		ExcludeLinked = true,
	})
end

end)
end
