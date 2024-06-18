local var0_0 = class("WorldAtlas", import("...BaseEntity"))

var0_0.Fields = {
	config = "table",
	sairenEntranceList = "table",
	replaceDic = "table",
	achEntranceList = "table",
	costMapDic = "table",
	mapDic = "table",
	transportDic = "table",
	activeEntranceId = "number",
	pressingMapList = "table",
	areaEntranceList = "table",
	portEntranceList = "table",
	activeMapId = "number",
	taskMarkDic = "table",
	pressingUnlcokCount = "number",
	world = "table",
	markPortDic = "table",
	treasureMarkDic = "table",
	id = "number",
	entranceDic = "table",
	nShopGoodsDic = "table",
	mapEntrance = "table"
}
var0_0.EventUpdateProgress = "WorldAtlas.EventUpdateProgress"
var0_0.EventUpdateActiveEntrance = "WorldAtlas.EventUpdateActiveEntrance"
var0_0.EventUpdateActiveMap = "WorldAtlas.EventUpdateActiveMap"
var0_0.EventAddPressingMap = "WorldAtlas.EventAddPressingMap"
var0_0.EventAddPressingEntrance = "WorldAtlas.EventAddPressingEntrance"
var0_0.EventUpdatePortMark = "WorldAtlas.EventUpdatePortMark"
var0_0.EventUpdateNGoodsCount = "WorldAtlas.EventUpdateNGoodsCount"
var0_0.ScaleShrink = 1
var0_0.ScaleFull = 2
var0_0.ScaleExpand = 3
var0_0.ScaleHalf = 4
var0_0.Scales = {
	var0_0.ScaleShrink,
	var0_0.ScaleHalf,
	var0_0.ScaleFull
}

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.id = arg1_1

	assert(pg.world_expedition_data_by_map[arg0_1.id], "world_expedition_data_by_map missing: " .. arg0_1.id)

	arg0_1.config = pg.world_expedition_data_by_map[arg0_1.id]

	arg0_1:BuildEntranceDic()
end

function var0_0.Build(arg0_2)
	arg0_2.entranceDic = {}
	arg0_2.mapDic = {}
	arg0_2.taskMarkDic = {}
	arg0_2.treasureMarkDic = {}
	arg0_2.sairenEntranceList = {}
	arg0_2.costMapDic = {}
	arg0_2.pressingMapList = {}
	arg0_2.transportDic = {}
	arg0_2.markPortDic = {}
end

function var0_0.Dispose(arg0_3)
	WPool:ReturnMap(arg0_3.entranceDic)
	WPool:ReturnMap(arg0_3.mapDic)
	arg0_3:Clear()
end

function var0_0.NewEntrance(arg0_4, arg1_4)
	local var0_4 = WPool:Get(WorldEntrance)

	var0_4:Setup(arg1_4, arg0_4)

	arg0_4.entranceDic[arg1_4] = var0_4

	return var0_4
end

function var0_0.NewMap(arg0_5, arg1_5)
	local var0_5 = WPool:Get(WorldMap)

	var0_5:Setup(arg1_5)

	arg0_5.mapDic[arg1_5] = var0_5

	return var0_5
end

