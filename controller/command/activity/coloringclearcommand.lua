local var0 = class("ColoringClearCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.activityId
	local var2 = var0.id

	pg.ConnectionMgr.GetInstance():Send(26006, {
		act_id = var1,
		id = var2
	}, 26007, function(arg0)
		if arg0.result == 0 then
			getProxy(ColoringProxy):getColorGroup(var2):clearFill()
			arg0:sendNotification(GAME.COLORING_CLEAR_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_clear", arg0.result))
		end
	end)
end

return var0
