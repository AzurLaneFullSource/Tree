local var0_0 = class("NewBattleResultBackSceneHandler", pm.Mediator)

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)
	pg.m02:registerMediator(arg0_1)

	arg0_1.contextData = arg1_1
end

function var0_0.Execute(arg0_2)
	local var0_2 = arg0_2.contextData
	local var1_2 = var0_2.system

	if var1_2 == SYSTEM_DUEL then
		arg0_2:ExitDuelSystem(var0_2)
	elseif var1_2 == SYSTEM_ACT_BOSS then
		arg0_2:ExitActBossSystem(var0_2)
	elseif var1_2 == SYSTEM_ROUTINE or var1_2 == SYSTEM_SUB_ROUTINE then
		arg0_2:ExitRoutineSystem(var0_2)
	elseif var1_2 == SYSTEM_SCENARIO then
		arg0_2:ExitScenarioSystem(var0_2)
	elseif var1_2 == SYSTEM_CHALLENGE then
		arg0_2:ExitChallengeSystem(var0_2)
	elseif var1_2 == SYSTEM_HP_SHARE_ACT_BOSS or var1_2 == SYSTEM_BOSS_EXPERIMENT or var1_2 == SYSTEM_ACT_BOSS_SP then
		arg0_2:ExitShareBossSystem(var0_2)
	elseif var1_2 == SYSTEM_WORLD_BOSS then
		arg0_2:ExitWorldBossSystem(var0_2)
	elseif var1_2 == SYSTEM_WORLD then
		arg0_2:ExitWorldSystem(var0_2)
	elseif var1_2 == SYSTEM_BOSS_RUSH or var1_2 == SYSTEM_BOSS_RUSH_EX then
		if arg0_2:CheckBossRushSystem(var0_2) then
			arg0_2:ResultRushBossSystem(var0_2)
		end
	elseif var1_2 == SYSTEM_LIMIT_CHALLENGE then
		arg0_2:ExitLimitChallengeSystem(var0_2)
	elseif var1_2 == SYSTEM_BOSS_SINGLE then
		arg0_2:ExitBossSingleSystem(var0_2)
	elseif var1_2 == SYSTEM_BOSS_SINGLE_VARIABLE then
		arg0_2:ExitBossSingleVariableSystem(var0_2)
	elseif var1_2 == SYSTEM_REWARD_PERFORM then
		arg0_2:ExitRewardPerform(var0_2)
	else
		arg0_2:ExitCommonSystem(var0_2)
	end

	getProxy(MetaCharacterProxy):clearLastMetaSkillExpInfoList()
end

function var0_0.ExitDuelSystem(arg0_3, arg1_3)
	local var0_3 = getProxy(ContextProxy):getContextByMediator(MilitaryExerciseMediator)

	if var0_3 then
		local var1_3 = var0_3:getContextByMediator(ExercisePreCombatMediator)

		var0_3:removeChild(var1_3)
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.ExitActBossSystem(arg0_4, arg1_4)
	local var0_4, var1_4 = getProxy(ContextProxy):getContextByMediator(ActivityBossPreCombatMediator)

	if var0_4 then
		var1_4:removeChild(var0_4)
	end

	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
		arg0_4:CheckActBossSystem(arg1_4)
	else
		pg.m02:sendNotification(GAME.GO_BACK)
	end
end

