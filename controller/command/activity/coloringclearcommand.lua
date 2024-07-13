local var0_0 = class("ColoringClearCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.activityId
	local var2_1 = var0_1.id

	pg.ConnectionMgr.GetInstance():Send(26006, {
		act_id = var1_1,
		id = var2_1
	}, 26007, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(ColoringProxy):getColorGroup(var2_1):clearFill()
			arg0_1:sendNotification(GAME.COLORING_CLEAR_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_clear", arg0_2.result))
		end
	end)
end

return var0_0
