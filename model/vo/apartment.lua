local var0_0 = class("Apartment", import(".BaseVO"))

var0_0.TRIGGER_TOUCH = 1001
var0_0.TRIGGER_TALK = 1002
var0_0.TRIGGER_OWNER = 1007
var0_0.TRIGGER_PROPOSE = 1008

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.ship_group
	arg0_1.level = arg1_1.favor_lv
	arg0_1.favor = arg1_1.favor_exp
	arg0_1.daily = arg1_1.daily_favor
	arg0_1.skinId = arg1_1.cur_skin
	arg0_1.skinList = {}

	table.insert(arg0_1.skinList, arg0_1:getConfig("skin_model"))

	for iter0_1, iter1_1 in ipairs(arg1_1.skins) do
		table.insert(arg0_1.skinList, iter1_1)
	end

	table.sort(arg0_1.skinList)

	arg0_1.triggerCountDic = setmetatable({}, {
		__index = function(arg0_2, arg1_2)
			return 0
		end
	})

	for iter2_1, iter3_1 in ipairs(arg1_1.regular_trigger) do
		arg0_1.triggerCountDic[iter3_1] = arg0_1.triggerCountDic[iter3_1] + 1
	end

	arg0_1.furnitures = {}

	table.Ipairs(arg1_1.furnitures, function(arg0_3, arg1_3)
		arg0_1.furnitures[arg0_3] = Dorm3dFurniture.New({
			configId = arg1_3.furniture_id,
			slotId = arg1_3.slot_id
		})
	end)

	arg0_1.slots = {}

	table.Ipairs(arg0_1:GetSlotIDList(), function(arg0_4, arg1_4)
		local var0_4 = Dorm3dFurnitureSlot.New({
			configId = arg1_4
		})

		arg0_1.slots[arg0_4] = var0_4
	end)

	arg0_1.zones = {}

	table.Ipairs(arg0_1:GetZoneIDList(), function(arg0_5, arg1_5)
		local var0_5 = Dorm3dZone.New({
			configId = arg1_5
		})

		arg0_1.zones[arg0_5] = var0_5

		var0_5:SetSlots(_.map(var0_5:GetSlotIDList(), function(arg0_6)
			return _.detect(arg0_1.slots, function(arg0_7)
				return arg0_7:GetConfigID() == arg0_6
			end)
		end))
	end)

	arg0_1.globalZones = {}
	arg0_1.normalZones = {}

	_.each(arg0_1.zones, function(arg0_8)
		table.insert(arg0_8:IsGlobal() and arg0_1.globalZones or arg0_1.normalZones, arg0_8)
	end)

	arg0_1.cameraZones = _.map(arg0_1:GetCameraZoneIDList(), function(arg0_9)
		return Dorm3dCameraZone.New({
			configId = arg0_9
		})
	end)
	arg0_1.talkDic = {}

	for iter4_1, iter5_1 in ipairs(arg1_1.dialogues) do
		arg0_1.talkDic[iter5_1] = true
	end

	arg0_1.collectItemDic = {}

	for iter6_1, iter7_1 in ipairs(arg1_1.collections) do
		arg0_1.collectItemDic[iter7_1] = true
	end

	arg0_1.zoneDic = {}

	for iter8_1, iter9_1 in ipairs(pg.dorm3d_zone_template.get_id_list_by_char_id[arg0_1.configId]) do
		local var0_1 = Dorm3dZone.New({
			configId = iter9_1
		})
		local var1_1 = var0_1:GetWatchCameraName()

		if var1_1 and var1_1 ~= "" then
			arg0_1.zoneDic[var1_1] = var0_1
		end
	end
end

function var0_0.bindConfigTable(arg0_10)
	return pg.dorm3d_dorm_template
end

function var0_0.getFavorConfig(arg0_11, arg1_11, arg2_11)
	arg2_11 = arg2_11 or arg0_11.level

	local var0_11 = pg.dorm3d_favor.get_id_list_by_char_id[arg0_11.configId]

	return pg.dorm3d_favor[var0_11[arg2_11]][arg1_11]
end

function var0_0.addFavor(arg0_12, arg1_12)
	local var0_12 = pg.dorm3d_favor_trigger[arg1_12]
	local var1_12 = var0_12.num

	if var0_12.is_repeat > 0 then
		local var2_12 = getDorm3dGameset("daily_exp_max")[1]

		var1_12 = math.min(var1_12, var2_12 - arg0_12.daily)
		arg0_12.daily = arg0_12.daily + var1_12
	end

	arg0_12.favor = arg0_12.favor + var1_12
	arg0_12.triggerCountDic[arg1_12] = arg0_12.triggerCountDic[arg1_12] + 1

	return var1_12
