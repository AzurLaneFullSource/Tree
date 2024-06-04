local var0 = class("StopBluePrintCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.callback
	local var3 = getProxy(TechnologyProxy)
	local var4 = var3:getBluePrintById(var1)

	if not var4 then
		return
	end

	if not var4:isDeving() and not var4:isFinished() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63206, {
		blueprint_id = var1
	}, 63207, function(arg0)
		if arg0.result == 0 then
			local var0 = pg.TimeMgr.GetInstance():GetServerTime() - var4.startTime

			var4:updateStartUpTime(var0)
			var4:reset()
			var3:updateBluePrint(var4)
			arg0:sendNotification(GAME.STOP_BLUEPRINT_DONE, {
				id = var4.id
			})

			if var2 then
				var2()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_stop_erro") .. arg0.result)
		end
	end)
end

return var0
