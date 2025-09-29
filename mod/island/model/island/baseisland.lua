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
	arg0_1.gatherCollectAgency = IslandGatherCollectAgency.New(arg0_1, arg1_1)
	arg0_1.buildingAgency = IslandBuildingAgency.New(arg0_1, arg1_1)
	arg0_1.followerAgency = IslandFollowerAgency.New(arg0_1)
	arg0_1.activityNpcAgency = IslandActivityNpcAgency.New(arg0_1)
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

function var0_0.GetActivityNpcAgency(arg0_2)
	return arg0_2.activityNpcAgency
end

function var0_0.GetFollowerAgency(arg0_3)
	return arg0_3.followerAgency
end

function var0_0.GetAccessAgency(arg0_4)
	return arg0_4.accessAgency
end

function var0_0.IsPrivate(arg0_5)
	return false
end

function var0_0.GetVisitorAgency(arg0_6)
	return arg0_6.visitorAgency
end

function var0_0.GetAgoraAgency(arg0_7)
	return arg0_7.agoraAgency
end

function var0_0.GetCharacterAgency(arg0_8)
	return arg0_8.characterAgency
end

function var0_0.GetTechnologyAgency(arg0_9)
	return arg0_9.technologyAgency
end

function var0_0.GetAblityAgency(arg0_10)
	return arg0_10.ablityAgency
end

function var0_0.GetSignInAgency(arg0_11)
	return arg0_11.signInAgency
end

function var0_0.GetTaskAgency(arg0_12)
	return arg0_12.taskAgency
end

function var0_0.GetManageAgency(arg0_13)
	return arg0_13.manageAgency
end

function var0_0.GetWildCollectAgency(arg0_14)
	return arg0_14.gatherCollectAgency
end

function var0_0.GetBuildingAgency(arg0_15)
	return arg0_15.buildingAgency
end

function var0_0.SetSpawnPointId(arg0_16, arg1_16)
	arg0_16.spawnPointId = arg1_16
end

function var0_0.GetSpawnPointId(arg0_17)
	local var0_17 = arg0_17.spawnPointId

	arg0_17.spawnPointId = nil

	return var0_17
end

function var0_0.SetLastExitPosition(arg0_18, arg1_18, arg2_18, arg3_18)
	if arg1_18 <= 0 then
		return
	end

	arg0_18.lastExitPosition = {
		mapId = arg1_18,
		position = arg2_18,
		rotation = arg3_18
	}
end

function var0_0.GetLastExitPosition(arg0_19)
	return arg0_19.lastExitPosition
end

function var0_0.GetMapId(arg0_20)
	return arg0_20.mapID
end

function var0_0.SetMapId(arg0_21, arg1_21)
	local var0_21 = pg.island_map[arg1_21]

	if not var0_21 then
		return
	end

	if not pg.TimeMgr.GetInstance():inTime(var0_21.time) then
		return
	end

	arg0_21.mapID = arg1_21
end

function var0_0.GetUnlockBuildingList(arg0_22)
	if arg0_22:IsMaxLevel() then
		return {}
	end

	return pg.island_level[arg0_22.level].island_level_award
end

function var0_0.IsNew(arg0_23)
	return arg0_23.name == ""
end

function var0_0.CanModifyName(arg0_24)
	return true
end

function var0_0.SetName(arg0_25, arg1_25)
	arg0_25.name = arg1_25
end

function var0_0.GetName(arg0_26)
	if arg0_26.name == "" then
		local var0_26 = getProxy(PlayerProxy):getRawData().name

		return i18n("island_default_name", var0_26)
	else
		return arg0_26.name
	end
end

function var0_0.SetManifesto(arg0_27, arg1_27)
	arg0_27.manifesto = arg1_27
end

function var0_0.GetManifesto(arg0_28)
	return arg0_28.manifesto
end

function var0_0.AddExp(arg0_29, arg1_29)
	if arg0_29:IsMaxLevel() then
		return
	end

	arg0_29.exp = arg0_29.exp + arg1_29
end

function var0_0.Upgrade(arg0_30)
	if arg0_30:IsMaxLevel() then
		return
	end

	if arg0_30:CanLevelUp() then
		arg0_30.exp = arg0_30:IsMaxLevel() and 0 or arg0_30.exp - arg0_30:GetTargeExp()

		arg0_30:LevelUp()
	end
end

function var0_0.LevelUp(arg0_31)
	arg0_31.level = arg0_31.level + 1
	arg0_31.configId = arg0_31.level
end

function var0_0.GetTargeExp(arg0_32)
	local var0_32 = pg.island_level[arg0_32.level]

	assert(var0_32)

	return var0_32.island_exp
