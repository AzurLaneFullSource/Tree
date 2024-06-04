local var0 = class("GuildMemberMediator", import("..base.ContextMediator"))

var0.OPEN_DESC_INFO = "GuildMemberMediator:OPEN_DESC_INFO"
var0.FIRE = "GuildMemberMediator:FIRE"
var0.SET_DUTY = "GuildMemberMediator:SET_DUTY"
var0.IMPEACH = "GuildMemberMediator:IMPEACH"
var0.GET_RANK = "GuildMemberMediator:GET_RANK"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayerVO(var0)

	local var1 = getProxy(GuildProxy)

	arg0.viewComponent:setGuildVO(var1:getData())
	arg0:bind(var0.GET_RANK, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_GET_RANK, {
			id = arg1
		})
	end)
	arg0:bind(var0.OPEN_DESC_INFO, function(arg0, arg1)
		arg0:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1.id
		})
	end)
	arg0:bind(var0.FIRE, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_FIRE, arg1)
	end)
	arg0:bind(var0.SET_DUTY, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SET_GUILD_DUTY, {
			playerId = arg1,
			dutyId = arg2
		})
	end)
	arg0:bind(var0.IMPEACH, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_IMPEACH, arg1)
	end)

	local var2 = getProxy(GuildProxy):GetRanks()

	arg0.viewComponent:SetRanks(var2)
end

function var0.listNotificationInterests(arg0)
	return {
		GuildProxy.GUILD_UPDATED,
		GAME.SET_GUILD_DUTY_DONE,
		GAME.GUILD_FIRE_DONE,
		GAME.FRIEND_SEARCH_DONE,
		GAME.GUILD_GET_RANK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GuildProxy.GUILD_UPDATED then
		arg0.viewComponent:setGuildVO(var1)
		arg0.viewComponent:RefreshMembers()
	elseif var0 == GAME.SET_GUILD_DUTY_DONE then
		arg0.viewComponent:LoadPainting(var1)
	elseif var0 == GAME.GUILD_FIRE_DONE then
		arg0.viewComponent:ActiveDefaultMenmber()
	elseif var0 == GAME.FRIEND_SEARCH_DONE then
		local var2 = var1.list[1]

		arg0.viewComponent:ShowInfoPanel(var2)
	elseif var0 == GAME.GUILD_GET_RANK_DONE then
		local var3 = var1.id
		local var4 = var1.list

		arg0.viewComponent:UpdateRankList(var3, var4)
	end
end

return var0
