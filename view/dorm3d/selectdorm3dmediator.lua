local var0_0 = class("SelectDorm3DMediator", import("view.base.ContextMediator"))

var0_0.ON_DORM = "SelectDorm3DMediator.ON_DORM"
var0_0.ON_UNLOCK_DORM_ROOM = "SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM"
var0_0.ON_SUBMIT_TASK = "SelectDorm3DMediator.ON_SUBMIT_TASK"
var0_0.OPEN_INVITE_LAYER = "SelectDorm3DMediator.OPEN_INVITE_LAYER"
var0_0.OPEN_ROOM_UNLOCK_WINDOW = "SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_DORM, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_ROOM, arg1_2)
	end)
	arg0_1:bind(var0_0.ON_UNLOCK_DORM_ROOM, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.APARTMENT_ROOM_UNLOCK, {
			roomId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.ON_SUBMIT_TASK, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_4)
	end)
	arg0_1:bind(var0_0.OPEN_ROOM_UNLOCK_WINDOW, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dRoomUnlockWindow,
			mediator = Dorm3dRoomUnlockWindowMediator,
			data = {
				roomId = arg1_5
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_INVITE_LAYER, function(arg0_6, arg1_6, arg2_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dInviteLayer,
			mediator = Dorm3dInviteMediator,
			data = {
				roomId = arg1_6,
				groupIds = arg2_6
			}
		}))
	end)

	if not arg0_1.contextData.hasEnterCheck then
		arg0_1.contextData.hasEnterCheck = true

		arg0_1:sendNotification(GAME.SELECT_DORM_ENTER)
	end
end

function var0_0.initNotificationHandleDic(arg0_7)
	arg0_7.handleDic = {
		[DormGroupConst.NotifyDormDownloadStart] = function(arg0_8, arg1_8)
			local var0_8 = arg1_8:getBody()

			arg0_8.viewComponent:DownloadUpdate(DormGroupConst.DormDownloadLock.roomId, "start")
		end,
		[DormGroupConst.NotifyDormDownloadProgress] = function(arg0_9, arg1_9)
			local var0_9 = arg1_9:getBody()

			arg0_9.viewComponent:DownloadUpdate(DormGroupConst.DormDownloadLock.roomId, "loading")
		end,
		[DormGroupConst.NotifyDormDownloadFinish] = function(arg0_10, arg1_10)
			arg0_10.viewComponent:DownloadUpdate(arg1_10:getBody(), "finish")
		end,
		[GAME.APARTMENT_ROOM_UNLOCK_DONE] = function(arg0_11, arg1_11)
			local var0_11 = arg1_11:getBody()

			arg0_11.viewComponent:AfterRoomUnlock(var0_11)
		end,
		[PlayerProxy.UPDATED] = function(arg0_12, arg1_12)
			local var0_12 = arg1_12:getBody()

			arg0_12.viewComponent:UpdateRes()
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0_13, arg1_13)
			local var0_13 = arg1_13:getBody()

			if arg1_13:getType()[1] == getDorm3dGameset("drom3d_weekly_task")[1] then
				if #var0_13 > 0 then
					arg0_13.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_13, function()
						arg0_13.viewComponent:UpdateWeekTask()
					end)
				else
					arg0_13.viewComponent:UpdateWeekTask()
				end
			end
		end,
		[Dorm3dInviteMediator.ON_DORM] = function(arg0_15, arg1_15)
			local var0_15 = arg1_15:getBody()

			arg0_15:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_ROOM, var0_15)
		end,
		[ApartmentProxy.ZERO_HOUR_REFRESH] = function(arg0_16, arg1_16)
			local var0_16 = arg1_16:getBody()

			arg0_16.viewComponent:UpdateStamina()
		end
	}
end

return var0_0
