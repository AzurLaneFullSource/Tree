local var0_0 = class("NewEducateChooseMediator", import("view.newEducate.base.NewEducateContextMediator"))

var0_0.ON_REFRESH_CHOICE = "NewEducateChooseMediator.ON_REFRESH_CHOICE"
var0_0.ON_MAKE_CHOICE = "NewEducateChooseMediator.ON_MAKE_CHOICE"
var0_0.ON_GIVE_UP_CHOICE = "NewEducateChooseMediator.ON_GIVE_UP_CHOICE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_REFRESH_CHOICE, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_REFRESH_CHOICE, {
			id = arg0_1.contextData.char.id,
			idx = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_MAKE_CHOICE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_MAKE_CHOICE, {
			id = arg0_1.contextData.char.id,
			idx = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_GIVE_UP_CHOICE, function(arg0_4)
		arg0_1:sendNotification(GAME.NEW_EDUCATE_GIVE_UP_CHOICE, {
			id = arg0_1.contextData.char.id
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.NEW_EDUCATE_REFRESH_CHOICE_DONE,
		GAME.NEW_EDUCATE_MAKE_CHOICE_DONE,
		GAME.NEW_EDUCATE_GIVE_UP_CHOICE_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.NEW_EDUCATE_REFRESH_CHOICE_DONE then
		arg0_6.viewComponent:OnRefreshDone(var1_6)
	elseif var0_6 == GAME.NEW_EDUCATE_MAKE_CHOICE_DONE then
		arg0_6.viewComponent:OnMakeChoiceDone(var1_6)
	elseif var0_6 == GAME.NEW_EDUCATE_GIVE_UP_CHOICE_DONE then
		arg0_6.viewComponent:OnGiveUpDone(var1_6)
	end
end

return var0_0
