local var0_0 = class("IslandCollectSlot", import("model.vo.BaseVO"))

var0_0.slotType = {
	Normal = 1,
	Task = 2
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.placeId = arg1_1

	arg0_1:UpdateData(arg2_1)
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_production_slot
end

function var0_0.UpdateData(arg0_3, arg1_3)
	arg0_3.configId = arg1_3.id
	arg0_3.pos = arg1_3.pos
	arg0_3.get_num = arg1_3.get_num
	arg0_3.refresh_time = arg1_3.refresh_time

	local var0_3 = pg.island_set.mining_recovery_time.key_value_varchar
	local var1_3 = pg.island_set.mission_gather_point.key_value_varchar

	arg0_3.type = var0_0.slotType.Normal

	for iter0_3, iter1_3 in ipairs(var1_3) do
		if arg0_3.configId == iter1_3[1] then
			arg0_3.type = var0_0.slotType.Task
			arg0_3.pos = iter1_3[2]
		end
	end

	if arg0_3.type == var0_0.slotType.Normal then
		for iter2_3, iter3_3 in ipairs(var0_3) do
			if iter3_3[1] == arg0_3.configId then
				arg0_3.cd = iter3_3[2]
				arg0_3.maxTimes = iter3_3[3]
			end
		end
	end
end

function var0_0.UpdateCollectData(arg0_4, arg1_4, arg2_4)
	local var0_4 = getProxy(IslandProxy):GetIsland()

	if arg2_4 == var0_0.slotType.Task then
		var0_4:DispatchEvent(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, {
			unitId = arg0_4.pos
		})

		return
	end

	local var1_4

	if arg1_4.pos ~= arg0_4.pos then
		var0_4:DispatchEvent(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, {
			unitId = arg0_4.pos
		})

		var1_4 = true
	end

	arg0_4:UpdateData(arg1_4)

	if var1_4 then
		arg0_4:NotifyToLoadCollectSlotModel()
	end
end

function var0_0.StartColloct(arg0_5)
	pg.m02:sendNotification(GAME.ISLAND_START_COLLECT, {
		build_id = arg0_5.placeId,
		area_id = arg0_5.configId
	})
end

function var0_0.GetRecoverCD(arg0_6)
	return arg0_6.cd
end

function var0_0.GetRecoverTime(arg0_7)
	return (math.floor(math.max(pg.TimeMgr.GetInstance():GetServerTime() - arg0_7.refresh_time, 0) / arg0_7:GetRecoverCD()))
end

function var0_0.GetNextRecoverTimes(arg0_8)
	return arg0_8.refresh_time + (arg0_8:GetRecoverTime() + 1) * arg0_8:GetRecoverCD()
end

function var0_0.GetCanCollectTime(arg0_9)
	if arg0_9.type == var0_0.slotType.Task then
		return 1
	end

	local var0_9 = arg0_9:GetRecoverTime()

	return math.min(arg0_9.maxTimes, var0_9 - arg0_9.get_num + arg0_9.maxTimes)
end

function var0_0.GetCollectMaxTime(arg0_10)
	if arg0_10.type == var0_0.slotType.Task then
		return 1
	end

	return arg0_10.maxTimes
end

function var0_0.NotifyToLoadCollectSlotModel(arg0_11)
	getProxy(IslandProxy):GetIsland():DispatchEvent(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, {
		slotId = arg0_11.configId
	})
end

return var0_0
