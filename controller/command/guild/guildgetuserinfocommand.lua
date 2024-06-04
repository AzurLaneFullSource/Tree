local var0 = class("GuildGetUserInfoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(GuildProxy)

	if not var1:getData() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(60102, {
		type = 0
	}, 60103, function(arg0)
		local var0 = var1:getData()

		var0:updateUserInfo(arg0)
		var1:updateGuild(var0)
		arg0:sendNotification(GAME.GUILD_GET_USER_INFO_DONE)
	end)
end

return var0
