local var0 = class("Dorm3dSceneMediator", import("view.base.ContextMediator"))

var0.TRIGGER_FAVOR = "Dorm3dSceneMediator.TRIGGER_FAVOR"
var0.FAVOR_LEVEL_UP = "Dorm3dSceneMediator.FAVOR_LEVEL_UP"
var0.TALKING_EVENT_FINISH = "Dorm3dSceneMediator.TALKING_EVENT_FINISH"
var0.DO_TALK = "Dorm3dSceneMediator.DO_TALK"
var0.COLLECTION_ITEM = "Dorm3dSceneMediator.COLLECTION_ITEM"
var0.OPEN_FURNITURE_SELECT = "Dorm3dSceneMediator.OPEN_FURNITURE_SELECT"
var0.OPEN_LEVEL_LAYER = "Dorm3dSceneMediator.OPEN_LEVEL_LAYER"
var0.OPEN_GIFT_LAYER = "Dorm3dSceneMediator.OPEN_GIFT_LAYER"
var0.OPEN_CAMERA_LAYER = "Dorm3dSceneMediator.OPEN_CAMERA_LAYER"
var0.OPEN_DROP_LAYER = "Dorm3dSceneMediator.OPEN_DROP_LAYER"
var0.OPEN_COLLECTION_LAYER = "Dorm3dSceneMediator.OPEN_COLLECTION_LAYER"
var0.ON_CLICK_FURNITURE_SLOT = "Dorm3dSceneMediator.ON_CLICK_FURNITURE_SLOT"
var0.OTHER_DO_TALK = "Dorm3dSceneMediator.OTHER_DO_TALK"
var0.OTHER_CHECK_LEVEL_UP = "Dorm3dSceneMediator.OTHER_CHECK_LEVEL_UP"
var0.CHAMGE_TIME_RELOAD_SCENE = "Dorm3dSceneMediator.CHAMGE_TIME_RELOAD_SCENE"

function var0.register(arg0)
	arg0:bind(var0.TRIGGER_FAVOR, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.APARTMENT_TRIGGER_FAVOR, {
			groupId = arg1,
			triggerId = arg2
		})
	end)
	arg0:bind(var0.FAVOR_LEVEL_UP, function(arg0, arg1)
		arg0:sendNotification(GAME.APARTMENT_LEVEL_UP, {
			groupId = arg1
		})
	end)
	arg0:bind(var0.TALKING_EVENT_FINISH, function(arg0, arg1, arg2)
		arg0:sendNotification(arg1, arg2)
	end)
	arg0:bind(var0.OPEN_FURNITURE_SELECT, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = Dorm3dFurnitureSelectMediator,
			viewComponent = Dorm3dFurnitureSelectLayer,
			data = arg0.contextData,
			onRemoved = function()
				arg0.viewComponent:ShowBaseView()
			end
		}), nil, function()
			arg0.viewComponent:HideBaseView()
		end)
	end)
	arg0:bind(var0.ON_CLICK_FURNITURE_SLOT, function(arg0, arg1)
		arg0:sendNotification(arg0, arg1)
	end)
	arg0:bind(var0.OPEN_LEVEL_LAYER, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = Dorm3dLevelLayer,
			mediator = Dorm3dLevelMediator,
			data = {
				groupId = arg0.contextData.groupId,
				timeIndex = arg0.contextData.timeIndex
			},
			onRemoved = function()
				arg0.viewComponent:ShowBaseView()
			end
		}), nil, function()
			arg0.viewComponent:HideBaseView()
		end)
	end)
	arg0:bind(var0.OPEN_GIFT_LAYER, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = Dorm3dGiftLayer,
			mediator = Dorm3dGiftMediator,
			data = {
				groupId = arg0.contextData.groupId
			},
			onRemoved = function()
				arg0:SetBlackboardValue("inLockLayer", false)
				arg0.viewComponent:ShowBaseView()
			end
		}), nil, function()
			arg0:SetBlackboardValue("inLockLayer", true)
			arg0.viewComponent:HideBaseView()
		end)
	end)
	arg0:bind(var0.OPEN_CAMERA_LAYER, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = Dorm3dPhotoLayer,
			mediator = Dorm3dPhotoMediator,
			data = arg0.contextData,
			onRemoved = function()
				arg0.viewComponent:ShowBaseView()
			end
		}), nil, function()
			arg0.viewComponent:HideBaseView()
		end)
	end)
	arg0:bind(var0.OPEN_DROP_LAYER, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			viewComponent = Dorm3dAwardInfoLayer,
			mediator = Dorm3dAwardInfoMediator,
			data = {
				items = arg1
			},
			onRemoved = arg2
		}))
	end)
	arg0:bind(var0.OPEN_COLLECTION_LAYER, function(arg0)
		arg0:addSubLayers(Context.New({
			viewComponent = Dorm3dCollectionLayer,
			mediator = Dorm3dCollectionMediator,
			data = arg0.contextData
		}))
	end)
	arg0:bind(var0.DO_TALK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.APARTMENT_DO_TALK, {
			talkId = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.COLLECTION_ITEM, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.APARTMENT_COLLECTION_ITEM, {
			groupId = arg1,
			itemId = arg2
		})
	end)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.APARTMENT_TRIGGER_FAVOR_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent.baseView:PopFavorTrigger(var0.triggerId, var0.delta, var0.apartment)
			arg0.viewComponent:SetApartment(var0.apartment)
			arg0.viewComponent.baseView:CheckFavorTrigger()
		end,
		[GAME.APARTMENT_LEVEL_UP_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent.baseView:PopFavorLevelUp(var0, function()
				arg0.viewComponent:SetApartment(var0)
				arg0.viewComponent.baseView:CheckFavorTrigger()
			end)
		end,
		[STORY_EVENT.TEST] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent.baseView:TalkingEventHandle(var0)
		end,
		[ApartmentProxy.UPDATE_APARTMENT] = function(arg0, arg1)
			arg0.viewComponent:SetApartment(arg1:getBody())
		end,
		[var0.OTHER_DO_TALK] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent.baseView:DoTalk(var0.talkId, var0.moveCamera, var0.callback)
		end,
		[var0.OTHER_CHECK_LEVEL_UP] = function(arg0, arg1)
			arg0.viewComponent.baseView:CheckLevelUp()
		end,
		[GAME.APARTMENT_CHANGE_SKIN_DONE] = function(arg0, arg1)
			arg0:ReloadScene()
		end,
		[GAME.APARTMENT_DO_TALK_DONE] = function(arg0, arg1)
			return
		end,
		[GAME.APARTMENT_COLLECTION_ITEM_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0:addSubLayers(Context.New({
				viewComponent = Dorm3dCollectAwardLayer,
				mediator = Dorm3dCollectAwardMediator,
				data = {
					itemId = var0.itemId
				}
			}))
		end,
		[var0.CHAMGE_TIME_RELOAD_SCENE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.contextData.timeIndex = var0.timeIndex

			arg0:ReloadScene()
		end
	}
end

function var0.ReloadScene(arg0)
	pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0)
		local var0 = Clone(arg0.contextData)

		var0.resumeCallback = arg0
		var0.showLoading = false

		arg0:sendNotification(GAME.RELOAD_SCENE, var0)
	end)
end

function var0.remove(arg0)
	return
end

return var0