function var0_0.ExitRoutineSystem(arg0_5, arg1_5)
	local var0_5 = getProxy(ContextProxy):getContextByMediator(DailyLevelMediator)

	if var0_5 then
		local var1_5 = var0_5:getContextByMediator(PreCombatMediator)

		var0_5:removeChild(var1_5)
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.ExitScenarioSystem(arg0_6, arg1_6)
	if arg1_6.needHelpMessage or arg1_6.score == ys.Battle.BattleConst.BattleScore.C then
		getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.BATTLE_FAILED)
	end

	local var0_6 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

	if var0_6 then
		local var1_6 = var0_6:getContextByMediator(ChapterPreCombatMediator)

		if var1_6 then
			var0_6:removeChild(var1_6)
		end
	end

	if arg1_6.score > ys.Battle.BattleConst.BattleScore.C then
		arg0_6:ShowExtraChapterActSocre(arg1_6)
	end

	getProxy(ChapterProxy):WriteBackOnExitBattleResult()
	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.ExitChallengeSystem(arg0_7, arg1_7)
	getProxy(ChallengeProxy):WriteBackOnExitBattleResult(arg0_7.contextData.score, arg0_7.contextData.mode)

	if not arg1_7.goToNext then
		arg1_7.goToNext = nil

		local var0_7 = getProxy(ContextProxy):getContextByMediator(ChallengeMainMediator)

		if var0_7 then
			local var1_7 = var0_7:getContextByMediator(ChallengePreCombatMediator)

			var0_7:removeChild(var1_7)
		end
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.ExitShareBossSystem(arg0_8, arg1_8)
	local var0_8, var1_8 = getProxy(ContextProxy):getContextByMediator(ActivityBossPreCombatMediator)

	if var0_8 then
		var1_8:removeChild(var0_8)
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.ExitWorldBossSystem(arg0_9, arg1_9)
	local var0_9 = getProxy(ContextProxy):getContextByMediator(WorldBossMediator)
	local var1_9 = var0_9:getContextByMediator(WorldBossFormationMediator)

	if var1_9 then
		var0_9:removeChild(var1_9)
	end

	pg.m02:sendNotification(GAME.WORLD_BOSS_BATTLE_QUIT, {
		id = arg1_9.bossId
	})
	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.ExitWorldSystem(arg0_10, arg1_10)
	local var0_10 = getProxy(ContextProxy):getContextByMediator(WorldMediator)
	local var1_10 = var0_10:getContextByMediator(WorldPreCombatMediator) or var0_10:getContextByMediator(WorldBossInformationMediator)

	if var1_10 then
		var0_10:removeChild(var1_10)
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.ResultRushBossSystem(arg0_11, arg1_11)
	local var0_11 = getProxy(ContextProxy)
	local var1_11, var2_11 = var0_11:getContextByMediator(BossRushPreCombatMediator)

	if var1_11 then
		var2_11:removeChild(var1_11)
	end

	local var3_11, var4_11 = var0_11:getContextByMediator(BossRushFleetSelectMediator)

	if var3_11 then
		var4_11:removeChild(var3_11)
	end

	if not (arg1_11.score > ys.Battle.BattleConst.BattleScore.C) and arg1_11.system == SYSTEM_BOSS_RUSH_EX then
		arg0_11:addSubLayers(Context.New({
			mediator = BattleFailTipMediator,
			viewComponent = BattleFailTipLayer,
			data = {
				mainShips = arg1_11.newMainShips,
				battleSystem = arg1_11.system
			},
			onRemoved = function()
				pg.m02:sendNotification(GAME.GO_BACK)
			end
		}))

		return
	end

	pg.m02:sendNotification(GAME.BOSSRUSH_SETTLE, {
		actId = arg1_11.actId
	})
end

