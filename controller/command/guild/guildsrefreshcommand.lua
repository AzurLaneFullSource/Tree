local var0_0 = class("GuildsRefreshCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(60024, {
		type = 0
	}, 60025, function(arg0_2)
		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.guild_list) do
			local var1_2 = Guild.New(iter1_2)

			var1_2:SetMaxMemberCntAddition(iter1_2.tech_seat)

			local var2_2 = GuildMember.New(iter1_2.leader)

			var2_2:setDuty(GuildConst.DUTY_COMMANDER)
			var1_2:addMember(var2_2)
			table.insert(var0_2, var1_2)
		end

		arg0_1:sendNotification(GAME.GUILD_LIST_REFRESH_DONE, var0_2)
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_list_refresh_sucess"))
	end)
end

return var0_0
