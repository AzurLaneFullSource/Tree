local var0_0 = class("GameRoomWeekCoinCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(26122, {
		type = 0
	}, 26123, function(arg0_2)
		local var0_2

		if arg0_2.result == 0 then
			arg0_1.coinMax = pg.gameset.game_coin_max.key_value
			arg0_1.myCoinCount = getProxy(GameRoomProxy):getCoin()

			local var1_2 = arg0_1.coinMax - arg0_1.myCoinCount
			local var2_2 = pg.gameset.game_coin_initial.key_value

			if var1_2 < var2_2 then
				var2_2 = var1_2
			end

			local var3_2 = id2res(GameRoomProxy.coin_res_id)

			getProxy(PlayerProxy):getRawData():addResources({
				[var3_2] = var2_2 or 0
			})

			local var4_2 = pg.player_resource[GameRoomProxy.coin_res_id].itemid
			local var5_2 = {
				{
					id = var4_2,
					type = DROP_TYPE_ITEM,
					count = var2_2
				}
			}

			getProxy(GameRoomProxy):setWeekly()
			pg.m02:sendNotification(GAME.GAME_ROOM_AWARD_DONE, var5_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
