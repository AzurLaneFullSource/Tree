local var0_0 = class("NotificationProxy", import(".NetProxy"))

var0_0.FRIEND_REQUEST_ADDED = "note friend request added"
var0_0.FRIEND_REQUEST_REMOVED = "note friend request removed"

function var0_0.register(arg0_1)
	arg0_1:on(50000, function(arg0_2)
		arg0_1.data = {
			requests = {}
		}

		for iter0_2, iter1_2 in ipairs(arg0_2.request_list) do
			local var0_2 = ChatMsg.New(ChatConst.ChannelFriend, {
				player = Player.New(iter1_2.player),
				content = iter1_2.content,
				timestamp = iter1_2.timestamp
			})

			var0_2:display("request loaded")

			arg0_1.data.requests[var0_2.player.id] = var0_2
		end
	end)
	arg0_1:on(50005, function(arg0_3)
		local var0_3 = ChatMsg.New(ChatConst.ChannelFriend, {
			player = Player.New(arg0_3.msg.player),
			content = arg0_3.msg.content,
			timestamp = arg0_3.msg.timestamp
		})

		if not arg0_1.data.requests[var0_3.player.id] then
			arg0_1.data.requests[var0_3.player.id] = var0_3

			var0_3:display("new friend")

			if not getProxy(FriendProxy):isInBlackList(var0_3.player.id) then
				arg0_1:sendNotification(var0_0.FRIEND_REQUEST_ADDED, var0_3:clone())
			end
		end
	end)
end

function var0_0.getRequests(arg0_4)
	local var0_4 = {}
	local var1_4 = getProxy(FriendProxy)

	for iter0_4, iter1_4 in pairs(arg0_4.data.requests or {}) do
		if not var1_4:isInBlackList(iter0_4) then
			table.insert(var0_4, iter1_4)
		end
	end

	return var0_4
end

function var0_0.removeRequest(arg0_5, arg1_5)
	if arg0_5.data.requests[arg1_5] then
		local var0_5 = arg0_5.data.requests[arg1_5]

		var0_5:display("removed")

		arg0_5.data.requests[arg1_5] = nil

		arg0_5:sendNotification(var0_0.FRIEND_REQUEST_REMOVED, var0_5)
	end
end

function var0_0.removeAllRequest(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.data.requests) do
		arg0_6:removeRequest(iter0_6)
	end
end

function var0_0.getRequestCount(arg0_7)
	return #arg0_7:getRequests()
end

function var0_0.getUnreadCount(arg0_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in pairs(arg0_8.data.requests or {}) do
		var0_8 = var0_8 + 1
	end

	return var0_8
end

return var0_0
