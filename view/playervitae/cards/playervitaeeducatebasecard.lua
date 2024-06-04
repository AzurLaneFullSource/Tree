local var0 = class("PlayerVitaeEducateBaseCard", import("view.base.BaseEventLogic"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._tf = arg1
	arg0._go = arg1.gameObject
end

function var0.ShowOrHide(arg0, arg1)
	setActive(arg0._tf, arg1)

	if not arg1 then
		arg0:Clear()
	end
end

function var0.Flush(arg0)
	return
end

function var0.Clear(arg0)
	return
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

return var0
