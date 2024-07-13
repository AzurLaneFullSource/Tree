local var0_0 = class("Dorm3dSceneMediator", import("view.base.ContextMediator"))

var0_0.TRIGGER_FAVOR = "Dorm3dSceneMediator.TRIGGER_FAVOR"
var0_0.FAVOR_LEVEL_UP = "Dorm3dSceneMediator.FAVOR_LEVEL_UP"
var0_0.TALKING_EVENT_FINISH = "Dorm3dSceneMediator.TALKING_EVENT_FINISH"
var0_0.DO_TALK = "Dorm3dSceneMediator.DO_TALK"
var0_0.COLLECTION_ITEM = "Dorm3dSceneMediator.COLLECTION_ITEM"
var0_0.OPEN_FURNITURE_SELECT = "Dorm3dSceneMediator.OPEN_FURNITURE_SELECT"
var0_0.OPEN_LEVEL_LAYER = "Dorm3dSceneMediator.OPEN_LEVEL_LAYER"
var0_0.OPEN_GIFT_LAYER = "Dorm3dSceneMediator.OPEN_GIFT_LAYER"
var0_0.OPEN_CAMERA_LAYER = "Dorm3dSceneMediator.OPEN_CAMERA_LAYER"
var0_0.OPEN_DROP_LAYER = "Dorm3dSceneMediator.OPEN_DROP_LAYER"
var0_0.OPEN_COLLECTION_LAYER = "Dorm3dSceneMediator.OPEN_COLLECTION_LAYER"
var0_0.ON_CLICK_FURNITURE_SLOT = "Dorm3dSceneMediator.ON_CLICK_FURNITURE_SLOT"
var0_0.OTHER_DO_TALK = "Dorm3dSceneMediator.OTHER_DO_TALK"
var0_0.OTHER_CHECK_LEVEL_UP = "Dorm3dSceneMediator.OTHER_CHECK_LEVEL_UP"
var0_0.CHAMGE_TIME_RELOAD_SCENE = "Dorm3dSceneMediator.CHAMGE_TIME_RELOAD_SCENE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.TRIGGER_FAVOR, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.APARTMENT_TRIGGER_FAVOR, {
			groupId = arg1_2,
			triggerId = arg2_2
		})
	end)
	arg0_1:bind(var0_0.FAVOR_LEVEL_UP, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.APARTMENT_LEVEL_UP, {
			groupId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.TALKING_EVENT_FINISH, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(arg1_4, arg2_4)
	end)
	arg0_1:bind(var0_0.OPEN_FURNITURE_SELECT, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dFurnitureSelectMediator,
			viewComponent = Dorm3dFurnitureSelectLayer,
			data = arg0_1.contextData,
			onRemoved = function()
				arg0_1.viewComponent:ShowBaseView()
			end
		}), nil, function()
			arg0_1.viewComponent:HideBaseView()
		end)
	end)
	arg0_1:bind(var0_0.ON_CLICK_FURNITURE_SLOT, function(arg0_8, arg1_8)
		arg0_1:sendNotification(arg0_8, arg1_8)
	end)
	arg0_1:bind(var0_0.OPEN_LEVEL_LAYER, function(arg0_9)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dLevelLayer,
			mediator = Dorm3dLevelMediator,
			data = {
				groupId = arg0_1.contextData.groupId,
				timeIndex = arg0_1.contextData.timeIndex
			},
			onRemoved = function()
				arg0_1.viewComponent:ShowBaseView()
			end
		}), nil, function()
			arg0_1.viewComponent:HideBaseView()
		end)
	end)
	arg0_1:bind(var0_0.OPEN_GIFT_LAYER, function(arg0_12)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dGiftLayer,
			mediator = Dorm3dGiftMediator,
			data = {
				groupId = arg0_1.contextData.groupId
			},
			onRemoved = function()
				arg0_1:SetBlackboardValue("inLockLayer", false)
				arg0_1.viewComponent:ShowBaseView()
			end
		}), nil, function()
			arg0_1:SetBlackboardValue("inLockLayer", true)
			arg0_1.viewComponent:HideBaseView()
		end)
	end)
	arg0_1:bind(var0_0.OPEN_CAMERA_LAYER, function(arg0_15)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dPhotoLayer,
			mediator = Dorm3dPhotoMediator,
			data = arg0_1.contextData,
			onRemoved = function()
				arg0_1.viewComponent:ShowBaseView()
			end
		}), nil, function()
			arg0_1.viewComponent:HideBaseView()
		end)
	end)
	arg0_1:bind(var0_0.OPEN_DROP_LAYER, function(arg0_18, arg1_18, arg2_18)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dAwardInfoLayer,
			mediator = Dorm3dAwardInfoMediator,
			data = {
				items = arg1_18
			},
			onRemoved = arg2_18
		}))
	end)
	arg0_1:bind(var0_0.OPEN_COLLECTION_LAYER, function(arg0_19)
		arg0_1:addSubLayers(Context.New({
			viewComponent = Dorm3dCollectionLayer,
			mediator = Dorm3dCollectionMediator,
			data = arg0_1.contextData
		}))
	end)
	arg0_1:bind(var0_0.DO_TALK, function(arg0_20, arg1_20, arg2_20)
		arg0_1:sendNotification(GAME.APARTMENT_DO_TALK, {
			talkId = arg1_20,
			callback = arg2_20
		})
	end)
	arg0_1:bind(var0_0.COLLECTION_ITEM, function(arg0_21, arg1_21, arg2_21)
		arg0_1:sendNotification(GAME.APARTMENT_COLLECTION_ITEM, {
			groupId = arg1_21,
			itemId = arg2_21
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_22)
	arg0_22.handleDic = {
		[GAME.APARTMENT_TRIGGER_FAVOR_DONE] = function(arg0_23, arg1_23)
			local var0_23 = arg1_23:getBody()

			arg0_23.viewComponent.baseView:PopFavorTrigger(var0_23.triggerId, var0_23.delta, var0_23.apartment)
			arg0_23.viewComponent:SetApartment(var0_23.apartment)
			arg0_23.viewComponent.baseView:CheckFavorTrigger()
		end,
		[GAME.APARTMENT_LEVEL_UP_DONE] = function(arg0_24, arg1_24)
			local var0_24 = arg1_24:getBody()

			arg0_24.viewComponent.baseView:PopFavorLevelUp(var0_24, function()
				arg0_24.viewComponent:SetApartment(var0_24)
				arg0_24.viewComponent.baseView:CheckFavorTrigger()
			end)
		end,
		[STORY_EVENT.TEST] = function(arg0_26, arg1_26)
			local var0_26 = arg1_26:getBody()

			arg0_26.viewComponent.baseView:TalkingEventHandle(var0_26)
		end,
		[ApartmentProxy.UPDATE_APARTMENT] = function(arg0_27, arg1_27)
			arg0_27.viewComponent:SetApartment(arg1_27:getBody())
		end,
		[var0_0.OTHER_DO_TALK] = function(arg0_28, arg1_28)
			local var0_28 = arg1_28:getBody()

			arg0_28.viewComponent.baseView:DoTalk(var0_28.talkId, var0_28.moveCamera, var0_28.callback)
		end,
		[var0_0.OTHER_CHECK_LEVEL_UP] = function(arg0_29, arg1_29)
			arg0_29.viewComponent.baseView:CheckLevelUp()
		end,
		[GAME.APARTMENT_CHANGE_SKIN_DONE] = function(arg0_30, arg1_30)
			arg0_30:ReloadScene()
		end,
		[GAME.APARTMENT_DO_TALK_DONE] = function(arg0_31, arg1_31)
			return
		end,
		[GAME.APARTMENT_COLLECTION_ITEM_DONE] = function(arg0_32, arg1_32)
			local var0_32 = arg1_32:getBody()

			arg0_32:addSubLayers(Context.New({
				viewComponent = Dorm3dCollectAwardLayer,
				mediator = Dorm3dCollectAwardMediator,
				data = {
					itemId = var0_32.itemId
				}
			}))
		end,
		[var0_0.CHAMGE_TIME_RELOAD_SCENE] = function(arg0_33, arg1_33)
			local var0_33 = arg1_33:getBody()

			arg0_33.contextData.timeIndex = var0_33.timeIndex

			arg0_33:ReloadScene()
		end
	}
end

function var0_0.ReloadScene(arg0_34)
	pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_35)
		local var0_35 = Clone(arg0_34.contextData)

		var0_35.resumeCallback = arg0_35
		var0_35.showLoading = false

		arg0_34:sendNotification(GAME.RELOAD_SCENE, var0_35)
	end)
end

function var0_0.remove(arg0_36)
	return
end

return var0_0
