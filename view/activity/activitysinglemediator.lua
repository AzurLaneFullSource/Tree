local var0 = class("ActivityMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	local var0 = arg0.contextData.id

	arg0.contextData.singleActivity = true

	arg0:bind(ActivityMediator.EVENT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
	arg0:bind(ActivityMediator.EVENT_GO_SCENE, function(arg0, arg1, arg2)
		if arg1 == SCENE.SUMMER_FEAST then
			pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1", function()
				arg0:sendNotification(GAME.GO_SCENE, SCENE.SUMMER_FEAST)
			end)
		else
			arg0:sendNotification(GAME.GO_SCENE, arg1, arg2)
		end
	end)

	local var1 = getProxy(PlayerProxy):getRawData()

	arg0.viewComponent:setPlayer(var1)

	local var2 = getProxy(BayProxy):getShipById(var1.character)

	arg0.viewComponent:setFlagShip(var2)

	local var3 = getProxy(ActivityProxy):getActivityById(var0)

	arg0.viewComponent:selectActivity(var3)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_ADDED,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		GAME.ACT_NEW_PT_DONE,
		GAME.RETURN_AWARD_OP_DONE,
		GAME.MONOPOLY_AWARD_DONE,
		GAME.SUBMIT_TASK_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_ADDED or var0 == ActivityProxy.ACTIVITY_UPDATED then
		arg0.viewComponent:updateActivity(var1)
	elseif var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		-- block empty
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS or var0 == GAME.ACT_NEW_PT_DONE or var0 == GAME.RETURN_AWARD_OP_DONE or var0 == GAME.MONOPOLY_AWARD_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	elseif var0 == GAME.SUBMIT_TASK_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1, function()
			arg0.viewComponent:updateTaskLayers()
		end)
	elseif var0 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2 = {
			function(arg0)
				local var0 = var1.awards

				if #var0 > 0 then
					if arg0.viewComponent then
						arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, arg0)
					else
						arg0:emit(BaseUI.ON_ACHIEVE, var0, arg0)
					end
				else
					arg0()
				end
			end
		}

		seriesAsync(var2)
	end
end

return var0
