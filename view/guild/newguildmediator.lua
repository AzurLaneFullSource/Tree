local var0_0 = class("NewGuildMediator", import("..base.ContextMediator"))

var0_0.OPEN_GUILD_LIST = "NewGuildMediator:OPEN_GUILD_LIST"
var0_0.CREATE = "NewGuildMediator:CREATE"
var0_0.OPEN_PUBLIC_GUILD = "NewGuildMediator:OPEN_PUBLIC_GUILD"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var0_1)
	arg0_1:bind(var0_0.OPEN_PUBLIC_GUILD, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.PUBLIC_GUILD)
	end)
	arg0_1:bind(var0_0.OPEN_GUILD_LIST, function(arg0_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = JoinGuildLayer,
			mediator = JoinGuildMediator
		}))
	end)
	arg0_1:bind(var0_0.CREATE, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.CREATE_GUILD, arg1_4)
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GuildProxy.NEW_GUILD_ADDED,
		PlayerProxy.UPDATED,
		GAME.CREATE_GUILD_DONE,
		GAME.REMOVE_LAYERS
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GuildProxy.NEW_GUILD_ADDED then
		arg0_6:sendNotification(GAME.GO_SCENE, SCENE.GUILD)
	elseif var0_6 == PlayerProxy.UPDATED then
		arg0_6.viewComponent:setPlayer(var1_6)
	elseif var0_6 == GAME.CREATE_GUILD_DONE then
		arg0_6.viewComponent:ClosePage()
	elseif var0_6 == GAME.REMOVE_LAYERS and var1_6.context.mediator == JoinGuildMediator then
		arg0_6.viewComponent:startCreate()
	end
end

return var0_0
