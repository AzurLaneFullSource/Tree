local var0 = class("FinishBluePrintCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(TechnologyProxy)
	local var2 = var1:getBluePrintById(var0)

	if not var2 then
		return
	end

	if not var2:isFinished() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63202, {
		blueprint_id = var0
	}, 63203, function(arg0)
		if arg0.result == 0 then
			local var0 = Ship.New(arg0.ship)

			getProxy(BayProxy):addShip(var0)
			var2:unlock(var0.id)
			var1:updateBluePrint(var2)
			arg0:sendNotification(GAME.FINISH_SHIP_BLUEPRINT_DONE, {
				ship = var0
			})

			local var1 = {
				[6] = true,
				[5] = true
			}

			if PLATFORM_CODE == PLATFORM_JP and var1[var2:getConfig("blueprint_version")] then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_SHIPWORKS_COMPLETE, var0.configId)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("printblue_build_erro") .. arg0.result)
		end
	end)
end

return var0
