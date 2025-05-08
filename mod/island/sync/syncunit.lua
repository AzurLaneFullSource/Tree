local var0_0 = class("SyncUnit")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.syncType = arg1_1.type
	arg0_1.tid = arg1_1.tid
end

function var0_0.GetType(arg0_2)
	return arg0_2.syncType
end

function var0_0.UpdateOwner(arg0_3, arg1_3)
	return
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
