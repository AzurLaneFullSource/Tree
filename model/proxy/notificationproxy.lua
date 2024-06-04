local var0 = class("NotificationProxy", import(".NetProxy"))

var0.FRIEND_REQUEST_ADDED = "note friend request added"
var0.FRIEND_REQUEST_REMOVED = "note friend request removed"

function var0.register(arg0)
	arg0:on(50000, function(arg0)
		arg0.data = {
			requests = {}
		}

		for iter0, iter1 in ipairs(arg0.request_list) do
			local var0 = ChatMsg.New(ChatConst.ChannelFriend, {
				player = Player.New(iter1.player),
				content = iter1.content,
				timestamp = iter1.timestamp
			})

			var0:display("request loaded")

			arg0.data.requests[var0.player.id] = var0
		end
	end)
	arg0:on(50005, function(arg0)
		local var0 = ChatMsg.New(ChatConst.ChannelFriend, {
			player = Player.New(arg0.msg.player),
			content = arg0.msg.content,
			timestamp = arg0.msg.timestamp
		})

		if not arg0.data.requests[var0.player.id] then
			arg0.data.requests[var0.player.id] = var0

			var0:display("new friend")

			if not getProxy(FriendProxy):isInBlackList(var0.player.id) then
				arg0:sendNotification(var0.FRIEND_REQUEST_ADDED, var0:clone())
			end
		end
	end)
end

function var0.getRequests(arg0)
	local var0 = {}
	local var1 = getProxy(FriendProxy)

	for iter0, iter1 in pairs(arg0.data.requests or {}) do
		if not var1:isInBlackList(iter0) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.removeRequest(arg0, arg1)
	if arg0.data.requests[arg1] then
		local var0 = arg0.data.requests[arg1]

		var0:display("removed")

		arg0.data.requests[arg1] = nil

		arg0:sendNotification(var0.FRIEND_REQUEST_REMOVED, var0)
	end
end

function var0.removeAllRequest(arg0)
	for iter0, iter1 in pairs(arg0.data.requests) do
		arg0:removeRequest(iter0)
	end
end

function var0.getRequestCount(arg0)
	return #arg0:getRequests()
end

function var0.getUnreadCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0.data.requests or {}) do
		var0 = var0 + 1
	end

	return var0
end

return var0
