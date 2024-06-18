local var0_0 = class("NewNavalTacticsBaseCard")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.event = arg2_1
	arg0_1._tf = arg1_1
	arg0_1._go = arg1_1.gameObject

	arg0_1:OnInit()
end

function var0_0.emit(arg0_2, ...)
	if arg0_2.event then
		arg0_2.event:emit(...)
	end
end

function var0_0.UpdatePosition(arg0_3, arg1_3)
	local var0_3 = -493
	local var1_3 = 0
	local var2_3 = arg0_3._tf.sizeDelta.x
	local var3_3 = arg0_3._tf.anchoredPosition3D
	local var4_3 = var0_3 + (arg1_3 - 1) * (var2_3 + var1_3)

	arg0_3._tf.anchoredPosition3D = Vector3(var4_3, var3_3.y, 0)
end

function var0_0.Update(arg0_4, arg1_4, arg2_4)
	arg0_4.index = arg1_4

	arg0_4:UpdatePosition(arg1_4)
	arg0_4:OnUpdate(arg2_4)
end

function var0_0.Enable(arg0_5)
	setActive(arg0_5._go, true)
end

function var0_0.Disable(arg0_6)
	setActive(arg0_6._go, false)
end

function var0_0.Dispose(arg0_7)
	pg.DelegateInfo.Dispose(arg0_7)
	Object.Destroy(arg0_7._go)
	arg0_7:OnDispose()
end

function var0_0.Clone(arg0_8)
	local var0_8 = Object.Instantiate(arg0_8._go, arg0_8._tf.parent)

	assert(var0_8)

	return _G[arg0_8.__cname].New(var0_8.transform, arg0_8.event)
end

function var0_0.OnInit(arg0_9)
	return
end

function var0_0.OnUpdate(arg0_10, arg1_10)
	return
end

function var0_0.OnDispose(arg0_11)
	return
end

return var0_0
