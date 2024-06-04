local var0 = class("GuildRequestRejectCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = arg1:getType()

	pg.ConnectionMgr.GetInstance():Send(60022, {
		player_id = var0
	}, 60023, function(arg0)
		if arg0.result == 0 then
			getProxy(GuildProxy):deleteRequest(var0)
			arg0:sendNotification(GAME.GUIDL_REQUEST_REJECT_DONE)

			if not var1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_rejecet_apply_sucess"))
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_reject_erro", arg0.result))
		end
	end)
end

return var0
