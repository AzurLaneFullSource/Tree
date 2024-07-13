local var0_0 = class("ChapterBattleResultRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1.body or {}
	local var1_1 = var0_1.isSkipBattle

	pg.ConnectionMgr.GetInstance():Send(13106, {
		arg = 0
	}, 13105, function(arg0_2)
		getProxy(ChapterProxy):OnBattleFinished(arg0_2, var1_1)
		existCall(var0_1.callback)
	end)
end

return var0_0
