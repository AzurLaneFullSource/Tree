local var0 = class("GuildSearchCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	if not var0 or var0 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_should_input_keyword"))

		return
	end

	var0 = var0 and string.gsub(var0, "^%s*(.-)%s*$", "%1")

	local var1
	local var2 = tonumber(var0) and 0 or 1

	pg.ConnectionMgr.GetInstance():Send(60028, {
		type = var2,
		keyword = var0
	}, 60029, function(arg0)
		if arg0.result == 0 then
			local var0 = {}

			for iter0, iter1 in ipairs(arg0.guild) do
				local var1 = Guild.New(iter1)

				var1:SetMaxMemberCntAddition(iter1.tech_seat)

				local var2 = GuildMember.New(iter1.leader)

				var2:setDuty(GuildConst.DUTY_COMMANDER)
				var1:addMember(var2)
				table.insert(var0, var1)
			end

			arg0:sendNotification(GAME.GUILD_SEARCH_DONE, var0)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_search_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_no_exist"))
		end
	end)
end

return var0
