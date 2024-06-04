local var0 = class("FetchEvaluationCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = getProxy(CollectionProxy)
	local var3 = var2:getShipGroup(var0)

	if not var3 then
		return
	end

	assert(var3, "shipGroup is nil" .. var0)

	if var1 - var3.lastReqStamp > ShipGroup.REQ_INTERVAL then
		pg.ConnectionMgr.GetInstance():Send(17101, {
			ship_group_id = var0
		}, 17102, function(arg0)
			local var0 = arg0.ship_discuss

			if var0 and var0.ship_group_id == var0 then
				if var3 then
					var3.evaluation = ShipEvaluation.New(var0)
					var3.lastReqStamp = pg.TimeMgr.GetInstance():GetServerTime()

					var2:updateShipGroup(var3)
					arg0:sendNotification(GAME.FETCH_EVALUATION_DONE, var0)
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("fetch_ship_eva", arg0.result))
			end
		end)
	elseif var3.evaluation then
		arg0:sendNotification(GAME.FETCH_EVALUATION_DONE, var0)
	end
end

return var0
