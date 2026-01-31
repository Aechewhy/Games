table.insert(ObjectiveSetData.SwordTutorial.RequiredFalseTraits, "SwordAndShieldTrait")
ObjectiveSetData.SwordTutorial_Athena =
{
	AllowRepeat = true,
	OverrideExistingObjective = false,
	RequiredFalseObjectiveTriggers = { "RoomStart" },
	RequiredMainWeapon = "SwordWeapon",
	RequiredTrait = "SwordAndShieldTrait",
	Objectives =
	{
		{"SwordWeapon", "ShieldWeaponRush", "SwordParry", "SwordWeaponDash"}
	},
}

ObjectiveData.PerfectCatch = { Description = "Objective_PerfectCatch" }
table.insert(ObjectiveSetData.ShieldTutorial.RequiredFalseTraits, "ShieldPerfectCatchTrait")
ObjectiveSetData.ShieldTutorial_Cerberus =
{
	AllowRepeat = true,
	OverrideExistingObjective = false,
	RequiredFalseObjectiveTriggers = { "RoomStart" },
	RequiredMainWeapon = "ShieldWeapon",
	RequiredTrait = "ShieldPerfectCatchTrait",
	Objectives =
	{
		{"ShieldWeapon", "ShieldWeaponRush", "ShieldThrow", "PerfectCatch", "ShieldWeaponDash"}
	},
}

table.insert(ObjectiveSetData.BowTutorial.RequiredFalseTraits, "BowAndKickTrait")
ObjectiveSetData.BowTutorial_Apollo =
{
	AllowRepeat = true,
	OverrideExistingObjective = false,
	RequiredFalseObjectiveTriggers = { "RoomStart" },
	RequiredMainWeapon = "BowWeapon",
	RequiredTrait = "BowAndKickTrait",
	Objectives =
	{
		{"BowWeapon", "PerfectCharge", "BowWeaponDash", "FistWeaponSpecial"}
	},
}

table.insert(ObjectiveSetData.GunTutorial.RequiredFalseTraits, "GunSharedTrait")
ObjectiveSetData.GunTutorial_Helios =
{
	AllowRepeat = true,
	OverrideExistingObjective = false,
	RequiredFalseObjectiveTriggers = { "RoomStart" },
	RequiredMainWeapon = "GunWeapon",
	RequiredTrait = "GunSharedTrait",
	Objectives =
	{
		{"GunWeapon", "GunWeaponManualReload", "GunGrenadeToss"}
	},
}

