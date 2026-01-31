table.insert(WeaponUpgradeData.BowWeapon,
{
	Costs = { 1, 1, 1, 1, 1 },
	MaxUpgradeLevel = 5,
	TraitName = "BowAndKickTrait",
	UnequipFunctionName = "RemoveBowAndKick",
	EquippedKitAnimation = "WeaponBowAlt01FloatingIdleOff",
	UnequippedKitAnimation = "WeaponBowAlt01FloatingIdle",
	BonusUnequippedKitAnimation = "WeaponBowAlt01FloatingIdleBonus",
	BonusEquippedKitAnimation = "WeaponBowAlt01FloatingIdleOffBonus",
	Image = "Codex_Portrait_Bow_DDAspects"
})

function RemoveBowAndKick( unit )
	UnequipWeapon({ DestinationId = unit.ObjectId, Name = "FistWeaponSpecial" })
	UnequipWeapon({ DestinationId = unit.ObjectId, Name = "FistWeaponSpecialDash" })
end