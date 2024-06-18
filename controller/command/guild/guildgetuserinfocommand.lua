local var0_0 = class("GuildGetUserInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(GuildProxy)

	if not var1_1:getData() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(60102, {
		type = 0
	}, 60103, function(arg0_2)
		local var0_2 = var1_1:getData()

		var0_2:updateUserInfo(arg0_2)
		var1_1:updateGuild(var0_2)
		arg0_1:sendNotification(GAME.GUILD_GET_USER_INFO_DONE)
	end)
end

return var0_0