function var0_0.ExitRushBossSystem(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13.system
	local var1_13 = arg1_13.actId
	local var2_13 = arg2_13.seriesData
	local var3_13 = arg1_13.score > ys.Battle.BattleConst.BattleScore.C
	local var4_13 = var0_13 == SYSTEM_BOSS_RUSH and BossRushBattleResultMediator or BossRushBattleResultMediator
	local var5_13 = var0_13 == SYSTEM_BOSS_RUSH and BossRushBattleResultLayer or BossRushConst.GetEXBattleResultLayer(var1_13)

	arg0_13:addSubLayers(Context.New({
		mediator = var4_13,
		viewComponent = var5_13,
		data = {
			awards = arg2_13.awards,
			system = var0_13,
			actId = var1_13,
			seriesData = var2_13,
			win = var3_13,
			isAutoFight = arg0_13.contextData.isAutoFight
		}
	}), true)
	LoadContextCommand.RemoveLayerByMediator(NewBattleResultMediator)
end

function var0_0.ExitLimitChallengeSystem(arg0_14, arg1_14)
	local var0_14 = getProxy(ContextProxy):getContextByMediator(LimitChallengeMediator)

	if var0_14 then
		local var1_14 = var0_14:getContextByMediator(LimitChallengePreCombatMediator)

		if var1_14 then
			var0_14:removeChild(var1_14)
		end
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.ExitBossSingleSystem(arg0_15, arg1_15)
	local var0_15, var1_15 = getProxy(ContextProxy):getContextByMediator(BossSinglePreCombatMediator)

	if var0_15 then
		local var2_15 = var1_15:removeChild(var0_15)
	end

	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
		arg0_15:CheckBossSingleSystem(arg1_15)
	else
		pg.m02:sendNotification(GAME.GO_BACK)
	end
end

function var0_0.ExitBossSingleVariableSystem(arg0_16, arg1_16)
	local var0_16, var1_16 = getProxy(ContextProxy):getContextByMediator(BossSinglePreCombatMediator)

	if var0_16 then
		local var2_16 = var1_16:removeChild(var0_16)
	end

	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
		arg0_16:CheckBossSingleSystem(arg1_16)
	else
		pg.m02:sendNotification(GAME.GO_BACK)
	end
end

function var0_0.ExitRewardPerform(arg0_17, arg1_17)
	local var0_17, var1_17 = getProxy(ContextProxy):getContextByMediator(BossSinglePreCombatLiteMediator)

	print(var0_17.parent)

	if var0_17 then
		print(var1_17.mediator.__cname)

		local var2_17 = var1_17:removeChild(var0_17)
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0_0.ExitCommonSystem(arg0_18, arg1_18)
	local var0_18 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

	if var0_18 then
		local var1_18 = var0_18:getContextByMediator(PreCombatMediator)

		if var1_18 then
			var0_18:removeChild(var1_18)
		end
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

local function var1_0()
	local var0_19 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK)
	local var1_19 = {}

	for iter0_19, iter1_19 in ipairs(var0_19) do
		if iter1_19 and not iter1_19:isEnd() then
			table.insert(var1_19, iter1_19)
		end
	end

	return var1_19
end

function var0_0.ShowExtraChapterActSocre(arg0_20, arg1_20)
	local var0_20 = getProxy(ChapterProxy):getActiveChapter()
	local var1_20 = var1_0()

	for iter0_20, iter1_20 in ipairs(var1_20) do
		local var2_20 = iter1_20:getConfig("config_data")
		local var3_20 = arg1_20.stageId

		if var2_20[1] == var3_20 and var0_20:IsEXChapter() then
			local var4_20 = math.floor(arg1_20.statistics._totalTime)
			local var5_20 = ActivityLevelConst.getShipsPower(arg1_20.prefabFleet or arg1_20.oldMainShips)
			local var6_20, var7_20 = ActivityLevelConst.getExtraChapterSocre(var3_20, var4_20, var5_20, iter1_20)
			local var8_20 = var7_20 < var6_20 and i18n("extra_chapter_record_updated") or i18n("extra_chapter_record_not_updated")

			if var7_20 < var6_20 then
				iter1_20.data1 = var6_20

				getProxy(ActivityProxy):updateActivity(iter1_20)

				var7_20 = var6_20
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("extra_chapter_socre_tip", var6_20, var7_20, var8_20)
			})
		end
	end
end

local function var2_0(arg0_21)
	local var0_21 = getProxy(ActivityProxy):getActivityById(arg0_21.actId)
	local var1_21 = var0_21:getConfig("config_id")
	local var2_21 = pg.activity_event_worldboss[var1_21]
	local var3_21 = var0_21:IsOilLimit(arg0_21.stageId)
	local var4_21 = getProxy(FleetProxy):getActivityFleets()[arg0_21.actId]
	local var5_21 = 0
	local var6_21 = var2_21.use_oil_limit[arg0_21.mainFleetId]

	local function var7_21(arg0_22, arg1_22)
		local var0_22 = arg0_22:GetCostSum().oil

		if arg1_22 > 0 then
			var0_22 = math.min(var0_22, arg1_22)
		end

		var5_21 = var5_21 + var0_22
	end

	var7_21(var4_21[arg0_21.mainFleetId], var3_21 and var6_21[1] or 0)
	var7_21(var4_21[arg0_21.mainFleetId + 10], var3_21 and var6_21[2] or 0)

	return var5_21
