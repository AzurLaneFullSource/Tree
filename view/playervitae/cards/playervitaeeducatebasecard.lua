local var0_0 = class("PlayerVitaeEducateBaseCard", import("view.base.BaseEventLogic"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1._go = arg1_1.gameObject
end

function var0_0.ShowOrHide(arg0_2, arg1_2)
	setActive(arg0_2._tf, arg1_2)

	if not arg1_2 then
		arg0_2:Clear()
	end
end

function var0_0.Flush(arg0_3)
	return
end

function var0_0.Clear(arg0_4)
	return
end

function var0_0.Dispose(arg0_5)
	pg.DelegateInfo.Dispose(arg0_5)
	arg0_5:Clear()
end

return var0_0
