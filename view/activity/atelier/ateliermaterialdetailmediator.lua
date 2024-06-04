local var0 = class("AtelierMaterialDetailMediator", import("view.base.ContextMediator"))

var0.SHOW_DETAIL = "SHOW_DETAIL"
var0.GO_RECIPE = "GO_RECIPE"

function var0.register(arg0)
	arg0:bind(GAME.GO_SCENE, function(arg0, arg1, arg2)
		arg0.viewComponent:closeView()
		arg0:sendNotification(GAME.GO_SCENE, arg1, arg2)
	end)
	arg0:bind(var0.GO_RECIPE, function(arg0, arg1)
		arg0.viewComponent:closeView()

		if getProxy(ContextProxy):getCurrentContext():getContextByMediator(AtelierCompositeMediator) then
			arg0:sendNotification(AtelierCompositeMediator.OPEN_FORMULA, arg1)
		else
			arg0:sendNotification(GAME.GO_SCENE, SCENE.ATELIER_COMPOSITE, {
				formulaId = arg1
			})
		end
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	end
end

function var0.remove(arg0)
	return
end

return var0
