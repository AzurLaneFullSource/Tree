local var0_0 = class("Apartment", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.ship_group
	arg0_1.level = arg1_1.favor_lv
	arg0_1.favor = arg1_1.favor_exp
	arg0_1.daily = arg1_1.daily_favor
	arg0_1.skinId = arg1_1.cur_skin
	arg0_1.callName = arg1_1.name
	arg0_1.setCallCd = arg1_1.name_cd
	arg0_1.setCallTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
	arg0_1.visitTime = arg1_1.visit_time
	arg0_1.skinList = {}
	arg0_1.hiddenInfo = {}

	table.insert(arg0_1.skinList, arg0_1:getConfig("skin_model"))

	for iter0_1, iter1_1 in ipairs(arg1_1.skins or {}) do
		table.insert(arg0_1.skinList, iter1_1)
	end

	for iter2_1, iter3_1 in ipairs(arg1_1.hidden_parts or {}) do
		table.insert(arg0_1.hiddenInfo, {
			skin_id = iter3_1.id,
			hidden_parts = {}
		})

		for iter4_1, iter5_1 in ipairs(iter3_1.hidden_parts or {}) do
			table.insert(arg0_1.hiddenInfo[#arg0_1.hiddenInfo].hidden_parts, iter5_1)
		end
	end

	table.sort(arg0_1.skinList)

	arg0_1.triggerCountDic = setmetatable({}, {
		__index = function(arg0_2, arg1_2)
			return 0
		end
	})

	for iter6_1, iter7_1 in ipairs(arg1_1.regular_trigger or {}) do
		arg0_1.triggerCountDic[iter7_1] = arg0_1.triggerCountDic[iter7_1] + 1
	end

	arg0_1.talkDic = {}

	for iter8_1, iter9_1 in ipairs(arg1_1.dialogues or {}) do
		arg0_1.talkDic[iter9_1] = true
	end
end

function var0_0.bindConfigTable(arg0_3)
	return pg.dorm3d_dorm_template
end

function var0_0.getFavorConfig(arg0_4, arg1_4, arg2_4)
	arg2_4 = arg2_4 or arg0_4.level

	local var0_4 = pg.dorm3d_favor.get_id_list_by_char_id[arg0_4.configId]

	return pg.dorm3d_favor[var0_4[arg2_4]][arg1_4]
end

function var0_0.getFavor(arg0_5)
	return arg0_5.favor, arg0_5:getNextFavor()
end

function var0_0.getNextFavor(arg0_6)
	if arg0_6.level < getDorm3dGameset("favor_level")[1] then
		return arg0_6:getFavorConfig("favor_exp", arg0_6.level + 1)
	else
		return 2147483647
	end
end

function var0_0.getMaxFavor(arg0_7)
	local var0_7 = 0

	for iter0_7 = arg0_7.level + 1, getDorm3dGameset("favor_level")[1] do
		var0_7 = var0_7 + arg0_7:getFavorConfig("favor_exp", iter0_7)
	end

	return var0_7
end

function var0_0.isMaxFavor(arg0_8)
	return arg0_8.level >= getDorm3dGameset("favor_level")[1] or arg0_8.favor >= arg0_8:getMaxFavor()
end

function var0_0.getLevel(arg0_9)
	return arg0_9.level, getDorm3dGameset("favor_level")[1]
end

function var0_0.canLevelUp(arg0_10)
	return arg0_10.level < getDorm3dGameset("favor_level")[1] and arg0_10.favor >= arg0_10:getNextFavor()
end

function var0_0.addLevel(arg0_11)
	assert(arg0_11:canLevelUp())

	arg0_11.favor = arg0_11.favor - arg0_11:getNextFavor()
	arg0_11.level = arg0_11.level + 1
end

function var0_0.addSkin(arg0_12, arg1_12)
	table.insert(arg0_12.skinList, arg1_12)
	table.sort(arg0_12.skinList)
end

function var0_0.GetCurSkinId(arg0_13)
	if arg0_13.skinId == 0 then
		return arg0_13:getConfig("skin_model")
	else
		return arg0_13.skinId
	end
end

function var0_0.GetSkinModelID(arg0_14, arg1_14)
	local var0_14 = arg0_14:getConfig("skin_model")

	if arg1_14 and arg1_14 ~= "" then
		var0_14 = underscore.detect(pg.dorm3d_resource.get_id_list_by_ship_group[arg0_14.configId] or {}, function(arg0_15)
			return table.contains(pg.dorm3d_resource[arg0_15].tags, arg1_14)
		end)
	end

	return var0_14
end

function var0_0.GetCallName(arg0_16)
	return arg0_16.callName and #arg0_16.callName > 0 and arg0_16.callName or pg.dorm3d_dorm_template[arg0_16.configId].default_appellation
end

function var0_0.GetSetCallCd(arg0_17)
	if not arg0_17.setCallCd or pg.TimeMgr.GetInstance():GetServerTime() >= arg0_17.setCallCd then
		return 0
	end

	return arg0_17.setCallCd - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetHiddenParts(arg0_18, arg1_18)
	local var0_18 = underscore.detect(arg0_18.hiddenInfo, function(arg0_19)
		return arg0_19.skin_id == arg1_18
	end)

	if not var0_18 then
		if PlayerPrefs.GetInt(var0_0.GetSetSkinKey(arg1_18), 0) == 0 then
			return arg0_18:GetDefaultHiddenParts(arg1_18)
		end

		return {}
	end

	return var0_18.hidden_parts or {}
end

function var0_0.GetSetSkinKey(arg0_20)
	return "dorm3d_apartment_set_skin_" .. arg0_20 .. "_" .. getProxy(PlayerProxy):getRawData().id
end

function var0_0.GetDefaultHiddenParts(arg0_21, arg1_21)
	return pg.dorm3d_default_hidden_part.get_id_list_by_skin_id[arg1_21] or {}
end

function var0_0.SetHiddenParts(arg0_22, arg1_22, arg2_22)
	PlayerPrefs.SetInt(var0_0.GetSetSkinKey(arg1_22), 1)

	local var0_22 = underscore.detect(arg0_22.hiddenInfo, function(arg0_23)
		return arg0_23.skin_id == arg1_22
	end)

	if not var0_22 then
		table.insert(arg0_22.hiddenInfo, {
			skin_id = arg1_22,
			hidden_parts = arg2_22
		})
	else
		var0_22.hidden_parts = arg2_22
	end
end

function var0_0.getTalkingList(arg0_24, arg1_24)
	return underscore.filter(pg.dorm3d_dialogue_group.get_id_list_by_char_id[arg0_24.configId] or {}, function(arg0_25)
		local var0_25 = pg.dorm3d_dialogue_group[arg0_25]

		return (not arg1_24.typeDic or tobool(arg1_24.typeDic[var0_25.type])) and (not arg1_24.roomId or var0_25.room_id == 0 or arg1_24.roomId == var0_25.room_id) and (not arg1_24.unplay or not arg0_24.talkDic[arg0_25]) and (not arg1_24.unlock or ApartmentProxy.CheckUnlockConfig(var0_25.unlock))
	end)
end

function var0_0.getForceEnterTalking(arg0_26, arg1_26)
	if DORM_LOCK_GUIDE then
		return {}
	end

	return arg0_26:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[100] = true
		},
		roomId = arg1_26
	})
