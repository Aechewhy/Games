--[[ List of hammers:
FistHeavyAttackTrait (Heavy knuckle)
FistReachAttackTrait (Long knuckle)
FistConsecutiveAttackTrait (Concentrated knuckle)
FistDashAttackHealthBufferTrait (Breaching cross)
FistAttackFinisherTrait (Rolling knuckle)
FistDoubleDashSpecialTrait (Explosive upper)
FistKillTrait (Draining cutter)
FistSpecialLandTrait (Quake cutter)
FistRushChargeTrait (NEW - Centaur kick)
FistRushFireballTrait (NEW - Sync shot)
]]

local excludeHammers = { "FistChargeSpecialTrait", "FistTeleportSpecialTrait", "FistSpecialFireballTrait", "FistAttackDefenseTrait" }
for i, hammer in ipairs(excludeHammers) do
	TraitData[hammer].RequiredFalseTraits = TraitData[hammer].RequiredFalseTraits or {}
	table.insert(TraitData[hammer].RequiredFalseTraits, "FistRushTrait")
end

-- New!
-- Special charges in real time and deals up to 100 base damage
TraitData.FistRushChargeTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Fist_05",
	RequiredWeapon = "FistWeapon",
	RequiredTrait = "FistRushTrait",
	RequiredFalseTraits = { "FistRushFireballTrait" },
	WeaponDataOverride =
	{
		FistWeaponSpecial =
		{
			ChargeCameraMotion = { ZoomType = "None" },
			FireCameraMotion = { ZoomType = "None" },
		}
	},
	PropertyChanges =
	{
		{
			WeaponNames = { "FistWeaponSpecial" },
			WeaponProperty = "ChargeTime",
			ChangeValue = 0.6,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponNames = { "FistWeaponSpecial" },
			WeaponProperty = "ChargeDamageMultiplier",
			ChangeValue = 4,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponNames = { "FistWeaponSpecial" },
			WeaponProperty = "ChargeStartFx",
			ChangeValue = "FistChargeUppercutTrait",
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
	}
}

