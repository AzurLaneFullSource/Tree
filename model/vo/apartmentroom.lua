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
	local var0_9 = arg0_9:getConfig("type")

	if var0_9 == 1 then
		return {}, DormGroupConst.GetDownloadResourceDic().common or {}
	elseif var0_9 == 2 then
		local var1_9 = DormGroupConst.GetDownloadResourceDic()

		return var1_9[arg0_9:getConfig("resource_name")] or {}, var1_9.common or {}
	else
		assert(false)
	end
end

function var0_0.needDownload(arg0_10)
	local var0_10, var1_10 = arg0_10:getDownloadNameList()

	return #var0_10 > 0 or #var1_10 > 0
end

function var0_0.getDownloadNeedSize(arg0_11)
	local var0_11, var1_11 = arg0_11:getDownloadNameList()
	local var2_11 = table.mergeArray(var0_11, var1_11)
	local var3_11, var4_11 = DormGroupConst.CalcDormListSize(var2_11)

	return var0_11, var1_11
end

function var0_0.getState(arg0_12)
	if DormGroupConst.DormDownloadLock and DormGroupConst.DormDownloadLock.roomId == arg0_12.configId then
		return "loading"
	elseif arg0_12:needDownload() then
		return "download"
	else
		return "complete"
	end
end

function var0_0.isPersonalRoom(arg0_13)
	return arg0_13:getConfig("type") == 2
end

function var0_0.getPersonalGroupId(arg0_14)
	assert(arg0_14:isPersonalRoom())

	return arg0_14:getConfig("character")[1]
end

function var0_0.getInviteList(arg0_15)
	return table.mergeArray(arg0_15:getConfig("character"), arg0_15:getConfig("character_pay"))
end

function var0_0.getInteractRange(arg0_16)
	local var0_16, var1_16 = unpack(arg0_16:getConfig("character_range"))

	var1_16 = var1_16 or var0_16

	return var0_16, var1_16
end

function var0_0.getRoomName(arg0_17)
	return arg0_17:getConfig("room")
end

function var0_0.GetZoneIDList(arg0_18)
	return pg.dorm3d_zone_template.get_id_list_by_room_id[arg0_18.configId] or {}
end

function var0_0.GetSlotIDList(arg0_19)
	return pg.dorm3d_furniture_slot_template.get_id_list_by_room_id[arg0_19.configId] or {}
end

function var0_0.GetFurnitureZoneIDList(arg0_20)
	return arg0_20:getConfig("furniture_zones")
end

function var0_0.GetCameraZoneIDList(arg0_21)
	return pg.dorm3d_camera_zone_template.get_id_list_by_room_id[arg0_21.configId] or {}
end

function var0_0.GetZones(arg0_22)
	return underscore(arg0_22.zoneDic):chain():values():sort(CompareFuncs({
		function(arg0_23)
			return arg0_23.configId
		end
	})):value()
end

function var0_0.GetFurnitureZones(arg0_24)
	local var0_24 = arg0_24:GetFurnitureZoneIDList()

	return underscore.map(var0_24, function(arg0_25)
		return (table.Find(arg0_24.zoneDic, function(arg0_26, arg1_26)
			return arg1_26:GetConfigID() == arg0_25
		end))
	end)
end

function var0_0.GetCameraZones(arg0_27)
	return arg0_27.cameraZones
end

function var0_0.GetSlots(arg0_28)
	return underscore(arg0_28.slotDic):chain():values():sort(CompareFuncs({
		function(arg0_29)
			return arg0_29.configId
		end
	})):value()
end

function var0_0.GetFurnitureIDList(arg0_30)
	return pg.dorm3d_furniture_template.get_id_list_by_room_id[arg0_30.configId]
end

function var0_0.GetFurnitures(arg0_31)
	return arg0_31.furnitures
end

function var0_0.AddFurnitureByID(arg0_32, arg1_32)
	table.insert(arg0_32.furnitures, Dorm3dFurniture.New({
		configId = arg1_32
	}))
