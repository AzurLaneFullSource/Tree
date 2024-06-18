local var0_0 = class("BackYardDeleteThemeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(DormProxy)

	if not var1_1:getThemeById(var0_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_no_exist"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(19022, {
		id = var0_1
	}, 19023, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:deleteTheme(var0_1)
			arg0_1:sendNotification(GAME.DELETE_BACKYARD_THEME_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("backayrd_theme_delete_sucess"))
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("backayrd_theme_delete_erro"))
		end
	end)
end

return var0_0
