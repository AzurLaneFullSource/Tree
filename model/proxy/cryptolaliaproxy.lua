local var0_0 = class("CryptolaliaProxy", import(".NetProxy"))

function var0_0.register(arg0_1)
	arg0_1.isLoop = false
end

function var0_0.SetLoop(arg0_2, arg1_2)
	arg0_2.isLoop = arg1_2
end

function var0_0.GetLoop(arg0_3)
	return arg0_3.isLoop
end

return var0_0
