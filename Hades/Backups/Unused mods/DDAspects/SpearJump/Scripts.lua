--- HAMMER SCRIPTS ---

function SpearJumpSharedOnHit( victim, functionArgs, triggerArgs )
	if not triggerArgs.PureDamage then
		local weapon = triggerArgs.SourceWeapon
		if weapon == "SpearWeaponSpin" or weapon == "SpearWeaponSpin2" or weapon == "SpearWeaponSpin3" then
			SpearJumpDamageShare(triggerArgs.DamageAmount, functionArgs)
			wait( 0.1, RoomThreadName )
			ApplyEffectFromWeapon({ WeaponName = "SpearWeaponSpin", EffectName = "MarkBondTarget", Id = CurrentRun.Hero.ObjectId, DestinationId = victim.ObjectId })
		elseif weapon == "SpearWeapon" or weapon == "SpearWeapon2" or weapon == "SpearWeapon3" or weapon == "SpearWeaponDash" then
			SpearJumpDamageShare(triggerArgs.DamageAmount, functionArgs)
		end
	end
end

function SpearJumpDamageShare( damageAmount, functionArgs )
	if functionArgs.Multiplier ~= nil then
		damageAmount = damageAmount * functionArgs.Multiplier
	end
	if not IsEmpty(ActiveEnemies) then
		local enemyIds = GetAllKeys( ActiveEnemies )
		for index, id in pairs(enemyIds) do
			local enemy = ActiveEnemies[id]
			if enemy and not enemy.IsDead and IsEmpty( enemy.InvulnerableFlags ) and IsEmpty ( enemy.PersistentInvulnerableFlags )
				and enemy.ActiveEffects and enemy.ActiveEffects.MarkBondTarget then
				Damage( enemy, { EffectName = "DamageShare", DamageAmount = damageAmount, Silent = false, PureDamage = true } )
			end
		end
	end
end
