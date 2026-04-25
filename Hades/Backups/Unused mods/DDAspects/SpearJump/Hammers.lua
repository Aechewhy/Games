--[[ List of hammers:
SpearReachAttack (Extending jab)
SpearAutoAttack (Flurry jab)
SpearAttackPhalanxTrait (Triple jab)
SpearThrowPenetrate (Breaching skewer)
SpearThrowElectiveCharge (Charged skewer)
SpearThrowBounce (Chain skewer)
SpearSpinDamageRadius (Massive spin)
SpearSpinChargeLevelTime (Quick spin)
SpearSpinChargeAreaDamageTrait (Flaring spin)
SpearJumpSharedTrait (NEW - Celestial spin)
]]

local excludeHammers = { "SpearThrowExplode", "SpearThrowCritical", "SpearDashMultiStrike" }
for i, hammer in ipairs(excludeHammers) do
	TraitData[hammer].RequiredFalseTraits = TraitData[hammer].RequiredFalseTraits or {}
	table.insert(TraitData[hammer].RequiredFalseTraits, "SpearJumpTrait")
end

-- New!
-- Spin attack inflicts shared damage
-- 60% of damage dealt by attack, dash-attack or spin attack is shared
TraitData.SpearJumpSharedTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Spear_14",
	RequiredWeapon = "SpearWeapon",
	RequiredTrait = "SpearJumpTrait",
	RequiredFalseTraits = { "SpearAutoAttack" },
	PreEquipWeapons = {"RushRuptureWeapon", "FistDetonationWeapon", "MarkRuptureApplicator"},
	OnEnemyDamagedFunction =
	{
		Name = "SpearJumpSharedOnHit",
		Args = 
		{
			Multiplier = 0.6,
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
}

table.insert(TraitData.SpearAutoAttack.RequiredFalseTraits, "SpearJumpSharedTrait")

-- Changes to flurry jab
local properties = TraitData.SpearAutoAttack.PropertyChanges
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeapon", "SpearWeapon2", "SpearWeapon3", "SpearWeaponDash" },
	WeaponProperty = "ChargeTime",
	ChangeValue = 1.7,
	ChangeType = "Multiply",
	ExcludeLinked = true,
})
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeapon", "SpearWeapon2", "SpearWeapon3", "SpearWeaponDash" },
	ProjectileProperty = "ImpactVelocity",
	ChangeValue = 800,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeapon", "SpearWeapon2", "SpearWeapon3", "SpearWeaponDash" },
	ProjectileProperty = "ImpactVelocityCap",
	ChangeValue = 800,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeapon", "SpearWeapon2", "SpearWeapon3", "SpearWeaponDash" },
	WeaponProperty = "AutoLockArcDistance",
	ChangeValue = 180,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})

-- Changes to chain skewer
local properties = TraitData.SpearThrowBounce.PropertyChanges
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponName = "SpearWeaponThrow",
	WeaponProperty = "RemoveControlOnFire",
	ChangeValue = "SpearWeaponThrow",
	ExcludeLinked = true,
})
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponName = "SpearWeaponThrow",
	ProjectileProperty = "AddControlOnDeath",
	ChangeValue = "SpearWeaponThrow",
	ExcludeLinked = true,
})
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponName = "SpearWeaponThrow",
	ProjectileProperty = "CheckUnitImpact",
	ChangeValue = true,
	ExcludeLinked = true,
})

-- Changes to extending jab (now affects dash-attack)
table.insert(TraitData.SpearReachAttack.PropertyChanges,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeaponDash" },
	ProjectileProperty = "Range",
	ChangeValue = 1.3,
	ChangeType = "Multiply",
	ExcludeLinked = true,
})

-- Changes to triple jab (now affects dash-attack)
local properties = TraitData.SpearAttackPhalanxTrait.PropertyChanges
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeaponDash" },
	WeaponProperty = "NumProjectiles",
	ChangeValue = 3,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeaponDash" },
	ProjectileProperty = "ImmunityDuration",
	ChangeValue = 0.05,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeaponDash" },
	WeaponProperty = "ProjectileSpacing",
	ChangeValue = 135,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeaponDash" },
	WeaponProperty = "ProjectileAngleOffset",
	ChangeValue = 0.10,
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
table.insert(properties,
{
	TraitName = "SpearJumpTrait",
	WeaponNames = { "SpearWeaponDash" },
	WeaponProperty = "ProjectileOffsetStart",
	ChangeValue = "CENTER",
	ChangeType = "Absolute",
	ExcludeLinked = true,
})
