local var0_0 = class("Dorm3dGameMediatorTemplate", import("view.base.ContextMediator"))

var0_0.TRIGGER_FAVOR = "Dorm3dGameMediatorTemplate.TRIGGER_FAVOR"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.TRIGGER_FAVOR, function(arg0_2, arg1_2)
		local var0_2 = getDorm3dGameset("drom3d_favir_trigger_game")[1]
		local var1_2 = pg.dorm3d_favor_trigger[var0_2]

		if getProxy(ApartmentProxy).stamina < var1_2.is_daily_max then
			arg0_1.viewComponent:ShowResultUI()

			return
		end

		arg0_1:sendNotification(GAME.APARTMENT_TRIGGER_FAVOR, {
			groupId = arg1_2,
			triggerId = var0_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.APARTMENT_TRIGGER_FAVOR_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.APARTMENT_TRIGGER_FAVOR_DONE then
		arg0_4.viewComponent:ShowResultUI(var1_4)
	end
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
