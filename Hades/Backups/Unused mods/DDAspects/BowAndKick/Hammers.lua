--[[ List of hammers:
BowSlowChargeDamageTrait (Explosive shot)
BowLongRangeDamageTrait (Sniper shot)
BowTapFireTrait (Flurry shot)
BowTripleShotTrait (Triple shot)
BowChainShotTrait (Chain shot)
BowAndKickKillTrait (Draining cutter)
BowAndKickDefenseTrait (Colossus knucle)
BowAndKickSpecialLandTrait (Quake cutter)
BowAndKickMarkTrait (NEW - Flying kick)
BowAndKickKnockbackTrait (NEW - Repulse kick)
BowAndKickDelayTrait (NEW - Echo shot)
]]

local excludeHammers = { "BowPenetrationTrait", "BowSecondaryBarrageTrait", "BowPowerShotTrait", "BowDoubleShotTrait", "BowCloseAttackTrait", "BowConsecutiveBarrageTrait", "BowSecondaryFocusedFireTrait" }
for i, hammer in ipairs(excludeHammers) do
	TraitData[hammer].RequiredFalseTraits = TraitData[hammer].RequiredFalseTraits or {}
	table.insert(TraitData[hammer].RequiredFalseTraits, "BowAndKickTrait")
end

-- Changes to flurry shot
table.insert(TraitData.BowTapFireTrait.PropertyChanges,
{
	TraitName = "BowAndKickTrait",
	WeaponNames = { "BowWeapon", "BowWeaponDash" },
	WeaponProperty = "ReloadTime",
	ChangeValue = 1.5,
	ChangeType = "Multiply",
	ExcludeLinked = true,
})
table.insert(TraitData.BowTapFireTrait.PropertyChanges,
{
	TraitName = "BowAndKickTrait",
	WeaponNames = { "BowWeapon" },
	WeaponProperty = "ClipSize",
	ChangeValue = 1,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
table.insert(TraitData.BowTapFireTrait.PropertyChanges,
{
	TraitName = "BowAndKickTrait",
	WeaponNames = { "BowWeapon" },
	EffectName = "BowDoubleShotDisable",
	EffectProperty = "Active",
	ChangeValue = true,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})

-- Reimplementation of draining cutter (FistKillTrait)
TraitData.BowAndKickKillTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Fist_06",
	RequiredWeapon = "BowWeapon",
	RequiredTrait = "BowAndKickTrait",
	OnEnemyDeathWeapon =
	{
		Weapon = "FistKillBuff",
		RequiredKillWeapons = { "FistWeaponSpecial" },
	},
	FistKillHeal = 0.02,
	ExtractValues =
	{
		{
			Key = "FistKillHeal",
			ExtractAs = "TooltipHeal",
			Format = "Percent",
		},
	}
}

-- Reimplementation of colossus knucle (FistAttackDefenseTrait)
-- Become sturdy while using special
TraitData.BowAndKickDefenseTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Fist_14",
	RequiredWeapon = "BowWeapon",
	RequiredTrait = "BowAndKickTrait",
	PropertyChanges =
	{
		{
			WeaponNames = { "FistWeaponSpecial" },
			EffectName = "FistHeavyAttackTraitDefense",
			EffectProperty = "Active",
			ChangeValue = true,
			ChangeType = "Absolute",
		},
		{
			WeaponNames = { "FistWeaponSpecial" },
			EffectName = "FistHeavyAttackTraitDefense",
			EffectProperty = "Duration",
			ChangeValue = 0.8,
			ChangeType = "Absolute",
			ExtractValue =
			{
				ExtractAs = "TooltipDuration",
				DecimalPlaces = 2,
			}
		},
		{
			WeaponNames = { "FistWeaponSpecial" },
			EffectName= "FistHeavyAttackTraitDefense",
			EffectProperty = "Modifier",
			BaseMin = 0.7,
			BaseMax = 0.7,
			SourceIsMultiplier = true,
			ChangeType = "Absolute",
			ExtractValue =
			{
				ExtractAs = "TooltipDamageReduction",
				Format = "PercentDelta",
			}
		},
		{
			WeaponNames = { "FistWeaponSpecial" },
			EffectName = "FistHeavyAttackTraitDefense",
			EffectProperty = "FrontFx",
			ChangeValue = "HyperArmorLoop",
			ChangeType = "Absolute",
		},
	},
}

-- Reimplementation of quake cutter (FistSpecialLandTrait)
TraitData.BowAndKickSpecialLandTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Fist_12",
	RequiredWeapon = "BowWeapon",
	RequiredTrait = "BowAndKickTrait",
	RequiredFalseTraits = { "BowAndKickKnockbackTrait" },

	PreEquipWeapons = { "FistWeaponLandAreaAttack" },
	AddOnFireWeapons = { "FistWeaponLandAreaAttack" },
	LegalOnFireWeapons = { "FistWeaponSpecial" },

	PropertyChanges =
	{
		{
			WeaponNames = { "FistWeaponLandAreaAttack" },
			ProjectileProperty = "DamageLow",
			BaseValue = 90,
			ChangeType = "Absolute",
			ExcludeLinked = true,
			ExtractValue =
			{
				ExtractAs = "TooltipDamage",
			},
		},
		{
			WeaponNames = { "FistWeaponLandAreaAttack" },
			ProjectileProperty = "DamageHigh",
			DeriveValueFrom = "DamageLow",
		},
	},
}

local gods = { "Zeus", "Athena", "Poseidon", "Artemis", "Aphrodite", "Ares", "Dionysus", "Demeter", "Apollo", "Hestia", "Hera" }
for i, godName in ipairs(gods) do
	table.insert(TraitData.BowAndKickSpecialLandTrait.PropertyChanges,
	{
		TraitName = godName .. "SecondaryTrait",
		WeaponName = "FistWeaponLandAreaAttack",
		ProjectileProperty = "DetonateGraphic",
		ChangeValue = "FistSpecialLandFx_" .. godName,
		ExcludeLinked = true,
	})
