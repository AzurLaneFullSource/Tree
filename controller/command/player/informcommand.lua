local var0 = class("InformCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.playerId
	local var2 = var0.info
	local var3 = var0.content

	if not var1 or not var2 or not var3 then
		return
	end

	if getProxy(PlayerProxy):getRawData().level < 20 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("inform_level_limit"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50111, {
		id = var1,
		info = var2,
		content = var3
	}, 50112, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(ChatProxy)

			table.insert(var0.informs, var1 .. var3)
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_sueecss"))
			arg0:sendNotification(GAME.INFORM_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_failed"))
		end
	end)
end

return var0
