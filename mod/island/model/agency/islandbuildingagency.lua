local var0_0 = class("IslandBuildingAgency", import(".IslandBaseAgency"))

var0_0.SLOT_STATE_CHANGE = "IslandBuildingAgency:SLOT_STATE_CHANGE"
var0_0.SLOT_UNIT_REMOVE = "IslandBuildingAgency:SLOT_UNIT_REMOVE"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.buildings = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.build_list or {}) do
		local var0_1 = IslandBuilding.New(iter1_1)

		arg0_1.buildings[iter1_1.id] = var0_1
	end
end

function var0_0.GetBuilding(arg0_2, arg1_2)
	return arg0_2.buildings[arg1_2]
end

function var0_0.GetBuildings(arg0_3)
	return arg0_3.buildings
end

function var0_0.GetBuildingList(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in pairs(arg0_4.buildings) do
		table.insert(var0_4, iter1_4)
	end

	return var0_4
end

function var0_0.UpdateBuilding(arg0_5, arg1_5)
	arg0_5.buildings[arg1_5.id] = arg1_5
end

function var0_0.UpdatePerSecond(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6.buildings) do
		iter1_6:UpdatePerSecond()
	end
end

function var0_0.InitSlotRoleDataByAbility(arg0_7, arg1_7)
	local var0_7 = pg.island_ability_template[arg1_7].effect
	local var1_7 = pg.island_production_slot[var0_7].place
	local var2_7 = arg0_7:GetBuilding(var1_7)

	if not var2_7 then
		warning("需要先解锁产地,再解锁产地上的槽位")

		return
	end

	var2_7:InitSlotRoleDataByAbility(var0_7)
end

function var0_0.InitBuildData(arg0_8, arg1_8)
	if arg0_8.buildings[arg1_8.id] then
		warning("产地已经解锁过了,下发的产地id是" .. arg1_8.id)

		return
	end

	local var0_8 = IslandBuilding.New(arg1_8)

	arg0_8.buildings[arg1_8.id] = var0_8
end

function var0_0.GetCurrentMapCheckWorldObjectList(arg0_9)
	local var0_9 = arg0_9.host:GetMapId()
	local var1_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9:GetBuildings()) do
		if iter1_9:getConfigTable().map_id == var0_9 then
			local var2_9 = iter1_9:GetCheckWorldIdByModelData()

			var1_9 = table.mergeArray(var1_9, var2_9)
		end
	end

	return var1_9
end

function var0_0.GetMinimumDelegationCompletionTimeByMapId(arg0_10, arg1_10)
	local var0_10 = pg.island_production_place.get_id_list_by_map_id[arg1_10] or {}
	local var1_10

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var2_10 = arg0_10.buildings[iter1_10]

		if var2_10 then
			local var3_10 = var2_10:GetMinRoleDeleGationTime()

			if var3_10 ~= -1 then
				var1_10 = var1_10 and math.min(var3_10, var1_10) or var3_10
			end
		end
	end

	return var1_10 and var1_10 or -1
end

function var0_0.GetDelegationSlotDataByTechId(arg0_11, arg1_11)
	local var0_11 = arg0_11.buildings[IslandTechnologyAgency.PLACE_ID]

	if not var0_11 then
		return
	end

	local var1_11 = pg.island_technology_template[arg1_11].formula_id

	return var0_11:GetDelegationSlotDataByFormulaId(var1_11)
end

return var0_0
