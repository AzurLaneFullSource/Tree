local var0_0 = class("IslandSetOrderTendencyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().value
	local var1_1 = getProxy(IslandProxy):GetIsland():GetOrderAgency()

	if var1_1:GetTendency() == var0_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21410, {
		type = var0_1
	}, 21411, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:SetTendency(var0_1)
			arg0_1:sendNotification(GAME.ISLAND_SET_ORDER_TENDENCY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
