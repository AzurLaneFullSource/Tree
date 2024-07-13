local var0_0 = class("GetShipEvaluationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().shipId

	pg.ConnectionMgr.GetInstance():Send(99999, {
		shipId = var0_1
	}, 99999, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy):getShipById(var0_1)

			arg0_1:sendNotification(GAME.GET_SHIP_EVALUATION_DONE, var0_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("get_ship_evaluation", arg0_2.result))
		end
	end)
end

return var0_0
