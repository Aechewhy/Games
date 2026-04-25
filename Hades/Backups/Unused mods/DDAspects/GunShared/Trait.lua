	TraitData.GunSharedTrait =
	{
		Icon = "WeaponEnchantment_Gun_DDAspects",
		CustomTrayText = "GunSharedTrait_Tray",
		PostWeaponUpgradeScreenAnimation = "ZagreusGunLuciferReload_End",
		PostWeaponUpgradeScreenAngle = 210,
		InheritFrom = { "WeaponEnchantmentTrait" },

		RarityLevels =
		{
			Common    = { Multiplier = 3.0 },
			Rare      = { Multiplier = 3.5 },
			Epic      = { Multiplier = 4.0 },
			Heroic    = { Multiplier = 4.5 },
			Legendary = { Multiplier = 5.0 },
		},
		OnEnemyDamagedFunction =
		{
			Name = "GunSharedOnHit",
			Args = 
			{
				Multiplier = { BaseValue = 0.1 },
				ExtractValues =
				{
					{
						Key = "Multiplier",
						ExtractAs = "TooltipDamageTransfer",
						Format = "Percent",
					},
				}
			}
		},

		WeaponDataOverride =
		{
			GunWeapon =
			{
				DashSwaps = {},
				-- CancelUnitHitFlash = true,
				RapidDamageType = true,
				CancelUnitShake = true,
				CancelArmorUnitShake = true,
				CancelArmorSpark = true,
				DashWeapon = nil,
				IdleReloadAnimation = "ZagreusGunLuciferReload_Start",
				MovingReloadAnimation = "ZagreusGunLuciferRunReload",

				Sounds =
				{
					ImpactSounds =
					{
						Invulnerable = "/SFX/BurnDamage",
						Armored = "/SFX/BurnDamage",
						Bone = "/SFX/BurnDamage",
						Brick = "/SFX/BurnDamage",
						Stone = "/SFX/BurnDamage",
						Organic = "/SFX/BurnDamage",
						StoneObstacle = "/SFX/BurnDamage",
						BrickObstacle = "/SFX/BurnDamage",
						MetalObstacle = "/SFX/BurnDamage",
						BushObstacle = "/Leftovers/World Sounds/LeavesRustle",
					},
				},
			},
			GunGrenadeToss =
			{
				-- OnFiredFunctionName = "GunSharedReload",
				Sounds =
				{
					ChargeSounds =
					{
						{ Name = "/VO/ZagreusEmotes/EmoteCharging_Bow" },
					},
					FireSounds =
					{
						{ Name = "/VO/ZagreusEmotes/EmoteAttacking_Bow" },
						{ Name = "/SFX/Player Sounds/ZagreusGunGrenadeLaunchFire" },
						{ Name = "/SFX/PlayerHammerExplosionsTight" },
					},
					ImpactSounds =
					{
						Invulnerable = "/SFX/Player Sounds/ZagreusShieldRicochet",
						Armored = "/SFX/Player Sounds/ZagreusShieldRicochet",
						Bone = "/SFX/ArrowMetalBoneSmash",
						Brick = "/SFX/ArrowMetalStoneClang",
						Stone = "/SFX/ArrowMetalStoneClang",
						Organic = "/SFX/ArrowImpactSplatter",
						StoneObstacle = "/SFX/ArrowWallHitClankSmall",
						BrickObstacle = "/SFX/ArrowWallHitClankSmall",
						MetalObstacle = "/SFX/ArrowWallHitClankSmall",
						BushObstacle = "/Leftovers/World Sounds/LeavesRustle",
					},
				},
			},
		},

		PropertyChanges =
		{
			--- SPECIAL PROJECTILES ---

			{
				WeaponNames = { "GunGrenadeToss" },
				EffectName = "MarkBondTarget",
				EffectProperty = "Active",
				ChangeValue = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				ProjectileProperty = "DamageLow",
				ChangeValue = 20,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				ProjectileProperty = "DamageHigh",
				ChangeValue = 20,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				EffectName = "OnHitStun",
				EffectProperty = "Duration",
				ChangeValue = 0.5,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				ProjectileProperty = "DamageRadius",
				ChangeValue = 300,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				ProjectileProperty = "ProjectileDefenseRadius",
				ChangeValue = 45,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				ProjectileProperty = "SpawnOnDetonate",
				ChangeValue = "null",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				ProjectileProperty = "DetonateScreenShakeSpeed",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "NumProjectiles",
				ChangeValue = 3,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "ProjectileInterval",
				ChangeValue = 0.03,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "ProjectileAngleOffset",
				ChangeValue = math.rad(20),
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				EffectName = "GrenadeClusterDisable",
				EffectProperty = "Active",
				ChangeValue = true,
				ChangeType = "Absolute",
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "Type",
				ChangeValue = "HOMING",
				ChangeType = "Absolute",
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "MaxAdjustRate",
				ChangeValue = 3,
				ChangeType = "Absolute",
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "AdjustRateAcceleration",
				ChangeValue = 7.5,
				ChangeType = "Absolute",
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "CheckUnitImpact",
				ChangeValue = true,
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "ObstacleCollisionCheck",
				ChangeValue = "PolygonContainsPoint",
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "Speed",
				ChangeValue = 2700,
				ChangeType = "Absolute"
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "Range",
				ChangeValue = 800,
				ChangeType = "Absolute"
			},

			--- SPECIAL CHARGE ---

			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.3,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "MinChargeToFire",
				ChangeValue = 1.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "ReloadTime",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "Cooldown",
				ChangeValue = 0.85,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "LockTriggerForCharge",
				ChangeValue = true,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "SetCompleteAngleOnCharge",
				ChangeValue = false,
				ChangeType = "Absolute",
			},
			{
				WeaponNames = { "GunGrenadeToss"},
				ProjectileProperty = "Scale",
				ChangeValue = 10,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "AimLineAnimation",
				ChangeValue = "AuraAimLineNoMovement",
				ChangeType = "Absolute",
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "TargetReticleAnimation",
				ChangeValue = "null",
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "FireOnRelease",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "FullyAutomatic",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- SPECIAL AUTO LOCK ---
			--- Close range only! Helps hitting 3 bombs on the same target

			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "ManualAiming",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "AutoLock",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "AutoLockArcDistance",
				ChangeValue = math.rad(90),
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "AutoLockRange",
				ChangeValue = 250,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			--- SPECIAL GRAPHICAL CHANGES ---

			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "Graphic",
				ChangeValue = "GunWeaponProjectile",
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "AttachedAnim",
				ChangeValue = "GunProjectileLight",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			{
				WeaponNames = { "GunGrenadeToss" },
				ProjectileProperty = "OffsetZ",
				ChangeValue = 60,
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusGunLucifer_Start",
			},
			{
				WeaponNames = { "GunGrenadeToss" },
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusGunLuciferGrenadeTossFire",
			},
			{
				WeaponName = "GunGrenadeToss",
				WeaponProperty = "FireFx",
				ChangeValue = "GunGrenadeFireFx-Rocket",
			},

			--- BEAM ATTACK ---
			--- From GunLoadedGrenadeTrait

			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "ClearWeaponBonusesOnHit",
				ChangeValue = true,
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "ProjectileDefenseRadius",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "Type",
				ChangeValue = "BEAM",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "ArcSize",
				ChangeValue = 100,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "RefreshProjectileOnFire",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "RushWeapon",
				EffectName = "RushWeaponInvulnerable",
				EffectProperty = "ClearOnAttack",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "SkipFireCancelIfFiring",
				ChangeValue = "true",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "AutoAdjustForTarget",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "AttachToOwner",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "Speed",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "TotalFuse",
				ChangeValue = 0.2,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "Fuse",
				ChangeValue = 0.13,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "Cooldown",
				ChangeValue = 0.13,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "Scatter",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "ScatterCap",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "ImmunityDuration",
				ChangeValue = 0.05,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "MultiDetonate",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "DrawAsBeam",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "BarrelLength",
				ChangeValue = 50,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.3,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusGunLucifer_Start",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "FireGraphic",
				ChangeValue = "ZagreusGunLucifer_Fire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "FireEndGraphic",
				ChangeValue = "ZagreusGunLucifer_ReturnToIdle",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "FailedToFireCooldownAnimation",
				ChangeValue = "ZagreusGunLuciferFireEmpty",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "OnlyChargeOnce",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "FireFx",
				ChangeValue = "null",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "ConsecutiveHitWindow",
				ChangeValue = 0.6,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "DamagePerConsecutiveHit",
				ChangeValue = 0.75,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "MaxAmmo",
				ChangeValue = 20,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "GunWeapon",
				EffectName = "GunDisable",
				EffectProperty = "Active",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				EffectName = "GunDisableCancellable",
				EffectProperty = "Active",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				EffectName = "GunDisableLucifer",
				EffectProperty = "Active",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				EffectName = "GunDisableCancellableLucifer",
				EffectProperty = "Active",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "RushWeapon",
				EffectName = "RushWeaponInvulnerable",
				EffectProperty = "ClearOnAttack",
				ChangeValue = true,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			-- rapid fire trait stabilizers
			
			{
				WeaponName = "ArtemisLegendary",
				WeaponProperty = "Cooldown",
				ChangeValue = 0.25,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "LightningStrikeImpact",
				WeaponProperty = "Cooldown",
				ChangeValue = 0.25,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "ChainLightning",
				WeaponProperty = "Cooldown",
				ChangeValue = 0.25,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},

			-- laser vfx

			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "Graphic",
				ChangeValue = "GunLaser",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "BeamStartAnimSkipsImpact",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "AttachedAnim",
				ChangeValue = "GunLaserOriginFlare",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "TipFx",
				ChangeValue = "GunLaserTipFlare",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				WeaponProperty = "ChargeStartFx",
				ChangeValue = "GunCharge",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "GunWeapon",
				ProjectileProperty = "DissipateGraphic",
				ChangeValue = "GunLaserEnd",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
		},
		ExtractValues =
		{
			{
				ExtractAs = "TooltipBondDuration",
				SkipAutoExtract = true,
				External = true,
				BaseType = "Effect",
				WeaponName = "SwordWeapon",
				BaseName = "MarkBondTarget",
				BaseProperty = "Duration",
			},
		},
	}

