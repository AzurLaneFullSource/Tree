local var0_0 = class("IslandBuildingAgency", import(".IslandBaseAgency"))

var0_0.SlOT_UNIT_INIT = "IslandBuildingAgency:SlOT_UNIT_INIT"
var0_0.SLOT_UNIT_REMOVE = "IslandBuildingAgency:SLOT_UNIT_REMOVE"
var0_0.SLOT_HANDPLABT_SLOT_UNIT_CHANGE = "IslandBuildingAgency:SLOT_HANDPLABT_SLOT_UNIT_CHANGE"
var0_0.SLOT_RESET_DELEGATION_STATE_DONE = "IslandBuildingAgency:SLOT_RESET_DELEGATION_STATE_DONE"
var0_0.GEN_ANIMAL_INT = "IslandBuildingAgency:GEN_ANIMAL_INT"

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.buildings = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.build_list or {}) do
		local var0_1 = IslandBuilding.New(iter1_1, arg0_1:IsSelf(arg1_1.id))

		arg0_1.buildings[iter1_1.id] = var0_1
	end
end

function var0_0.InitPrivateData(arg0_2, arg1_2)
	arg0_2.formulaNums = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.formula_num or {}) do
		arg0_2.formulaNums[iter1_2.id] = iter1_2.num
	end
end

function var0_0.IsSelf(arg0_3, arg1_3)
	return arg1_3 == getProxy(PlayerProxy):getRawData().id
end

function var0_0.GetBuilding(arg0_4, arg1_4)
	return arg0_4.buildings[arg1_4]
end

function var0_0.GetBuildings(arg0_5)
	return arg0_5.buildings
end

function var0_0.GetBuildingList(arg0_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.buildings) do
		table.insert(var0_6, iter1_6)
	end

	return var0_6
end

function var0_0.UpdateBuilding(arg0_7, arg1_7)
	arg0_7.buildings[arg1_7.id] = arg1_7
end

function var0_0.UpdatePerSecond(arg0_8)
	for iter0_8, iter1_8 in pairs(arg0_8.buildings) do
		iter1_8:UpdatePerSecond()
	end
end

function var0_0.InitSlotDataByAbility(arg0_9, arg1_9)
	local var0_9 = pg.island_ability_template[arg1_9].effect
	local var1_9 = pg.island_production_slot[var0_9]
	local var2_9 = var1_9.place
	local var3_9 = arg0_9:GetBuilding(var2_9)

	if not var3_9 then
		warning("需要先解锁产地,再解锁产地上的槽位")

		return
	end

	if var1_9.type == 1 then
		var3_9:InitSlotHandPlantByAbility(var0_9)
		getProxy(IslandProxy):GetIsland():DispatchEvent(IslandBuildingAgency.SLOT_HANDPLABT_SLOT_UNIT_CHANGE, {
			build_id = var2_9,
			slotId = var0_9
		})
	elseif var1_9.type == 9 or var1_9.type == 3 then
		var3_9:InitSlotRoleDataByAbility(var0_9)
	end
end

function var0_0.InitBuildData(arg0_10, arg1_10)
	if arg0_10.buildings[arg1_10.id] then
		warning("产地已经解锁过了,下发的产地id是" .. arg1_10.id)

		return
	end

	local var0_10 = IslandBuilding.New(arg1_10, true)

	arg0_10.buildings[arg1_10.id] = var0_10

	for iter0_10, iter1_10 in ipairs(arg1_10.collect_list or {}) do
		var0_10:GetCollectSlotData(iter1_10.id):SetNeedLoadModel()
	end

	for iter2_10, iter3_10 in ipairs(arg1_10.hand_list or {}) do
		getProxy(IslandProxy):GetIsland():DispatchEvent(IslandBuildingAgency.SLOT_HANDPLABT_SLOT_UNIT_CHANGE, {
			build_id = arg1_10.id,
			slotId = iter3_10.id
		})
	end

	for iter4_10, iter5_10 in ipairs(arg1_10.appoint_list or {}) do
		local var1_10 = {}

		for iter6_10, iter7_10 in ipairs(iter5_10.part_list) do
			table.insert(var1_10, iter7_10)
		end

		if #var1_10 > 0 then
			getProxy(IslandProxy):GetIsland():DispatchEvent(IslandBuildingAgency.GEN_ANIMAL_INT, {
				aniList = var1_10,
				slotId = iter5_10.id
			})
		end
	end
end

function var0_0.InitBuildAnimalDataByAbility(arg0_11, arg1_11)
	local var0_11 = pg.island_ranch_animal[arg1_11].slot_id
	local var1_11 = pg.island_production_slot[var0_11].place
	local var2_11 = arg0_11.buildings[var1_11]

	if not var2_11 then
		return
	end

	local var3_11 = var2_11:GetDelegationSlotData(var0_11)

	if not var3_11 then
		return
	end

	var3_11:AddAnimal(arg1_11)
	getProxy(IslandProxy):GetIsland():DispatchEvent(IslandBuildingAgency.GEN_ANIMAL_INT, {
		aniList = {
			arg1_11
		},
		slotId = var0_11
	})
end

function var0_0.InitHandSlotData(arg0_12, arg1_12)
	local var0_12 = arg1_12.id
	local var1_12 = pg.island_production_slot[var0_12].place
	local var2_12 = arg0_12:GetBuilding(var1_12)

	if not var2_12 then
		warning("需要先解锁产地,再解锁产地上的槽位")

		return
	end

	var2_12:InitHandSlotData(arg1_12)
end

function var0_0.GetMinimumDelegationCompletionTimeByMapId(arg0_13, arg1_13)
	local var0_13 = pg.island_production_place.get_id_list_by_map_id[arg1_13] or {}
	local var1_13

	for iter0_13, iter1_13 in ipairs(var0_13) do
		local var2_13 = arg0_13.buildings[iter1_13]

		if var2_13 then
			local var3_13 = var2_13:GetMinRoleDeleGationTime()

			if var3_13 ~= -1 then
				var1_13 = var1_13 and math.min(var3_13, var1_13) or var3_13
			end
		end
	end

	return var1_13 and var1_13 or -1
end

function var0_0.GetDelegationSlotDataByTechId(arg0_14, arg1_14)
	local var0_14 = arg0_14.buildings[IslandTechnologyAgency.PLACE_ID]

	if not var0_14 then
		return
	end

	local var1_14 = pg.island_technology_template[arg1_14].formula_id

	return var0_14:GetDelegationSlotDataByFormulaId(var1_14)
end

function var0_0.GetBuildingListByMap(arg0_15, arg1_15)
	local var0_15 = pg.island_production_place.get_id_list_by_map_id[arg1_15] or {}
	local var1_15 = {}

	for iter0_15, iter1_15 in ipairs(var0_15) do
		local var2_15 = arg0_15.buildings[iter1_15]

		table.insert(var1_15, var2_15)
	end

	return var1_15
end

function var0_0.OnSeasonReset(arg0_16)
	return
end

function var0_0.GetFormulaNums(arg0_17)
	return arg0_17.formulaNums
end

function var0_0.AddFormulaNum(arg0_18, arg1_18, arg2_18)
	if pg.island_formula[arg1_18].is_condition ~= 1 then
		return
	end

	if arg0_18.formulaNums[arg1_18] then
		arg0_18.formulaNums[arg1_18] = arg0_18.formulaNums[arg1_18] + arg2_18
	else
		arg0_18.formulaNums[arg1_18] = arg2_18
	end
end

return var0_0
