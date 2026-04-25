--[[ List of hammers:
SwordHealthBufferDamageTrait (Breaching slash)
SwordCursedLifeStealTrait (Cursed slash)
SwordBackstabTrait (Shadow slash)
SwordThrustWaveTrait (Piercing wave)
SwordCriticalTrait (Cruel thrust)
SwordSecondaryDoubleAttackTrait (Double nova)
SwordAndShieldChargeSpeedTrait (Sudden rush)
SwordAndShieldPerfectRushTrait (Minotaur rush)
SwordAndShieldRushProjectileTrait (Charged shot)
SwordAndShieldBlockEmpowerTrait (Ferocious guard)
SwordAndShieldBashDamageTrait (Pulverizing blow)
SwordAndShieldDashAOETrait (NEW - Dashing spin)
]]

local excludeHammers = { "SwordTwoComboTrait", "SwordHeavySecondStrikeTrait", "SwordBlinkTrait", "SwordSecondaryAreaDamageTrait", "SwordDoubleDashAttackTrait", "SwordGoldDamageTrait" }
for i, hammer in ipairs(excludeHammers) do
	TraitData[hammer].RequiredFalseTraits = TraitData[hammer].RequiredFalseTraits or {}
	table.insert(TraitData[hammer].RequiredFalseTraits, "SwordAndShieldTrait")
end

-- New!
-- Same effect as dashing wallop, but with the spear spin graphics
TraitData.SwordAndShieldDashAOETrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Sword_14",
	RequiredWeapon = "SwordWeapon",
	RequiredTrait = "SwordAndShieldTrait",

	AddOutgoingDamageModifiers =
	{
		ValidWeaponMultiplier = 1.5,
		ValidWeapons = { "SwordWeaponDash" },
		ExcludeLinked = true,
		ExtractValues =
		{
			{
				Key = "ValidWeaponMultiplier",
				ExtractAs = "TooltipDamageIncrease",
				Format = "PercentDelta",
			},
		},
	},

	WeaponDataOverride =
	{
		SwordWeaponDash =
		{
			Sounds =
			{
				FireSounds =
				{
					{ Name = "/VO/ZagreusEmotes/EmoteAttacking_Bow" },
					{ Name = "/SFX/Player Sounds/ZagreusSpearSwipe" },
				},
				ChargeSounds =
				{
					{ Name = "/VO/ZagreusEmotes/EmoteCharging" },
					{
						Name = "/Leftovers/SFX/AuraCharge" ,
						StoppedBy = { "TriggerRelease" }
					},
				},
				ImpactSounds =
				{
					Invulnerable = "/SFX/SwordWallHitClank",
					Armored = "/SFX/Player Sounds/ZagreusShieldRicochet",
					Bone = "/SFX/MetalBoneSmash",
					Brick = "/SFX/MetalStoneClang",
					Stone = "/SFX/MetalStoneClang",
					Organic = "/SFX/StabSplatterSmall",
					StoneObstacle = "/SFX/SwordWallHitClank",
					BrickObstacle = "/SFX/SwordWallHitClank",
					MetalObstacle = "/SFX/SwordWallHitClank",
					BushObstacle = "/Leftovers/World Sounds/LeavesRustle",
				},
			},
		},
	},

	PropertyChanges =
	{
		{
			WeaponName = "SwordWeaponDash",
			ProjectileProperty = "DetonateGraphic",
			ChangeValue = "SpearSwipe360",
			ExcludeLinked = true,
		},
		{
			WeaponNames = {  "SwordWeaponDash" },
			WeaponProperty = "FireFx",
			ChangeValue = "null",
			ExcludeLinked = true,
		},
		{
			WeaponName = "SwordWeaponDash",
			ProjectileProperty = "DamageRadius",
			ChangeValue = 285,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "SwordWeaponDash",
			ProjectileProperty = "DamageRadiusScaleY",
			ChangeValue = 0.62,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "SwordWeaponDash",
			ProjectileProperty = "ProjectileDefenseAngle",
			ChangeValue = 360,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "SwordWeaponDash",
			ProjectileProperty = "ProjectileDefenseRadius",
			ChangeValue = 285,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "SwordWeaponDash",
			WeaponProperty = "BarrelLength",
			ChangeValue = 85,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "SwordWeaponDash",
			ProjectileProperty = "RequireHitCenter",
			ChangeValue = false,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "SwordWeaponDash",
			ProjectileProperty = "BlastDuration",
			ChangeValue = 0.3,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "SwordWeaponDash",
			ProjectileProperty = "Fuse",
			ChangeValue = 0,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "SwordWeaponDash",
			WeaponProperty = "AutoLock",
			ChangeValue = false,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
	},
}

