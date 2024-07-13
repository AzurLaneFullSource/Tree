local var0_0 = class("EducateScheduleMediator", import(".base.EducateContextMediator"))

var0_0.GET_PLANS = "GET_PLANS"
var0_0.OPEN_FILTER_LAYER = "OPEN_FILTER_LAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GET_PLANS, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.EDUCATE_GET_PLANS, {
			plans = EducatePlanProxy.GridData2ProtData(arg1_2.gridData),
			isSkip = arg1_2.isSkip,
			callback = function()
				return
			end
		})
	end)
	arg0_1:bind(var0_0.OPEN_FILTER_LAYER, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EducateScheduleFilterLayer,
			mediator = EducateScheduleFilterMediator,
			data = arg1_4
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.EDUCATE_REFRESH_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.EDUCATE_REFRESH_DONE then
		arg0_6.viewComponent:emit(EducateBaseUI.EDUCATE_CHANGE_SCENE, SCENE.EDUCATE)
	end
end

return var0_0
