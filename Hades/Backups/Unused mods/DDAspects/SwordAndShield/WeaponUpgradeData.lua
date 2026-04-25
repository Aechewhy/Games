table.insert(WeaponUpgradeData.SwordWeapon,
{
	Costs = { 1, 1, 1, 1, 1 },
	MaxUpgradeLevel = 5,
	TraitName = "SwordAndShieldTrait",
	UnequipFunctionName = "RemoveSwordAndShield",
	EquippedKitAnimation = "WeaponSwordFloatingIdleOff",
	UnequippedKitAnimation = "WeaponSwordFloatingIdle",
	BonusUnequippedKitAnimation = "WeaponSwordFloatingIdleBonus",
	BonusEquippedKitAnimation = "WeaponSwordFloatingIdleOffBonus",
	Image = "Codex_Portrait_Sword_DDAspects"
})

function RemoveSwordAndShield( unit )
	SetWeaponProperty({ WeaponName = "SwordWeapon", DestinationId = unit.ObjectId, Property = "AddOnFire", Value = "null" })
	SetWeaponProperty({ WeaponName = "SwordWeapon2", DestinationId = unit.ObjectId, Property = "AddOnFire", Value = "null" })
	SetWeaponProperty({ WeaponName = "SwordWeapon3", DestinationId = unit.ObjectId, Property = "AddOnFire", Value = "null" })
	SetWeaponProperty({ WeaponName = "SwordWeaponDash", DestinationId = unit.ObjectId, Property = "AddOnFire", Value = "null" })
	UnequipWeapon({ DestinationId = unit.ObjectId, Name = "ShieldWeaponRush" })
end
