local var0_0 = class("WorldOverviewMediator", import("..base.ContextMediator"))

var0_0.OnAchieveStar = "WorldOverviewMediator.OnAchieveStar"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnAchieveStar, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.WORLD_ACHIEVE, {
			list = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.WORLD_ACHIEVE_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.WORLD_ACHIEVE_DONE then
		-- block empty
	end
end

return var0_0
