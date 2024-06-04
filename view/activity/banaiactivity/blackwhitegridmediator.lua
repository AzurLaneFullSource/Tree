local var0 = class("BlackWhiteGridMediator", import("...base.ContextMediator"))

var0.ON_FINISH = "VirtualSpaceMediator:ON_FINISH"
var0.ON_UPDATE_SCORE = "VirtualSpaceMediator:ON_UPDATE_SCORE"

function var0.register(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BLACKWHITE)

	arg0.viewComponent:setActivity(var0)
	arg0:bind(var0.ON_FINISH, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BLACK_WHITE_GRID_OP, {
			cmd = 1,
			activityId = var0.id,
			id = arg1,
			score = arg2
		})
	end)
	arg0:bind(var0.ON_UPDATE_SCORE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BLACK_WHITE_GRID_OP, {
			cmd = 2,
			activityId = var0.id,
			id = arg1,
			score = arg2
		})
	end)

	local var1 = getProxy(PlayerProxy):getRawData()

	arg0.viewComponent:setPlayer(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BLACK_WHITE_GRID_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BLACK_WHITE_GRID_OP_DONE then
		local var2 = {
			function(arg0)
				arg0.viewComponent:playStory(arg0)
			end,
			function(arg0)
				local var0 = var1.awards

				if #var0 > 0 then
					arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, arg0)
				else
					arg0()
				end
			end,
			function(arg0)
				arg0.viewComponent:updateBtnsState()
				arg0()
			end
		}

		seriesAsync(var2)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED and arg0.viewComponent.activityVO.id == var1.id then
		arg0.viewComponent:setActivity(var1)
	end
end

return var0
