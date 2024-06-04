local var0 = class("BackYardDeleteThemeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(DormProxy)

	if not var1:getThemeById(var0) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_no_exist"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(19022, {
		id = var0
	}, 19023, function(arg0)
		if arg0.result == 0 then
			var1:deleteTheme(var0)
			arg0:sendNotification(GAME.DELETE_BACKYARD_THEME_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("backayrd_theme_delete_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("backayrd_theme_delete_erro"))
		end
	end)
end

return var0
