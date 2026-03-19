local var0_0 = class("EducateCharDockMediator", import("view.base.ContextMediator"))

var0_0.GO_PROFILE = "EducateCharDockMediator:GO_PROFILE"
var0_0.ON_SELECTED = "EducateCharDockMediator:ON_SELECTED"
var0_0.ON_SKIN_SHOP = "EducateCharDockMediator.ON_SKIN_SHOP"

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
	arg0_1:bind(var0_0.ON_SKIN_SHOP, function(arg0_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP, {
			skinId = arg0_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.CLEAR_EDUCATE_TIP
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.CLEAR_EDUCATE_TIP then
		arg0_6.viewComponent:emit(EducateCharDockScene.MSG_CLEAR_TIP, var1_6.id)
	end
end

return var0_0
