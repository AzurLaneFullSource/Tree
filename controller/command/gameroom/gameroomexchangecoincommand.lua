local var0 = class("GameRoomExchangeCoinCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.times
	local var2 = var0.price

	pg.ConnectionMgr.GetInstance():Send(26124, {
		times = var1
	}, 26125, function(arg0)
		if arg0.result == 0 then
			arg0.coinMax = pg.gameset.game_coin_max.key_value
			arg0.myCoinCount = getProxy(GameRoomProxy):getCoin()

			local var0 = arg0.coinMax - arg0.myCoinCount

			if var0 < var1 then
				var1 = var0
			end

			local var1 = id2res(GameRoomProxy.coin_res_id)

			getProxy(GameRoomProxy):setPayCoinCount(var1)

			local var2 = getProxy(PlayerProxy):getRawData()

			var2:addResources({
				[var1] = var1 or 0
			})
			var2:consume({
				gold = var2 or 0
			})
			getProxy(PlayerProxy):updatePlayer(var2)

			local var3 = pg.player_resource[GameRoomProxy.coin_res_id].itemid
			local var4 = {
				{
					id = var3,
					type = DROP_TYPE_ITEM,
					count = var1
				}
			}

			pg.m02:sendNotification(GAME.GAME_ROOM_AWARD_DONE, var4)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
