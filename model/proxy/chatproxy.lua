local var0 = class("ChatProxy", import(".NetProxy"))

var0.NEW_MSG = "ChatProxy public msg"

function var0.InjectPublic(arg0, arg1, arg2)
	if arg1.id == 0 then
		arg0.text = arg1.args[1] and arg1.args[1].string or ""

		return
	end

	local var0 = i18n("ad_" .. arg1.id)

	for iter0 = 1, #arg1.args do
		local var1 = arg1.args[iter0]
		local var2

		if var1.type == PublicArg.TypePlayerName then
			var2 = var1.string
		elseif var1.type == PublicArg.TypeShipId then
			local var3 = pg.ship_data_statistics[var1.int]
			local var4 = "shiptype" .. iter0
			local var5 = GetSpriteFromAtlas("shiptype", shipType2print(var3.type))

			arg0:AddSprite(var4, var5)

			local var6 = "shipcolor" .. iter0

			var0 = string.gsub(var0, var6, ItemRarity.Rarity2HexColor(var3.rarity - 1))
			var2 = var3.name

			if arg2 then
				local var7 = false

				if PLATFORM_CODE == PLATFORM_JP then
					var7, var2 = contentWrap(var2, 18, 1.65)
				end

				if var7 then
					var2 = var2 .. "..." or var2
				end
			end
		elseif var1.type == PublicArg.TypeEquipId then
			var2 = pg.equip_data_statistics[var1.int].name
		elseif var1.type == PublicArg.TypeItemId then
			var2 = Item.getConfigData(var1.int).name
		elseif var1.type == PublicArg.TypeNums then
			var2 = var1.int
		elseif var1.type == PublicArg.TypeWorldBoss then
			var2 = var1.string
		else
			var2 = var1.string
		end

		var0 = string.gsub(var0, "$" .. iter0, var2)
	end

	arg0.text = var0
end

function var0.register(arg0)
	arg0:on(50101, function(arg0)
		if arg0.type == ChatConst.CODE_BANED then
			pg.TipsMgr.GetInstance():ShowTips(arg0.content)
		elseif arg0.type == ChatConst.CODE_ACTOBSS_MSG_WORD then
			local var0 = {
				name = arg0.player.name,
				score = arg0.content
			}

			arg0:sendNotification(GAME.ACTIVITY_BOSS_MSG_ADDED, var0)
			table.insert(arg0.actBossMsg, var0)

			if #arg0.actBossMsg > 6 then
				table.remove(arg0.actBossMsg, 1)
			end
		else
			local var1, var2 = wordVer(arg0.content, {
				isReplace = true
			})
			local var3

			string.gsub(var2, ChatConst.EmojiCodeMatch, function(arg0)
				var3 = tonumber(arg0)
			end)

			if var3 then
				local var4 = pg.emoji_template[var3]

				if var4 then
					var2 = var4.desc
				else
					var3 = nil
				end
			end

			local var5 = {
				player = Player.New(arg0.player),
				content = var2,
				emojiId = var3,
				timestamp = pg.TimeMgr.GetInstance():GetServerTime()
			}

			arg0:addNewMsg(ChatMsg.New(ChatConst.ChannelWorld, var5))
		end
	end)
	arg0:on(50103, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.arg_list) do
			table.insert(var0, PublicArg.New(iter1))
		end

		local var1 = {
			id = arg0.ad_id,
			args = var0,
			timestamp = pg.TimeMgr.GetInstance():GetServerTime()
		}

		arg0:addNewMsg(ChatMsg.New(ChatConst.ChannelPublic, var1))
	end)

	arg0.informs = {}
	arg0.actBossMsg = {}
end

function var0.addNewMsg(arg0, arg1)
	if arg1.id == 0 then
		arg0.top = arg1

		_.each(arg1.args, function(arg0)
			if arg0.string then
				pg.TipsMgr.GetInstance():ShowTips(arg0.string)
			end
		end)
	else
		table.insert(arg0.data, arg1)

		if #arg0.data > 100 then
			table.remove(arg0.data, 1)
		end
	end

	arg0:sendNotification(var0.NEW_MSG, arg1)
end

