local var0_0 = class("GameRoomExchangeCoinCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.times
	local var2_1 = var0_1.price

	pg.ConnectionMgr.GetInstance():Send(26124, {
		times = var1_1
	}, 26125, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1.coinMax = pg.gameset.game_coin_max.key_value
			arg0_1.myCoinCount = getProxy(GameRoomProxy):getCoin()

			local var0_2 = arg0_1.coinMax - arg0_1.myCoinCount

			if var0_2 < var1_1 then
				var1_1 = var0_2
			end

			local var1_2 = id2res(GameRoomProxy.coin_res_id)

			getProxy(GameRoomProxy):setPayCoinCount(var1_1)

			local var2_2 = getProxy(PlayerProxy):getRawData()

			var2_2:addResources({
				[var1_2] = var1_1 or 0
			})
			var2_2:consume({
				gold = var2_1 or 0
			})
			getProxy(PlayerProxy):updatePlayer(var2_2)

			local var3_2 = pg.player_resource[GameRoomProxy.coin_res_id].itemid
			local var4_2 = {
				{
					id = var3_2,
					type = DROP_TYPE_ITEM,
					count = var1_1
				}
			}

			pg.m02:sendNotification(GAME.GAME_ROOM_AWARD_DONE, var4_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