end

function var0_0.getDailyFavor(arg0_13)
	return arg0_13.daily, getDorm3dGameset("daily_exp_max")[1]
end

function var0_0.addLevel(arg0_14)
	arg0_14.favor = arg0_14.favor - arg0_14:getNextExp()
	arg0_14.level = arg0_14.level + 1
end

function var0_0.addSkin(arg0_15, arg1_15)
	table.insert(arg0_15.skinList, arg1_15)
	table.sort(arg0_15.skinList)
end

function var0_0.getSkinId(arg0_16)
	if arg0_16.skinId == 0 then
		return arg0_16:getConfig("skin_model")
	else
		return arg0_16.skinId
	end
end

function var0_0.getStageRank(arg0_17)
	if not var0_0.stageDic then
		var0_0.stageDic = {}

		for iter0_17, iter1_17 in ipairs(getDorm3dGameset("stage_level")[2]) do
			for iter2_17, iter3_17 in ipairs(iter1_17) do
				var0_0.stageDic[iter3_17] = iter0_17
			end
		end
	end

	return var0_0.stageDic[arg0_17.level]
end

function var0_0.getStageText(arg0_18)
	return getDorm3dGameset("stage_name")[2][arg0_18:getStageRank()][1]
end

function var0_0.getNextExp(arg0_19)
	if arg0_19.level < getDorm3dGameset("favor_level")[1] then
		return arg0_19:getFavorConfig("favor_exp", arg0_19.level + 1)
	else
		return 0
	end
end

function var0_0.GetScene(arg0_20)
	return arg0_20:getConfig("scene")
end

function var0_0.GetBaseScene(arg0_21)
	return arg0_21:getConfig("scene_base")
end

function var0_0.GetSceneRootName(arg0_22)
	return arg0_22:getConfig("scene_parent")
end

function var0_0.GetAssetName(arg0_23)
	return arg0_23:getConfig("asset_name")
end

function var0_0.GetBaseModelName(arg0_24)
	return arg0_24:getConfig("base_model")
end

function var0_0.GetSceneData(arg0_25, arg1_25)
	return {
		sceneName = arg0_25:getConfig("scene")[arg1_25],
		baseSceneName = arg0_25:getConfig("scene_base")[arg1_25],
		modelName = arg0_25:GetSkinModelName()
	}
end

function var0_0.GetSkinModelName(arg0_26)
	local var0_26 = arg0_26.skinId

	if var0_26 == 0 then
		var0_26 = arg0_26:getConfig("skin_model")
	end

	assert(underscore.any(pg.dorm3d_resource.get_id_list_by_ship_group[arg0_26.configId], function(arg0_27)
		return var0_26 == arg0_27
	end))

	return pg.dorm3d_resource[var0_26].model_id
end

function var0_0.GetZoneIDList(arg0_28)
	return pg.dorm3d_zone_template.get_id_list_by_char_id[arg0_28.configId]
end

function var0_0.GetSlotIDList(arg0_29)
	return pg.dorm3d_furniture_slot_template.get_id_list_by_char_id[arg0_29.configId]
end

function var0_0.GetCameraZoneIDList(arg0_30)
	return pg.dorm3d_camera_zone_template.get_id_list_by_char_id[arg0_30.configId]
end

function var0_0.GetZones(arg0_31)
	return arg0_31.zones
end

function var0_0.GetGlobalZones(arg0_32)
	return arg0_32.globalZones
end

function var0_0.GetNormalZones(arg0_33)
	return arg0_33.normalZones
end

function var0_0.GetCameraZones(arg0_34)
	return arg0_34.cameraZones
end

function var0_0.GetSlots(arg0_35)
	return arg0_35.slots
end

function var0_0.GetFurnitures(arg0_36)
	return arg0_36.furnitures
end

function var0_0.ReplaceFurnitures(arg0_37, arg1_37)
	_.each(arg1_37, function(arg0_38)
		arg0_37:ReplaceFurniture(arg0_38.slotId, arg0_38.furnitureId)
	end)
end

function var0_0.ReplaceFurniture(arg0_39, arg1_39, arg2_39)
	local var0_39 = _.detect(arg0_39.furnitures, function(arg0_40)
		return arg0_40:GetSlotID() == arg1_39
	end)

	if var0_39 then
		var0_39:SetSlotID(0)
	end

	local var1_39 = _.detect(arg0_39.furnitures, function(arg0_41)
		return arg0_41:GetConfigID() == arg2_39 and arg0_41:GetSlotID() == 0
	end)

	if var1_39 then
		var1_39:SetSlotID(arg1_39)
	end
