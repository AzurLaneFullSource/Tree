local var0_0 = class("AmusementParkMediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0_0.MINIGAME_OPERATION = "MINIGAME_OPERATION"
var0_0.ACTIVITY_OPERATION = "ACTIVITY_OPERATION"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	assert(var0_1, "Building Activity Not Found")

	arg0_1.activity = var0_1

	arg0_1.viewComponent:UpdateActivity(var0_1)
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.ACTIVITY_OPERATION, function(arg0_3, arg1_3)
		assert(arg0_2.activity, "Cant Initialize Activity")

		arg1_3.activity_id = arg0_2.activity.id

		arg0_2:sendNotification(GAME.ACTIVITY_OPERATION, arg1_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.SEND_MINI_GAME_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2_5 = {
			function(arg0_6)
				local var0_6 = var1_5.awards

				if #var0_6 > 0 then
					arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_6, arg0_6)
				else
					arg0_6()
				end
			end,
			function(arg0_7)
				arg0_5.viewComponent:UpdateView()
			end
		}

		seriesAsync(var2_5)
	elseif var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
			arg0_5.activity = var1_5

			arg0_5.viewComponent:UpdateActivity(var1_5)
		elseif var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD then
			local var3_5 = var1_5

			arg0_5.viewComponent:UpdateView()
		end
	end
end

return var0_0
