local var0 = class("GameRoomSuccessCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.roomId
	local var2 = var0.times
	local var3 = var0.score
	local var4 = getProxy(GameRoomProxy):lastMonthlyTicket()

	if getProxy(GameRoomProxy):lastTicketMax() == 0 or var4 == 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(26126, {
		roomid = var1,
		times = var2,
		score = var3
	}, 26127, function(arg0)
		if arg0.result == 0 then
			getProxy(GameRoomProxy):storeGameScore(var1, var3)

			local var0 = id2res(GameRoomProxy.coin_res_id)

			getProxy(PlayerProxy):getRawData():consume({
				[var0] = var2 or 0
			})

			local var1 = PlayerConst.addTranDrop(arg0.drop_list)
			local var2 = var1[1].count
			local var3 = getProxy(GameRoomProxy):lastMonthlyTicket()

			if var3 < var2 then
				var2 = var3
			end

			local var4 = getProxy(GameRoomProxy):lastTicketMax()

			if var4 < var2 then
				var2 = var4
			end

			getProxy(GameRoomProxy):setMonthlyTicket(var2)

			local var5 = getProxy(GameRoomProxy):getTicket()
			local var6 = pg.gameset.game_room_remax.key_value - var5

			if var6 < var2 then
				local var7 = var6

				var1[1].count = var7
			end

			if var1[1].count ~= 0 then
				pg.m02:sendNotification(GAME.GAME_ROOM_AWARD_DONE, var1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
