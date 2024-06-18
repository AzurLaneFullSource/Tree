local var0_0 = class("AnniversaryIslandComposite2023Mediator", import("view.base.ContextMediator"))

var0_0.OPEN_FORMULA = "OPEN_FORMULA"
var0_0.OPEN_STOREHOUSE = "AnniversaryIslandComposite2023Mediator:OPEN_STOREHOUSE"
var0_0.OPEN_UPGRADE_PANEL = "AnniversaryIslandComposite2023Mediator:OPEN_UPGRADE_PANEL"

function var0_0.register(arg0_1)
	arg0_1:bind(GAME.WORKBENCH_COMPOSITE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.WORKBENCH_COMPOSITE, {
			formulaId = arg1_2,
			repeats = arg2_2
		})
	end)
	arg0_1:bind(var0_0.OPEN_STOREHOUSE, function(arg0_3)
		arg0_1:addSubLayers(Context.New({
			mediator = AnniversaryIslandStoreHouse2023Mediator,
			viewComponent = AnniversaryIslandStoreHouse2023Window
		}))
	end)
	arg0_1:bind(var0_0.OPEN_UPGRADE_PANEL, function(arg0_4)
		arg0_1:addSubLayers(Context.New({
			mediator = AnniversaryIslandBuildingUpgrade2023WindowMediator,
			viewComponent = AnniversaryIslandBuildingUpgrade2023Window,
			data = {
				buildingID = table.keyof(AnniversaryIsland2023Scene.Buildings, "craft")
			}
		}), true)
	end)
	arg0_1:bind(WorkBenchItemDetailMediator.SHOW_DETAIL, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			mediator = WorkBenchItemDetailMediator,
			viewComponent = WorkBenchItemDetailLayer,
			data = {
				material = arg1_5
			}
		}))
	end)
	getProxy(SettingsProxy):SetWorkbenchDailyTip()
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GAME.WORKBENCH_COMPOSITE_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		var0_0.OPEN_FORMULA
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.WORKBENCH_COMPOSITE_DONE then
		arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_7)
	elseif var0_7 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_7:getConfig("type") == ActivityConst.ACTIVITY_TYPE_WORKBENCH or var1_7:getConfig("type") == ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG or var1_7:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF_2 then
			arg0_7.viewComponent:BuildActivityEnv()
			arg0_7.viewComponent:UpdateView()
		end
	elseif var0_7 == var0_0.OPEN_FORMULA then
		if not var1_7 then
			return
		end

		arg0_7.viewComponent:OnReceiveFormualRequest(var1_7)
	end
end

function var0_0.remove(arg0_8)
	return
end

return var0_0
