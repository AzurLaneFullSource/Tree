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
	if arg1_6.needHelpMessage then
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
	local var0_11 = getProxy(ContextProxy):GetPrevContext(1)
	local var1_11 = var0_11:getContextByMediator(BossRushPreCombatMediator)

	if var1_11 then
		var0_11:removeChild(var1_11)
	end

	local var2_11 = var0_11:getContextByMediator(BossRushFleetSelectMediator)

	if var2_11 then
		var0_11:removeChild(var2_11)
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

function var0_0.ExitCommonSystem(arg0_17, arg1_17)
	local var0_17 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

	if var0_17 then
		local var1_17 = var0_17:getContextByMediator(PreCombatMediator)

		if var1_17 then
			var0_17:removeChild(var1_17)
		end
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

local function var1_0()
	local var0_18 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK)
	local var1_18 = {}

	for iter0_18, iter1_18 in ipairs(var0_18) do
		if iter1_18 and not iter1_18:isEnd() then
			table.insert(var1_18, iter1_18)
		end
	end

	return var1_18
end

function var0_0.ShowExtraChapterActSocre(arg0_19, arg1_19)
	local var0_19 = getProxy(ChapterProxy):getActiveChapter()
	local var1_19 = var1_0()

	for iter0_19, iter1_19 in ipairs(var1_19) do
		local var2_19 = iter1_19:getConfig("config_data")
		local var3_19 = arg1_19.stageId

		if var2_19[1] == var3_19 and var0_19:IsEXChapter() then
			local var4_19 = math.floor(arg1_19.statistics._totalTime)
			local var5_19 = ActivityLevelConst.getShipsPower(arg1_19.prefabFleet or arg1_19.oldMainShips)
			local var6_19, var7_19 = ActivityLevelConst.getExtraChapterSocre(var3_19, var4_19, var5_19, iter1_19)
			local var8_19 = var7_19 < var6_19 and i18n("extra_chapter_record_updated") or i18n("extra_chapter_record_not_updated")

			if var7_19 < var6_19 then
				iter1_19.data1 = var6_19

				getProxy(ActivityProxy):updateActivity(iter1_19)

				var7_19 = var6_19
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("extra_chapter_socre_tip", var6_19, var7_19, var8_19),
				weight = LayerWeightConst.SECOND_LAYER
			})
		end
	end
end

local function var2_0(arg0_20)
	local var0_20 = getProxy(ActivityProxy):getActivityById(arg0_20.actId)
	local var1_20 = var0_20:getConfig("config_id")
	local var2_20 = pg.activity_event_worldboss[var1_20]
	local var3_20 = var0_20:IsOilLimit(arg0_20.stageId)
	local var4_20 = getProxy(FleetProxy):getActivityFleets()[arg0_20.actId]
	local var5_20 = 0
	local var6_20 = var2_20.use_oil_limit[arg0_20.mainFleetId]

	local function var7_20(arg0_21, arg1_21)
		local var0_21 = arg0_21:GetCostSum().oil

		if arg1_21 > 0 then
			var0_21 = math.min(var0_21, arg1_21)
		end

		var5_20 = var5_20 + var0_21
	end

	var7_20(var4_20[arg0_20.mainFleetId], var3_20 and var6_20[1] or 0)
	var7_20(var4_20[arg0_20.mainFleetId + 10], var3_20 and var6_20[2] or 0)

	return var5_20
end

local function var3_0(arg0_22, arg1_22)
	local var0_22 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var1_22 = var0_22 and var0_22.data.autoFlag or nil
	local var2_22 = getProxy(ChapterProxy):PopActBossRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = ActivityBossTotalRewardPanelMediator,
		viewComponent = ActivityBossTotalRewardPanel,
		data = {
			onClose = function()
				pg.m02:sendNotification(GAME.GO_BACK)
			end,
			stopReason = arg1_22,
			rewards = var2_22,
			isAutoFight = var1_22,
			continuousBattleTimes = arg0_22.continuousBattleTimes,
			totalBattleTimes = arg0_22.totalBattleTimes
		}
	}))
end

local function var4_0(arg0_24, arg1_24)
	local var0_24 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)
	local var1_24 = var0_24 and var0_24.data.autoFlag or nil
	local var2_24 = getProxy(ChapterProxy):PopBossSingleRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = BossSingleTotalRewardPanelMediator,
		viewComponent = BossSingleTotalRewardPanel,
		data = {
			onClose = function()
				pg.m02:sendNotification(GAME.GO_BACK)
			end,
			stopReason = arg1_24,
			rewards = var2_24,
			isAutoFight = var1_24,
			continuousBattleTimes = arg0_24.continuousBattleTimes,
			totalBattleTimes = arg0_24.totalBattleTimes
		}
	}))
end

