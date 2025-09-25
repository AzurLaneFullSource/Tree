local var0_0 = class("SyncUnitVisitor")

function var0_0.Ctor(arg0_1, arg1_1)
	return
end

function var0_0.RecordLastInteract(arg0_2, arg1_2, arg2_2)
	arg0_2.lastInteract = {
		type = arg2_2,
		id = arg1_2
	}
end

function var0_0.ClearLastInteract(arg0_3)
	arg0_3.lastInteract = nil
end

function var0_0.GetLastInteract(arg0_4)
	return arg0_4.lastInteract
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
