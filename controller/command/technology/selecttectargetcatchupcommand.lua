local var0_0 = class("SelectTecTargetCatchupCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.tecID
	local var2_1 = var0_1.charID

	pg.ConnectionMgr.GetInstance():Send(63011, {
		version = var1_1,
		target = var2_1
	}, 63012, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(TechnologyProxy)
			local var1_2 = var0_1.tecID
			local var2_2 = var2_1

			if var2_1 == 0 then
				-- block empty
			else
				var0_2:setCurCatchupTecInfo(var1_2, var2_2)
			end

			arg0_1:sendNotification(GAME.SELECT_TEC_TARGET_CATCHUP_DONE, {
				tecID = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Error Code" .. arg0_2.result)
		end
	end)
end

return var0_0
