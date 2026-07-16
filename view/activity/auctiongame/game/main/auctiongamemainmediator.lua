local var0_0 = class("AuctionGameMainMediator", import("view.base.ContextMediator"))

var0_0.FORFEIT = "AuctionGameMainMediator::FORFEIT"
var0_0.EXIT = "AuctionGameMainMediator::EXIT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.FORFEIT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.AUCTION_GAME_FORFEIT)
	end)
	arg0_1:bind(var0_0.EXIT, function(arg0_3, arg1_3)
		arg0_1.viewComponent:closeView()
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[GAME.AUCTION_GAME_NEW_ROUND] = function(arg0_5, arg1_5)
			arg0_5.viewComponent:RefreshRound()
			arg0_5.viewComponent:emit(AuctionGameMainRightView.POP_EVENT_LAYER)
		end,
		[GAME.AUCTION_GAME_EVENT_SELECTED_ID_DONE] = function(arg0_6, arg1_6)
			arg0_6.viewComponent:emit(AuctionGameMainRightView.EVENT_SELECTED)
		end,
		[GAME.AUCTION_GAME_BID_PHASE] = function(arg0_7, arg1_7)
			arg0_7.viewComponent:OnStartBid()
		end,
		[GAME.AUCTION_GAME_BID_DONE] = function(arg0_8, arg1_8)
			arg0_8.viewComponent:OnBidDone(arg1_8:getBody())
		end,
		[GAME.AUCTION_GAME_FORFEIT_DONE] = function(arg0_9, arg1_9)
			arg0_9.viewComponent:emit(AuctionGameMainRightView.FORFEIT_DONE, arg1_9)
		end,
		[GAME.AUCTION_GAME_EVENT_EFFECT_UPDATE] = function(arg0_10, arg1_10)
			arg0_10.viewComponent:emit(AuctionGameStoreView.UPDATE_ITEM_LIST)
			arg0_10.viewComponent:emit(AuctionGameMainRightInfoView.EVENT_INFO_UPDATE)
		end,
		[GAME.AUCTION_GAME_PLAYER_OPT_STATE_UPDATE] = function(arg0_11, arg1_11)
			arg0_11.viewComponent:emit(AuctionGameMainRightView.PLAYER_OPT_STATE_UPDATE)
		end,
		[GAME.AUCTION_GAME_ROUND_OVER] = function(arg0_12, arg1_12)
			arg0_12.viewComponent:OnStartRoundOver()
		end,
		[GAME.AUCTION_GAME_SETTLEMENT] = function(arg0_13, arg1_13)
			local var0_13 = getProxy(AuctionGameProxy)

			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionFinish(var0_13:GetAuctionID(), var0_13:GetRound(), 0))
			arg0_13:sendNotification(GAME.GO_SCENE, SCENE.AUCTION_GAME_MAIN_SETTLEMENT)
		end,
		[GAME.AUCTION_GAME_KICK] = function(arg0_14, arg1_14)
			arg0_14.viewComponent:OnKick()
		end,
		[GAME.AUCTION_GAME_SHOW_EMOJI] = function(arg0_15, arg1_15)
			arg0_15.viewComponent:emit(AuctionGameMainRightView.SHOW_EMOJI, arg1_15:getBody())
		end,
		[GAME.AUCTION_GAME_SWITCH_EMOJI_DONE] = function(arg0_16, arg1_16)
			arg0_16.viewComponent:emit(AuctionGameMainRightView.SWITCH_EMOJI)
		end,
		[GAME.ON_RECONNECTION] = function(arg0_17, arg1_17)
			arg0_17.viewComponent:OnReconnection()
		end
	}
end

function var0_0.remove(arg0_18)
	return
end

return var0_0
