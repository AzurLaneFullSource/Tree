local var0 = class("MusicFestivalMediator", import("..TemplateMV.BackHillMediatorTemplate"))

function var0.listNotificationInterests(arg0)
	return {
		GAME.SEND_MINI_GAME_OP_DONE,
		GAME.ACT_INSTAGRAM_OP_DONE,
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
	elseif var0 == GAME.ACT_INSTAGRAM_OP_DONE or var0 == ActivityProxy.ACTIVITY_UPDATED then
		arg0.viewComponent:UpdateView()
	end
end

return var0
