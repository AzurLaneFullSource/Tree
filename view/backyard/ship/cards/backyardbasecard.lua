local var0_0 = class("BackYardBaseCard")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.event = arg2_1
	arg0_1._go = arg1_1
	arg0_1._content = arg1_1:Find("content")

	arg0_1:OnInit()

	arg0_1.startPos = Vector2(135, -354)
	arg0_1.space = 255
end

function var0_0.Disable(arg0_2)
	setActive(arg0_2._go, false)
end

function var0_0.Enable(arg0_3)
	setActive(arg0_3._go, true)
end

function var0_0.Flush(arg0_4, arg1_4, arg2_4)
	arg0_4.type = arg1_4
	arg0_4.ship = arg2_4

	arg0_4:OnFlush()
end

function var0_0.emit(arg0_5, ...)
	if arg0_5.event then
		arg0_5.event:emit(...)
	end
end

function var0_0.Clone(arg0_6)
	local var0_6 = cloneTplTo(arg0_6._go, arg0_6._go.parent)

	return _G[arg0_6.__cname].New(var0_6, arg0_6.event)
end

function var0_0.SetSiblingIndex(arg0_7, arg1_7)
	arg0_7._go.gameObject.name = arg1_7

	local var0_7 = arg0_7.startPos.x + (arg1_7 - 1) * arg0_7.space

	arg0_7._go.anchoredPosition3D = Vector3(var0_7, arg0_7.startPos.y, 0)
end

function var0_0.Dispose(arg0_8)
	pg.DelegateInfo.Dispose(arg0_8)
	arg0_8:OnDispose()

	if not IsNil(arg0_8._go) then
		Object.Destroy(arg0_8._go.gameObject)
	end
end

function var0_0.OnInit(arg0_9)
	return
end

function var0_0.OnFlush(arg0_10)
	return
end

function var0_0.OnDispose(arg0_11)
	return
end

return var0_0
