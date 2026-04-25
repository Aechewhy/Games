	TraitData.SwordAndShieldTrait =
	{
		Icon = "WeaponEnchantment_Sword_DDAspects",
		CustomTrayText = "SwordAndShieldTrait_Tray",
		InheritFrom = { "WeaponEnchantmentTrait" },
		PostWeaponUpgradeScreenAnimation = "ZagreusShieldAlt02Idle",
		PostWeaponUpgradeScreenAngle = 180,
		PreEquipWeapons = { "ShieldWeaponRush" },

		RarityLevels =
		{
			Common    = { Multiplier = 1 },
			Rare      = { Multiplier = 2 },
			Epic      = { Multiplier = 3 },
			Heroic    = { Multiplier = 4 },
			Legendary = { Multiplier = 5 },
		},
		AddOutgoingDamageModifiers =
		{
			ValidWeaponMultiplier =
			{
				BaseValue = 1.04,
				SourceIsMultiplier = true,
			},
			ValidWeapons = { "SwordParry" },
			ExtractValues =
			{
				{
					Key = "ValidWeaponMultiplier",
					ExtractAs = "TooltipDamage",
					Format = "PercentDelta",
				},
			}
		},
		OnWeaponChargeFunctions =
		{
			ValidWeapons = { "SwordWeapon3" },
			FunctionName = "SwordAndShieldSlowCharge",
		},

		WeaponDataOverride =
		{
			SwordWeapon3 =
			{
				Sounds =
				{
					ChargeSounds =
					{
						{
							Name = "/Leftovers/SFX/AuraCharge" ,
							StoppedBy = { "TriggerRelease" }
						},
					},
					FireSounds =
					{
						--{ Name = "/VO/ZagreusEmotes/EmotePowerAttacking_Sword" },
						{ Name = "/VO/ZagreusEmotes/EmoteRanged" },
						{ Name = "/SFX/Player Sounds/ZagreusShieldSwipe" },
					},
					ImpactSounds =
					{
						Invulnerable = "/SFX/SwordWallHitClank",
						Armored = "/SFX/Player Sounds/ZagreusShieldRicochet",
						Bone = "/SFX/MetalBoneSmashSHIELD",
						Brick = "/SFX/MetalStoneClangSHIELD",
						Stone = "/SFX/MetalStoneClangSHIELD",
						Organic = "/SFX/MetalOrganicHitSHIELD",
						StoneObstacle = "/SFX/Player Sounds/ShieldObstacleHit",
						BrickObstacle = "/SFX/Player Sounds/ShieldObstacleHit",
						MetalObstacle = "/SFX/Player Sounds/ShieldObstacleHit",
						BushObstacle = "/Leftovers/World Sounds/LeavesRustle",
					},
				},
			},
		},

		PropertyChanges =
		{
			--- BULL RUSH ---

			{
				WeaponNames = { "SwordWeapon", "SwordWeapon2", "SwordWeapon3", "SwordWeaponDash" },
				WeaponProperty = "AddOnFire",
				ChangeValue = "ShieldWeaponRush",
				ExcludeLinked = true,
			},
			{
				WeaponName = "ShieldWeaponRush",
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusShieldAlt02AttackCharge",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "ShieldWeaponRush",
				WeaponProperty = "ChargeCancelGraphic",
				ChangeValue = "ZagreusShieldAlt02AttackChargeCancel",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "ShieldWeaponRush",
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusShieldAlt02AttackFire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- SPECIAL ---
			-- Enable charging the special during bull rush
			{
				WeaponName = "SwordParry",
				WeaponProperty = "IgnoreOwnerAttackDisabled",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordParry",
				ProjectileProperty = "DamageRadius",
				BaseValue = 1.04,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},

			--- ATTACK 3 PROJECTILE ---
			--- Becomes a shield bash

			{
				WeaponName = "SwordWeapon3",
				WeaponProperty = "BarrelLength",
				ChangeValue = 150,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				ProjectileProperty = "Range",
				ChangeValue = 1,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				ProjectileProperty = "Speed",
				ChangeValue = 3000,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				ProjectileProperty = "DamageRadius",
				ChangeValue = 160,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				ProjectileProperty = "Fuse",
				ChangeValue = 0.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				ProjectileProperty = "BlastDuration",
				ChangeValue = 0.1,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				ProjectileProperty = "DamageRadiusScaleX",
				ChangeValue = 1.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				ProjectileProperty = "DamageRadiusScaleY",
				ChangeValue = 0.7,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			--- ATTACK 3 WEAPON ---

			{
				WeaponName = "SwordWeapon3",
				WeaponProperty = "SelfVelocity",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				WeaponProperty = "SelfVelocityCap",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				WeaponProperty = "RootOwnerWhileFiring",
				ChangeValue = false,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				WeaponProperty = "BlockMoveInput",
				ChangeValue = false,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				WeaponProperty = "ChargeCancelMovement",
				ChangeValue = false,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				EffectName = "SwordDisableCancelable3",
				EffectProperty = "Active",
				ChangeValue = false,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusShieldAlt02PunchFast",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusShieldAlt02Punch",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				ProjectileProperty = "DetonateGraphic",
				ChangeValue = "ShieldSwipe",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SwordWeapon3",
				WeaponProperty = "FireFx",
				ChangeValue = "null",
				ExcludeLinked = true,
			},
		},
		SetupFunction =
		{
			Name = "SwordAndShieldSetup",
		},
	}

-- Player moves slowly when charging attack 3
function SwordAndShieldSlowCharge( unit, args )
	local modifier = 0.3
	local duration = 0.25
	SetUnitProperty({ Property = "Speed", Value = modifier, ValueChangeType = "Multiply", DestinationId = CurrentRun.Hero.ObjectId })
	wait( duration )
	SetUnitProperty({ Property = "Speed", Value = 1/modifier, ValueChangeType = "Multiply", DestinationId = CurrentRun.Hero.ObjectId })
end

-- Some dirty bug fixing
function SwordAndShieldSetup( unit, args )
	CurrentRun.Hero.Weapons.ShieldWeaponRush = true
end

-- Graphical changes for attack 3
local gods = { "Zeus", "Athena", "Poseidon", "Artemis", "Aphrodite", "Ares", "Dionysus", "Demeter", "Apollo", "Hestia", "Hera" }
for i, godName in ipairs(gods) do
	table.insert(TraitData.SwordAndShieldTrait.PropertyChanges,
	{
		TraitName = godName .. "WeaponTrait",
		WeaponName = "SwordWeapon3",
		ProjectileProperty = "DetonateGraphic",
		ChangeValue = "ShieldSwipe-" .. godName,
		ExcludeLinked = true,
	})
	table.insert(TraitData.SwordAndShieldTrait.PropertyChanges,
	{
		TraitName = godName .. "WeaponTrait",
		WeaponName = "SwordWeapon3",
		WeaponProperty = "FireFx",
		ChangeValue = "null",
		ExcludeLinked = true,
	})
end
