local var0 = class("NewYearFestivalMediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0.MINIGAME_OPERATION = "MINIGAME_OPERATION"
var0.ON_OPEN_PILE_SIGNED = "ON_OPEN_PILE_SIGNED"

function var0.BindEvent(arg0)
	var0.super.BindEvent(arg0)
	arg0:bind(var0.ON_OPEN_PILE_SIGNED, function()
		arg0:addSubLayers(Context.New({
			viewComponent = PileGameSignedLayer,
			mediator = PileGameSignedMediator
		}))
	end)
	arg0:bind(var0.MINIGAME_OPERATION, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg1,
			cmd = arg2,
			args1 = arg3
		})
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
		arg0:OnSendMiniGameOPDone(var1)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		arg0.viewComponent:UpdateView()
	end
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	local var0 = arg1.argList
	local var1 = var0[1]
	local var2 = var0[2]

	if var1 == 3 and var2 == 1 then
		arg0.viewComponent:UpdateView()
	end
end

return var0
