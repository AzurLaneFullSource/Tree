local var0_0 = class("IslandSetCommanderDressupReadCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().dress_List

	pg.ConnectionMgr.GetInstance():Send(21621, {
		dress_id = var0_1
	}, 21622, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()

			for iter0_2, iter1_2 in ipairs(var0_1) do
				var0_2:SetDressHasRead(iter1_2)
			end

			arg0_1:sendNotification(GAME.ISLAND_SEND_COMMANDER_DRESS_READ_DONE, var0_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
