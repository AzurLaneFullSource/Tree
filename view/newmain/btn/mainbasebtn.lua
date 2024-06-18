local var0_0 = class("MainBaseBtn", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg2_1)

	arg0_1._tf = arg1_1
end

function var0_0.GetTarget(arg0_2)
	return arg0_2._tf
end

function var0_0.IsFixed(arg0_3)
	return false
end

function var0_0.OnClick(arg0_4)
	return
end

function var0_0.Flush(arg0_5, arg1_5)
	return
end

function var0_0.Dispose(arg0_6)
	arg0_6:disposeEvent()
end

return var0_0
