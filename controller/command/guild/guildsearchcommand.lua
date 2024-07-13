local var0_0 = class("GuildSearchCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if not var0_1 or var0_1 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_should_input_keyword"))

		return
	end

	var0_1 = var0_1 and string.gsub(var0_1, "^%s*(.-)%s*$", "%1")

	local var1_1
	local var2_1 = tonumber(var0_1) and 0 or 1

	pg.ConnectionMgr.GetInstance():Send(60028, {
		type = var2_1,
		keyword = var0_1
	}, 60029, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.guild) do
				local var1_2 = Guild.New(iter1_2)

				var1_2:SetMaxMemberCntAddition(iter1_2.tech_seat)

				local var2_2 = GuildMember.New(iter1_2.leader)

				var2_2:setDuty(GuildConst.DUTY_COMMANDER)
				var1_2:addMember(var2_2)
				table.insert(var0_2, var1_2)
			end

			arg0_1:sendNotification(GAME.GUILD_SEARCH_DONE, var0_2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_search_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_no_exist"))
		end
	end)
end

return var0_0
