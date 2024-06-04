local var0 = class("Dorm3dPhotoMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	local var0 = pg.m02:retrieveMediator(Dorm3dSceneMediator.__cname):getViewComponent()

	arg0.viewComponent:SetSceneRoot(var0)

	local var1 = var0:GetApartment()

	arg0.viewComponent:SetApartment(var1)
	arg0:bind(SnapshotScene.SHARE_PANEL, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = SnapshotShareMediator,
			viewComponent = SnapshotShareLayer,
			data = {
				photoTex = arg1,
				photoData = arg2
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ApartmentProxy.UPDATE_APARTMENT
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ApartmentProxy.UPDATE_APARTMENT then
		-- block empty
	end
end

function var0.remove(arg0)
	return
end

return var0
