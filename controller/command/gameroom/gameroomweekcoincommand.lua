local var0 = class("GameRoomWeekCoinCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(26122, {
		type = 0
	}, 26123, function(arg0)
		local var0

		if arg0.result == 0 then
			arg0.coinMax = pg.gameset.game_coin_max.key_value
			arg0.myCoinCount = getProxy(GameRoomProxy):getCoin()

			local var1 = arg0.coinMax - arg0.myCoinCount
			local var2 = pg.gameset.game_coin_initial.key_value

			if var1 < var2 then
				var2 = var1
			end

			local var3 = id2res(GameRoomProxy.coin_res_id)

			getProxy(PlayerProxy):getRawData():addResources({
				[var3] = var2 or 0
			})

			local var4 = pg.player_resource[GameRoomProxy.coin_res_id].itemid
			local var5 = {
				{
					id = var4,
					type = DROP_TYPE_ITEM,
					count = var2
				}
			}

			getProxy(GameRoomProxy):setWeekly()
			pg.m02:sendNotification(GAME.GAME_ROOM_AWARD_DONE, var5)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
