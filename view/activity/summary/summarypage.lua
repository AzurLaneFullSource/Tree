local var0_0 = class("SummaryPage")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)

	pg.DelegateInfo.New(arg0_1)
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2.summaryInfoVO = arg1_2

	arg0_2:OnInit()
end

function var0_0.OnInit(arg0_3)
	assert(false)
end

function var0_0.Show(arg0_4, arg1_4)
	setActive(arg0_4._tf, true)

	if arg1_4 then
		arg1_4()
	end
end

function var0_0.Hide(arg0_5, arg1_5)
	setActive(arg0_5._tf, false)

	if arg1_5 then
		arg1_5()
	end
end

function var0_0.inAnim(arg0_6)
	assert(false)
end

function var0_0.Clear(arg0_7)
	return
end

function var0_0.Dispose(arg0_8)
	pg.DelegateInfo.Dispose(arg0_8)
	arg0_8:Clear()
end

return var0_0
