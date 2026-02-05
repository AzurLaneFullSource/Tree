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

function var0_0.GetManageAgency(arg0_14)
	return arg0_14.manageAgency
end

function var0_0.GetWildCollectAgency(arg0_15)
	return arg0_15.gatherCollectAgency
end

function var0_0.GetBuildingAgency(arg0_16)
	return arg0_16.buildingAgency
end

function var0_0.SetSpawnPointId(arg0_17, arg1_17)
	arg0_17.spawnPointId = arg1_17
end

function var0_0.GetSpawnPointId(arg0_18)
	local var0_18 = arg0_18.spawnPointId

	arg0_18.spawnPointId = nil

	return var0_18
end

function var0_0.SetLastExitPosition(arg0_19, arg1_19, arg2_19, arg3_19)
	if arg1_19 <= 0 then
		return
	end

	arg0_19.lastExitPosition = {
		mapId = arg1_19,
		position = arg2_19,
		rotation = arg3_19
	}
end

function var0_0.GetLastExitPosition(arg0_20)
	return arg0_20.lastExitPosition
end

function var0_0.GetMapId(arg0_21)
	return arg0_21.mapID
end

function var0_0.SetMapId(arg0_22, arg1_22)
	local var0_22 = pg.island_map[arg1_22]

	if not var0_22 then
		return
	end

	if not pg.TimeMgr.GetInstance():inTime(var0_22.time) then
		return
	end

	arg0_22.mapID = arg1_22
end

function var0_0.GetUnlockBuildingList(arg0_23)
	if arg0_23:IsMaxLevel() then
		return {}
	end

	return pg.island_level[arg0_23.level].island_level_award
end

function var0_0.IsNew(arg0_24)
	return arg0_24.name == ""
end

function var0_0.CanModifyName(arg0_25)
	return true
end

function var0_0.SetName(arg0_26, arg1_26)
	arg0_26.name = arg1_26
end

function var0_0.GetName(arg0_27)
	if arg0_27.name == "" then
		local var0_27 = getProxy(PlayerProxy):getRawData().name

		return i18n("island_default_name", var0_27)
	else
		return arg0_27.name
	end
end

function var0_0.SetManifesto(arg0_28, arg1_28)
	arg0_28.manifesto = arg1_28
end

function var0_0.GetManifesto(arg0_29)
	return arg0_29.manifesto
end

function var0_0.AddExp(arg0_30, arg1_30)
	if arg0_30:IsMaxLevel() then
		return
	end

	arg0_30.exp = arg0_30.exp + arg1_30
end

function var0_0.Upgrade(arg0_31)
	if arg0_31:IsMaxLevel() then
		return
	end

	if arg0_31:CanLevelUp() then
		arg0_31.exp = arg0_31:IsMaxLevel() and 0 or arg0_31.exp - arg0_31:GetTargeExp()

		arg0_31:LevelUp()
	end
end

function var0_0.LevelUp(arg0_32)
	arg0_32.level = arg0_32.level + 1
	arg0_32.configId = arg0_32.level
end

function var0_0.GetTargeExp(arg0_33)
	local var0_33 = pg.island_level[arg0_33.level]

	assert(var0_33)

	return var0_33.island_exp
end

function var0_0.CanLevelUp(arg0_34)
	if arg0_34:IsMaxLevel() then
		return false
	end

	return arg0_34:GetTargeExp() <= arg0_34.exp
end

function var0_0.IsMaxLevel(arg0_35)
	local var0_35 = #pg.island_level.all

	return pg.island_level.all[var0_35] <= arg0_35.level
end

function var0_0.StaticIsMaxLevel(arg0_36, arg1_36)
	local var0_36 = #pg.island_level.all

	return arg1_36 >= pg.island_level.all[var0_36]
end

function var0_0.GetLevel(arg0_37)
	return arg0_37.level
end

function var0_0.GetExp(arg0_38)
	return arg0_38.exp
end

