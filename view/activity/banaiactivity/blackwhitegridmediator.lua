local var0_0 = class("BlackWhiteGridMediator", import("...base.ContextMediator"))

var0_0.ON_FINISH = "VirtualSpaceMediator:ON_FINISH"
var0_0.ON_UPDATE_SCORE = "VirtualSpaceMediator:ON_UPDATE_SCORE"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLACKWHITE)

	arg0_1.viewComponent:setActivity(var0_1)
	arg0_1:bind(var0_0.ON_FINISH, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.BLACK_WHITE_GRID_OP, {
			cmd = 1,
			activityId = var0_1.id,
			id = arg1_2,
			score = arg2_2
		})
	end)
	arg0_1:bind(var0_0.ON_UPDATE_SCORE, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.BLACK_WHITE_GRID_OP, {
			cmd = 2,
			activityId = var0_1.id,
			id = arg1_3,
			score = arg2_3
		})
	end)

	local var1_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:setPlayer(var1_1)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.BLACK_WHITE_GRID_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.BLACK_WHITE_GRID_OP_DONE then
		local var2_5 = {
			function(arg0_6)
				arg0_5.viewComponent:playStory(arg0_6)
			end,
			function(arg0_7)
				local var0_7 = var1_5.awards

				if #var0_7 > 0 then
					arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_7, arg0_7)
				else
					arg0_7()
				end
			end,
			function(arg0_8)
				arg0_5.viewComponent:updateBtnsState()
				arg0_8()
			end
		}

		seriesAsync(var2_5)
	elseif var0_5 == ActivityProxy.ACTIVITY_UPDATED and arg0_5.viewComponent.activityVO.id == var1_5.id then
		arg0_5.viewComponent:setActivity(var1_5)
	end
end

return var0_0
