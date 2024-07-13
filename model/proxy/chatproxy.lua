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

function var0_0.register(arg0_2)
	arg0_2:on(50101, function(arg0_3)
		if arg0_3.type == ChatConst.CODE_BANED then
			pg.TipsMgr.GetInstance():ShowTips(arg0_3.content)
		elseif arg0_3.type == ChatConst.CODE_ACTOBSS_MSG_WORD then
			local var0_3 = {
				name = arg0_3.player.name,
				score = arg0_3.content
			}

			arg0_2:sendNotification(GAME.ACTIVITY_BOSS_MSG_ADDED, var0_3)
			table.insert(arg0_2.actBossMsg, var0_3)

			if #arg0_2.actBossMsg > 6 then
				table.remove(arg0_2.actBossMsg, 1)
			end
		else
			local var1_3, var2_3 = wordVer(arg0_3.content, {
				isReplace = true
			})
			local var3_3

			string.gsub(var2_3, ChatConst.EmojiCodeMatch, function(arg0_4)
				var3_3 = tonumber(arg0_4)
			end)

			if var3_3 then
				local var4_3 = pg.emoji_template[var3_3]

				if var4_3 then
					var2_3 = var4_3.desc
				else
					var3_3 = nil
				end
			end

			local var5_3 = {
				player = Player.New(arg0_3.player),
				content = var2_3,
				emojiId = var3_3,
				timestamp = pg.TimeMgr.GetInstance():GetServerTime()
			}

			arg0_2:addNewMsg(ChatMsg.New(ChatConst.ChannelWorld, var5_3))
		end
	end)
	arg0_2:on(50103, function(arg0_5)
		local var0_5 = {}

		for iter0_5, iter1_5 in ipairs(arg0_5.arg_list) do
			table.insert(var0_5, PublicArg.New(iter1_5))
		end

		local var1_5 = {
			id = arg0_5.ad_id,
			args = var0_5,
			timestamp = pg.TimeMgr.GetInstance():GetServerTime()
		}

		arg0_2:addNewMsg(ChatMsg.New(ChatConst.ChannelPublic, var1_5))
	end)

	arg0_2.informs = {}
	arg0_2.actBossMsg = {}
end

function var0_0.addNewMsg(arg0_6, arg1_6)
	if arg1_6.id == 0 then
		arg0_6.top = arg1_6

		_.each(arg1_6.args, function(arg0_7)
			if arg0_7.string then
				pg.TipsMgr.GetInstance():ShowTips(arg0_7.string)
			end
		end)
	else
		table.insert(arg0_6.data, arg1_6)

		if #arg0_6.data > 100 then
			table.remove(arg0_6.data, 1)
		end
	end

	arg0_6:sendNotification(var0_0.NEW_MSG, arg1_6)
end

function var0_0.UpdateMsg(arg0_8, arg1_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.data) do
		if iter1_8:IsSame(arg1_8.uniqueId) then
			arg0_8.data[iter0_8] = arg1_8
		end
	end
end

function var0_0.GetMessagesByUniqueId(arg0_9, arg1_9)
	return _.select(arg0_9.data, function(arg0_10)
		return arg0_10.uniqueId == arg1_9
	end)
end

function var0_0.clearMsg(arg0_11)
	arg0_11.data = {}
end

function var0_0.loadUsedEmoji(arg0_12)
	arg0_12.usedEmoji = {}

	local var0_12 = getProxy(PlayerProxy):getRawData().id
	local var1_12 = string.split(PlayerPrefs.GetString(ChatConst.EMOJI_SAVE_TAG .. var0_12) or "", ":")

	if #var1_12 > 0 then
		_.each(var1_12, function(arg0_13)
			local var0_13 = string.split(arg0_13, "|")

			if #var0_13 == 2 then
				arg0_12.usedEmoji[tonumber(var0_13[1])] = tonumber(var0_13[2])
			end
		end)
	end
end

