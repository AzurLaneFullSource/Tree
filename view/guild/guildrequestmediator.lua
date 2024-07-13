local var0_0 = class("GuildRequestMediator", import("..base.ContextMediator"))

var0_0.ACCPET = "GuildRequestMediator:ACCPET"
var0_0.REJECT = "GuildRequestMediator:REJECT"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(GuildProxy)

	arg0_1.guild = var0_1:getData()

	local var1_1 = var0_1:getSortRequest()

	if not var1_1 or var0_1.requestCount > 0 then
		arg0_1:sendNotification(GAME.GUILD_GET_REQUEST_LIST, arg0_1.guild.id)
		var0_1:ResetRequestCount()
	else
		arg0_1.viewComponent:setRequest(var1_1)
		arg0_1.viewComponent:initRequests()
	end

	arg0_1:bind(var0_0.ACCPET, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GUIDL_REQUEST_ACCEPT, arg1_2)
	end)
	arg0_1:bind(var0_0.REJECT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.GUIDL_REQUEST_REJECT, arg1_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GuildProxy.REQUEST_DELETED,
		GAME.GUILD_GET_REQUEST_LIST_DONE,
		GuildProxy.REQUEST_COUNT_UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GuildProxy.REQUEST_DELETED then
		arg0_5.viewComponent:deleteRequest(var1_5)
	elseif var0_5 == GAME.GUILD_GET_REQUEST_LIST_DONE then
		arg0_5.viewComponent:setRequest(var1_5)

		if not arg0_5.viewComponent.isInit then
			arg0_5.viewComponent.isInit = true

			arg0_5.viewComponent:initRequests()
		else
			arg0_5.viewComponent:SetTotalCount()
		end
	elseif var0_5 == GuildProxy.REQUEST_COUNT_UPDATED then
		arg0_5:sendNotification(GAME.GUILD_GET_REQUEST_LIST, arg0_5.guild.id)
		getProxy(GuildProxy):ResetRequestCount()
	end
end

return var0_0