end

var0_0.ENTER_TALK_TYPE_DIC = {
	[101] = function(arg0_27, arg1_27)
		return PlayerPrefs.GetString("DORM3D_DAILY_ENTER", "") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")
	end,
	[102] = function(arg0_28, arg1_28)
		return underscore.any(arg0_28, function(arg0_29)
			return getProxy(ActivityProxy):IsActivityNotEnd(arg0_29)
		end)
	end,
	[103] = function(arg0_30, arg1_30)
		return PlayerPrefs.GetInt("dorm3d_enter_count_" .. arg1_30, 0) > arg0_30[1]
	end,
	[104] = function(arg0_31, arg1_31)
		return true
	end
}

function var0_0.getEnterTalking(arg0_32, arg1_32)
	local var0_32

	for iter0_32, iter1_32 in ipairs(arg0_32:getTalkingList({
		unlock = true,
		typeDic = var0_0.ENTER_TALK_TYPE_DIC,
		roomId = arg1_32
	})) do
		local var1_32 = pg.dorm3d_dialogue_group[iter1_32]

		if switch(var1_32.type, var0_0.ENTER_TALK_TYPE_DIC, function(arg0_33)
			return false
		end, var1_32.trigger_config, arg0_32.configId) then
			if not var0_32 or var1_32.type < pg.dorm3d_dialogue_group[var0_32[1]].type then
				var0_32 = {
					iter1_32
				}
			elseif var1_32.type == pg.dorm3d_dialogue_group[var0_32[1]].type then
				table.insert(var0_32, iter1_32)
			end
		end
	end

	return var0_32 or {}
end

