local var0 = class("NewNavalTacticsBaseCard")

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.event = arg2
	arg0._tf = arg1
	arg0._go = arg1.gameObject

	arg0:OnInit()
end

function var0.emit(arg0, ...)
	if arg0.event then
		arg0.event:emit(...)
	end
end

function var0.UpdatePosition(arg0, arg1)
	local var0 = -493
	local var1 = 0
	local var2 = arg0._tf.sizeDelta.x
	local var3 = arg0._tf.anchoredPosition3D
	local var4 = var0 + (arg1 - 1) * (var2 + var1)

	arg0._tf.anchoredPosition3D = Vector3(var4, var3.y, 0)
end

function var0.Update(arg0, arg1, arg2)
	arg0.index = arg1

	arg0:UpdatePosition(arg1)
	arg0:OnUpdate(arg2)
end

function var0.Enable(arg0)
	setActive(arg0._go, true)
end

function var0.Disable(arg0)
	setActive(arg0._go, false)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	Object.Destroy(arg0._go)
	arg0:OnDispose()
end

function var0.Clone(arg0)
	local var0 = Object.Instantiate(arg0._go, arg0._tf.parent)

	assert(var0)

	return _G[arg0.__cname].New(var0.transform, arg0.event)
end

function var0.OnInit(arg0)
	return
end

function var0.OnUpdate(arg0, arg1)
	return
end

function var0.OnDispose(arg0)
	return
end

return var0
