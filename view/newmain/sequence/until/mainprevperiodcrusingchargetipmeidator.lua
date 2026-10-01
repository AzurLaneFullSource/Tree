local var0_0 = class("MainPrevPeriodCrusingChargeTipMeidator", pm.Mediator)

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.sequence = arg1_1

	pg.m02:registerMediator(arg0_1)
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.CHARGE_SUCCESS
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.CHARGE_SUCCESS then
		arg0_3.sequence:OnChargeSuccess(var1_3)
	end
end

function var0_0.Dispose(arg0_4)
	pg.m02:removeMediator(arg0_4.__cname)
end

return var0_0
