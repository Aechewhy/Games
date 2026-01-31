function ShieldPerfectCatchApply( triggerArgs, traitDataArgs )
	if triggerArgs.name == "ShieldThrow" or triggerArgs.name == "ShieldThrowDash" then
		local instances = 1
		local multiplier = traitDataArgs.Modifier
		local duration = 0.15

		-- Force swap to dash-attack if catch while dashing
		if HasEffect({Id = CurrentRun.Hero.ObjectId, EffectName = "RushWeaponInvulnerable" }) then
			SetWeaponProperty({ WeaponName = "ShieldWeaponDash", DestinationId = CurrentRun.Hero.ObjectId, Property = "ControlWindow", Value = duration })
			SwapWeapon({ Name = "ShieldWeapon", SwapWeaponName = "ShieldWeaponDash", DestinationId = CurrentRun.Hero.ObjectId, RequireCurrentControl = true })
			RunWeaponMethod({ Id = CurrentRun.Hero.ObjectId, Weapon = "ShieldWeaponDash", Method = "SetAdditiveDamageBonus", Parameters = { instances, multiplier } })
		end

		RunWeaponMethod({ Id = CurrentRun.Hero.ObjectId, Weapon = "ShieldWeapon", Method = "SetAdditiveDamageBonus", Parameters = { instances, multiplier } })
		_G.ShieldPerfectCatchWindow = true
		Flash({ Id = CurrentRun.Hero.ObjectId, Speed = 0.85, MinFraction = 0.7, MaxFraction = 0.0, Color = Color.White, Duration = 0.2 })
		wait( duration, RoomThreadName )

		-- Remove effects
		RunWeaponMethod({ Id = CurrentRun.Hero.ObjectId, Weapon = "ShieldWeapon", Method = "SetAdditiveDamageBonus", Parameters = { 0, multiplier } })
		RunWeaponMethod({ Id = CurrentRun.Hero.ObjectId, Weapon = "ShieldWeaponDash", Method = "SetAdditiveDamageBonus", Parameters = { 0, multiplier } })
		SetWeaponProperty({ WeaponName = "ShieldWeaponDash", DestinationId = CurrentRun.Hero.ObjectId, Property = "ControlWindow", Value = 0.45 })
		_G.ShieldPerfectCatchWindow = false
	end
end

function ShieldPerfectCatchFire( weaponData, args )
	if _G.ShieldPerfectCatchWindow then
		CreateAnimation({ Name = "PerfectShotShroud", UseScreenLocation = true, OffsetX = ScreenCenterX, OffsetY = ScreenCenterY, GroupName = "Combat_UI_World_Add" })
		CreateAnimation({ Name = "PerfectShotShroud_Dark", UseScreenLocation = true, OffsetX = ScreenCenterX, OffsetY = ScreenCenterY, GroupName = "Combat_UI_World" })
		PlaySound({ Name = "/SFX/Player Sounds/ZagreusCriticalFire", Id = CurrentRun.Hero.ObjectId })
		thread( MarkObjectiveComplete, "PerfectCatch" )
		_G.ShieldPerfectCatchWindow = false
	end
end
