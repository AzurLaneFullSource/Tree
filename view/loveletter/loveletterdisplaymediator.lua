local var0_0 = class("LoveLetterDisplayMediator", import("view.base.ContextMediator"))

var0_0.ON_UNLOCK_LETTER = "LoveLetterDisplayMediator.ON_UNLOCK_LETTER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_UNLOCK_LETTER, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.UNLOCK_LOVE_LETTER, {
			id = arg1_2
		})
	end)
	arg0_1.viewComponent:SetLoveLetter(arg0_1.contextData.groupId)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.UNLOCK_LOVE_LETTER_DONE] = function(arg0_4, arg1_4)
			arg0_4.viewComponent:DoOpenLetter()
		end
	}
end

return var0_0
