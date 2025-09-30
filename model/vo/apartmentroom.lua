local var0_0 = class("ApartmentRoom", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.unlockCharacter = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.ships or {}) do
		arg0_1.unlockCharacter[iter1_1] = true
	end

	arg0_1.furnitures = {}

	table.Ipairs(arg1_1.furnitures or {}, function(arg0_2, arg1_2)
		arg0_1.furnitures[arg0_2] = Dorm3dFurniture.New({
			configId = arg1_2.furniture_id,
			slotId = arg1_2.slot_id
		})
	end)

	arg0_1.slotDic = {}

	table.Ipairs(arg0_1:GetSlotIDList(), function(arg0_3, arg1_3)
		arg0_1.slotDic[arg1_3] = Dorm3dFurnitureSlot.New({
			configId = arg1_3
		})
	end)

	arg0_1.zoneDic = {}
	arg0_1.zoneReplaceDic = {}

	table.Ipairs(arg0_1:GetZoneIDList(), function(arg0_4, arg1_4)
		local var0_4 = Dorm3dZone.New({
			configId = arg1_4
		})
		local var1_4 = var0_4:GetWatchCameraName()

		arg0_1.zoneDic[var1_4] = var0_4
		arg0_1.zoneReplaceDic[var1_4] = {}

		var0_4:SetSlots(_.map(var0_4:GetSlotIDList(), function(arg0_5)
			return arg0_1.slotDic[arg0_5]
		end))
	end)
	arg0_1:UpdateFurnitureReplaceConfig()

	arg0_1.cameraZones = _.map(arg0_1:GetCameraZoneIDList(), function(arg0_6)
		return Dorm3dCameraZone.New({
			configId = arg0_6
		})
	end)
	arg0_1.collectItemDic = {}

	for iter2_1, iter3_1 in ipairs(arg1_1.collections or {}) do
		arg0_1.collectItemDic[iter3_1] = true
	end

	arg0_1.shipArAnimationDic = {}

	local var0_1 = arg0_1:getConfig("ar_anim")

	if var0_1 then
		for iter4_1, iter5_1 in ipairs(var0_1) do
			local var1_1 = iter5_1[1]
			local var2_1 = iter5_1[2]
			local var3_1 = _.map(var2_1, function(arg0_7)
				return Dorm3dCameraAnim.New({
					configId = arg0_7
				})
			end)

			arg0_1.shipArAnimationDic[var1_1] = var3_1
		end
	end
end

function var0_0.bindConfigTable(arg0_8)
	return pg.dorm3d_rooms
end

function var0_0.getDownloadNameList(arg0_9)
	local var0_9 = DormGroupConst.GetDownloadResourceDic()
	local var1_9 = string.lower(arg0_9:getConfig("resource_name"))
	local var2_9 = {}

	switch(arg0_9:getConfig("type"), {
		function()
			var2_9 = {
				"room_" .. var1_9,
				"common"
			}
		end,
		function()
			var2_9 = {
				"room_" .. var1_9,
				"apartment_" .. var1_9,
				"common"
			}
		end
	}, function()
		assert(false, "without room type:" .. arg0_9:getConfig("type"))
	end)

	local var3_9 = {}

	for iter0_9, iter1_9 in ipairs(var2_9) do
		table.insertto(var3_9, var0_9[iter1_9] or {})
	end

	return var3_9
end

function var0_0.needDownload(arg0_13)
	return #arg0_13:getDownloadNameList() > 0
end

function var0_0.getDownloadNeedSize(arg0_14)
	local var0_14, var1_14 = DormGroupConst.CalcDormListSize(arg0_14:getDownloadNameList())

	return var0_14, var1_14
end

function var0_0.getState(arg0_15)
	if DormGroupConst.DormDownloadLock and DormGroupConst.DormDownloadLock.roomId == arg0_15.configId then
		return "loading"
	elseif arg0_15:needDownload() then
		return "download"
	else
		return "complete"
	end
end

function var0_0.isPersonalRoom(arg0_16)
	return arg0_16:getConfig("type") == 2
end

function var0_0.getPersonalGroupId(arg0_17)
	assert(arg0_17:isPersonalRoom())

	return arg0_17:getConfig("character")[1]
end

function var0_0.getInviteList(arg0_18)
	return table.mergeArray(arg0_18:getConfig("character"), arg0_18:getConfig("character_pay"))
end

function var0_0.getInteractRange(arg0_19)
	local var0_19, var1_19 = unpack(arg0_19:getConfig("character_range"))

	var1_19 = var1_19 or var0_19

	return var0_19, var1_19
end

function var0_0.getRoomName(arg0_20)
	return arg0_20:getConfig("room")
end

function var0_0.GetZoneIDList(arg0_21)
	return pg.dorm3d_zone_template.get_id_list_by_room_id[arg0_21.configId] or {}
end

function var0_0.GetSlotIDList(arg0_22)
	return pg.dorm3d_furniture_slot_template.get_id_list_by_room_id[arg0_22.configId] or {}
end

function var0_0.GetFurnitureZoneIDList(arg0_23)
	return arg0_23:getConfig("furniture_zones")
end

function var0_0.GetCameraZoneIDList(arg0_24)
	return pg.dorm3d_camera_zone_template.get_id_list_by_room_id[arg0_24.configId] or {}
end

function var0_0.GetZones(arg0_25)
	return underscore(arg0_25.zoneDic):chain():values():sort(CompareFuncs({
		function(arg0_26)
			return arg0_26.configId
		end
	})):value()
end

