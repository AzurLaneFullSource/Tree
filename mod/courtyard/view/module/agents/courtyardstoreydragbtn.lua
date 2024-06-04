local var0 = class("CourtYardStoreyDragBtn")

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._go = arg1.gameObject
	arg0.agent = CourtYardDragAgent.New(arg0, arg2)

	arg0.agent:Enable(false)
end

function var0.Active(arg0, arg1, arg2, arg3)
	arg0.OnDragCallBack = arg1
	arg0.OnDragingCallBack = arg2
	arg0.OnDragEndCallBack = arg3

	arg0.agent:Enable(true)
end

function var0.DeActive(arg0)
	arg0.OnDragCallBack = nil
	arg0.OnDragingCallBack = nil
	arg0.OnDragEndCallBack = nil

	arg0.agent:Enable(false)
end

function var0.OnBeginDrag(arg0)
	if arg0.OnDragCallBack then
		arg0.OnDragCallBack()
	end
end

function var0.OnDragging(arg0, arg1)
	if arg0.OnDragingCallBack then
		arg0.OnDragingCallBack(arg1)
	end
end

function var0.OnDragEnd(arg0, arg1)
	if arg0.OnDragEndCallBack then
		arg0.OnDragEndCallBack(arg1)
	end
end

function var0.Dispose(arg0)
	arg0:DeActive()
	arg0.agent:Dispose()
end

return var0
