local var0_0 = class("ChatProxy", import(".NetProxy"))

var0_0.NEW_MSG = "ChatProxy public msg"

function var0_0.InjectPublic(arg0_1, arg1_1, arg2_1)
	if arg1_1.id == 0 then
		arg0_1.text = arg1_1.args[1] and arg1_1.args[1].string or ""

		return
	end

	local var0_1 = i18n("ad_" .. arg1_1.id)

	for iter0_1 = 1, #arg1_1.args do
		local var1_1 = arg1_1.args[iter0_1]
		local var2_1

		if var1_1.type == PublicArg.TypePlayerName then
			var2_1 = var1_1.string
		elseif var1_1.type == PublicArg.TypeShipId then
			local var3_1 = pg.ship_data_statistics[var1_1.int]
			local var4_1 = "shiptype" .. iter0_1
			local var5_1 = GetSpriteFromAtlas("shiptype", shipType2print(var3_1.type))

			arg0_1:AddSprite(var4_1, var5_1)

			local var6_1 = "shipcolor" .. iter0_1

			var0_1 = string.gsub(var0_1, var6_1, ItemRarity.Rarity2HexColor(var3_1.rarity - 1))
			var2_1 = var3_1.name

			if arg2_1 then
				local var7_1 = false

				if PLATFORM_CODE == PLATFORM_JP then
					var7_1, var2_1 = contentWrap(var2_1, 18, 1.65)
				end

				if var7_1 then
					var2_1 = var2_1 .. "..." or var2_1
				end
			end
		elseif var1_1.type == PublicArg.TypeEquipId then
			var2_1 = pg.equip_data_statistics[var1_1.int].name
		elseif var1_1.type == PublicArg.TypeItemId then
			var2_1 = Item.getConfigData(var1_1.int).name
		elseif var1_1.type == PublicArg.TypeNums then
			var2_1 = var1_1.int
		elseif var1_1.type == PublicArg.TypeWorldBoss then
			var2_1 = var1_1.string
		else
			var2_1 = var1_1.string
		end

		var0_1 = string.gsub(var0_1, "$" .. iter0_1, var2_1)
	end

	arg0_1.text = var0_1
end

function var0_0.InjectPublicMsg(arg0_2, arg1_2)
	local var0_2, var1_2 = wordVer(arg0_2, {
		isReplace = true
	})
	local var2_2

	string.gsub(var1_2, ChatConst.EmojiCodeMatch, function(arg0_3)
		var2_2 = tonumber(arg0_3)
	end)

	if var2_2 then
		local var3_2 = pg.emoji_template[var2_2]

		if var3_2 then
			var1_2 = var3_2.desc
		else
			var2_2 = nil
		end
	end

	return {
		player = arg1_2,
		content = var1_2,
		emojiId = var2_2,
		timestamp = pg.TimeMgr.GetInstance():GetServerTime()
	}
end

function var0_0.register(arg0_4)
	arg0_4:on(50101, function(arg0_5)
		if arg0_5.type == ChatConst.CODE_BANED then
			pg.TipsMgr.GetInstance():ShowTips(arg0_5.content)
		elseif arg0_5.type == ChatConst.CODE_ACTOBSS_MSG_WORD then
			local var0_5 = {
				name = arg0_5.player.name,
				score = arg0_5.content
			}

			arg0_4:sendNotification(GAME.ACTIVITY_BOSS_MSG_ADDED, var0_5)
			table.insert(arg0_4.actBossMsg, var0_5)

			if #arg0_4.actBossMsg > 6 then
				table.remove(arg0_4.actBossMsg, 1)
			end
		else
			local var1_5 = var0_0.InjectPublicMsg(arg0_5.content, Player.New(arg0_5.player))

			arg0_4:addNewMsg(ChatMsg.New(ChatConst.ChannelWorld, var1_5))
		end
	end)
	arg0_4:on(50103, function(arg0_6)
		local var0_6 = {}

		for iter0_6, iter1_6 in ipairs(arg0_6.arg_list) do
			table.insert(var0_6, PublicArg.New(iter1_6))
		end

		local var1_6 = {
			id = arg0_6.ad_id,
			args = var0_6,
			timestamp = pg.TimeMgr.GetInstance():GetServerTime()
		}

		arg0_4:addNewMsg(ChatMsg.New(ChatConst.ChannelPublic, var1_6))
	end)

	arg0_4.informs = {}
	arg0_4.actBossMsg = {}
end

function var0_0.addNewMsg(arg0_7, arg1_7)
	if arg1_7.id == 0 then
		arg0_7.top = arg1_7

		_.each(arg1_7.args, function(arg0_8)
			if arg0_8.string then
				pg.TipsMgr.GetInstance():ShowTips(arg0_8.string)
			end
		end)
	else
		table.insert(arg0_7.data, arg1_7)

		if #arg0_7.data > 100 then
			table.remove(arg0_7.data, 1)
		end
	end

	arg0_7:sendNotification(var0_0.NEW_MSG, arg1_7)
end

