local var0 = class("EducateScheduleMediator", import(".base.EducateContextMediator"))

var0.GET_PLANS = "GET_PLANS"
var0.OPEN_FILTER_LAYER = "OPEN_FILTER_LAYER"

function var0.register(arg0)
	arg0:bind(var0.GET_PLANS, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_GET_PLANS, {
			plans = EducatePlanProxy.GridData2ProtData(arg1.gridData),
			isSkip = arg1.isSkip,
			callback = function()
				return
			end
		})
	end)
	arg0:bind(var0.OPEN_FILTER_LAYER, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = EducateScheduleFilterLayer,
			mediator = EducateScheduleFilterMediator,
			data = arg1
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.EDUCATE_REFRESH_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.EDUCATE_REFRESH_DONE then
		arg0.viewComponent:emit(EducateBaseUI.EDUCATE_CHANGE_SCENE, SCENE.EDUCATE)
	end
end

return var0