function var0_0.GetFurnitureZones(arg0_27)
	local var0_27 = arg0_27:GetFurnitureZoneIDList()

	return underscore.map(var0_27, function(arg0_28)
		return (table.Find(arg0_27.zoneDic, function(arg0_29, arg1_29)
			return arg1_29:GetConfigID() == arg0_28
		end))
	end)
end

function var0_0.GetCameraZones(arg0_30)
	return arg0_30.cameraZones
end

function var0_0.GetSlots(arg0_31)
	return underscore(arg0_31.slotDic):chain():values():sort(CompareFuncs({
		function(arg0_32)
			return arg0_32.configId
		end
	})):value()
end

function var0_0.GetFurnitureIDList(arg0_33)
	return pg.dorm3d_furniture_template.get_id_list_by_room_id[arg0_33.configId]
end

function var0_0.GetFurnitures(arg0_34)
	return arg0_34.furnitures
end

function var0_0.HasFurniture(arg0_35, arg1_35)
	return _.any(arg0_35.furnitures, function(arg0_36)
		return arg0_36:GetConfigID() == arg1_35
	end)
end

function var0_0.AddFurnitureByID(arg0_37, arg1_37)
	table.insert(arg0_37.furnitures, Dorm3dFurniture.New({
		configId = arg1_37
	}))
end

function var0_0.ReplaceFurnitures(arg0_38, arg1_38)
	_.each(arg1_38, function(arg0_39)
		arg0_38:ReplaceFurniture(arg0_39.slotId, arg0_39.furnitureId)
	end)
	arg0_38:UpdateFurnitureReplaceConfig()
end

function var0_0.ReplaceFurniture(arg0_40, arg1_40, arg2_40)
	if arg1_40 > 0 then
		local var0_40 = _.detect(arg0_40.furnitures, function(arg0_41)
			return arg0_41:GetSlotID() == arg1_40
		end)

		if var0_40 then
			var0_40:SetSlotID(0)
		end
	end

	if arg2_40 > 0 then
		local var1_40 = _.detect(arg0_40.furnitures, function(arg0_42)
			return arg0_42:GetConfigID() == arg2_40 and arg0_42:GetSlotID() == 0
		end)

		if var1_40 then
			var1_40:SetSlotID(arg1_40)
		end
	end
end

function var0_0.IsFurnitureSetIn(arg0_43, arg1_43)
	for iter0_43, iter1_43 in ipairs(arg0_43.furnitures) do
		if iter1_43:GetConfigID() == arg1_43 and iter1_43.slotId > 0 then
			return true
		end
	end

	return false
end

function var0_0.UpdateFurnitureReplaceConfig(arg0_44)
	local var0_44 = {}

	for iter0_44, iter1_44 in ipairs(arg0_44.furnitures) do
		if iter1_44.slotId ~= 0 then
			var0_44[iter1_44.slotId] = iter1_44
		end
	end

	for iter2_44, iter3_44 in pairs(arg0_44.zoneDic) do
		if iter2_44 ~= "" then
			for iter4_44, iter5_44 in ipairs(iter3_44:GetSlots()) do
				local var1_44 = var0_44[iter5_44.configId]

				if var1_44 and var1_44:getConfig("touch_id") ~= "" then
					arg0_44.zoneReplaceDic[iter2_44].touch_id = var1_44:getConfig("touch_id")
				end
			end
		end
	end
end

var0_0.ITEM_LOCK = 0
var0_0.ITEM_UNLOCK = 1
var0_0.ITEM_ACTIVE = 2
var0_0.ITEM_FIRST = 3

function var0_0.getTriggerableCollectItemDic(arg0_45, arg1_45)
	local var0_45 = {}

	for iter0_45, iter1_45 in ipairs(pg.dorm3d_collection_template.get_id_list_by_room_id[arg0_45.configId] or {}) do
		local var1_45 = pg.dorm3d_collection_template[iter1_45]

		if var1_45.time ~= 0 and var1_45.time ~= arg1_45 or not ApartmentProxy.CheckUnlockConfig(var1_45.unlock) then
			var0_45[iter1_45] = var0_0.ITEM_LOCK
		elseif arg0_45.collectItemDic[iter1_45] then
			var0_45[iter1_45] = var0_0.ITEM_ACTIVE
		else
			var0_45[iter1_45] = var0_0.ITEM_FIRST
		end
	end

	return var0_45
end

function var0_0.getNormalZoneNames(arg0_46)
	return underscore(arg0_46.zoneDic):chain():values():select(function(arg0_47)
		return not arg0_47:IsGlobal()
	end):map(function(arg0_48)
		return arg0_48:GetWatchCameraName()
	end):value()
end

function var0_0.getZoneConfig(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg0_49.zoneDic[arg1_49]

	return arg0_49.zoneReplaceDic[arg1_49][arg2_49] or var0_49:getConfig(arg2_49)
end

function var0_0.getApartmentZoneConfig(arg0_50, arg1_50, arg2_50, arg3_50)
	return Apartment.getGroupConfig(arg3_50, arg0_50:getZoneConfig(arg1_50, arg2_50))
end

function var0_0.getAllARAnimationListByShip(arg0_51, arg1_51)
	return arg0_51.shipArAnimationDic[arg1_51]
end

function var0_0.getMiniGames(arg0_52)
	return underscore.rest(pg.dorm3d_minigame.get_id_list_by_room_id[arg0_52.configId] or {}, 1)
end

function var0_0.unlockAllInvite(arg0_53)
	for iter0_53, iter1_53 in ipairs(arg0_53:getConfig("character_pay")) do
		if not arg0_53.unlockCharacter[iter1_53] then
			return false
		end
	end

	return true
end

return var0_0
