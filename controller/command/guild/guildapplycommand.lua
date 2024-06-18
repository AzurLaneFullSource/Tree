local var0_0 = class("GuildApplyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.content or ""

	if wordVer(var2_1) > 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_msg_forbid"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60005, {
		id = var1_1,
		content = var2_1
	}, 60006, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.GUILD_APPLY_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_apply_sucess"))
		elseif arg0_2.result == 4 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_join_cd"))
		elseif arg0_2.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_apply_full"))
		elseif arg0_2.result == 4305 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tip_grand_fleet_is_frozen"))
		elseif arg0_2.result == 4306 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_member_full"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_apply_erro", arg0_2.result))
		end
	end)
end

return var0_0
