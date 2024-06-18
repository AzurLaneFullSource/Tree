local var0_0 = class("TechnologySettingsMediator", import("..base.ContextMediator"))

var0_0.CHANGE_TENDENCY = "TechnologySettingsMediator.CHANGE_TENDENCY"
var0_0.EXIT_CALL = "TechnologySettingsMediator.EXIT_CALL"

function var0_0.register(arg0_1)
	arg0_1:bindEvent()
end

function var0_0.bindEvent(arg0_2)
	arg0_2:bind(var0_0.CHANGE_TENDENCY, function(arg0_3, arg1_3)
		arg0_2:sendNotification(GAME.CHANGE_REFRESH_TECHNOLOGYS_TENDENCY, {
			pool_id = 2,
			tendency = arg1_3
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.CHANGE_REFRESH_TECHNOLOGYS_TENDENCY_DONE,
		GAME.SELECT_TEC_TARGET_CATCHUP_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.CHANGE_REFRESH_TECHNOLOGYS_TENDENCY_DONE then
		local var2_5 = getProxy(TechnologyProxy):getTendency(2)

		arg0_5.viewComponent:updateTendencyPage(var2_5)
		arg0_5.viewComponent:updateTendencyBtn(var2_5)
	elseif var0_5 == GAME.SELECT_TEC_TARGET_CATCHUP_DONE then
		arg0_5.viewComponent:updateTargetCatchupPage(var1_5.tecID)
		arg0_5.viewComponent:updateTargetCatchupBtns()
	end
end

function var0_0.remove(arg0_6)
	arg0_6:sendNotification(var0_0.EXIT_CALL)
end

return var0_0
