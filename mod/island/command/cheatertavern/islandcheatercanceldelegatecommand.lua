local var0_0 = class("IslandCheaterReconectCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().type

	pg.ConnectionMgr.GetInstance():Send(23113, {
		Type = var0_1
	}, 23114, function(arg0_2)
		if arg0_2.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end, false)
end

return var0_0
