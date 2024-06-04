local var0 = class("TechnologySettingsMediator", import("..base.ContextMediator"))

var0.CHANGE_TENDENCY = "TechnologySettingsMediator.CHANGE_TENDENCY"
var0.EXIT_CALL = "TechnologySettingsMediator.EXIT_CALL"

function var0.register(arg0)
	arg0:bindEvent()
end

function var0.bindEvent(arg0)
	arg0:bind(var0.CHANGE_TENDENCY, function(arg0, arg1)
		arg0:sendNotification(GAME.CHANGE_REFRESH_TECHNOLOGYS_TENDENCY, {
			pool_id = 2,
			tendency = arg1
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.CHANGE_REFRESH_TECHNOLOGYS_TENDENCY_DONE,
		GAME.SELECT_TEC_TARGET_CATCHUP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.CHANGE_REFRESH_TECHNOLOGYS_TENDENCY_DONE then
		local var2 = getProxy(TechnologyProxy):getTendency(2)

		arg0.viewComponent:updateTendencyPage(var2)
		arg0.viewComponent:updateTendencyBtn(var2)
	elseif var0 == GAME.SELECT_TEC_TARGET_CATCHUP_DONE then
		arg0.viewComponent:updateTargetCatchupPage(var1.tecID)
		arg0.viewComponent:updateTargetCatchupBtns()
	end
end

function var0.remove(arg0)
	arg0:sendNotification(var0.EXIT_CALL)
end

return var0
