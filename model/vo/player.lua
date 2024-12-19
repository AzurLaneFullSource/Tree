local var0_0 = class("Player", import(".PlayerAttire"))
local var1_0 = pg.player_resource
local var2_0 = var1_0.get_id_list_by_name
local var3_0
local var4_0

var0_0.MAX_SHIP_BAG = 4000
var0_0.MAX_EQUIP_BAG = 2000
var0_0.MAX_COMMANDER_BAG = 200
var0_0.ASSISTS_TYPE_SHAM = 0
var0_0.ASSISTS_TYPE_GUILD = 1
var0_0.CHANGE_NAME_KEY = 1

function id2res(arg0_1)
	return var1_0[arg0_1].name
end

function res2id(arg0_2)
	return var1_0.get_id_list_by_name[arg0_2][1]
end

function id2ItemId(arg0_3)
	return var1_0[arg0_3].itemid
end

function itemId2Id(arg0_4)
	assert(false)
end

function var0_0.isMetaShipNeedToTrans(arg0_5)
	local var0_5 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0_5)

	return getProxy(BayProxy):getMetaShipByGroupId(var0_5) and true or false
end

function var0_0.metaShip2Res(arg0_6)
	local var0_6 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0_6)
	local var1_6 = getProxy(BayProxy):getMetaShipByGroupId(var0_6):getMetaCharacter():getSpecialMaterialInfoToMaxStar()
	local var2_6 = var1_6.itemID
	local var3_6 = var1_6.count <= getProxy(BagProxy):getItemCountById(var2_6)
	local var4_6

	if var3_6 then
		var4_6 = pg.ship_transform[var0_6].common_item
	else
		var4_6 = pg.ship_transform[var0_6].exclusive_item
	end

	local var5_6 = {}

	for iter0_6, iter1_6 in ipairs(var4_6) do
		local var6_6 = {
			type = iter1_6[1],
			id = iter1_6[2],
			count = iter1_6[3]
		}

		table.insert(var5_6, var6_6)
	end

	return var5_6
end

function var0_0.getSkinTicket(arg0_7)
	local var0_7 = pg.gameset.skin_ticket.key_value

	return var0_7 == 0 and 0 or arg0_7:getResource(var0_7)
end

