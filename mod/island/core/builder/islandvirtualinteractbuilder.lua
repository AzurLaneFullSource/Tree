local var0_0 = class("IslandVirtualInteractBuilder", import(".IslandItemInteractBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandVirtualInteractUnit.New(arg1_1, arg2_1)
end

function var0_0.Load(arg0_2, arg1_2, arg2_2)
	local var0_2 = {}
	local var1_2

	table.insert(var0_2, function(arg0_3)
		var1_2 = GameObject.New("VirtualInteractUnit" .. arg1_2.id)

		arg0_3()
	end)
	table.insert(var0_2, function(arg0_4)
		arg0_2:SetupBT(var1_2, arg1_2, arg0_4)
	end)
	seriesAsync(var0_2, function()
		arg2_2(var1_2)
	end)
end

return var0_0
