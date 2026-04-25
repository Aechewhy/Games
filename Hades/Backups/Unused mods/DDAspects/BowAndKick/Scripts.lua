--- HAMMER SCRIPTS ---

function BowAndkKickDelayPresentation( weaponData, args )
	wait(0.5, RoomThreadName)
	PlaySound({ Name = "/SFX/Player Sounds/ZagreusBowFire", Id = CurrentRun.Hero.ObjectId })
end

function BowAndKickShowTarget( weaponData, args )
	local targetId = GetWeaponProperty({ Id = CurrentRun.Hero.ObjectId, WeaponName = "BowSplitShot", Property = "OverrideFireRequestTarget"})
	wait(0.3, RoomThreadName)
	local newTarget = GetWeaponProperty({ Id = CurrentRun.Hero.ObjectId, WeaponName = "BowSplitShot", Property = "OverrideFireRequestTarget"})
	if newTarget ~= targetId and ActiveEnemies[newTarget] ~= nil and not ActiveEnemies[newTarget].IsDead then
		CreateAnimation({ Name = "ItemGet_PomUpgraded", DestinationId = newTarget, Scale = 2.0 })
		--PlaySound({ Name = "/SFX/Player Sounds/DarknessRewardDrop", Id = CurrentRun.Hero.ObjectId })
		PlaySound({ Name = "/SFX/Player Sounds/AphroditeLoveDashHeart", Id = CurrentRun.Hero.ObjectId })
	end
end

function BowAndKickLockTarget( weaponData, args )
	local multiplier = 2
	local instances = 1
	local targetId = GetWeaponProperty({ Id = CurrentRun.Hero.ObjectId, WeaponName = "BowSplitShot", Property = "OverrideFireRequestTarget"})
	if targetId ~= -1 and ActiveEnemies[targetId] ~= nil and not ActiveEnemies[targetId].IsDead then
		--StopAnimation({ Name = "ErisPowerUpFx", DestinationId = CurrentRun.Hero.ObjectId })
		RunWeaponMethod({ Id = CurrentRun.Hero.ObjectId, Weapon = "FistWeaponSpecial", Method = "SetAdditiveDamageBonus", Parameters = { instances, multiplier } })
		wait(0.1, RoomThreadName)
		AngleTowardTarget({ Id = CurrentRun.Hero.ObjectId, DestinationId = targetId, CompleteAngle = true })
	end
end

function BowAndKickDashToMark( weaponData, args )
	local targetId = GetWeaponProperty({ Id = CurrentRun.Hero.ObjectId, WeaponName = "BowSplitShot", Property = "OverrideFireRequestTarget"})
	if targetId ~= -1 and ActiveEnemies[targetId] ~= nil and not ActiveEnemies[targetId].IsDead then
		FireWeaponFromUnit({ Weapon = "FistSpecialMiniDash", Id = CurrentRun.Hero.ObjectId, DestinationId = targetId })
		ClearEffect({ Id = targetId, Name = "MarkTarget" })
	end
end
