local var0_0 = class("IslandCheaterReconectCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = 1
	local var2_1 = getProxy(IslandProxy):GetIsland():GetCheaterTavernAgency()

	pg.ConnectionMgr.GetInstance():Send(23106, {
		type = var1_1
	}, 23107, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1:SetIsConnecting()
			var2_1:SetResetGameData(arg0_2)
			arg0_1:InitPlayerDate(arg0_2)

			local var0_2 = {
				user_id = arg0_2.user_id,
				operationType = IslandCheaterTavernConst.PlayerCurrentOperateType.PutCardOrQuery,
				auto_time = arg0_2.auto_time
			}

			pg.m02:sendNotification(GAME.ISLAND_CHEATER_RECONNECT, {
				operation = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end, false)
end

function var0_0.InitPlayerDate(arg0_3, arg1_3)
	local var0_3 = getProxy(IslandProxy):GetIsland()

	for iter0_3, iter1_3 in ipairs(arg1_3.player_list or {}) do
		local var1_3 = iter1_3.seat
		local var2_3 = iter1_3.player_info
		local var3_3 = {
			user_view = PlayRoomTools.GetGameViewID(var2_3.user_view),
			seat = var1_3,
			id = var2_3.id
		}

		var0_3:DispatchEvent(IslandCheaterTavernMonitor.ADD_CHEATERTAVERN_PLAYER, var3_3)
	end

	var0_3:DispatchEvent(IslandCheaterTavernMonitor.INIT_PLAYER_DATA_DONE)
end

return var0_0
