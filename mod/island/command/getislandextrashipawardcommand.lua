local var0_0 = class("GetIslandExtraShipAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.op
	local var3_1 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	local var4_1 = var3_1:GetShipById(var1_1)

	if not var4_1 then
		return
	end

	local var5_1 = table.indexof(var4_1:GetAllExtraAwardOP(), var2_1)

	pg.ConnectionMgr.GetInstance():Send(21047, {
		ship_id = var1_1,
		index = var5_1
	}, 21048, function(arg0_2)
		if arg0_2.ret == 0 then
			local var0_2 = IslandDropHelper.AddItems(arg0_2)

			var3_1:ExtraShipAward(var1_1, var2_1)
			arg0_1:sendNotification(GAME.ISLAND_GET_EXTRA_AWARD_DONE, {
				dropData = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
