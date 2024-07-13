local var0_0 = class("GuildRequestRejectCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = arg1_1:getType()

	pg.ConnectionMgr.GetInstance():Send(60022, {
		player_id = var0_1
	}, 60023, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(GuildProxy):deleteRequest(var0_1)
			arg0_1:sendNotification(GAME.GUIDL_REQUEST_REJECT_DONE)

			if not var1_1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("guild_rejecet_apply_sucess"))
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("guild_reject_erro", arg0_2.result))
		end
	end)
end

return var0_0
