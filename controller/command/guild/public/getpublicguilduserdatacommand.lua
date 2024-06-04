local var0 = class("GetPublicGuildUserDataCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	seriesAsync({
		function(arg0)
			arg0:CreatePublicGuild(arg0)
		end,
		function(arg0)
			arg0:InitPublicGuild(arg0)
		end
	}, function()
		arg0:sendNotification(GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH)
		arg0:sendNotification(GAME.GET_PUBLIC_GUILD_USER_DATA_DONE)
	end)
end

function var0.CreatePublicGuild(arg0, arg1)
	pg.ConnectionMgr.GetInstance():Send(62100, {
		type = 0
	}, 62101, function(arg0)
		local var0 = PublicGuild.New(arg0)

		getProxy(GuildProxy):AddPublicGuild(var0)
		arg1()
	end)
end

function var0.InitPublicGuild(arg0, arg1)
	pg.ConnectionMgr.GetInstance():Send(60102, {
		type = 0
	}, 60103, function(arg0)
		getProxy(GuildProxy):GetPublicGuild():InitUser(arg0.user_info)
		arg1()
	end)
end

return var0
