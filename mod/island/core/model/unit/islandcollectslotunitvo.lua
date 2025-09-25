local var0_0 = class("IslandCollectSlotUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.isSelfIsland = arg1_1.isSelfIsland
	arg0_1.slotId = arg1_1.slotId

	arg0_1:BindSlotData()
end

function var0_0.BindSlotData(arg0_2)
	arg0_2.slotData = arg0_2:HandCollectSlotData()
end

function var0_0.HandCollectSlotData(arg0_3)
	local var0_3

	if arg0_3.isSelfIsland then
		var0_3 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	else
		var0_3 = getProxy(IslandProxy):GetSharedIsland():GetBuildingAgency()
	end

	local var1_3 = pg.island_production_slot[arg0_3.slotId].place
	local var2_3 = var0_3:GetBuilding(var1_3)

	if not var2_3 then
		return nil
	end

	local var3_3 = var2_3:GetCollectSlotData(arg0_3.slotId)

	if var3_3 then
		return var3_3
	end
end

return var0_0
