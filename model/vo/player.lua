local var0 = class("Player", import(".PlayerAttire"))
local var1 = pg.player_resource
local var2 = var1.get_id_list_by_name
local var3
local var4

var0.MAX_SHIP_BAG = 4000
var0.MAX_EQUIP_BAG = 2000
var0.MAX_COMMANDER_BAG = 200
var0.ASSISTS_TYPE_SHAM = 0
var0.ASSISTS_TYPE_GUILD = 1
var0.CHANGE_NAME_KEY = 1

function id2res(arg0)
	return var1[arg0].name
end

function res2id(arg0)
	return var1.get_id_list_by_name[arg0][1]
end

function id2ItemId(arg0)
	return var1[arg0].itemid
end

function itemId2Id(arg0)
	assert(false)
end

function var0.isMetaShipNeedToTrans(arg0)
	local var0 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0)

	return getProxy(BayProxy):getMetaShipByGroupId(var0) and true or false
end

function var0.metaShip2Res(arg0)
	local var0 = MetaCharacterConst.GetMetaShipGroupIDByConfigID(arg0)
	local var1 = getProxy(BayProxy):getMetaShipByGroupId(var0):getMetaCharacter():getSpecialMaterialInfoToMaxStar()
	local var2 = var1.itemID
	local var3 = var1.count <= getProxy(BagProxy):getItemCountById(var2)
	local var4

	if var3 then
		var4 = pg.ship_transform[var0].common_item
	else
		var4 = pg.ship_transform[var0].exclusive_item
	end

	local var5 = {}

	for iter0, iter1 in ipairs(var4) do
		local var6 = {
			type = iter1[1],
			id = iter1[2],
			count = iter1[3]
		}

		table.insert(var5, var6)
	end

	return var5
end

function var0.getSkinTicket(arg0)
	local var0 = pg.gameset.skin_ticket.key_value

	return var0 == 0 and 0 or arg0:getResource(var0)
