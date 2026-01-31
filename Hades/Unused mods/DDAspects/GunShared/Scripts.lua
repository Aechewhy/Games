function GunSharedOnHit( victim, functionArgs, triggerArgs )
	if triggerArgs.SourceProjectile == "GunWeapon" then
		local damageAmount = triggerArgs.DamageAmount
		if functionArgs.Multiplier ~= nil then
			damageAmount = damageAmount * functionArgs.Multiplier
		end
		if not IsEmpty(ActiveEnemies) then
			local enemyIds = GetAllKeys( ActiveEnemies )
			for index, id in pairs(enemyIds) do
				local enemy = ActiveEnemies[id]
				if enemy and not enemy.IsDead and IsEmpty( enemy.InvulnerableFlags ) and IsEmpty ( enemy.PersistentInvulnerableFlags )
					and enemy.ActiveEffects and enemy.ActiveEffects.MarkBondTarget then
					Damage( enemy, { EffectName = "DamageShareAlt", DamageAmount = damageAmount, Silent = false, PureDamage = true, AttackerTable = CurrentRun.Hero } )
				end
			end
		end
	end

	if triggerArgs.SourceProjectile == "ShieldWeapon" or triggerArgs.SourceProjectile == "ShieldWeaponDash" or triggerArgs.SourceProjectile == "ShieldWeaponRush" then
		local damageAmount = triggerArgs.DamageAmount
		if functionArgs.Multiplier ~= nil then
			damageAmount = damageAmount * functionArgs.Multiplier
		end
		if not IsEmpty(ActiveEnemies) then
			local enemyIds = GetAllKeys( ActiveEnemies )
			for index, id in pairs(enemyIds) do
				local enemy = ActiveEnemies[id]
				if enemy and not enemy.IsDead and IsEmpty( enemy.InvulnerableFlags ) and IsEmpty ( enemy.PersistentInvulnerableFlags )
					and enemy.ActiveEffects and enemy.ActiveEffects.MarkBondTarget then
					Damage( enemy, { EffectName = "DamageShare", DamageAmount = damageAmount, Silent = false, PureDamage = true, AttackerTable = CurrentRun.Hero } )
				end
			end
		end
	end

end

function GunSharedReload( attacker_, weaponData_, args_ )
	local weaponData = GetWeaponData( CurrentRun.Hero, "GunWeapon" )
	local attacker = CurrentRun.Hero
	if attacker.HandlingDeath or attacker.Reloading or attacker.SurgeActive then
		return false
	end

	attacker.Reloading = true
	local prevCooldownAnim = GetWeaponDataValue({ Id = attacker.ObjectId, WeaponName = "GunWeapon", Property = "FailedToFireCooldownAnimation" })
	if prevCooldownAnim ~= nil then
		SetWeaponProperty({ WeaponName = "GunWeapon", DestinationId = attacker.ObjectId, Property = "FailedToFireCooldownAnimation", Value = "null" })
	end
	SetWeaponProperty({ WeaponName = "GunWeapon", DestinationId = attacker.ObjectId, Property = "Enabled", Value = false })

	--RunWeaponMethod({ Id = attacker.ObjectId, Weapon = weaponData.Name, Method = "EmptyAmmo" })
	thread( UpdateGunUI )
	local state = {}

	--- ReloadPresentationStart ---
	if IsMoving({ Id = attacker.ObjectId }) then
		SetAnimation({ DestinationId = attacker.ObjectId, Name = weaponData.MovingReloadAnimation })
	else
		SetAnimation({ DestinationId = attacker.ObjectId, Name = weaponData.IdleReloadAnimation })
		FireWeaponFromUnit({ Weapon = "GunReloadSelf", AutoEquip = true, Id = attacker.ObjectId, DestinationId = attacker.ObjectId })
	end
	local startX = GetLocalizedValue(GunUI.StartX, {
		{ Code = "ja", Value = 650 },
	})
	state.GunReloadDisplayId = CreateScreenObstacle({ Name = "GunReloadIndicator", Group = "Combat_UI", X = startX + GunUI.ReloadingOffsetX, Y = GunUI.StartY + GunUI.ReloadingOffsetY })

	wait( weaponData.ActiveReloadTime, RoomThreadName)
	if attacker.HandlingDeath then
		return false
	end

	--- ReloadPresentationComplete ---
	Flash({ Id = CurrentRun.Hero.ObjectId, Speed = 6, MinFraction = 0, MaxFraction = 1, Color = Color.White, Duration = 0.15, ExpireAfterCycle = false })
	StopSound({ Id = state.ReloadSoundId, Duration = 0.2 })
	PlaySound({ Name = "/SFX/Player Sounds/ZagreusSwordSwipe", Id = state.GunReloadDisplayId })
	CreateAnimation({ Name="GunReloadIndicatorComplete", DestinationId = state.GunReloadDisplayId, GroupName="Combat_UI" })
	Destroy({ Id = state.GunReloadDisplayId })

	if prevCooldownAnim ~= nil then
		SetWeaponProperty({ WeaponName = "GunWeapon", DestinationId = attacker.ObjectId, Property = "FailedToFireCooldownAnimation", Value = prevCooldownAnim })
	end
	RunWeaponMethod({ Id = attacker.ObjectId, Weapon = weaponData.Name, Method = "RefillAmmo" })
	SetWeaponProperty({ WeaponName = "GunWeapon", DestinationId = attacker.ObjectId, Property = "Enabled", Value = true })
	thread( UpdateGunUI )
	attacker.Reloading = false
	return true
end

--- HAMMER SCRIPTS ---

function GunSharedDeathDamage()
	local damageAmount = 120
	wait(0.2, RoomThreadName)
	if not IsEmpty(ActiveEnemies) then
		local enemyIds = GetAllKeys( ActiveEnemies )
		for index, id in pairs(enemyIds) do
			local enemy = ActiveEnemies[id]
			if enemy and not enemy.IsDead and IsEmpty( enemy.InvulnerableFlags ) and IsEmpty ( enemy.PersistentInvulnerableFlags )
				and enemy.ActiveEffects and enemy.ActiveEffects.MarkBondTarget then
				Damage( enemy, { EffectName = "DamageShare", DamageAmount = damageAmount, Silent = false, PureDamage = true, AttackerTable = CurrentRun.Hero } )
				PlaySound({ Name = "/SFX/Player Sounds/AresDelayedDamageStab", Id = id })
			end
		end
	end
end
