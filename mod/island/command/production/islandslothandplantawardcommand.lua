local var0_0 = class("IslandSlotHandPlantAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.build_id
	local var2_1 = var0_1.area_id

	pg.ConnectionMgr.GetInstance():Send(21511, {
		build_id = var1_1,
		area_id = var2_1
	}, 21512, function(arg0_2)
		if arg0_2.result == 0 then
			-- block empty
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
