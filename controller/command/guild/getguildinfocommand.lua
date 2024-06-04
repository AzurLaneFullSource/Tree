local var0 = class("GetGuildInfoCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	if not getProxy(GuildProxy):getRawData() and not getProxy(GuildProxy).isFetchMainInfo then
		pg.ConnectionMgr.GetInstance():Send(60037, {
			type = 0
		}, 60000, function(arg0)
			getProxy(GuildProxy).isFetchMainInfo = true

			arg0:sendNotification(GAME.GET_GUILD_INFO_DONE)
		end)
	else
		arg0:sendNotification(GAME.GET_GUILD_INFO_DONE)
	end
end

return var0
