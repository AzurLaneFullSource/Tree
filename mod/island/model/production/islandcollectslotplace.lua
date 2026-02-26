local var0_0 = class("IslandCollectSlotPlace", import("model.vo.BaseVO"))

var0_0.slotType = {
	Normal = 1,
	Task = 2
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.placeId = arg1_1

	local var0_1 = pg.TimeMgr.GetInstance():GetServerTime()

	arg0_1.get_num = arg2_1.get_num
	arg0_1.refresh_time = arg2_1.refresh_time

	if var0_1 > arg0_1.refresh_time then
		arg0_1.get_num = 0
	end

	if arg0_1.get_num > 0 then
		arg0_1.needRefresh = true
	end

	arg0_1.recoverQueue = {}
	arg0_1.collectionSlotData = {}

	local var1_1 = pg.island_set.mission_gather_point.key_value_varchar

	arg0_1.taskPointDic = {}

	for iter0_1, iter1_1 in ipairs(var1_1) do
		arg0_1.taskPointDic[iter1_1[1]] = true
	end

	for iter2_1, iter3_1 in ipairs(arg2_1.collect_list or {}) do
		local var2_1 = arg0_1.taskPointDic[iter3_1] and var0_0.slotType.Task or var0_0.slotType.Normal

		if var2_1 == var0_0.slotType.Normal then
			table.insert(arg0_1.recoverQueue, iter3_1)
		end

		arg0_1.collectionSlotData[iter3_1] = IslandCollectSlotNew.New(arg0_1, iter3_1, var2_1)
	end
end

function var0_0.GetCollectSlotDatasDic(arg0_2)
	return arg0_2.collectionSlotData
end

function var0_0.GetRecoverQueue(arg0_3)
	return arg0_3.recoverQueue
end

function var0_0.GetCanCollectTime(arg0_4)
	return math.min(#arg0_4.recoverQueue, #arg0_4.recoverQueue - arg0_4.get_num)
end

function var0_0.GetInRecoverTimeBySlotId(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.recoverQueue) do
		if iter1_5 == arg1_5 then
			return iter0_5
		end
	end
end

function var0_0.GetNextRecoverTimes(arg0_6)
	return arg0_6.refresh_time
end

function var0_0.UpdateCollectRefreshtTime(arg0_7, arg1_7)
	if arg1_7 ~= arg0_7.refresh_time then
		arg0_7.refresh_time = arg1_7
		arg0_7.needRefresh = true
	end
end

function var0_0.UpdateGetCollectNum(arg0_8, arg1_8)
	if arg1_8 == var0_0.slotType.Normal then
		arg0_8.get_num = arg0_8.get_num + 1
	end
end

function var0_0.SetAllTakeColelct(arg0_9)
	arg0_9.get_num = #arg0_9.recoverQueue
end

function var0_0.UpdateCollectDataBySlotId(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg1_10.id
	local var1_10 = arg0_10.collectionSlotData[var0_10]

	if not var1_10 then
		return
	end

	if arg2_10 == var0_0.slotType.Task then
		var1_10:UpdateCollectData(arg1_10, arg2_10)

		arg0_10.collectionSlotData[var0_10] = nil
	else
		arg0_10:RefreshRecoverQueue(var0_10)
		var1_10:UpdateCollectData(arg1_10, arg2_10)
	end
end

function var0_0.RefreshRecoverQueue(arg0_11, arg1_11)
	local var0_11 = -1

	for iter0_11, iter1_11 in ipairs(arg0_11.recoverQueue) do
		if iter1_11 == arg1_11 then
			var0_11 = iter0_11
		end
	end

	if var0_11 ~= -1 then
		table.remove(arg0_11.recoverQueue, var0_11)
	end

	table.insert(arg0_11.recoverQueue, arg1_11)
end

function var0_0.GetCollectSlotData(arg0_12, arg1_12)
	return arg0_12.collectionSlotData[arg1_12]
end

function var0_0.InitHandSlotData(arg0_13, arg1_13)
	local var0_13 = arg1_13.id

	if arg0_13.collectionSlotData[var0_13] then
		warning("已经存在当前槽位的信息了")

		return
	end

	local var1_13 = arg0_13.taskPointDic[var0_13] and var0_0.slotType.Task or var0_0.slotType.Normal

	if var1_13 == var0_0.slotType.Normal then
		table.insert(arg0_13.recoverQueue, 1, var0_13)
	end

	local var2_13 = IslandCollectSlotNew.New(arg0_13.configId, arg1_13, var1_13)

	arg0_13.collectionSlotData[arg1_13.id] = var2_13

	getProxy(IslandProxy):GetIsland():DispatchEvent(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, {
		slotId = arg1_13.id
	})
end

function var0_0.UpdatePerSecond(arg0_14)
	local var0_14 = pg.TimeMgr.GetInstance():GetServerTime()

	if arg0_14.needRefresh and var0_14 >= arg0_14.refresh_time then
		arg0_14.needRefresh = false

		local var1_14 = #arg0_14.recoverQueue - arg0_14.get_num + 1

		arg0_14.get_num = 0

		local var2_14 = getProxy(IslandProxy):GetIsland()
		local var3_14 = math.max(1, var1_14)

		for iter0_14 = #arg0_14.recoverQueue, var3_14, -1 do
			local var4_14 = arg0_14.recoverQueue[iter0_14]

			if arg0_14.placeId == IslandProductConst.MinePlaceId then
				var2_14:DispatchEvent(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, {
					slotId = var4_14
				})
			else
				var2_14:DispatchEvent(IslandBuildingAgency.COLLECT_SlOT_UNIT_UPDATE, {
					slotId = var4_14
				})
			end
		end
	end
end

return var0_0
