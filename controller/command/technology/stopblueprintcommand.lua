local var0_0 = class("StopBluePrintCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(TechnologyProxy)
	local var4_1 = var3_1:getBluePrintById(var1_1)

	if not var4_1 then
		return
	end

	if not var4_1:isDeving() and not var4_1:isFinished() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63206, {
		blueprint_id = var1_1
	}, 63207, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = pg.TimeMgr.GetInstance():GetServerTime() - var4_1.startTime

			var4_1:updateStartUpTime(var0_2)
			var4_1:reset()
			var3_1:updateBluePrint(var4_1)
			arg0_1:sendNotification(GAME.STOP_BLUEPRINT_DONE, {
				id = var4_1.id
			})

			if var2_1 then
				var2_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("technology_stop_erro") .. arg0_2.result)
		end
	end)
end

return var0_0
