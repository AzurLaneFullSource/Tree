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
	arg0_1.tradeAgency = IslandTradegency.New(arg0_1, arg1_1)
	arg0_1.agoraAgency = IslandAgoraAgency.New(arg0_1, arg1_1)
	arg0_1.manageAgency = IslandManageAgecny.New(arg0_1, arg1_1)
	arg0_1.cheaterTavernAgency = IslandCheaterTavernAgency.New(arg0_1)
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

function var0_0.GetTradeAgency(arg0_2)
	return arg0_2.tradeAgency
end

function var0_0.GetActivityNpcAgency(arg0_3)
	return arg0_3.activityNpcAgency
end

function var0_0.GetFollowerAgency(arg0_4)
	return arg0_4.followerAgency
end

function var0_0.GetAccessAgency(arg0_5)
	return arg0_5.accessAgency
end

function var0_0.IsPrivate(arg0_6)
	return false
end

function var0_0.GetVisitorAgency(arg0_7)
	return arg0_7.visitorAgency
end

function var0_0.GetAgoraAgency(arg0_8)
	return arg0_8.agoraAgency
end

function var0_0.GetCharacterAgency(arg0_9)
	return arg0_9.characterAgency
end

function var0_0.GetTechnologyAgency(arg0_10)
	return arg0_10.technologyAgency
end

function var0_0.GetAblityAgency(arg0_11)
	return arg0_11.ablityAgency
end

function var0_0.GetSignInAgency(arg0_12)
	return arg0_12.signInAgency
end

function var0_0.GetTaskAgency(arg0_13)
	return arg0_13.taskAgency
end

function var0_0.GetCheaterTavernAgency(arg0_14)
	return arg0_14.cheaterTavernAgency
end

function var0_0.GetManageAgency(arg0_15)
	return arg0_15.manageAgency
end

function var0_0.GetWildCollectAgency(arg0_16)
	return arg0_16.gatherCollectAgency
end

function var0_0.GetBuildingAgency(arg0_17)
	return arg0_17.buildingAgency
end

function var0_0.SetSpawnPointId(arg0_18, arg1_18)
	arg0_18.spawnPointId = arg1_18
end

function var0_0.GetSpawnPointId(arg0_19)
	local var0_19 = arg0_19.spawnPointId

	arg0_19.spawnPointId = nil

	return var0_19
end

function var0_0.SetLastExitPosition(arg0_20, arg1_20, arg2_20, arg3_20)
	if arg1_20 <= 0 then
		return
	end

	arg0_20.lastExitPosition = {
		mapId = arg1_20,
		position = arg2_20,
		rotation = arg3_20
	}
end

function var0_0.GetLastExitPosition(arg0_21)
	return arg0_21.lastExitPosition
end

function var0_0.GetMapId(arg0_22)
	return arg0_22.mapID
end

function var0_0.SetMapId(arg0_23, arg1_23)
	local var0_23 = pg.island_map[arg1_23]

	if not var0_23 then
		return
	end

	if not pg.TimeMgr.GetInstance():inTime(var0_23.time) then
		return
	end

	arg0_23.mapID = arg1_23
end

function var0_0.GetUnlockBuildingList(arg0_24)
	if arg0_24:IsMaxLevel() then
		return {}
	end

	return pg.island_level[arg0_24.level].island_level_award
end

function var0_0.IsNew(arg0_25)
	return arg0_25.name == ""
end

function var0_0.CanModifyName(arg0_26)
	return true
end

function var0_0.SetName(arg0_27, arg1_27)
	arg0_27.name = arg1_27
end

function var0_0.GetName(arg0_28)
	if arg0_28.name == "" then
		local var0_28 = getProxy(PlayerProxy):getRawData().name

		return i18n("island_default_name", var0_28)
	else
		return arg0_28.name
	end
end

function var0_0.SetManifesto(arg0_29, arg1_29)
	arg0_29.manifesto = arg1_29
end

function var0_0.GetManifesto(arg0_30)
	return arg0_30.manifesto
end

function var0_0.AddExp(arg0_31, arg1_31)
	if arg0_31:IsMaxLevel() then
		return
	end

	arg0_31.exp = arg0_31.exp + arg1_31
end

function var0_0.Upgrade(arg0_32)
	if arg0_32:IsMaxLevel() then
		return
	end

	if arg0_32:CanLevelUp() then
		arg0_32.exp = arg0_32:IsMaxLevel() and 0 or arg0_32.exp - arg0_32:GetTargeExp()

		arg0_32:LevelUp()
	end
end

function var0_0.LevelUp(arg0_33)
	arg0_33.level = arg0_33.level + 1
	arg0_33.configId = arg0_33.level
end

function var0_0.GetTargeExp(arg0_34)
	local var0_34 = pg.island_level[arg0_34.level]

	assert(var0_34)

	return var0_34.island_exp
end

