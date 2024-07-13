local var0_0 = class("GuildRequestAcceptCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(GuildProxy)
	local var2_1 = var1_1:getData()

	if var2_1.memberCount >= var2_1:getMaxMember() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_member_max_count"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60020, {
		player_id = var0_1
	}, 60021, function(arg0_2)
		if arg0_2.result == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_new_member_join"))
			arg0_1:sendNotification(GAME.GUIDL_REQUEST_ACCEPT_DONE)
		elseif arg0_2.result == 4 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_player_in_cd_time"))
		elseif arg0_2.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_player_already_join"))
			arg0_1:sendNotification(GAME.GUIDL_REQUEST_REJECT, var0_1, true)
		elseif arg0_2.result == 4305 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tip_grand_fleet_is_frozen"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_accept_erro", arg0_2.result))
		end

		var1_1:deleteRequest(var0_1)
	end)
end

return var0_0
