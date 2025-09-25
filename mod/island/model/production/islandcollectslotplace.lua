local var0_0 = class("IslandCollectSlotPlace", import("model.vo.BaseVO"))

var0_0.slotType = {
	Normal = 1,
	Task = 2
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.placeId = arg1_1
	arg0_1.get_num = arg2_1.get_num
	arg0_1.refresh_time = arg2_1.refresh_time
	arg0_1.recoverQueue = {}
	arg0_1.collectionSlotData = {}

	local var0_1 = pg.island_set.mission_gather_point.key_value_varchar

	arg0_1.taskPointDic = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		arg0_1.taskPointDic[iter1_1[1]] = true
	end

	for iter2_1, iter3_1 in ipairs(arg2_1.collect_list or {}) do
		local var1_1 = arg0_1.taskPointDic[iter3_1.id] and 2 or 1

		if var1_1 == var0_0.slotType.Normal then
			table.insert(arg0_1.recoverQueue, iter3_1.id)
		end

		arg0_1.collectionSlotData[iter3_1.id] = IslandCollectSlotNew.New(arg0_1, iter3_1, var1_1)
	end

	local var2_1 = pg.island_set.collection_point_recovery_time.key_value_varchar

	for iter4_1, iter5_1 in ipairs(var2_1) do
		if iter5_1[1] == arg0_1.placeId then
			arg0_1.cd = iter5_1[2]
		end
	end
end

function var0_0.GetCollectSlotDatasDic(arg0_2)
	return arg0_2.collectionSlotData
end

function var0_0.GetRecoverQueue(arg0_3)
	return arg0_3.recoverQueue
end

function var0_0.GetRecoverTime(arg0_4)
	return (math.floor(math.max(pg.TimeMgr.GetInstance():GetServerTime() - arg0_4.refresh_time, 0) / arg0_4:GetRecoverCD()))
end

function var0_0.GetCanCollectTime(arg0_5)
	local var0_5 = arg0_5:GetRecoverTime()

	return math.min(#arg0_5.recoverQueue, var0_5 - arg0_5.get_num + #arg0_5.recoverQueue)
end

function var0_0.GetInRecoverTimeBySlotId(arg0_6, arg1_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.recoverQueue) do
		if iter1_6 == arg1_6 then
			return iter0_6
		end
	end
end

function var0_0.GetNextRecoverTimes(arg0_7, arg1_7)
	return arg0_7.refresh_time + (arg0_7:GetRecoverTime() + arg1_7) * arg0_7:GetRecoverCD()
end

function var0_0.GetRecoverCD(arg0_8)
	return arg0_8.cd
end

function var0_0.UpdateCollectRefreshtTime(arg0_9, arg1_9, arg2_9)
	if arg1_9 ~= arg0_9.refresh_time then
		arg0_9.get_num = 1
	elseif arg2_9 == var0_0.slotType.Normal then
		arg0_9.get_num = arg0_9.get_num + 1
	end

	arg0_9.refresh_time = arg1_9
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

return var0_0