function var0_0.CanLevelUp(arg0_35)
	if arg0_35:IsMaxLevel() then
		return false
	end

	return arg0_35:GetTargeExp() <= arg0_35.exp
end

function var0_0.IsMaxLevel(arg0_36)
	local var0_36 = #pg.island_level.all

	return pg.island_level.all[var0_36] <= arg0_36.level
end

function var0_0.StaticIsMaxLevel(arg0_37, arg1_37)
	local var0_37 = #pg.island_level.all

	return arg1_37 >= pg.island_level.all[var0_37]
end

function var0_0.GetLevel(arg0_38)
	return arg0_38.level
end

function var0_0.GetExp(arg0_39)
	return arg0_39.exp
end

function var0_0.GetUpgradeAwardsByLevel(arg0_40, arg1_40)
	if arg0_40:StaticIsMaxLevel(arg1_40) then
		return {}
	end

	local var0_40 = pg.island_level[arg1_40]

	assert(var0_40)

	local var1_40 = {}

	for iter0_40, iter1_40 in ipairs(var0_40.island_level_award) do
		table.insert(var1_40, {
			DROP_TYPE_ISLAND_ITEM,
			iter1_40[1],
			iter1_40[2]
		})
	end

	return var1_40
end

function var0_0.GetUpgradeAwards(arg0_41)
	return (arg0_41:GetUpgradeAwardsByLevel(arg0_41.level))
end

function var0_0.AddProsperity(arg0_42, arg1_42)
	if not arg0_42:CanAddProsperity() then
		return
	end

	arg0_42.prosperity = arg0_42.prosperity + arg1_42
end

function var0_0.CanAddProsperity(arg0_43)
	local var0_43 = arg0_43:GetMaxProsperityLevel()

	return pg.island_prosperity[var0_43].prosperity > arg0_43.prosperity
end

function var0_0.GetProsperity(arg0_44)
	return arg0_44.prosperity
end

function var0_0.GetMaxProsperityLevel(arg0_45)
	local var0_45 = pg.island_prosperity.all

	return var0_45[#var0_45]
end

function var0_0.GetTargetProsperityByLevel(arg0_46, arg1_46)
	assert(pg.island_prosperity[arg1_46])

	return pg.island_prosperity[arg1_46].prosperity
end

function var0_0.GetTargetProsperity(arg0_47)
	local var0_47 = 0
	local var1_47 = arg0_47:GetProsperity()

	for iter0_47, iter1_47 in ipairs(pg.island_prosperity.all) do
		local var2_47 = arg0_47:GetTargetProsperityByLevel(iter1_47)

		if var1_47 < var2_47 then
			return var2_47
		end
	end

	return var0_47
end

function var0_0.GetProsperityLevel(arg0_48)
	local var0_48 = arg0_48:GetProsperity()

	for iter0_48, iter1_48 in ipairs(pg.island_prosperity.all) do
		if var0_48 < arg0_48:GetTargetProsperityByLevel(iter1_48) then
			return iter1_48
		end
	end

	return arg0_48:GetMaxProsperityLevel()
end

function var0_0.CanGetProsperityAwards(arg0_49, arg1_49)
	if arg0_49:IsReceiveProsperityAwards(arg1_49) then
		return false
	end

	local var0_49 = pg.island_prosperity[arg1_49]

	if not var0_49 then
		return false
	end

	return var0_49.prosperity <= arg0_49:GetProsperity()
end

function var0_0.AnyProsperityAwardCanGet(arg0_50)
	for iter0_50, iter1_50 in ipairs(pg.island_prosperity.all) do
		if arg0_50:CanGetProsperityAwards(iter1_50) then
			return true
		end
	end

	return false
end

function var0_0.IsReceiveProsperityAwards(arg0_51, arg1_51)
	return arg0_51.prosperityList[arg1_51] == true
end

function var0_0.ReceiveProsperityAwards(arg0_52, arg1_52)
	arg0_52.prosperityList[arg1_52] = true
end

function var0_0.GetProsperityAward(arg0_53, arg1_53)
	return pg.island_prosperity[arg1_53].award_display
end

function var0_0.getConfig(arg0_54, arg1_54)
	return pg.island_level[arg0_54.configId][arg1_54]
end

function var0_0.UpdatePerDay(arg0_55)
	arg0_55:GetSignInAgency():ResetSignInCnt()
	arg0_55:GetAccessAgency():ResetFreshInviteCodeFlag()
	arg0_55:GetCharacterAgency():ResetShipSkillUsed()
end

function var0_0.UpdatePerSecond(arg0_56)
	if arg0_56.buildingAgency then
		arg0_56.buildingAgency:UpdatePerSecond()
	end
end

function var0_0.UpdatePerHour(arg0_57, arg1_57)
	arg0_57:GetTradeAgency():UpdatePerHour(arg1_57)
end

return var0_0
