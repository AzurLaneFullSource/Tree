local var0_0 = class("IslandWildGatherData", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.pos = arg1_1.pos
	arg0_1.state = arg1_1.state
	arg0_1.mark = arg1_1.mark
	arg0_1.isSelfIsLand = arg2_1
end

function var0_0.UpdateData(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id

	local var0_2
	local var1_2
	local var2_2
	local var3_2

	if arg1_2.pos ~= arg0_2.pos then
		var0_2 = true
		var1_2 = arg0_2.pos
		var2_2 = true
		var3_2 = arg1_2.pos
	end

	arg0_2.pos = arg1_2.pos

	if arg1_2.state ~= arg0_2.state then
		if arg1_2.state == 0 then
			var2_2 = true
			var3_2 = arg0_2.pos
		else
			var0_2 = true
			var1_2 = arg0_2.pos
		end
	end

	arg0_2.state = arg1_2.state
	arg0_2.mark = arg1_2.mark

	return var2_2, var0_2, var3_2, var1_2
end

function var0_0.bindConfigTable(arg0_3)
	return pg.island_wild_gather
end

function var0_0.CheckCofigShow(arg0_4)
	if arg0_4.isSelfIsLand then
		return true
	end

	return arg0_4:getConfigTable().show ~= IslandGatherCollectAgency.ShowTpye.OnlySelf
end

function var0_0.IsShow(arg0_5)
	return arg0_5:CheckCofigShow() and arg0_5.state == 0
end

function var0_0.StartGaher(arg0_6, arg1_6, arg2_6)
	pg.m02:sendNotification(GAME.ISLAND_START_WILD_GATHER, {
		unitId = arg1_6,
		island_id = arg2_6,
		gather_id = arg0_6.id
	})
end

function var0_0.StartGaherSign(arg0_7, arg1_7, arg2_7)
	pg.m02:sendNotification(GAME.ISLAND_START_WILD_GATHER_SIGN, {
		unitId = arg1_7,
		island_id = arg2_7,
		gather_id = arg0_7.id
	})
end

function var0_0.CheckGatherCanSign(arg0_8)
	return arg0_8:getConfigTable().show == 3
end

return var0_0
