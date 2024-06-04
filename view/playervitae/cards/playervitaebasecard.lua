local var0 = class("PlayerVitaeBaseCard")
local var1 = 160
local var2 = 25

function var0.Ctor(arg0, arg1, arg2)
	arg0.event = arg2

	pg.DelegateInfo.New(arg0)
	arg0:Init(arg1)
end

function var0.Init(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.width = arg0._tf.sizeDelta.x
	arg0.mask = arg0._tf:Find("mask")

	arg0:OnInit()
end

function var0.UpdatePosition(arg0, arg1)
	local var0 = var1 + (arg0.width + var2) * (arg1 - 1)

	arg0._tf.anchoredPosition3D = Vector3(var0, 0, 0)

	arg0._tf:SetSiblingIndex(arg1 - 1)
end

function var0.Update(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0:OnUpdate(arg1, arg2, arg3, arg4, arg5)
	arg0:UpdatePosition(arg1)
end

function var0.Enable(arg0)
	setActive(arg0._tf, true)
end

function var0.Disable(arg0)
	setActive(arg0._tf, false)
end

function var0.Clone(arg0)
	local var0 = cloneTplTo(arg0._go, arg0._go.parent)

	return _G[arg0.__cname].New(var0, arg0.event)
end

function var0.emit(arg0, ...)
	if arg0.event then
		arg0.event:emit(...)
	end
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:OnDispose()
end

function var0.OnInit(arg0)
	return
end

function var0.OnUpdate(arg0, arg1, arg2, arg3, arg4, arg5)
	return
end

function var0.OnDispose(arg0)
	return
end

return var0
