local var0_0 = class("IslandWildGatherUnit", import(".IslandSceneUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var0_0.GetHudInfo(arg0_2)
	local var0_2 = {}

	var0_2.needShowHud = true

	if arg0_2.data.gatherType == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM then
		local var1_2 = pg.island_wild_gather[arg0_2.data.gatherData.configId]

		var0_2.name = var1_2.name
		var0_2.itemIcon = "island/" .. var1_2.icon
	else
		local var2_2 = pg.island_collect_fragment[arg0_2.data.gatherData.configId]

		var0_2.name = var2_2.name
		var0_2.itemIcon = "island/" .. var2_2.icon
	end

	return var0_2
end

function var0_0.StartGather(arg0_3, arg1_3)
	local var0_3 = arg0_3.data:GetGatherData()

	if not var0_3 then
		return
	end

	if arg0_3.data.gatherType == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM then
		var0_3:StartGaher(arg0_3.id, arg1_3)
	else
		var0_3:StartCollect(arg0_3.id, arg1_3)
	end
end

function var0_0.StartGaherSign(arg0_4, arg1_4)
	local var0_4 = arg0_4.data:GetGatherData()

	if not var0_4 then
		return
	end

	if arg0_4.data.gatherType == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM then
		var0_4:StartGaherSign(arg0_4.id, arg1_4)
	else
		var0_4:StartCollectSign(arg0_4.id, arg1_4)
	end
end

function var0_0.CheckGatherCanSign(arg0_5)
	local var0_5 = arg0_5.data:GetGatherData()

	if not var0_5 then
		return false
	end

	if arg0_5.data.gatherType == IslandConst.UNIT_TYPE_ITEM_GATHER_ITEM then
		return var0_5:CheckGatherCanSign()
	else
		return var0_5:StartCollectSign()
	end
end

return var0_0
