local var0_0 = class("BaseAgoraView", import("Mod.Island.Core.View.IslandView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg3_1, arg4_1)

	arg0_1.agora = arg2_1
	arg0_1.agora_callbacks = {}
end

function var0_0.SetUp(arg0_2)
	var0_0.super.SetUp(arg0_2)
	arg0_2:AddAgoraListeners()
end

function var0_0.AddAgoraListeners(arg0_3)
	return
end

function var0_0.RemoveAgoraListeners(arg0_4)
	return
end

function var0_0.AddAgoraListener(arg0_5, arg1_5, arg2_5)
	local function var0_5(arg0_6, ...)
		arg2_5(arg0_5, ...)
	end

	assert(arg0_5.agora_callbacks[arg2_5] == nil, "This method has been monitored. Please use another one" .. arg1_5)

	arg0_5.agora_callbacks[arg2_5] = var0_5

	arg0_5.agora:AddListener(arg1_5, var0_5)
end

function var0_0.RemoveAgoraListener(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.agora_callbacks[arg2_7]

	if var0_7 then
		arg0_7.agora:RemoveListener(arg1_7, var0_7)

		arg0_7.agora_callbacks[var0_7] = nil
	end
end

function var0_0.OnDispose(arg0_8)
	var0_0.super.OnDispose(arg0_8)
	arg0_8:RemoveAgoraListeners()
end

return var0_0
