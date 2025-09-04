local var0_0 = class("FurnitureSlideExtraMediator", import("view.base.ContextMediator"))

var0_0.OPEN_INVITE_LAYER = "FurnitureSlideExtraMediator.OPEN_INVITE_LAYER"
var0_0.GO_SLIDE_PERFORMANCE = "FurnitureSlideExtraMediator.GO_SLIDE_PERFORMANCE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_INVITE_LAYER, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dSlideInviteLayer,
			mediator = Dorm3dInviteMediator,
			data = {
				groupIds = arg1_2,
				roomId = SlideConst.ROOM_ID
			}
		}))
	end)
	arg0_1:bind(var0_0.GO_SLIDE_PERFORMANCE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DORM3D_SLIDE, {
			groupId = arg1_3
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_4)
	arg0_4.handleDic = {
		[ApartmentProxy.UPDATE_SLIDE_INVITE_LIST] = function(arg0_5, arg1_5)
			local var0_5 = arg1_5:getBody()

			arg0_5.viewComponent:UpdateSlideInviteList(var0_5.groupIds, var0_5.addIds, var0_5.removeIds)
		end,
		[Dorm3dRoomScene.NOTIFY_UI_STATE] = function(arg0_6, arg1_6)
			local var0_6 = arg1_6:getBody()

			arg0_6.viewComponent:HandleDormUIState(var0_6)
		end,
		[SlideExtraSystem.SHOW_INTERACTION] = function(arg0_7, arg1_7)
			arg0_7.viewComponent:ShowInteraction()
		end,
		[SlideExtraSystem.HIDE_INTERACTION] = function(arg0_8, arg1_8)
			arg0_8.viewComponent:HideInteraction()
		end,
		[SlideExtraSystem.SHOW_PERFORMANCE] = function(arg0_9, arg1_9)
			arg0_9.viewComponent:ShowPerformance()
		end,
		[SlideExtraSystem.HIDE_PERFORMANCE] = function(arg0_10, arg1_10)
			arg0_10.viewComponent:HidePerformance()
		end
	}
end

return var0_0
