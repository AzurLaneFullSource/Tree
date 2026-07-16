local var0_0 = class("AuctionGameMainEventMediator", import("view.base.ContextMediator"))

var0_0.EVENT_SELECTED_ID = "AuctionGameMainEventMediator::EVENT_SELECTED_ID"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EVENT_SELECTED_ID, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.AUCTION_GAME_EVENT_SELECTED_ID, arg1_2)
	end)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.AUCTION_GAME_EVENT_SELECTED_ID_DONE] = function(arg0_4, arg1_4)
			arg0_4.viewComponent:closeView()
		end,
		[GAME.AUCTION_GAME_ROUND_OVER] = function(arg0_5, arg1_5)
			arg0_5.viewComponent:closeView()
		end,
		[GAME.AUCTION_GAME_BID_PHASE] = function(arg0_6, arg1_6)
			arg0_6.viewComponent:closeView()
		end
	}
end

function var0_0.remove(arg0_7)
	return
end

return var0_0
