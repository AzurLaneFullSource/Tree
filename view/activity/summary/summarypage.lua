local var0 = class("SummaryPage")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)

	pg.DelegateInfo.New(arg0)
end

function var0.Init(arg0, arg1)
	arg0.summaryInfoVO = arg1

	arg0:OnInit()
end

function var0.OnInit(arg0)
	assert(false)
end

function var0.Show(arg0, arg1)
	setActive(arg0._tf, true)

	if arg1 then
		arg1()
	end
end

function var0.Hide(arg0, arg1)
	setActive(arg0._tf, false)

	if arg1 then
		arg1()
	end
end

function var0.inAnim(arg0)
	assert(false)
end

function var0.Clear(arg0)
	return
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

return var0
