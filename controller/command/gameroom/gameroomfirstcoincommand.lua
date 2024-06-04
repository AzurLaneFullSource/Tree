local var0 = class("GameRoomFirstCoinCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	print("")
	pg.ConnectionMgr.GetInstance():Send(26128, {
		type = 0
	}, 26129, function(arg0)
		if arg0.result == 0 then
			getProxy(GameRoomProxy):setFirstEnter()

			arg0.coinMax = pg.gameset.game_coin_max.key_value
			arg0.myCoinCount = getProxy(GameRoomProxy):getCoin()

			local var0 = arg0.coinMax - arg0.myCoinCount
			local var1 = pg.gameset.game_coin_initial.key_value

			if var0 < var1 then
				var1 = var0
			end

			local var2 = id2res(GameRoomProxy.coin_res_id)

			getProxy(PlayerProxy):getRawData():addResources({
				[var2] = var1 or 0
			})

			local var3 = pg.player_resource[GameRoomProxy.coin_res_id].itemid
			local var4 = {
				{
					id = var3,
					type = DROP_TYPE_ITEM,
					count = var1
				}
			}

			pg.m02:sendNotification(GAME.ROOM_FIRST_COIN_DONE, var4)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
