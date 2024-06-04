local var0 = class("CommanderChangeCatteryStyleCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.styleId
	local var3 = getProxy(CommanderProxy):GetCommanderHome()

	if not var3 then
		return
	end

	local var4 = var3:GetCatteryById(var1)

	if not var4 then
		return
	end

	if var4:GetStyle() == var2 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25032, {
		slotidx = var1,
		styleidx = var2
	}, 25033, function(arg0)
		if arg0.result == 0 then
			var4:UpdateStyle(var2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("cattery_style_change_success"))
			arg0:sendNotification(GAME.COMMANDER_CHANGE_CATTERY_STYLE_DONE, {
				id = var4.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
