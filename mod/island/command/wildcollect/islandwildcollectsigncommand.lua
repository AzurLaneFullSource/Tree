local var0_0 = class("IslandWildCollectSignCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.island_id
	local var2_1 = var0_1.gather_id

	pg.ConnectionMgr.GetInstance():Send(21531, {
		island_id = var1_1,
		gather_id = var2_1
	}, 21532, function(arg0_2)
		if arg0_2.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
