local var0 = class("NewSystemSubmarineRunResultGradePage", import("..dodgem.NewDodgemResultGradePage"))

function var0.GetFlagShip(arg0)
	return Ship.New({
		id = 9999,
		configId = 900180,
		skin_id = 900180
	})
end

function var0.RegisterEvent(arg0, arg1)
	seriesAsync({
		function(arg0)
			arg0:LoadPainitingContainer(arg0)
		end,
		function(arg0)
			arg0:MovePainting(arg0)
		end
	}, function()
		onButton(arg0, arg0._tf, function()
			arg1()
		end, SFX_PANEL)
	end)
end

function var0.GetGetObjectives(arg0)
	return {}
end

return var0
