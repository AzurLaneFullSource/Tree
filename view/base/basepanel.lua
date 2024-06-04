local var0 = class("BasePanel")

function var0.Ctor(arg0, arg1)
	assert(arg1)

	arg0._go = arg1
	arg0._tf = arg1.transform

	function arg0.emit()
		assert(false, "can not emit event beforce attach to a parent ui.")
	end

	arg0:init()
end

function var0.init(arg0)
	return
end

function var0.attach(arg0, arg1)
	assert(arg1)

	arg0.exited = false
	arg0.parent = arg1
	arg0.contextData = arg1.contextData

	function arg0.emit(arg0, arg1, ...)
		if arg0.parent then
			arg0.parent:emit(arg1, ...)
		end
	end

	setActive(arg0._go, true)
	pg.DelegateInfo.New(arg0)
end

function var0.detach(arg0)
	if not arg0.exited then
		setActive(arg0._go, false)
		pg.DelegateInfo.Dispose(arg0)
		arg0:clear()

		arg0.parent = nil
		arg0.emit = nil
		arg0.exited = true
	end
end

function var0.findTF(arg0, arg1, arg2)
	assert(arg0._tf, "transform should exist")

	return findTF(arg2 or arg0._tf, arg1)
end

function var0.getTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF(arg1, arg2)

	var0:SetParent(arg0._tf, false)
	SetActive(var0, false)

	return var0
end

function var0.clear(arg0)
	return
end

return var0
