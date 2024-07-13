local var0_0 = class("AnniversaryIslandStoreHouse2023Mediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(WorkBenchItemDetailMediator.SHOW_DETAIL, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			mediator = WorkBenchItemDetailMediator,
			viewComponent = WorkBenchItemDetailLayer,
			data = {
				material = arg1_2
			}
		}))
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.WORKBENCH_ITEM_GO
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG then
			arg0_4.viewComponent:SetActivity(var1_4)
			arg0_4.viewComponent:UpdateView()
		end
	elseif var0_4 == GAME.WORKBENCH_ITEM_GO then
		arg0_4.viewComponent:closeView()
	end
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
