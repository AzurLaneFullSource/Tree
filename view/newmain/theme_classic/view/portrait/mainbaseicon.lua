local var0_0 = class("MainBaseIcon")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1._go = arg1_1.gameObject
	arg0_1.loading = false
end

function var0_0.Resume(arg0_2)
	return
end

function var0_0.Pause(arg0_3)
	return
end

function var0_0.Load(arg0_4, arg1_4)
	return
end

function var0_0.Unload(arg0_5)
	return
end

function var0_0.IsLoading(arg0_6)
	return arg0_6.loading
end

function var0_0.Dispose(arg0_7)
	arg0_7.exited = true

	arg0_7:Unload()
end

return var0_0
