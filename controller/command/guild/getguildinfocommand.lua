local var0_0 = class("GetGuildInfoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if not getProxy(GuildProxy):getRawData() and not getProxy(GuildProxy).isFetchMainInfo then
		pg.ConnectionMgr.GetInstance():Send(60037, {
			type = 0
		}, 60000, function(arg0_2)
			getProxy(GuildProxy).isFetchMainInfo = true

			arg0_1:sendNotification(GAME.GET_GUILD_INFO_DONE)
		end)
	else
		arg0_1:sendNotification(GAME.GET_GUILD_INFO_DONE)
	end
end

return var0_0
