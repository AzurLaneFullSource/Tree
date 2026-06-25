local var0_0 = class("Dorm3dGameBaseSubView", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)
	var0_0.super.Ctor(arg0_1, arg2_1)

	arg0_1._tf = arg1_1
	arg0_1.go = arg1_1.gameObject
	arg0_1.contextData = arg3_1

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	return
end

function var0_0.Flush(arg0_3)
	return
end

function var0_0.Show(arg0_4)
	setActive(arg0_4._tf, true)
end

function var0_0.Hide(arg0_5)
	setActive(arg0_5._tf, false)
end

function var0_0.Dispose(arg0_6)
	arg0_6:cleanManagedTween()
	arg0_6:disposeEvent()
	pg.DelegateInfo.Dispose(arg0_6)
end

return var0_0
