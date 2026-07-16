local var0_0 = class("AuctionGameMainEmojiMediator", import("view.base.ContextMediator"))

var0_0.ON_CLICK_EMOJI = "AuctionGameMainEmojiMediator::ON_CLICK_EMOJI"
var0_0.ON_CLICK_EMOJI_SWITCH = "AuctionGameMainEmojiMediator::ON_CLICK_EMOJI_SWITCH"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_CLICK_EMOJI, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.AUCTION_GAME_EMOJI, arg1_2)
	end)
	arg0_1:bind(var0_0.ON_CLICK_EMOJI_SWITCH, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.AUCTION_GAME_SWITCH_EMOJI, arg1_3)
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[GAME.AUCTION_GAME_EMOJI_DONE] = function(arg0_5, arg1_5)
			arg0_5.viewComponent:closeView()
		end,
		[GAME.AUCTION_GAME_SWITCH_EMOJI_DONE] = function(arg0_6, arg1_6)
			arg0_6.viewComponent:OnRefreshSwitchEmojiBtn()
		end
	}
end

function var0_0.remove(arg0_7)
	return
end

return var0_0
