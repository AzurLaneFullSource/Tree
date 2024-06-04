local var0 = class("CourtYardBaseModule")
local var1 = 0
local var2 = 1
local var3 = 2

function var0.Ctor(arg0, arg1, arg2)
	arg0.state = var1

	pg.DelegateInfo.New(arg0)

	arg0._go = arg2
	arg0._tf = arg2.transform
	arg0.data = arg1
	arg0.callbacks = {}

	arg0:Init()
end

function var0.Init(arg0)
	if arg0.state == var1 then
		arg0.state = var2

		arg0:OnInit()
		arg0:AddListeners()
	end
end

function var0.IsInit(arg0)
	return arg0.state == var2
end

function var0.AddListener(arg0, arg1, arg2)
	local function var0(arg0, arg1, ...)
		arg2(arg0, ...)
	end

	arg0.callbacks[arg2] = var0

	arg0.data:AddListener(arg1, var0)
end

function var0.RemoveListener(arg0, arg1, arg2)
	local var0 = arg0.callbacks[arg2]

	if var0 then
		arg0.data:RemoveListener(arg1, var0)

		arg0.callbacks[var0] = nil
	end
end

function var0.GetController(arg0)
	return arg0.data:GetHost()
end

function var0.GetView(arg0)
	return arg0:GetController():GetBridge():GetView()
end

function var0.Emit(arg0, arg1, ...)
	arg0:GetController():Receive(arg1, ...)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	if arg0.state == var2 then
		arg0:RemoveListeners()
		arg0:OnDispose()
	end

	arg0.state = var3

	arg0:OnDestroy()

	arg0._go = nil
	arg0.callbacks = nil
end

function var0.IsExit(arg0)
	return arg0.state == var3 or IsNil(arg0._go) or IsNil(arg0._tf)
end

function var0.OnInit(arg0)
	return
end

function var0.AddListeners(arg0)
	return
end

function var0.RemoveListeners(arg0)
	return
end

function var0.OnDispose(arg0)
	return
end

function var0.OnDestroy(arg0)
	return
end

return var0
