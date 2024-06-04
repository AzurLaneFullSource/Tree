local var0 = class("MainBaseIcon")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0._go = arg1.gameObject
	arg0.loading = false
end

function var0.Resume(arg0)
	return
end

function var0.Pause(arg0)
	return
end

function var0.Load(arg0, arg1)
	return
end

function var0.Unload(arg0)
	return
end

function var0.IsLoading(arg0)
	return arg0.loading
end

function var0.Dispose(arg0)
	arg0.exited = true

	arg0:Unload()
end

return var0
