local var0_0 = class("Dorm3dPhotoARMediator", import("view.base.ContextMediator"))

var0_0.SHARE_PANEL = "Dorm3dPhotoARMediator:SHARE_PANEL"
var0_0.Camera_Pinch_Value_Change = "Camera_Pinch_Value_Change"
var0_0.PLAY_SINGLE_ACTION = "Dorm3dPhotoARMediator.PLAY_SINGLE_ACTION"
var0_0.SCENE_CALL = "Dorm3dPhotoARMediator.SCENE_CALL"
var0_0.EXIT_SHARE = "Dorm3dPhotoARMediator:EXIT_SHARE"
var0_0.AR_PHOTO_INITED = "Dorm3dPhotoARMediator:AR_PHOTO_INITED"
var0_0.ACTIVE_AR_UI = "Dorm3dPhotoARMediator:ACTIVE_AR_UI"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.SHARE_PANEL, function(arg0_2, arg1_2, arg2_2)
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dPhotoShareLayerMediator,
			viewComponent = Dorm3dPhotoShareLayer,
			data = {
				photoTex = arg1_2,
				photoData = arg2_2
			}
		}))
	end)
	arg0_1:bind(var0_0.PLAY_SINGLE_ACTION, function(arg0_3, arg1_3)
		arg0_1:sendNotification(Dorm3dPhotoARMediator.PLAY_SINGLE_ACTION, {
			name = arg1_3
		})
	end)
	arg0_1:bind(var0_0.SCENE_CALL, function(arg0_4, arg1_4, ...)
		arg0_1:sendNotification(Dorm3dPhotoARMediator.SCENE_CALL, {
			name = arg1_4,
			args = packEx(...)
		})
	end)
	arg0_1:bind(var0_0.AR_PHOTO_INITED, function()
		arg0_1:sendNotification(var0_0.AR_PHOTO_INITED)
	end)
	arg0_1:bind(var0_0.ACTIVE_AR_UI, function(arg0_6, arg1_6)
		arg0_1:sendNotification(var0_0.ACTIVE_AR_UI, {
			flag = arg1_6
		})
	end)
	arg0_1.viewComponent:SetRoom(arg0_1.contextData.roomId)
	arg0_1.viewComponent:SetGroupId(arg0_1.contextData.groupId)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		ApartmentProxy.UPDATE_APARTMENT,
		var0_0.Camera_Pinch_Value_Change,
		Dorm3dARMediator.INIT_AR_PLANE,
		Dorm3dARMediator.AR_INIT_FINISH
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == ApartmentProxy.UPDATE_APARTMENT then
		-- block empty
	elseif var0_8 == var0_0.Camera_Pinch_Value_Change then
		arg0_8.viewComponent:SetCamaraPinchSliderValue(arg1_8.body.value)
	elseif var0_8 == Dorm3dARMediator.INIT_AR_PLANE then
		arg0_8.viewComponent:SetPhotoUIActive(false)
	elseif var0_8 == Dorm3dARMediator.AR_INIT_FINISH then
		arg0_8.viewComponent:SetPhotoUIActive(true)
	end
end

function var0_0.remove(arg0_9)
	return
end

return var0_0