local function var5_0()
	local var0_26 = pg.GuildMsgBoxMgr.GetInstance()

	if var0_26:GetShouldShowBattleTip() then
		local var1_26 = getProxy(GuildProxy):getRawData()
		local var2_26 = var1_26 and var1_26:getWeeklyTask()

		if var2_26 and var2_26.id ~= 0 then
			var0_26:SubmitTask(function(arg0_27, arg1_27)
				if arg1_27 then
					var0_26:CancelShouldShowBattleTip()
				end
			end)
		end
	end
end

function var0_0.CheckActBossSystem(arg0_28, arg1_28)
	pg.m02:sendNotification(ContinuousOperationMediator.CONTINUE_OPERATION)

	if var2_0(arg1_28) > getProxy(PlayerProxy):getRawData().oil then
		var3_0(arg1_28, i18n("multiple_sorties_stop_reason1"))

		return
	end

	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		var3_0(arg1_28, i18n("multiple_sorties_stop_reason3"))

		return
	end

	local var0_28 = getProxy(FleetProxy):getActivityFleets()[arg1_28.actId][arg1_28.mainFleetId]
	local var1_28 = _.map(_.values(var0_28.ships), function(arg0_29)
		local var0_29 = getProxy(BayProxy):getShipById(arg0_29)

		if var0_29 and var0_29.energy == Ship.ENERGY_LOW then
			return var0_29
		end
	end)

	if #var1_28 > 0 then
		local var2_28 = Fleet.DEFAULT_NAME_BOSS_ACT[arg1_28.mainFleetId]
		local var3_28 = _.map(var1_28, function(arg0_30)
			return "「" .. arg0_30:getConfig("name") .. "」"
		end)

		var3_0(arg1_28, i18n("multiple_sorties_stop_reason2", var2_28, table.concat(var3_28, "")))

		return
	end

	if arg1_28.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
		var3_0(arg1_28, i18n("multiple_sorties_stop_reason4"))

		return
	end

	var5_0()

	local var4_28 = getProxy(ContextProxy)
	local var5_28 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)

	if var5_28 and not var5_28.data.autoFlag then
		var3_0(arg1_28)

		return
	end

	if arg1_28.continuousBattleTimes < 1 then
		var3_0(arg1_28)

		return
	end

	pg.m02:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
end

function var0_0.ContinuousBossRush(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31, arg5_31, arg6_31)
	seriesAsync({
		function(arg0_32)
			arg0_31:addSubLayers(Context.New({
				mediator = ChallengePassedMediator,
				viewComponent = BossRushConst.GetPassedLayer(arg2_31),
				data = {
					curIndex = arg3_31 - 1,
					maxIndex = #arg4_31
				},
				onRemoved = arg0_32
			}))
		end,
		function(arg0_33)
			pg.m02:sendNotification(GAME.BEGIN_STAGE, {
				system = arg1_31,
				actId = arg2_31,
				continuousBattleTimes = arg5_31,
				totalBattleTimes = arg6_31
			})
		end
	})
end

function var0_0.CheckBossRushSystem(arg0_34, arg1_34)
	local var0_34 = getProxy(ContextProxy)
	local var1_34 = arg1_34.score > ys.Battle.BattleConst.BattleScore.C
	local var2_34 = arg1_34.actId
	local var3_34 = getProxy(ActivityProxy):getActivityById(var2_34):GetSeriesData()

	assert(var3_34)

	local var4_34 = var3_34:GetStaegLevel() + 1
	local var5_34 = var3_34:GetExpeditionIds()

	if var0_34:getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
		var5_0()
	end

	local var6_34 = var0_34:getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var7_34 = not var6_34 or var6_34.data.autoFlag
	local var8_34 = not var1_34 or var4_34 > #var5_34 or not var7_34

	arg0_34.contextData.isAutoFight = var7_34

	if not var8_34 then
		arg0_34:ContinuousBossRush(arg1_34.system, var2_34, var4_34, var5_34, arg1_34.continuousBattleTimes, arg1_34.totalBattleTimes)
	end

	return var8_34
end

local function var6_0(arg0_35)
	local var0_35 = getProxy(ActivityProxy):getActivityById(arg0_35.actId)
	local var1_35 = var0_35:GetEnemyDataByStageId(arg0_35.stageId):GetOilLimit()
	local var2_35 = getProxy(FleetProxy):getActivityFleets()[arg0_35.actId]
	local var3_35 = 0

	local function var4_35(arg0_36, arg1_36)
		local var0_36 = arg0_36:GetCostSum().oil

		if arg1_36 > 0 then
			var0_36 = math.min(var0_36, arg1_36)
		end

		var3_35 = var3_35 + var0_36
	end

	var4_35(var2_35[arg0_35.mainFleetId], var1_35[1] or 0)

	local var5_35 = var0_35:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE_VARIABLE and Fleet.MEGA_SUBMARINE_FLEET_OFFSET or 10

	var4_35(var2_35[arg0_35.mainFleetId + var5_35], var1_35[2] or 0)

	return var3_35
