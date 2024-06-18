local var0_0 = class("HoloLiveLinkGameMediator", import(".MiniHubMediator"))

function var0_0.handleNotification(arg0_1, arg1_1)
	local var0_1 = arg1_1:getName()
	local var1_1 = arg1_1:getBody()

	if var0_1 == GAME.SEND_MINI_GAME_OP_DONE and var1_1.cmd == MiniGameOPCommand.CMD_COMPLETE then
		local var2_1 = {
			function(arg0_2)
				local var0_2 = var1_1.awards

				if #var0_2 > 0 then
					arg0_1.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_2, arg0_2)
				else
					arg0_2()
				end
			end,
			function(arg0_3)
				arg0_1.viewComponent:playStory()
			end
		}

		seriesAsync(var2_1)
	else
		var0_0.super.handleNotification(arg0_1, arg1_1)
	end
end

return var0_0
