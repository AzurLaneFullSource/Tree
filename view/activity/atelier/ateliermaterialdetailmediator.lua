local var0_0 = class("AtelierMaterialDetailMediator", import("view.base.ContextMediator"))

var0_0.SHOW_DETAIL = "SHOW_DETAIL"
var0_0.GO_RECIPE = "GO_RECIPE"

function var0_0.register(arg0_1)
	arg0_1:bind(GAME.GO_SCENE, function(arg0_2, arg1_2, arg2_2)
		arg0_1.viewComponent:closeView()
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, arg2_2)
	end)
	arg0_1:bind(var0_0.GO_RECIPE, function(arg0_3, arg1_3)
		arg0_1.viewComponent:closeView()

		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(AtelierCompositeMediator) then
			arg0_1:sendNotification(AtelierCompositeMediator.OPEN_FORMULA, arg1_3)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ATELIER_COMPOSITE, {
				formulaId = arg1_3
			})
		end
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == nil then
		-- block empty
	end
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
