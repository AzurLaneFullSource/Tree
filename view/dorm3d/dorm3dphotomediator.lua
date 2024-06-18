local var0_0 = class("Dorm3dPhotoMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	local var0_1 = pg.m02:retrieveMediator(Dorm3dSceneMediator.__cname):getViewComponent()

	arg0_1.viewComponent:SetSceneRoot(var0_1)

	local var1_1 = var0_1:GetApartment()

	arg0_1.viewComponent:SetApartment(var1_1)
	arg0_1:bind(SnapshotScene.SHARE_PANEL, function(arg0_2, arg1_2, arg2_2)
		arg0_1:addSubLayers(Context.New({
			mediator = SnapshotShareMediator,
			viewComponent = SnapshotShareLayer,
			data = {
				photoTex = arg1_2,
				photoData = arg2_2
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		ApartmentProxy.UPDATE_APARTMENT
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == ApartmentProxy.UPDATE_APARTMENT then
		-- block empty
	end
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
