local var0_0 = class("IslandBaseController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.core = arg1_1
	arg0_1.island = arg2_1
	arg0_1.__callbacks = {}

	arg0_1:Init()
end

function var0_0.IsSelfIsland(arg0_2)
	return getProxy(IslandProxy):GetIsland().id == arg0_2.island.id
end

function var0_0.GetCore(arg0_3)
	return arg0_3.core
end

function var0_0.OnCoreStateChanged(arg0_4, arg1_4)
	if arg1_4 == IslandCore.STATE_INIT_FINISH then
		arg0_4:AddListeners()
		arg0_4:OnCoreInitFinish()
	end
end

function var0_0.Dispose(arg0_5)
	arg0_5:RemoveListeners()
	arg0_5:OnDispose()
end

function var0_0.AddIslandListener(arg0_6, arg1_6, arg2_6)
	local function var0_6(arg0_7, ...)
		arg2_6(arg0_6, ...)
	end

	arg0_6.__callbacks[arg2_6] = var0_6

	arg0_6.island:AddListener(arg1_6, var0_6)
end

function var0_0.RemoveIslandListener(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.__callbacks[arg2_8]

	if var0_8 then
		arg0_8.island:RemoveListener(arg1_8, var0_8)

		arg0_8.__callbacks[var0_8] = nil
	end
end

function var0_0.NotifiyCore(arg0_9, arg1_9, ...)
	arg0_9.core:DispatchEvent(arg1_9, ...)
end

function var0_0.NotifiyIsland(arg0_10, arg1_10, ...)
	arg0_10.island:DispatchEvent(arg1_10, ...)
end

function var0_0.Receive(arg0_11, arg1_11, ...)
	if arg0_11[arg1_11] then
		arg0_11[arg1_11](arg0_11, ...)
	end
end

function var0_0.AddListeners(arg0_12)
	return
end

function var0_0.RemoveListeners(arg0_13)
	return
end

function var0_0.Init(arg0_14)
	return
end

function var0_0.SetUp(arg0_15)
	return
end

function var0_0.OnCoreInitFinish(arg0_16)
	return
end

function var0_0.Update(arg0_17)
	return
end

function var0_0.LateUpdate(arg0_18)
	return
end

function var0_0.OnDispose(arg0_19)
	return
end

return var0_0
