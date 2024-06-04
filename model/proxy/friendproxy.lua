local var0 = class("FriendProxy", import(".NetProxy"))

var0.FRIEND_ADDED = "FriendProxy friend added"
var0.FRIEND_REMOVED = "FriendProxy friend removed"
var0.FRIEND_NEW_MSG = "FriendProxy friend new msg"
var0.FRIEND_UPDATED = "FriendProxy friend updated"
var0.RELIEVE_BLACKLIST = "FriendProxy relieve blacklist"
var0.ADD_INTO_BLACKLIST = "FriendProxy add into blacklist"
var0.BLACK_LIST_UPDATED = "FriendProxy black list updated"

function var0.register(arg0)
	arg0:on(50000, function(arg0)
		arg0.data = {}

		for iter0, iter1 in ipairs(arg0.friend_list) do
			local var0 = Friend.New(iter1)

			arg0.data[var0.id] = {
				player = var0,
				cacheMsgs = {}
			}
		end
	end)
	arg0:on(50008, function(arg0)
		local var0 = Friend.New(arg0.player)

		if not arg0.data[var0.id] then
			arg0:addFriend(var0)
		else
			arg0:updateFriend(var0)
		end
	end)
	arg0:on(50013, function(arg0)
		arg0:removeFriend(arg0.id)
	end)
	arg0:on(50104, function(arg0)
		local var0 = ChatMsg.New(ChatConst.ChannelFriend, {
			player = Player.New(arg0.msg.player),
			content = arg0.msg.content,
			timestamp = arg0.msg.timestamp
		})

		arg0:addChatMsg(var0.playerId, var0)

		local var1 = arg0:getFriend(var0.playerId)

		var1:increaseUnreadCount()
		arg0:updateFriend(var1)
	end)
end

function var0.removeFriend(arg0, arg1)
	local var0 = arg0.data[arg1]

	if var0 then
		arg0.data[arg1] = nil

		arg0:sendNotification(var0.FRIEND_REMOVED, var0.player)
	else
		print("不存在的好友: " .. arg1)
	end
end

function var0.getAllFriends(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		table.insert(var0, iter1.player)
	end

	return Clone(var0)
end

function var0.getAllCacheMsg(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		var0[iter1.player.id] = iter1.cacheMsgs
	end

	return Clone(var0)
end

function var0.getCacheMsgList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		underscore.each(iter1.cacheMsgs, function(arg0)
			table.insert(var0, arg0)
		end)
	end

	return var0
end

function var0.getFriend(arg0, arg1)
	if arg0.data[arg1] then
		local var0 = arg0.data[arg1]

		return var0.player:clone(), var0.cacheMsgs
	end
end

function var0.addChatMsg(arg0, arg1, arg2)
	assert(isa(arg2, ChatMsg), "should be an instance of ChatMsg")

	if arg0.data[arg1] then
		local var0, var1 = wordVer(arg2.content, {
			isReplace = true
		})
		local var2

		string.gsub(var1, ChatConst.EmojiCodeMatch, function(arg0)
			var2 = tonumber(arg0)
		end)

		if var2 then
			local var3 = pg.emoji_template[var2]

			if var3 then
				var1 = var3.desc
			else
				var2 = nil
			end
		end

		arg2.content = var1
		arg2.emojiId = var2

		local var4 = arg0.data[arg1]

		table.insert(var4.cacheMsgs, arg2)
		arg2:display("added")
		arg0:sendNotification(var0.FRIEND_NEW_MSG, arg2)
	end
end

function var0.addFriend(arg0, arg1)
	assert(not arg0.data[arg1.id], "friend already eixst" .. arg1.id)
	arg1:display("added")

	arg0.data[arg1.id] = {
		player = arg1,
		cacheMsgs = {}
	}

	arg0:sendNotification(var0.FRIEND_ADDED, arg1:clone())
end

function var0.updateFriend(arg0, arg1)
	assert(arg0.data[arg1.id], "friend should eixst" .. arg1.id)

	arg0.data[arg1.id].player = arg1

	arg0:sendNotification(var0.FRIEND_UPDATED, arg1:clone())
end

function var0.isFriend(arg0, arg1)
	for iter0, iter1 in pairs(arg0.data) do
		if iter0 == arg1 then
			return true
		end
	end

	return false
end

function var0.getFriendCount(arg0)
	return table.getCount(arg0.data or {})
end

function var0.getNewMsgCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data) do
		if iter1.player.unreadCount > 0 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.setBlackList(arg0, arg1)
	arg0.blackList = arg1

	arg0:sendNotification(var0.BLACK_LIST_UPDATED, Clone(arg1))
end

function var0.getBlackList(arg0)
	return Clone(arg0.blackList)
end

function var0.relieveBlackListById(arg0, arg1)
	assert(arg0.blackList[arg1], "friend should eixst>>" .. arg1)

	arg0.blackList[arg1] = nil

	arg0:sendNotification(var0.RELIEVE_BLACKLIST, arg1)
end

function var0.getBlackPlayerById(arg0, arg1)
	return arg0.blackList and Clone(arg0.blackList[arg1])
end

function var0.addIntoBlackList(arg0, arg1)
	if arg0.blackList then
		arg0.blackList[arg1.id] = arg1

		arg0:sendNotification(var0.ADD_INTO_BLACKLIST, Clone(arg1))
	end
end

function var0.isInBlackList(arg0, arg1)
	if arg0.blackList then
		return arg0.blackList[arg1]
	end
end

return var0
