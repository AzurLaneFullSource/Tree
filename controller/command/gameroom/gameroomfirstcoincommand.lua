local var0_0 = class("GameRoomFirstCoinCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	print("")
	pg.ConnectionMgr.GetInstance():Send(26128, {
		type = 0
	}, 26129, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(GameRoomProxy):setFirstEnter()

			arg0_1.coinMax = pg.gameset.game_coin_max.key_value
			arg0_1.myCoinCount = getProxy(GameRoomProxy):getCoin()

			local var0_2 = arg0_1.coinMax - arg0_1.myCoinCount
			local var1_2 = pg.gameset.game_coin_initial.key_value

			if var0_2 < var1_2 then
				var1_2 = var0_2
			end

			local var2_2 = id2res(GameRoomProxy.coin_res_id)

			getProxy(PlayerProxy):getRawData():addResources({
				[var2_2] = var1_2 or 0
			})

			local var3_2 = pg.player_resource[GameRoomProxy.coin_res_id].itemid
			local var4_2 = {
				{
					id = var3_2,
					type = DROP_TYPE_ITEM,
					count = var1_2
				}
			}

			pg.m02:sendNotification(GAME.ROOM_FIRST_COIN_DONE, var4_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