function var0.UpdateMsg(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.data) do
		if iter1:IsSame(arg1.uniqueId) then
			arg0.data[iter0] = arg1
		end
	end
end

function var0.GetMessagesByUniqueId(arg0, arg1)
	return _.select(arg0.data, function(arg0)
		return arg0.uniqueId == arg1
	end)
end

function var0.clearMsg(arg0)
	arg0.data = {}
end

function var0.loadUsedEmoji(arg0)
	arg0.usedEmoji = {}

	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = string.split(PlayerPrefs.GetString(ChatConst.EMOJI_SAVE_TAG .. var0) or "", ":")

	if #var1 > 0 then
		_.each(var1, function(arg0)
			local var0 = string.split(arg0, "|")

			if #var0 == 2 then
				arg0.usedEmoji[tonumber(var0[1])] = tonumber(var0[2])
			end
		end)
	end
end

function var0.saveUsedEmoji(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.usedEmoji) do
		table.insert(var0, iter0 .. "|" .. iter1)
	end

	local var1 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(ChatConst.EMOJI_SAVE_TAG .. var1, table.concat(var0, ":"))
end

function var0.getUsedEmoji(arg0)
	if not arg0.usedEmoji then
		arg0:loadUsedEmoji()
	end

	return arg0.usedEmoji
end

function var0.addUsedEmoji(arg0, arg1)
	local var0 = arg0:getUsedEmoji()

	var0[arg1] = (var0[arg1] or 0) + 1

	arg0:saveUsedEmoji()
end

function var0.loadUsedEmojiIcon(arg0)
	arg0.usedEmojiIcon = {}

	for iter0 = 1, 6 do
		arg0.usedEmojiIcon[iter0] = pg.emoji_small_template.all[iter0]
	end

	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = string.split(PlayerPrefs.GetString(ChatConst.EMOJI_ICON_SAVE_TAG .. var0) or "", ":")

	if #var1 > 0 then
		for iter1, iter2 in ipairs(var1) do
			arg0.usedEmojiIcon[iter1] = tonumber(iter2)
		end
	end
end

function var0.saveUsedEmojiIcon(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.usedEmojiIcon) do
		table.insert(var0, iter1)
	end

	local var1 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(ChatConst.EMOJI_ICON_SAVE_TAG .. var1, table.concat(var0, ":"))
end

function var0.getUsedEmojiIcon(arg0)
	if not arg0.usedEmojiIcon then
		arg0:loadUsedEmojiIcon()
	end

	return arg0.usedEmojiIcon
end

function var0.addUsedEmojiIcon(arg0, arg1)
	local var0 = arg0:getUsedEmojiIcon()
	local var1 = table.indexof(var0, arg1, 1)

	if var1 then
		table.remove(var0, var1)
	else
		table.remove(var0, #var0)
	end

	table.insert(var0, 1, arg1)
	arg0:saveUsedEmojiIcon()
end

function var0.GetAllTypeChatMessages(arg0, arg1)
	local var0 = {}
	local var1 = getProxy(ChatProxy)

	if not var1 then
		return
	end

	_.each(var1:getRawData(), function(arg0)
		table.insert(var0, arg0)
	end)

	local var2 = getProxy(GuildProxy)

	if var2:getRawData() then
		_.each(var2:getChatMsgs(), function(arg0)
			table.insert(var0, arg0)
		end)
	end

	local var3 = getProxy(FriendProxy)

	_.each(var3:getCacheMsgList(), function(arg0)
		table.insert(var0, arg0)
	end)

	var0 = _(var0):chain():filter(function(arg0)
		return not var3:isInBlackList(arg0.playerId)
	end):sort(function(arg0, arg1)
		return arg0.timestamp < arg1.timestamp
	end):value()

	local var4 = NotificationLayer.ChannelBits.recv
	local var5 = bit.lshift(1, ChatConst.ChannelAll)

	var0 = _.filter(var0, function(arg0)
		return var4 == var5 or bit.band(var4, bit.lshift(1, arg0.type)) > 0
	end)
	var0 = _.slice(var0, #var0 - arg1 + 1, arg1)

	return var0
end

return var0
