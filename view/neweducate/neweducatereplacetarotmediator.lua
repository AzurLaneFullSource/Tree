local var0_0 = class("NewEducateReplaceTarotMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_REPLACE_TAROT = "NewEducateReplaceTarotMediator.ON_REPLACE_TAROT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_REPLACE_TAROT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_REPLACE_TAROT, {
			id = arg0_1.contextData.char.id,
			tarotId = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.NEW_EDUCATE_REPLACE_TAROT_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.NEW_EDUCATE_REPLACE_TAROT_DONE then
		arg0_4.viewComponent:OnReplaceDone(var1_4)
	end
end

return var0_0
