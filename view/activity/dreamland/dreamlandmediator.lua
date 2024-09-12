local var0_0 = class("DreamlandMediator", import("view.activity.BackHills.AnniversaryIsland2023.AnniversaryIslandHotSpringMediator"))

var0_0.GET_MAP_AWARD = "DreamlandMediator:GET_MAP_AWARD"
var0_0.GET_EXPLORE_AWARD = "DreamlandMediator:GET_EXPLORE_AWARD"
var0_0.RECORD_EXPLORE = "DreamlandMediator:RECORD_EXPLORE"
var0_0.HOT_SPRING_OP = "DreamlandMediator:HOT_SPRING_OP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.HOT_SPRING_OP, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1.maxSlotCnt = arg2_2

		arg0_1:OnSelShips(arg1_2, arg3_2)
	end)
	arg0_1:bind(var0_0.GET_MAP_AWARD, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.ACTIVITY_DREAMLAND_OP, {
			activity_id = arg1_3,
			cmd = DreamlandData.OP_GET_MAP_AWARD,
			arg1 = arg2_3
		})
	end)
	arg0_1:bind(var0_0.GET_EXPLORE_AWARD, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.ACTIVITY_DREAMLAND_OP, {
			activity_id = arg1_4,
			cmd = DreamlandData.OP_GET_EXPLORE_AWARD,
			arg1 = arg2_4
		})
	end)
	arg0_1:bind(var0_0.RECORD_EXPLORE, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_1:sendNotification(GAME.ACTIVITY_DREAMLAND_OP, {
			activity_id = arg1_5,
			cmd = DreamlandData.OP_RECORD_EXPLORE,
			arg1 = arg3_5
		})
	end)

	arg0_1.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)
end

function var0_0.GetGetSlotCount(arg0_6)
	return arg0_6.maxSlotCnt or 0
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.ACTIVITY_DREAMLAND_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.STORY_UPDATE_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.ACTIVITY_DREAMLAND_OP_DONE then
		arg0_8.viewComponent:UpdateActivity(var1_8.activity, var1_8.cmd)

		if #var1_8.awards > 0 then
			arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards)
		end
	elseif var0_8 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_8:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
			arg0_8.activity = var1_8

			arg0_8.viewComponent:UpdateSpringActivity(var1_8)
		end
	elseif var0_8 == GAME.STORY_UPDATE_DONE then
		arg0_8.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)

		arg0_8.viewComponent:UpdateSpringActivity(arg0_8.activity)
	end
end

return var0_0
