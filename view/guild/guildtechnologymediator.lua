local var0 = class("GuildTechnologyMediator", import("..base.ContextMediator"))

var0.ON_UPGRADE = "GuildTechnologyMediator:ON_UPGRADE"
var0.ON_START = "GuildTechnologyMediator:ON_START"
var0.ON_CANCEL_TECH = "GuildTechnologyMediator:ON_CANCEL_TECH"
var0.ON_OPEN_OFFICE = "GuildTechnologyMediator:ON_OPEN_OFFICE"

function var0.register(arg0)
	arg0:bind(var0.ON_OPEN_OFFICE, function()
		arg0:sendNotification(var0.ON_OPEN_OFFICE)
	end)
	arg0:bind(var0.ON_CANCEL_TECH, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_CANCEL_TECH, {
			id = arg1
		})
	end)
	arg0:bind(var0.ON_UPGRADE, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_START_TECH, {
			id = arg1
		})
	end)
	arg0:bind(var0.ON_START, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_START_TECH_TASK, {
			id = arg1
		})
	end)

	local var0 = getProxy(GuildProxy):getData()

	arg0.viewComponent:setGuild(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		GuildProxy.GUILD_UPDATED,
		GuildProxy.DONATE_UPDTAE,
		GAME.GUILD_START_TECH_DONE,
		GuildProxy.TECHNOLOGY_START,
		GuildProxy.TECHNOLOGY_STOP,
		GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GuildProxy.GUILD_UPDATED then
		arg0.viewComponent:UpdateGuild(var1)
	elseif var0 == GAME.GUILD_START_TECH_DONE then
		arg0.viewComponent:UpdateUpgradeList()
	elseif var0 == GuildProxy.DONATE_UPDTAE or var0 == GuildProxy.TECHNOLOGY_START or var0 == GuildProxy.TECHNOLOGY_STOP then
		arg0.viewComponent:UpdateBreakOutList()
	elseif var0 == GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH_DONE then
		arg0.viewComponent:UpdateAll()
	end
end

return var0
