--[[ List of hammers:
GunArmorPenerationTrait (Piercing Fire)
GunLoadedGrenadeLaserTrait (Concentrated Beam)
GunLoadedGrenadeSpeedTrait (Flash Fire)
GunLoadedGrenadeWideTrait (Triple Beam)
GunLoadedGrenadeInfiniteAmmoTrait (Eternal Chamber)
GunSharedClusterBombTrait (Cluster Bomb)
GunSharedSingleBombTrait (NEW - Seeking Bomb)
GunSharedDeathTrait (NEW - Shared Fate)
]]

local excludeHammers = { "GunMinigunTrait", "GunShotgunTrait", "GunExplodingSecondaryTrait", "GunHeavyBulletTrait", "GunHomingBulletTrait", "GunInfiniteAmmoTrait", "GunGrenadeDropTrait", "GunGrenadeFastTrait", "GunChainShotTrait", "GunGrenadeClusterTrait", "GunSlowGrenade" }
for i, hammer in ipairs(excludeHammers) do
	TraitData[hammer].RequiredFalseTraits = TraitData[hammer].RequiredFalseTraits or {}
	table.insert(TraitData[hammer].RequiredFalseTraits, "GunSharedTrait")
end

-- Can equip most of GunLoadedGrenadeTrait's unique hammers (aka aspect of Lucifer)
local includeHammers = { "GunLoadedGrenadeLaserTrait", "GunLoadedGrenadeSpeedTrait", "GunLoadedGrenadeWideTrait", "GunLoadedGrenadeInfiniteAmmoTrait" }
for i, hammer in ipairs(includeHammers) do
	TraitData[hammer]["RequiredTrait"] = nil
	TraitData[hammer]["RequiredOneOfTraits"] = { "GunLoadedGrenadeTrait", "GunSharedTrait" }

	-- For some reason... every single PropertyChanges is tagged with TraitName = "GunLoadedGrenadeTrait"
	-- This is not needed, since the hammers themselves are already tagged with RequiredTrait = "GunLoadedGrenadeTrait"
	local table = TraitData[hammer]["PropertyChanges"]
	for j, property in ipairs(table) do
		property.TraitName = nil
	end
end

-- Reimplementation of cluster bomb (GunGrenadeClusterTrait)
TraitData.GunSharedClusterBombTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Gun_17",
	RequiredWeapon = "GunWeapon",
	RequiredTrait = "GunSharedTrait",
	PropertyChanges =
	{
		{
			WeaponName = "GunGrenadeToss",
			WeaponProperty = "NumProjectiles",
			ChangeValue = 5,
			ChangeType = "Absolute",
			ExtractValue =
			{
				ExtractAs = "TooltipProjectiles",
			},
			ExcludeLinked = true,
		},
		{
			WeaponName = "GunGrenadeToss",
			WeaponProperty = "ProjectileAngleOffset",
			ChangeValue = math.rad(18),
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
	},
}

-- New!
-- Special projectiles seek foes and deal more damage
TraitData.GunSharedSingleBombTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Gun_10",
	RequiredWeapon = "GunWeapon",
	RequiredTrait = "GunSharedTrait",
	AddOutgoingDamageModifiers =
	{
		ValidWeaponMultiplier = 1.5,
		ValidWeapons = { "GunGrenadeToss" },
		ExcludeLinked = true,
		ExtractValues =
		{
			{
				Key = "ValidWeaponMultiplier",
				ExtractAs = "TooltipDamageIncrease",
				Format = "PercentDelta",
			},
		}
	},
	PropertyChanges =
	{
		{
			WeaponName = "GunGrenadeToss",
			ProjectileProperty = "MaxAdjustRate",
			ChangeValue = 15,
			ChangeType = "Absolute",
		},
		{
			WeaponName = "GunGrenadeToss",
			ProjectileProperty = "AdjustRateAcceleration",
			ChangeValue = 50,
			ChangeType = "Absolute",
		},
		{
			WeaponName = "GunGrenadeToss",
			WeaponProperty = "AutoLockRange",
			ChangeValue = 800,
			ChangeType = "Absolute",
			ExcludeLinked = true,
		},
		{
			WeaponName = "GunGrenadeToss",
			WeaponProperty = "ShowFreeAimLine",
			ChangeValue = false,
			ExcludeLinked = true,
		},
	},
}

-- New!
-- When an enemy is killed, cause 100 shared damage
TraitData.GunSharedDeathTrait =
{
	InheritFrom = { "WeaponTrait" },
	Icon = "Weapon_Sword_12",
	RequiredWeapon = "GunWeapon",
	RequiredTrait = "GunSharedTrait",
	OnEnemyDeathFunction = "GunSharedDeathDamage",
}
