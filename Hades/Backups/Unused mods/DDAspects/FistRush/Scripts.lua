function FistRushSetUpGlobals( unit, args )

	ScreenAnchors.FullscreenAlertFxAnchor = CreateScreenObstacle({ Name = "BlankObstacle", Group = "Events", X = ScreenCenterX, Y = ScreenCenterY })
	local attackSpeedFx = SpawnObstacle({ Name = "FullscreenAlertColorDark", Group = "FX_Standing_Top", DestinationId = ScreenAnchors.FullscreenAlertFxAnchor})
	DrawScreenRelative({ Id = attackSpeedFx })
	SetAlpha({ Id = attackSpeedFx, Fraction = 0, Duration = 0 })

	local incomingDamageId = nil
	for index, modifier in pairs(CurrentRun.Hero.IncomingDamageModifiers) do
		if modifier.Name == "FistRushTrait" then
			incomingDamageId = index
		end
	end

	_G.FistRushData =
	{
		AttackLastHit = 0,
		AttackSpeed = 0,
		AttackSpeedFx = attackSpeedFx,
		IncomingDamageId = incomingDamageId,
		SpecialCharging = false,
		SpecialCharge = 0,
		SpecialIgnoreRush = false,
	}
end

function FistRushUpdateSpeed( data )
	local lerpTime = data.LerpTime or 0
	local multiplier = data.Multiplier or 1
	local speedFraction = _G.FistRushData.AttackSpeed

	local speed = (1 + 0.4*speedFraction) * multiplier
	AddSimSpeedChange( "FistRushSpeed", { Fraction = speed, LerpTime = lerpTime, Priority = true } )
	SetAlpha({ Id = _G.FistRushData.AttackSpeedFx, Fraction = speedFraction, Duration = lerpTime })

	local incomingDamage = CurrentRun.Hero.IncomingDamageModifiers[_G.FistRushData.IncomingDamageId]
	local maxDefense = 1 - incomingDamage.MaxSpeedMultiplier
	incomingDamage.GlobalMultiplier = 1 - (maxDefense * speedFraction)
end

function FistRushRequestSpeedDecay( hitId )
	local decay = 0.01
	while hitId == _G.FistRushData.AttackLastHit do
		if _G.FistRushData.AttackSpeed > decay then
			_G.FistRushData.AttackSpeed = _G.FistRushData.AttackSpeed - decay
		else
			_G.FistRushData.AttackSpeed = 0
			_G.FistRushData.AttackLastHit = 0
		end
		FistRushUpdateSpeed({ LerpTime = 0.2 })
		decay = decay + 0.01
		wait(0.2, RoomThreadName)
	end
end

function FistRushAttack( victim, functionArgs, triggerArgs )
	if triggerArgs.SourceProjectile == "FistWeapon" or triggerArgs.SourceProjectile == "FistWeaponDash" then
		local hitId = _G.FistRushData.AttackLastHit + 1
		_G.FistRushData.AttackLastHit = hitId

		local speed = _G.FistRushData.AttackSpeed + 0.07
		if speed > 1 then
			speed = 1
		end
		_G.FistRushData.AttackSpeed = speed
		FistRushUpdateSpeed({ LerpTime = 0.16 })

		wait(0.3, RoomThreadName)
		FistRushRequestSpeedDecay( hitId )
	end
end

OnWeaponCharging{ "FistWeaponSpecial",
	function( triggerArgs )
		if HeroHasTrait("FistRushTrait") then
			local chargeOverride = FistRushAltCharge()
			if chargeOverride then
				return
			end

			_G.FistRushData.AttackLastHit = 0
			_G.FistRushData.AttackSpeed = 0
			_G.FistRushData.SpecialCharging = true
			_G.FistRushData.SpecialCharge = 0
			_G.FistRushData.SpecialIgnoreRush = false
			FistRushUpdateSpeed({ Multiplier = 0.2, LerpTime = 0.08 })

			local chargeTime = 0.12
			local charge = 0.02 / chargeTime
			while _G.FistRushData.SpecialCharging and ( _G.FistRushData.SpecialCharge < 1 ) do
				wait(0.02, RoomThreadName)
				_G.FistRushData.SpecialCharge = _G.FistRushData.SpecialCharge + charge
			end

			wait(0.3, RoomThreadName)

			if _G.FistRushData.SpecialCharging then
				FistRushUpdateSpeed({ LerpTime = 2 })
				DoCameraMotion({ ZoomType = "Ease", Fraction = 1.0, Duration = 1.5 })
				ShakeScreen({ Distance = 4, Speed = 600, FalloffSpeed = 12000, Duration = 0.08, Angle = 225 })
				--Flash({ Id = CurrentRun.Hero.ObjectId, Speed = 2.5, MinFraction = 0.7, MaxFraction = 0.0, Color = Color.White, Duration = 0.10 })
			end
		end
	end
}

