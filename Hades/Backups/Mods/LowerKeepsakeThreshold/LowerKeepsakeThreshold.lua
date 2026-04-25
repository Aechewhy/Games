-- Going to combine all mods
if ModUtil ~= nil then
    ModUtil.Mod.Register("LowerKeepsakeThreshold")

	local MyTraitData = ModUtil.Entangled.ModData(TraitData)

	ModUtil.Path.Wrap( "ShowAwardMenu", 
		function(baseFunc)
			for name, keepsake in pairs(GetAvailableKeepsakeTraits()) do
				if MyTraitData[keepsake.Gift] ~= nil and MyTraitData[keepsake.Gift].ChamberThresholds ~= nil then
					if(MyTraitData[keepsake.Gift].ChamberThresholds[2] >= 45) then
						MyTraitData[keepsake.Gift].ChamberThresholds = { 15, 30 }
					end
				end
			end
			baseFunc()
		end
	)
end
