	TraitData.ShieldPerfectCatchTrait =
	{
		Icon = "WeaponEnchantment_Shield_DDAspects",
		CustomTrayText = "ShieldPerfectCatchTrait_Tray",
		InheritFrom = { "WeaponEnchantmentTrait" },

		RarityLevels =
		{
			Common    = { Multiplier = 1.00 },
			Rare      = { Multiplier = 1.25 },
			Epic      = { Multiplier = 1.50 },
			Heroic    = { Multiplier = 1.75 },
			Legendary = { Multiplier = 2.00 },
		},

		OnProjectileDeathFunction =
		{
			Name = "ShieldPerfectCatchApply",
			Args =
			{
				Modifier = { BaseValue = 1 },
				ExtractValues =
				{
					{
						Key = "Modifier",
						ExtractAs = "TooltipDamage",
						Format = "Percent"
					},
				}
			},
		},

		OnWeaponFiredFunctions =
		{
			ValidWeapons = { "ShieldWeapon", "ShieldWeaponDash" },
			FunctionName = "ShieldPerfectCatchFire",
		},

		WeaponDataOverride =
		{
			-- This is required, even if empty
		},

		PropertyChanges =
		{
			{
				WeaponNames = { "ShieldThrow", "ShieldThrowDash" },
				ProjectileProperty = "DamageLow",
				ChangeValue = 40,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "ShieldThrow", "ShieldThrowDash" },
				ProjectileProperty = "DamageHigh",
				DeriveValueFrom = "DamageLow",
			},
			{
				WeaponNames = { "ShieldThrow", "ShieldThrowDash" },
				ProjectileProperty = "NumJumps",
				ChangeValue = 1,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "ShieldThrow",
				WeaponProperty = "ChargeTime",
				ChangeValue = 0.12,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "ShieldThrow",
				WeaponProperty = "MinChargeToFire",
				ChangeValue = 1.0,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "ShieldThrow",
				WeaponProperty= "ShowFreeAimLine",
				ChangeValue = false,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "ShieldThrow",
				WeaponProperty = "ChargeStartAnimation",
				ChangeValue = "ZagreusShieldHeavyThrow_Fire",
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponName = "ShieldThrow",
				ProjectileProperty = "Speed",
				ChangeValue = 0.7,
				ChangeType = "Multiply",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "ShieldThrow", "ShieldThrowDash" },
				ProjectileProperty = "JumpSpeedMultiplier",
				ChangeValue = 1,
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
			{
				WeaponNames = { "ShieldThrow", "ShieldThrowDash" },
				WeaponProperty = "DisableOwnerForDuration",
				ChangeValue = 0.12,                          -- must be lower than perfect catch window
				ChangeType = "Absolute",
				ExcludeLinked = true,
			},
		},
	}
