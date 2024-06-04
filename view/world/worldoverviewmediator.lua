local var0 = class("WorldOverviewMediator", import("..base.ContextMediator"))

var0.OnAchieveStar = "WorldOverviewMediator.OnAchieveStar"

function var0.register(arg0)
	arg0:bind(var0.OnAchieveStar, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_ACHIEVE, {
			list = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.WORLD_ACHIEVE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.WORLD_ACHIEVE_DONE then
		-- block empty
	end
end

return var0
