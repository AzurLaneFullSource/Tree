local var0_0 = class("IslandCharIllustration", import(".IslandIllustration"))

function var0_0.GetReachPoints(arg0_1, arg1_1, arg2_1)
	local var0_1 = underscore.reduce(arg0_1:getConfig("collect_upgrade"), 0, function(arg0_2, arg1_2)
		return arg0_2 + (arg1_1 >= arg1_2[1] and arg1_2[2] or 0)
	end)
	local var1_1 = underscore.reduce(arg0_1:getConfig("collect_star"), 0, function(arg0_3, arg1_3)
		return arg0_3 + (arg2_1 >= arg1_3[1] and arg1_3[2] or 0)
	end)

	return arg0_1.basePoint + var0_1 + var1_1
end

function var0_0.CheckTip(arg0_4)
	if arg0_4.status == var0_0.STATUS.CAN_UNLOCK then
		arg0_4.isTip = true

		return
	end

	local var0_4 = arg0_4:GetLinkConfigID()
	local var1_4 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var0_4)

	if not var1_4 then
		arg0_4.isTip = false

		return
	end

	local var2_4 = var1_4:GetLevel()
	local var3_4 = var1_4:GetBreakLevel()

	arg0_4.isTip = arg0_4:GetReachPoints(var2_4, var3_4) > arg0_4:GetPoints()
end

return var0_0
