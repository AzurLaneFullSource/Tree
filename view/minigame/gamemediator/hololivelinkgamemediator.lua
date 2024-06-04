local var0 = class("HoloLiveLinkGameMediator", import(".MiniHubMediator"))

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.SEND_MINI_GAME_OP_DONE and var1.cmd == MiniGameOPCommand.CMD_COMPLETE then
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
				arg0.viewComponent:playStory()
			end
		}

		seriesAsync(var2)
	else
		var0.super.handleNotification(arg0, arg1)
	end
end

return var0
