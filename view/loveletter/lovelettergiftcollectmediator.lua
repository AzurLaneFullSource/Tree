local var0_0 = class("LoveLetterGiftCollectMediator", import("view.base.ContextMediator"))

var0_0.ON_RECORD_GIFT = "LoveLetterGiftCollectMediator.ON_RECORD_GIFT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_RECORD_GIFT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.REALIZE_LOVE_LETTER_GIFT, {
			list = arg1_2
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.REALIZE_LOVE_LETTER_GIFT_DONE] = function(arg0_4, arg1_4)
			arg0_4.viewComponent:closeView()
		end
	}
end

return var0_0