function var0_0.GetUpgradeAwardsByLevel(arg0_39, arg1_39)
	if arg0_39:StaticIsMaxLevel(arg1_39) then
		return {}
	end

	local var0_39 = pg.island_level[arg1_39]

	assert(var0_39)

	local var1_39 = {}

	for iter0_39, iter1_39 in ipairs(var0_39.island_level_award) do
		table.insert(var1_39, {
			DROP_TYPE_ISLAND_ITEM,
			iter1_39[1],
			iter1_39[2]
		})
	end

	return var1_39
end

function var0_0.GetUpgradeAwards(arg0_40)
	return (arg0_40:GetUpgradeAwardsByLevel(arg0_40.level))
end

function var0_0.AddProsperity(arg0_41, arg1_41)
	if not arg0_41:CanAddProsperity() then
		return
	end

	arg0_41.prosperity = arg0_41.prosperity + arg1_41
end

function var0_0.CanAddProsperity(arg0_42)
	local var0_42 = arg0_42:GetMaxProsperityLevel()

	return pg.island_prosperity[var0_42].prosperity > arg0_42.prosperity
end

function var0_0.GetProsperity(arg0_43)
	return arg0_43.prosperity
end

function var0_0.GetMaxProsperityLevel(arg0_44)
	local var0_44 = pg.island_prosperity.all

	return var0_44[#var0_44]
end

function var0_0.GetTargetProsperityByLevel(arg0_45, arg1_45)
	assert(pg.island_prosperity[arg1_45])

	return pg.island_prosperity[arg1_45].prosperity
end

function var0_0.GetTargetProsperity(arg0_46)
	local var0_46 = 0
	local var1_46 = arg0_46:GetProsperity()

	for iter0_46, iter1_46 in ipairs(pg.island_prosperity.all) do
		local var2_46 = arg0_46:GetTargetProsperityByLevel(iter1_46)

		if var1_46 < var2_46 then
			return var2_46
		end
	end

	return var0_46
end

function var0_0.GetProsperityLevel(arg0_47)
	local var0_47 = arg0_47:GetProsperity()

	for iter0_47, iter1_47 in ipairs(pg.island_prosperity.all) do
		if var0_47 < arg0_47:GetTargetProsperityByLevel(iter1_47) then
			return iter1_47
		end
	end

	return arg0_47:GetMaxProsperityLevel()
end

function var0_0.CanGetProsperityAwards(arg0_48, arg1_48)
	if arg0_48:IsReceiveProsperityAwards(arg1_48) then
		return false
	end

	local var0_48 = pg.island_prosperity[arg1_48]

	if not var0_48 then
		return false
	end

	return var0_48.prosperity <= arg0_48:GetProsperity()
end

function var0_0.AnyProsperityAwardCanGet(arg0_49)
	for iter0_49, iter1_49 in ipairs(pg.island_prosperity.all) do
		if arg0_49:CanGetProsperityAwards(iter1_49) then
			return true
		end
	end

	return false
end

function var0_0.IsReceiveProsperityAwards(arg0_50, arg1_50)
	return arg0_50.prosperityList[arg1_50] == true
end

function var0_0.ReceiveProsperityAwards(arg0_51, arg1_51)
	arg0_51.prosperityList[arg1_51] = true
end

function var0_0.GetProsperityAward(arg0_52, arg1_52)
	return pg.island_prosperity[arg1_52].award_display
end

function var0_0.getConfig(arg0_53, arg1_53)
	return pg.island_level[arg0_53.configId][arg1_53]
end

function var0_0.UpdatePerDay(arg0_54)
	arg0_54:GetSignInAgency():ResetSignInCnt()
	arg0_54:GetAccessAgency():ResetFreshInviteCodeFlag()
end

function var0_0.UpdatePerSecond(arg0_55)
	if arg0_55.buildingAgency then
		arg0_55.buildingAgency:UpdatePerSecond()
	end
end

function var0_0.UpdatePerHour(arg0_56, arg1_56)
	arg0_56:GetTradeAgency():UpdatePerHour(arg1_56)
end

return var0_0