end

local function var3_0(arg0_23, arg1_23)
	local var0_23 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var1_23 = var0_23 and var0_23.data.autoFlag or nil
	local var2_23 = getProxy(ChapterProxy):PopActBossRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = ActivityBossTotalRewardPanelMediator,
		viewComponent = ActivityBossTotalRewardPanel,
		data = {
			onClose = function()
				pg.m02:sendNotification(GAME.GO_BACK)
			end,
			stopReason = arg1_23,
			rewards = var2_23,
			isAutoFight = var1_23,
			continuousBattleTimes = arg0_23.continuousBattleTimes,
			totalBattleTimes = arg0_23.totalBattleTimes
		}
	}))
end

local function var4_0(arg0_25, arg1_25)
	local var0_25 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)
	local var1_25 = var0_25 and var0_25.data.autoFlag or nil
	local var2_25 = getProxy(ChapterProxy):PopBossSingleRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = BossSingleTotalRewardPanelMediator,
		viewComponent = BossSingleTotalRewardPanel,
		data = {
			onConfirm = function()
				pg.m02:sendNotification(GAME.GO_BACK)
			end,
			onClose = function()
				local var0_27 = getProxy(ContextProxy):getContextByMediator(ClueMapMediator)

				if var0_27 then
					var0_27.cleanChild = true

					warning("ClueMapMediator")
				end

				local var1_27 = getProxy(ContextProxy):getContextByMediator(BossSinglePreCombatMediator)

				if var1_27 then
					var1_27.skipBack = true

					warning("BossSinglePreCombatMediator")
				end

				pg.m02:sendNotification(GAME.GO_BACK)
			end,
			stopReason = arg1_25,
			rewards = var2_25,
			isAutoFight = var1_25,
			continuousBattleTimes = arg0_25.continuousBattleTimes,
			totalBattleTimes = arg0_25.totalBattleTimes
		}
	}))
end

local function var5_0()
	local var0_28 = pg.GuildMsgBoxMgr.GetInstance()

	if var0_28:GetShouldShowBattleTip() then
		local var1_28 = getProxy(GuildProxy):getRawData()
		local var2_28 = var1_28 and var1_28:getWeeklyTask()

		if var2_28 and var2_28.id ~= 0 then
			var0_28:SubmitTask(function(arg0_29, arg1_29)
				if arg1_29 then
					var0_28:CancelShouldShowBattleTip()
				end
			end)
		end
	end
end

function var0_0.CheckActBossSystem(arg0_30, arg1_30)
	pg.m02:sendNotification(ContinuousOperationMediator.CONTINUE_OPERATION)

	if var2_0(arg1_30) > getProxy(PlayerProxy):getRawData().oil then
		var3_0(arg1_30, i18n("multiple_sorties_stop_reason1"))

		return
	end

	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		var3_0(arg1_30, i18n("multiple_sorties_stop_reason3"))

		return
	end

	local var0_30 = getProxy(FleetProxy):getActivityFleets()[arg1_30.actId][arg1_30.mainFleetId]
	local var1_30 = _.map(_.values(var0_30.ships), function(arg0_31)
		local var0_31 = getProxy(BayProxy):getShipById(arg0_31)

		if var0_31 and var0_31.energy == Ship.ENERGY_LOW then
			return var0_31
		end
	end)

	if #var1_30 > 0 then
		local var2_30 = Fleet.DEFAULT_NAME_BOSS_ACT[arg1_30.mainFleetId]
		local var3_30 = _.map(var1_30, function(arg0_32)
			return "「" .. arg0_32:getConfig("name") .. "」"
		end)

		var3_0(arg1_30, i18n("multiple_sorties_stop_reason2", var2_30, table.concat(var3_30, "")))

		return
	end

	if arg1_30.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
		var3_0(arg1_30, i18n("multiple_sorties_stop_reason4"))

		return
	end

	var5_0()

	local var4_30 = getProxy(ContextProxy)
	local var5_30 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)

	if var5_30 and not var5_30.data.autoFlag then
		var3_0(arg1_30)

		return
	end

	if arg1_30.continuousBattleTimes < 1 then
		var3_0(arg1_30)

		return
	end

	pg.m02:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
