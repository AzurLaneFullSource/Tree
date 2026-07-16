local var0_0 = import("view.playRoom.PlayRoomCommonMediator")
local var1_0 = class("AuctionGameEntranceMediator", var0_0)

var1_0.CLICK_PREORDER_BOX = "AuctionGameEntranceMediator::CLICK_PREORDER_BOX"
var1_0.CLICK_OPEN_BOX = "AuctionGameEntranceMediator::CLICK_OPEN_BOX"
var1_0.SHOW_WARNING_TIP = "AuctionGameEntranceMediator::SHOW_WARNING_TIP"
var1_0.CLICK_GET_RELIEF = "AuctionGameEntranceMediator::CLICK_GET_RELIEF"

function var1_0.register(arg0_1)
	arg0_1:bind(var1_0.CLICK_PREORDER_BOX, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.AUCTION_GAME_PREORDER_BOX)
	end)
	arg0_1:bind(var1_0.CLICK_OPEN_BOX, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.AUCTION_GAME_OPEN_BOX)
	end)
	arg0_1:bind(var1_0.SHOW_WARNING_TIP, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.AUCTION_GAME_SHOW_MATCH_WARNING_TIP)
	end)
	arg0_1:bind(var1_0.CLICK_GET_RELIEF, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.AUCTION_GAME_GET_RELIEF)
	end)
end

function var1_0.initNotificationHandleDic(arg0_6)
	arg0_6.handleDic = {
		[GAME.AUCTION_GAME_PREORDER_BOX_DONE] = function(arg0_7, arg1_7)
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildPreorder(0, AuctionGameTools.GetPreorderCurrentyCnt()))
			arg0_7.viewComponent:OnUpdateCurrency()
		end,
		[GAME.AUCTION_GAME_OPEN_BOX_DONE] = function(arg0_8, arg1_8)
			getProxy(AuctionGameBaseProxy):SetNeedInitFlag(true)
			arg0_8:sendNotification(GAME.GO_SCENE, SCENE.AUCTION_GAME_PREORDER_BOX_SETTLEMENT)
		end,
		[GAME.ADD_ITEM] = function(arg0_9, arg1_9)
			arg0_9.viewComponent:RefreshLocationTip()
			arg0_9.viewComponent:OnUpdateCurrency()
			arg0_9.viewComponent:emit(AuctionGamePlayerPanel.REFRESH_CURRENCY)
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0_10, arg1_10)
			arg0_10.viewComponent:RefreshTaskTip()
		end,
		[GAME.SUBMIT_ACTIVITY_TASK_DONE] = function(arg0_11, arg1_11)
			arg0_11.viewComponent:RefreshTaskTip()
		end,
		[GAME.AUCTION_GAME_GET_RELIEF_DONE] = function(arg0_12, arg1_12)
			local var0_12 = arg1_12:getBody()

			if #var0_12 > 0 then
				arg0_12.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_12)
			end
		end,
		[GAME.TOTAL_TASK_UPDATED] = function(arg0_13, arg1_13)
			arg0_13.viewComponent:RefreshTaskTip()
		end,
		[GAME.ON_RECONNECTION] = function(arg0_14, arg1_14)
			local var0_14 = {}

			table.insert(var0_14, function(arg0_15)
				getProxy(AuctionGameBaseProxy):SetNeedInitFlag(true)
				arg0_14:sendNotification(GAME.AUCTION_GAME_INIT, {
					callback = arg0_15
				})
			end)
			seriesAsync(var0_14, function()
				if arg0_14.viewComponent:IsQuickMatch() then
					arg0_14:sendNotification(GAME.AUCTION_GAME_MATCHING_RECONNECT, {})
				end
			end)
		end,
		[GAME.AUCTION_GAME_MATCHING_RECONNECT_DONE] = function(arg0_17, arg1_17)
			if arg1_17:getBody() == 3 then
				arg0_17.viewComponent:OnClickStopQuickMatch()
			end
		end
	}
end

function var1_0.remove(arg0_18)
	return
end

return var1_0