OnWeaponFired{ "FistWeaponSpecial",
	function( triggerArgs )
		if HeroHasTrait("FistRushTrait") and _G.FistRushData.SpecialCharging then
			local charge = _G.FistRushData.SpecialCharge
			if charge < 0.25 then
				charge = 0.25
			end
			_G.FistRushData.SpecialCharging = false
			_G.FistRushData.SpecialCharge = 0
			local hitId = _G.FistRushData.AttackLastHit + 1
			_G.FistRushData.AttackLastHit = hitId             -- stop decay

			if not _G.FistRushData.SpecialIgnoreRush then
				local angle = math.rad( GetAngle({ Id = CurrentRun.Hero.ObjectId }) )
				-- local range = 200 + (charge * 600)
				local range = 200 + (charge * 600)
				local offset = CalcOffset( angle, range )
				local tempObstacle = SpawnObstacle({ Name = "BlankObstacle", DestinationId = CurrentRun.Hero.ObjectId, OffsetX = offset.X, OffsetY = offset.Y })

				SetPlayerInvulnerable( "FistRushSpecial" )
				FireWeaponFromUnit({ Weapon = "FistSpecialMiniDash", Id = CurrentRun.Hero.ObjectId, DestinationId = tempObstacle })

				local rushSpeed = 1 - 0.25*charge
				FistRushUpdateSpeed({ Multiplier = rushSpeed, LerpTime = 0 })
				wait(0.26, RoomThreadName)
				SetPlayerVulnerable( "FistRushSpecial" )
				Destroy({ Ids = { tempObstacle } })
			end

			FistRushUpdateSpeed({ LerpTime = 0.08 })
			FistRushRequestSpeedDecay( hitId )
		end
	end
}

OnWeaponFired{ "FistWeaponSpecialDash",
	function( triggerArgs )
		if HeroHasTrait("FistRushTrait") then
			if not HeroHasTrait("FistRushChargeTrait") then
				_G.FistRushData.AttackLastHit = 0
				_G.FistRushData.AttackSpeed = 0
				FistRushUpdateSpeed({ LerpTime = 0.08 })
			end
		end
	end
}

OnWeaponFired{ "RushWeapon",
	function( triggerArgs )
		if HeroHasTrait("FistRushTrait") then
			_G.FistRushData.SpecialIgnoreRush = true
		end
	end
}

--- HAMMER SCRIPTS ---

