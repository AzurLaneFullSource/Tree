local var0_0 = class("IslandCollectSlot", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:InitCfgData()

	arg0_1.placeId = arg1_1

	arg0_1:UpdateData(arg2_1)
end

function var0_0.InitCfgData(arg0_2)
	arg0_2.cfgMap = {}

	for iter0_2, iter1_2 in ipairs(pg.island_production_mining.all) do
		local var0_2 = pg.island_production_mining[iter1_2]

		if not arg0_2.cfgMap[var0_2.slotId] then
			arg0_2.cfgMap[var0_2.slotId] = var0_2.objId
		end
	end
end

function var0_0.bindConfigTable(arg0_3)
	return pg.island_production_slot
end

function var0_0.UpdateData(arg0_4, arg1_4)
	arg0_4.configId = arg1_4.id
	arg0_4.pos = arg1_4.pos
	arg0_4.get_num = arg1_4.get_num
	arg0_4.refresh_time = arg1_4.refresh_time

	local var0_4 = pg.island_set.mining_recovery_time.key_value_varchar
	local var1_4 = pg.island_set.mission_gather_point.key_value_varchar

	arg0_4.type = 1

	for iter0_4, iter1_4 in ipairs(var1_4) do
		if arg0_4.configId == iter1_4[1] then
			arg0_4.type = 2
			arg0_4.pos = iter1_4[2]
		end
	end

	if arg0_4.type == 1 then
		for iter2_4, iter3_4 in ipairs(var0_4) do
			if iter3_4[1] == arg0_4.configId then
				arg0_4.cd = iter3_4[2]
				arg0_4.maxTimes = iter3_4[3]
			end
		end
	end
end

function var0_0.UpdateCollectData(arg0_5, arg1_5, arg2_5)
	local var0_5 = getProxy(IslandProxy):GetIsland()

	if arg2_5 == 2 then
		var0_5:DispatchEvent(IslandBuildingAgency.SLOT_UNIT_REMOVE, {
			unitId = arg0_5.pos
		})

		return
	end

	if arg0_5.placeId == 401 and arg1_5.pos ~= arg0_5.pos then
		var0_5:DispatchEvent(IslandBuildingAgency.SLOT_UNIT_REMOVE, {
			unitId = arg0_5.pos
		})

		arg0_5.needTimeToLoadModel = true
	end

	arg0_5:UpdateData(arg1_5)
end

function var0_0.StartColloct(arg0_6)
	pg.m02:sendNotification(GAME.ISLAND_START_COLLECT, {
		build_id = arg0_6.placeId,
		area_id = arg0_6.configId
	})
end

function var0_0.GetCanCollectTime(arg0_7)
	if arg0_7.type == 2 then
		return 1
	end

	local var0_7 = math.floor((pg.TimeMgr.GetInstance():GetServerTime() - arg0_7.refresh_time) / arg0_7.cd)

	return math.min(arg0_7.maxTimes, var0_7 - arg0_7.get_num + arg0_7.maxTimes)
end

function var0_0.GetCollectMaxTime(arg0_8)
	if arg0_8.type == 2 then
		return 1
	end

	return arg0_8.maxTimes
end

function var0_0.UpdatePerSecond(arg0_9)
	if not arg0_9.needTimeToLoadModel then
		return
	end

	if arg0_9:GetCanCollectTime() >= 1 then
		local var0_9 = getProxy(IslandProxy):GetIsland()
		local var1_9 = arg0_9.placeId == 401 and arg0_9.pos or arg0_9.cfgMap[arg0_9.configId]
		local var2_9 = pg.island_production_slot[arg0_9.configId].formula[1]
		local var3_9 = pg.island_formula[var2_9].unitid[1][2]

		var0_9:DispatchEvent(IslandBuildingAgency.SlOT_UNIT_INIT, {
			build_id = arg0_9.placeId,
			unitId = var1_9,
			modelId = var3_9,
			unitType = IslandConst.UNIT_TYPE_ITEM_HANDLE_COLLECT,
			fammulaId = var2_9,
			slotId = arg0_9.configId
		})

		arg0_9.needTimeToLoadModel = false
	end
end

function var0_0.SetNeedLoadModel(arg0_10)
	arg0_10.needTimeToLoadModel = true
end

return var0_0
