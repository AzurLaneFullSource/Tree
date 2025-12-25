local var0_0 = class("BaseLadyEnv")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.event = arg1_1
	arg0_1.scene = arg2_1
end

function var0_0.Emit(arg0_2, arg1_2, ...)
	arg0_2.event:emit(arg1_2, ...)
end

function var0_0.Func(arg0_3, arg1_3, ...)
	assert(arg0_3.scene[arg1_3], "Function " .. arg1_3 .. " not found in scene")

	return arg0_3.scene[arg1_3](arg0_3.scene, ...)
end

function var0_0.Get(arg0_4, arg1_4)
	return arg0_4.scene[arg1_4]
end

function var0_0.Init(arg0_5)
	return
end

function var0_0.HandleNotification(arg0_6, arg1_6, arg2_6)
	return
end

function var0_0.GetInterests()
	return {}
end

function var0_0.IsOpen()
	return false
end

function var0_0.Dispose(arg0_9)
	return
end

return var0_0
