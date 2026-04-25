	TraitData.FistRushTrait =
	{
		Icon = "WeaponEnchantment_Fist_DDAspects",
		CustomTrayText = "FistRushTrait_Tray",
		InheritFrom = { "WeaponEnchantmentTrait" },
		PostWeaponUpgradeScreenAnimation = "ZagreusFistAlt01FlashKick_ReturnToIdle",
		PostWeaponUpgradeScreenAngle = 208,
		PreEquipWeapons = { "FistSpecialMiniDash" },
		RarityLevels =
		{
			Common    = { Multiplier = 1.000 },
			Rare      = { Multiplier = 1.125 },
			Epic      = { Multiplier = 1.250 },
			Heroic    = { Multiplier = 1.375 },
			Legendary = { Multiplier = 1.500 },
		},

		AddIncomingDamageModifiers =
		{
			MaxSpeedMultiplier =
			{
				BaseValue = 0.6,
				SourceIsMultiplier = true,
			},
			GlobalMultiplier = 1,
			ExtractValues =
			{
				{
					Key = "MaxSpeedMultiplier",
					ExtractAs = "TooltipDamageReduction",
					Format = "NegativePercentDelta",
				},
			}
		},

		WeaponDataOverride =
		{
			FistWeaponSpecial =
			{
				ChargeCameraMotion = { ZoomType = "Overshoot", Fraction = 0.85, Duration = 0.18 },
				ChargeCancelCameraMotion = { ZoomType = "Ease", Fraction = 1.0, Duration = 0.2 },
				FireScreenshake = {},
				Sounds =
				{
					ChargeSounds =
					{
						{
							Name = "/SFX/Player Sounds/ZagreusWeaponChargeup",
							Key = "FistRushTrait",
							StoppedBy = { "ChargeCancel", "TriggerRelease", "Fired" },
							SetPitchToPropertyValue = "ChargeTime",
						},
						{
							Name = "/VO/ZagreusEmotes/EmoteCharging_Bow",
							StoppedBy = { "ChargeCancel", "TriggerRelease", "Fired" },
						}
					},

					FireSounds =
					{
						{ Name = "/VO/ZagreusEmotes/EmoteAttacking_FistKick" },
						{ Name = "/SFX/Player Sounds/ZagreusFistBigWhoosh" },
					},
					ImpactSounds =
					{
						Invulnerable = "/SFX/FistImpactSmall",
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

		SetupFunction =
		{
			Name = "FistRushSetUpGlobals",
		},
		OnEnemyDamagedFunction =
		{
			Name = "FistRushAttack",
		},

		PropertyChanges =
		{

			--- SPECIAL RUSH ---

			{
				WeaponNames = { "FistSpecialMiniDash" },
				WeaponProperty = "BlinkDuration",
				ChangeValue = 0.26,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistSpecialMiniDash" },
				WeaponProperty = "BlinkMaxRange",
				ChangeValue = 800,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- CHARGED SPECIAL ---

			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.12,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "MinChargeToFire",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "FireOnRelease",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ForceReleaseOnFire",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "Cooldown",
				ChangeValue = 0.7,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "FullyAutomatic",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "LockTriggerForCharge",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AcceptTriggerLockRequests",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ChargeCancelMovement",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "BlockMoveInput",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "RootOwnerWhileFiring",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				EffectName = "FistSpecialDisable",
				EffectProperty = "DisableMove",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- SPECIAL PROJECTILE ---

			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "NumProjectiles",
				ChangeValue = 1,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "DamageLow",
				ChangeValue = 25,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "DamageHigh",
				ChangeValue = 25,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "ProjectileDefenseRadius",
				ChangeValue = 150,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- AIM LINE ---

			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ShowFreeAimLine",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AimLineAnimation",
				ChangeValue = "AuraAimLineShield",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "Scale",
				ChangeValue = 0.3,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "Range",
				ChangeValue = 1,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ChargeRangeMultiplier",
				ChangeValue = 700,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- GRAPHICAL CHANGES ---
			--- Aspect of Demeter

			{
				WeaponNames = { "FistWeapon" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Start",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeapon" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Fire1",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeapon2" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Charge2",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeapon2" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Fire2",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeapon3" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Charge3",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeapon3" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Fire3",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeapon4" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Charge4",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeapon4" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Fire4",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeapon5" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Charge5",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeapon5" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01FlurryPunch_Fire5",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponDash" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01DashHayMaker_Charge",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponDash" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01DashHayMaker_Fire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01AerialUpperCut_Start",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01FlashKick_Fire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecialDash" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01DashUpperCut_Start",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecialDash" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01DashUpperCut_Fire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "FireFx",
				ChangeValue = "FistFxUppercutDirectional_FlashKick",
				ExcludeLinked = true,
			},
			{
				TraitName = "FistHeavyAttackTrait",
				WeaponName = "FistWeapon2",
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01DashHayMaker_Fire",
				ChangeType = "Absolute",
			},
			{
				TraitName = "FistHeavyAttackTrait",
				WeaponName = "FistWeapon3",
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01Grab_Start",
				ChangeType = "Absolute",
			},
			{
				TraitName = "FistHeavyAttackTrait",
				WeaponName = "FistWeapon3",
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01Grab_Fire",
				ChangeType = "Absolute",
			},
		},
	}
