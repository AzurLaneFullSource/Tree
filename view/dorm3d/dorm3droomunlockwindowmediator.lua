local var0_0 = class("Dorm3dRoomUnlockWindowMediator", import("view.base.ContextMediator"))

var0_0.ON_UNLOCK_DORM_ROOM = "Dorm3dRoomUnlockWindowMediator.ON_UNLOCK_DORM_ROOM"
var0_0.ON_UNLOCK_ROOM_INVITE = "Dorm3dRoomUnlockWindowMediator.ON_UNLOCK_ROOM_INVITE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_UNLOCK_DORM_ROOM, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.APARTMENT_ROOM_UNLOCK, {
			roomId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_UNLOCK_ROOM_INVITE, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.APARTMENT_ROOM_INVITE_UNLOCK, {
			roomId = arg1_3,
			groupId = arg2_3
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[GAME.APARTMENT_ROOM_UNLOCK_DONE] = function(arg0_5, arg1_5)
			local var0_5 = arg1_5:getBody()

			arg0_5.viewComponent:closeView()
		end,
		[GAME.APARTMENT_ROOM_INVITE_UNLOCK_DONE] = function(arg0_6, arg1_6)
			local var0_6 = arg1_6:getBody()

			arg0_6.viewComponent:closeView()
		end
	}
end

function var0_0.remove(arg0_7)
	return
end

return var0_0
