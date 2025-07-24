local var0_0 = class("AtelierStoreBaseMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(AtelierMaterialDetailMediator.SHOW_DETAIL, function(arg0_2, arg1_2)
		local var0_2 = arg1_2:GetVersion()
		local var1_2

		if var0_2 == 1 then
			var1_2 = AtelierMaterialDetailLayer
		else
			var1_2 = AtelierMaterialDetailYumiaLayer
		end

		arg0_1:addSubLayers(Context.New({
			mediator = AtelierMaterialDetailMediator,
			viewComponent = var1_2,
			data = {
				material = arg1_2
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		AtelierCompositeMediator.OPEN_FORMULA
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == AtelierCompositeMediator.OPEN_FORMULA then
		arg0_4.viewComponent:closeView()
	end
end

return var0_0
