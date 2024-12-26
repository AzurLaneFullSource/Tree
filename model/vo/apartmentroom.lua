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

function var0_0.AddFurnitureByID(arg0_35, arg1_35)
	table.insert(arg0_35.furnitures, Dorm3dFurniture.New({
		configId = arg1_35
	}))
end

function var0_0.ReplaceFurnitures(arg0_36, arg1_36)
	_.each(arg1_36, function(arg0_37)
		arg0_36:ReplaceFurniture(arg0_37.slotId, arg0_37.furnitureId)
	end)
	arg0_36:UpdateFurnitureReplaceConfig()
end

function var0_0.ReplaceFurniture(arg0_38, arg1_38, arg2_38)
	if arg1_38 > 0 then
		local var0_38 = _.detect(arg0_38.furnitures, function(arg0_39)
			return arg0_39:GetSlotID() == arg1_38
		end)

		if var0_38 then
			var0_38:SetSlotID(0)
		end
	end

	if arg2_38 > 0 then
		local var1_38 = _.detect(arg0_38.furnitures, function(arg0_40)
			return arg0_40:GetConfigID() == arg2_38 and arg0_40:GetSlotID() == 0
		end)

		if var1_38 then
			var1_38:SetSlotID(arg1_38)
		end
	end
end

function var0_0.IsFurnitureSetIn(arg0_41, arg1_41)
	for iter0_41, iter1_41 in ipairs(arg0_41.furnitures) do
		if iter1_41:GetConfigID() == arg1_41 and iter1_41.slotId > 0 then
			return true
		end
	end

	return false
end

function var0_0.UpdateFurnitureReplaceConfig(arg0_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in ipairs(arg0_42.furnitures) do
		if iter1_42.slotId ~= 0 then
			var0_42[iter1_42.slotId] = iter1_42
		end
	end

	for iter2_42, iter3_42 in pairs(arg0_42.zoneDic) do
		if iter2_42 ~= "" then
			for iter4_42, iter5_42 in ipairs(iter3_42:GetSlots()) do
				local var1_42 = var0_42[iter5_42.configId]

				if var1_42 and var1_42:getConfig("touch_id") ~= "" then
					arg0_42.zoneReplaceDic[iter2_42].touch_id = var1_42:getConfig("touch_id")
				end
			end
		end
	end
end

var0_0.ITEM_LOCK = 0
var0_0.ITEM_UNLOCK = 1
var0_0.ITEM_ACTIVE = 2
var0_0.ITEM_FIRST = 3

function var0_0.getTriggerableCollectItemDic(arg0_43, arg1_43)
	local var0_43 = {}

	for iter0_43, iter1_43 in ipairs(pg.dorm3d_collection_template.get_id_list_by_room_id[arg0_43.configId] or {}) do
		local var1_43 = pg.dorm3d_collection_template[iter1_43]

		if var1_43.time ~= 0 and var1_43.time ~= arg1_43 or not ApartmentProxy.CheckUnlockConfig(var1_43.unlock) then
			var0_43[iter1_43] = var0_0.ITEM_LOCK
		elseif arg0_43.collectItemDic[iter1_43] then
			var0_43[iter1_43] = var0_0.ITEM_ACTIVE
		else
			var0_43[iter1_43] = var0_0.ITEM_FIRST
		end
	end

	return var0_43
end

function var0_0.getNormalZoneNames(arg0_44)
	return underscore(arg0_44.zoneDic):chain():values():select(function(arg0_45)
		return not arg0_45:IsGlobal()
	end):map(function(arg0_46)
		return arg0_46:GetWatchCameraName()
	end):value()
end

function var0_0.getZoneConfig(arg0_47, arg1_47, arg2_47)
	local var0_47 = arg0_47.zoneDic[arg1_47]

	return arg0_47.zoneReplaceDic[arg1_47][arg2_47] or var0_47:getConfig(arg2_47)
end

function var0_0.getApartmentZoneConfig(arg0_48, arg1_48, arg2_48, arg3_48)
	return Apartment.getGroupConfig(arg3_48, arg0_48:getZoneConfig(arg1_48, arg2_48))
end

function var0_0.getAllARAnimationListByShip(arg0_49, arg1_49)
	return arg0_49.shipArAnimationDic[arg1_49]
end

function var0_0.getMiniGames(arg0_50)
	return underscore.rest(pg.dorm3d_minigame.get_id_list_by_room_id[arg0_50.configId] or {}, 1)
end

return var0_0
