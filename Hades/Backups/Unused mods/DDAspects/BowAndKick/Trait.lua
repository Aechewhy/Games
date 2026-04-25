	TraitData.BowAndKickTrait =
	{
		Icon = "WeaponEnchantment_Bow_DDAspects",
		CustomTrayText = "BowAndKickTrait_Tray",
		InheritFrom = { "WeaponEnchantmentTrait" },
		PostWeaponUpgradeScreenAnimation = "ZagreusBowAlt01FireEndLoop",
		PostWeaponUpgradeScreenAngle = 205,
		PreEquipWeapons = { "FistWeaponSpecial" },
		RarityLevels =
		{
			Common    = { Multiplier = 1.0 },
			Rare      = { Multiplier = 1.5 },
			Epic      = { Multiplier = 2.0 },
			Heroic    = { Multiplier = 2.5 },
			Legendary = { Multiplier = 3.0 },
		},

		WeaponDataOverride =
		{
			FistWeaponSpecial =
			{
				DashWeapon = nil,
				FireScreenshake = {},
				HitSimSlowCooldown = 0.2,

				Sounds =
				{
					-- Sound effects from fist's dash-attack
					FireSounds =
					{
						{ Name = "/VO/ZagreusEmotes/EmoteAttacking_DashPunch" },
						{ Name = "/SFX/Player Sounds/ZagreusFistWhoosh" },
					},
					ImpactSounds =
					{
						Armored = "/SFX/Player Sounds/ZagreusShieldRicochet",
						Bone = "/SFX/FistImpactBig",
						Brick = "/SFX/FistImpactBig",
						Stone = "/SFX/FistImpactBig",
						Organic = "/SFX/FistImpactBig",
						StoneObstacle = "/SFX/FistImpactSmall",
						BrickObstacle = "/SFX/FistImpactSmall",
						MetalObstacle = "/SFX/FistImpactSmall",
						BushObstacle = "/Leftovers/World Sounds/LeavesRustle",
					},
				},
			},
		},

		PropertyChanges =
		{

			--- ATTACK ---
			{
				WeaponNames = { "BowWeapon" },
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.9,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "BowWeapon" },
				WeaponProperty = "ChargeDamageMultiplier",
				ChangeValue = 9.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "BowWeapon" },
				WeaponProperty = "PerfectChargeWindowDuration",
				ChangeValue = 0.24,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- DASH ATTACK ---

			{
				WeaponNames = { "BowWeaponDash" },
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.6,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "BowWeaponDash" },
				WeaponProperty = "ChargeDamageMultiplier",
				ChangeValue = 6.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- UPGRADES ---
			--- Perfect shot deals +50% base damage

			{
				WeaponNames = { "BowWeapon", "BowWeaponDash" },
				WeaponProperty = "PerfectChargeDamageMultiplier",
				ChangeValue = 1.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "BowWeapon", "BowWeaponDash" },
				WeaponProperty = "PerfectChargeDamageMultiplier",
				BaseValue = 0.2,
				ChangeType = "Add",
				ExcludeLinked = true,
				ExtractValues =
				{
					{
						ExtractAs = "TooltipDamageIncrease",
						Format = "Percent",
					}
				},
			},

			--- SPECIAL ---

			{
				WeaponName = "BowSplitShot",
				WeaponProperty = "Enabled",
				ChangeValue = false,
				ExcludeLinked = true,
			},
			{
				WeaponName = "FistWeaponSpecial",
				WeaponProperty = "SwapOnFire",
				ChangeValue = "FistWeaponSpecialDash",
				ExcludeLinked = true,
			},
			{
				WeaponName = "FistWeaponSpecial",
				EffectName = "FistSpecialFireSelfSlow",
				EffectProperty = "Active",
				ChangeValue = false,
				ExcludeLinked = true,
			},

			--- SPECIAL AUTO LOCK ---
			--- Locks in 360 angle

			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AutoLock",
				ChangeValue = true,
				ExcludeLinked = true,
			},
			{
				WeaponName = { "FistWeaponSpecial" },
				WeaponProperty = "AutoLockArcDistance",
				ChangeValue = 40,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AutoLockRange",
				ChangeValue = 340,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AutoLockUseMouseOver",
				ChangeValue = false,
				ExcludeLinked = true,
			},

			--- GRAPHICAL CHANGES ---

			{
				WeaponName = "BowWeapon",
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusBowAlt01DashStart",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "BowWeapon",
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusBowAlt01DashFire",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "BowWeapon", "BowWeaponDash" },
				WeaponProperty = "ChargeCancelGraphic",
				ChangeValue = "ZagreusBowAlt01StartCancel",
				ExcludeLinked = true,
			},
			{
				WeaponName = "BowWeaponDash",
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusBowAlt01Start",
				ExcludeLinked = true,
			},
			{
				WeaponName = "BowWeaponDash",
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusBowAlt01Fire",
				ExcludeLinked = true,
			},
			{
				WeaponName = "BowWeapon",
				ProjectileProperty = "Graphic",
				ChangeValue = "BowWeaponArrow-Alt01",
				ExcludeLinked = true,
			},
			{
				WeaponName = "BowWeapon",
				ProjectileProperty = "AttachedAnim",
				ChangeValue = "BowWeaponArrowShadow-Alt01",
				ExcludeLinked = true,
			},
			{
				WeaponName = "FistWeaponSpecial",
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt02FlashKick_Start",
				ExcludeLinked = true,
			},
			{
				WeaponName = "FistWeaponSpecial",
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt02FlashKick_Fire",
				ExcludeLinked = true,
			},
			{
				WeaponName = "FistWeaponSpecial",
				WeaponProperty = "ChargeFinishFx",
				ChangeValue = "FistFxUppercutDirectional_FlashKick",
				ExcludeLinked = true,
			},

		},
		SetupFunction =
		{
			Name = "BowAndKickSetup",
		},
	}

-- Some dirty bug fixing
function BowAndKickSetup( unit, args )
	CurrentRun.Hero.Weapons.FistWeaponSpecial = true
end
