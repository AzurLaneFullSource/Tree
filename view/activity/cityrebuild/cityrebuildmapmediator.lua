local var0_0 = class("CityRebuildMapMediator", import("view.base.ContextMediator"))

var0_0.GET_DATA = "CityRebuildMapMediator.GET_DATA"
var0_0.OPEN_BOOK = "CityRebuildMapMediator.OPEN_BOOK"
var0_0.OPEN_BATTLE = "CityRebuildMapMediator.OPEN_BATTLE"
var0_0.OPEN_STORY = "CityRebuildMapMediator.OPEN_STORY"
var0_0.OPEN_TASKS = "CityRebuildMapMediator.OPEN_TASKS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GET_DATA, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.CITY_REBUILD, {
			operation = CityRebuildProxy.GET_DATA,
			activityId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.OPEN_BOOK, function(arg0_3, arg1_3, arg2_3)
		arg0_1:addSubLayers(Context.New({
			mediator = CityRebuildBookMediator,
			viewComponent = CityRebuildBookLayer,
			data = {
				page = arg1_3,
				showId = arg2_3
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_TASKS, function(arg0_4)
		arg0_1:addSubLayers(Context.New({
			mediator = CityRebuildTasksMediator,
			viewComponent = CityRebuildTasksLayer
		}))
	end)
	arg0_1:bind(var0_0.OPEN_BATTLE, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			mediator = CityRebuildGameMediator,
			viewComponent = CityRebuildGameLayer
		}))
	end)
	arg0_1:bind(var0_0.OPEN_STORY, function(arg0_6)
		arg0_1:addSubLayers(Context.New({
			mediator = CityRebuildStoryMediator,
			viewComponent = CityRebuildStoryLayer
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.CITY_REBUILD_DONE,
		GAME.STORY_UPDATE_DONE,
		GAME.SUBMIT_TASK_AWARD_DOWN
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.CITY_REBUILD_DONE then
		if var1_8.operation == CityRebuildProxy.GET_DATA or var1_8.operation == CityRebuildProxy.REBUILD_OR_START_RECRUIT or var1_8.operation == CityRebuildProxy.END_RECRUIT or var1_8.operation == CityRebuildProxy.CHOOSE_LEVEL or var1_8.operation == CityRebuildProxy.INIT_TIME then
			arg0_8.viewComponent:Refresh()
		end
	elseif var0_8 == GAME.STORY_UPDATE_DONE or var0_8 == GAME.SUBMIT_TASK_AWARD_DOWN then
		arg0_8.viewComponent:Refresh()
	end
end

return var0_0
