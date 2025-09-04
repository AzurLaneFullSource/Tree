local var0_0 = class("IslandComparableAllocator")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.controller = arg1_1
	arg0_1.flags = {}

	arg0_1:OnInitFlags()
end

function var0_0.Flush(arg0_2)
	local var0_2 = Clone(arg0_2.flags)

	arg0_2.flags = {}

	arg0_2:OnInitFlags()
	arg0_2:OnCompareSample(var0_2, arg0_2.flags)
end

function var0_0.Dispose(arg0_3)
	arg0_3:OnDispose()

	arg0_3.controller = nil
	arg0_3.flags = nil
end

function var0_0.RemoveUnit(arg0_4, arg1_4, arg2_4)
	arg0_4.controller:NotifiyCore(ISLAND_EVT.RMOVE_UNIT, arg1_4, arg2_4)
end

function var0_0.GenUnit(arg0_5, arg1_5)
	arg0_5.controller:NotifiyCore(ISLAND_EVT.GEN_UNIT, arg1_5)
end

function var0_0.OnInitFlags(arg0_6)
	assert(false, "overwrite!!!")
end

function var0_0.IsVisible(arg0_7, arg1_7)
	assert(false, "overwrite!!!")
end

function var0_0.OnCompareSample(arg0_8, arg1_8, arg2_8)
	assert(false, "overwrite!!!")
end

function var0_0.OnDispose(arg0_9)
	return
end

return var0_0
