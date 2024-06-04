local var0 = class("SpringFestival2024Mediator", import("view.activity.BackHills.TemplateMV.BackHillMediatorTemplate"))

var0.MINI_GAME_OPERATOR = "MINI_GAME_OPERATOR"
var0.GO_SCENE = "GO_SCENE"
var0.GO_SUBLAYER = "GO_SUBLAYER"

function var0.register(arg0)
	arg0:BindEvent()
end

function var0.BindEvent(arg0)
	arg0:bind(var0.GO_SCENE, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.GO_SCENE, arg1, ...)
	end)
	arg0:bind(var0.GO_SUBLAYER, function(arg0, arg1, arg2)
		arg0:addSubLayers(arg1, nil, arg2)
	end)
	arg0:bind(var0.MINI_GAME_OPERATOR, function(arg0, ...)
		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, ...)
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
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		arg0.viewComponent:UpdateActivity(var1)
	end
end

return var0
