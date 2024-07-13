local var0_0 = class("ActivityMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.id

	arg0_1.contextData.singleActivity = true

	arg0_1:bind(ActivityMediator.EVENT_OPERATION, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_2)
	end)
	arg0_1:bind(ActivityMediator.EVENT_GO_SCENE, function(arg0_3, arg1_3, arg2_3)
		if arg1_3 == SCENE.SUMMER_FEAST then
			pg.NewStoryMgr.GetInstance():Play("TIANHOUYUYI1", function()
				arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SUMMER_FEAST)
			end)
		else
			arg0_1:sendNotification(GAME.GO_SCENE, arg1_3, arg2_3)
		end
	end)

	local var1_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.viewComponent:setPlayer(var1_1)

	local var2_1 = getProxy(BayProxy):getShipById(var1_1.character)

	arg0_1.viewComponent:setFlagShip(var2_1)

	local var3_1 = getProxy(ActivityProxy):getActivityById(var0_1)

	arg0_1.viewComponent:selectActivity(var3_1)
end

function var0_0.listNotificationInterests(arg0_5)
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

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == ActivityProxy.ACTIVITY_ADDED or var0_6 == ActivityProxy.ACTIVITY_UPDATED then
		arg0_6.viewComponent:updateActivity(var1_6)
	elseif var0_6 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		-- block empty
	elseif var0_6 == ActivityProxy.ACTIVITY_SHOW_AWARDS or var0_6 == GAME.ACT_NEW_PT_DONE or var0_6 == GAME.RETURN_AWARD_OP_DONE or var0_6 == GAME.MONOPOLY_AWARD_DONE then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.awards, var1_6.callback)
	elseif var0_6 == GAME.SUBMIT_TASK_DONE then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6, function()
			arg0_6.viewComponent:updateTaskLayers()
		end)
	elseif var0_6 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2_6 = {
			function(arg0_8)
				local var0_8 = var1_6.awards

				if #var0_8 > 0 then
					if arg0_6.viewComponent then
						arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_8, arg0_8)
					else
						arg0_6:emit(BaseUI.ON_ACHIEVE, var0_8, arg0_8)
					end
				else
					arg0_8()
				end
			end
		}

		seriesAsync(var2_6)
	end
end

return var0_0