function var0_0.UpdateMsg(arg0_9, arg1_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.data) do
		if iter1_9:IsSame(arg1_9.uniqueId) then
			arg0_9.data[iter0_9] = arg1_9
		end
	end
end

function var0_0.GetMessagesByUniqueId(arg0_10, arg1_10)
	return _.select(arg0_10.data, function(arg0_11)
		return arg0_11.uniqueId == arg1_10
	end)
end

function var0_0.clearMsg(arg0_12)
	arg0_12.data = {}
end

function var0_0.loadUsedEmoji(arg0_13)
	arg0_13.usedEmoji = {}

	local var0_13 = getProxy(PlayerProxy):getRawData().id
	local var1_13 = string.split(PlayerPrefs.GetString(ChatConst.EMOJI_SAVE_TAG .. var0_13) or "", ":")

	if #var1_13 > 0 then
		_.each(var1_13, function(arg0_14)
			local var0_14 = string.split(arg0_14, "|")

			if #var0_14 == 2 then
				arg0_13.usedEmoji[tonumber(var0_14[1])] = tonumber(var0_14[2])
			end
		end)
	end
end

function var0_0.saveUsedEmoji(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in pairs(arg0_15.usedEmoji) do
		table.insert(var0_15, iter0_15 .. "|" .. iter1_15)
	end

	local var1_15 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(ChatConst.EMOJI_SAVE_TAG .. var1_15, table.concat(var0_15, ":"))
end

function var0_0.getUsedEmoji(arg0_16)
	if not arg0_16.usedEmoji then
		arg0_16:loadUsedEmoji()
	end

	return arg0_16.usedEmoji
end

function var0_0.addUsedEmoji(arg0_17, arg1_17)
	local var0_17 = arg0_17:getUsedEmoji()

	var0_17[arg1_17] = (var0_17[arg1_17] or 0) + 1

	arg0_17:saveUsedEmoji()
end

function var0_0.loadUsedEmojiIcon(arg0_18)
	arg0_18.usedEmojiIcon = {}

	for iter0_18 = 1, 6 do
		arg0_18.usedEmojiIcon[iter0_18] = pg.emoji_small_template.all[iter0_18]
	end

	local var0_18 = getProxy(PlayerProxy):getRawData().id
	local var1_18 = string.split(PlayerPrefs.GetString(ChatConst.EMOJI_ICON_SAVE_TAG .. var0_18) or "", ":")

	if #var1_18 > 0 then
		for iter1_18, iter2_18 in ipairs(var1_18) do
			arg0_18.usedEmojiIcon[iter1_18] = tonumber(iter2_18)
		end
	end
end

function var0_0.saveUsedEmojiIcon(arg0_19)
	local var0_19 = {}

	for iter0_19, iter1_19 in ipairs(arg0_19.usedEmojiIcon) do
		table.insert(var0_19, iter1_19)
	end

	local var1_19 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(ChatConst.EMOJI_ICON_SAVE_TAG .. var1_19, table.concat(var0_19, ":"))
end

function var0_0.getUsedEmojiIcon(arg0_20)
	if not arg0_20.usedEmojiIcon then
		arg0_20:loadUsedEmojiIcon()
	end

	return arg0_20.usedEmojiIcon
end

function var0_0.addUsedEmojiIcon(arg0_21, arg1_21)
	local var0_21 = arg0_21:getUsedEmojiIcon()
	local var1_21 = table.indexof(var0_21, arg1_21, 1)

	if var1_21 then
		table.remove(var0_21, var1_21)
	else
		table.remove(var0_21, #var0_21)
	end

	table.insert(var0_21, 1, arg1_21)
	arg0_21:saveUsedEmojiIcon()
end

function var0_0.GetAllTypeChatMessages(arg0_22, arg1_22)
	local var0_22 = {}
	local var1_22 = getProxy(ChatProxy)

	if not var1_22 then
		return
	end

	_.each(var1_22:getRawData(), function(arg0_23)
		table.insert(var0_22, arg0_23)
	end)

	local var2_22 = getProxy(GuildProxy)

	if var2_22:getRawData() then
		_.each(var2_22:getChatMsgs(), function(arg0_24)
			table.insert(var0_22, arg0_24)
		end)
	end

	local var3_22 = getProxy(FriendProxy)

	_.each(var3_22:getCacheMsgList(), function(arg0_25)
		table.insert(var0_22, arg0_25)
	end)

	var0_22 = _(var0_22):chain():filter(function(arg0_26)
		return not var3_22:isInBlackList(arg0_26.playerId)
	end):sort(function(arg0_27, arg1_27)
		return arg0_27.timestamp < arg1_27.timestamp
	end):value()

	local var4_22 = NotificationLayer.ChannelBits.recv
	local var5_22 = bit.lshift(1, ChatConst.ChannelAll)

	var0_22 = _.filter(var0_22, function(arg0_28)
		return var4_22 == var5_22 or bit.band(var4_22, bit.lshift(1, arg0_28.type)) > 0
	end)
	var0_22 = _.slice(var0_22, #var0_22 - arg1_22 + 1, arg1_22)

	return var0_22
end

return var0_0
