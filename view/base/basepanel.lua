local var0_0 = class("BasePanel")

function var0_0.Ctor(arg0_1, arg1_1)
	assert(arg1_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform

	function arg0_1.emit()
		assert(false, "can not emit event beforce attach to a parent ui.")
	end

	arg0_1:init()
end

function var0_0.init(arg0_3)
	return
end

function var0_0.attach(arg0_4, arg1_4)
	assert(arg1_4)

	arg0_4.exited = false
	arg0_4.parent = arg1_4
	arg0_4.contextData = arg1_4.contextData

	function arg0_4.emit(arg0_5, arg1_5, ...)
		if arg0_5.parent then
			arg0_5.parent:emit(arg1_5, ...)
		end
	end

	setActive(arg0_4._go, true)
	pg.DelegateInfo.New(arg0_4)
end

function var0_0.detach(arg0_6)
	if not arg0_6.exited then
		setActive(arg0_6._go, false)
		pg.DelegateInfo.Dispose(arg0_6)
		arg0_6:clear()

		arg0_6.parent = nil
		arg0_6.emit = nil
		arg0_6.exited = true
	end
end

function var0_0.findTF(arg0_7, arg1_7, arg2_7)
	assert(arg0_7._tf, "transform should exist")

	return findTF(arg2_7 or arg0_7._tf, arg1_7)
end

function var0_0.getTpl(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8:findTF(arg1_8, arg2_8)

	var0_8:SetParent(arg0_8._tf, false)
	SetActive(var0_8, false)

	return var0_8
end

function var0_0.clear(arg0_9)
	return
end

return var0_0
