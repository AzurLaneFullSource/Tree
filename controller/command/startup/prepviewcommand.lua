local var0_0 = class("PrepViewCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	arg0_1.facade:registerMediator(GameMediator.New())
end

return var0_0
