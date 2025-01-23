local var0_0 = class("NewEducateSelEndingMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_SELECT_ENDING = "NewEducateSelEndingMediator:ON_SELECT_ENDING"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SELECT_ENDING, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_ENDING, {
			id = arg0_1.contextData.char.id,
			endingId = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.NEW_EDUCATE_SEL_ENDING_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.NEW_EDUCATE_SEL_ENDING_DONE then
		arg0_4.viewComponent:OnSelDone(var1_4.id)
	end
end

return var0_0
