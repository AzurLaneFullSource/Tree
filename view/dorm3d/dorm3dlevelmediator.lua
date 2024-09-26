local var0_0 = class("Dorm3dLevelMediator", import("view.base.ContextMediator"))

var0_0.CHANGE_SKIN = "Dorm3dLevelMediator.CHANGE_SKIN"
var0_0.CHAMGE_TIME = "Dorm3dLevelMediator.CHAMGE_TIME"
var0_0.ON_DROP_CLIENT = "Dorm3dLevelMediator.ON_DROP_CLIENT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CHANGE_SKIN, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.APARTMENT_CHANGE_SKIN, {
			groupId = arg1_2,
			skinId = arg2_2
		})
		arg0_1.viewComponent:closeView()
	end)
	arg0_1:bind(var0_0.CHAMGE_TIME, function(arg0_3, arg1_3)
		arg0_1:sendNotification(Dorm3dRoomMediator.CHAMGE_TIME_RELOAD_SCENE, {
			timeIndex = arg1_3
		})
		arg0_1.viewComponent:closeView()
	end)
	arg0_1:bind(var0_0.ON_DROP_CLIENT, function(arg0_4, arg1_4)
		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_DROP_CLIENT, arg1_4)
	end)
	arg0_1.viewComponent:SetApartment(arg0_1.contextData.apartment)
end

function var0_0.initNotificationHandleDic(arg0_5)
	arg0_5.handleDic = {}
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
