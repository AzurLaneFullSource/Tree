local var0 = class("MainBaseBtn", import("view.base.BaseEventLogic"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg2)

	arg0._tf = arg1
end

function var0.GetTarget(arg0)
	return arg0._tf
end

function var0.IsFixed(arg0)
	return false
end

function var0.OnClick(arg0)
	return
end

function var0.Flush(arg0, arg1)
	return
end

function var0.Dispose(arg0)
	arg0:disposeEvent()
end

return var0