end

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	local var0 = arg0.character

	arg0.educateCharacter = arg1.child_display or 0

	if var0 then
		if type(var0) == "number" then
			arg0.character = var0
			arg0.characters = {
				var0
			}
		else
			arg0.character = var0[1]
			arg0.characters = var0
		end
	end

	arg0.id = arg1.id
	arg0.name = arg1.name
	arg0.level = arg1.level or arg1.lv
	arg0.configId = arg0.level
	arg0.exp = arg1.exp or 0
	arg0.attackCount = arg1.attack_count or 0
	arg0.winCount = arg1.win_count or 0
	arg0.manifesto = arg1.adv or arg1.manifesto
	arg0.shipBagMax = arg1.ship_bag_max
	arg0.equipBagMax = arg1.equip_bag_max
	arg0.buff_list = arg1.buffList or {}
	arg0.rank = arg1.rank or arg1.title or 0
	arg0.pvp_attack_count = arg1.pvp_attack_count or 0
	arg0.pvp_win_count = arg1.pvp_win_count or 0
	arg0.collect_attack_count = arg1.collect_attack_count or 0
	arg0.guideIndex = arg1.guide_index
	arg0.buyOilCount = arg1.buy_oil_count
	arg0.chatRoomId = arg1.chat_room_id or 1
	arg0.score = arg1.score or 0
	arg0.guildWaitTime = arg1.guild_wait_time or 0
	arg0.commanderBagMax = arg1.commander_bag_max
	arg0.displayTrophyList = arg1.medal_id or {}
	arg0.banBackyardUploadTime = arg1.theme_upload_not_allowed_time or 0
	arg0.rmb = arg1.rmb or 0
	arg0.identityFlag = arg1.gm_flag
	arg0.mailStoreLevel = arg1.mail_storeroom_lv

	local var1 = getProxy(AppreciateProxy)

	if arg1.appreciation then
		for iter0, iter1 in ipairs(arg1.appreciation.gallerys or {}) do
			var1:addPicIDToUnlockList(iter1)
		end

		for iter2, iter3 in ipairs(arg1.appreciation.musics or {}) do
			var1:addMusicIDToUnlockList(iter3)
		end

		for iter4, iter5 in ipairs(arg1.appreciation.favor_gallerys or {}) do
			var1:addPicIDToLikeList(iter5)
		end

		for iter6, iter7 in ipairs(arg1.appreciation.favor_musics or {}) do
			var1:addMusicIDToLikeList(iter7)
		end

		local var2 = getProxy(AppreciateProxy)
		local var3 = var2:getResultForVer()

		if var3 then
			pg.ConnectionMgr.GetInstance():Send(15300, {
				type = 0,
				ver_str = var3
			})
			var2:clearVer()
		end
	end

	if arg1.cartoon_read_mark then
		var1:initMangaReadIDList(arg1.cartoon_read_mark)
	end

	if arg1.cartoon_collect_mark then
		var1:initMangaLikeIDList(arg1.cartoon_collect_mark)
	end

	arg0.cdList = {}

	for iter8, iter9 in ipairs(arg1.cd_list or {}) do
		arg0.cdList[iter9.key] = iter9.timestamp
	end

	arg0.commonFlagList = {}

	for iter10, iter11 in ipairs(arg1.flag_list or {}) do
		arg0.commonFlagList[iter11] = true
	end

	arg0.registerTime = arg1.register_time
	arg0.vipCards = {}

	for iter12, iter13 in ipairs(arg1.card_list or {}) do
		local var4 = VipCard.New(iter13)

		arg0.vipCards[var4.id] = var4
	end

	arg0:updateResources(arg1.resource_list)

	arg0.maxRank = arg1.max_rank or 0
	arg0.shipCount = arg1.ship_count or 0
	arg0.chargeExp = arg1.acc_pay_lv or 0
	arg0.mingshiflag = 0
	arg0.mingshiCount = 0
	arg0.chatMsgBanTime = arg1.chat_msg_ban_time or 0
	arg0.randomShipMode = arg1.random_ship_mode or 0
	arg0.customRandomShips = {}

	for iter14, iter15 in ipairs(arg1.random_ship_list or {}) do
		table.insert(arg0.customRandomShips, iter15)
	end

	arg0.buildShipNotification = {}

	for iter16, iter17 in ipairs(arg1.taking_ship_list or {}) do
		table.insert(arg0.buildShipNotification, {
			uid = iter17.uid,
			new = iter17.isnew == 1
		})
	end

	arg0.proposeShipId = arg1.marry_ship
	arg0.unlockCryptolaliaList = {}

	for iter18, iter19 in ipairs(arg1.soundstory or {}) do
		table.insert(arg0.unlockCryptolaliaList, iter19)
	end

	arg0.displayInfo = arg1.display or {}
	arg0.attireInfo = {}
	arg0.attireInfo[AttireConst.TYPE_ICON_FRAME] = arg0.iconFrame
	arg0.attireInfo[AttireConst.TYPE_CHAT_FRAME] = arg0.chatFrame
end

function var0.updateAttireFrame(arg0, arg1, arg2)
	arg0.attireInfo[arg1] = arg2
end

function var0.getAttireByType(arg0, arg1)
	return arg0.attireInfo[arg1]
end

