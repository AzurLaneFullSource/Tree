local var0_0 = class("SpringFestival2023Mediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0_0.MINI_GAME_OPERATOR = "MINI_GAME_OPERATOR"
var0_0.GO_SCENE = "GO_SCENE"
var0_0.GO_SUBLAYER = "GO_SUBLAYER"
var0_0.PLAY_FIREWORKS = "PLAY_FIREWORKS"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_2:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_2:bind(var0_0.GO_SUBLAYER, function(arg0_4, arg1_4, arg2_4)
		arg0_2:addSubLayers(arg1_4, nil, arg2_4)
	end)
	arg0_2:bind(var0_0.MINI_GAME_OPERATOR, function(arg0_5, ...)
		arg0_2:sendNotification(GAME.SEND_MINI_GAME_OP, ...)
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GAME.SEND_MINI_GAME_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		var0_0.PLAY_FIREWORKS
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2_7 = {
			function(arg0_8)
				local var0_8 = var1_7.awards

				if #var0_8 > 0 then
					arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_8, arg0_8)
				else
					arg0_8()
				end
			end,
			function(arg0_9)
				arg0_7.viewComponent:UpdateView()
			end
		}

		seriesAsync(var2_7)
	elseif var0_7 == ActivityProxy.ACTIVITY_UPDATED then
		arg0_7.viewComponent:UpdateActivity(var1_7)
	elseif var0_7 == var0_0.PLAY_FIREWORKS then
		arg0_7.viewComponent:PlayFireworks(var1_7)
	end
end

return var0_0
