local var0 = class("SelectTecTargetCatchupCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.tecID
	local var2 = var0.charID

	pg.ConnectionMgr.GetInstance():Send(63011, {
		version = var1,
		target = var2
	}, 63012, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(TechnologyProxy)
			local var1 = var0.tecID
			local var2 = var2

			if var2 == 0 then
				-- block empty
			else
				var0:setCurCatchupTecInfo(var1, var2)
			end

			arg0:sendNotification(GAME.SELECT_TEC_TARGET_CATCHUP_DONE, {
				tecID = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Error Code" .. arg0.result)
		end
	end)
end

return var0
