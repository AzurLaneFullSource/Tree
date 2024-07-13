local var0_0 = class("AnniversaryIslandBuildingUpgrade2023WindowMediator", import("view.base.ContextMediator"))

var0_0.ACTIVITY_OPERATION = "ACTIVITY_OPERATION"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ACTIVITY_OPERATION, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_2)
	end)
	arg0_1:bind(WorkBenchItemDetailMediator.SHOW_DETAIL, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = WorkBenchItemDetailMediator,
			viewComponent = WorkBenchItemDetailLayer,
			data = {
				material = arg1_3
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == ActivityProxy.ACTIVITY_UPDATED and var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
		arg0_5.viewComponent:UpdateView()
	end
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