-- New!
-- Ranged special like kinetic launcher, charges for 1 sec (0.2 at 20% speed)
-- Zag says Huh Ha Yeah to help the player time it correctly
-- Got this idea from Rekka (Hi-fi rush) ^-^
	TraitData.FistRushFireballTrait =
	{
		InheritFrom = { "WeaponTrait" },
		Icon = "Weapon_Fist_10",
		RequiredFalseTraits = { "FistDoubleDashSpecialTrait", "FistSpecialLandTrait", "FistRushChargeTrait", "HermesSecondaryTrait" },
		RequiredWeapon = "FistWeapon",
		RequiredTrait = "FistRushTrait",
		WeaponDataOverride =
		{
			FistWeaponSpecial =
			{
				ChargeCameraMotion = { ZoomType = "Overshoot", Fraction = 0.9, Duration = 0.2 },
				ChargeCancelCameraMotion = { ZoomType = "Ease", Fraction = 1.0, Duration = 0.1 },
				HitSimSlowCooldown = 0.2,
				HitSimSlowParameters =
				{
						{ ScreenPreWait = 0.02, Fraction = 0.2, LerpTime = 0 },
						{ ScreenPreWait = 0.02, Fraction = 1.0, LerpTime = 0.0 },
				},
				Sounds =
				{
					--[[
					ChargeSounds =
					{
						{
							Name = "/SFX/Player Sounds/ZagreusWeaponChargeup",
							Key = "FistSpecialFireballTrait",
							StoppedBy = { "ChargeCancel", "TriggerRelease", "Fired" },
							SetPitchToPropertyValue = "ChargeTime",
						},
					},
					]]
					FireSounds =
					{
						PerfectChargeSounds =
						{
							{ Name = "/VO/ZagreusEmotes/EmoteAttacking_FistKick" },
						},

						{ Name = "/Leftovers/SFX/AuraThrow" },
						{ Name = "/SFX/Player Sounds/ZagreusSpearThrow" },
					},
					ImpactSounds =
					{
						Invulnerable = "/SFX/SwordWallHitClank",
						Armored = "/SFX/Player Sounds/ZagreusShieldRicochet",
						Bone = "/SFX/ArrowMetalBoneSmash",
						Brick = "/SFX/ArrowMetalStoneClang",
						Stone = "/SFX/ArrowMetalStoneClang",
						Organic = "/SFX/ArrowImpactSplatter",
						StoneObstacle = "/SFX/SwordWallHitClankSmall",
						BrickObstacle = "/SFX/SwordWallHitClankSmall",
						MetalObstacle = "/SFX/SwordWallHitClankSmall",
						BushObstacle = "/Leftovers/World Sounds/LeavesRustle",
					},
				},
			},
		},

		PropertyChanges =
		{
			-- My stuff

			{
				WeaponNames = { "FistWeaponSpecialDash" },
				WeaponProperty = "Enabled",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecialDash" },
				WeaponProperty = "ControlWindow",
				ChangeValue = 0.15,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.2,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "Cooldown",
				ChangeValue = 0.8,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "PerfectChargeDamageMultiplier",
				ChangeValue = 2.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
				ExtractValues =
				{
					{
						ExtractAs = "TooltipDamageIncrease",
						Format = "PercentDelta",
					}
				},
			},

			-- Stuff from FistSpecialFireballTrait 

			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "DetonateGraphic",
				ChangeValue = "EnemyConeAttackLoopEnd",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "DetonateSound",
				ChangeValue = "/SFX/Enemy Sounds/EnemyProjectileDetonateExplode",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "AttachToOwner",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "DissipateGraphic",
				ChangeValue = "null",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "Fuse",
				ChangeValue = 8,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "Speed",
				ChangeValue = 600,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "Acceleration",
				ChangeValue = 2450,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "ObstacleCollisionCheck",
				ChangeValue = "PolygonContainsPoint",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "UnitCollisionCheck",
				ChangeValue = "Polygon",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "RelativeExtentScale",
				ChangeValue = 0.35,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "OriginX",
				ChangeValue = 50,
				ChangeType = "Add",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "UnlimitedUnitPenetration",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "ProjectileDefenseRadius",
				ChangeValue = 100,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "DamageRadius",
				ChangeValue = 180,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "RequireHitCenter",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "GroupName",
				ChangeValue = "FX_Add_Top",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "UseRadialImpact",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "NumPenetrations",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "ProjectileDefenseAngle",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "ImpactLineOfSightFromOwner",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "Graphic",
				ChangeValue = "FistFireballFx",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "DamageLow",
				ChangeValue = 50,
				ChangeType = "Absolute",
				ExcludeLinked = true,
				ExtractValue =
				{
					ExtractAs = "TooltipDamage",
				},
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "DamageHigh",
				DeriveValueFrom = "DamageLow",
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "BarrelLength",
				ChangeValue = 50,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AutoLockRange",
				ChangeValue = 1110,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AutoLock",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AutoLockArcDistance",
				ChangeValue = 120,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusFistAlt01Grab_Start",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusFistAlt01Grab_Fire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ChargeStartFx",
				ChangeValue = "FistChargeSpecialTrait",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "MinChargeToFire",
				ChangeValue = 0.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "PerfectChargeWindowDuration",
				ChangeValue = 0.15,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "PerfectChargeSpeedMultiplier",
				ChangeValue = 2.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "ChargeRangeMultiplier",
				ChangeValue = 9,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "SelfVelocity",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "SelfVelocityCap",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				ProjectileProperty = "Range",
				ChangeValue = 100,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AllowExternalForceRelease",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "AllowExternalForceReleaseIfAnyCharged",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				WeaponProperty = "MinChargeStartFx",
				ChangeValue = "FistChargeFocusedFire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				EffectName = "FistSpecialFireHalt",
				EffectProperty = "Active",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				EffectName = "FistSpecialFireDisable",
				EffectProperty = "Active",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				EffectName = "FistSpecialFireMoveCancel",
				EffectProperty = "Active",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				EffectName = "FistSpecialDisable",
				EffectProperty = "Active",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				EffectName = "FistSpecialDisableCancelable",
				EffectProperty = "Active",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "FistWeaponSpecial" },
				EffectName = "FistSpecialInvulnerable",
				EffectProperty = "Active",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "FistWeaponSpecial",
				ProjectileProperty = "AttachedPowershotAnimation",
				ChangeValue = "BowWeaponPowerShot",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
		},
	}

local gods = { "Zeus", "Athena", "Poseidon", "Artemis", "Aphrodite", "Ares", "Dionysus", "Demeter", "Apollo", "Hestia", "Hera" }
for i, godName in ipairs(gods) do
	table.insert(TraitData.FistRushFireballTrait.PropertyChanges,
	{
		TraitName = godName .. "SecondaryTrait",
		WeaponName = "FistWeaponSpecial",
		ProjectileProperty = "Graphic",
		ChangeValue = "FistFireballFx-" .. godName,
		ExcludeLinked = true,
	})
	table.insert(TraitData.FistRushFireballTrait.PropertyChanges,
	{
		TraitName = godName .. "SecondaryTrait",
		WeaponName = "FistWeaponSpecial",
		WeaponProperty = "FireFx",
		ChangeValue = "null",
		ExcludeLinked = true,
	})
end

table.insert(TraitData.FistRushFireballTrait.PropertyChanges,
{
	WeaponName = "FistWeaponSpecial",
	WeaponProperty = "FireFx",
	ChangeValue = "null",
	ExcludeLinked = true,
})

table.insert(TraitData.FistDoubleDashSpecialTrait.RequiredFalseTraits, "FistRushFireballTrait")
table.insert(TraitData.FistSpecialLandTrait.RequiredFalseTraits, "FistRushFireballTrait")
table.insert(TraitData.HermesSecondaryTrait.RequiredFalseTraits, "FistRushFireballTrait") -- won't let Hermes mess up the timing
