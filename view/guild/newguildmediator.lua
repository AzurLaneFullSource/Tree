local var0 = class("NewGuildMediator", import("..base.ContextMediator"))

var0.OPEN_GUILD_LIST = "NewGuildMediator:OPEN_GUILD_LIST"
var0.CREATE = "NewGuildMediator:CREATE"
var0.OPEN_PUBLIC_GUILD = "NewGuildMediator:OPEN_PUBLIC_GUILD"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var0)
	arg0:bind(var0.OPEN_PUBLIC_GUILD, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.PUBLIC_GUILD)
	end)
	arg0:bind(var0.OPEN_GUILD_LIST, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = JoinGuildLayer,
			mediator = JoinGuildMediator
		}))
	end)
	arg0:bind(var0.CREATE, function(arg0, arg1)
		arg0:sendNotification(GAME.CREATE_GUILD, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GuildProxy.NEW_GUILD_ADDED,
		PlayerProxy.UPDATED,
		GAME.CREATE_GUILD_DONE,
		GAME.REMOVE_LAYERS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GuildProxy.NEW_GUILD_ADDED then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.GUILD)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.CREATE_GUILD_DONE then
		arg0.viewComponent:ClosePage()
	elseif var0 == GAME.REMOVE_LAYERS and var1.context.mediator == JoinGuildMediator then
		arg0.viewComponent:startCreate()
	end
end

return var0
