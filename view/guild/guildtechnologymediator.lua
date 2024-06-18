local var0_0 = class("GuildTechnologyMediator", import("..base.ContextMediator"))

var0_0.ON_UPGRADE = "GuildTechnologyMediator:ON_UPGRADE"
var0_0.ON_START = "GuildTechnologyMediator:ON_START"
var0_0.ON_CANCEL_TECH = "GuildTechnologyMediator:ON_CANCEL_TECH"
var0_0.ON_OPEN_OFFICE = "GuildTechnologyMediator:ON_OPEN_OFFICE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_OPEN_OFFICE, function()
		arg0_1:sendNotification(var0_0.ON_OPEN_OFFICE)
	end)
	arg0_1:bind(var0_0.ON_CANCEL_TECH, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.GUILD_CANCEL_TECH, {
			id = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.GUILD_START_TECH, {
			id = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.GUILD_START_TECH_TASK, {
			id = arg1_5
		})
	end)

	local var0_1 = getProxy(GuildProxy):getData()

	arg0_1.viewComponent:setGuild(var0_1)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GuildProxy.GUILD_UPDATED,
		GuildProxy.DONATE_UPDTAE,
		GAME.GUILD_START_TECH_DONE,
		GuildProxy.TECHNOLOGY_START,
		GuildProxy.TECHNOLOGY_STOP,
		GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH_DONE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GuildProxy.GUILD_UPDATED then
		arg0_7.viewComponent:UpdateGuild(var1_7)
	elseif var0_7 == GAME.GUILD_START_TECH_DONE then
		arg0_7.viewComponent:UpdateUpgradeList()
	elseif var0_7 == GuildProxy.DONATE_UPDTAE or var0_7 == GuildProxy.TECHNOLOGY_START or var0_7 == GuildProxy.TECHNOLOGY_STOP then
		arg0_7.viewComponent:UpdateBreakOutList()
	elseif var0_7 == GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH_DONE then
		arg0_7.viewComponent:UpdateAll()
	end
end

return var0_0
