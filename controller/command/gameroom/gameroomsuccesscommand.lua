local var0_0 = class("GameRoomSuccessCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.roomId
	local var2_1 = var0_1.times
	local var3_1 = var0_1.score
	local var4_1 = getProxy(GameRoomProxy):lastMonthlyTicket()

	if getProxy(GameRoomProxy):lastTicketMax() == 0 or var4_1 == 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(26126, {
		roomid = var1_1,
		times = var2_1,
		score = var3_1
	}, 26127, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(GameRoomProxy):storeGameScore(var1_1, var3_1)

			local var0_2 = getProxy(GameRoomProxy):lastTicketMax()
			local var1_2 = id2res(GameRoomProxy.coin_res_id)

			getProxy(PlayerProxy):getRawData():consume({
				[var1_2] = var2_1 or 0
			})

			local var2_2 = PlayerConst.addTranDrop(arg0_2.drop_list)
			local var3_2 = var2_2[1].count
			local var4_2 = getProxy(GameRoomProxy):lastMonthlyTicket()

			if var4_2 < var3_2 then
				var3_2 = var4_2
			end

			if var0_2 < var3_2 then
				var3_2 = var0_2
			end

			getProxy(GameRoomProxy):setMonthlyTicket(var3_2)

			var2_2[1].count = var3_2

			if var2_2[1].count ~= 0 then
				pg.m02:sendNotification(GAME.GAME_ROOM_AWARD_DONE, var2_2)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