end

function var0_0.CheckBossSingleSystem(arg0_37, arg1_37)
	pg.m02:sendNotification(BossSingleContinuousOperationMediator.CONTINUE_OPERATION)

	if var6_0(arg1_37) > getProxy(PlayerProxy):getRawData().oil then
		var4_0(arg1_37, i18n("multiple_sorties_stop_reason1"))

		return
	end

	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		var4_0(arg1_37, i18n("multiple_sorties_stop_reason3"))

		return
	end

	local var0_37 = getProxy(FleetProxy):getActivityFleets()[arg1_37.actId][arg1_37.mainFleetId]
	local var1_37 = _.map(_.values(var0_37.ships), function(arg0_38)
		local var0_38 = getProxy(BayProxy):getShipById(arg0_38)

		if var0_38 and var0_38.energy == Ship.ENERGY_LOW then
			return var0_38
		end
	end)

	if #var1_37 > 0 then
		local var2_37 = Fleet.DEFAULT_NAME_BOSS_ACT[arg1_37.mainFleetId]
		local var3_37 = _.map(var1_37, function(arg0_39)
			return "「" .. arg0_39:getConfig("name") .. "」"
		end)

		var4_0(arg1_37, i18n("multiple_sorties_stop_reason2", var2_37, table.concat(var3_37, "")))

		return
	end

	if arg1_37.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
		var4_0(arg1_37, i18n("multiple_sorties_stop_reason4"))

		return
	end

	var5_0()

	local var4_37 = getProxy(ContextProxy)
	local var5_37 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)

	if var5_37 and not var5_37.data.autoFlag then
		var4_0(arg1_37)

		return
	end

	if arg1_37.continuousBattleTimes < 1 then
		var4_0(arg1_37)

		return
	end

	pg.m02:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
end

local function var7_0(arg0_40, arg1_40)
	local var0_40 = getProxy(ActivityProxy):getActivityById(arg0_40)
	local var1_40 = var0_40:getConfig("config_id")
	local var2_40 = pg.activity_event_worldboss[var1_40].ticket
	local var3_40 = getProxy(PlayerProxy):getRawData():getResource(var2_40)

	if var0_40:GetStageBonus(arg1_40) == 0 and getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1 and var3_40 > 0 then
		return true
	end

	return false
end

local function var8_0(arg0_41)
	pg.m02:sendNotification(GAME.BEGIN_STAGE, {
		stageId = arg0_41.stageId,
		mainFleetId = arg0_41.mainFleetId,
		system = arg0_41.system,
		actId = arg0_41.actId,
		rivalId = arg0_41.rivalId,
		continuousBattleTimes = arg0_41.continuousBattleTimes,
		variableBuffList = arg0_41.variableBuffList,
		totalBattleTimes = arg0_41.totalBattleTimes,
		useVariableTicket = arg0_41.useVariableTicket
	})
end

function var0_0.listNotificationInterests(arg0_42)
	return {
		GAME.BOSSRUSH_SETTLE_DONE,
		ContinuousOperationMediator.ON_REENTER,
		BossSingleContinuousOperationMediator.ON_REENTER
	}
end

function var0_0.handleNotification(arg0_43, arg1_43)
	local var0_43 = arg1_43:getName()
	local var1_43 = arg1_43:getBody()

	if var0_43 == GAME.BOSSRUSH_SETTLE_DONE then
		arg0_43:ExitRushBossSystem(arg0_43.contextData, var1_43)
	elseif var0_43 == ContinuousOperationMediator.ON_REENTER then
		if not var1_43.autoFlag then
			var3_0(arg0_43.contextData)

			return
		end

		if var7_0(arg0_43.contextData.actId, arg0_43.contextData.stageId) then
			pg.m02:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
				stageId = arg0_43.contextData.stageId
			})
		else
			var8_0(arg0_43.contextData)
		end
	elseif var0_43 == BossSingleContinuousOperationMediator.ON_REENTER then
		if not var1_43.autoFlag then
			var4_0(arg0_43.contextData)

			return
		end

		var8_0(arg0_43.contextData)
	end
end

function var0_0.addSubLayers(arg0_44, arg1_44, arg2_44, arg3_44)
	assert(isa(arg1_44, Context), "should be an instance of Context")

	local var0_44 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewBattleResultMediator)

	if arg2_44 then
		while var0_44.parent do
			var0_44 = var0_44.parent
		end
	end

	arg0_44:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_44,
		context = arg1_44,
		callback = arg3_44
	})
end

function var0_0.Dispose(arg0_45)
	pg.m02:removeMediator(arg0_45.__cname)
end

return var0_0