function var0_0.BuildEntranceDic(arg0_6)
	local var0_6 = {
		{
			field = "stage_chapter",
			name = "step"
		},
		{
			field = "task_chapter",
			name = "task"
		},
		{
			field = "teasure_chapter",
			name = "treasure"
		}
	}

	arg0_6.mapEntrance = {}
	arg0_6.areaEntranceList = {}
	arg0_6.portEntranceList = {}
	arg0_6.achEntranceList = {}
	arg0_6.replaceDic = {
		step = {},
		task = {},
		treasure = {},
		open = {
			{},
			{}
		}
	}

	_.each(pg.world_chapter_colormask.all, function(arg0_7)
		local var0_7 = pg.world_chapter_colormask[arg0_7]

		if var0_7.world ~= arg0_6.id then
			return
		end

		local var1_7 = arg0_6:NewEntrance(arg0_7)
		local var2_7 = var1_7:GetAreaId()

		arg0_6.areaEntranceList[var2_7] = arg0_6.areaEntranceList[var2_7] or {}

		table.insert(arg0_6.areaEntranceList[var2_7], arg0_7)

		if var1_7:HasPort() then
			local var3_7 = var1_7:GetPortId()

			arg0_6.portEntranceList[var3_7] = arg0_6.portEntranceList[var3_7] or {}

			table.insert(arg0_6.portEntranceList[var3_7], arg0_7)
		end

		for iter0_7, iter1_7 in ipairs(var0_6) do
			for iter2_7, iter3_7 in ipairs(var1_7.config[iter1_7.field]) do
				if iter1_7.name == "step" then
					for iter4_7 = iter3_7[1], iter3_7[2] do
						arg0_6.replaceDic[iter1_7.name][iter4_7] = arg0_6.replaceDic[iter1_7.name][iter4_7] or {}
						arg0_6.replaceDic[iter1_7.name][iter4_7][arg0_7] = var1_7
					end
				else
					arg0_6.replaceDic[iter1_7.name][iter3_7[1]] = arg0_6.replaceDic[iter1_7.name][iter3_7[1]] or {}
					arg0_6.replaceDic[iter1_7.name][iter3_7[1]][arg0_7] = var1_7
				end
			end
		end

		if #var1_7.config.normal_target > 0 or #var1_7.config.cryptic_target > 0 then
			table.insert(arg0_6.achEntranceList, var1_7)
		end

		local var4_7 = var0_7.chapter
		local var5_7 = arg0_6:NewMap(var4_7)

		arg0_6.mapEntrance[var4_7] = var1_7
		arg0_6.replaceDic.open[1][var5_7.config.open_stage[1]] = arg0_6.replaceDic.open[1][var5_7.config.open_stage[1]] or {}
		arg0_6.replaceDic.open[1][var5_7.config.open_stage[1]][arg0_7] = 1
		arg0_6.replaceDic.open[2][var5_7.config.open_stage[2]] = arg0_6.replaceDic.open[2][var5_7.config.open_stage[2]] or {}
		arg0_6.replaceDic.open[2][var5_7.config.open_stage[2]][arg0_7] = 1
	end)
end

function var0_0.GetEntrance(arg0_8, arg1_8)
	return arg0_8.entranceDic[arg1_8]
end

function var0_0.SetActiveEntrance(arg0_9, arg1_9)
	if arg0_9.activeEntranceId ~= arg1_9.id then
		arg0_9.activeEntranceId = arg1_9.id

		arg0_9:DispatchEvent(var0_0.EventUpdateActiveEntrance, arg1_9)
	end
end

function var0_0.GetActiveEntrance(arg0_10)
	return arg0_10.activeEntranceId and arg0_10:GetEntrance(arg0_10.activeEntranceId)
end

function var0_0.GetMap(arg0_11, arg1_11)
	if not arg0_11.mapDic[arg1_11] then
		arg0_11:NewMap(arg1_11)
	end

	return arg0_11.mapDic[arg1_11]
end

function var0_0.SetActiveMap(arg0_12, arg1_12)
	if arg0_12.activeMapId ~= arg1_12.id then
		arg0_12.activeMapId = arg1_12.id

		arg0_12:DispatchEvent(var0_0.EventUpdateActiveMap, arg1_12)
	end
end

function var0_0.GetActiveMap(arg0_13)
	return arg0_13.activeMapId and arg0_13:GetMap(arg0_13.activeMapId)
end

function var0_0.GetDiscoverRate(arg0_14)
	return 0
end

function var0_0.CheckMapActive(arg0_15, arg1_15)
	local var0_15 = arg0_15:GetMap(arg1_15)

	assert(var0_15, "map not exist: " .. arg1_15)

	return var0_15.active or _.any(_.values(arg0_15:GetPartMaps(arg1_15)), function(arg0_16)
		return arg0_16.active
	end)
