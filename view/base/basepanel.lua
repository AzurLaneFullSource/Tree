local var0_0 = class("BasePanel")

function var0_0.Ctor(arg0_1, arg1_1)
	assert(arg1_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform

	function arg0_1.emit()
		assert(false, "can not emit event beforce attach to a parent ui.")
	end

	bindComponent(arg0_1, arg0_1._go)
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

	function arg0_4.bind(arg0_6, ...)
		if arg0_6.parent then
			arg0_6.parent:bind(...)
		end
	end

	function arg0_4.disconnect(arg0_7, arg1_7)
		if arg0_7.parent then
			arg0_7.parent:disconnect(arg1_7)
		end
	end

	setActive(arg0_4._go, true)
	pg.DelegateInfo.New(arg0_4)
end

function var0_0.detach(arg0_8)
	if not arg0_8.exited then
		setActive(arg0_8._go, false)
		pg.DelegateInfo.Dispose(arg0_8)
		arg0_8:clear()

		arg0_8.parent = nil
		arg0_8.emit = nil
		arg0_8.bind = nil
		arg0_8.disconnect = nil
		arg0_8.exited = true
	end
end

function var0_0.getTpl(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg2_9:Find(arg1_9)

	var0_9:SetParent(arg0_9._tf, false)
	SetActive(var0_9, false)

	return var0_9
end

function var0_0.clear(arg0_10)
	return
end

return var0_0
