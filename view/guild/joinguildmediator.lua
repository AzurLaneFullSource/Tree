local var0_0 = class("JoinGuildMediator", import("..base.ContextMediator"))

var0_0.APPLY = "JoinGuildMediator:APPLY"
var0_0.REFRESH = "JoinGuildMediator:REFRESH"
var0_0.SEARCH = "JoinGuildMediator:SEARCH"

function var0_0.register(arg0_1)
	arg0_1:sendNotification(GAME.GUILD_LIST_REFRESH)

	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayerVO(var0_1)
	arg0_1:bind(var0_0.APPLY, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.GUILD_APPLY, {
			id = arg1_2,
			content = arg2_2
		})
	end)
	arg0_1:bind(var0_0.REFRESH, function(arg0_3)
		arg0_1:sendNotification(GAME.GUILD_LIST_REFRESH)
	end)
	arg0_1:bind(var0_0.SEARCH, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.GUILD_SEARCH, arg1_4)
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.GUILD_LIST_REFRESH_DONE,
		GAME.GUILD_SEARCH_DONE,
		GAME.GUILD_APPLY_DONE,
		GAME.REMOVE_LAYERS
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.GUILD_LIST_REFRESH_DONE or var0_6 == GAME.GUILD_SEARCH_DONE then
		arg0_6.viewComponent:setGuildVOs(var1_6)

		if arg0_6.contextData.filterData then
			arg0_6.viewComponent:filter()
		else
			arg0_6.viewComponent:sortGuilds()
		end
	elseif var0_6 == GAME.GUILD_APPLY_DONE then
		arg0_6.viewComponent:CloseApply()
	end
end

return var0_0