end

function var0_0.GetAtlasPixelSize(arg0_17)
	return Vector2(arg0_17.config.size[1], arg0_17.config.size[2])
end

function var0_0.GetAchEntranceList(arg0_18)
	return arg0_18.achEntranceList
end

function var0_0.GetOpenEntranceDic(arg0_19, arg1_19)
	return arg0_19.replaceDic.open[nowWorld():GetRealm()][arg1_19] or {}
end

function var0_0.GetStepDic(arg0_20, arg1_20)
	return arg0_20.replaceDic.step[arg1_20] or {}
end

function var0_0.GetTaskDic(arg0_21, arg1_21)
	return arg0_21.replaceDic.task[arg1_21] or {}
end

function var0_0.GetTreasureDic(arg0_22, arg1_22)
	return arg0_22.replaceDic.treasure[arg1_22] or {}
end

function var0_0.UpdateProgress(arg0_23, arg1_23, arg2_23)
	local var0_23 = {}

	for iter0_23 = arg1_23 + 1, arg2_23 do
		for iter1_23 in pairs(arg0_23:GetOpenEntranceDic(iter0_23)) do
			var0_23[iter1_23] = 1
		end
	end

	arg0_23:DispatchEvent(var0_0.EventUpdateProgress, var0_23)

	local var1_23 = {}

	for iter2_23 in pairs(arg0_23:GetStepDic(arg2_23)) do
		var1_23[iter2_23] = 1
	end

	for iter3_23 in pairs(arg0_23:GetStepDic(arg1_23)) do
		var1_23[iter3_23] = (var1_23[iter3_23] or 0) - 1
	end

	for iter4_23, iter5_23 in pairs(var1_23) do
		if iter5_23 ~= 0 then
			arg0_23.entranceDic[iter4_23]:UpdateDisplayMarks("step", iter5_23 > 0)
		end
	end
end

function var0_0.UpdateTask(arg0_24, arg1_24)
	local var0_24 = arg1_24:isAlive()
	local var1_24 = (var0_24 and 1 or 0) - (arg0_24.taskMarkDic[arg1_24.id] and 1 or 0)

	arg0_24.taskMarkDic[arg1_24.id] = var0_24

	if var1_24 == 0 then
		return
	end

	local var2_24 = false

	for iter0_24 in pairs(arg0_24:GetTaskDic(arg1_24.id)) do
		var2_24 = true

		if arg1_24.config.type == 0 then
			arg0_24.entranceDic[iter0_24]:UpdateDisplayMarks("task_main", var1_24 > 0)
		elseif arg1_24.config.type == 6 then
			arg0_24.entranceDic[iter0_24]:UpdateDisplayMarks("task_collecktion", var1_24 > 0)
		else
			arg0_24.entranceDic[iter0_24]:UpdateDisplayMarks("task", var1_24 > 0)
		end
	end

	local var3_24 = arg1_24:GetFollowingEntrance()

	if var3_24 and not var2_24 then
		if arg1_24.config.type == 0 then
			arg0_24.entranceDic[var3_24]:UpdateDisplayMarks("task_following_main", var1_24 > 0)
		elseif arg1_24.config.type == 7 then
			arg0_24.entranceDic[var3_24]:UpdateDisplayMarks("task_following_boss", var1_24 > 0)
		else
			arg0_24.entranceDic[var3_24]:UpdateDisplayMarks("task_following", var1_24 > 0)
		end
	end
end

function var0_0.UpdateTreasure(arg0_25, arg1_25)
	local var0_25 = nowWorld()
	local var1_25 = var0_25:GetInventoryProxy():GetItemCount(arg1_25)
	local var2_25 = (var1_25 > 0 and 1 or 0) - (arg0_25.treasureMarkDic[arg1_25] and 1 or 0)

	arg0_25.treasureMarkDic[arg1_25] = var1_25 > 0

	if var2_25 ~= 0 then
		local var3_25 = var0_25:FindTreasureEntrance(arg1_25)

		if pg.world_item_data_template[arg1_25].usage_arg[1] == 1 then
			var3_25:UpdateDisplayMarks("treasure_sairen", var2_25 > 0)
		else
			var3_25:UpdateDisplayMarks("treasure", var2_25 > 0)
		end
	end
