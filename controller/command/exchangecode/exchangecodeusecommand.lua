local var0_0 = class("ExchangeCodeUseCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().key
	local var1_1 = pg.SdkMgr.GetInstance():GetChannelUID()

	if var1_1 == "" then
		var1_1 = PLATFORM_LOCAL
	end

	pg.ConnectionMgr.GetInstance():Send(11508, {
		key = var0_1,
		platform = var1_1
	}, 11509, function(arg0_2)
		if arg0_2.result == 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("exchangecode_use_ok")
			})
			pg.m02:sendNotification(GAME.EXCHANGECODE_USE_SUCCESS)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("exchangecode_use", arg0_2.result))
		end
	end)
end

return var0_0
