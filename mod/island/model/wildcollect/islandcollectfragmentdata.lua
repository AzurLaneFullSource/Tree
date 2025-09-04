local var0_0 = class("IslandCollectFragmentData", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.pos = arg1_1.pos
	arg0_1.mark = arg1_1.mark
	arg0_1.isSelfIsLand = arg2_1
end

function var0_0.UpdateData(arg0_2, arg1_2)
	local var0_2
	local var1_2
	local var2_2
	local var3_2

	arg0_2.id = arg1_2.id

	if arg1_2.pos ~= arg0_2.pos then
		var0_2 = true
		var2_2 = arg0_2.pos
		var1_2 = true
		var3_2 = arg1_2.pos
	end

	arg0_2.pos = arg1_2.pos
	arg0_2.mark = arg1_2.mark

	return var1_2, var0_2, var3_2, var2_2
end

function var0_0.bindConfigTable(arg0_3)
	return pg.island_collect_fragment
end

function var0_0.IsShow(arg0_4)
	if arg0_4.isSelfIsLand then
		return true
	end

	return arg0_4:getConfigTable().show ~= IslandGatherCollectAgency.ShowTpye.OnlySelf
end

function var0_0.StartCollect(arg0_5, arg1_5, arg2_5)
	pg.m02:sendNotification(GAME.ISLAND_START_WILD_COLLECT, {
		unitId = arg1_5,
		island_id = arg2_5,
		fragment_id = arg0_5.id
	})
end

function var0_0.StartCollectSign(arg0_6, arg1_6, arg2_6)
	pg.m02:sendNotification(GAME.ISLAND_START_WILD_COLLECT_SIGN, {
		unitId = arg1_6,
		island_id = arg2_6,
		gather_id = arg0_6.id
	})
end

function var0_0.CheckCollectCanSign(arg0_7)
	return arg0_7:getConfigTable().show == 3
end

return var0_0
