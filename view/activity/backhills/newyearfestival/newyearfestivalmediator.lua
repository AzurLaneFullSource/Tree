local var0_0 = class("NewYearFestivalMediator", import("..TemplateMV.BackHillMediatorTemplate"))

var0_0.MINIGAME_OPERATION = "MINIGAME_OPERATION"
var0_0.ON_OPEN_PILE_SIGNED = "ON_OPEN_PILE_SIGNED"

function var0_0.BindEvent(arg0_1)
	var0_0.super.BindEvent(arg0_1)
	arg0_1:bind(var0_0.ON_OPEN_PILE_SIGNED, function()
		arg0_1:addSubLayers(Context.New({
			viewComponent = PileGameSignedLayer,
			mediator = PileGameSignedMediator
		}))
	end)
	arg0_1:bind(var0_0.MINIGAME_OPERATION, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg1_3,
			cmd = arg2_3,
			args1 = arg3_3
		})
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
		arg0_5:OnSendMiniGameOPDone(var1_5)
	elseif var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		arg0_5.viewComponent:UpdateView()
	end
end

function var0_0.OnSendMiniGameOPDone(arg0_8, arg1_8)
	local var0_8 = arg1_8.argList
	local var1_8 = var0_8[1]
	local var2_8 = var0_8[2]

	if var1_8 == 3 and var2_8 == 1 then
		arg0_8.viewComponent:UpdateView()
	end
end

return var0_0