function var0.getRandomSecretary(arg0)
	return arg0.characters[math.random(#arg0.characters)]
end

function var0.canModifyName(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1 = pg.gameset.player_name_change_lv_limit.key_value

	if var1 > arg0.level then
		return false, i18n("player_name_change_time_lv_tip", var1)
	end

	local var2 = arg0:getModifyNameTimestamp()

	if var0 < var2 then
		local var3, var4, var5, var6 = pg.TimeMgr.GetInstance():parseTimeFrom(var2 - var0)
		local var7

		if var3 == 0 then
			if var4 == 0 then
				var7 = math.max(var5, 1) .. i18n("word_minute")
			else
				var7 = var4 .. i18n("word_hour")
			end
		else
			var7 = var3 .. i18n("word_date")
		end

		return false, i18n("player_name_change_time_limit_tip", var7)
	end

	return true
end

function var0.getModifyNameComsume(arg0)
	return pg.gameset.player_name_change_cost.description
end

function var0.getModifyNameTimestamp(arg0)
	return arg0.cdList[var0.CHANGE_NAME_KEY] or 0
end

function var0.updateModifyNameColdTime(arg0, arg1)
	arg0.cdList[var0.CHANGE_NAME_KEY] = arg1
end

function var0.getMaxGold(arg0)
	return pg.gameset.max_gold.key_value
end

function var0.getMaxOil(arg0)
	return pg.gameset.max_oil.key_value
end

function var0.getLevelMaxGold(arg0)
	local var0 = arg0:getConfig("max_gold")
	local var1 = getProxy(GuildProxy):GetAdditionGuild()

	return var1 and var0 + var1:getMaxGoldAddition() or var0
end

function var0.getLevelMaxOil(arg0)
	local var0 = arg0:getConfig("max_oil")
	local var1 = getProxy(GuildProxy):GetAdditionGuild()

	return var1 and var0 + var1:getMaxOilAddition() or var0
end

function var0.getResource(arg0, arg1)
	return arg0[id2res(arg1)] or 0
end

function var0.updateResources(arg0, arg1)
	for iter0, iter1 in pairs(var2) do
		assert(#iter1 == 1, "Multiple ID have the same name : " .. iter0)

		local var0 = iter1[1]

		if iter0 == "gem" then
			arg0.chargeGem = 0
		elseif iter0 == "freeGem" then
			arg0.awardGem = 0
		else
			arg0[iter0] = 0
		end
	end

	for iter2, iter3 in ipairs(arg1 or {}) do
		local var1 = id2res(iter3.type)

		assert(var1, "resource type erro>>>>>" .. iter3.type)

		if var1 == "gem" then
			arg0.chargeGem = iter3.num
		elseif var1 == "freeGem" then
			arg0.awardGem = iter3.num
		else
			arg0[var1] = iter3.num
		end
	end
end

function var0.getPainting(arg0)
	local var0 = pg.ship_skin_template[arg0.skinId]

	return var0 and var0.painting or "unknown"
end

function var0.inGuildCDTime(arg0)
	return arg0.guildWaitTime > 0 and arg0.guildWaitTime > pg.TimeMgr.GetInstance():GetServerTime()
end

function var0.setGuildWaitTime(arg0, arg1)
	arg0.guildWaitTime = arg1
end

function var0.getChargeLevel(arg0)
	local var0 = pg.pay_level_award
	local var1 = var0.all[1]
	local var2 = var0.all[#var0.all]

	for iter0, iter1 in ipairs(var0.all) do
		if arg0.chargeExp >= var0[iter1].exp then
			var1 = math.min(iter1 + 1, var2)
		end
	end

	return var1
end

function var0.getCardById(arg0, arg1)
	return Clone(arg0.vipCards[arg1])
end

function var0.addVipCard(arg0, arg1)
	arg0.vipCards[arg1.id] = arg1
end

function var0.addShipBagCount(arg0, arg1)
	arg0.shipBagMax = arg0.shipBagMax + arg1
end

function var0.addEquipmentBagCount(arg0, arg1)
	arg0.equipBagMax = arg0.equipBagMax + arg1
end

function var0.bindConfigTable(arg0)
	return pg.user_level
end

function var0.updateScoreAndRank(arg0, arg1, arg2)
	arg0.score = arg1
	arg0.rank = arg2
end

function var0.increasePvpCount(arg0)
	arg0.pvp_attack_count = arg0.pvp_attack_count + 1
end

function var0.increasePvpWinCount(arg0)
	arg0.pvp_win_count = arg0.pvp_win_count + 1
end

function var0.isEnough(arg0, arg1)
	for iter0, iter1 in pairs(arg1) do
		if arg0[iter0] == nil or iter1 > arg0[iter0] then
			return false, iter0
		end
	end

	return true
end

function var0.increaseBuyOilCount(arg0)
	arg0.buyOilCount = arg0.buyOilCount + 1
end

function var0.changeChatRoom(arg0, arg1)
	arg0.chatRoomId = arg1
end

function var0.increaseAttackCount(arg0)
	arg0.attackCount = arg0.attackCount + 1
end

function var0.increaseAttackWinCount(arg0)
	arg0.winCount = arg0.winCount + 1
end

function var0.increaseShipCount(arg0, arg1)
	arg0.shipCount = arg0.shipCount + (arg1 and arg1 or 1)
end

function var0.isFull(arg0)
	for iter0, iter1 in pairs(var2) do
		local var0 = pg.user_level["max_" .. iter0]

		if var0 and var0 > arg0[iter0] then
			return false
		end
	end

	return true
end

function var0.getMaxEquipmentBag(arg0)
	local var0 = arg0.equipBagMax
	local var1 = 0
	local var2 = getProxy(GuildProxy):GetAdditionGuild()

	if var2 then
		var1 = var2:getEquipmentBagAddition()
	end

	return var1 + var0
end

function var0.getMaxShipBag(arg0)
	local var0 = arg0.shipBagMax
	local var1 = 0
	local var2 = getProxy(GuildProxy):GetAdditionGuild()

	if var2 then
		var1 = var2:getShipBagAddition()
	end

	return var1 + var0
end

function var0.getMaxEquipmentBagExcludeGuild(arg0)
	return arg0.equipBagMax
end

function var0.getMaxShipBagExcludeGuild(arg0)
	return arg0.shipBagMax
end

function var0.__index(arg0, arg1)
	if arg1 == "gem" then
		return arg0:getChargeGem()
	elseif arg1 == "freeGem" then
		return arg0:getTotalGem()
	elseif arg1 == "equipBagMax" then
		return arg0:getMaxEquipmentBag()
	elseif arg1 == "shipBagMax" then
		return arg0:getMaxShipBag()
	end

	local var0 = rawget(arg0, arg1) or var0[arg1]

	var0 = var0 or var0.super[arg1]

	return var0
end

function var0.__newindex(arg0, arg1, arg2)
	assert(arg1 ~= "gem" and arg1 ~= "freeGem", "Do not set gem directly.")
	rawset(arg0, arg1, arg2)
end

function var0.getFreeGem(arg0)
	return arg0.awardGem
end

function var0.getChargeGem(arg0)
	return arg0.chargeGem
end

function var0.getTotalGem(arg0)
	return arg0:getFreeGem() + arg0:getChargeGem()
end

function var0.getResById(arg0, arg1)
	if arg1 == 4 then
		return arg0:getTotalGem()
	else
		return arg0[id2res(arg1)]
	end
end

function var0.consume(arg0, arg1)
	local var0 = (arg1.freeGem or 0) + (arg1.gem or 0)

	arg1.freeGem = nil
	arg1.gem = nil

	if var0 > 0 then
		local var1 = arg0:getFreeGem()
		local var2 = math.min(var0, var1)

		arg0.awardGem = var1 - var2
		arg0.chargeGem = arg0.chargeGem - (var0 - var2)
	end

	for iter0, iter1 in pairs(arg1) do
		arg0[iter0] = arg0[iter0] - iter1
	end
end

function var0.addResources(arg0, arg1)
	for iter0, iter1 in pairs(arg1) do
		if iter0 == "gold" then
			local var0 = arg0:getMaxGold()

			arg0[iter0] = math.min(arg0[iter0] + iter1, var0)
		elseif iter0 == "oil" then
			local var1 = arg0:getMaxOil()

			arg0[iter0] = math.min(arg0[iter0] + iter1, var1)
		elseif iter0 == "gem" then
			arg0.chargeGem = arg0:getChargeGem() + iter1
		elseif iter0 == "freeGem" then
			arg0.awardGem = arg0:getFreeGem() + iter1
		elseif iter0 == id2res(WorldConst.ResourceID) then
			local var2 = pg.gameset.world_resource_max.key_value

			arg0[iter0] = math.min(arg0[iter0] + iter1, var2)
		elseif iter0 == "gameticket" then
			local var3 = pg.gameset.game_room_remax.key_value

			arg0[iter0] = math.min(arg0[iter0] + iter1, var3)
		else
			arg0[iter0] = arg0[iter0] + iter1
		end
	end
end

function var0.resetBuyOilCount(arg0)
	arg0.buyOilCount = 0
end

function var0.addExp(arg0, arg1)
	assert(arg1 >= 0, "exp should greater than zero")

	arg0.exp = arg0.exp + arg1

	while arg0:canLevelUp() do
		arg0.exp = arg0.exp - arg0:getLevelExpConfig().exp_interval
		arg0.level = arg0.level + 1

		pg.TrackerMgr.GetInstance():Tracking(TRACKING_USER_LEVELUP, arg0.level)

		if arg0.level == 30 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_USER_LEVEL_THIRTY)
		elseif arg0.level == 40 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_USER_LEVEL_FORTY)
		end
	end
end

function var0.addExpToLevel(arg0, arg1)
	local var0 = getConfigFromLevel1(pg.user_level, arg1)
	local var1 = arg0:getLevelExpConfig()

	if var1.exp_start + arg0.exp >= var0.exp_start then
		print("EXP Overflow, Return")

		return
	end

	arg0:addExp(var0.exp_start - var1.exp_start - arg0.exp)
end

function var0.GetBuffs(arg0)
	return arg0.buff_list
end

function var0.getLevelExpConfig(arg0)
	return getConfigFromLevel1(pg.user_level, arg0.level)
end

function var0.getMaxLevel(arg0)
	return pg.user_level.all[#pg.user_level.all]
end

function var0.getTotalExp(arg0)
	return arg0:getLevelExpConfig().exp_start + arg0.exp
end

function var0.canLevelUp(arg0)
	local var0 = getConfigFromLevel1(pg.user_level, arg0.level + 1)
	local var1 = arg0:getLevelExpConfig()

	return var0 and var1 ~= var0 and var1.exp_interval <= arg0.exp
end

function var0.isSelf(arg0)
	return getProxy(PlayerProxy):isSelf(arg0.id)
end

function var0.isFriend(arg0)
	return getProxy(FriendProxy):isFriend(arg0.id)
end

function var0.OilMax(arg0, arg1)
	arg1 = arg1 or 0

	return pg.gameset.max_oil.key_value < arg0.oil + arg1
end

function var0.GoldMax(arg0, arg1)
	arg1 = arg1 or 0

	return pg.gameset.max_gold.key_value < arg0.gold + arg1
end

function var0.ResLack(arg0, arg1, arg2)
	local var0 = pg.gameset["max_" .. arg1].key_value

	if var0 < arg0[arg1] then
		return 0
	else
		return math.min(arg2, var0 - arg0[arg1])
	end
end

function var0.OverStore(arg0, arg1, arg2)
	arg2 = arg2 or 0

	local var0 = id2res(arg1)
	local var1 = pg.mail_storeroom[arg0.mailStoreLevel]
	local var2 = switch(arg1, {
		[PlayerConst.ResStoreGold] = function()
			return var1.gold_store
		end,
		[PlayerConst.ResStoreOil] = function()
			return var1.oil_store
		end
	})

	return arg0[var0] + arg2 - var2
end

function var0.UpdateCommonFlag(arg0, arg1)
	arg0.commonFlagList[arg1] = true
end

function var0.GetCommonFlag(arg0, arg1)
	return arg0.commonFlagList[arg1]
end

function var0.CancelCommonFlag(arg0, arg1)
	arg0.commonFlagList[arg1] = false
end

function var0.SetCommonFlag(arg0, arg1, arg2)
	arg0.commonFlagList[arg1] = arg2
end

function var0.updateCommanderBagMax(arg0, arg1)
	arg0.commanderBagMax = arg0.commanderBagMax + arg1
end

function var0.GetDaysFromRegister(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return pg.TimeMgr.GetInstance():DiffDay(arg0.registerTime, var0)
end

function var0.CanUploadBackYardThemeTemplate(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.banBackyardUploadTime
end

function var0.GetBanUploadBackYardThemeTemplateTime(arg0)
	return pg.TimeMgr.GetInstance():STimeDescC(arg0.banBackyardUploadTime or 0)
end

function var0.CheckIdentityFlag(arg0)
	return arg0.identityFlag == 1
end

function var0.GetRegisterTime(arg0)
	return arg0.registerTime
end

function var0.GetFlagShip(arg0)
	local var0 = getProxy(SettingsProxy)
	local var1 = var0:getCurrentSecretaryIndex()
	local var2

	if var0:IsOpenRandomFlagShip() then
		var2 = arg0:GetRandomFlagShip(var1)
	else
		var2 = arg0:GetNativeFlagShip(var1)
	end

	return var2
end

local function var5(arg0)
	local var0 = {}
	local var1 = {}
	local var2 = getProxy(SettingsProxy):GetFlagShipDisplayMode()
	local var3 = getProxy(PlayerProxy):getRawData():ExistEducateChar()

	if var2 == FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR and not var3 then
		var2 = FlAG_SHIP_DISPLAY_ALL

		getProxy(SettingsProxy):SetFlagShipDisplayMode(var2)
	end

	if var2 ~= FlAG_SHIP_DISPLAY_ONLY_EDUCATECHAR then
		local var4 = getProxy(BayProxy)

		for iter0, iter1 in ipairs(arg0) do
			var0[iter0] = defaultValue(var4:RawGetShipById(iter1), false)

			table.insert(var1, iter0)
		end
	end

	if var3 and var2 ~= FlAG_SHIP_DISPLAY_ONLY_SHIP then
		table.insert(var1, PlayerVitaeShipsPage.EDUCATE_CHAR_SLOT_ID)

		local var5 = getProxy(PlayerProxy):getRawData():GetEducateCharacter()
		local var6 = VirtualEducateCharShip.New(var5)

		var0[PlayerVitaeShipsPage.EDUCATE_CHAR_SLOT_ID] = var6
	end

	return var0, var1
end

function var0.GetNativeFlagShip(arg0, arg1)
	local var0, var1 = var5(arg0.characters)
	local var2 = getProxy(SettingsProxy)

	if getProxy(PlayerProxy):getFlag("battle") then
		local var3 = math.random(#var1)

		arg1 = var1[var3]

		var2:setCurrentSecretaryIndex(var3)
	end

	local var4 = var0[arg1]

	if not var4 then
		local var5 = PlayerVitaeShipsPage.GetSlotIndexList()
		local var6 = table.indexof(var5, arg1)

		if var6 and var6 > 0 then
			for iter0 = var6 + 1, #var5 do
				arg1 = var5[iter0]
				var4 = var0[arg1]

				if var4 then
					var2:setCurrentSecretaryIndex(iter0)

					break
				end
			end
		end
	end

	if not var4 then
		arg1 = 1

		var2:setCurrentSecretaryIndex(arg1)

		var4 = var0[arg1]
	end

	return var4
end

function var0.GetRandomFlagShip(arg0, arg1)
	local var0 = getProxy(SettingsProxy)
	local var1 = var0:GetRandomFlagShipList()
	local var2, var3 = var5(var1)

	if getProxy(PlayerProxy):getFlag("battle") then
		local var4 = math.random(#var3)

		arg1 = var3[var4]

		var0:setCurrentSecretaryIndex(var4)
	end

	local var5 = var2[arg1]

	if not var5 then
		local var6 = PlayerVitaeShipsPage.GetSlotIndexList()
		local var7 = table.indexof(var6, arg1)

		if var7 and var7 > 0 then
			for iter0 = var7 + 1, #var6 do
				arg1 = var6[iter0]
				var5 = var2[arg1]

				if var5 then
					var0:setCurrentSecretaryIndex(iter0)

					break
				end
			end
		end
	end

	if not var5 then
		local var8 = {}

		for iter1, iter2 in pairs(var2) do
			if iter2 then
				table.insert(var8, iter1)
			end
		end

		if #var8 > 0 then
			arg1 = var8[math.random(1, #var8)]
			var5 = var2[arg1]

			local var9 = table.indexof(var3, arg1)

			if var9 then
				var0:setCurrentSecretaryIndex(var9)
			end
		end
	end

	if not var5 then
		arg1 = 1

		var0:setCurrentSecretaryIndex(arg1)

		var5 = var2[arg1]
	end

	return var5
end

function var0.GetNextFlagShip(arg0)
	getProxy(SettingsProxy):rotateCurrentSecretaryIndex()

	return arg0:GetFlagShip()
end

function var0.IsOpenShipEvaluationImpeach(arg0)
	return not LOCK_IMPEACH and arg0.level >= pg.gameset.report_level_limit.key_value
end

function var0.ShouldCheckCustomName(arg0)
	return arg0:GetCommonFlag(REVERT_CUSTOM_NAME)
end

function var0.WhetherServerModifiesName(arg0)
	return arg0:GetCommonFlag(ILLEGALITY_PLAYER_NAME)
end

function var0.GetManifesto(arg0)
	return arg0.manifesto or ""
end

function var0.GetName(arg0)
	return arg0.name
end

function var0.GetRandomFlagShipMode(arg0)
	if arg0.randomShipMode <= 0 then
		if arg0:GetCommonFlag(RANDOM_FLAG_SHIP_MODE) then
			arg0.randomShipMode = SettingsRandomFlagShipAndSkinPanel.SHIP_LOCKED
		else
			arg0.randomShipMode = SettingsRandomFlagShipAndSkinPanel.SHIP_FREQUENTLYUSED
		end
	end

	return arg0.randomShipMode
end

function var0.UpdateRandomFlagShipMode(arg0, arg1)
	arg0.randomShipMode = arg1
end

function var0.GetCustomRandomShipList(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.customRandomShips) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.UpdateCustomRandomShipList(arg0, arg1)
	arg0.customRandomShips = arg1
end

function var0.SetProposeShipId(arg0, arg1)
	arg0.proposeShipId = arg1
end

function var0.GetProposeShipId(arg0)
	return arg0.proposeShipId
end

function var0.GetCryptolaliaList(arg0)
	local var0 = {}
	local var1 = {}
	local var2 = arg0.unlockCryptolaliaList

	for iter0, iter1 in ipairs(var2) do
		var1[iter1] = true
	end

	for iter2, iter3 in ipairs(pg.soundstory_template.all) do
		local var3 = Cryptolalia.New({
			id = iter3
		})

		if var1[iter3] then
			var3:Unlock()
		end

		table.insert(var0, var3)
	end

	return var0
end

function var0.UnlockCryptolalia(arg0, arg1)
	if not table.contains(arg0.unlockCryptolaliaList) then
		table.insert(arg0.unlockCryptolaliaList, arg1)
	end
end

function var0.ExistCryptolalia(arg0, arg1)
	local var0 = arg0:GetCryptolaliaList()

	for iter0, iter1 in ipairs(var0) do
		if (iter1:InTime() or not iter1:IsLock()) and iter1:IsSameGroup(arg1) then
			return true
		end
	end

	return false
end

function var0.ExistEducateChar(arg0)
	return arg0.educateCharacter > 0
end

function var0.GetEducateCharacter(arg0)
	return arg0.educateCharacter
end

function var0.SetEducateCharacter(arg0, arg1)
	arg0.educateCharacter = arg1
end

function var0.CanGetResource(arg0, arg1)
	local var0 = id2res(arg1)
	local var1

	if arg1 == 1 then
		var1 = arg0:getLevelMaxGold()
	elseif arg1 == 2 then
		var1 = arg0:getLevelMaxOil()
	else
		assert(false)
	end

	if var1 <= arg0[var0] then
		return false
	end

	return true
end

function var0.GetExtendStoreCost(arg0)
	local var0 = pg.mail_storeroom[arg0.mailStoreLevel]
	local var1 = {}

	if var0.upgrade_gem > 0 then
		var1.diamond = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond,
			count = var0.upgrade_gem
		})
	end

	if var0.upgrade_gold > 0 then
		var1.gold = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResGold,
			count = var0.upgrade_gold
		})
	end

	return var1.diamond, var1.gold
end

function var0.IsStoreLevelMax(arg0)
	return not pg.mail_storeroom[arg0.mailStoreLevel + 1]
end

return var0
