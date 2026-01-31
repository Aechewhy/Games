	TraitData.SpearJumpTrait =
	{
		InheritFrom = { "WeaponEnchantmentTrait" },
		Icon = "WeaponEnchantment_Spear_DDAspects",
		PostWeaponUpgradeScreenAnimation = "ZagreusSpearAlt03ThrowFireReturn",
		RequiredWeapons = {"SpearWeapon", "SpearWeaponThrow"},
		CustomTrayText = "SpearJumpTrait_Tray",

		RarityLevels =
		{
			Common =
			{
				Multiplier = 1,
			},
			Rare =
			{
				Multiplier = 2,
			},
			Epic =
			{
				Multiplier = 3,
			},
			Heroic =
			{
				Multiplier = 4,
			},
			Legendary =
			{
				Multiplier = 5,
			},
		},

		WeaponDataOverride =
		{
			SpearWeapon =
			{
				DashSwaps = { "SpearWeapon" },
				Sounds =
				{
					FireSounds =
					{
						{ Name = "/VO/ZagreusEmotes/EmoteMartialSpearAttack" },
						{ Name = "/SFX/Player Sounds/ZagreusSpearThrust" },
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
			SpearWeapon2 =
			{	
				DashWeapon = nil,
				Sounds =
				{
					FireSounds =
					{
						{ Name = "/VO/ZagreusEmotes/EmotePowerAttacking_Sword" },
						{ Name = "/SFX/Player Sounds/ZagreusSpearThrust" },
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
			SpearWeapon3 =
			{
				DashWeapon = nil,
				Sounds =
				{
					FireSounds =
					{
						{ Name = "/VO/ZagreusEmotes/EmoteAttacking_FistKick" },
						{ Name = "/SFX/Player Sounds/ZagreusSwordOverhead" },
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
			SpearWeaponDash =
			{
				Sounds =
				{
					FireSounds =
					{
						{ Name = "/VO/ZagreusEmotes/EmotePowerAttacking_Sword" },
						{ Name = "/SFX/Player Sounds/ZagreusSpearThrust" },
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
			SpearWeaponThrow =
			{
				Sounds =
				{
					FireSounds =
					{
						{ Name = "/SFX/Player Sounds/ZagreusBowFire" },
						{ Name = "/SFX/Player Sounds/ZagreusSpearThrow" },
						{
							Name = "/VO/ZagreusEmotes/EmoteMartialSpearThrow",
							Cooldown = 0.5
						},
					},
					ChargeSounds =
					{
						{ Name = "/VO/ZagreusEmotes/EmoteCharging" },
						{
							Name = "/Leftovers/SFX/AuraCharge" ,
							StoppedBy = { "TriggerRelease" },
							SetPitchToPropertyValue = "ChargeTime",
						},
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

			--- ATTACK 1 ---

			{
				WeaponName = "SpearWeapon",
				ProjectileProperty = "DamageLow",
				ChangeValue = 30,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon",
				ProjectileProperty = "DamageHigh",
				ChangeValue = 30,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon",
				ProjectileProperty = "ImpactVelocity",
				ChangeValue = 1200,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon",
				ProjectileProperty = "ImpactVelocityCap",
				ChangeValue = 1200,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- ATTACK 2 ---

			{
				WeaponName = "SpearWeapon2",
				ProjectileProperty = "DamageLow",
				ChangeValue = 50,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon2",
				ProjectileProperty = "DamageHigh",
				ChangeValue = 50,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon2",
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.33,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon2",
				WeaponProperty = "ControlWindow",
				ChangeValue = 0.43,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon2",
				EffectName = "SpearLunarAerialSlow2",
				EffectProperty = "Active",
				ChangeValue = true,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon2",
				ProjectileProperty = "ImpactVelocity",
				ChangeValue = 2000,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon2",
				ProjectileProperty = "ImpactVelocityCap",
				ChangeValue = 2000,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- ATTACK 3 ---

			{
				WeaponName = "SpearWeapon3",
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.52,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon3",
				WeaponProperty = "ControlWindow",
				ChangeValue = 0.70,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon3",
				EffectName = "SpearLunarAerialSlow3",
				EffectProperty = "Active",
				ChangeValue = true,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon3",
				ProjectileProperty = "DamageLow",
				ChangeValue = 80,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon3",
				ProjectileProperty = "DamageHigh",
				ChangeValue = 80,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon3",
				ProjectileProperty = "ImpactVelocity",
				ChangeValue = 2500,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeapon3",
				ProjectileProperty = "ImpactVelocityCap",
				ChangeValue = 2500,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- DASH ATTACK ---
			--- Same projectile as attack 1

			{
				WeaponName = "SpearWeaponDash",
				WeaponProperty = "Projectile",
				ChangeValue = "SpearWeapon",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponDash",
				WeaponProperty = "ControlWindow",
				ChangeValue = 0.20,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponDash",
				ProjectileProperty = "DamageLow",
				ChangeValue = 30,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponDash",
				ProjectileProperty = "DamageHigh",
				ChangeValue = 30,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponDash",
				ProjectileProperty = "ImpactVelocity",
				ChangeValue = 1200,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponDash",
				ProjectileProperty = "ImpactVelocityCap",
				ChangeValue = 1200,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponDash",
				WeaponProperty = "SelfVelocity",
				ChangeValue = 400,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			-- increased range for extra smoothness
			{
				WeaponName = "SpearWeaponDash",
				ProjectileProperty = "Range",
				ChangeValue = 100,
				ChangeType = "Add",
				ExcludeLinked = true,
			},

			--- SPECIAL ---
			--- Same as Guan Yu, but faster

			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "DamageLow",
				ChangeValue = 30,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "DamageHigh",
				ChangeValue = 30,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.2,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "ReloadTime",
				ChangeValue = 0.45,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "DamageRadius",
				ChangeValue = 250,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "DamageRadiusScaleX",
				ChangeValue = 1.1,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "DamageRadiusScaleY",
				ChangeValue = 0.67,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "SwapOnFire",
				ChangeValue = "null",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "RemoveControlOnFire",
				ChangeValue = "null",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "RemoveControlOnFire2",
				ChangeValue = "null",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "RemoveControlOnFire3",
				ChangeValue = "null",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "RemoveControlOnFire4",
				ChangeValue = "null",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "SpawnOnDeath",
				ChangeValue = "null",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "SpawnOnDetonate",
				ChangeValue = "null",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "SpawnCount",
				ChangeValue = 0,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "MultiDetonate",
				ChangeValue = true,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "Fuse",
				ChangeValue = 0.08,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "ImmunityDuration",
				ChangeValue = 0.5,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "UseVulnerability",
				ChangeValue = true,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "Speed",
				ChangeValue = 2500,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "CheckUnitImpact",
				ChangeValue = false,
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "CheckObstacleImpact",
				ChangeValue = true,
				ExcludeLinked = true,
			},

			-- Aim line is larger
--[[
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "Scale",
				ChangeValue = 3,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "AimLineAnimation",
				ChangeValue = "AuraAimLineNoMovement",
			},
]]


			--- UPGRADE LEVELS ---
			--- +15% movement and attack speed

			{
				UnitProperty = "Speed",
				BaseValue = 1.03,
				ChangeType = "Multiply",
				SourceIsMultiplier = true,
			},
			{
				WeaponNames = { "SpearWeapon", "SpearWeapon2", "SpearWeapon3" },
				WeaponProperty = "ChargeTime",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon" },
				EffectName = "SpearDisable",
				EffectProperty = "DurationFrames",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon" },
				EffectName = "SpearDisableCancelableAndLockTrigger",
				EffectProperty = "DurationFrames",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon" },
				EffectName = "SpearDisableCancelableAndLockRotation",
				EffectProperty = "DurationFrames",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon" },
				EffectName = "SpearDashDisableLong",
				EffectProperty = "DurationFrames",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon2" },
				EffectName = "SpearDisable2",
				EffectProperty = "DurationFrames",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon2" },
				EffectName = "SpearDisableCancelableAndLockTrigger2",
				EffectProperty = "DurationFrames",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon2" },
				EffectName = "SpearDisableCancelableAndLockRotation",
				EffectProperty = "DurationFrames",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon3" },
				EffectName = "SpearDisable3",
				EffectProperty = "DurationFrames",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon3" },
				EffectName = "SpearDisableCancelable3",
				EffectProperty = "DurationFrames",
				BaseValue = 0.97,
				SourceIsMultiplier = true,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},

			--- GRAPHICAL CHANGES ---
			--- Aspect of Guan Yu

			{
				WeaponNames = { "SpearWeapon", "SpearWeapon3", "SpearWeaponDash" },
				ProjectileProperty = "AttachedAnim",
				ChangeType = "Absolute",
				ChangeValue = "GuanYuThrust",
				ExcludeLinked = true,
			},
			{
				WeaponNames = {"SpearWeapon2" },
				ProjectileProperty = "AttachedAnim",
				ChangeType = "Absolute",
				ChangeValue = "GuanYuThrust_Flip",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon", "SpearWeaponDash" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusSpearLunarThrust1_Start",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon", "SpearWeaponDash" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusSpearLunarThrust1_Fire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon2" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusSpearLunarThrust2_Start",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon2" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusSpearLunarThrust2_Fire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon3" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusSpearLunarThrust3_Start",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeapon3" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusSpearLunarThrust3_Fire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeaponSpin","SpearWeaponSpin2","SpearWeaponSpin3" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusSpearAlt03SpinStart",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeaponSpin","SpearWeaponSpin2","SpearWeaponSpin3" },
				WeaponProperty = "ChargeCancelGraphic",
				ChangeValue = "ZagreusSpearAlt03SpinStartChargeCancel",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeaponSpin","SpearWeaponSpin2","SpearWeaponSpin3" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusSpearAlt03SpinAttack",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "SpearWeaponSpin","SpearWeaponSpin2","SpearWeaponSpin3" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusSpearAlt03SpinAttack",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusSpearAlt03ThrowCharge",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "ChargeCancelGraphic",
				ChangeValue = "ZagreusSpearAlt03ThrowFireReturnToIdle",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusSpearAlt03ThrowFire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "DetonateGraphic",
				ChangeValue = "GuanYuFirecrackers",
				ExcludeLinked = true,
			},
			{
				WeaponName = "SpearWeaponThrow",
				ProjectileProperty = "DetonateSound",
				ChangeValue = "null",
				ExcludeLinked = true,
			},
		},
		ExtractEntry =
		{
			BaseValue = 0.97,
			SourceIsMultiplier = true,
		},
		ExtractValues =
		{
			{
				Key = "ExtractEntry",
				DecimalPlaces = 2,
				Format = "NegativePercentDelta",
				ExtractAs = "TooltipSpeed",
			},
		}
	}


-- Fix for attack boons switching dash-attack graphics back to default
local gods = { "Zeus", "Athena", "Poseidon", "Artemis", "Aphrodite", "Ares", "Dionysus", "Demeter", "Apollo", "Hestia", "Hera" }
for i, godName in ipairs(gods) do
	table.insert(TraitData.SpearJumpTrait.PropertyChanges,
	{
		TraitName = godName .. "WeaponTrait",
		WeaponName = "SpearWeaponDash",
		ProjectileProperty = "Graphic",
		ChangeValue = "SpearThrustProjectile-" .. godName,
		ExcludeLinked = true,
	})
end

