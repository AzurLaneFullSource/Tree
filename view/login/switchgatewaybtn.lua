local var0_0 = class("SwitchGatewayBtn")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tr = arg1_1
	arg0_1._go = arg1_1.gameObject

	setActive(arg0_1._go, false)
end

function var0_0.Flush(arg0_2)
	local var0_2 = getProxy(UserProxy):ShowGatewaySwitcher()

	setActive(arg0_2._go, var0_2)

	if var0_2 then
		arg0_2:RegistSwicher()
	end
end

function var0_0.RegistSwicher(arg0_3)
	local var0_3 = getProxy(UserProxy)
	local var1_3 = var0_3:getLastLoginUser()

	onButton(nil, arg0_3._go, function()
		pg.m02:sendNotification(GAME.SERVER_INTERCOMMECTION, {
			user = var1_3,
			platform = var0_3:GetReversePlatform()
		})
	end, SFX_PANEL)

	arg0_3.isRegist = true
end

function var0_0.Dispose(arg0_5)
	if arg0_5.isRegist then
		removeOnButton(arg0_5._go)

		arg0_5.isRegist = nil
	end
end

return var0_0
