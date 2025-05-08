local var0_0 = class("IslandBaseView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.core = arg1_1
	arg0_1.callbacks = {}
end

function var0_0.SetUp(arg0_2)
	arg0_2:Init()
	arg0_2:AddListeners()
end

function var0_0.OnCoreStateChanged(arg0_3)
	return
end

function var0_0.Emit(arg0_4, arg1_4, ...)
	arg0_4:Op("NotifiyCore", arg1_4, unpack({
		...
	}))
end

function var0_0.Op(arg0_5, arg1_5, ...)
	arg0_5:GetCore():GetController():Receive(arg1_5, ...)
end

function var0_0.IsSelfIsland(arg0_6)
	return arg0_6:GetCore():GetController():IsSelfIsland()
end

function var0_0.GetController(arg0_7)
	return arg0_7.core:GetController()
end

function var0_0.GetCore(arg0_8)
	return arg0_8.core
end

function var0_0.InMap(arg0_9, arg1_9)
	return arg0_9:GetCore():GetMapId() == arg1_9
end

function var0_0.AddListener(arg0_10, arg1_10, arg2_10)
	local function var0_10(arg0_11, ...)
		arg2_10(arg0_10, ...)
	end

	arg0_10.callbacks[arg2_10] = var0_10

	arg0_10.core:AddListener(arg1_10, var0_10)
end

function var0_0.RemoveListener(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.callbacks[arg2_12]

	if var0_12 then
		arg0_12.core:RemoveListener(arg1_12, var0_12)

		arg0_12.callbacks[var0_12] = nil
	end
end

function var0_0.Dispose(arg0_13)
	arg0_13:RemoveListeners()
	arg0_13:OnDispose()

	arg0_13.callbacks = nil
end

function var0_0.Init(arg0_14)
	return
end

function var0_0.Update(arg0_15)
	return
end

function var0_0.LateUpdate(arg0_16)
	return
end

function var0_0.AddListeners(arg0_17)
	return
end

function var0_0.RemoveListeners(arg0_18)
	return
end

function var0_0.OnDispose(arg0_19)
	return
end

return var0_0
