local var0_0 = class("Dorm3dLevelMediator", import("view.base.ContextMediator"))

var0_0.CHANGE_SKIN = "Dorm3dLevelMediator.CHANGE_SKIN"
var0_0.CHAMGE_TIME = "Dorm3dLevelMediator.CHAMGE_TIME"
var0_0.ON_DROP_CLIENT = "Dorm3dLevelMediator.ON_DROP_CLIENT"
var0_0.RENAME = "Dorm3dLevelMediator.RENAME"
var0_0.RENAME_RESET = "Dorm3dLevelMediator.RENAME_RESET"
var0_0.UPDATE_FAVOR_DISPLAY = "UpdateFavorDisplay"

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
	arg0_1:bind(var0_0.RENAME, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.DORM_SET_CALL, {
			groupId = arg1_5,
			callName = arg2_5
		})
	end)
	arg0_1:bind(var0_0.RENAME_RESET, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.DORM_SET_CALL, {
			callName = "",
			groupId = arg1_6
		})
	end)
	arg0_1:bind(var0_0.UPDATE_FAVOR_DISPLAY, function(arg0_7)
		arg0_1:sendNotification(Dorm3dRoomMediator.UPDATE_FAVOR_DISPLAY)
	end)
	arg0_1.viewComponent:SetApartment(arg0_1.contextData.apartment)
end

function var0_0.initNotificationHandleDic(arg0_8)
	arg0_8.handleDic = {
		[GAME.DORM_SET_CALL_DONE] = function(arg0_9, arg1_9)
			local var0_9 = arg1_9:getBody()

			arg0_9.viewComponent:SetApartment(var0_9.apartment)
			arg0_9.viewComponent:CloseRenameWindow()
		end
	}
end

function var0_0.remove(arg0_10)
	return
end

return var0_0
