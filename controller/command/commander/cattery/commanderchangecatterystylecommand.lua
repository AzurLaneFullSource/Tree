local var0_0 = class("CommanderChangeCatteryStyleCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.styleId
	local var3_1 = getProxy(CommanderProxy):GetCommanderHome()

	if not var3_1 then
		return
	end

	local var4_1 = var3_1:GetCatteryById(var1_1)

	if not var4_1 then
		return
	end

	if var4_1:GetStyle() == var2_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25032, {
		slotidx = var1_1,
		styleidx = var2_1
	}, 25033, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:UpdateStyle(var2_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("cattery_style_change_success"))
			arg0_1:sendNotification(GAME.COMMANDER_CHANGE_CATTERY_STYLE_DONE, {
				id = var4_1.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