end

function var0_0.getTalkingList(arg0_42)
	return pg.dorm3d_dialogue_group.get_id_list_by_char_id[arg0_42.configId]
end

var0_0.ENTER_TALK_TYPE = {
	[103] = true,
	[102] = true,
	[104] = true,
	[101] = true,
	[105] = true
}

function var0_0.getEnterTalking(arg0_43)
	return underscore.filter(arg0_43:getTalkingList(), function(arg0_44)
		local var0_44 = pg.dorm3d_dialogue_group[arg0_44]

		return var0_0.ENTER_TALK_TYPE[var0_44.type] and arg0_43:checkUnlockConfig(var0_44.unlock)
	end)
end

function var0_0.getFurnitureTalking(arg0_45, arg1_45)
	return underscore.filter(arg0_45:getTalkingList(), function(arg0_46)
		local var0_46 = pg.dorm3d_dialogue_group[arg0_46]

		return var0_46.type == 200 and var0_46.trigger_config == arg1_45 and arg0_45:checkUnlockConfig(var0_46.unlock)
	end)
end

function var0_0.getTouchConfig(arg0_47, arg1_47)
	local var0_47
	local var1_47 = {}

	for iter0_47, iter1_47 in ipairs(pg.dorm3d_touch_data.get_id_list_by_char_id[arg0_47.configId]) do
		if arg1_47 == pg.dorm3d_touch_data[iter1_47].trigger_area then
			var0_47 = pg.dorm3d_touch_data[iter1_47]

			break
		end
	end

	local var2_47 = arg0_47:getStageRank()

	if not var0_47 then
		return
	end

	for iter2_47, iter3_47 in ipairs(var0_47.stage_unlock) do
		if var2_47 < iter2_47 then
			break
		else
			var1_47 = table.mergeArray(var1_47, iter3_47)
		end
	end

	local var3_47 = {
		[0] = {}
	}

	envFunc(var3_47[0], function()
		up, donw, left, right, zoom_in, zoom_out = unpack(var0_47.camera_trigger[var2_47])
	end)

	for iter4_47, iter5_47 in ipairs(var1_47) do
		local var4_47 = pg.dorm3d_touch_trigger[iter5_47]

		var3_47[var4_47.touch_type] = var3_47[var4_47.touch_type] or {}
		var3_47[var4_47.touch_type][var4_47.body_area] = iter5_47
	end

	return var0_47, var3_47
end

function var0_0.getGiftIds(arg0_49)
	local var0_49 = pg.dorm3d_gift.get_id_list_by_ship_group_id

	return table.mergeArray(var0_49[0], var0_49[arg0_49.configId])
end

function var0_0.getCollectConfig(arg0_50, arg1_50)
	local var0_50 = pg.dorm3D_collect[arg0_50.configId]

	return var0_50 and var0_50[arg1_50] or nil
end

function var0_0.getTriggerableCollectItems(arg0_51)
	local var0_51 = {}

	for iter0_51, iter1_51 in ipairs(arg0_51:getCollectConfig("collection_template_list")) do
		local var1_51 = pg.dorm3d_collection_template[iter1_51]

		if not arg0_51.collectItemDic[iter1_51] and arg0_51:checkUnlockConfig(var1_51.unlock) then
			table.insert(var0_51, iter1_51)
		end
	end

	return var0_51
end

function var0_0.checkUnlockConfig(arg0_52, arg1_52)
	local var0_52, var1_52 = unpack(arg1_52)

	return switch(var0_52, {
		function()
			if arg0_52.level >= var1_52 then
				return true
			else
				return false, string.format("apartment level unenough:%d", var1_52)
			end
		end,
		function()
			if underscore.any(arg0_52.furnitures, function(arg0_55)
				return arg0_55.configId == var1_52
			end) then
				return true
			else
				return false, string.format("without dorm furniture:%d", var1_52)
			end
		end,
		function()
			if getProxy(ApartmentProxy):isGiveGiftDone(var1_52) then
				return true
			else
				return false, string.format("gift:%d didn't had given", var1_52)
			end
		end
	}, function()
		return false, string.format("without unlock type:%d", var0_52)
	end)
end

function var0_0.getZone(arg0_58, arg1_58)
	return arg0_58.zoneDic[arg1_58]
end

function var0_0.getZoneNames(arg0_59)
	return underscore.keys(arg0_59.zoneDic)
end

return var0_0
