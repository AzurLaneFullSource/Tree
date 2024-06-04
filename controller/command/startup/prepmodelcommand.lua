local var0 = class("PrepModelCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	arg0.facade:registerProxy(ContextProxy.New({}))
	arg0.facade:registerProxy(ServerProxy.New({}))
	arg0.facade:registerProxy(UserProxy.New())
	arg0.facade:registerProxy(GatewayNoticeProxy.New())
	arg0.facade:registerProxy(SettingsProxy.New())
end

return var0
