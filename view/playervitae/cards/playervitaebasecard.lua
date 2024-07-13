local var0_0 = class("PlayerVitaeBaseCard")
local var1_0 = 160
local var2_0 = 25

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.event = arg2_1

	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init(arg1_1)
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2.width = arg0_2._tf.sizeDelta.x
	arg0_2.mask = arg0_2._tf:Find("mask")

	arg0_2:OnInit()
end

function var0_0.UpdatePosition(arg0_3, arg1_3)
	local var0_3 = var1_0 + (arg0_3.width + var2_0) * (arg1_3 - 1)

	arg0_3._tf.anchoredPosition3D = Vector3(var0_3, 0, 0)

	arg0_3._tf:SetSiblingIndex(arg1_3 - 1)
end

function var0_0.Update(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
	arg0_4:OnUpdate(arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
	arg0_4:UpdatePosition(arg1_4)
end

function var0_0.Enable(arg0_5)
	setActive(arg0_5._tf, true)
end

function var0_0.Disable(arg0_6)
	setActive(arg0_6._tf, false)
end

function var0_0.Clone(arg0_7)
	local var0_7 = cloneTplTo(arg0_7._go, arg0_7._go.parent)

	return _G[arg0_7.__cname].New(var0_7, arg0_7.event)
end

function var0_0.emit(arg0_8, ...)
	if arg0_8.event then
		arg0_8.event:emit(...)
	end
end

function var0_0.Dispose(arg0_9)
	pg.DelegateInfo.Dispose(arg0_9)
	arg0_9:OnDispose()
end

function var0_0.OnInit(arg0_10)
	return
end

function var0_0.OnUpdate(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11)
	return
end

function var0_0.OnDispose(arg0_12)
	return
end

return var0_0
