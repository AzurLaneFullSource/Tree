local var0_0 = class("NewEducateRefreshCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id

	pg.ConnectionMgr.GetInstance():Send(29092, {
		id = var0_1
	}, 29093, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):RefreshChar(var0_1, arg0_2.tb)
			NewEducateHelper.ClearEventPerformance()
			arg0_1:sendNotification(GAME.NEW_EDUCATE_REFRESH_DONE, {
				id = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_Refresh", arg0_2.result))
		end
	end)
end

return var0_0
