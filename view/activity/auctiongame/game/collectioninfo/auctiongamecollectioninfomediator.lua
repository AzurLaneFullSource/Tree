local var0_0 = class("AuctionGameCollectionInfoMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.initNotificationHandleDic(arg0_2)
	arg0_2.handleDic = {
		[GAME.AUCTION_GAME_ROUND_OVER] = function(arg0_3, arg1_3)
			arg0_3.viewComponent:closeView()
		end
	}
end

return var0_0
