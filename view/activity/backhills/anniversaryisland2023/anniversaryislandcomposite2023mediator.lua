local var0 = class("AnniversaryIslandComposite2023Mediator", import("view.base.ContextMediator"))

var0.OPEN_FORMULA = "OPEN_FORMULA"
var0.OPEN_STOREHOUSE = "AnniversaryIslandComposite2023Mediator:OPEN_STOREHOUSE"
var0.OPEN_UPGRADE_PANEL = "AnniversaryIslandComposite2023Mediator:OPEN_UPGRADE_PANEL"

function var0.register(arg0)
	arg0:bind(GAME.WORKBENCH_COMPOSITE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.WORKBENCH_COMPOSITE, {
			formulaId = arg1,
			repeats = arg2
		})
	end)
	arg0:bind(var0.OPEN_STOREHOUSE, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = AnniversaryIslandStoreHouse2023Mediator,
			viewComponent = AnniversaryIslandStoreHouse2023Window
		}))
	end)
	arg0:bind(var0.OPEN_UPGRADE_PANEL, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = AnniversaryIslandBuildingUpgrade2023WindowMediator,
			viewComponent = AnniversaryIslandBuildingUpgrade2023Window,
			data = {
				buildingID = table.keyof(AnniversaryIsland2023Scene.Buildings, "craft")
			}
		}), true)
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
	getProxy(SettingsProxy):SetWorkbenchDailyTip()
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.WORKBENCH_COMPOSITE_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		var0.OPEN_FORMULA
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.WORKBENCH_COMPOSITE_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORKBENCH or var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG or var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
			arg0.viewComponent:BuildActivityEnv()
			arg0.viewComponent:UpdateView()
		end
	elseif var0 == var0.OPEN_FORMULA then
		if not var1 then
			return
		end

		arg0.viewComponent:OnReceiveFormualRequest(var1)
	end
end

function var0.remove(arg0)
	return
end

return var0
