local var0_0 = class("CityRebuildGameMediator", import("view.base.ContextMediator"))

var0_0.INIT_TIME = "CityRebuildGameMediator.INIT_TIME"
var0_0.RESULT = "CityRebuildGameMediator.RESULT"
var0_0.CHOOSE_LEVEL = "CityRebuildGameMediator.CHOOSE_LEVEL"
var0_0.OPEN_BOOK = "CityRebuildGameMediator.OPEN_BOOK"
var0_0.OPEN_TASKS = "CityRebuildGameMediator.OPEN_TASKS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.INIT_TIME, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.CITY_REBUILD, {
			operation = CityRebuildProxy.INIT_TIME,
			activityId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.RESULT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.CITY_REBUILD, {
			operation = CityRebuildProxy.RESULT,
			activityId = arg1_3
		})
	end)
	arg0_1:bind(var0_0.CHOOSE_LEVEL, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.CITY_REBUILD, {
			operation = CityRebuildProxy.CHOOSE_LEVEL,
			activityId = arg1_4,
			level = arg2_4
		})
	end)
	arg0_1:bind(var0_0.OPEN_BOOK, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			mediator = CityRebuildBookMediator,
			viewComponent = CityRebuildBookLayer,
			data = {
				page = "buff"
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_TASKS, function(arg0_6)
		arg0_1:addSubLayers(Context.New({
			mediator = CityRebuildTasksMediator,
			viewComponent = CityRebuildTasksLayer
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.CITY_REBUILD_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.CITY_REBUILD_DONE then
		if var1_8.operation == CityRebuildProxy.CHOOSE_LEVEL or var1_8.operation == CityRebuildProxy.INIT_TIME then
			arg0_8.viewComponent:Refresh()
		elseif var1_8.operation == CityRebuildProxy.REBUILD_OR_START_RECRUIT or var1_8.operation == CityRebuildProxy.END_RECRUIT or var1_8.operation == CityRebuildProxy.UPGRADE_BUFF then
			arg0_8.viewComponent:Refresh(true)
		elseif var1_8.operation == CityRebuildProxy.RESULT then
			arg0_8.viewComponent:Refresh(true)

			local var2_8 = var1_8.awards
			local var3_8 = var1_8.pt.k + var1_8.pt.m * 1000000 + var1_8.pt.b * 1000000000

			if #var2_8 == 0 and var3_8 == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ninja_game_cant_pickup"))

				return
			end

			local function var4_8()
				if var3_8 > 0 then
					table.insert(var2_8, {
						id = 65103,
						type = 2,
						count = var3_8
					})
				end

				if #var2_8 > 0 then
					arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var2_8)
				end
			end

			arg0_8.viewComponent:Summary(var4_8, var3_8)
		end
	end
end

return var0_0
