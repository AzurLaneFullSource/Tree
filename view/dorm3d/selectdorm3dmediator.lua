local var0_0 = class("SelectDorm3DMediator", import("view.base.ContextMediator"))

var0_0.ON_DORM = "SelectDorm3DMediator.ON_DORM"
var0_0.ON_UNLOCK_DORM_ROOM = "SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM"
var0_0.ON_SUBMIT_TASK = "SelectDorm3DMediator.ON_SUBMIT_TASK"
var0_0.OPEN_INVITE_LAYER = "SelectDorm3DMediator.OPEN_INVITE_LAYER"
var0_0.OPEN_ROOM_UNLOCK_WINDOW = "SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW"
var0_0.OPEN_INS_LAYER = "SelectDorm3DMediator.OPEN_INS_LAYER"
var0_0.OPEN_SHOP_LAYER = "SelectDorm3DMediator.OPEN_SHOP_LAYER"
var0_0.OPEN_SETTING_LAYER = "SelectDorm3DMediator.OPEN_SETTING_LAYER"

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
	arg0_1:bind(var0_0.OPEN_INVITE_LAYER, function(arg0_6, arg1_6, arg2_6, arg3_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dInviteLayer,
			mediator = Dorm3dInviteMediator,
			data = {
				roomId = arg1_6,
				groupIds = arg2_6
			},
			onRemoved = arg3_6
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
	arg0_1:bind(var0_0.OPEN_SHOP_LAYER, function(arg0_9, arg1_9)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dShopUI,
			mediator = Dorm3dShopMediator,
			onRemoved = arg1_9
		}))
	end)
	arg0_1:bind(var0_0.OPEN_SETTING_LAYER, function(arg0_10)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dSettingScene,
			mediator = NewSettingsMediator
		}))
	end)

	if not arg0_1.contextData.hasEnterCheck then
		arg0_1.contextData.hasEnterCheck = true

		arg0_1:sendNotification(GAME.SELECT_DORM_ENTER)
	end
end

function var0_0.initNotificationHandleDic(arg0_11)
	arg0_11.handleDic = {
		[DormGroupConst.NotifyDormDownloadStart] = function(arg0_12, arg1_12)
			local var0_12 = arg1_12:getBody()

			arg0_12.viewComponent:DownloadUpdate(DormGroupConst.DormDownloadLock.roomId, "start")
		end,
		[DormGroupConst.NotifyDormDownloadProgress] = function(arg0_13, arg1_13)
			local var0_13 = arg1_13:getBody()

			arg0_13.viewComponent:DownloadUpdate(DormGroupConst.DormDownloadLock.roomId, "loading")
		end,
		[DormGroupConst.NotifyDormDownloadFinish] = function(arg0_14, arg1_14)
			arg0_14.viewComponent:DownloadUpdate(arg1_14:getBody(), "finish")
		end,
		[Dorm3dInsMainMediator.NotifyDormDelete] = function(arg0_15, arg1_15)
			arg0_15.viewComponent:DownloadUpdate(arg1_15:getBody(), "delete")
		end,
		[GAME.APARTMENT_ROOM_UNLOCK_DONE] = function(arg0_16, arg1_16)
			local var0_16 = arg1_16:getBody()

			arg0_16.viewComponent:AfterRoomUnlock(var0_16)
		end,
		[PlayerProxy.UPDATED] = function(arg0_17, arg1_17)
			local var0_17 = arg1_17:getBody()

			arg0_17.viewComponent:UpdateRes()
		end,
		[GAME.SUBMIT_TASK_DONE] = function(arg0_18, arg1_18)
			local var0_18 = arg1_18:getBody()

			if arg1_18:getType()[1] == getDorm3dGameset("drom3d_weekly_task")[1] then
				if #var0_18 > 0 then
					arg0_18.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_18, function()
						arg0_18.viewComponent:UpdateWeekTask()
					end)
				else
					arg0_18.viewComponent:UpdateWeekTask()
				end
			end
		end,
		[Dorm3dInviteMediator.ON_DORM] = function(arg0_20, arg1_20)
			local var0_20 = arg1_20:getBody()

			arg0_20:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_ROOM, var0_20)
		end,
		[ApartmentProxy.ZERO_HOUR_REFRESH] = function(arg0_21, arg1_21)
			local var0_21 = arg1_21:getBody()

			arg0_21.viewComponent:UpdateStamina()
		end,
		[GAME.APARTMENT_ROOM_INVITE_UNLOCK_DONE] = function(arg0_22, arg1_22)
			local var0_22 = arg1_22:getBody()
			local var1_22 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt(var1_22 .. "_dorm3dRoomInviteSuccess_" .. var0_22.roomId, 0)
			PlayerPrefs.SetInt(var1_22 .. "_dorm3dRoomInviteSuccess_" .. var0_22.roomId .. "_" .. var0_22.groupId, 0)
			arg0_22.viewComponent:FlushFloor()
		end
	}
end

return var0_0
