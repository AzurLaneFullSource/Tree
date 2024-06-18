local var0_0 = class("SummerFeastMediator", import("..TemplateMV.BackHillMediatorTemplate"))

function var0_0.listNotificationInterests(arg0_1)
	return {
		GAME.SEND_MINI_GAME_OP_DONE
	}
end

function var0_0.handleNotification(arg0_2, arg1_2)
	local var0_2 = arg1_2:getName()
	local var1_2 = arg1_2:getBody()

	if var0_2 == GAME.SEND_MINI_GAME_OP_DONE then
		local var2_2 = {
			function(arg0_3)
				local var0_3 = var1_2.awards

				if #var0_3 > 0 then
					arg0_2.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_3, arg0_3)
				else
					arg0_3()
				end
			end,
			function(arg0_4)
				arg0_2.viewComponent:UpdateView()
			end
		}

		seriesAsync(var2_2)
	end
end

return var0_0
