local var0 = class("BasePerformPlayer")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._anim = arg0._tf:GetComponent(typeof(Animation))

	arg0:Hide()
end

function var0.Play(arg0, arg1, arg2)
	assert(nil, "Play方法必须由子类实现")
end

function var0.Show(arg0)
	setActive(arg0._go, true)
end

function var0.Hide(arg0)
	setActive(arg0._go, false)
end

function var0.Clear(arg0)
	assert(nil, "Clear方法必须由子类实现")
end

function var0.findTF(arg0, arg1, arg2)
	assert(arg0._tf, "transform should exist")

	return findTF(arg2 or arg0._tf, arg1)
end

return var0
