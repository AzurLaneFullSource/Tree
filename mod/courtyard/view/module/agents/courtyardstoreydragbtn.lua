local var0_0 = class("CourtYardStoreyDragBtn")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._go = arg1_1.gameObject
	arg0_1.agent = CourtYardDragAgent.New(arg0_1, arg2_1)

	arg0_1.agent:Enable(false)
end

function var0_0.Active(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.OnDragCallBack = arg1_2
	arg0_2.OnDragingCallBack = arg2_2
	arg0_2.OnDragEndCallBack = arg3_2

	arg0_2.agent:Enable(true)
end

function var0_0.DeActive(arg0_3)
	arg0_3.OnDragCallBack = nil
	arg0_3.OnDragingCallBack = nil
	arg0_3.OnDragEndCallBack = nil

	arg0_3.agent:Enable(false)
end

function var0_0.OnBeginDrag(arg0_4)
	if arg0_4.OnDragCallBack then
		arg0_4.OnDragCallBack()
	end
end

function var0_0.OnDragging(arg0_5, arg1_5)
	if arg0_5.OnDragingCallBack then
		arg0_5.OnDragingCallBack(arg1_5)
	end
end

function var0_0.OnDragEnd(arg0_6, arg1_6)
	if arg0_6.OnDragEndCallBack then
		arg0_6.OnDragEndCallBack(arg1_6)
	end
end

function var0_0.Dispose(arg0_7)
	arg0_7:DeActive()
	arg0_7.agent:Dispose()
end

return var0_0