function FistRushAltCharge()
	if HeroHasTrait("FistRushChargeTrait") then
		_G.FistRushData.SpecialCharging = true
		_G.FistRushData.SpecialCharge = 0
		_G.FistRushData.SpecialIgnoreRush = false

		local chargeTime = 0.6
		local charge = 0.1 / chargeTime
		while _G.FistRushData.SpecialCharging and ( _G.FistRushData.SpecialCharge < 1 ) do
			wait(0.1, RoomThreadName)
			_G.FistRushData.SpecialCharge = _G.FistRushData.SpecialCharge + charge
		end

		return true
	end
	if HeroHasTrait("FistRushFireballTrait") then
		-- Bug fix
		SetWeaponProperty({ WeaponName = "FistWeaponSpecial", DestinationId = CurrentRun.Hero.ObjectId, Property = "PerfectChargeWindowDuration", Value = "null" })

		_G.FistRushData.AttackLastHit = 0
		_G.FistRushData.AttackSpeed = 0
		_G.FistRushData.SpecialCharging = true
		_G.FistRushData.SpecialCharge = 0
		_G.FistRushData.SpecialIgnoreRush = true

		FistRushUpdateSpeed({ Multiplier = 0.2, LerpTime = 0 })
		SetVolume({ Id = MusicId, Value = 0.4 })
		wait(0.05, RoomThreadName)

		PlaySound({ Name = "/VO/ZagreusEmotes/EmoteMartialSpearAttack", Id = CurrentRun.Hero.ObjectId, Delay = 0 })
		Flash({ Id = CurrentRun.Hero.ObjectId, Speed = 0.85, MinFraction = 0.7, MaxFraction = 0.0, Color = Color.White, Duration = 0.02 })
		wait(0.08, RoomThreadName)

		if _G.FistRushData.SpecialCharging then
			PlaySound({ Name = "/VO/ZagreusEmotes/EmotePowerAttacking_Sword", Id = CurrentRun.Hero.ObjectId, Delay = 0 })
			Flash({ Id = CurrentRun.Hero.ObjectId, Speed = 0.85, MinFraction = 0.7, MaxFraction = 0.0, Color = Color.White, Duration = 0.02 })
			SetWeaponProperty({ WeaponName = "FistWeaponSpecial", DestinationId = CurrentRun.Hero.ObjectId, Property = "PerfectChargeWindowDuration", Value = 0.15 })
			wait(0.07, RoomThreadName)

			if _G.FistRushData.SpecialCharging then
				FistRushUpdateSpeed({ LerpTime = 0 })
				DoCameraMotion({ ZoomType = "Ease", Fraction = 1.0, Duration = 1.0 })
			end
		end

		SetVolume({ Id = MusicId, Value = 1.0 })

		return true
	end
	return false
end

--- VOICE LINES ---

-- Reaction voice lines if the player is hit while in slow motion
OnHit{
	function( triggerArgs )
		local victim = triggerArgs.TriggeredByTable
		local attacker = triggerArgs.AttackerTable
		local sourceWeaponData = GetWeaponData( attacker, triggerArgs.SourceWeapon )

		if victim == CurrentRun.Hero
		and HeroHasTrait("FistRushTrait") and not HeroHasTrait("FistRushChargeTrait")
		and _G.FistRushData.SpecialCharging
		and triggerArgs.DamageAmount ~= nil and triggerArgs.DamageAmount > 0
		and not triggerArgs.PureDamage
		and not triggerArgs.Silent
		and not triggerArgs.IsInvulnerable
		and not triggerArgs.InvulnerableFromCoverage
		and not (victim.InvulnerableFlags ~= nil and not IsEmpty( victim.InvulnerableFlags ))
		and not (victim.PersistentInvulnerableFlags ~= nil and not IsEmpty( victim.PersistentInvulnerableFlags ))
		and sourceWeaponData ~= nil and not sourceWeaponData.RapidDamageType
		then
			thread( PlayVoiceLines, FistRushVoiceLines.ReactionFast )
		end
	end
}

FistRushVoiceLines =
{
	ReactionFast =
	{
		BreakIfPlayed = true,
		RandomRemaining = true,
		PreLineWait = 0,
		CooldownTime = 5,
		CooldownName = "SlowTimeReaction",

		-- Wha-?
		{ Cue = "/VO/ZagreusField_2462" },
		-- No, wait...!
		{ Cue = "/VO/ZagreusField_0080" },
		-- Wha, how?
		{ Cue = "/VO/ZagreusField_0078" },
		-- Ugh what?!
		{ Cue = "/VO/ZagreusField_1122" },

		-- Almost...!
		--{ Cue = "/VO/ZagreusField_0553" },
		-- Huh--?
		--{ Cue = "/VO/ZagreusField_4009" },
		-- Wha--?
		--{ Cue = "/VO/ZagreusField_0069" },
		-- Wha?!
		--{ Cue = "/VO/ZagreusField_0070" },
		-- Damn it...!
		--{ Cue = "/VO/ZagreusField_0400" },
	},
}

