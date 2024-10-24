local var0_0 = class("Dorm3dCollectionMediator", import("view.base.ContextMediator"))

var0_0.DO_TALK = "Dorm3dCollectionMediator.DO_TALK"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.DO_TALK, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(Dorm3dRoomMediator.OTHER_DO_TALK, {
			isReplay = true,
			talkId = arg1_2,
			callback = arg2_2
		})
		arg0_1.viewComponent:closeView()
	end)
	arg0_1.viewComponent:SetRoom(arg0_1.contextData.roomId)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {}
end

function var0_0.remove(arg0_4)
	return
end

return var0_0
