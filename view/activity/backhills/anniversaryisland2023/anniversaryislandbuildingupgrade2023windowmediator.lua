local var0 = class("AnniversaryIslandBuildingUpgrade2023WindowMediator", import("view.base.ContextMediator"))

var0.ACTIVITY_OPERATION = "ACTIVITY_OPERATION"

function var0.register(arg0)
	arg0:bind(var0.ACTIVITY_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
	arg0:bind(WorkBenchItemDetailMediator.SHOW_DETAIL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = WorkBenchItemDetailMediator,
			viewComponent = WorkBenchItemDetailLayer,
			data = {
				material = arg1
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
		arg0.viewComponent:UpdateView()
	end
end

function var0.remove(arg0)
	return
end

return var0