local gods = { "Zeus", "Poseidon", "Athena", "Artemis", "Aphrodite", "Ares", "Dionysus", "Demeter" }
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

table.insert(TraitData.AthenaWeaponTrait.PropertyChanges,
{
	TraitName = "GunSharedTrait",
	WeaponName = "GunWeapon",
	ProjectileProperty = "ProjectileDefenseRadius",
	ChangeValue = 40,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
table.insert(TraitData.AthenaSecondaryTrait.PropertyChanges,
{
	TraitName = "GunSharedTrait",
	WeaponName = "GunGrenadeToss",
	ProjectileProperty = "ProjectileDefenseRadius",
	ChangeValue = 55,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
table.insert(TraitData.PoseidonSecondaryTrait.PropertyChanges,
{
	TraitName = "GunSharedTrait",
	WeaponName = "GunGrenadeToss",
	ProjectileProperty = "ImpactVelocity",
	ChangeValue = -700,
	ChangeType = "Add",
	ExcludeLinked = true,
})
table.insert(TraitData.PoseidonSecondaryTrait.PropertyChanges,
{
	TraitName = "GunSharedTrait",
	WeaponName = "GunGrenadeToss",
	ProjectileProperty = "ImpactVelocityCap",
	ChangeValue = -700,
	ChangeType = "Add",
	ExcludeLinked = true,
})

table.insert(TraitData.ArtemisRushTrait.RequiredFalseTraits, "GunSharedTrait")
table.insert(TraitData.ChaosBlessingDashAttackTrait.RequiredFalseTraits, "GunSharedTrait")
