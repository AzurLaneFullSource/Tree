local var0 = class("GuildRequestAcceptCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(GuildProxy)
	local var2 = var1:getData()

	if var2.memberCount >= var2:getMaxMember() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_member_max_count"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(60020, {
		player_id = var0
	}, 60021, function(arg0)
		if arg0.result == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_new_member_join"))
			arg0:sendNotification(GAME.GUIDL_REQUEST_ACCEPT_DONE)
		elseif arg0.result == 4 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_player_in_cd_time"))
		elseif arg0.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_player_already_join"))
			arg0:sendNotification(GAME.GUIDL_REQUEST_REJECT, var0, true)
		elseif arg0.result == 4305 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_tip_grand_fleet_is_frozen"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_accept_erro", arg0.result))
		end

		var1:deleteRequest(var0)
	end)
end

return var0
