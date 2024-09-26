local var0_0 = class("Apartment", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.ship_group
	arg0_1.level = arg1_1.favor_lv
	arg0_1.favor = arg1_1.favor_exp
	arg0_1.daily = arg1_1.daily_favor
	arg0_1.skinId = arg1_1.cur_skin
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

function var0_0.getTalkingList(arg0_16, arg1_16)
	return underscore.filter(pg.dorm3d_dialogue_group.get_id_list_by_char_id[arg0_16.configId], function(arg0_17)
		local var0_17 = pg.dorm3d_dialogue_group[arg0_17]

		return (not arg1_16.typeDic or tobool(arg1_16.typeDic[var0_17.type])) and (not arg1_16.roomId or var0_17.room_id == 0 or arg1_16.roomId == var0_17.room_id) and (not arg1_16.unplay or not arg0_16.talkDic[arg0_17]) and (not arg1_16.unlock or ApartmentProxy.CheckUnlockConfig(var0_17.unlock))
	end)
end

function var0_0.getForceEnterTalking(arg0_18, arg1_18)
	return arg0_18:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[100] = true
		},
		roomId = arg1_18
	})
end

var0_0.ENTER_TALK_TYPE_DIC = {
	[101] = function(arg0_19, arg1_19)
		return PlayerPrefs.GetString("DORM3D_DAILY_ENTER", "") ~= pg.TimeMgr.GetInstance():CurrentSTimeDesc("%Y/%m/%d")
	end,
	[102] = function(arg0_20, arg1_20)
		return underscore.any(arg0_20, function(arg0_21)
			return getProxy(ActivityProxy):IsActivityNotEnd(arg0_21)
		end)
	end,
	[103] = function(arg0_22, arg1_22)
		return PlayerPrefs.GetInt("dorm3d_enter_count_" .. arg1_22, 0) > arg0_22[1]
	end,
	[104] = function(arg0_23, arg1_23)
		return true
	end
}

function var0_0.getEnterTalking(arg0_24, arg1_24)
	local var0_24

	for iter0_24, iter1_24 in ipairs(arg0_24:getTalkingList({
		unlock = true,
		typeDic = var0_0.ENTER_TALK_TYPE_DIC,
		roomId = arg1_24
	})) do
		local var1_24 = pg.dorm3d_dialogue_group[iter1_24]

		if switch(var1_24.type, var0_0.ENTER_TALK_TYPE_DIC, function(arg0_25)
			return false
		end, var1_24.trigger_config, arg0_24.configId) then
			if not var0_24 or var1_24.type < pg.dorm3d_dialogue_group[var0_24[1]].type then
				var0_24 = {
					iter1_24
				}
			elseif var1_24.type == pg.dorm3d_dialogue_group[var0_24[1]].type then
				table.insert(var0_24, iter1_24)
			end
		end
	end

	return var0_24 or {}
end

function var0_0.getFurnitureTalking(arg0_26, arg1_26, arg2_26)
	return underscore.filter(arg0_26:getTalkingList({
		unlock = true,
		typeDic = {
			[200] = true
		},
		roomId = arg1_26
	}), function(arg0_27)
		local var0_27 = pg.dorm3d_dialogue_group[arg0_27]

		return var0_27.trigger_config == "" or var0_27.trigger_config == arg2_26
	end)
end

function var0_0.getZoneTalking(arg0_28, arg1_28, arg2_28)
	return underscore.filter(arg0_28:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[300] = true
		},
		roomId = arg1_28
	}), function(arg0_29)
		return pg.dorm3d_dialogue_group[arg0_29].trigger_config == arg2_28
	end)
end

function var0_0.getDistanceTalking(arg0_30, arg1_30, arg2_30)
	return underscore.filter(arg0_30:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[550] = true
		},
		roomId = arg1_30
	}), function(arg0_31)
		return pg.dorm3d_dialogue_group[arg0_31].trigger_config == arg2_30
	end)
end

function var0_0.getSpecialTalking(arg0_32, arg1_32)
	return arg0_32:getTalkingList({
		unlock = true,
		unplay = true,
		typeDic = {
			[700] = true
		},
		roomId = arg1_32
	})
end

function var0_0.getGiftIds(arg0_33)
	local var0_33 = pg.dorm3d_gift.get_id_list_by_ship_group_id

	return table.mergeArray(var0_33[0], var0_33[arg0_33.configId] or {})
end

function var0_0.needDownload(arg0_34)
	local var0_34, var1_34 = ApartmentRoom.New({
		id = arg0_34:getConfig("bind_room")
	}):getDownloadNameList()

	return #var0_34 > 0 or #var1_34 > 0
end

function var0_0.filterUnlockTalkList(arg0_35, arg1_35)
	return underscore.filter(arg1_35, function(arg0_36)
		return ApartmentProxy.CheckUnlockConfig(pg.dorm3d_dialogue_group[arg0_36].unlock)
	end)
end

function var0_0.getIconTip(arg0_37, arg1_37)
	if #arg0_37:getForceEnterTalking(arg1_37) > 0 then
		return "main"
	elseif getProxy(ApartmentProxy):getApartmentGiftCount(arg0_37.configId) then
		return "gift"
	elseif false then
		return "furnitrue"
	elseif false then
		return "talk"
	else
		return nil
	end
end

function var0_0.getGroupConfig(arg0_38, arg1_38)
	if not arg1_38 or arg1_38 == "" then
		return nil
	end

	for iter0_38, iter1_38 in ipairs(arg1_38) do
		if iter1_38[1] == arg0_38 then
			return iter1_38[2]
		end
	end

	return nil
end

return var0_0
