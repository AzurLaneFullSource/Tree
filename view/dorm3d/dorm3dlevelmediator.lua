local var0 = class("Dorm3dLevelMediator", import("view.base.ContextMediator"))

var0.CHANGE_SKIN = "Dorm3dLevelMediator.CHANGE_SKIN"
var0.CHAMGE_TIME = "Dorm3dLevelMediator.CHAMGE_TIME"

function var0.register(arg0)
	arg0:bind(var0.CHANGE_SKIN, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.APARTMENT_CHANGE_SKIN, {
			groupId = arg1,
			skinId = arg2
		})
		arg0.viewComponent:closeView()
	end)
	arg0:bind(var0.CHAMGE_TIME, function(arg0, arg1)
		arg0:sendNotification(Dorm3dSceneMediator.CHAMGE_TIME_RELOAD_SCENE, {
			timeIndex = arg1
		})
		arg0.viewComponent:closeView()
	end)
	arg0.viewComponent:SetApartment(getProxy(ApartmentProxy):getApartment(arg0.contextData.groupId))
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {}
end

function var0.remove(arg0)
	return
end

return var0
