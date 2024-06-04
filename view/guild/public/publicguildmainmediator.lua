local var0 = class("PublicGuildMainMediator", import("...base.ContextMediator"))

var0.ON_COMMIT = "PublicGuildMainMediator:ON_COMMIT"
var0.UPGRADE_TECH = "PublicGuildMainMediator:UPGRADE_TECH"

function var0.register(arg0)
	arg0:bind(var0.ON_COMMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.PUBLIC_GUILD_COMMIT_DONATE, {
			id = arg1
		})
	end)
	arg0:bind(var0.UPGRADE_TECH, function(arg0, arg1)
		arg0:sendNotification(GAME.PULIC_GUILD_UPGRADE_TECH, {
			id = arg1
		})
	end)

	local var0 = getProxy(GuildProxy):GetPublicGuild()

	arg0.viewComponent:SetPublicGuild(var0)
	arg0.viewComponent:SetPlayer(getProxy(PlayerProxy):getData())
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.PUBLIC_GUILD_COMMIT_DONATE_DONE,
		GAME.PUBLIC_GUILD_REFRESH_DONATE_LIST_DONE,
		PlayerProxy.UPDATED,
		GAME.PULIC_GUILD_UPGRADE_TECH_DONE,
		GAME.GET_PUBLIC_GUILD_USER_DATA_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.PUBLIC_GUILD_COMMIT_DONATE_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		arg0.viewComponent:OnUpdateDonateList()
	elseif var0 == GAME.PUBLIC_GUILD_REFRESH_DONATE_LIST_DONE then
		arg0.viewComponent:OnUpdateDonateList()
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:OnPlayerUpdate(var1)
	elseif var0 == GAME.PULIC_GUILD_UPGRADE_TECH_DONE then
		arg0.viewComponent:OnTechGroupUpdate(var1.id)
	elseif var0 == GAME.GET_PUBLIC_GUILD_USER_DATA_DONE then
		local var2 = getProxy(GuildProxy):GetPublicGuild()

		arg0.viewComponent:SetPublicGuild(var2)
		arg0.viewComponent:RefreshAll()
	end
end

return var0
