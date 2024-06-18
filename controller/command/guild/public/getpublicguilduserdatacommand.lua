local var0_0 = class("GetPublicGuildUserDataCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	seriesAsync({
		function(arg0_2)
			arg0_1:CreatePublicGuild(arg0_2)
		end,
		function(arg0_3)
			arg0_1:InitPublicGuild(arg0_3)
		end
	}, function()
		arg0_1:sendNotification(GAME.HANDLE_GUILD_AND_PUBLIC_GUILD_TECH)
		arg0_1:sendNotification(GAME.GET_PUBLIC_GUILD_USER_DATA_DONE)
	end)
end

function var0_0.CreatePublicGuild(arg0_5, arg1_5)
	pg.ConnectionMgr.GetInstance():Send(62100, {
		type = 0
	}, 62101, function(arg0_6)
		local var0_6 = PublicGuild.New(arg0_6)

		getProxy(GuildProxy):AddPublicGuild(var0_6)
		arg1_5()
	end)
end

function var0_0.InitPublicGuild(arg0_7, arg1_7)
	pg.ConnectionMgr.GetInstance():Send(60102, {
		type = 0
	}, 60103, function(arg0_8)
		getProxy(GuildProxy):GetPublicGuild():InitUser(arg0_8.user_info)
		arg1_7()
	end)
end

return var0_0
