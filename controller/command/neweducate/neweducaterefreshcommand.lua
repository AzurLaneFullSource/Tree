local var0_0 = class("NewEducateRefreshCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.difficulty
	local var3_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(29092, {
		id = var1_1,
		difficulty = var2_1
	}, 29093, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(NewEducateProxy):RefreshChar(var1_1, arg0_2.tb)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_REFRESH_DONE, {
				id = var1_1
			})
			existCall(var3_1)
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_Refresh: " .. arg0_2.result)
		end
	end)
end

return var0_0
