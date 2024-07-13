local var0_0 = class("OtherworldBackHilllMediator", import("view.base.ContextMediator"))

var0_0.MINI_GAME_OPERATOR = "MINI_GAME_OPERATOR"
var0_0.GO_SCENE = "GO_SCENE"
var0_0.CHANGE_SCENE = "CHANGE_SCENE"
var0_0.GO_SUBLAYER = "GO_SUBLAYER"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_2:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_2:bind(var0_0.CHANGE_SCENE, function(arg0_4, arg1_4, ...)
		arg0_2:sendNotification(GAME.CHANGE_SCENE, arg1_4, ...)
	end)
	arg0_2:bind(var0_0.GO_SUBLAYER, function(arg0_5, arg1_5, arg2_5)
		arg0_2:addSubLayers(arg1_5, nil, arg2_5)
	end)
	arg0_2:bind(var0_0.MINI_GAME_OPERATOR, function(arg0_6, ...)
		arg0_2:sendNotification(GAME.SEND_MINI_GAME_OP, ...)
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.SEND_MINI_GAME_OP_DONE,
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2_8 = {
			function(arg0_9)
				local var0_9 = var1_8.awards

				if #var0_9 > 0 then
					arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_9, arg0_9)
				else
					arg0_9()
				end
			end,
			function(arg0_10)
				arg0_8.viewComponent:UpdateView()
			end
		}

		seriesAsync(var2_8)
	elseif var0_8 == ActivityProxy.ACTIVITY_UPDATED then
		arg0_8.viewComponent:UpdateActivity(var1_8)
	elseif var0_8 == PlayerProxy.UPDATED then
		arg0_8.viewComponent:UpdateRes()
		arg0_8.viewComponent:UpdateView()
	end
end

return var0_0
