local var0 = class("EducateCharDockMediator", import("view.base.ContextMediator"))

var0.GO_PROFILE = "EducateCharDockMediator:GO_PROFILE"
var0.ON_SELECTED = "EducateCharDockMediator:ON_SELECTED"

function var0.register(arg0)
	arg0:bind(var0.ON_SELECTED, function(arg0, arg1)
		arg0:sendNotification(GAME.CHANGE_EDUCATE, {
			id = arg1
		})
	end)
	arg0:bind(var0.GO_PROFILE, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.EDUCATE_PROFILE)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.CLEAR_EDUCATE_TIP
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.CLEAR_EDUCATE_TIP then
		arg0.viewComponent:emit(EducateCharDockScene.MSG_CLEAR_TIP, var1.id)
	end
end

return var0
