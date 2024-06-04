local var0 = class("ChapterBattleResultRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1.body or {}
	local var1 = var0.isSkipBattle

	pg.ConnectionMgr.GetInstance():Send(13106, {
		arg = 0
	}, 13105, function(arg0)
		getProxy(ChapterProxy):OnBattleFinished(arg0, var1)
		existCall(var0.callback)
	end)
end

return var0
