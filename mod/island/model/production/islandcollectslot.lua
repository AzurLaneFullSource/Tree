local var0_0 = class("IslandCollectSlot", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.placeId = arg1_1

	arg0_1:UpdateData(arg2_1)
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_production_slot
end

function var0_0.UpdateData(arg0_3, arg1_3)
	arg0_3.configId = arg1_3.id
	arg0_3.formula_id = arg1_3.formula_id
	arg0_3.pos = arg1_3.pos
	arg0_3.get_num = arg1_3.get_num
	arg0_3.refresh_time = arg1_3.refresh_time

	if arg0_3.pos ~= 0 then
		arg0_3.unityPos = pg.island_world_objects[arg0_3.pos].param.position
	end

	local var0_3 = pg.island_set.mining_recovery_time.key_value_varchar

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if iter1_3[1] == arg0_3.configId then
			arg0_3.cd = iter1_3[2]
			arg0_3.maxTimes = iter1_3[3]
		end
	end
end

function var0_0.GetUnitData(arg0_4)
	return {
		arg0_4.pos,
		1004
	}
end

function var0_0.GetUnityWorldPos(arg0_5)
	return arg0_5.unityPos or {
		0,
		0,
		0
	}
end

function var0_0.StartColloct(arg0_6)
	pg.m02:sendNotification(GAME.ISLAND_START_COLLECT, {
		build_id = arg0_6.placeId,
		area_id = arg0_6.configId
	})
end

function var0_0.IsInitUnit(arg0_7)
	return pg.TimeMgr.GetInstance():GetServerTime() > arg0_7.refresh_time + arg0_7.cd
end

function var0_0.GetCanCollectTime(arg0_8)
	return
end

return var0_0
