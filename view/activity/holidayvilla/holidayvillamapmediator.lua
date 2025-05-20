local var0_0 = class("HolidayVillaMapMediator", import("view.base.ContextMediator"))

var0_0.EXCHANGE_RESOURCES = "HolidayVillaMapMediator.EXCHANGE_RESOURCES"
var0_0.SITE_CLICKED = "HolidayVillaMapMediator.SITE_CLICKED"
var0_0.ON_TASK_SUBMIT_ONESTEP = "HolidayVillaMapMediator.ON_TASK_SUBMIT_ONESTEP"
var0_0.OPEN_WHARF = "HolidayVillaMapMediator.OPEN_WHARF"
var0_0.OPEN_HolidayVilla_TASk = "HolidayVillaMapMediator.OPEN_HolidayVilla_TASk"
var0_0.ON_SHOP = "HolidayVillaMapMediator.ON_SHOP"
var0_0.ON_BOOK = "HolidayVillaMapMediator.ON_BOOK"
var0_0.GO_HOTSPRING = "HolidayVillaMapMediator.GO_HOTSPRING"
var0_0.OPEN_MINI_GAME = "HolidayVillaMapMediator.OPEN_MINI_GAME"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_HOTSPRING, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.HOLIDAY_VILLA_HOTSPRING)
	end)
	arg0_1:bind(var0_0.EXCHANGE_RESOURCES, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg1_3
		})
	end)
	arg0_1:bind(var0_0.SITE_CLICKED, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			activity_id = arg1_4,
			arg1 = arg2_4
		})
	end)
	arg0_1:bind(var0_0.ON_SHOP, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			mediator = HolidayVillaShopMediator,
			viewComponent = HolidayVillaShopLayer
		}))
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT_ONESTEP, function(arg0_6, arg1_6, arg2_6, arg3_6)
		arg0_1:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = arg1_6,
			task_ids = arg2_6,
			callback = arg3_6
		})
	end)
	arg0_1:bind(var0_0.OPEN_WHARF, function(arg0_7)
		arg0_1:addSubLayers(Context.New({
			viewComponent = HolidayVillaWharfLayer,
			mediator = HolidayVillaWharfMediator
		}))
	end)
	arg0_1:bind(var0_0.OPEN_HolidayVilla_TASk, function(arg0_8, arg1_8)
		arg0_1:addSubLayers(Context.New({
			viewComponent = HolidayVillaTasksLayer,
			mediator = HolidayVillaTasksMediator,
			onRemoved = arg1_8
		}))
	end)
	arg0_1:bind(var0_0.ON_BOOK, function(arg0_9, arg1_9)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CollectionBookLayer,
			mediator = CollectionBookMediator
		}))
	end)
	arg0_1:bind(var0_0.OPEN_MINI_GAME, function(arg0_10, arg1_10)
		arg0_1:sendNotification(GAME.GO_MINI_GAME, arg1_10)
	end)
end

function var0_0.listNotificationInterests(arg0_11)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE,
		ActivityProxy.ACTIVITY_EXCHANGE_RESOURCES,
		GAME.STORY_UPDATE_DONE,
		GAME.ISLAND_SHOPPING_DONE
	}
end

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()

	if var0_12 == ActivityProxy.ACTIVITY_OPERATION_DONE or var0_12 == GAME.SUBMIT_ACTIVITY_TASK_DONE or var0_12 == GAME.ISLAND_SHOPPING_DONE then
		arg0_12.viewComponent:RefreshData()
		arg0_12.viewComponent:Show()
	elseif var0_12 == ActivityProxy.ACTIVITY_EXCHANGE_RESOURCES then
		arg0_12.viewComponent:RefreshData()
		arg0_12.viewComponent:Show()
		arg0_12.viewComponent:ShowAllRepairPage()
	elseif var0_12 == GAME.STORY_UPDATE_DONE then
		getProxy(TaskProxy):pushAutoSubmitTask()
	end
end

return var0_0
