local var0_0 = class("NewSystemSubmarineRunResultGradePage", import("..dodgem.NewDodgemResultGradePage"))

function var0_0.GetFlagShip(arg0_1)
	return Ship.New({
		id = 9999,
		configId = 900180,
		skin_id = 900180
	})
end

function var0_0.RegisterEvent(arg0_2, arg1_2)
	seriesAsync({
		function(arg0_3)
			arg0_2:LoadPainitingContainer(arg0_3)
		end,
		function(arg0_4)
			arg0_2:MovePainting(arg0_4)
		end
	}, function()
		onButton(arg0_2, arg0_2._tf, function()
			arg1_2()
		end, SFX_PANEL)
	end)
end

function var0_0.GetGetObjectives(arg0_7)
	return {}
end

return var0_0