local gods = { "Zeus", "Athena", "Poseidon", "Artemis", "Aphrodite", "Ares", "Dionysus", "Demeter", "Apollo", "Hestia", "Hera" }
for i, godName in ipairs(gods) do
	table.insert(TraitData.SwordAndShieldDashAOETrait.PropertyChanges,
	{
		TraitName = godName .. "WeaponTrait",
		WeaponName = "SwordWeaponDash",
		ProjectileProperty = "DetonateGraphic",
		ChangeValue = "SpearSwipe360-" .. godName,
		ExcludeLinked = true,
	})
	table.insert(TraitData.SwordAndShieldDashAOETrait.PropertyChanges,
	{
		TraitName = godName .. "WeaponTrait",
		WeaponName = "SwordWeaponDash",
		WeaponProperty = "FireFx",
		ChangeValue = "null",
		ExcludeLinked = true,
	})
end

TraitData.SwordAndShieldChargeSpeedTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Shield_05",
	RequiredWeapon = "SwordWeapon",
	RequiredTrait = "SwordAndShieldTrait",
	PropertyChanges =
	{
		{
			WeaponName = "ShieldWeaponRush",
			WeaponProperty = "ChargeTime",
			ChangeValue = 0.5,
			ChangeType = "Multiply",
		},
	},
}

TraitData.SwordAndShieldPerfectRushTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Shield_08",
	RequiredWeapon = "SwordWeapon",
	RequiredTrait = "SwordAndShieldTrait",
	AddOutgoingDamageModifiers =
	{
		ValidWeapons = { "ShieldWeaponRush" },
		PerfectChargeMultiplier = 6.0,
		ExcludeLinked = true,
		ExtractValues =
		{
			{
				Key = "PerfectChargeMultiplier",
				ExtractAs = "TooltipDamageIncrease",
				Format = "PercentDelta",
			}
		},
	},
	PropertyChanges =
	{
		{
			WeaponName = "ShieldWeaponRush",
			WeaponProperty = "PerfectChargeWindowDuration",
			ChangeValue = 0.2,
			ChangeType = "Absolute",
		},
		{
			WeaponName = "ShieldWeaponRush",
			WeaponProperty = "PerfectChargeVelocityMultiplier",
			ChangeValue = 1.0,
			ChangeType = "Absolute",
		},
	},
}

TraitData.SwordAndShieldRushProjectileTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Shield_09",
	RequiredWeapon = "SwordWeapon",
	RequiredTrait = "SwordAndShieldTrait",
	WeaponDataOverride =
	{
		ShieldWeaponRush =
		{
			FireScreenshake = { Distance = 0, Speed = 0, FalloffSpeed = 1200, Duration = 0.2 },
			Sounds =
			{
				FireSounds =
				{
					PerfectChargeSounds =
					{
						{ Name = "/SFX/Player Sounds/ZagreusCriticalFire" },
						{ Name = "/VO/ZagreusEmotes/EmoteAttacking_BowPowerShot" },
						{ Name = "/SFX/Player Sounds/ZagreusBowFire" },
					},
					{ Name = "/VO/ZagreusEmotes/EmoteParrying" },
					{ Name = "/SFX/Player Sounds/ZagreusShieldRush" },
					{ Name = "/Leftovers/SFX/AuraThrowSmall" },
				},
				ChargeSounds =
				{
					{
						Name = "/SFX/Player Sounds/ZagreusWeaponChargeup",
						Key = "ShieldRushProjectileTrait",
						StoppedBy = { "ChargeCancel", "TriggerRelease", "Fired" },
						SetPitchToPropertyValue = "ChargeTime",
					},
					{
						Name = "/VO/ZagreusEmotes/EmoteRangedCharging",
						StoppedBy = { "ChargeCancel", "TriggerRelease", "Fired" },
					}
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
		{
			WeaponName = "ShieldWeaponRush",
			WeaponProperty = "SelfVelocity",
			ChangeValue = 0,
		},
		{
			WeaponName = "ShieldWeaponRush",
			ProjectileProperty = "AttachToOwner",
			ChangeValue = false,
		},
		{
			WeaponName = "ShieldWeaponRush",
			WeaponProperty = "ChargeRangeMultiplier",
			ChangeValue = 5,
		},
		{
			WeaponName = "ShieldWeaponRush",
			ProjectileProperty = "Speed",
			ChangeValue = 6000,
		},
		{
			WeaponName = "ShieldWeaponRush",
			ProjectileProperty = "IgnoreCoverageAngles",
			ChangeValue = true,
		},
		{
			WeaponName = "ShieldWeaponRush",
			ProjectileProperty = "Range",
			ChangeValue = 175,
		},
		{
			WeaponName = "ShieldWeaponRush",
			WeaponProperty = "ChargeDamageMultiplier",
			ChangeValue = 0,
			ChangeType = "Absolute",
		},
		{
			WeaponName = "ShieldWeaponRush",
			ProjectileProperty = "CheckObstacleImpact",
			ChangeValue = true,
			ChangeType = "Absolute",
		},
		{
			WeaponName = "ShieldWeaponRush",
			ProjectileProperty = "NumPenetrations",
			ChangeValue = 0,
			ChangeType = "Absolute",
		},
		{
			WeaponName = "ShieldWeaponRush",
			EffectName = "ShieldFireSelfInvulnerable",
			EffectProperty = "Active",
			ChangeValue = false,
			ChangeType = "Absolute",
		},
		{
			WeaponName = "ShieldWeaponRush",
			EffectName = "ShieldFireDisableAttack",
			EffectProperty = "Active",
			ChangeValue = false,
			ChangeType = "Absolute",
		},
		{
			WeaponName = "ShieldWeaponRush",
			EffectName = "ShieldFireDisableMove",
			EffectProperty = "Active",
			ChangeValue = false,
			ChangeType = "Absolute",
		},
		{
			WeaponNames = { "ShieldWeaponRush" },
			ProjectileProperty = "DamageLow",
			ChangeValue = 80,
			ChangeType = "Absolute",
			ExcludeLinked = true,
			ExtractValue =
			{
				ExtractAs = "TooltipDamage",
			},
		},
		{
			WeaponNames = { "ShieldWeaponRush" },
			ProjectileProperty = "DamageHigh",
			DeriveValueFrom = "DamageLow",
		},
		{
			WeaponNames = { "ShieldWeaponRush" },
			ProjectileProperty = "ObstacleCollisionCheck",
			ChangeValue = "PolygonContainsPoint",
			ExcludeLinked = true,
		},
		{
			TraitName = "AthenaWeaponTrait",
			WeaponNames = { "ShieldWeaponRush" },
			ProjectileProperty = "DeflectProjectiles",
			ChangeValue = true,
			ExcludeLinked = true,
		},
		{
			TraitName = "AthenaWeaponTrait",
			WeaponNames = { "ShieldWeaponRush" },
			ProjectileProperty = "ProjectileDefenseRadius",
			ChangeValue = 120,
			ExcludeLinked = true,
		},
		{
			TraitName = "AthenaWeaponTrait",
			WeaponNames = { "ShieldWeaponRush" },
			ProjectileProperty = "ProjectileDefenseAngle",
			ChangeValue = math.rad(100),
			ExcludeLinked = true,
		}
	}
}

TraitData.SwordAndShieldBlockEmpowerTrait =
{
	Icon = "Weapon_Shield_14",
	InheritFrom = { "WeaponTrait" },
	PreEquipWeapons = { "BlockEmpowerApplicator"},
	OnBlockDamageFunctionName = "AddBlockEmpower",
	RequiredWeapon = "SwordWeapon",
	RequiredTrait = "SwordAndShieldTrait",
	PropertyChanges =
	{
		{
			WeaponName = "BlockEmpowerApplicator",
			EffectName = "BlockDamageBonus",
			EffectProperty = "Modifier",
			BaseValue = 0.2,
			ChangeType = "Add",
			ExtractValue =
			{
				ExtractAs = "TooltipDamage",
				Format = "Percent"
			}
		},
		{
			WeaponName = "BlockEmpowerApplicator",
			EffectName = "BlockMoveSpeed",
			EffectProperty = "Modifier",
			BaseValue = 0.2,
			ChangeType = "Add",
		},
		{
			WeaponName = "BlockEmpowerApplicator",
			EffectName = "BlockDamageBonus",
			EffectProperty = "Duration",
			ChangeValue = 10,
			ChangeType = "Absolute",
			ExtractValue =
			{
				ExtractAs = "TooltipDuration",
			}
		},
		{
			WeaponName = "BlockEmpowerApplicator",
			EffectName = "BlockMoveSpeed",
			EffectProperty = "Duration",
			ChangeValue = 10,
			ChangeType = "Absolute",
		},
	}
}
