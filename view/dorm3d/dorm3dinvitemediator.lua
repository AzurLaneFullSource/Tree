local var0_0 = class("Dorm3dInviteMediator", import("view.base.ContextMediator"))

var0_0.ON_DORM = "Dorm3dInviteMediator.ON_DORM"
var0_0.ON_UNLOCK_DORM_ROOM = "Dorm3dInviteMediator.ON_UNLOCK_DORM_ROOM"
var0_0.OPEN_ROOM_UNLOCK_WINDOW = "Dorm3dInviteMediator.OPEN_ROOM_UNLOCK_WINDOW"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_DORM, function(arg0_2, arg1_2)
		arg0_1:sendNotification(Dorm3dInviteMediator.ON_DORM, arg1_2)
	end)
	arg0_1:bind(var0_0.OPEN_ROOM_UNLOCK_WINDOW, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dRoomUnlockWindow,
			mediator = Dorm3dRoomUnlockWindowMediator,
			data = {
				roomId = arg1_3,
				groupId = arg2_3
			},
			onRemoved = function()
				arg0_1.viewComponent:ShowSelectPanel()
			end
		}))
	end)
end

function var0_0.initNotificationHandleDic(arg0_5)
	arg0_5.handleDic = {
		[GAME.APARTMENT_ROOM_INVITE_UNLOCK_DONE] = function(arg0_6, arg1_6)
			local var0_6 = arg1_6:getBody()
		end
	}
end

return var0_0
