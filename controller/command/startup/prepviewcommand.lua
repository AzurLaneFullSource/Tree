local var0 = class("PrepViewCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	arg0.facade:registerMediator(GameMediator.New())
end

return var0
