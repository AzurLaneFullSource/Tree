local var0_0 = class("GuildMemberMediator", import("..base.ContextMediator"))

var0_0.OPEN_DESC_INFO = "GuildMemberMediator:OPEN_DESC_INFO"
var0_0.FIRE = "GuildMemberMediator:FIRE"
var0_0.SET_DUTY = "GuildMemberMediator:SET_DUTY"
var0_0.IMPEACH = "GuildMemberMediator:IMPEACH"
var0_0.GET_RANK = "GuildMemberMediator:GET_RANK"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayerVO(var0_1)

	local var1_1 = getProxy(GuildProxy)

	arg0_1.viewComponent:setGuildVO(var1_1:getData())
	arg0_1:bind(var0_0.GET_RANK, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GUILD_GET_RANK, {
			id = arg1_2
		})
	end)
	arg0_1:bind(var0_0.OPEN_DESC_INFO, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.FRIEND_SEARCH, {
			type = SearchFriendCommand.SEARCH_TYPE_RESUME,
			keyword = arg1_3.id
		})
	end)
	arg0_1:bind(var0_0.FIRE, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.GUILD_FIRE, arg1_4)
	end)
	arg0_1:bind(var0_0.SET_DUTY, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.SET_GUILD_DUTY, {
			playerId = arg1_5,
			dutyId = arg2_5
		})
	end)
	arg0_1:bind(var0_0.IMPEACH, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.GUILD_IMPEACH, arg1_6)
	end)

	local var2_1 = getProxy(GuildProxy):GetRanks()

	arg0_1.viewComponent:SetRanks(var2_1)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GuildProxy.GUILD_UPDATED,
		GAME.SET_GUILD_DUTY_DONE,
		GAME.GUILD_FIRE_DONE,
		GAME.FRIEND_SEARCH_DONE,
		GAME.GUILD_GET_RANK_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GuildProxy.GUILD_UPDATED then
		arg0_8.viewComponent:setGuildVO(var1_8)
		arg0_8.viewComponent:RefreshMembers()
	elseif var0_8 == GAME.SET_GUILD_DUTY_DONE then
		arg0_8.viewComponent:LoadPainting(var1_8)
	elseif var0_8 == GAME.GUILD_FIRE_DONE then
		arg0_8.viewComponent:ActiveDefaultMenmber()
	elseif var0_8 == GAME.FRIEND_SEARCH_DONE then
		local var2_8 = var1_8.list[1]

		arg0_8.viewComponent:ShowInfoPanel(var2_8)
	elseif var0_8 == GAME.GUILD_GET_RANK_DONE then
		local var3_8 = var1_8.id
		local var4_8 = var1_8.list

		arg0_8.viewComponent:UpdateRankList(var3_8, var4_8)
	end
end

return var0_0
