local var0 = class("Apartment", import(".BaseVO"))

var0.TRIGGER_TOUCH = 1001
var0.TRIGGER_TALK = 1002
var0.TRIGGER_OWNER = 1007
var0.TRIGGER_PROPOSE = 1008

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.ship_group
	arg0.level = arg1.favor_lv
	arg0.favor = arg1.favor_exp
	arg0.daily = arg1.daily_favor
	arg0.skinId = arg1.cur_skin
	arg0.skinList = {}

	table.insert(arg0.skinList, arg0:getConfig("skin_model"))

	for iter0, iter1 in ipairs(arg1.skins) do
		table.insert(arg0.skinList, iter1)
	end

	table.sort(arg0.skinList)

	arg0.triggerCountDic = setmetatable({}, {
		__index = function(arg0, arg1)
			return 0
		end
	})

	for iter2, iter3 in ipairs(arg1.regular_trigger) do
		arg0.triggerCountDic[iter3] = arg0.triggerCountDic[iter3] + 1
	end

	arg0.furnitures = {}

	table.Ipairs(arg1.furnitures, function(arg0, arg1)
		arg0.furnitures[arg0] = Dorm3dFurniture.New({
			configId = arg1.furniture_id,
			slotId = arg1.slot_id
		})
	end)

	arg0.slots = {}

	table.Ipairs(arg0:GetSlotIDList(), function(arg0, arg1)
		local var0 = Dorm3dFurnitureSlot.New({
			configId = arg1
		})

		arg0.slots[arg0] = var0
	end)

	arg0.zones = {}

	table.Ipairs(arg0:GetZoneIDList(), function(arg0, arg1)
		local var0 = Dorm3dZone.New({
			configId = arg1
		})

		arg0.zones[arg0] = var0

		var0:SetSlots(_.map(var0:GetSlotIDList(), function(arg0)
			return _.detect(arg0.slots, function(arg0)
				return arg0:GetConfigID() == arg0
			end)
		end))
	end)

	arg0.globalZones = {}
	arg0.normalZones = {}

	_.each(arg0.zones, function(arg0)
		table.insert(arg0:IsGlobal() and arg0.globalZones or arg0.normalZones, arg0)
	end)

	arg0.cameraZones = _.map(arg0:GetCameraZoneIDList(), function(arg0)
		return Dorm3dCameraZone.New({
			configId = arg0
		})
	end)
	arg0.talkDic = {}

	for iter4, iter5 in ipairs(arg1.dialogues) do
		arg0.talkDic[iter5] = true
	end

	arg0.collectItemDic = {}

	for iter6, iter7 in ipairs(arg1.collections) do
		arg0.collectItemDic[iter7] = true
	end

	arg0.zoneDic = {}

	for iter8, iter9 in ipairs(pg.dorm3d_zone_template.get_id_list_by_char_id[arg0.configId]) do
		local var0 = Dorm3dZone.New({
			configId = iter9
		})
		local var1 = var0:GetWatchCameraName()

		if var1 and var1 ~= "" then
			arg0.zoneDic[var1] = var0
		end
	end
end

function var0.bindConfigTable(arg0)
	return pg.dorm3d_dorm_template
end

function var0.getFavorConfig(arg0, arg1, arg2)
	arg2 = arg2 or arg0.level

	local var0 = pg.dorm3d_favor.get_id_list_by_char_id[arg0.configId]

	return pg.dorm3d_favor[var0[arg2]][arg1]
end

function var0.addFavor(arg0, arg1)
	local var0 = pg.dorm3d_favor_trigger[arg1]
	local var1 = var0.num

	if var0.is_repeat > 0 then
		local var2 = getDorm3dGameset("daily_exp_max")[1]

		var1 = math.min(var1, var2 - arg0.daily)
		arg0.daily = arg0.daily + var1
	end

	arg0.favor = arg0.favor + var1
	arg0.triggerCountDic[arg1] = arg0.triggerCountDic[arg1] + 1

	return var1
end

function var0.getDailyFavor(arg0)
	return arg0.daily, getDorm3dGameset("daily_exp_max")[1]
end

function var0.addLevel(arg0)
	arg0.favor = arg0.favor - arg0:getNextExp()
	arg0.level = arg0.level + 1
end

function var0.addSkin(arg0, arg1)
	table.insert(arg0.skinList, arg1)
	table.sort(arg0.skinList)
end

function var0.getSkinId(arg0)
	if arg0.skinId == 0 then
		return arg0:getConfig("skin_model")
	else
		return arg0.skinId
	end
end

function var0.getStageRank(arg0)
	if not var0.stageDic then
		var0.stageDic = {}

		for iter0, iter1 in ipairs(getDorm3dGameset("stage_level")[2]) do
			for iter2, iter3 in ipairs(iter1) do
				var0.stageDic[iter3] = iter0
			end
		end
	end

	return var0.stageDic[arg0.level]
end

function var0.getStageText(arg0)
	return getDorm3dGameset("stage_name")[2][arg0:getStageRank()][1]
end

function var0.getNextExp(arg0)
	if arg0.level < getDorm3dGameset("favor_level")[1] then
		return arg0:getFavorConfig("favor_exp", arg0.level + 1)
	else
		return 0
	end
end

function var0.GetScene(arg0)
	return arg0:getConfig("scene")
end

function var0.GetBaseScene(arg0)
	return arg0:getConfig("scene_base")
end

function var0.GetSceneRootName(arg0)
	return arg0:getConfig("scene_parent")
end

function var0.GetAssetName(arg0)
	return arg0:getConfig("asset_name")
end

function var0.GetBaseModelName(arg0)
	return arg0:getConfig("base_model")
end

