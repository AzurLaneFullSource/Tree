local var0_0 = class("ThirdAnniversarySquareMediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0_0.MINIGAME_OPERATION = "MINIGAME_OPERATION"
var0_0.ON_OPEN_TOWERCLIMBING_SIGNED = "ON_OPEN_TOWERCLIMBING_SIGNED"
var0_0.ACTIVITY_OPERATION = "ACTIVITY_OPERATION"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	assert(var0_1, "Building Activity Not Found")

	arg0_1.activity = var0_1

	arg0_1.viewComponent:UpdateActivity(var0_1)
end

function var0_0.BindEvent(arg0_2)
	var0_0.super.BindEvent(arg0_2)
	arg0_2:bind(var0_0.ON_OPEN_TOWERCLIMBING_SIGNED, function()
		arg0_2:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.TOWERCLIMBING_SIGN
		})
	end)
	arg0_2:bind(var0_0.ACTIVITY_OPERATION, function(arg0_4, arg1_4)
		assert(arg0_2.activity, "Cant Initialize Activity")

		arg1_4.activity_id = arg0_2.activity.id

		arg0_2:sendNotification(GAME.ACTIVITY_OPERATION, arg1_4)
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.SEND_MINI_GAME_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2_6 = {
			function(arg0_7)
				local var0_7 = var1_6.awards

				if #var0_7 > 0 then
					arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_7, arg0_7)
				else
					arg0_7()
				end
			end,
			function(arg0_8)
				arg0_6.viewComponent:UpdateView()
			end
		}

		seriesAsync(var2_6)
	elseif var0_6 == ActivityProxy.ACTIVITY_UPDATED and var1_6:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
		arg0_6.activity = var1_6

		arg0_6.viewComponent:UpdateActivity(var1_6)
	end
end

return var0_0
