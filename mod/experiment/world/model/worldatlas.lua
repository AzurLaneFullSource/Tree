local var0 = class("WorldAtlas", import("...BaseEntity"))

var0.Fields = {
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
var0.EventUpdateProgress = "WorldAtlas.EventUpdateProgress"
var0.EventUpdateActiveEntrance = "WorldAtlas.EventUpdateActiveEntrance"
var0.EventUpdateActiveMap = "WorldAtlas.EventUpdateActiveMap"
var0.EventAddPressingMap = "WorldAtlas.EventAddPressingMap"
var0.EventAddPressingEntrance = "WorldAtlas.EventAddPressingEntrance"
var0.EventUpdatePortMark = "WorldAtlas.EventUpdatePortMark"
var0.EventUpdateNGoodsCount = "WorldAtlas.EventUpdateNGoodsCount"
var0.ScaleShrink = 1
var0.ScaleFull = 2
var0.ScaleExpand = 3
var0.ScaleHalf = 4
var0.Scales = {
	var0.ScaleShrink,
	var0.ScaleHalf,
	var0.ScaleFull
}

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0)

	arg0.id = arg1

	assert(pg.world_expedition_data_by_map[arg0.id], "world_expedition_data_by_map missing: " .. arg0.id)

	arg0.config = pg.world_expedition_data_by_map[arg0.id]

	arg0:BuildEntranceDic()
end

function var0.Build(arg0)
	arg0.entranceDic = {}
	arg0.mapDic = {}
	arg0.taskMarkDic = {}
	arg0.treasureMarkDic = {}
	arg0.sairenEntranceList = {}
	arg0.costMapDic = {}
	arg0.pressingMapList = {}
	arg0.transportDic = {}
	arg0.markPortDic = {}
end

function var0.Dispose(arg0)
	WPool:ReturnMap(arg0.entranceDic)
	WPool:ReturnMap(arg0.mapDic)
	arg0:Clear()
end

function var0.NewEntrance(arg0, arg1)
	local var0 = WPool:Get(WorldEntrance)

	var0:Setup(arg1, arg0)

	arg0.entranceDic[arg1] = var0

	return var0
end

function var0.NewMap(arg0, arg1)
	local var0 = WPool:Get(WorldMap)

	var0:Setup(arg1)

	arg0.mapDic[arg1] = var0

	return var0
end

