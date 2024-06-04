local var0 = class("SwitchGatewayBtn")

function var0.Ctor(arg0, arg1)
	arg0._tr = arg1
	arg0._go = arg1.gameObject

	setActive(arg0._go, false)
end

function var0.Flush(arg0)
	local var0 = getProxy(UserProxy):ShowGatewaySwitcher()

	setActive(arg0._go, var0)

	if var0 then
		arg0:RegistSwicher()
	end
end

function var0.RegistSwicher(arg0)
	local var0 = getProxy(UserProxy)
	local var1 = var0:getLastLoginUser()

	onButton(nil, arg0._go, function()
		pg.m02:sendNotification(GAME.SERVER_INTERCOMMECTION, {
			user = var1,
			platform = var0:GetReversePlatform()
		})
	end, SFX_PANEL)

	arg0.isRegist = true
end

function var0.Dispose(arg0)
	if arg0.isRegist then
		removeOnButton(arg0._go)

		arg0.isRegist = nil
	end
end

return var0
