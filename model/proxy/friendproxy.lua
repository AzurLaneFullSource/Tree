local var0_0 = class("FriendProxy", import(".NetProxy"))

var0_0.FRIEND_ADDED = "FriendProxy friend added"
var0_0.FRIEND_REMOVED = "FriendProxy friend removed"
var0_0.FRIEND_NEW_MSG = "FriendProxy friend new msg"
var0_0.FRIEND_UPDATED = "FriendProxy friend updated"
var0_0.RELIEVE_BLACKLIST = "FriendProxy relieve blacklist"
var0_0.ADD_INTO_BLACKLIST = "FriendProxy add into blacklist"
var0_0.BLACK_LIST_UPDATED = "FriendProxy black list updated"

function var0_0.register(arg0_1)
	arg0_1:on(50000, function(arg0_2)
		arg0_1.data = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.friend_list) do
			local var0_2 = Friend.New(iter1_2)

			arg0_1.data[var0_2.id] = {
				player = var0_2,
				cacheMsgs = {}
			}
		end
	end)
	arg0_1:on(50008, function(arg0_3)
		local var0_3 = Friend.New(arg0_3.player)

		if not arg0_1.data[var0_3.id] then
			arg0_1:addFriend(var0_3)
		else
			arg0_1:updateFriend(var0_3)
		end
	end)
	arg0_1:on(50013, function(arg0_4)
		arg0_1:removeFriend(arg0_4.id)
	end)
	arg0_1:on(50104, function(arg0_5)
		local var0_5 = ChatMsg.New(ChatConst.ChannelFriend, {
			player = Player.New(arg0_5.msg.player),
			content = arg0_5.msg.content,
			timestamp = arg0_5.msg.timestamp
		})

		arg0_1:addChatMsg(var0_5.playerId, var0_5)

		local var1_5 = arg0_1:getFriend(var0_5.playerId)

		var1_5:increaseUnreadCount()
		arg0_1:updateFriend(var1_5)
	end)
end

function var0_0.removeFriend(arg0_6, arg1_6)
	local var0_6 = arg0_6.data[arg1_6]

	if var0_6 then
		arg0_6.data[arg1_6] = nil

		arg0_6:sendNotification(var0_0.FRIEND_REMOVED, var0_6.player)
	else
		print("不存在的好友: " .. arg1_6)
	end
end

function var0_0.getAllFriends(arg0_7)
	local var0_7 = {}

	for iter0_7, iter1_7 in pairs(arg0_7.data) do
		table.insert(var0_7, iter1_7.player)
	end

	return Clone(var0_7)
end

function var0_0.getAllCacheMsg(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.data) do
		var0_8[iter1_8.player.id] = iter1_8.cacheMsgs
	end

	return Clone(var0_8)
end

function var0_0.getCacheMsgList(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.data) do
		underscore.each(iter1_9.cacheMsgs, function(arg0_10)
			table.insert(var0_9, arg0_10)
		end)
	end

	return var0_9
end

function var0_0.getFriend(arg0_11, arg1_11)
	if arg0_11.data[arg1_11] then
		local var0_11 = arg0_11.data[arg1_11]

		return var0_11.player:clone(), var0_11.cacheMsgs
	end
end

function var0_0.addChatMsg(arg0_12, arg1_12, arg2_12)
	assert(isa(arg2_12, ChatMsg), "should be an instance of ChatMsg")

	if arg0_12.data[arg1_12] then
		local var0_12, var1_12 = wordVer(arg2_12.content, {
			isReplace = true
		})
		local var2_12

		string.gsub(var1_12, ChatConst.EmojiCodeMatch, function(arg0_13)
			var2_12 = tonumber(arg0_13)
		end)

		if var2_12 then
			local var3_12 = pg.emoji_template[var2_12]

			if var3_12 then
				var1_12 = var3_12.desc
			else
				var2_12 = nil
			end
		end

		arg2_12.content = var1_12
		arg2_12.emojiId = var2_12

		local var4_12 = arg0_12.data[arg1_12]

		table.insert(var4_12.cacheMsgs, arg2_12)
		arg2_12:display("added")
		arg0_12:sendNotification(var0_0.FRIEND_NEW_MSG, arg2_12)
	end
end

function var0_0.addFriend(arg0_14, arg1_14)
	assert(not arg0_14.data[arg1_14.id], "friend already eixst" .. arg1_14.id)
	arg1_14:display("added")

	arg0_14.data[arg1_14.id] = {
		player = arg1_14,
		cacheMsgs = {}
	}

	arg0_14:sendNotification(var0_0.FRIEND_ADDED, arg1_14:clone())
end

function var0_0.updateFriend(arg0_15, arg1_15)
	assert(arg0_15.data[arg1_15.id], "friend should eixst" .. arg1_15.id)

	arg0_15.data[arg1_15.id].player = arg1_15

	arg0_15:sendNotification(var0_0.FRIEND_UPDATED, arg1_15:clone())
end

function var0_0.isFriend(arg0_16, arg1_16)
	for iter0_16, iter1_16 in pairs(arg0_16.data) do
		if iter0_16 == arg1_16 then
			return true
		end
	end

	return false
end

function var0_0.getFriendCount(arg0_17)
	return table.getCount(arg0_17.data or {})
end

function var0_0.getNewMsgCount(arg0_18)
	local var0_18 = 0

	for iter0_18, iter1_18 in pairs(arg0_18.data) do
		if iter1_18.player.unreadCount > 0 then
			var0_18 = var0_18 + 1
		end
	end

	return var0_18
end

function var0_0.setBlackList(arg0_19, arg1_19)
	arg0_19.blackList = arg1_19

	arg0_19:sendNotification(var0_0.BLACK_LIST_UPDATED, Clone(arg1_19))
end

function var0_0.getBlackList(arg0_20)
	return Clone(arg0_20.blackList)
end

function var0_0.relieveBlackListById(arg0_21, arg1_21)
	assert(arg0_21.blackList[arg1_21], "friend should eixst>>" .. arg1_21)

	arg0_21.blackList[arg1_21] = nil

	arg0_21:sendNotification(var0_0.RELIEVE_BLACKLIST, arg1_21)
end

function var0_0.getBlackPlayerById(arg0_22, arg1_22)
	return arg0_22.blackList and Clone(arg0_22.blackList[arg1_22])
end

function var0_0.addIntoBlackList(arg0_23, arg1_23)
	if arg0_23.blackList then
		arg0_23.blackList[arg1_23.id] = arg1_23

		arg0_23:sendNotification(var0_0.ADD_INTO_BLACKLIST, Clone(arg1_23))
	end
end

function var0_0.isInBlackList(arg0_24, arg1_24)
	if arg0_24.blackList then
		return arg0_24.blackList[arg1_24]
	end
end

return var0_0