function var0_0.Ctor(arg0_8, arg1_8)
	var0_0.super.Ctor(arg0_8, arg1_8)

	local var0_8 = arg0_8.character

	arg0_8.educateCharacter = arg1_8.child_display or 0

	if var0_8 then
		if type(var0_8) == "number" then
			arg0_8.character = var0_8
			arg0_8.characters = {
				var0_8
			}
		else
			arg0_8.character = var0_8[1]
			arg0_8.characters = var0_8
		end
	end

	arg0_8.id = arg1_8.id
	arg0_8.name = arg1_8.name
	arg0_8.level = arg1_8.level or arg1_8.lv
	arg0_8.configId = arg0_8.level
	arg0_8.exp = arg1_8.exp or 0
	arg0_8.attackCount = arg1_8.attack_count or 0
	arg0_8.winCount = arg1_8.win_count or 0
	arg0_8.manifesto = arg1_8.adv or arg1_8.manifesto
	arg0_8.shipBagMax = arg1_8.ship_bag_max
	arg0_8.equipBagMax = arg1_8.equip_bag_max
	arg0_8.buff_list = arg1_8.buffList or {}
	arg0_8.rank = arg1_8.rank or arg1_8.title or 0
	arg0_8.pvp_attack_count = arg1_8.pvp_attack_count or 0
	arg0_8.pvp_win_count = arg1_8.pvp_win_count or 0
	arg0_8.collect_attack_count = arg1_8.collect_attack_count or 0
	arg0_8.guideIndex = arg1_8.guide_index
	arg0_8.buyOilCount = arg1_8.buy_oil_count
	arg0_8.chatRoomId = arg1_8.chat_room_id or 1
	arg0_8.score = arg1_8.score or 0
	arg0_8.guildWaitTime = arg1_8.guild_wait_time or 0
	arg0_8.commanderBagMax = arg1_8.commander_bag_max
	arg0_8.displayTrophyList = arg1_8.medal_id or {}
	arg0_8.banBackyardUploadTime = arg1_8.theme_upload_not_allowed_time or 0
	arg0_8.rmb = arg1_8.rmb or 0
	arg0_8.identityFlag = arg1_8.gm_flag
	arg0_8.mailStoreLevel = arg1_8.mail_storeroom_lv

	local var1_8 = getProxy(AppreciateProxy)

	if arg1_8.appreciation then
		for iter0_8, iter1_8 in ipairs(arg1_8.appreciation.gallerys or {}) do
			var1_8:addPicIDToUnlockList(iter1_8)
		end

		for iter2_8, iter3_8 in ipairs(arg1_8.appreciation.musics or {}) do
			var1_8:addMusicIDToUnlockList(iter3_8)
		end

		for iter4_8, iter5_8 in ipairs(arg1_8.appreciation.favor_gallerys or {}) do
			var1_8:addPicIDToLikeList(iter5_8)
		end

		for iter6_8, iter7_8 in ipairs(arg1_8.appreciation.favor_musics or {}) do
			var1_8:addMusicIDToLikeList(iter7_8)
		end

		local var2_8 = getProxy(AppreciateProxy)
		local var3_8 = var2_8:getResultForVer()

		if var3_8 then
			pg.ConnectionMgr.GetInstance():Send(15300, {
				type = 0,
				ver_str = var3_8
			})
			var2_8:clearVer()
		end
	end

	if arg1_8.cartoon_read_mark then
		var1_8:initMangaReadIDList(arg1_8.cartoon_read_mark)
	end

	if arg1_8.cartoon_collect_mark then
		var1_8:initMangaLikeIDList(arg1_8.cartoon_collect_mark)
	end

	arg0_8.cdList = {}

	for iter8_8, iter9_8 in ipairs(arg1_8.cd_list or {}) do
		arg0_8.cdList[iter9_8.key] = iter9_8.timestamp
	end

	arg0_8.commonFlagList = {}

	for iter10_8, iter11_8 in ipairs(arg1_8.flag_list or {}) do
		arg0_8.commonFlagList[iter11_8] = true
	end

	arg0_8.registerTime = arg1_8.register_time
	arg0_8.vipCards = {}

	for iter12_8, iter13_8 in ipairs(arg1_8.card_list or {}) do
		local var4_8 = VipCard.New(iter13_8)

		arg0_8.vipCards[var4_8.id] = var4_8
	end

	arg0_8:updateResources(arg1_8.resource_list)

	arg0_8.maxRank = arg1_8.max_rank or 0
	arg0_8.shipCount = arg1_8.ship_count or 0
	arg0_8.chargeExp = arg1_8.acc_pay_lv or 0
	arg0_8.mingshiflag = 0
	arg0_8.mingshiCount = 0
	arg0_8.chatMsgBanTime = arg1_8.chat_msg_ban_time or 0
	arg0_8.randomShipMode = arg1_8.random_ship_mode or 0
	arg0_8.customRandomShips = {}

	for iter14_8, iter15_8 in ipairs(arg1_8.random_ship_list or {}) do
		table.insert(arg0_8.customRandomShips, iter15_8)
	end

	arg0_8.buildShipNotification = {}

	for iter16_8, iter17_8 in ipairs(arg1_8.taking_ship_list or {}) do
		table.insert(arg0_8.buildShipNotification, {
			uid = iter17_8.uid,
			new = iter17_8.isnew == 1
		})
	end

	arg0_8.proposeShipId = arg1_8.marry_ship
	arg0_8.unlockCryptolaliaList = {}

	for iter18_8, iter19_8 in ipairs(arg1_8.soundstory or {}) do
		table.insert(arg0_8.unlockCryptolaliaList, iter19_8)
	end

	arg0_8.displayInfo = arg1_8.display or {}
	arg0_8.attireInfo = {}
	arg0_8.attireInfo[AttireConst.TYPE_ICON_FRAME] = arg0_8.iconFrame
	arg0_8.attireInfo[AttireConst.TYPE_CHAT_FRAME] = arg0_8.chatFrame
	arg0_8.activityMedalGroupList = {}

	arg0_8:updateMedalList(arg1_8.activity_medals or {})
end

function var0_0.updateAttireFrame(arg0_9, arg1_9, arg2_9)
	arg0_9.attireInfo[arg1_9] = arg2_9

	if arg1_9 == AttireConst.TYPE_COMBAT_UI_STYLE then
		COMBAT_SKIN_KEY = pg.item_data_battleui[arg2_9].key
	end
end

function var0_0.getAttireByType(arg0_10, arg1_10)
	return arg0_10.attireInfo[arg1_10]