function var0.GetSceneData(arg0, arg1)
	return {
		sceneName = arg0:getConfig("scene")[arg1],
		baseSceneName = arg0:getConfig("scene_base")[arg1],
		modelName = arg0:GetSkinModelName()
	}
end

function var0.GetSkinModelName(arg0)
	local var0 = arg0.skinId

	if var0 == 0 then
		var0 = arg0:getConfig("skin_model")
	end

	assert(underscore.any(pg.dorm3d_resource.get_id_list_by_ship_group[arg0.configId], function(arg0)
		return var0 == arg0
	end))

	return pg.dorm3d_resource[var0].model_id
end

function var0.GetZoneIDList(arg0)
	return pg.dorm3d_zone_template.get_id_list_by_char_id[arg0.configId]
end

function var0.GetSlotIDList(arg0)
	return pg.dorm3d_furniture_slot_template.get_id_list_by_char_id[arg0.configId]
end

function var0.GetCameraZoneIDList(arg0)
	return pg.dorm3d_camera_zone_template.get_id_list_by_char_id[arg0.configId]
end

function var0.GetZones(arg0)
	return arg0.zones
end

function var0.GetGlobalZones(arg0)
	return arg0.globalZones
end

function var0.GetNormalZones(arg0)
	return arg0.normalZones
end

function var0.GetCameraZones(arg0)
	return arg0.cameraZones
end

function var0.GetSlots(arg0)
	return arg0.slots
end

function var0.GetFurnitures(arg0)
	return arg0.furnitures
end

function var0.ReplaceFurnitures(arg0, arg1)
	_.each(arg1, function(arg0)
		arg0:ReplaceFurniture(arg0.slotId, arg0.furnitureId)
	end)
end

function var0.ReplaceFurniture(arg0, arg1, arg2)
	local var0 = _.detect(arg0.furnitures, function(arg0)
		return arg0:GetSlotID() == arg1
	end)

	if var0 then
		var0:SetSlotID(0)
	end

	local var1 = _.detect(arg0.furnitures, function(arg0)
		return arg0:GetConfigID() == arg2 and arg0:GetSlotID() == 0
	end)

	if var1 then
		var1:SetSlotID(arg1)
	end
end

function var0.getTalkingList(arg0)
	return pg.dorm3d_dialogue_group.get_id_list_by_char_id[arg0.configId]
end

var0.ENTER_TALK_TYPE = {
	[103] = true,
	[102] = true,
	[104] = true,
	[101] = true,
	[105] = true
}

function var0.getEnterTalking(arg0)
	return underscore.filter(arg0:getTalkingList(), function(arg0)
		local var0 = pg.dorm3d_dialogue_group[arg0]

		return var0.ENTER_TALK_TYPE[var0.type] and arg0:checkUnlockConfig(var0.unlock)
	end)
end

function var0.getFurnitureTalking(arg0, arg1)
	return underscore.filter(arg0:getTalkingList(), function(arg0)
		local var0 = pg.dorm3d_dialogue_group[arg0]

		return var0.type == 200 and var0.trigger_config == arg1 and arg0:checkUnlockConfig(var0.unlock)
	end)
end

function var0.getTouchConfig(arg0, arg1)
	local var0
	local var1 = {}

	for iter0, iter1 in ipairs(pg.dorm3d_touch_data.get_id_list_by_char_id[arg0.configId]) do
		if arg1 == pg.dorm3d_touch_data[iter1].trigger_area then
			var0 = pg.dorm3d_touch_data[iter1]

			break
		end
	end

	local var2 = arg0:getStageRank()

	if not var0 then
		return
	end

	for iter2, iter3 in ipairs(var0.stage_unlock) do
		if var2 < iter2 then
			break
		else
			var1 = table.mergeArray(var1, iter3)
		end
	end

	local var3 = {
		[0] = envFunc(function()
			up, donw, left, right, zoom_in, zoom_out = unpack(var0.camera_trigger[var2])
		end, {})
	}

	for iter4, iter5 in ipairs(var1) do
		local var4 = pg.dorm3d_touch_trigger[iter5]

		var3[var4.touch_type] = var3[var4.touch_type] or {}
		var3[var4.touch_type][var4.body_area] = iter5
	end

	return var0, var3
end

function var0.getGiftIds(arg0)
	local var0 = pg.dorm3d_gift.get_id_list_by_ship_group_id

	return table.mergeArray(var0[0], var0[arg0.configId])
end

function var0.getCollectConfig(arg0, arg1)
	local var0 = pg.dorm3D_collect[arg0.configId]

	return var0 and var0[arg1] or nil
end

function var0.getTriggerableCollectItems(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:getCollectConfig("collection_template_list")) do
		local var1 = pg.dorm3d_collection_template[iter1]

		if not arg0.collectItemDic[iter1] and arg0:checkUnlockConfig(var1.unlock) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.checkUnlockConfig(arg0, arg1)
	local var0, var1 = unpack(arg1)

	return switch(var0, {
		function()
			if arg0.level >= var1 then
				return true
			else
				return false, string.format("apartment level unenough:%d", var1)
			end
		end,
		function()
			if underscore.any(arg0.furnitures, function(arg0)
				return arg0.configId == var1
			end) then
				return true
			else
				return false, string.format("without dorm furniture:%d", var1)
			end
		end,
		function()
			if getProxy(ApartmentProxy):isGiveGiftDone(var1) then
				return true
			else
				return false, string.format("gift:%d didn't had given", var1)
			end
		end
	}, function()
		return false, string.format("without unlock type:%d", var0)
	end)
end

function var0.getZone(arg0, arg1)
	return arg0.zoneDic[arg1]
end

function var0.getZoneNames(arg0)
	return underscore.keys(arg0.zoneDic)
end

return var0