function var0.BuildEntranceDic(arg0)
	local var0 = {
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

	arg0.mapEntrance = {}
	arg0.areaEntranceList = {}
	arg0.portEntranceList = {}
	arg0.achEntranceList = {}
	arg0.replaceDic = {
		step = {},
		task = {},
		treasure = {},
		open = {
			{},
			{}
		}
	}

	_.each(pg.world_chapter_colormask.all, function(arg0)
		local var0 = pg.world_chapter_colormask[arg0]

		if var0.world ~= arg0.id then
			return
		end

		local var1 = arg0:NewEntrance(arg0)
		local var2 = var1:GetAreaId()

		arg0.areaEntranceList[var2] = arg0.areaEntranceList[var2] or {}

		table.insert(arg0.areaEntranceList[var2], arg0)

		if var1:HasPort() then
			local var3 = var1:GetPortId()

			arg0.portEntranceList[var3] = arg0.portEntranceList[var3] or {}

			table.insert(arg0.portEntranceList[var3], arg0)
		end

		for iter0, iter1 in ipairs(var0) do
			for iter2, iter3 in ipairs(var1.config[iter1.field]) do
				if iter1.name == "step" then
					for iter4 = iter3[1], iter3[2] do
						arg0.replaceDic[iter1.name][iter4] = arg0.replaceDic[iter1.name][iter4] or {}
						arg0.replaceDic[iter1.name][iter4][arg0] = var1
					end
				else
					arg0.replaceDic[iter1.name][iter3[1]] = arg0.replaceDic[iter1.name][iter3[1]] or {}
					arg0.replaceDic[iter1.name][iter3[1]][arg0] = var1
				end
			end
		end

		if #var1.config.normal_target > 0 or #var1.config.cryptic_target > 0 then
			table.insert(arg0.achEntranceList, var1)
		end

		local var4 = var0.chapter
		local var5 = arg0:NewMap(var4)

		arg0.mapEntrance[var4] = var1
		arg0.replaceDic.open[1][var5.config.open_stage[1]] = arg0.replaceDic.open[1][var5.config.open_stage[1]] or {}
		arg0.replaceDic.open[1][var5.config.open_stage[1]][arg0] = 1
		arg0.replaceDic.open[2][var5.config.open_stage[2]] = arg0.replaceDic.open[2][var5.config.open_stage[2]] or {}
		arg0.replaceDic.open[2][var5.config.open_stage[2]][arg0] = 1
	end)
end

function var0.GetEntrance(arg0, arg1)
	return arg0.entranceDic[arg1]
end

function var0.SetActiveEntrance(arg0, arg1)
	if arg0.activeEntranceId ~= arg1.id then
		arg0.activeEntranceId = arg1.id

		arg0:DispatchEvent(var0.EventUpdateActiveEntrance, arg1)
	end
end

function var0.GetActiveEntrance(arg0)
	return arg0.activeEntranceId and arg0:GetEntrance(arg0.activeEntranceId)
end

function var0.GetMap(arg0, arg1)
	if not arg0.mapDic[arg1] then
		arg0:NewMap(arg1)
	end

	return arg0.mapDic[arg1]
end

function var0.SetActiveMap(arg0, arg1)
	if arg0.activeMapId ~= arg1.id then
		arg0.activeMapId = arg1.id

		arg0:DispatchEvent(var0.EventUpdateActiveMap, arg1)
	end
end

function var0.GetActiveMap(arg0)
	return arg0.activeMapId and arg0:GetMap(arg0.activeMapId)
end

function var0.GetDiscoverRate(arg0)
	return 0
end

function var0.CheckMapActive(arg0, arg1)
	local var0 = arg0:GetMap(arg1)

	assert(var0, "map not exist: " .. arg1)

	return var0.active or _.any(_.values(arg0:GetPartMaps(arg1)), function(arg0)
		return arg0.active
	end)
end

function var0.GetAtlasPixelSize(arg0)
	return Vector2(arg0.config.size[1], arg0.config.size[2])
end

function var0.GetAchEntranceList(arg0)
	return arg0.achEntranceList
end

function var0.GetOpenEntranceDic(arg0, arg1)
	return arg0.replaceDic.open[nowWorld():GetRealm()][arg1] or {}
end

function var0.GetStepDic(arg0, arg1)
	return arg0.replaceDic.step[arg1] or {}
end

function var0.GetTaskDic(arg0, arg1)
	return arg0.replaceDic.task[arg1] or {}
end

function var0.GetTreasureDic(arg0, arg1)
	return arg0.replaceDic.treasure[arg1] or {}
end

function var0.UpdateProgress(arg0, arg1, arg2)
	local var0 = {}

	for iter0 = arg1 + 1, arg2 do
		for iter1 in pairs(arg0:GetOpenEntranceDic(iter0)) do
			var0[iter1] = 1
		end
	end

	arg0:DispatchEvent(var0.EventUpdateProgress, var0)

	local var1 = {}

	for iter2 in pairs(arg0:GetStepDic(arg2)) do
		var1[iter2] = 1
	end

	for iter3 in pairs(arg0:GetStepDic(arg1)) do
		var1[iter3] = (var1[iter3] or 0) - 1
	end

	for iter4, iter5 in pairs(var1) do
		if iter5 ~= 0 then
			arg0.entranceDic[iter4]:UpdateDisplayMarks("step", iter5 > 0)
		end
	end
end

function var0.UpdateTask(arg0, arg1)
	local var0 = arg1:isAlive()
	local var1 = (var0 and 1 or 0) - (arg0.taskMarkDic[arg1.id] and 1 or 0)

	arg0.taskMarkDic[arg1.id] = var0

	if var1 == 0 then
		return
	end

	local var2 = false

	for iter0 in pairs(arg0:GetTaskDic(arg1.id)) do
		var2 = true

		if arg1.config.type == 0 then
			arg0.entranceDic[iter0]:UpdateDisplayMarks("task_main", var1 > 0)
		elseif arg1.config.type == 6 then
			arg0.entranceDic[iter0]:UpdateDisplayMarks("task_collecktion", var1 > 0)
		else
			arg0.entranceDic[iter0]:UpdateDisplayMarks("task", var1 > 0)
		end
	end

	local var3 = arg1:GetFollowingEntrance()

	if var3 and not var2 then
		if arg1.config.type == 0 then
			arg0.entranceDic[var3]:UpdateDisplayMarks("task_following_main", var1 > 0)
		elseif arg1.config.type == 7 then
			arg0.entranceDic[var3]:UpdateDisplayMarks("task_following_boss", var1 > 0)
		else
			arg0.entranceDic[var3]:UpdateDisplayMarks("task_following", var1 > 0)
		end
	end
end

function var0.UpdateTreasure(arg0, arg1)
	local var0 = nowWorld()
	local var1 = var0:GetInventoryProxy():GetItemCount(arg1)
	local var2 = (var1 > 0 and 1 or 0) - (arg0.treasureMarkDic[arg1] and 1 or 0)

	arg0.treasureMarkDic[arg1] = var1 > 0

	if var2 ~= 0 then
		local var3 = var0:FindTreasureEntrance(arg1)

		if pg.world_item_data_template[arg1].usage_arg[1] == 1 then
			var3:UpdateDisplayMarks("treasure_sairen", var2 > 0)
		else
			var3:UpdateDisplayMarks("treasure", var2 > 0)
		end
	end
end

function var0.SetPressingMarkList(arg0, arg1)
	_.each(arg0.pressingMapList, function(arg0)
		arg0:GetMap(arg0):UpdatePressingMark(false)
	end)

	local var0 = 0

	arg0.pressingMapList = arg1

	_.each(arg0.pressingMapList, function(arg0)
		arg0:GetMap(arg0):UpdatePressingMark(true)

		local var0 = arg0.mapEntrance[arg0]

		if var0 and not var0:HasPort() then
			var0 = var0 + 1
		end
	end)

	arg0.pressingUnlcokCount = var0

	arg0:BuildTransportDic()
end

function var0.BuildTransportDic(arg0)
	arg0.transportDic = {}

	for iter0, iter1 in pairs(arg0.entranceDic) do
		if iter1:IsPressing() then
			arg0.transportDic[iter0] = true

			for iter2 in pairs(iter1.transportDic) do
				arg0.transportDic[iter2] = true
			end
		end
	end

	if nowWorld():IsReseted() then
		arg0:AddPortTransportDic()
	end
end

function var0.AddPortTransportDic(arg0)
	for iter0, iter1 in pairs(arg0.portEntranceList) do
		for iter2, iter3 in ipairs(iter1) do
			arg0.transportDic[iter3] = true
		end
	end
end

function var0.MarkMapTransport(arg0, arg1)
	local var0 = arg0.mapEntrance[arg1]

	if var0 then
		arg0.transportDic[var0.id] = true
	end
end

function var0.AddPressingMap(arg0, arg1)
	if _.any(arg0.pressingMapList, function(arg0)
		return arg0 == arg1
	end) then
		return
	else
		arg0:GetMap(arg1):UpdatePressingMark(true)
		table.insert(arg0.pressingMapList, arg1)

		local var0 = arg0.mapEntrance[arg1]

		if var0 then
			local var1 = {}

			arg0.transportDic[var0.id] = true
			var1[var0.id] = true

			for iter0 in pairs(var0.transportDic) do
				if not arg0.transportDic[iter0] then
					arg0.transportDic[iter0] = true
					var1[iter0] = true
				end
			end

			arg0:DispatchEvent(var0.EventAddPressingEntrance, var1)

			if not var0:HasPort() then
				arg0.pressingUnlcokCount = arg0.pressingUnlcokCount + 1

				arg0:UpdateUnlockCountPortMark()
			end
		end

		arg0:DispatchEvent(var0.EventAddPressingMap, arg1)
	end
end

function var0.GetPressingUnlockCount(arg0)
	return arg0.pressingUnlcokCount
end

function var0.GetPressingUnlockRecordCount(arg0, arg1)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = nowWorld().activateCount

	return PlayerPrefs.GetInt(string.format("world_new_shop_unlock_count_in_port_%d_%d_%d", var0, var1, arg1), -1)
end

function var0.SetPressingUnlockRecordCount(arg0, arg1, arg2)
	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = nowWorld().activateCount

	return PlayerPrefs.SetInt(string.format("world_new_shop_unlock_count_in_port_%d_%d_%d", var0, var1, arg1), arg2)
end

function var0.SetSairenEntranceList(arg0, arg1)
	_.each(arg0.sairenEntranceList, function(arg0)
		local var0 = arg0:GetEntrance(arg0)

		var0:UpdateSairenMark(false)
		var0:UpdateDisplayMarks("sairen", false)
	end)

	arg0.sairenEntranceList = arg1

	_.each(arg0.sairenEntranceList, function(arg0)
		local var0 = arg0:GetEntrance(arg0)

		var0:UpdateSairenMark(true)
		var0:UpdateDisplayMarks("sairen", true)
	end)
end

function var0.RemoveSairenEntrance(arg0, arg1)
	local var0 = table.indexof(arg0.sairenEntranceList, arg1.id)

	if var0 then
		table.remove(arg0.sairenEntranceList, var0)
		arg1:UpdateSairenMark(false)
		arg1:UpdateDisplayMarks("sairen", false)
	end
end

function var0.SetCostMapList(arg0, arg1)
	for iter0 in pairs(arg0.costMapDic) do
		arg0:GetMap(iter0).isCost = false
	end

	arg0.costMapDic = {}

	_.each(arg1, function(arg0)
		arg0.costMapDic[arg0.random_id] = true
		arg0:GetMap(arg0.random_id).isCost = true
	end)
end

function var0.UpdateCostMap(arg0, arg1, arg2)
	if not arg0.costMapDic[arg1] and arg2 then
		nowWorld():ClearAllFleetDefeatEnemies()
	end

	arg0.costMapDic[arg1] = arg2
end

function var0.SetPortMarkList(arg0, arg1, arg2)
	arg0.markPortDic.goods = {}

	for iter0, iter1 in ipairs(arg1) do
		arg0.markPortDic.goods[iter1] = true
	end

	arg0.markPortDic.new = {}

	for iter2, iter3 in ipairs(arg2) do
		arg0.markPortDic.new[iter3] = true
	end
end

function var0.UpdatePortMark(arg0, arg1, arg2, arg3)
	if not arg0.portEntranceList[arg1] then
		return
	end

	local var0

	if arg2 ~= nil and tobool(arg0.markPortDic.goods[arg1]) ~= arg2 then
		arg0.markPortDic.goods[arg1] = arg2
		var0 = var0 or {}

		for iter0, iter1 in ipairs(arg0.portEntranceList[arg1]) do
			var0[iter1] = true
		end
	end

	if arg3 ~= nil and tobool(arg0.markPortDic.new[arg1]) ~= arg3 then
		arg0.markPortDic.new[arg1] = arg3
		var0 = var0 or {}

		for iter2, iter3 in ipairs(arg0.portEntranceList[arg1]) do
			var0[iter3] = true
		end
	end

	if var0 and not nowWorld():UsePortNShop() then
		arg0:DispatchEvent(var0.EventUpdatePortMark, var0)
	end
end

function var0.InitPortMarkNShopList(arg0)
	local var0 = arg0:GetPressingUnlockCount()

	arg0.markPortDic.newGoods = {}

	for iter0, iter1 in pairs(arg0.nShopGoodsDic) do
		local var1 = Goods.Create({
			id = iter0,
			count = iter1
		}, Goods.TYPE_WORLD_NSHOP)
		local var2 = var1:getConfig("port_id")
		local var3 = var1:getConfig("unlock_num")
		local var4 = arg0:GetPressingUnlockRecordCount(var2)

		if var1:canPurchase() and var4 < var3 and var3 <= var0 then
			arg0.markPortDic.newGoods[var2] = true
		end
	end
end

function var0.UpdateUnlockCountPortMark(arg0)
	if not nowWorld():UsePortNShop() then
		return
	end

	local var0 = arg0.markPortDic.newGoods

	arg0:InitPortMarkNShopList()

	for iter0, iter1 in ipairs(underscore.keys(arg0.portEntranceList)) do
		if tobool(var0[iter1]) ~= tobool(arg0.markPortDic.newGoods[iter1]) then
			local var1 = {}

			for iter2, iter3 in ipairs(arg0.portEntranceList[iter1]) do
				var1[iter3] = true
			end
		end
	end

	if changeDic then
		arg0:DispatchEvent(var0.EventUpdatePortMark, changeDic)
	end
end

function var0.UpdatePortMarkNShop(arg0, arg1, arg2)
	if not arg0.portEntranceList[arg1] then
		return
	end

	if tobool(arg0.markPortDic.newGoods[arg1]) ~= arg2 then
		arg0.markPortDic.newGoods[arg1] = arg2

		if nowWorld():UsePortNShop() then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.portEntranceList[arg1]) do
				var0[iter1] = true
			end

			arg0:DispatchEvent(var0.EventUpdatePortMark, var0)
		end
	end
