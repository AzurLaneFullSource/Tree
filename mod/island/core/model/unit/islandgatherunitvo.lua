local var0_0 = class("IslandGatherUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.nowIslandId = arg0_1.index
	arg0_1.gatherType = arg0_1:GetType()

	arg0_1:BindGatherData()
end

function var0_0.BindGatherData(arg0_2)
	local var0_2 = (arg0_2.nowIslandId == getProxy(IslandProxy):GetIsland().id and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()):GetWildCollectAgency()

	if arg0_2.gatherType == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM then
		arg0_2.gatherData = var0_2:GetGatherDataByUnitId(arg0_2.id)
	else
		arg0_2.gatherData = var0_2:GetCollectDataByUnitId(arg0_2.id)
	end
end

function var0_0.GetGatherData(arg0_3)
	return arg0_3.gatherData
end

return var0_0
