local var0 = class("GuildApplyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.content or ""

	if wordVer(var2) > 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_msg_forbid"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60005, {
		id = var1,
		content = var2
	}, 60006, function(arg0)
		if arg0.result == 0 then
			arg0:sendNotification(GAME.GUILD_APPLY_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_apply_sucess"))
		elseif arg0.result == 4 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_join_cd"))
		elseif arg0.result == 6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_apply_full"))
		elseif arg0.result == 4305 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tip_grand_fleet_is_frozen"))
		elseif arg0.result == 4306 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_member_full"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_apply_erro", arg0.result))
		end
	end)
end

return var0
