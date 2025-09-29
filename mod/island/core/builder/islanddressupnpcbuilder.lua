local var0_0 = class("IslandDressupNpcBuilder", import(".IslandNpcBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandDressupNpcUnit.New(arg1_1, arg2_1)
end

function var0_0.LoadOtherPart(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	local var0_2 = arg3_2.shipId

	if not var0_2 or var0_2 == 0 then
		arg4_2()

		return
	end

	seriesAsync({
		function(arg0_3)
			local var0_3 = arg0_2.view:GetIsland()
			local var1_3 = IslandShipDressHelperNew.New(var0_3)

			arg2_2:SetShipDressHelper(var1_3)
			var1_3:PreLoadShipDressupItem(arg1_2, var0_2, arg0_3)
		end
	}, function()
		existCall(arg4_2)
	end)
end

return var0_0