end

function var0_0.getRandomSecretary(arg0_11)
	return arg0_11.characters[math.random(#arg0_11.characters)]
end

function var0_0.canModifyName(arg0_12)
	local var0_12 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_12 = pg.gameset.player_name_change_lv_limit.key_value

	if var1_12 > arg0_12.level then
		return false, i18n("player_name_change_time_lv_tip", var1_12)
	end

	local var2_12 = arg0_12:getModifyNameTimestamp()

	if var0_12 < var2_12 then
		local var3_12, var4_12, var5_12, var6_12 = pg.TimeMgr.GetInstance():parseTimeFrom(var2_12 - var0_12)
		local var7_12

		if var3_12 == 0 then
			if var4_12 == 0 then
				var7_12 = math.max(var5_12, 1) .. i18n("word_minute")
			else
				var7_12 = var4_12 .. i18n("word_hour")
			end
		else
			var7_12 = var3_12 .. i18n("word_date")
		end

		return false, i18n("player_name_change_time_limit_tip", var7_12)
	end

	return true
end

function var0_0.getModifyNameComsume(arg0_13)
	return pg.gameset.player_name_change_cost.description
end

function var0_0.getModifyNameTimestamp(arg0_14)
	return arg0_14.cdList[var0_0.CHANGE_NAME_KEY] or 0
end

function var0_0.updateModifyNameColdTime(arg0_15, arg1_15)
	arg0_15.cdList[var0_0.CHANGE_NAME_KEY] = arg1_15
end

function var0_0.getMaxGold(arg0_16)
	return pg.gameset.max_gold.key_value
end

function var0_0.getMaxOil(arg0_17)
	return pg.gameset.max_oil.key_value
end

function var0_0.getLevelMaxGold(arg0_18)
	local var0_18 = arg0_18:getConfig("max_gold")
	local var1_18 = getProxy(GuildProxy):GetAdditionGuild()

	return var1_18 and var0_18 + var1_18:getMaxGoldAddition() or var0_18
end

function var0_0.getLevelMaxOil(arg0_19)
	local var0_19 = arg0_19:getConfig("max_oil")
	local var1_19 = getProxy(GuildProxy):GetAdditionGuild()

	return var1_19 and var0_19 + var1_19:getMaxOilAddition() or var0_19
end

function var0_0.getResource(arg0_20, arg1_20)
	return arg0_20[id2res(arg1_20)] or 0
end

function var0_0.updateResources(arg0_21, arg1_21)
	for iter0_21, iter1_21 in pairs(var2_0) do
		assert(#iter1_21 == 1, "Multiple ID have the same name : " .. iter0_21)

		local var0_21 = iter1_21[1]

		if iter0_21 == "gem" then
			arg0_21.chargeGem = 0
		elseif iter0_21 == "freeGem" then
			arg0_21.awardGem = 0
		else
			arg0_21[iter0_21] = 0
		end
	end

	for iter2_21, iter3_21 in ipairs(arg1_21 or {}) do
		local var1_21 = id2res(iter3_21.type)

		assert(var1_21, "resource type erro>>>>>" .. iter3_21.type)

		if var1_21 == "gem" then
			arg0_21.chargeGem = iter3_21.num
		elseif var1_21 == "freeGem" then
			arg0_21.awardGem = iter3_21.num
		else
			arg0_21[var1_21] = iter3_21.num
		end
	end
end

function var0_0.getPainting(arg0_22)
	local var0_22 = pg.ship_skin_template[arg0_22.skinId]

	return var0_22 and var0_22.painting or "unknown"
end

function var0_0.inGuildCDTime(arg0_23)
	return arg0_23.guildWaitTime > 0 and arg0_23.guildWaitTime > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.setGuildWaitTime(arg0_24, arg1_24)
	arg0_24.guildWaitTime = arg1_24
end

function var0_0.getChargeLevel(arg0_25)
	local var0_25 = pg.pay_level_award
	local var1_25 = var0_25.all[1]
	local var2_25 = var0_25.all[#var0_25.all]

	for iter0_25, iter1_25 in ipairs(var0_25.all) do
		if arg0_25.chargeExp >= var0_25[iter1_25].exp then
			var1_25 = math.min(iter1_25 + 1, var2_25)
		end
	end

	return var1_25
end

function var0_0.getCardById(arg0_26, arg1_26)
	return Clone(arg0_26.vipCards[arg1_26])
end

function var0_0.addVipCard(arg0_27, arg1_27)
	arg0_27.vipCards[arg1_27.id] = arg1_27
end

function var0_0.addShipBagCount(arg0_28, arg1_28)
	arg0_28.shipBagMax = arg0_28.shipBagMax + arg1_28
end

function var0_0.addEquipmentBagCount(arg0_29, arg1_29)
	arg0_29.equipBagMax = arg0_29.equipBagMax + arg1_29
end

function var0_0.bindConfigTable(arg0_30)
	return pg.user_level
end

function var0_0.updateScoreAndRank(arg0_31, arg1_31, arg2_31)
	arg0_31.score = arg1_31
	arg0_31.rank = arg2_31
end

function var0_0.increasePvpCount(arg0_32)
	arg0_32.pvp_attack_count = arg0_32.pvp_attack_count + 1
end

function var0_0.increasePvpWinCount(arg0_33)
	arg0_33.pvp_win_count = arg0_33.pvp_win_count + 1
end

function var0_0.isEnough(arg0_34, arg1_34)
	for iter0_34, iter1_34 in pairs(arg1_34) do
		if arg0_34[iter0_34] == nil or iter1_34 > arg0_34[iter0_34] then
			return false, iter0_34
		end
	end

	return true
end

function var0_0.increaseBuyOilCount(arg0_35)
	arg0_35.buyOilCount = arg0_35.buyOilCount + 1
end

function var0_0.changeChatRoom(arg0_36, arg1_36)
	arg0_36.chatRoomId = arg1_36
end

function var0_0.increaseAttackCount(arg0_37)
	arg0_37.attackCount = arg0_37.attackCount + 1
end

function var0_0.increaseAttackWinCount(arg0_38)
	arg0_38.winCount = arg0_38.winCount + 1
end

function var0_0.increaseShipCount(arg0_39, arg1_39)
	arg0_39.shipCount = arg0_39.shipCount + (arg1_39 and arg1_39 or 1)
end

function var0_0.isFull(arg0_40)
	for iter0_40, iter1_40 in pairs(var2_0) do
		local var0_40 = pg.user_level["max_" .. iter0_40]

		if var0_40 and var0_40 > arg0_40[iter0_40] then
			return false
		end
	end

	return true
end

function var0_0.getMaxEquipmentBag(arg0_41)
	local var0_41 = arg0_41.equipBagMax
	local var1_41 = 0
	local var2_41 = getProxy(GuildProxy):GetAdditionGuild()

	if var2_41 then
		var1_41 = var2_41:getEquipmentBagAddition()
	end

	return var1_41 + var0_41
end

function var0_0.getMaxShipBag(arg0_42)
	local var0_42 = arg0_42.shipBagMax
	local var1_42 = 0
	local var2_42 = getProxy(GuildProxy):GetAdditionGuild()

	if var2_42 then
		var1_42 = var2_42:getShipBagAddition()
	end

	return var1_42 + var0_42
end

function var0_0.getMaxEquipmentBagExcludeGuild(arg0_43)
	return arg0_43.equipBagMax
end

function var0_0.getMaxShipBagExcludeGuild(arg0_44)
	return arg0_44.shipBagMax
end

function var0_0.__index(arg0_45, arg1_45)
	if arg1_45 == "gem" then
		return arg0_45:getChargeGem()
	elseif arg1_45 == "freeGem" then
		return arg0_45:getTotalGem()
	elseif arg1_45 == "equipBagMax" then
		return arg0_45:getMaxEquipmentBag()
	elseif arg1_45 == "shipBagMax" then
		return arg0_45:getMaxShipBag()
	end

	local var0_45 = rawget(arg0_45, arg1_45) or var0_0[arg1_45]

	var0_45 = var0_45 or var0_0.super[arg1_45]

	return var0_45
end

function var0_0.__newindex(arg0_46, arg1_46, arg2_46)
	assert(arg1_46 ~= "gem" and arg1_46 ~= "freeGem", "Do not set gem directly.")
	rawset(arg0_46, arg1_46, arg2_46)
end

function var0_0.getFreeGem(arg0_47)
	return arg0_47.awardGem
end

function var0_0.getChargeGem(arg0_48)
	return arg0_48.chargeGem
end

function var0_0.getTotalGem(arg0_49)
	return arg0_49:getFreeGem() + arg0_49:getChargeGem()
end

function var0_0.getResById(arg0_50, arg1_50)
	if arg1_50 == 4 then
		return arg0_50:getTotalGem()
	else
		return arg0_50[id2res(arg1_50)]
	end
end

function var0_0.consume(arg0_51, arg1_51)
	local var0_51 = (arg1_51.freeGem or 0) + (arg1_51.gem or 0)

	arg1_51.freeGem = nil
	arg1_51.gem = nil

	if var0_51 > 0 then
		local var1_51 = arg0_51:getFreeGem()
		local var2_51 = math.min(var0_51, var1_51)

		arg0_51.awardGem = var1_51 - var2_51
		arg0_51.chargeGem = arg0_51.chargeGem - (var0_51 - var2_51)
	end

	for iter0_51, iter1_51 in pairs(arg1_51) do
		arg0_51[iter0_51] = arg0_51[iter0_51] - iter1_51
	end
end

function var0_0.addResources(arg0_52, arg1_52)
	for iter0_52, iter1_52 in pairs(arg1_52) do
		if iter0_52 == "gold" then
			local var0_52 = arg0_52:getMaxGold()

			arg0_52[iter0_52] = math.min(arg0_52[iter0_52] + iter1_52, var0_52)
		elseif iter0_52 == "oil" then
			local var1_52 = arg0_52:getMaxOil()

			arg0_52[iter0_52] = math.min(arg0_52[iter0_52] + iter1_52, var1_52)
		elseif iter0_52 == "gem" then
			arg0_52.chargeGem = arg0_52:getChargeGem() + iter1_52
		elseif iter0_52 == "freeGem" then
			arg0_52.awardGem = arg0_52:getFreeGem() + iter1_52
		elseif iter0_52 == id2res(WorldConst.ResourceID) then
			local var2_52 = pg.gameset.world_resource_max.key_value

			arg0_52[iter0_52] = math.min(arg0_52[iter0_52] + iter1_52, var2_52)
		elseif iter0_52 == "gameticket" then
			local var3_52 = pg.gameset.game_room_remax.key_value

			arg0_52[iter0_52] = math.min(arg0_52[iter0_52] + iter1_52, var3_52)
		else
			arg0_52[iter0_52] = arg0_52[iter0_52] + iter1_52
		end
	end
end

function var0_0.resetBuyOilCount(arg0_53)
	arg0_53.buyOilCount = 0
end

function var0_0.addExp(arg0_54, arg1_54)
	assert(arg1_54 >= 0, "exp should greater than zero")

	arg0_54.exp = arg0_54.exp + arg1_54

	while arg0_54:canLevelUp() do
		arg0_54.exp = arg0_54.exp - arg0_54:getLevelExpConfig().exp_interval
		arg0_54.level = arg0_54.level + 1

		pg.TrackerMgr.GetInstance():Tracking(TRACKING_USER_LEVELUP, arg0_54.level)

		if arg0_54.level == 30 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_USER_LEVEL_THIRTY)
		elseif arg0_54.level == 40 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_USER_LEVEL_FORTY)
		end
	end
end

function var0_0.addExpToLevel(arg0_55, arg1_55)
	local var0_55 = getConfigFromLevel1(pg.user_level, arg1_55)
	local var1_55 = arg0_55:getLevelExpConfig()

	if var1_55.exp_start + arg0_55.exp >= var0_55.exp_start then
		print("EXP Overflow, Return")

		return
	end

	arg0_55:addExp(var0_55.exp_start - var1_55.exp_start - arg0_55.exp)
end

function var0_0.GetBuffs(arg0_56)
	return arg0_56.buff_list
end

function var0_0.getLevelExpConfig(arg0_57)
	return getConfigFromLevel1(pg.user_level, arg0_57.level)
end

function var0_0.getMaxLevel(arg0_58)
	return pg.user_level.all[#pg.user_level.all]
end

function var0_0.getTotalExp(arg0_59)
	return arg0_59:getLevelExpConfig().exp_start + arg0_59.exp
end

function var0_0.canLevelUp(arg0_60)
	local var0_60 = getConfigFromLevel1(pg.user_level, arg0_60.level + 1)
	local var1_60 = arg0_60:getLevelExpConfig()

	return var0_60 and var1_60 ~= var0_60 and var1_60.exp_interval <= arg0_60.exp
end

function var0_0.isSelf(arg0_61)
	return getProxy(PlayerProxy):isSelf(arg0_61.id)
end

function var0_0.isFriend(arg0_62)
	return getProxy(FriendProxy):isFriend(arg0_62.id)
end

function var0_0.OilMax(arg0_63, arg1_63)
	arg1_63 = arg1_63 or 0

	return pg.gameset.max_oil.key_value < arg0_63.oil + arg1_63
end

function var0_0.GoldMax(arg0_64, arg1_64)
	arg1_64 = arg1_64 or 0

	return pg.gameset.max_gold.key_value < arg0_64.gold + arg1_64
end

function var0_0.ResLack(arg0_65, arg1_65, arg2_65)
	local var0_65 = pg.gameset["max_" .. arg1_65].key_value

	if var0_65 < arg0_65[arg1_65] then
		return 0
	else
		return math.min(arg2_65, var0_65 - arg0_65[arg1_65])
	end
end

function var0_0.OverStore(arg0_66, arg1_66, arg2_66)
	arg2_66 = arg2_66 or 0

	local var0_66 = id2res(arg1_66)
	local var1_66 = pg.mail_storeroom[arg0_66.mailStoreLevel]
	local var2_66 = switch(arg1_66, {
		[PlayerConst.ResStoreGold] = function()
			return var1_66.gold_store
		end,
		[PlayerConst.ResStoreOil] = function()
			return var1_66.oil_store
		end
	})

	return arg0_66[var0_66] + arg2_66 - var2_66
end

function var0_0.UpdateCommonFlag(arg0_69, arg1_69)
	arg0_69.commonFlagList[arg1_69] = true
end

function var0_0.GetCommonFlag(arg0_70, arg1_70)
	return arg0_70.commonFlagList[arg1_70]
end

function var0_0.CancelCommonFlag(arg0_71, arg1_71)
	arg0_71.commonFlagList[arg1_71] = false
end

function var0_0.SetCommonFlag(arg0_72, arg1_72, arg2_72)
	arg0_72.commonFlagList[arg1_72] = arg2_72
end

function var0_0.updateCommanderBagMax(arg0_73, arg1_73)
	arg0_73.commanderBagMax = arg0_73.commanderBagMax + arg1_73
end

function var0_0.GetDaysFromRegister(arg0_74)
	local var0_74 = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():DiffDay(arg0_74.registerTime, var0_74)
end

function var0_0.CanUploadBackYardThemeTemplate(arg0_75)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_75.banBackyardUploadTime
end

function var0_0.GetBanUploadBackYardThemeTemplateTime(arg0_76)
	return pg.TimeMgr.GetInstance():STimeDescC(arg0_76.banBackyardUploadTime or 0)
end

function var0_0.CheckIdentityFlag(arg0_77)
	return arg0_77.identityFlag == 1
end

function var0_0.GetRegisterTime(arg0_78)
	return arg0_78.registerTime
end

function var0_0.GetFlagShip(arg0_79)
	local var0_79 = getProxy(SettingsProxy)
	local var1_79 = var0_79:getCurrentSecretaryIndex()
	local var2_79

	if var0_79:IsOpenRandomFlagShip() then
		var2_79 = arg0_79:GetRandomFlagShip(var1_79)
	else
		var2_79 = arg0_79:GetNativeFlagShip(var1_79)
	end

	return var2_79
end

local function var5_0(arg0_80)
	local var0_80 = {}
	local var1_80 = {}
	local var2_80 = getProxy(SettingsProxy):GetFlagShipDisplayMode()
	local var3_80 = getProxy(PlayerProxy):getRawData():ExistEducateChar()

	if var2_80 == FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR and not var3_80 then
		var2_80 = FlAG_SHIP_DISPLAY_ALL

		getProxy(SettingsProxy):SetFlagShipDisplayMode(var2_80)
	end

	if var2_80 ~= FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR then
		local var4_80 = getProxy(BayProxy)

		for iter0_80, iter1_80 in ipairs(arg0_80) do
			var0_80[iter0_80] = defaultValue(var4_80:RawGetShipById(iter1_80), false)

			table.insert(var1_80, iter0_80)
		end
	end

	if var3_80 and var2_80 ~= FlAG_SHIP_DISPLAY_ONLY_SHIP then
		table.insert(var1_80, PlayerVitaeShipsPage.EDUCATE_CHAR_SLOT_ID)

		local var5_80 = getProxy(PlayerProxy):getRawData():GetEducateCharacter()
		local var6_80 = VirtualEducateCharShip.New(var5_80)

		var0_80[PlayerVitaeShipsPage.EDUCATE_CHAR_SLOT_ID] = var6_80
	end

	return var0_80, var1_80
end

function var0_0.GetNativeFlagShip(arg0_81, arg1_81)
	local var0_81, var1_81 = var5_0(arg0_81.characters)
	local var2_81 = getProxy(SettingsProxy)

	if getProxy(PlayerProxy):getFlag("battle") then
		local var3_81 = math.random(#var1_81)

		arg1_81 = var1_81[var3_81]

		var2_81:setCurrentSecretaryIndex(var3_81)
	end

	local var4_81 = var0_81[arg1_81]

	if not var4_81 then
		local var5_81 = PlayerVitaeShipsPage.GetSlotIndexList()
		local var6_81 = table.indexof(var5_81, arg1_81)

		if var6_81 and var6_81 > 0 then
			for iter0_81 = var6_81 + 1, #var5_81 do
				arg1_81 = var5_81[iter0_81]
				var4_81 = var0_81[arg1_81]

				if var4_81 then
					var2_81:setCurrentSecretaryIndex(iter0_81)

					break
				end
			end
		end
	end

	if not var4_81 then
		arg1_81 = 1

		var2_81:setCurrentSecretaryIndex(arg1_81)

		var4_81 = var0_81[arg1_81]
	end

	return var4_81
end

function var0_0.GetRandomFlagShip(arg0_82, arg1_82)
	local var0_82 = getProxy(SettingsProxy)
	local var1_82 = var0_82:GetRandomFlagShipList()
	local var2_82, var3_82 = var5_0(var1_82)

	if getProxy(PlayerProxy):getFlag("battle") then
		local var4_82 = math.random(#var3_82)

		arg1_82 = var3_82[var4_82]

		var0_82:setCurrentSecretaryIndex(var4_82)
	end

	local var5_82 = var2_82[arg1_82]

	if not var5_82 then
		local var6_82 = PlayerVitaeShipsPage.GetSlotIndexList()
		local var7_82 = table.indexof(var6_82, arg1_82)

		if var7_82 and var7_82 > 0 then
			for iter0_82 = var7_82 + 1, #var6_82 do
				arg1_82 = var6_82[iter0_82]
				var5_82 = var2_82[arg1_82]

				if var5_82 then
					var0_82:setCurrentSecretaryIndex(iter0_82)

					break
				end
			end
		end
	end

	if not var5_82 then
		local var8_82 = {}

		for iter1_82, iter2_82 in pairs(var2_82) do
			if iter2_82 then
				table.insert(var8_82, iter1_82)
			end
		end

		if #var8_82 > 0 then
			arg1_82 = var8_82[math.random(1, #var8_82)]
			var5_82 = var2_82[arg1_82]

			local var9_82 = table.indexof(var3_82, arg1_82)

			if var9_82 then
				var0_82:setCurrentSecretaryIndex(var9_82)
			end
		end
	end

	if not var5_82 then
		arg1_82 = 1

		var0_82:setCurrentSecretaryIndex(arg1_82)

		var5_82 = var2_82[arg1_82]
	end

	return var5_82
end

function var0_0.GetNextFlagShip(arg0_83)
	getProxy(SettingsProxy):rotateCurrentSecretaryIndex()

	return arg0_83:GetFlagShip()
end

function var0_0.IsOpenShipEvaluationImpeach(arg0_84)
	return not LOCK_IMPEACH and arg0_84.level >= pg.gameset.report_level_limit.key_value
end

function var0_0.ShouldCheckCustomName(arg0_85)
	return arg0_85:GetCommonFlag(REVERT_CUSTOM_NAME)
end

function var0_0.WhetherServerModifiesName(arg0_86)
	return arg0_86:GetCommonFlag(ILLEGALITY_PLAYER_NAME)
end

function var0_0.GetManifesto(arg0_87)
	return arg0_87.manifesto or ""
end

function var0_0.GetName(arg0_88)
	return arg0_88.name
end

function var0_0.GetRandomFlagShipMode(arg0_89)
	if arg0_89.randomShipMode <= 0 then
		if arg0_89:GetCommonFlag(RANDOM_FLAG_SHIP_MODE) then
			arg0_89.randomShipMode = SettingsRandomFlagShipAndSkinPanel.SHIP_LOCKED
		else
			arg0_89.randomShipMode = SettingsRandomFlagShipAndSkinPanel.SHIP_FREQUENTLYUSED
		end
	end

	return arg0_89.randomShipMode
end

function var0_0.UpdateRandomFlagShipMode(arg0_90, arg1_90)
	arg0_90.randomShipMode = arg1_90
end

function var0_0.GetCustomRandomShipList(arg0_91)
	local var0_91 = {}

	for iter0_91, iter1_91 in ipairs(arg0_91.customRandomShips) do
		table.insert(var0_91, iter1_91)
	end

	return var0_91
end

function var0_0.UpdateCustomRandomShipList(arg0_92, arg1_92)
	arg0_92.customRandomShips = arg1_92
end

function var0_0.SetProposeShipId(arg0_93, arg1_93)
	arg0_93.proposeShipId = arg1_93
end

function var0_0.GetProposeShipId(arg0_94)
	return arg0_94.proposeShipId
end

function var0_0.GetCryptolaliaList(arg0_95)
	local var0_95 = {}
	local var1_95 = {}
	local var2_95 = arg0_95.unlockCryptolaliaList

	for iter0_95, iter1_95 in ipairs(var2_95) do
		var1_95[iter1_95] = true
	end

	for iter2_95, iter3_95 in ipairs(pg.soundstory_template.all) do
		local var3_95 = Cryptolalia.New({
			id = iter3_95
		})

		if var1_95[iter3_95] then
			var3_95:Unlock()
		end

		table.insert(var0_95, var3_95)
	end

	return var0_95
end

function var0_0.UnlockCryptolalia(arg0_96, arg1_96)
	if not table.contains(arg0_96.unlockCryptolaliaList) then
		table.insert(arg0_96.unlockCryptolaliaList, arg1_96)
	end
end

function var0_0.ExistCryptolalia(arg0_97, arg1_97)
	local var0_97 = arg0_97:GetCryptolaliaList()

	for iter0_97, iter1_97 in ipairs(var0_97) do
		if (iter1_97:InTime() or not iter1_97:IsLock()) and iter1_97:IsSameGroup(arg1_97) then
			return true
		end
	end

	return false
end

function var0_0.ExistEducateChar(arg0_98)
	return arg0_98.educateCharacter > 0
end

function var0_0.GetEducateCharacter(arg0_99)
	return arg0_99.educateCharacter
end

function var0_0.SetEducateCharacter(arg0_100, arg1_100)
	arg0_100.educateCharacter = arg1_100
end

function var0_0.CanGetResource(arg0_101, arg1_101)
	local var0_101 = id2res(arg1_101)
	local var1_101

	if arg1_101 == 1 then
		var1_101 = arg0_101:getLevelMaxGold()
	elseif arg1_101 == 2 then
		var1_101 = arg0_101:getLevelMaxOil()
	else
		assert(false)
	end

	if var1_101 <= arg0_101[var0_101] then
		return false
	end

	return true
end

function var0_0.GetExtendStoreCost(arg0_102)
	local var0_102 = pg.mail_storeroom[arg0_102.mailStoreLevel]
	local var1_102 = {}

	if var0_102.upgrade_gem > 0 then
		var1_102.diamond = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond,
			count = var0_102.upgrade_gem
		})
	end

	if var0_102.upgrade_gold > 0 then
		var1_102.gold = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold,
			count = var0_102.upgrade_gold
		})
	end

	return var1_102.diamond, var1_102.gold
end

function var0_0.IsStoreLevelMax(arg0_103)
	return not pg.mail_storeroom[arg0_103.mailStoreLevel + 1]
end

function var0_0.updateMedalList(arg0_104, arg1_104)
	for iter0_104, iter1_104 in ipairs(arg1_104) do
		local var0_104 = iter1_104.key
		local var1_104 = iter1_104.value
		local var2_104 = pg.activity_medal_template[var0_104].group

		arg0_104.activityMedalGroupList[var2_104] = arg0_104.activityMedalGroupList[var2_104] or ActivityMedalGroup.New(var2_104)

		arg0_104.activityMedalGroupList[var2_104]:UpdateMedal(var0_104, var1_104)
	end
end

function var0_0.getActivityMedalGroup(arg0_105)
	return arg0_105.activityMedalGroupList
end

return var0_0
