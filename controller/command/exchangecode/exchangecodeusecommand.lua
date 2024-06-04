local var0 = class("ExchangeCodeUseCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().key
	local var1 = pg.SdkMgr.GetInstance():GetChannelUID()

	if var1 == "" then
		var1 = PLATFORM_LOCAL
	end

	pg.ConnectionMgr.GetInstance():Send(11508, {
		key = var0,
		platform = var1
	}, 11509, function(arg0)
		if arg0.result == 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("exchangecode_use_ok")
			})
			pg.m02:sendNotification(GAME.EXCHANGECODE_USE_SUCCESS)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("exchangecode_use", arg0.result))
		end
	end)
end

return var0