end

function var0_0.SetPressingMarkList(arg0_26, arg1_26)
	_.each(arg0_26.pressingMapList, function(arg0_27)
		arg0_26:GetMap(arg0_27):UpdatePressingMark(false)
	end)

	local var0_26 = 0

	arg0_26.pressingMapList = arg1_26

	_.each(arg0_26.pressingMapList, function(arg0_28)
		arg0_26:GetMap(arg0_28):UpdatePressingMark(true)

		local var0_28 = arg0_26.mapEntrance[arg0_28]

		if var0_28 and not var0_28:HasPort() then
			var0_26 = var0_26 + 1
		end
	end)

	arg0_26.pressingUnlcokCount = var0_26

	arg0_26:BuildTransportDic()
end

function var0_0.BuildTransportDic(arg0_29)
	arg0_29.transportDic = {}

	for iter0_29, iter1_29 in pairs(arg0_29.entranceDic) do
		if iter1_29:IsPressing() then
			arg0_29.transportDic[iter0_29] = true

			for iter2_29 in pairs(iter1_29.transportDic) do
				arg0_29.transportDic[iter2_29] = true
			end
		end
	end

	if nowWorld():IsReseted() then
		arg0_29:AddPortTransportDic()
	end
end

function var0_0.AddPortTransportDic(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.portEntranceList) do
		for iter2_30, iter3_30 in ipairs(iter1_30) do
			arg0_30.transportDic[iter3_30] = true
		end
	end
end

function var0_0.MarkMapTransport(arg0_31, arg1_31)
	local var0_31 = arg0_31.mapEntrance[arg1_31]

	if var0_31 then
		arg0_31.transportDic[var0_31.id] = true
	end
end

function var0_0.AddPressingMap(arg0_32, arg1_32)
	if _.any(arg0_32.pressingMapList, function(arg0_33)
		return arg0_33 == arg1_32
	end) then
		return
	else
		arg0_32:GetMap(arg1_32):UpdatePressingMark(true)
		table.insert(arg0_32.pressingMapList, arg1_32)

		local var0_32 = arg0_32.mapEntrance[arg1_32]

		if var0_32 then
			local var1_32 = {}

			arg0_32.transportDic[var0_32.id] = true
			var1_32[var0_32.id] = true

			for iter0_32 in pairs(var0_32.transportDic) do
				if not arg0_32.transportDic[iter0_32] then
					arg0_32.transportDic[iter0_32] = true
					var1_32[iter0_32] = true
				end
			end

			arg0_32:DispatchEvent(var0_0.EventAddPressingEntrance, var1_32)

			if not var0_32:HasPort() then
				arg0_32.pressingUnlcokCount = arg0_32.pressingUnlcokCount + 1

				arg0_32:UpdateUnlockCountPortMark()
			end
		end

		arg0_32:DispatchEvent(var0_0.EventAddPressingMap, arg1_32)
	end
end

function var0_0.GetPressingUnlockCount(arg0_34)
	return arg0_34.pressingUnlcokCount
end

function var0_0.GetPressingUnlockRecordCount(arg0_35, arg1_35)
	local var0_35 = getProxy(PlayerProxy):getRawData().id
	local var1_35 = nowWorld().activateCount

	return PlayerPrefs.GetInt(string.format("world_new_shop_unlock_count_in_port_%d_%d_%d", var0_35, var1_35, arg1_35), -1)
end

function var0_0.SetPressingUnlockRecordCount(arg0_36, arg1_36, arg2_36)
	local var0_36 = getProxy(PlayerProxy):getRawData().id
	local var1_36 = nowWorld().activateCount

	return PlayerPrefs.SetInt(string.format("world_new_shop_unlock_count_in_port_%d_%d_%d", var0_36, var1_36, arg1_36), arg2_36)
