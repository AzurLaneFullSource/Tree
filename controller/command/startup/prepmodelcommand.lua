local var0_0 = class("PrepModelCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	arg0_1.facade:registerProxy(ContextProxy.New({}))
	arg0_1.facade:registerProxy(ServerProxy.New({}))
	arg0_1.facade:registerProxy(UserProxy.New())
	arg0_1.facade:registerProxy(GatewayNoticeProxy.New())
	arg0_1.facade:registerProxy(SettingsProxy.New())
end

return var0_0