end

function var0_0.CanLevelUp(arg0_33)
	if arg0_33:IsMaxLevel() then
		return false
	end

	return arg0_33:GetTargeExp() <= arg0_33.exp
end

function var0_0.IsMaxLevel(arg0_34)
	local var0_34 = #pg.island_level.all

	return pg.island_level.all[var0_34] <= arg0_34.level
end

function var0_0.StaticIsMaxLevel(arg0_35, arg1_35)
	local var0_35 = #pg.island_level.all

	return arg1_35 >= pg.island_level.all[var0_35]
end

function var0_0.GetLevel(arg0_36)
	return arg0_36.level
end

function var0_0.GetExp(arg0_37)
	return arg0_37.exp
end

function var0_0.GetUpgradeAwardsByLevel(arg0_38, arg1_38)
	if arg0_38:StaticIsMaxLevel(arg1_38) then
		return {}
	end

	local var0_38 = pg.island_level[arg1_38]

	assert(var0_38)

	local var1_38 = {}

	for iter0_38, iter1_38 in ipairs(var0_38.island_level_award) do
		table.insert(var1_38, {
			DROP_TYPE_ISLAND_ITEM,
			iter1_38[1],
			iter1_38[2]
		})
	end

	return var1_38
end

function var0_0.GetUpgradeAwards(arg0_39)
	return (arg0_39:GetUpgradeAwardsByLevel(arg0_39.level))
end

function var0_0.AddProsperity(arg0_40, arg1_40)
	if not arg0_40:CanAddProsperity() then
		return
	end

	arg0_40.prosperity = arg0_40.prosperity + arg1_40
end

function var0_0.CanAddProsperity(arg0_41)
	local var0_41 = arg0_41:GetMaxProsperityLevel()

	return pg.island_prosperity[var0_41].prosperity > arg0_41.prosperity
end

function var0_0.GetProsperity(arg0_42)
	return arg0_42.prosperity
end

function var0_0.GetMaxProsperityLevel(arg0_43)
	local var0_43 = pg.island_prosperity.all

	return var0_43[#var0_43]
end

function var0_0.GetTargetProsperityByLevel(arg0_44, arg1_44)
	assert(pg.island_prosperity[arg1_44])

	return pg.island_prosperity[arg1_44].prosperity
end

function var0_0.GetTargetProsperity(arg0_45)
	local var0_45 = 0
	local var1_45 = arg0_45:GetProsperity()

	for iter0_45, iter1_45 in ipairs(pg.island_prosperity.all) do
		local var2_45 = arg0_45:GetTargetProsperityByLevel(iter1_45)

		if var1_45 < var2_45 then
			return var2_45
		end
	end

	return var0_45
end

function var0_0.GetProsperityLevel(arg0_46)
	local var0_46 = arg0_46:GetProsperity()

	for iter0_46, iter1_46 in ipairs(pg.island_prosperity.all) do
		if var0_46 < arg0_46:GetTargetProsperityByLevel(iter1_46) then
			return iter1_46
		end
	end

	return arg0_46:GetMaxProsperityLevel()
end

function var0_0.CanGetProsperityAwards(arg0_47, arg1_47)
	if arg0_47:IsReceiveProsperityAwards(arg1_47) then
		return false
	end

	local var0_47 = pg.island_prosperity[arg1_47]

	if not var0_47 then
		return false
	end

	return var0_47.prosperity <= arg0_47:GetProsperity()
end

function var0_0.AnyProsperityAwardCanGet(arg0_48)
	for iter0_48, iter1_48 in ipairs(pg.island_prosperity.all) do
		if arg0_48:CanGetProsperityAwards(iter1_48) then
			return true
		end
	end

	return false
end

function var0_0.IsReceiveProsperityAwards(arg0_49, arg1_49)
	return arg0_49.prosperityList[arg1_49] == true
end

function var0_0.ReceiveProsperityAwards(arg0_50, arg1_50)
	arg0_50.prosperityList[arg1_50] = true
end

function var0_0.GetProsperityAward(arg0_51, arg1_51)
	return pg.island_prosperity[arg1_51].award_display
end

function var0_0.getConfig(arg0_52, arg1_52)
	return pg.island_level[arg0_52.configId][arg1_52]
end

function var0_0.UpdatePerDay(arg0_53)
	arg0_53:GetSignInAgency():ResetSignInCnt()
	arg0_53:GetAccessAgency():ResetFreshInviteCodeFlag()
end

function var0_0.UpdatePerSecond(arg0_54)
	if arg0_54.buildingAgency then
		arg0_54.buildingAgency:UpdatePerSecond()
	end
end

return var0_0