end

function var0_0.ContinuousBossRush(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33, arg5_33, arg6_33)
	seriesAsync({
		function(arg0_34)
			arg0_33:addSubLayers(Context.New({
				mediator = ChallengePassedMediator,
				viewComponent = BossRushConst.GetPassedLayer(arg2_33),
				data = {
					curIndex = arg3_33 - 1,
					maxIndex = #arg4_33
				},
				onRemoved = arg0_34
			}))
		end,
		function(arg0_35)
			pg.m02:sendNotification(GAME.BEGIN_STAGE, {
				system = arg1_33,
				actId = arg2_33,
				continuousBattleTimes = arg5_33,
				totalBattleTimes = arg6_33
			})
		end
	})
end

function var0_0.CheckBossRushSystem(arg0_36, arg1_36)
	local var0_36 = getProxy(ContextProxy)
	local var1_36 = arg1_36.score > ys.Battle.BattleConst.BattleScore.C
	local var2_36 = arg1_36.actId
	local var3_36 = getProxy(ActivityProxy):getActivityById(var2_36):GetSeriesData()

	assert(var3_36)

	local var4_36 = var3_36:GetStaegLevel() + 1
	local var5_36 = var3_36:GetExpeditionIds()

	if var0_36:getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
		var5_0()
	end

	local var6_36 = var0_36:getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var7_36 = not var6_36 or var6_36.data.autoFlag
	local var8_36 = not var1_36 or var4_36 > #var5_36 or not var7_36

	arg0_36.contextData.isAutoFight = var7_36

	if not var8_36 then
		arg0_36:ContinuousBossRush(arg1_36.system, var2_36, var4_36, var5_36, arg1_36.continuousBattleTimes, arg1_36.totalBattleTimes)
	end

	return var8_36
end

local function var6_0(arg0_37)
	local var0_37 = getProxy(ActivityProxy):getActivityById(arg0_37.actId)
	local var1_37 = var0_37:GetEnemyDataByStageId(arg0_37.stageId):GetOilLimit()
	local var2_37 = getProxy(FleetProxy):getActivityFleets()[arg0_37.actId]
	local var3_37 = 0

	local function var4_37(arg0_38, arg1_38)
		local var0_38 = arg0_38:GetCostSum().oil

		if arg1_38 > 0 then
			var0_38 = math.min(var0_38, arg1_38)
		end

		var3_37 = var3_37 + var0_38
	end

	var4_37(var2_37[arg0_37.mainFleetId], var1_37[1] or 0)

	local var5_37 = var0_37:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE and Fleet.MEGA_SUBMARINE_FLEET_OFFSET or 10

	var4_37(var2_37[arg0_37.mainFleetId + var5_37], var1_37[2] or 0)

	return var3_37
end

