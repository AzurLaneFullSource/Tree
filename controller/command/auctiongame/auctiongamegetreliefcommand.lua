local var0_0 = class("AuctionGameGetReliefCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(23426, {
		arg = 1
	}, 23427, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_AUCTION_GAME):getConfig("config_client").itemID
			local var1_2 = PlayerConst.GetTranAwards({}, {
				award_list = {
					{
						type = DROP_TYPE_VITEM,
						id = var0_2,
						number = pg.gameset.auction_relief_payment.key_value
					}
				}
			})

			getProxy(AuctionGameBaseProxy):AddReliefCnt()
			pg.m02:sendNotification(GAME.AUCTION_GAME_GET_RELIEF_DONE, var1_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
