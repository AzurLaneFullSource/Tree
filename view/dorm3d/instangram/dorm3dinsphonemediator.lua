local var0_0 = class("Dorm3dInsPhoneMediator", import("view.base.ContextMediator"))

var0_0.ON_DORM = "Dorm3dInsPhoneMediator.ON_DORM"
var0_0.MARK_READ = "Dorm3dInsPhoneMediator.MARK_READ"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_DORM, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_ROOM, {
			isVideoTalk = true,
			roomId = arg1_2.roomId,
			groupIds = arg1_2.groupIds,
			specialId = arg1_2.specialId
		})
	end)
	arg0_1:bind(var0_0.MARK_READ, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.DORM3D_INS_PHONE_OP, {
			groupId = arg1_3.groupId,
			id = arg1_3.id
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[GAME.DORM3D_INS_PHONE_OP_DONE] = function(arg0_5)
			arg0_4.viewComponent:Flush()
		end
	}
end

return var0_0