end

function var0_0.SetSairenEntranceList(arg0_37, arg1_37)
	_.each(arg0_37.sairenEntranceList, function(arg0_38)
		local var0_38 = arg0_37:GetEntrance(arg0_38)

		var0_38:UpdateSairenMark(false)
		var0_38:UpdateDisplayMarks("sairen", false)
	end)

	arg0_37.sairenEntranceList = arg1_37

	_.each(arg0_37.sairenEntranceList, function(arg0_39)
		local var0_39 = arg0_37:GetEntrance(arg0_39)

		var0_39:UpdateSairenMark(true)
		var0_39:UpdateDisplayMarks("sairen", true)
	end)
end

function var0_0.RemoveSairenEntrance(arg0_40, arg1_40)
	local var0_40 = table.indexof(arg0_40.sairenEntranceList, arg1_40.id)

	if var0_40 then
		table.remove(arg0_40.sairenEntranceList, var0_40)
		arg1_40:UpdateSairenMark(false)
		arg1_40:UpdateDisplayMarks("sairen", false)
	end
end

function var0_0.SetCostMapList(arg0_41, arg1_41)
	for iter0_41 in pairs(arg0_41.costMapDic) do
		arg0_41:GetMap(iter0_41).isCost = false
	end

	arg0_41.costMapDic = {}

	_.each(arg1_41, function(arg0_42)
		arg0_41.costMapDic[arg0_42.random_id] = true
		arg0_41:GetMap(arg0_42.random_id).isCost = true
	end)
end

function var0_0.UpdateCostMap(arg0_43, arg1_43, arg2_43)
	if not arg0_43.costMapDic[arg1_43] and arg2_43 then
		nowWorld():ClearAllFleetDefeatEnemies()
	end

	arg0_43.costMapDic[arg1_43] = arg2_43
end

function var0_0.SetPortMarkList(arg0_44, arg1_44, arg2_44)
	arg0_44.markPortDic.goods = {}

	for iter0_44, iter1_44 in ipairs(arg1_44) do
		arg0_44.markPortDic.goods[iter1_44] = true
	end

	arg0_44.markPortDic.new = {}

	for iter2_44, iter3_44 in ipairs(arg2_44) do
		arg0_44.markPortDic.new[iter3_44] = true
	end
end

function var0_0.UpdatePortMark(arg0_45, arg1_45, arg2_45, arg3_45)
	if not arg0_45.portEntranceList[arg1_45] then
		return
	end

	local var0_45

	if arg2_45 ~= nil and tobool(arg0_45.markPortDic.goods[arg1_45]) ~= arg2_45 then
		arg0_45.markPortDic.goods[arg1_45] = arg2_45
		var0_45 = var0_45 or {}

		for iter0_45, iter1_45 in ipairs(arg0_45.portEntranceList[arg1_45]) do
			var0_45[iter1_45] = true
		end
	end

	if arg3_45 ~= nil and tobool(arg0_45.markPortDic.new[arg1_45]) ~= arg3_45 then
		arg0_45.markPortDic.new[arg1_45] = arg3_45
		var0_45 = var0_45 or {}

		for iter2_45, iter3_45 in ipairs(arg0_45.portEntranceList[arg1_45]) do
			var0_45[iter3_45] = true
		end
	end

	if var0_45 and not nowWorld():UsePortNShop() then
		arg0_45:DispatchEvent(var0_0.EventUpdatePortMark, var0_45)
	end
end

