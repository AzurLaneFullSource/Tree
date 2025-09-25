local var0_0 = class("IslandCollectSlotNew", import("model.vo.BaseVO"))

var0_0.slotType = {
	Normal = 1,
	Task = 2
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.id = arg2_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.pos = arg2_1.pos
	arg0_1.placeData = arg1_1
	arg0_1.slotType = arg3_1
end

function var0_0.UpdateData(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
	arg0_2.pos = arg1_2.pos
end

function var0_0.GetCanCollectTimeStamps(arg0_3)
	if arg0_3.slotType == var0_0.slotType.Task then
		return 0
	end

	local var0_3 = arg0_3.placeData:GetCanCollectTime()
	local var1_3 = arg0_3.placeData:GetInRecoverTimeBySlotId(arg0_3.id)

	if var1_3 <= var0_3 then
		return 0
	end

	return arg0_3.placeData:GetNextRecoverTimes(var1_3 - var0_3)
end

function var0_0.UpdateCollectData(arg0_4, arg1_4, arg2_4)
	local var0_4 = getProxy(IslandProxy):GetIsland()

	if arg2_4 == var0_0.slotType.Task then
		var0_4:DispatchEvent(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, {
			slotId = arg0_4.configId
		})

		return
	end

	local var1_4

	if arg1_4.pos ~= arg0_4.pos then
		var0_4:DispatchEvent(IslandBuildingAgency.COLLECT_SLOT_UNIT_REMOVE, {
			slotId = arg0_4.configId
		})

		var1_4 = true
	end

	arg0_4:UpdateData(arg1_4)

	if var1_4 then
		var0_4:DispatchEvent(IslandBuildingAgency.COLLECT_SlOT_UNIT_INIT, {
			slotId = arg0_4.configId
		})
	end
end

function var0_0.StartColloct(arg0_5)
	pg.m02:sendNotification(GAME.ISLAND_START_COLLECT, {
		build_id = arg0_5.placeData.placeId,
		area_id = arg0_5.configId,
		type = arg0_5.slotType
	})
end

return var0_0