function var0_0.CheckBossSingleSystem(arg0_39, arg1_39)
	pg.m02:sendNotification(BossSingleContinuousOperationMediator.CONTINUE_OPERATION)

	if var6_0(arg1_39) > getProxy(PlayerProxy):getRawData().oil then
		var4_0(arg1_39, i18n("multiple_sorties_stop_reason1"))

		return
	end

	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		var4_0(arg1_39, i18n("multiple_sorties_stop_reason3"))

		return
	end

	local var0_39 = getProxy(FleetProxy):getActivityFleets()[arg1_39.actId][arg1_39.mainFleetId]
	local var1_39 = _.map(_.values(var0_39.ships), function(arg0_40)
		local var0_40 = getProxy(BayProxy):getShipById(arg0_40)

		if var0_40 and var0_40.energy == Ship.ENERGY_LOW then
			return var0_40
		end
	end)

	if #var1_39 > 0 then
		local var2_39 = Fleet.DEFAULT_NAME_BOSS_ACT[arg1_39.mainFleetId]
		local var3_39 = _.map(var1_39, function(arg0_41)
			return "「" .. arg0_41:getConfig("name") .. "」"
		end)

		var4_0(arg1_39, i18n("multiple_sorties_stop_reason2", var2_39, table.concat(var3_39, "")))

		return
	end

	if arg1_39.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
		var4_0(arg1_39, i18n("multiple_sorties_stop_reason4"))

		return
	end

	var5_0()

	local var4_39 = getProxy(ContextProxy)
	local var5_39 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)

	if var5_39 and not var5_39.data.autoFlag then
		var4_0(arg1_39)

		return
	end

	if arg1_39.continuousBattleTimes < 1 then
		var4_0(arg1_39)

		return
	end

	pg.m02:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
end

local function var7_0(arg0_42, arg1_42)
	local var0_42 = getProxy(ActivityProxy):getActivityById(arg0_42)
	local var1_42 = var0_42:getConfig("config_id")
	local var2_42 = pg.activity_event_worldboss[var1_42].ticket
	local var3_42 = getProxy(PlayerProxy):getRawData():getResource(var2_42)

	if var0_42:GetStageBonus(arg1_42) == 0 and getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1 and var3_42 > 0 then
		return true
	end

	return false
end

local function var8_0(arg0_43)
	pg.m02:sendNotification(GAME.BEGIN_STAGE, {
		stageId = arg0_43.stageId,
		mainFleetId = arg0_43.mainFleetId,
		system = arg0_43.system,
		actId = arg0_43.actId,
		rivalId = arg0_43.rivalId,
		continuousBattleTimes = arg0_43.continuousBattleTimes,
		variableBuffList = arg0_43.variableBuffList,
		totalBattleTimes = arg0_43.totalBattleTimes,
		useVariableTicket = arg0_43.useVariableTicket
	})
end

function var0_0.listNotificationInterests(arg0_44)
	return {
		GAME.BOSSRUSH_SETTLE_DONE,
		ContinuousOperationMediator.ON_REENTER,
		BossSingleContinuousOperationMediator.ON_REENTER
	}
end

function var0_0.handleNotification(arg0_45, arg1_45)
	local var0_45 = arg1_45:getName()
	local var1_45 = arg1_45:getBody()

	if var0_45 == GAME.BOSSRUSH_SETTLE_DONE then
		arg0_45:ExitRushBossSystem(arg0_45.contextData, var1_45)
	elseif var0_45 == ContinuousOperationMediator.ON_REENTER then
		if not var1_45.autoFlag then
			var3_0(arg0_45.contextData)

			return
		end

		if var7_0(arg0_45.contextData.actId, arg0_45.contextData.stageId) then
			pg.m02:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
				stageId = arg0_45.contextData.stageId
			})
		else
			var8_0(arg0_45.contextData)
		end
	elseif var0_45 == BossSingleContinuousOperationMediator.ON_REENTER then
		if not var1_45.autoFlag then
			var4_0(arg0_45.contextData)

			return
		end

		var8_0(arg0_45.contextData)
	end
end

function var0_0.addSubLayers(arg0_46, arg1_46, arg2_46, arg3_46)
	assert(isa(arg1_46, Context), "should be an instance of Context")

	local var0_46 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewBattleResultMediator)

	if arg2_46 then
		while var0_46.parent do
			var0_46 = var0_46.parent
		end
	end

	arg0_46:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_46,
		context = arg1_46,
		callback = arg3_46
	})
end

function var0_0.Dispose(arg0_47)
	pg.m02:removeMediator(arg0_47.__cname)
end

return var0_0
