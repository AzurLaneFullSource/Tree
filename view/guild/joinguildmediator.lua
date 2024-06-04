local var0 = class("JoinGuildMediator", import("..base.ContextMediator"))

var0.APPLY = "JoinGuildMediator:APPLY"
var0.REFRESH = "JoinGuildMediator:REFRESH"
var0.SEARCH = "JoinGuildMediator:SEARCH"

function var0.register(arg0)
	arg0:sendNotification(GAME.GUILD_LIST_REFRESH)

	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayerVO(var0)
	arg0:bind(var0.APPLY, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GUILD_APPLY, {
			id = arg1,
			content = arg2
		})
	end)
	arg0:bind(var0.REFRESH, function(arg0)
		arg0:sendNotification(GAME.GUILD_LIST_REFRESH)
	end)
	arg0:bind(var0.SEARCH, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_SEARCH, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.GUILD_LIST_REFRESH_DONE,
		GAME.GUILD_SEARCH_DONE,
		GAME.GUILD_APPLY_DONE,
		GAME.REMOVE_LAYERS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.GUILD_LIST_REFRESH_DONE or var0 == GAME.GUILD_SEARCH_DONE then
		arg0.viewComponent:setGuildVOs(var1)

		if arg0.contextData.filterData then
			arg0.viewComponent:filter()
		else
			arg0.viewComponent:sortGuilds()
		end
	elseif var0 == GAME.GUILD_APPLY_DONE then
		arg0.viewComponent:CloseApply()
	end
end

return var0