function var0_0.getFurnitureTalking(arg0_34, arg1_34, arg2_34)
	return underscore.filter(arg0_34:getTalkingList({
		unlock = true,
		typeDic = {
			[200] = true
		},
		roomId = arg1_34
	}), function(arg0_35)
		local var0_35 = pg.dorm3d_dialogue_group[arg0_35]

		return var0_35.trigger_config == "" or var0_35.trigger_config == arg2_34
	end)
end

function var0_0.getZoneTalking(arg0_36, arg1_36, arg2_36)
	return underscore.filter(arg0_36:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[300] = true
		},
		roomId = arg1_36
	}), function(arg0_37)
		return pg.dorm3d_dialogue_group[arg0_37].trigger_config == arg2_36
	end)
end

function var0_0.getDistanceTalking(arg0_38, arg1_38, arg2_38)
	return underscore.filter(arg0_38:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[550] = true
		},
		roomId = arg1_38
	}), function(arg0_39)
		return pg.dorm3d_dialogue_group[arg0_39].trigger_config == arg2_38
	end)
end

function var0_0.getSpecialTalking(arg0_40, arg1_40)
	return arg0_40:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[700] = true
		},
		roomId = arg1_40
	})
end

function var0_0.getGiftIds(arg0_41)
	local var0_41 = pg.dorm3d_gift.get_id_list_by_ship_group_id

	return table.mergeArray(var0_41[0], var0_41[arg0_41.configId] or {})
end

function var0_0.needDownload(arg0_42)
	return #ApartmentRoom.New({
		id = arg0_42:getConfig("bind_room")
	}):getDownloadNameList() > 0
end

function var0_0.filterUnlockTalkList(arg0_43, arg1_43)
	return underscore.filter(arg1_43, function(arg0_44)
		return ApartmentProxy.CheckUnlockConfig(pg.dorm3d_dialogue_group[arg0_44].unlock)
	end)
end

function var0_0.getIconTip(arg0_45, arg1_45)
	if #arg0_45:getForceEnterTalking(arg1_45) > 0 then
		return "main"
	elseif getProxy(ApartmentProxy):getApartmentGiftCount(arg0_45.configId) then
		return "gift"
	elseif Dorm3dFurniture.IsTimelimitShopTip(arg1_45) then
		return "furniture"
	elseif false then
		return "talk"
	else
		return nil
	end
end

function var0_0.getGroupConfig(arg0_46, arg1_46)
	if not arg1_46 or arg1_46 == "" then
		return nil
	end

	for iter0_46, iter1_46 in ipairs(arg1_46) do
		if iter1_46[1] == arg0_46 then
			return iter1_46[2]
		end
	end

	return nil
end

function var0_0.GetAllModelIds(arg0_47)
	return pg.dorm3d_resource.get_id_list_by_ship_group[arg0_47.configId] or {}
end

function var0_0.CheckAllCollectionTrack()
	if not getProxy(ApartmentProxy):CheckAllRoomInviteAll() then
		return
	end

	local var0_48 = 0
	local var1_48 = {}

	for iter0_48, iter1_48 in ipairs(pg.dorm3d_recall.all) do
		local var2_48 = pg.dorm3d_recall[iter1_48].story_id
		local var3_48 = pg.dorm3d_dialogue_group[var2_48].char_id

		if var1_48[var3_48] == nil then
			var1_48[var3_48] = getProxy(ApartmentProxy):getApartment(var3_48) or false
		end

		if not var1_48[var3_48] or not var1_48[var3_48].talkDic[var2_48] then
			var0_48 = -1

			break
		else
			var0_48 = var0_48 + 1
		end
	end

	if var0_48 < 0 then
		return
	end

	local var4_48 = getProxy(ApartmentProxy).shopCount

	for iter2_48, iter3_48 in ipairs(pg.dorm3d_shop_template.all) do
		local var5_48 = pg.dorm3d_shop_template[iter3_48]

		if var5_48.room_id ~= 0 then
			if var5_48.type == 2 then
				if defaultValue(var4_48.permanentGift[var5_48.item_id], 0) > 0 then
					var0_48 = var0_48 + 1
				else
					var0_48 = -1

					break
				end
			elseif var5_48.type == 1 then
				if defaultValue(var4_48.permanentFurniture[var5_48.item_id], 0) > 0 then
					var0_48 = var0_48 + 1
				else
					var0_48 = -1

					break
				end
			end
		end
	end

	local var6_48 = getProxy(PlayerProxy):getRawData().id

	if var0_48 > PlayerPrefs.GetInt("APARTMENT_ALL_COLLECTION:" .. var6_48, 0) then
		PlayerPrefs.SetInt("APARTMENT_ALL_COLLECTION:" .. var6_48, var0_48)
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAllCollection(20002, var0_48))
	end
end

return var0_0