end


-- New!
-- Special creates a blast that knock foes away
TraitData.BowAndKickKnockbackTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Fist_10",
	RequiredWeapon = "BowWeapon",
	RequiredTrait = "BowAndKickTrait",
	RequiredFalseTraits = { "BowAndKickSpecialLandTrait" },

	PreEquipWeapons = { "BowAreaRepulse" },
	AddOnFireWeapons = { "BowAreaRepulse" },
	LegalOnFireWeapons = { "FistWeaponSpecial" },

	PropertyChanges =
	{
		{
			WeaponNames = { "BowAreaRepulse" },
			ProjectileProperty = "DamageLow",
			BaseValue = 0,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponNames = { "BowAreaRepulse" },
			ProjectileProperty = "DamageHigh",
			DeriveValueFrom = "DamageLow",
		},
		{
			WeaponNames = { "BowAreaRepulse" },
			WeaponProperty = "ChargeTime",
			ChangeValue = 0.20,
			ChangeType = "Absolute",
		},
	},
}

-- New!
-- Fires a second shot after 0.5s, each shot deals 70% base damage
TraitData.BowAndKickDelayTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Bow_08",
	RequiredWeapon = "BowWeapon",
	RequiredTrait = "BowAndKickTrait",
	RequiredFalseTraits = { "BowTripleShotTrait" },

	OnWeaponFiredFunctions =
	{
		ValidWeapons = { "BowWeapon", "BowWeaponDash" },
		FunctionName = "BowAndkKickDelayPresentation",
	},

	PropertyChanges =
	{
		{
			WeaponNames = { "BowWeapon", "BowWeaponDash" },
			WeaponProperty = "NumProjectiles",
			ChangeValue = 2,
			ChangeType = "Absolute",
		},
		{
			WeaponNames = { "BowWeapon", "BowWeaponDash" },
			WeaponProperty = "ProjectileInterval",
			ChangeValue = 0.5,
			ChangeType = "Absolute",
		},
		{
			WeaponNames = { "BowWeapon", "BowWeaponDash" },
			WeaponProperty = "ProjectileSpacing",
			ChangeValue = 0,
			ChangeType = "Absolute",
		},
		{
			WeaponNames = { "BowWeapon", "BowWeaponDash" },
			ProjectileProperty = "DamageLow",
			ChangeValue = 7,
			ChangeType = "Absolute",
		},
		{
			WeaponNames = { "BowWeapon", "BowWeaponDash" },
			ProjectileProperty = "DamageHigh",
			ChangeValue = 7,
			ChangeType = "Absolute",
		},

		--- GRAPHICAL CHANGES ---

		{
			WeaponNames = { "BowWeapon", "BowWeaponDash" },
			ProjectileProperty = "AttachedPowershotAnimation",
			ChangeValue = "null",
			ChangeType = "Absolute",
		},
		{
			WeaponNames = { "BowWeapon", "BowWeaponDash" },
			ProjectileProperty = "Graphic",
			ChangeValue = "BowWeaponArrowSplitShot",
			ChangeType = "Absolute",
		},
	},
}

local gods = { "Zeus", "Athena", "Poseidon", "Artemis", "Aphrodite", "Ares", "Dionysus", "Demeter", "Apollo", "Hestia", "Hera" }
for i, godName in ipairs(gods) do
	table.insert(TraitData.BowAndKickDelayTrait.PropertyChanges,
	{
		TraitName = godName .. "WeaponTrait",
		WeaponNames = { "BowWeapon", "BowWeaponDash" },
		ProjectileProperty = "Graphic",
		ChangeValue = "BowWeaponArrow-" .. godName .. "-SplitShot",
		ExcludeLinked = true,
	})
end

table.insert(TraitData.BowTripleShotTrait.RequiredFalseTraits, "BowAndKickDelayTrait")

-- New!
-- Attack marks target, special leaps towards target for +150% damage
TraitData.BowAndKickMarkTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Fist_05",
	RequiredWeapon = "BowWeapon",
	RequiredTrait = "BowAndKickTrait",
	RequiredFalseTraits = { "BowChainShotTrait" },

	PreEquipWeapons = { "FistSpecialMiniDash" },

	WeaponDataOverride =
	{
		BowWeapon =
		{
			OnFiredFunctionName = "BowAndKickShowTarget",
		},
		BowWeaponDash =
		{
			OnFiredFunctionName = "BowAndKickShowTarget",
		},
		FistWeaponSpecial =
		{
			OnFiredFunctionName = "BowAndKickDashToMark",
		},
	},

	OnWeaponChargeFunctions =
	{
		ValidWeapons = { "FistWeaponSpecial" },
		FunctionName = "BowAndKickLockTarget",
	},

	PropertyChanges =
	{
		{
			WeaponNames = { "BowWeapon", "BowWeaponDash" },
			EffectName = "MarkTarget",
			EffectProperty = "Active",
			ChangeValue = true,
		},
		{
			WeaponNames = { "BowWeapon", "BowWeaponDash" },
			EffectName = "MarkTarget",
			EffectProperty = "Duration",
			ChangeValue = 4.0,
			ChangeType = "Absolute",
		},
		{
			WeaponName = "BowSplitShot",
			WeaponProperty = "OverrideFireRequestTarget",
			ChangeValue = -1,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "FistWeaponSpecial",
			WeaponProperty = "LockTriggerForCharge",
			ChangeValue = true,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
	},
}

table.insert(TraitData.BowChainShotTrait.RequiredFalseTraits, "BowAndKickMarkTrait")
