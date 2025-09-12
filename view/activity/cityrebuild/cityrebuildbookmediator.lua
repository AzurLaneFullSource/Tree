local var0_0 = class("CityRebuildBookMediator", import("view.base.ContextMediator"))

var0_0.REBUILD_OR_START_RECRUIT = "CityRebuildBookMediator.REBUILD_OR_START_RECRUIT"
var0_0.END_RECRUIT = "CityRebuildBookMediator.END_RECRUIT"
var0_0.UPGRADE_BUFF = "CityRebuildBookMediator.UPGRADE_BUFF"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.REBUILD_OR_START_RECRUIT, function(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
		arg0_1:sendNotification(GAME.CITY_REBUILD, {
			operation = CityRebuildProxy.REBUILD_OR_START_RECRUIT,
			activityId = arg1_2,
			buildingId = arg2_2,
			cost = arg3_2,
			ptCost = arg4_2
		})
	end)
	arg0_1:bind(var0_0.END_RECRUIT, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.CITY_REBUILD, {
			operation = CityRebuildProxy.END_RECRUIT,
			activityId = arg1_3,
			roles = arg2_3
		})
	end)
	arg0_1:bind(var0_0.UPGRADE_BUFF, function(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
		arg0_1:sendNotification(GAME.CITY_REBUILD, {
			operation = CityRebuildProxy.UPGRADE_BUFF,
			activityId = arg1_4,
			group = arg2_4,
			count = arg3_4,
			ptCost = arg4_4
		})
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.CITY_REBUILD_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.CITY_REBUILD_DONE and (var1_6.operation == CityRebuildProxy.REBUILD_OR_START_RECRUIT or var1_6.operation == CityRebuildProxy.END_RECRUIT or var1_6.operation == CityRebuildProxy.UPGRADE_BUFF) then
		arg0_6.viewComponent:Refresh()
	end
end

return var0_0
