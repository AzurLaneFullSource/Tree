local var0 = class("ThirdAnniversarySquareMediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0.MINIGAME_OPERATION = "MINIGAME_OPERATION"
var0.ON_OPEN_TOWERCLIMBING_SIGNED = "ON_OPEN_TOWERCLIMBING_SIGNED"
var0.ACTIVITY_OPERATION = "ACTIVITY_OPERATION"

function var0.register(arg0)
	arg0:BindEvent()

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)

	assert(var0, "Building Activity Not Found")

	arg0.activity = var0

	arg0.viewComponent:UpdateActivity(var0)
end

function var0.BindEvent(arg0)
	var0.super.BindEvent(arg0)
	arg0:bind(var0.ON_OPEN_TOWERCLIMBING_SIGNED, function()
		arg0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.TOWERCLIMBING_SIGN
		})
	end)
	arg0:bind(var0.ACTIVITY_OPERATION, function(arg0, arg1)
		assert(arg0.activity, "Cant Initialize Activity")

		arg1.activity_id = arg0.activity.id

		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.SEND_MINI_GAME_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2 = {
			function(arg0)
				local var0 = var1.awards

				if #var0 > 0 then
					arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var0, arg0)
				else
					arg0()
				end
			end,
			function(arg0)
				arg0.viewComponent:UpdateView()
			end
		}

		seriesAsync(var2)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF then
		arg0.activity = var1

		arg0.viewComponent:UpdateActivity(var1)
	end
end

return var0
