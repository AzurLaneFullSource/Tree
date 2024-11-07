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
	arg0_1.skinList = {}

	table.insert(arg0_1.skinList, arg0_1:getConfig("skin_model"))

	for iter0_1, iter1_1 in ipairs(arg1_1.skins or {}) do
		table.insert(arg0_1.skinList, iter1_1)
	end

	table.sort(arg0_1.skinList)

	arg0_1.triggerCountDic = setmetatable({}, {
		__index = function(arg0_2, arg1_2)
			return 0
		end
	})

	for iter2_1, iter3_1 in ipairs(arg1_1.regular_trigger or {}) do
		arg0_1.triggerCountDic[iter3_1] = arg0_1.triggerCountDic[iter3_1] + 1
	end

	arg0_1.talkDic = {}

	for iter4_1, iter5_1 in ipairs(arg1_1.dialogues or {}) do
		arg0_1.talkDic[iter5_1] = true
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

function var0_0.getSkinId(arg0_13)
	if arg0_13.skinId == 0 then
		return arg0_13:getConfig("skin_model")
	else
		return arg0_13.skinId
	end
end

function var0_0.GetSkinModelID(arg0_14, arg1_14)
	local var0_14 = arg0_14:getConfig("skin_model")

	if arg1_14 and arg1_14 ~= "" then
		var0_14 = underscore.detect(pg.dorm3d_resource.get_id_list_by_ship_group[arg0_14.configId], function(arg0_15)
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

function var0_0.getTalkingList(arg0_18, arg1_18)
	return underscore.filter(pg.dorm3d_dialogue_group.get_id_list_by_char_id[arg0_18.configId], function(arg0_19)
		local var0_19 = pg.dorm3d_dialogue_group[arg0_19]

		return (not arg1_18.typeDic or tobool(arg1_18.typeDic[var0_19.type])) and (not arg1_18.roomId or var0_19.room_id == 0 or arg1_18.roomId == var0_19.room_id) and (not arg1_18.unplay or not arg0_18.talkDic[arg0_19]) and (not arg1_18.unlock or ApartmentProxy.CheckUnlockConfig(var0_19.unlock))
	end)
end

function var0_0.getForceEnterTalking(arg0_20, arg1_20)
	return arg0_20:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[100] = true
		},
		roomId = arg1_20
	})
end

var0_0.ENTER_TALK_TYPE_DIC = {
	[101] = function(arg0_21, arg1_21)
		return PlayerPrefs.GetString("DORM3D_DAILY_ENTER", "") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")
	end,
	[102] = function(arg0_22, arg1_22)
		return underscore.any(arg0_22, function(arg0_23)
			return getProxy(ActivityProxy):IsActivityNotEnd(arg0_23)
		end)
	end,
	[103] = function(arg0_24, arg1_24)
		return PlayerPrefs.GetInt("dorm3d_enter_count_" .. arg1_24, 0) > arg0_24[1]
	end,
	[104] = function(arg0_25, arg1_25)
		return true
	end
}

function var0_0.getEnterTalking(arg0_26, arg1_26)
	local var0_26

	for iter0_26, iter1_26 in ipairs(arg0_26:getTalkingList({
		unlock = true,
		typeDic = var0_0.ENTER_TALK_TYPE_DIC,
		roomId = arg1_26
	})) do
		local var1_26 = pg.dorm3d_dialogue_group[iter1_26]

		if switch(var1_26.type, var0_0.ENTER_TALK_TYPE_DIC, function(arg0_27)
			return false
		end, var1_26.trigger_config, arg0_26.configId) then
			if not var0_26 or var1_26.type < pg.dorm3d_dialogue_group[var0_26[1]].type then
				var0_26 = {
					iter1_26
				}
			elseif var1_26.type == pg.dorm3d_dialogue_group[var0_26[1]].type then
				table.insert(var0_26, iter1_26)
			end
		end
	end

	return var0_26 or {}
end

function var0_0.getFurnitureTalking(arg0_28, arg1_28, arg2_28)
	return underscore.filter(arg0_28:getTalkingList({
		unlock = true,
		typeDic = {
			[200] = true
		},
		roomId = arg1_28
	}), function(arg0_29)
		local var0_29 = pg.dorm3d_dialogue_group[arg0_29]

		return var0_29.trigger_config == "" or var0_29.trigger_config == arg2_28
	end)
end

function var0_0.getZoneTalking(arg0_30, arg1_30, arg2_30)
	return underscore.filter(arg0_30:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[300] = true
		},
		roomId = arg1_30
	}), function(arg0_31)
		return pg.dorm3d_dialogue_group[arg0_31].trigger_config == arg2_30
	end)
end

function var0_0.getDistanceTalking(arg0_32, arg1_32, arg2_32)
	return underscore.filter(arg0_32:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[550] = true
		},
		roomId = arg1_32
	}), function(arg0_33)
		return pg.dorm3d_dialogue_group[arg0_33].trigger_config == arg2_32
	end)
end

function var0_0.getSpecialTalking(arg0_34, arg1_34)
	return arg0_34:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[700] = true
		},
		roomId = arg1_34
	})
end

function var0_0.getGiftIds(arg0_35)
	local var0_35 = pg.dorm3d_gift.get_id_list_by_ship_group_id

	return table.mergeArray(var0_35[0], var0_35[arg0_35.configId] or {})
end

function var0_0.needDownload(arg0_36)
	local var0_36, var1_36 = ApartmentRoom.New({
		id = arg0_36:getConfig("bind_room")
	}):getDownloadNameList()

	return #var0_36 > 0 or #var1_36 > 0
end

function var0_0.filterUnlockTalkList(arg0_37, arg1_37)
	return underscore.filter(arg1_37, function(arg0_38)
		return ApartmentProxy.CheckUnlockConfig(pg.dorm3d_dialogue_group[arg0_38].unlock)
	end)
end

function var0_0.getIconTip(arg0_39, arg1_39)
	if #arg0_39:getForceEnterTalking(arg1_39) > 0 then
		return "main"
	elseif getProxy(ApartmentProxy):getApartmentGiftCount(arg0_39.configId) then
		return "gift"
	elseif false then
		return "furnitrue"
	elseif false then
		return "talk"
	else
		return nil
	end
end

function var0_0.getGroupConfig(arg0_40, arg1_40)
	if not arg1_40 or arg1_40 == "" then
		return nil
	end

	for iter0_40, iter1_40 in ipairs(arg1_40) do
		if iter1_40[1] == arg0_40 then
			return iter1_40[2]
		end
	end

	return nil
end

return var0_0
