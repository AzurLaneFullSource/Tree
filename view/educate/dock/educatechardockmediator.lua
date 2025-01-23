local var0_0 = class("EducateCharDockMediator", import("view.base.ContextMediator"))

var0_0.GO_PROFILE = "EducateCharDockMediator:GO_PROFILE"
var0_0.ON_SELECTED = "EducateCharDockMediator:ON_SELECTED"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SELECTED, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.CHANGE_EDUCATE, {
			id = arg1_2
		})
	end)
	arg0_1:bind(var0_0.GO_PROFILE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EDUCATE_PROFILE, {
			selectedCharacterId = arg1_3
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.CLEAR_EDUCATE_TIP
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.CLEAR_EDUCATE_TIP then
		arg0_5.viewComponent:emit(EducateCharDockScene.MSG_CLEAR_TIP, var1_5.id)
	end
end

return var0_0
