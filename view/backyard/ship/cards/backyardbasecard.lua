local var0 = class("BackYardBaseCard")

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0.event = arg2
	arg0._go = arg1
	arg0._content = arg1:Find("content")

	arg0:OnInit()

	arg0.startPos = Vector2(135, -354)
	arg0.space = 255
end

function var0.Disable(arg0)
	setActive(arg0._go, false)
end

function var0.Enable(arg0)
	setActive(arg0._go, true)
end

function var0.Flush(arg0, arg1, arg2)
	arg0.type = arg1
	arg0.ship = arg2

	arg0:OnFlush()
end

function var0.emit(arg0, ...)
	if arg0.event then
		arg0.event:emit(...)
	end
end

function var0.Clone(arg0)
	local var0 = cloneTplTo(arg0._go, arg0._go.parent)

	return _G[arg0.__cname].New(var0, arg0.event)
end

function var0.SetSiblingIndex(arg0, arg1)
	arg0._go.gameObject.name = arg1

	local var0 = arg0.startPos.x + (arg1 - 1) * arg0.space

	arg0._go.anchoredPosition3D = Vector3(var0, arg0.startPos.y, 0)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:OnDispose()

	if not IsNil(arg0._go) then
		Object.Destroy(arg0._go.gameObject)
	end
end

function var0.OnInit(arg0)
	return
end

function var0.OnFlush(arg0)
	return
end

function var0.OnDispose(arg0)
	return
end

return var0
