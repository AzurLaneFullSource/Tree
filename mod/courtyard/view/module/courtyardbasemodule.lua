local var0_0 = class("CourtYardBaseModule")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.state = var1_0

	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg2_1
	arg0_1._tf = arg2_1.transform
	arg0_1.data = arg1_1
	arg0_1.callbacks = {}

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	if arg0_2.state == var1_0 then
		arg0_2.state = var2_0

		arg0_2:OnInit()
		arg0_2:AddListeners()
	end
end

function var0_0.IsInit(arg0_3)
	return arg0_3.state == var2_0
end

function var0_0.AddListener(arg0_4, arg1_4, arg2_4)
	local function var0_4(arg0_5, arg1_5, ...)
		arg2_4(arg0_4, ...)
	end

	arg0_4.callbacks[arg2_4] = var0_4

	arg0_4.data:AddListener(arg1_4, var0_4)
end

function var0_0.RemoveListener(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.callbacks[arg2_6]

	if var0_6 then
		arg0_6.data:RemoveListener(arg1_6, var0_6)

		arg0_6.callbacks[var0_6] = nil
	end
end

function var0_0.GetController(arg0_7)
	return arg0_7.data:GetHost()
end

function var0_0.GetView(arg0_8)
	return arg0_8:GetController():GetBridge():GetView()
end

function var0_0.Emit(arg0_9, arg1_9, ...)
	arg0_9:GetController():Receive(arg1_9, ...)
end

function var0_0.Dispose(arg0_10)
	pg.DelegateInfo.Dispose(arg0_10)

	if arg0_10.state == var2_0 then
		arg0_10:RemoveListeners()
		arg0_10:OnDispose()
	end

	arg0_10.state = var3_0

	arg0_10:OnDestroy()

	arg0_10._go = nil
	arg0_10.callbacks = nil
end

function var0_0.IsExit(arg0_11)
	return arg0_11.state == var3_0 or IsNil(arg0_11._go) or IsNil(arg0_11._tf)
end

function var0_0.OnInit(arg0_12)
	return
end

function var0_0.AddListeners(arg0_13)
	return
end

function var0_0.RemoveListeners(arg0_14)
	return
end

function var0_0.OnDispose(arg0_15)
	return
end

function var0_0.OnDestroy(arg0_16)
	return
end

return var0_0
