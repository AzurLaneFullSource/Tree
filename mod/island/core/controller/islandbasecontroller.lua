local var0_0 = class("IslandBaseController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.core = arg1_1
	arg0_1.island = arg2_1
	arg0_1.__callbacks = {}

	arg0_1:Init()
end

function var0_0.GetIsland(arg0_2)
	return arg0_2.island
end

function var0_0.IsSelfIsland(arg0_3)
	return getProxy(IslandProxy):GetIsland().id == arg0_3.island.id
end

function var0_0.GetCore(arg0_4)
	return arg0_4.core
end

function var0_0.GetView(arg0_5)
	return arg0_5.core:GetView()
end

function var0_0.OnCoreStateChanged(arg0_6, arg1_6)
	if arg1_6 == IslandCore.STATE_INIT_FINISH then
		arg0_6:AddListeners()
		arg0_6:OnCoreInitFinish()
	end
end

function var0_0.Dispose(arg0_7)
	arg0_7:RemoveListeners()
	arg0_7:OnDispose()
end

function var0_0.AddIslandListener(arg0_8, arg1_8, arg2_8)
	local function var0_8(arg0_9, ...)
		arg2_8(arg0_8, ...)
	end

	assert(arg0_8.__callbacks[arg2_8] == nil, "This method has been monitored. Please use another one" .. arg1_8)

	arg0_8.__callbacks[arg2_8] = var0_8

	arg0_8.island:AddListener(arg1_8, var0_8)
end

function var0_0.RemoveIslandListener(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.__callbacks[arg2_10]

	if var0_10 then
		arg0_10.island:RemoveListener(arg1_10, var0_10)

		arg0_10.__callbacks[var0_10] = nil
	end
end

function var0_0.NotifiyCore(arg0_11, arg1_11, ...)
	arg0_11.core:DispatchEvent(arg1_11, ...)
end

function var0_0.NotifiyIsland(arg0_12, arg1_12, ...)
	arg0_12.island:DispatchEvent(arg1_12, ...)
end

function var0_0.NotifiyMeditor(arg0_13, arg1_13, ...)
	arg0_13:NotifiyIsland(ISLAND_EX_EVT.EMIT, arg1_13, ...)
end

function var0_0.Receive(arg0_14, arg1_14, ...)
	if arg0_14[arg1_14] then
		arg0_14[arg1_14](arg0_14, ...)
	end
end

function var0_0.AddListeners(arg0_15)
	return
end

function var0_0.RemoveListeners(arg0_16)
	return
end

function var0_0.Init(arg0_17)
	return
end

function var0_0.SetUp(arg0_18)
	return
end

function var0_0.OnCoreInitFinish(arg0_19)
	return
end

function var0_0.Update(arg0_20)
	return
end

function var0_0.LateUpdate(arg0_21)
	return
end

function var0_0.OnDispose(arg0_22)
	return
end

return var0_0
