local var0_0 = class("IslandFriendMediator", import("view.friend.FriendMediator"))

var0_0.MODIFY_ACCESS_TYPE = "IslandFriendMediator:MODIFY_ACCESS_TYPE"
var0_0.ACCESS_OP = "IslandFriendMediator:ACCESS_OP"
var0_0.ENTER_ISLAND = "IslandFriendMediator:ENTER_ISLAND"

function var0_0.register(arg0_1)
	var0_0.super.register(arg0_1)
	arg0_1:bind(var0_0.MODIFY_ACCESS_TYPE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ISLAND_SET_ACCESS_TYPE, {
			flag = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ACCESS_OP, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.ISLAND_ACCESS_OP, {
			op = arg1_3,
			list = arg2_3
		})
	end)
	arg0_1:bind(var0_0.ENTER_ISLAND, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ISLAND_ENTER, {
			id = arg1_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	local var0_5 = var0_0.super.listNotificationInterests(arg0_5)
	local var1_5 = {
		GAME.ISLAND_ACCESS_OP_DONE
	}

	for iter0_5, iter1_5 in ipairs(var1_5) do
		table.insert(var0_5, iter1_5)
	end

	return var0_5
end

function var0_0.handleNotification(arg0_6, arg1_6)
	var0_0.super.handleNotification(arg0_6, arg1_6)

	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.ISLAND_ACCESS_OP_DONE and var1_6.op == IslandConst.ACCESS_OP_SET_WHITELIST then
		arg0_6.viewComponent:UpdateWhiteList()
	end
end

return var0_0
