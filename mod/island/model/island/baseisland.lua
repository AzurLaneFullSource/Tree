local var0_0 = class("BaseIsland", import("Mod.Island.IslandDispatcher"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.id = arg1_1.id
	arg0_1.level = arg1_1.level or 1
	arg0_1.configId = arg0_1.level
	arg0_1.exp = arg1_1.exp or 0
	arg0_1.name = arg1_1.name or i18n1("布之岛")
	arg0_1.prosperity = arg1_1.prosperity or 0
	arg0_1.manifesto = arg1_1.signature or ""
	arg0_1.prosperityList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.prosperity_rewarded or {}) do
		arg0_1.prosperityList[iter1_1] = true
	end

	arg0_1.ablityAgency = IslandAblityAgency.New(arg0_1, arg1_1)
	arg0_1.characterAgency = IslandCharacterAgency.New(arg0_1, arg1_1)
	arg0_1.visitorAgency = IslandVisitorAgency.New(arg0_1, arg1_1)
	arg0_1.technologyAgency = IslandTechnologyAgency.New(arg0_1, arg1_1)

	local var0_1 = {}

	for iter2_1, iter3_1 in ipairs(pg.island_furniture_template.all) do
		table.insert(var0_1, {
			count = 1,
			id = iter3_1
		})
	end

	local var1_1 = {
		level = arg1_1.agora_level,
		furniture_list = {},
		placed_list = arg1_1.placed_list or {}
	}

	arg0_1.agoraAgency = IslandAgoraAgency.New(arg0_1, {
		agora = var1_1
	})
	arg0_1.mapID = pg.island_set.initial_scene.key_value_int
	arg0_1.spawnPointId = nil
end

function var0_0.IsPrivate(arg0_2)
	return false
end

function var0_0.GetVisitorAgency(arg0_3)
	return arg0_3.visitorAgency
end

function var0_0.GetAgoraAgency(arg0_4)
	return arg0_4.agoraAgency
end

function var0_0.GetCharacterAgency(arg0_5)
	return arg0_5.characterAgency
end

function var0_0.GetTechnologyAgency(arg0_6)
	return arg0_6.technologyAgency
end

function var0_0.GetAblityAgency(arg0_7)
	return arg0_7.ablityAgency
end

function var0_0.SetSpawnPointId(arg0_8, arg1_8)
	arg0_8.spawnPointId = arg1_8
end

function var0_0.GetSpawnPointId(arg0_9)
	local var0_9 = arg0_9.spawnPointId

	arg0_9.spawnPointId = nil

	return var0_9
end

function var0_0.GetMapId(arg0_10)
	return arg0_10.mapID
end

function var0_0.SetMapId(arg0_11, arg1_11)
	arg0_11.mapID = arg1_11
end

function var0_0.getConfig(arg0_12, arg1_12)
	return pg.island_level[arg0_12.configId][arg1_12]
end

function var0_0.GetUnlockBuildingList(arg0_13)
	if arg0_13:IsMaxLevel() then
		return {}
	end

	return pg.island_level[arg0_13.level].island_level_unlock
end

function var0_0.IsNew(arg0_14)
	return arg0_14.name == ""
end

function var0_0.CanModifyName(arg0_15)
	return true
end

function var0_0.SetName(arg0_16, arg1_16)
	arg0_16.name = arg1_16
end

function var0_0.GetName(arg0_17)
	return arg0_17.name
end

function var0_0.SetManifesto(arg0_18, arg1_18)
	arg0_18.manifesto = arg1_18
end

function var0_0.GetManifesto(arg0_19)
	return arg0_19.manifesto
end

function var0_0.GetModifyNameConsume(arg0_20)
	return {
		DROP_TYPE_RESOURCE,
		1,
		1
	}
end

function var0_0.AddExp(arg0_21, arg1_21)
	if arg0_21:IsMaxLevel() then
		return
	end

	arg0_21.exp = arg0_21.exp + arg1_21
end

function var0_0.Upgrade(arg0_22)
	if arg0_22:IsMaxLevel() then
		return
	end

	if arg0_22:CanLevelUp() then
		arg0_22.exp = arg0_22:IsMaxLevel() and 0 or arg0_22.exp - arg0_22:GetTargeExp()

		arg0_22:LevelUp()
	end
end

function var0_0.LevelUp(arg0_23)
	arg0_23.level = arg0_23.level + 1
	arg0_23.configId = arg0_23.level
end

function var0_0.GetTargeExp(arg0_24)
	local var0_24 = pg.island_level[arg0_24.level]

	assert(var0_24)

	return var0_24.island_exp
end

function var0_0.CanLevelUp(arg0_25)
	if arg0_25:IsMaxLevel() then
		return false
	end

	return arg0_25:GetTargeExp() <= arg0_25.exp
end

function var0_0.IsMaxLevel(arg0_26)
	local var0_26 = #pg.island_level.all

	return pg.island_level.all[var0_26] <= arg0_26.level
end

function var0_0.StaticIsMaxLevel(arg0_27, arg1_27)
	local var0_27 = #pg.island_level.all

	return arg1_27 >= pg.island_level.all[var0_27]
end

function var0_0.GetLevel(arg0_28)
	return arg0_28.level
end

function var0_0.GetExp(arg0_29)
	return arg0_29.exp
end

function var0_0.GetUpgradeAwardsByLevel(arg0_30, arg1_30)
	if arg0_30:StaticIsMaxLevel(arg1_30) then
		return {}
	end

	local var0_30 = pg.island_level[arg1_30]

	assert(var0_30)

	local var1_30 = {}

	for iter0_30, iter1_30 in ipairs(var0_30.island_level_award) do
		table.insert(var1_30, {
			DROP_TYPE_ISLAND_ITEM,
			iter1_30[1],
			iter1_30[2]
		})
	end

	return var1_30
end

function var0_0.GetUpgradeAwards(arg0_31)
	return (arg0_31:GetUpgradeAwardsByLevel(arg0_31.level))
end

function var0_0.GetUpgradeConsume(arg0_32)
	if arg0_32:StaticIsMaxLevel(arg0_32.level) then
		return {}
	end

	local var0_32 = pg.island_level[arg0_32.level + 1]

	assert(var0_32)

	local var1_32 = {}

	for iter0_32, iter1_32 in ipairs(var0_32.cost) do
		table.insert(var1_32, {
			DROP_TYPE_ISLAND_ITEM,
			iter1_32[1],
			iter1_32[2]
		})
	end

	return var1_32
end

function var0_0.AddProsperity(arg0_33, arg1_33)
	if not arg0_33:CanAddProsperity() then
		return
	end

	arg0_33.prosperity = arg0_33.prosperity + arg1_33
end

function var0_0.CanAddProsperity(arg0_34)
	local var0_34 = arg0_34:GetMaxProsperityLevel()

	return pg.island_prosperity[var0_34].prosperity > arg0_34.prosperity
end

function var0_0.GetProsperity(arg0_35)
	return arg0_35.prosperity
end

function var0_0.GetMaxProsperityLevel(arg0_36)
	local var0_36 = pg.island_prosperity.all

	return var0_36[#var0_36]
end

function var0_0.GetTargetProsperityByLevel(arg0_37, arg1_37)
	assert(pg.island_prosperity[arg1_37])

	return pg.island_prosperity[arg1_37].prosperity
end

function var0_0.GetTargetProsperity(arg0_38)
	local var0_38 = 0
	local var1_38 = arg0_38:GetProsperity()

	for iter0_38, iter1_38 in ipairs(pg.island_prosperity.all) do
		local var2_38 = arg0_38:GetTargetProsperityByLevel(iter1_38)

		if var1_38 < var2_38 then
			return var2_38
		end
	end

	return var0_38
end

function var0_0.GetProsperityLevel(arg0_39)
	local var0_39 = arg0_39:GetProsperity()

	for iter0_39, iter1_39 in ipairs(pg.island_prosperity.all) do
		if var0_39 < arg0_39:GetTargetProsperityByLevel(iter1_39) then
			return iter1_39
		end
	end

	return arg0_39:GetMaxProsperityLevel()
end

function var0_0.CanGetProsperityAwards(arg0_40, arg1_40)
	if arg0_40:IsReceiveProsperityAwards(arg1_40) then
		return false
	end

	local var0_40 = pg.island_prosperity[arg1_40]

	if not var0_40 then
		return false
	end

	return var0_40.prosperity <= arg0_40:GetProsperity()
end

function var0_0.AnyProsperityAwardCanGet(arg0_41)
	for iter0_41, iter1_41 in ipairs(pg.island_prosperity.all) do
		if arg0_41:CanGetProsperityAwards(iter1_41) then
			return true
		end
	end

	return false
end

function var0_0.IsReceiveProsperityAwards(arg0_42, arg1_42)
	return arg0_42.prosperityList[arg1_42] == true
end

function var0_0.ReceiveProsperityAwards(arg0_43, arg1_43)
	arg0_43.prosperityList[arg1_43] = true
end

function var0_0.GetProsperityAward(arg0_44, arg1_44)
	return pg.island_prosperity[arg1_44].award_display
end

function var0_0.UpdatePerDay(arg0_45)
	return
end

function var0_0.UpdatePerSecond(arg0_46)
	return
end

return var0_0