function var0_0.saveUsedEmoji(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(arg0_14.usedEmoji) do
		table.insert(var0_14, iter0_14 .. "|" .. iter1_14)
	end

	local var1_14 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(ChatConst.EMOJI_SAVE_TAG .. var1_14, table.concat(var0_14, ":"))
end

function var0_0.getUsedEmoji(arg0_15)
	if not arg0_15.usedEmoji then
		arg0_15:loadUsedEmoji()
	end

	return arg0_15.usedEmoji
end

function var0_0.addUsedEmoji(arg0_16, arg1_16)
	local var0_16 = arg0_16:getUsedEmoji()

	var0_16[arg1_16] = (var0_16[arg1_16] or 0) + 1

	arg0_16:saveUsedEmoji()
end

function var0_0.loadUsedEmojiIcon(arg0_17)
	arg0_17.usedEmojiIcon = {}

	for iter0_17 = 1, 6 do
		arg0_17.usedEmojiIcon[iter0_17] = pg.emoji_small_template.all[iter0_17]
	end

	local var0_17 = getProxy(PlayerProxy):getRawData().id
	local var1_17 = string.split(PlayerPrefs.GetString(ChatConst.EMOJI_ICON_SAVE_TAG .. var0_17) or "", ":")

	if #var1_17 > 0 then
		for iter1_17, iter2_17 in ipairs(var1_17) do
			arg0_17.usedEmojiIcon[iter1_17] = tonumber(iter2_17)
		end
	end
end

function var0_0.saveUsedEmojiIcon(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in ipairs(arg0_18.usedEmojiIcon) do
		table.insert(var0_18, iter1_18)
	end

	local var1_18 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(ChatConst.EMOJI_ICON_SAVE_TAG .. var1_18, table.concat(var0_18, ":"))
end

function var0_0.getUsedEmojiIcon(arg0_19)
	if not arg0_19.usedEmojiIcon then
		arg0_19:loadUsedEmojiIcon()
	end

	return arg0_19.usedEmojiIcon
end

function var0_0.addUsedEmojiIcon(arg0_20, arg1_20)
	local var0_20 = arg0_20:getUsedEmojiIcon()
	local var1_20 = table.indexof(var0_20, arg1_20, 1)

	if var1_20 then
		table.remove(var0_20, var1_20)
	else
		table.remove(var0_20, #var0_20)
	end

	table.insert(var0_20, 1, arg1_20)
	arg0_20:saveUsedEmojiIcon()
end

function var0_0.GetAllTypeChatMessages(arg0_21, arg1_21)
	local var0_21 = {}
	local var1_21 = getProxy(ChatProxy)

	if not var1_21 then
		return
	end

	_.each(var1_21:getRawData(), function(arg0_22)
		table.insert(var0_21, arg0_22)
	end)

	local var2_21 = getProxy(GuildProxy)

	if var2_21:getRawData() then
		_.each(var2_21:getChatMsgs(), function(arg0_23)
			table.insert(var0_21, arg0_23)
		end)
	end

	local var3_21 = getProxy(FriendProxy)

	_.each(var3_21:getCacheMsgList(), function(arg0_24)
		table.insert(var0_21, arg0_24)
	end)

	var0_21 = _(var0_21):chain():filter(function(arg0_25)
		return not var3_21:isInBlackList(arg0_25.playerId)
	end):sort(function(arg0_26, arg1_26)
		return arg0_26.timestamp < arg1_26.timestamp
	end):value()

	local var4_21 = NotificationLayer.ChannelBits.recv
	local var5_21 = bit.lshift(1, ChatConst.ChannelAll)

	var0_21 = _.filter(var0_21, function(arg0_27)
		return var4_21 == var5_21 or bit.band(var4_21, bit.lshift(1, arg0_27.type)) > 0
	end)
	var0_21 = _.slice(var0_21, #var0_21 - arg1_21 + 1, arg1_21)

	return var0_21
end

return var0_0
