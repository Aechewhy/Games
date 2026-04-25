--[[ List of hammers:
ShieldChargeSpeedTrait (Sudden rush)
ShieldPerfectRushTrait (Minotaur rush)
ShieldChargeHealthBufferTrait (Breaching rush)
ShieldRushProjectileTrait (Charged shot)
ShieldBashDamageTrait (Pulverizing blow)
ShieldDashAOETrait (Dashing wallop)
ShieldBlockEmpowerTrait (Ferocious guard)
ShieldThrowElectiveCharge (Charged flight)
ShieldThrowRushTrait (Dashing flight)
ShieldPerfectCatchAoETrait (NEW - Magnetic flight)
]]

local excludeHammers = { "ShieldThrowEmpowerTrait", "ShieldThrowCatchExplode", "ShieldThrowFastTrait" }
for i, hammer in ipairs(excludeHammers) do
	TraitData[hammer].RequiredFalseTraits = TraitData[hammer].RequiredFalseTraits or {}
	table.insert(TraitData[hammer].RequiredFalseTraits, "ShieldPerfectCatchTrait")
end

-- Changes to dashing flight
TraitData.ShieldThrowRushTrait.PropertyChanges =
{
	{
		TraitName = "ShieldPerfectCatchTrait",
		WeaponName = "ShieldThrowDash",
		ProjectileProperty = "ReturnToOwnerAfterInactiveSeconds",
		ChangeValue = 0.5,
		ChangeType = "Multiply",
		ExcludeLinked = true,
	}
}

-- Changes to charged flight
table.insert(TraitData.ShieldThrowElectiveCharge.PropertyChanges,
{
	TraitName = "ShieldPerfectCatchTrait",
	WeaponName = "ShieldThrow",
	WeaponProperty = "ChargeSpeedMultiplier",
	ChangeValue = 1.5,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})

-- New!
-- Special deals damage in an area and pull foes together
	TraitData.ShieldPerfectCatchAoETrait =
	{
		InheritFrom = { "WeaponTrait" },
		Icon = "Weapon_Shield_07",
		RequiredWeapon = "ShieldWeapon",
		RequiredTrait = "ShieldPerfectCatchTrait",

		PreEquipWeapons = { "FistWeaponLandAreaAttack" },
		AddOnDamageWeapons = { "FistWeaponLandAreaAttack" },
		OnDamageWeaponProperties = { FirstHitOnly = true, FireFromVictimLocation = true },
		LegalOnDamageWeapons = { "ShieldThrow", "ShieldThrowDash" },

		WeaponDataOverride =
		{
			FistWeaponLandAreaAttack =
			{
				FireScreenshake = {},
				FireRumbleParameters = {},
				HitSimSlowParameters = {},
			},
		},

		PropertyChanges =
		{
			--- BLAST PROJECTILE ---

			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "DamageLow",
				ChangeValue = 25,
				ChangeType = "Absolute",
				ExcludeLinked = true,
				ExtractValue =
				{
					ExtractAs = "TooltipDamage",
				},
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "DamageHigh",
				DeriveValueFrom = "DamageLow",
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "AttachToOwner",
				ChangeValue = false,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "DamageRadius",
				ChangeValue = 500,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "VacuumDistance",
				ChangeValue = 550,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "VacuumStrength",
				ChangeValue = 1800,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "BlastSpeed",
				ChangeValue = 0,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "DamageRadiusScaleX",
				ChangeValue = 1.1,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "DamageRadiusScaleY",
				ChangeValue = 0.6,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				ProjectileProperty = "DetonateGraphic",
				ChangeValue = "ShieldThrowTrailMirage",  -- Aspect of Zeus
				ExcludeLinked = true,
			},

			--- REMOVING DISABLES ---

			{
				WeaponName = "FistWeaponLandAreaAttack",
				WeaponProperty = "RootOwnerWhileFiring",
				ChangeValue = false,
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				WeaponProperty = "BlockMoveInput",
				ChangeValue = false,
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				WeaponProperty = "CancelMovement",
				ChangeValue = false,
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				WeaponProperty = "ChargeTime",
				ChangeValue = 0,
				ChangeType = "Absolute",
			},
			{
				WeaponName = "FistWeaponLandAreaAttack",
				EffectName = "LandDisable",
				EffectProperty = "Active",
				ChangeValue = false,
			},

			--- POSEIDON ---

			{
				TraitName = "PoseidonSecondaryTrait",
				WeaponNames = { "ShieldThrow", "ShieldThrowDash" },
				ProjectileProperty = "ImpactVelocity",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				TraitName = "PoseidonSecondaryTrait",
				WeaponNames = { "ShieldThrow", "ShieldThrowDash" },
				ProjectileProperty = "ImpactVelocityCap",
				ChangeValue = 0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				TraitName = "PoseidonSecondaryTrait",
				WeaponNames = { "FistWeaponLandAreaAttack" },
				ProjectileProperty = "VacuumStrength",
				ChangeValue = 3000,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
		},
	}

local gods = { "Zeus", "Athena", "Poseidon", "Artemis", "Aphrodite", "Ares", "Dionysus", "Demeter", "Apollo", "Hestia", "Hera" }
for i, godName in ipairs(gods) do
	table.insert(TraitData.ShieldPerfectCatchAoETrait.PropertyChanges,
	{
		TraitName = godName .. "SecondaryTrait",
		WeaponName = "FistWeaponLandAreaAttack",
		ProjectileProperty = "DetonateGraphic",
		ChangeValue = "ShieldThrowTrailMirage-" .. godName,
		ExcludeLinked = true,
	})
end
