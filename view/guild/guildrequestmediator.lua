local var0 = class("GuildRequestMediator", import("..base.ContextMediator"))

var0.ACCPET = "GuildRequestMediator:ACCPET"
var0.REJECT = "GuildRequestMediator:REJECT"

function var0.register(arg0)
	local var0 = getProxy(GuildProxy)

	arg0.guild = var0:getData()

	local var1 = var0:getSortRequest()

	if not var1 or var0.requestCount > 0 then
		arg0:sendNotification(GAME.GUILD_GET_REQUEST_LIST, arg0.guild.id)
		var0:ResetRequestCount()
	else
		arg0.viewComponent:setRequest(var1)
		arg0.viewComponent:initRequests()
	end

	arg0:bind(var0.ACCPET, function(arg0, arg1)
		arg0:sendNotification(GAME.GUIDL_REQUEST_ACCEPT, arg1)
	end)
	arg0:bind(var0.REJECT, function(arg0, arg1)
		arg0:sendNotification(GAME.GUIDL_REQUEST_REJECT, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GuildProxy.REQUEST_DELETED,
		GAME.GUILD_GET_REQUEST_LIST_DONE,
		GuildProxy.REQUEST_COUNT_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GuildProxy.REQUEST_DELETED then
		arg0.viewComponent:deleteRequest(var1)
	elseif var0 == GAME.GUILD_GET_REQUEST_LIST_DONE then
		arg0.viewComponent:setRequest(var1)

		if not arg0.viewComponent.isInit then
			arg0.viewComponent.isInit = true

			arg0.viewComponent:initRequests()
		else
			arg0.viewComponent:SetTotalCount()
		end
	elseif var0 == GuildProxy.REQUEST_COUNT_UPDATED then
		arg0:sendNotification(GAME.GUILD_GET_REQUEST_LIST, arg0.guild.id)
		getProxy(GuildProxy):ResetRequestCount()
	end
end

return var0
