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

function var0_0.GetSelfIsland(arg0_3)
	return (getProxy(IslandProxy):GetIsland())
end

function var0_0.IsSelfIsland(arg0_4)
	return getProxy(IslandProxy):GetIsland().id == arg0_4.island.id
end

function var0_0.GetCore(arg0_5)
	return arg0_5.core
end

function var0_0.GetView(arg0_6)
	return arg0_6.core:GetView()
end

function var0_0.OnCoreStateChanged(arg0_7, arg1_7)
	if arg1_7 == IslandCore.STATE_INIT_FINISH then
		arg0_7:AddListeners()
		arg0_7:OnCoreInitFinish()
	end
end

function var0_0.Dispose(arg0_8)
	arg0_8:RemoveListeners()
	arg0_8:OnDispose()
end

function var0_0.AddIslandListener(arg0_9, arg1_9, arg2_9)
	local function var0_9(arg0_10, ...)
		arg2_9(arg0_9, ...)
	end

	assert(arg0_9.__callbacks[arg2_9] == nil, "This method has been monitored. Please use another one" .. arg1_9)

	arg0_9.__callbacks[arg2_9] = var0_9

	arg0_9.island:AddListener(arg1_9, var0_9)
end

function var0_0.RemoveIslandListener(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.__callbacks[arg2_11]

	if var0_11 then
		arg0_11.island:RemoveListener(arg1_11, var0_11)

		arg0_11.__callbacks[var0_11] = nil
	end
end

function var0_0.NotifiyCore(arg0_12, arg1_12, ...)
	arg0_12.core:DispatchEvent(arg1_12, ...)
end

function var0_0.NotifiyIsland(arg0_13, arg1_13, ...)
	arg0_13.island:DispatchEvent(arg1_13, ...)
end

function var0_0.NotifiyMeditor(arg0_14, arg1_14, ...)
	arg0_14:NotifiyIsland(ISLAND_EX_EVT.EMIT, arg1_14, ...)
end

function var0_0.Receive(arg0_15, arg1_15, ...)
	if arg0_15[arg1_15] then
		arg0_15[arg1_15](arg0_15, ...)
	end
end

function var0_0.AddListeners(arg0_16)
	return
end

function var0_0.RemoveListeners(arg0_17)
	return
end

function var0_0.Init(arg0_18)
	return
end

function var0_0.SetUp(arg0_19)
	return
end

function var0_0.OnCoreInitFinish(arg0_20)
	return
end

function var0_0.Update(arg0_21)
	return
end

function var0_0.LateUpdate(arg0_22)
	return
end

function var0_0.OnDispose(arg0_23)
	return
end

return var0_0
