local var0_0 = class("BasePerformPlayer")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._anim = arg0_1._tf:GetComponent(typeof(Animation))

	arg0_1:Hide()
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	assert(nil, "Play方法必须由子类实现")
end

function var0_0.Show(arg0_3)
	setActive(arg0_3._go, true)
end

function var0_0.Hide(arg0_4)
	setActive(arg0_4._go, false)
end

function var0_0.Clear(arg0_5)
	assert(nil, "Clear方法必须由子类实现")
end

function var0_0.findTF(arg0_6, arg1_6, arg2_6)
	assert(arg0_6._tf, "transform should exist")

	return findTF(arg2_6 or arg0_6._tf, arg1_6)
end

return var0_0
