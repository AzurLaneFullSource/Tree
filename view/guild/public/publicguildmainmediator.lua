local var0_0 = class("PublicGuildMainMediator", import("...base.ContextMediator"))

var0_0.ON_COMMIT = "PublicGuildMainMediator:ON_COMMIT"
var0_0.UPGRADE_TECH = "PublicGuildMainMediator:UPGRADE_TECH"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_COMMIT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.PUBLIC_GUILD_COMMIT_DONATE, {
			id = arg1_2
		})
	end)
	arg0_1:bind(var0_0.UPGRADE_TECH, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.PULIC_GUILD_UPGRADE_TECH, {
			id = arg1_3
		})
	end)

	local var0_1 = getProxy(GuildProxy):GetPublicGuild()

	arg0_1.viewComponent:SetPublicGuild(var0_1)
	arg0_1.viewComponent:SetPlayer(getProxy(PlayerProxy):getData())
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.PUBLIC_GUILD_COMMIT_DONATE_DONE,
		GAME.PUBLIC_GUILD_REFRESH_DONATE_LIST_DONE,
		PlayerProxy.UPDATED,
		GAME.PULIC_GUILD_UPGRADE_TECH_DONE,
		GAME.GET_PUBLIC_GUILD_USER_DATA_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.PUBLIC_GUILD_COMMIT_DONATE_DONE then
		arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5.awards)
		arg0_5.viewComponent:OnUpdateDonateList()
	elseif var0_5 == GAME.PUBLIC_GUILD_REFRESH_DONATE_LIST_DONE then
		arg0_5.viewComponent:OnUpdateDonateList()
	elseif var0_5 == PlayerProxy.UPDATED then
		arg0_5.viewComponent:OnPlayerUpdate(var1_5)
	elseif var0_5 == GAME.PULIC_GUILD_UPGRADE_TECH_DONE then
		arg0_5.viewComponent:OnTechGroupUpdate(var1_5.id)
	elseif var0_5 == GAME.GET_PUBLIC_GUILD_USER_DATA_DONE then
		local var2_5 = getProxy(GuildProxy):GetPublicGuild()

		arg0_5.viewComponent:SetPublicGuild(var2_5)
		arg0_5.viewComponent:RefreshAll()
	end
end

return var0_0
