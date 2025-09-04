local var0_0 = class("BaseIsland", import("Mod.Island.IslandDispatcher"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.id = arg1_1.id
	arg0_1.level = arg1_1.level or 1
	arg0_1.configId = arg0_1.level
	arg0_1.exp = arg1_1.exp or 0
	arg0_1.name = arg1_1.name or "1"
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
	arg0_1.signInAgency = IslandSignInAgency.New(arg0_1, arg1_1)
	arg0_1.taskAgency = IslandTaskAgency.New(arg0_1, arg1_1)
	arg0_1.accessAgency = IslandAccessAgency.New(arg0_1, arg1_1)
	arg0_1.gatherCollectAgency = IslandGatherCollectAgency.New(arg0_1)
	arg0_1.buildingAgency = IslandBuildingAgency.New(arg0_1, arg1_1)
	arg0_1.agoraAgency = IslandAgoraAgency.New(arg0_1, arg1_1)
	arg0_1.manageAgency = IslandManageAgecny.New(arg0_1, arg1_1)
	arg0_1.mapID = pg.island_set.initial_scene.key_value_int
	arg0_1.lastExitPosition = {
		mapId = 0,
		position = Vector3.zero,
		rotation = Vector3.zero
	}

	if not arg0_1.taskAgency:IsFinishTask(IslandGuideChecker.MOVE_TASK_ID) then
		arg0_1:SetSpawnPointId(pg.island_set.initial_spawn_point.key_value_int)
	end
end

function var0_0.GetAccessAgency(arg0_2)
	return arg0_2.accessAgency
end

function var0_0.IsPrivate(arg0_3)
	return false
end

function var0_0.GetVisitorAgency(arg0_4)
	return arg0_4.visitorAgency
end

function var0_0.GetAgoraAgency(arg0_5)
	return arg0_5.agoraAgency
end

function var0_0.GetCharacterAgency(arg0_6)
	return arg0_6.characterAgency
end

function var0_0.GetTechnologyAgency(arg0_7)
	return arg0_7.technologyAgency
end

function var0_0.GetAblityAgency(arg0_8)
	return arg0_8.ablityAgency
end

function var0_0.GetSignInAgency(arg0_9)
	return arg0_9.signInAgency
end

function var0_0.GetTaskAgency(arg0_10)
	return arg0_10.taskAgency
end

function var0_0.GetManageAgency(arg0_11)
	return arg0_11.manageAgency
end

function var0_0.GetWildCollectAgency(arg0_12)
	return arg0_12.gatherCollectAgency
end

function var0_0.GetBuildingAgency(arg0_13)
	return arg0_13.buildingAgency
end

function var0_0.SetSpawnPointId(arg0_14, arg1_14)
	arg0_14.spawnPointId = arg1_14
end

function var0_0.GetSpawnPointId(arg0_15)
	local var0_15 = arg0_15.spawnPointId

	arg0_15.spawnPointId = nil

	return var0_15
end

function var0_0.SetLastExitPosition(arg0_16, arg1_16, arg2_16, arg3_16)
	if arg1_16 <= 0 then
		return
	end

	arg0_16.lastExitPosition = {
		mapId = arg1_16,
		position = arg2_16,
		rotation = arg3_16
	}
end

function var0_0.GetLastExitPosition(arg0_17)
	return arg0_17.lastExitPosition
end

function var0_0.GetMapId(arg0_18)
	return arg0_18.mapID
end

function var0_0.SetMapId(arg0_19, arg1_19)
	local var0_19 = pg.island_map[arg1_19]

	if not var0_19 then
		return
	end

	if not pg.TimeMgr.GetInstance():inTime(var0_19.time) then
		return
	end

	arg0_19.mapID = arg1_19
end

function var0_0.GetUnlockBuildingList(arg0_20)
	if arg0_20:IsMaxLevel() then
		return {}
	end

	return pg.island_level[arg0_20.level].island_level_award
end

function var0_0.IsNew(arg0_21)
	return arg0_21.name == ""
end

function var0_0.CanModifyName(arg0_22)
	return true
end

function var0_0.SetName(arg0_23, arg1_23)
	arg0_23.name = arg1_23
end

function var0_0.GetName(arg0_24)
	if arg0_24.name == "" then
		local var0_24 = getProxy(PlayerProxy):getRawData().name

		return i18n("island_default_name", var0_24)
	else
		return arg0_24.name
	end
end

function var0_0.SetManifesto(arg0_25, arg1_25)
	arg0_25.manifesto = arg1_25
end

function var0_0.GetManifesto(arg0_26)
	return arg0_26.manifesto
end

function var0_0.GetModifyNameConsume(arg0_27)
	return {
		DROP_TYPE_RESOURCE,
		1,
		1
	}
end

function var0_0.AddExp(arg0_28, arg1_28)
	if arg0_28:IsMaxLevel() then
		return
	end

	arg0_28.exp = arg0_28.exp + arg1_28
end

function var0_0.Upgrade(arg0_29)
	if arg0_29:IsMaxLevel() then
		return
	end

	if arg0_29:CanLevelUp() then
		arg0_29.exp = arg0_29:IsMaxLevel() and 0 or arg0_29.exp - arg0_29:GetTargeExp()

		arg0_29:LevelUp()
	end
end

function var0_0.LevelUp(arg0_30)
	arg0_30.level = arg0_30.level + 1
	arg0_30.configId = arg0_30.level
end

function var0_0.GetTargeExp(arg0_31)
	local var0_31 = pg.island_level[arg0_31.level]

	assert(var0_31)

	return var0_31.island_exp
end

function var0_0.CanLevelUp(arg0_32)
	if arg0_32:IsMaxLevel() then
		return false
	end

	return arg0_32:GetTargeExp() <= arg0_32.exp
end

function var0_0.IsMaxLevel(arg0_33)
	local var0_33 = #pg.island_level.all

	return pg.island_level.all[var0_33] <= arg0_33.level
end

function var0_0.StaticIsMaxLevel(arg0_34, arg1_34)
	local var0_34 = #pg.island_level.all

	return arg1_34 >= pg.island_level.all[var0_34]
end

function var0_0.GetLevel(arg0_35)
	return arg0_35.level
end

function var0_0.GetExp(arg0_36)
	return arg0_36.exp
end

function var0_0.GetUpgradeAwardsByLevel(arg0_37, arg1_37)
	if arg0_37:StaticIsMaxLevel(arg1_37) then
		return {}
	end

	local var0_37 = pg.island_level[arg1_37]

	assert(var0_37)

	local var1_37 = {}

	for iter0_37, iter1_37 in ipairs(var0_37.island_level_award) do
		table.insert(var1_37, {
			DROP_TYPE_ISLAND_ITEM,
			iter1_37[1],
			iter1_37[2]
		})
	end

	return var1_37
end

function var0_0.GetUpgradeAwards(arg0_38)
	return (arg0_38:GetUpgradeAwardsByLevel(arg0_38.level))
end

function var0_0.AddProsperity(arg0_39, arg1_39)
	if not arg0_39:CanAddProsperity() then
		return
	end

	arg0_39.prosperity = arg0_39.prosperity + arg1_39
end

function var0_0.CanAddProsperity(arg0_40)
	local var0_40 = arg0_40:GetMaxProsperityLevel()

	return pg.island_prosperity[var0_40].prosperity > arg0_40.prosperity
end

function var0_0.GetProsperity(arg0_41)
	return arg0_41.prosperity
end

function var0_0.GetMaxProsperityLevel(arg0_42)
	local var0_42 = pg.island_prosperity.all

	return var0_42[#var0_42]
end

function var0_0.GetTargetProsperityByLevel(arg0_43, arg1_43)
	assert(pg.island_prosperity[arg1_43])

	return pg.island_prosperity[arg1_43].prosperity
end

function var0_0.GetTargetProsperity(arg0_44)
	local var0_44 = 0
	local var1_44 = arg0_44:GetProsperity()

	for iter0_44, iter1_44 in ipairs(pg.island_prosperity.all) do
		local var2_44 = arg0_44:GetTargetProsperityByLevel(iter1_44)

		if var1_44 < var2_44 then
			return var2_44
		end
	end

	return var0_44
end

function var0_0.GetProsperityLevel(arg0_45)
	local var0_45 = arg0_45:GetProsperity()

	for iter0_45, iter1_45 in ipairs(pg.island_prosperity.all) do
		if var0_45 < arg0_45:GetTargetProsperityByLevel(iter1_45) then
			return iter1_45
		end
	end

	return arg0_45:GetMaxProsperityLevel()
end

function var0_0.CanGetProsperityAwards(arg0_46, arg1_46)
	if arg0_46:IsReceiveProsperityAwards(arg1_46) then
		return false
	end

	local var0_46 = pg.island_prosperity[arg1_46]

	if not var0_46 then
		return false
	end

	return var0_46.prosperity <= arg0_46:GetProsperity()
end

function var0_0.AnyProsperityAwardCanGet(arg0_47)
	for iter0_47, iter1_47 in ipairs(pg.island_prosperity.all) do
		if arg0_47:CanGetProsperityAwards(iter1_47) then
			return true
		end
	end

	return false
end

function var0_0.IsReceiveProsperityAwards(arg0_48, arg1_48)
	return arg0_48.prosperityList[arg1_48] == true
end

function var0_0.ReceiveProsperityAwards(arg0_49, arg1_49)
	arg0_49.prosperityList[arg1_49] = true
end

function var0_0.GetProsperityAward(arg0_50, arg1_50)
	return pg.island_prosperity[arg1_50].award_display
end

function var0_0.getConfig(arg0_51, arg1_51)
	return pg.island_level[arg0_51.configId][arg1_51]
end

function var0_0.UpdatePerDay(arg0_52)
	arg0_52:GetSignInAgency():ResetSignInCnt()
	arg0_52:GetAccessAgency():ResetFreshInviteCodeFlag()
end

function var0_0.UpdatePerSecond(arg0_53)
	if arg0_53.buildingAgency then
		arg0_53.buildingAgency:UpdatePerSecond()
	end
end

return var0_0
