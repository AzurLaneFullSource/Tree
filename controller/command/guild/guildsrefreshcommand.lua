local var0 = class("GuildsRefreshCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(60024, {
		type = 0
	}, 60025, function(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0.guild_list) do
			local var1 = Guild.New(iter1)

			var1:SetMaxMemberCntAddition(iter1.tech_seat)

			local var2 = GuildMember.New(iter1.leader)

			var2:setDuty(GuildConst.DUTY_COMMANDER)
			var1:addMember(var2)
			table.insert(var0, var1)
		end

		arg0:sendNotification(GAME.GUILD_LIST_REFRESH_DONE, var0)
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_list_refresh_sucess"))
	end)
end

return var0
