local var0_0 = class("FinishBluePrintCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(TechnologyProxy)
	local var2_1 = var1_1:getBluePrintById(var0_1)

	if not var2_1 then
		return
	end

	if not var2_1:isFinished() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63202, {
		blueprint_id = var0_1
	}, 63203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = Ship.New(arg0_2.ship)

			getProxy(BayProxy):addShip(var0_2)
			var2_1:unlock(var0_2.id)
			var1_1:updateBluePrint(var2_1)
			arg0_1:sendNotification(GAME.FINISH_SHIP_BLUEPRINT_DONE, {
				ship = var0_2
			})

			local var1_2 = {
				[6] = true,
				[5] = true
			}

			if PLATFORM_CODE == PLATFORM_JP and var1_2[var2_1:getConfig("blueprint_version")] then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIPWORKS_COMPLETE, var0_2.configId)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("printblue_build_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
