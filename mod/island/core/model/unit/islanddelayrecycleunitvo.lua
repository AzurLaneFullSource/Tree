local var0_0 = class("IslandDelayRecycleUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.delayRecycleTime = arg1_1.delayRecycleTime
	arg0_1.recycleAssetType = arg1_1.recycleAssetType
end

return var0_0
