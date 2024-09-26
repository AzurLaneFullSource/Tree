local var0_0 = class("Dorm3dARMediator", import("view.base.ContextMediator"))

var0_0.IN_ITAR_PHOTO = "Dorm3dARMediator:IN_ITAR_PHOTO"
var0_0.INIT_AR_PLANE = "Dorm3dARMediator:INIT_AR_PLANE"
var0_0.AR_INIT_FINISH = "Dorm3dARMediator:AR_INIT_FINISH"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.IN_ITAR_PHOTO, function()
		arg0_1:addSubLayers(Context.New({
			mediator = Dorm3dPhotoARMediator,
			viewComponent = Dorm3dPhotoARLayer,
			data = {
				roomId = arg0_1.contextData.roomId,
				groupId = arg0_1.contextData.groupId
			}
		}))
	end)
	arg0_1:bind(var0_0.INIT_AR_PLANE, function()
		arg0_1:sendNotification(var0_0.INIT_AR_PLANE)
	end)
	arg0_1:bind(var0_0.AR_INIT_FINISH, function()
		arg0_1:sendNotification(var0_0.AR_INIT_FINISH)
	end)
	arg0_1.viewComponent:SetARLite(arg0_1.contextData.ARCheckState)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		Dorm3dPhotoShareLayerMediator.EXIT_SHARE,
		Dorm3dPhotoARMediator.AR_PHOTO_INITED,
		Dorm3dPhotoARMediator.ACTIVE_AR_UI,
		Dorm3dPhotoARMediator.SCENE_CALL
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == Dorm3dPhotoShareLayerMediator.EXIT_SHARE then
		arg0_6.viewComponent:SetARUIActive(true)
	elseif var0_6 == Dorm3dPhotoARMediator.AR_PHOTO_INITED then
		arg0_6.viewComponent:InitARPlane()
	elseif var0_6 == Dorm3dPhotoARMediator.ACTIVE_AR_UI then
		arg0_6.viewComponent:SetARUIActive(var1_6.flag)
	elseif var0_6 == Dorm3dPhotoARMediator.SCENE_CALL then
		arg0_6.viewComponent[var1_6.name](arg0_6.viewComponent, unpackEx(var1_6.args))
	end
end

return var0_0