end

function var0_0.ReplaceFurnitures(arg0_33, arg1_33)
	_.each(arg1_33, function(arg0_34)
		arg0_33:ReplaceFurniture(arg0_34.slotId, arg0_34.furnitureId)
	end)
	arg0_33:UpdateFurnitureReplaceConfig()
end

function var0_0.ReplaceFurniture(arg0_35, arg1_35, arg2_35)
	if arg1_35 > 0 then
		local var0_35 = _.detect(arg0_35.furnitures, function(arg0_36)
			return arg0_36:GetSlotID() == arg1_35
		end)

		if var0_35 then
			var0_35:SetSlotID(0)
		end
	end

	if arg2_35 > 0 then
		local var1_35 = _.detect(arg0_35.furnitures, function(arg0_37)
			return arg0_37:GetConfigID() == arg2_35 and arg0_37:GetSlotID() == 0
		end)

		if var1_35 then
			var1_35:SetSlotID(arg1_35)
		end
	end
end

function var0_0.IsFurnitureSetIn(arg0_38, arg1_38)
	for iter0_38, iter1_38 in ipairs(arg0_38.furnitures) do
		if iter1_38:GetConfigID() == arg1_38 and iter1_38.slotId > 0 then
			return true
		end
	end

	return false
end

function var0_0.UpdateFurnitureReplaceConfig(arg0_39)
	local var0_39 = {}

	for iter0_39, iter1_39 in ipairs(arg0_39.furnitures) do
		if iter1_39.slotId ~= 0 then
			var0_39[iter1_39.slotId] = iter1_39
		end
	end

	for iter2_39, iter3_39 in pairs(arg0_39.zoneDic) do
		if iter2_39 ~= "" then
			for iter4_39, iter5_39 in ipairs(iter3_39:GetSlots()) do
				local var1_39 = var0_39[iter5_39.configId]

				if var1_39 and var1_39:getConfig("touch_id") ~= "" then
					arg0_39.zoneReplaceDic[iter2_39].touch_id = var1_39:getConfig("touch_id")
				end
			end
		end
	end
end

var0_0.ITEM_LOCK = 0
var0_0.ITEM_UNLOCK = 1
var0_0.ITEM_ACTIVE = 2
var0_0.ITEM_FIRST = 3

function var0_0.getTriggerableCollectItemDic(arg0_40, arg1_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in ipairs(pg.dorm3d_collection_template.get_id_list_by_room_id[arg0_40.configId] or {}) do
		local var1_40 = pg.dorm3d_collection_template[iter1_40]

		if var1_40.time ~= 0 and var1_40.time ~= arg1_40 or not ApartmentProxy.CheckUnlockConfig(var1_40.unlock) then
			var0_40[iter1_40] = var0_0.ITEM_LOCK
		elseif arg0_40.collectItemDic[iter1_40] then
			var0_40[iter1_40] = var0_0.ITEM_ACTIVE
		else
			var0_40[iter1_40] = var0_0.ITEM_FIRST
		end
	end

	return var0_40
end

function var0_0.getNormalZoneNames(arg0_41)
	return underscore(arg0_41.zoneDic):chain():values():select(function(arg0_42)
		return not arg0_42:IsGlobal()
	end):map(function(arg0_43)
		return arg0_43:GetWatchCameraName()
	end):value()
end

function var0_0.getZoneConfig(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44.zoneDic[arg1_44]

	return arg0_44.zoneReplaceDic[arg1_44][arg2_44] or var0_44:getConfig(arg2_44)
end

function var0_0.getApartmentZoneConfig(arg0_45, arg1_45, arg2_45, arg3_45)
	return Apartment.getGroupConfig(arg3_45, arg0_45:getZoneConfig(arg1_45, arg2_45))
end

function var0_0.getAllARAnimationListByShip(arg0_46, arg1_46)
	return arg0_46.shipArAnimationDic[arg1_46]
end

return var0_0
