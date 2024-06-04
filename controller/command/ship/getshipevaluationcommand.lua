local var0 = class("GetShipEvaluationCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().shipId

	pg.ConnectionMgr.GetInstance():Send(99999, {
		shipId = var0
	}, 99999, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy):getShipById(var0)

			arg0:sendNotification(GAME.GET_SHIP_EVALUATION_DONE, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("get_ship_evaluation", arg0.result))
		end
	end)
end

return var0
