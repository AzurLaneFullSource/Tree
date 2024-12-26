local var0_0 = class("Dorm3dPhotoSelectFrameMediator", import("view.base.ContextMediator"))

var0_0.CONFIRMFRAME = "Dorm3dPhotoSelectFrameMediator:CONFIRMFRAME"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CONFIRMFRAME, function(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
		arg0_1:sendNotification(var0_0.CONFIRMFRAME, {
			selectFrameId = arg1_2,
			imagePos = arg2_2,
			imageScale = arg3_2,
			specialPosDic = arg4_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.remove(arg0_4)
	return
end

return var0_0
