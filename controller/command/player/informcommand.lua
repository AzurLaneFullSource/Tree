local var0_0 = class("InformCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.playerId
	local var2_1 = var0_1.info
	local var3_1 = var0_1.content

	if not var1_1 or not var2_1 or not var3_1 then
		return
	end

	if getProxy(PlayerProxy):getRawData().level < 20 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("inform_level_limit"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(50111, {
		id = var1_1,
		info = var2_1,
		content = var3_1
	}, 50112, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ChatProxy)

			table.insert(var0_2.informs, var1_1 .. var3_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_sueecss"))
			arg0_1:sendNotification(GAME.INFORM_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_failed"))
		end
	end)
end

return var0_0