end

function var0.GetAnyPortMarkNShop(arg0)
	for iter0, iter1 in pairs(arg0.markPortDic.newGoods) do
		if iter1 then
			return true
		end
	end

	return false
end

function var0.InitWorldNShopGoods(arg0, arg1)
	arg0.nShopGoodsDic = {}

	for iter0, iter1 in ipairs(pg.world_newshop_data.all) do
		arg0.nShopGoodsDic[iter1] = 0
	end

	for iter2, iter3 in ipairs(arg1) do
		assert(arg0.nShopGoodsDic[iter3.goods_id], "without this good in id " .. iter3.goods_id)

		arg0.nShopGoodsDic[iter3.goods_id] = arg0.nShopGoodsDic[iter3.goods_id] + iter3.count
	end
end

function var0.UpdateNShopGoodsCount(arg0, arg1, arg2)
	assert(arg0.nShopGoodsDic[arg1], "without this goods:" .. arg1)

	if arg2 ~= 0 then
		arg0.nShopGoodsDic[arg1] = arg0.nShopGoodsDic[arg1] + arg2

		arg0:DispatchEvent(var0.EventUpdateNGoodsCount, arg1, arg0.nShopGoodsDic[arg1])
	end
end

function var0.GetEntrancePortInfo(arg0, arg1)
	local var0 = arg0:GetEntrance(arg1)
	local var1 = var0:GetPortId()

	if nowWorld():UsePortNShop() then
		return arg0.transportDic[var0.id], arg0.markPortDic.newGoods[var1], arg0.markPortDic.newGoods[var1]
	else
		return arg0.transportDic[var0.id], arg0.markPortDic.goods[var1], arg0.markPortDic.new[var1]
	end
end

return var0
