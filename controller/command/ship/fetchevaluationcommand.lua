local var0_0 = class("FetchEvaluationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_1 = getProxy(CollectionProxy)
	local var3_1 = var2_1:getShipGroup(var0_1)

	if not var3_1 then
		return
	end

	assert(var3_1, "shipGroup is nil" .. var0_1)

	if var1_1 - var3_1.lastReqStamp > ShipGroup.REQ_INTERVAL then
		pg.ConnectionMgr.GetInstance():Send(17101, {
			ship_group_id = var0_1
		}, 17102, function(arg0_2)
			local var0_2 = arg0_2.ship_discuss

			if var0_2 and var0_2.ship_group_id == var0_1 then
				if var3_1 then
					var3_1.evaluation = ShipEvaluation.New(var0_2)
					var3_1.lastReqStamp = pg.TimeMgr.GetInstance():GetServerTime()

					var2_1:updateShipGroup(var3_1)
					arg0_1:sendNotification(GAME.FETCH_EVALUATION_DONE, var0_1)
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("fetch_ship_eva", arg0_2.result))
			end
		end)
	elseif var3_1.evaluation then
		arg0_1:sendNotification(GAME.FETCH_EVALUATION_DONE, var0_1)
	end
end

return var0_0
