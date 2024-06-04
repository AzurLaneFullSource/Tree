local var0 = class("AnniversaryIslandStoreHouse2023Mediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(WorkBenchItemDetailMediator.SHOW_DETAIL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = WorkBenchItemDetailMediator,
			viewComponent = WorkBenchItemDetailLayer,
			data = {
				material = arg1
			}
		}))
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	arg0.viewComponent:SetActivity(var0)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.WORKBENCH_ITEM_GO
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG then
			arg0.viewComponent:SetActivity(var1)
			arg0.viewComponent:UpdateView()
		end
	elseif var0 == GAME.WORKBENCH_ITEM_GO then
		arg0.viewComponent:closeView()
	end
end

function var0.remove(arg0)
	return
end

return var0
