local var0_0 = class("SelectDorm3DMediator", import("view.base.ContextMediator"))

var0_0.ON_DORM = "SelectDorm3DMediator.ON_DORM"
var0_0.ON_UNLOCK_DORM_ROOM = "SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM"
var0_0.ON_SUBMIT_TASK = "SelectDorm3DMediator.ON_SUBMIT_TASK"
var0_0.OPEN_INVITE_LAYER = "SelectDorm3DMediator.OPEN_INVITE_LAYER"
var0_0.OPEN_ROOM_UNLOCK_WINDOW = "SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW"
var0_0.OPEN_INS_LAYER = "SelectDorm3DMediator.OPEN_INS_LAYER"

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
	arg0_1:bind(var0_0.OPEN_INS_LAYER, function(arg0_7, arg1_7)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dInsMainLayer,
			mediator = Dorm3dInsMainMediator,
			data = {
				isPhone = arg1_7
			},
			onRemoved = function()
				arg0_1.viewComponent:FlushInsBtn()
			end
		}))
	end)

	if not arg0_1.contextData.hasEnterCheck then
		arg0_1.contextData.hasEnterCheck = true

		arg0_1:sendNotification(GAME.SELECT_DORM_ENTER)
	end
end

function var0_0.initNotificationHandleDic(arg0_9)
	arg0_9.handleDic = {
		[DormGroupConst.NotifyDormDownloadStart] = function(arg0_10, arg1_10)
			local var0_10 = arg1_10:getBody()

			arg0_10.viewComponent:DownloadUpdate(DormGroupConst.DormDownloadLock.roomId, "start")
		end,
		[DormGroupConst.NotifyDormDownloadProgress] = function(arg0_11, arg1_11)
			local var0_11 = arg1_11:getBody()

			arg0_11.viewComponent:DownloadUpdate(DormGroupConst.DormDownloadLock.roomId, "loading")
		end,
		[DormGroupConst.NotifyDormDownloadFinish] = function(arg0_12, arg1_12)
			arg0_12.viewComponent:DownloadUpdate(arg1_12:getBody(), "finish")
		end,
		[Dorm3dInsMainMediator.NotifyDormDelete] = function(arg0_13, arg1_13)
			arg0_13.viewComponent:DownloadUpdate(arg1_13:getBody(), "delete")
		end,
		[GAME.APARTMENT_ROOM_UNLOCK_DONE] = function(arg0_14, arg1_14)
			local var0_14 = arg1_14:getBody()

			arg0_14.viewComponent:AfterRoomUnlock(var0_14)
		end,
		[PlayerProxy.UPDATED] = function(arg0_15, arg1_15)
			local var0_15 = arg1_15:getBody()

			arg0_15.viewComponent:UpdateRes()
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0_16, arg1_16)
			local var0_16 = arg1_16:getBody()

			if arg1_16:getType()[1] == getDorm3dGameset("drom3d_weekly_task")[1] then
				if #var0_16 > 0 then
					arg0_16.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_16, function()
						arg0_16.viewComponent:UpdateWeekTask()
					end)
				else
					arg0_16.viewComponent:UpdateWeekTask()
				end
			end
		end,
		[Dorm3dInviteMediator.ON_DORM] = function(arg0_18, arg1_18)
			local var0_18 = arg1_18:getBody()

			arg0_18:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_ROOM, var0_18)
		end,
		[ApartmentProxy.ZERO_HOUR_REFRESH] = function(arg0_19, arg1_19)
			local var0_19 = arg1_19:getBody()

			arg0_19.viewComponent:UpdateStamina()
		end
	}
end

return var0_0