function var0_0.InitPortMarkNShopList(arg0_46)
	local var0_46 = arg0_46:GetPressingUnlockCount()

	arg0_46.markPortDic.newGoods = {}

	for iter0_46, iter1_46 in pairs(arg0_46.nShopGoodsDic) do
		local var1_46 = Goods.Create({
			id = iter0_46,
			count = iter1_46
		}, Goods.TYPE_WORLD_NSHOP)
		local var2_46 = var1_46:getConfig("port_id")
		local var3_46 = var1_46:getConfig("unlock_num")
		local var4_46 = arg0_46:GetPressingUnlockRecordCount(var2_46)

		if var1_46:canPurchase() and var4_46 < var3_46 and var3_46 <= var0_46 then
			arg0_46.markPortDic.newGoods[var2_46] = true
		end
	end
end

function var0_0.UpdateUnlockCountPortMark(arg0_47)
	if not nowWorld():UsePortNShop() then
		return
	end

	local var0_47 = arg0_47.markPortDic.newGoods

	arg0_47:InitPortMarkNShopList()

	for iter0_47, iter1_47 in ipairs(underscore.keys(arg0_47.portEntranceList)) do
		if tobool(var0_47[iter1_47]) ~= tobool(arg0_47.markPortDic.newGoods[iter1_47]) then
			local var1_47 = {}

			for iter2_47, iter3_47 in ipairs(arg0_47.portEntranceList[iter1_47]) do
				var1_47[iter3_47] = true
			end
		end
	end

	if changeDic then
		arg0_47:DispatchEvent(var0_0.EventUpdatePortMark, changeDic)
	end
end

function var0_0.UpdatePortMarkNShop(arg0_48, arg1_48, arg2_48)
	if not arg0_48.portEntranceList[arg1_48] then
		return
	end

	if tobool(arg0_48.markPortDic.newGoods[arg1_48]) ~= arg2_48 then
		arg0_48.markPortDic.newGoods[arg1_48] = arg2_48

		if nowWorld():UsePortNShop() then
			local var0_48 = {}

			for iter0_48, iter1_48 in ipairs(arg0_48.portEntranceList[arg1_48]) do
				var0_48[iter1_48] = true
			end

			arg0_48:DispatchEvent(var0_0.EventUpdatePortMark, var0_48)
		end
	end
end

function var0_0.GetAnyPortMarkNShop(arg0_49)
	for iter0_49, iter1_49 in pairs(arg0_49.markPortDic.newGoods) do
		if iter1_49 then
			return true
		end
	end

	return false
end

function var0_0.InitWorldNShopGoods(arg0_50, arg1_50)
	arg0_50.nShopGoodsDic = {}

	for iter0_50, iter1_50 in ipairs(pg.world_newshop_data.all) do
		arg0_50.nShopGoodsDic[iter1_50] = 0
	end

	for iter2_50, iter3_50 in ipairs(arg1_50) do
		assert(arg0_50.nShopGoodsDic[iter3_50.goods_id], "without this good in id " .. iter3_50.goods_id)

		arg0_50.nShopGoodsDic[iter3_50.goods_id] = arg0_50.nShopGoodsDic[iter3_50.goods_id] + iter3_50.count
	end
end

function var0_0.UpdateNShopGoodsCount(arg0_51, arg1_51, arg2_51)
	assert(arg0_51.nShopGoodsDic[arg1_51], "without this goods:" .. arg1_51)

	if arg2_51 ~= 0 then
		arg0_51.nShopGoodsDic[arg1_51] = arg0_51.nShopGoodsDic[arg1_51] + arg2_51

		arg0_51:DispatchEvent(var0_0.EventUpdateNGoodsCount, arg1_51, arg0_51.nShopGoodsDic[arg1_51])
	end
end

function var0_0.GetEntrancePortInfo(arg0_52, arg1_52)
	local var0_52 = arg0_52:GetEntrance(arg1_52)
	local var1_52 = var0_52:GetPortId()

	if nowWorld():UsePortNShop() then
		return arg0_52.transportDic[var0_52.id], arg0_52.markPortDic.newGoods[var1_52], arg0_52.markPortDic.newGoods[var1_52]
	else
		return arg0_52.transportDic[var0_52.id], arg0_52.markPortDic.goods[var1_52], arg0_52.markPortDic.new[var1_52]
	end
end

return var0_0
