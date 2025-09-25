local var0_0 = class("IslandRemoveExpiredTicketCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.tickets
	local var2_1 = var0_1.callback
	local var3_1 = {}

	for iter0_1, iter1_1 in ipairs(var1_1) do
		table.insert(var3_1, {
			speed_id = iter1_1.id,
			end_time = iter1_1.endTime
		})
	end

	pg.ConnectionMgr.GetInstance():Send(21425, {
		ticket_keys = var3_1
	}, 21426, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetTicketAgency()

			for iter0_2, iter1_2 in ipairs(var3_1) do
				var0_2:RemoveTicket(iter1_2.speed_id, iter1_2.end_time)
			end

			arg0_1:sendNotification(GAME.ISLAND_REMOVE_EXPIRED_TICKET_DONE, {
				tickets = var1_1,
				callback = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
