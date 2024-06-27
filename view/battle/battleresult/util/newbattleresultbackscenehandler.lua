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
		var1_15:removeChild(var0_15)
	end

	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
		arg0_15:CheckBossSingleSystem(arg1_15)
	else
		pg.m02:sendNotification(GAME.GO_BACK)
	end
end

function var0_0.ExitCommonSystem(arg0_16, arg1_16)
	local var0_16 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

	if var0_16 then
		local var1_16 = var0_16:getContextByMediator(PreCombatMediator)

		if var1_16 then
			var0_16:removeChild(var1_16)
		end
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

local function var1_0()
	local var0_17 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK)
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if iter1_17 and not iter1_17:isEnd() then
			table.insert(var1_17, iter1_17)
		end
	end

	return var1_17
end

function var0_0.ShowExtraChapterActSocre(arg0_18, arg1_18)
	local var0_18 = getProxy(ChapterProxy)
	local var1_18 = var0_18:getActiveChapter()
	local var2_18 = var1_18 and var0_18:getMapById(var1_18:getConfig("map"))
	local var3_18 = var1_0()

	for iter0_18, iter1_18 in ipairs(var3_18) do
		local var4_18 = iter1_18:getConfig("config_data")
		local var5_18 = arg1_18.stageId

		if var4_18[1] == var5_18 and var2_18 and var2_18:isActExtra() then
			local var6_18 = math.floor(arg1_18.statistics._totalTime)
			local var7_18 = ActivityLevelConst.getShipsPower(arg1_18.prefabFleet or arg1_18.oldMainShips)
			local var8_18, var9_18 = ActivityLevelConst.getExtraChapterSocre(var5_18, var6_18, var7_18, iter1_18)
			local var10_18 = var9_18 < var8_18 and i18n("extra_chapter_record_updated") or i18n("extra_chapter_record_not_updated")

			if var9_18 < var8_18 then
				iter1_18.data1 = var8_18

				getProxy(ActivityProxy):updateActivity(iter1_18)

				var9_18 = var8_18
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("extra_chapter_socre_tip", var8_18, var9_18, var10_18),
				weight = LayerWeightConst.SECOND_LAYER
			})
		end
	end
end

local function var2_0(arg0_19)
	local var0_19 = getProxy(ActivityProxy):getActivityById(arg0_19.actId)
	local var1_19 = var0_19:getConfig("config_id")
	local var2_19 = pg.activity_event_worldboss[var1_19]
	local var3_19 = var0_19:IsOilLimit(arg0_19.stageId)
	local var4_19 = getProxy(FleetProxy):getActivityFleets()[arg0_19.actId]
	local var5_19 = 0
	local var6_19 = var2_19.use_oil_limit[arg0_19.mainFleetId]

	local function var7_19(arg0_20, arg1_20)
		local var0_20 = arg0_20:GetCostSum().oil

		if arg1_20 > 0 then
			var0_20 = math.min(var0_20, arg1_20)
		end

		var5_19 = var5_19 + var0_20
	end

	var7_19(var4_19[arg0_19.mainFleetId], var3_19 and var6_19[1] or 0)
	var7_19(var4_19[arg0_19.mainFleetId + 10], var3_19 and var6_19[2] or 0)

	return var5_19
end

local function var3_0(arg0_21, arg1_21)
	local var0_21 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var1_21 = var0_21 and var0_21.data.autoFlag or nil
	local var2_21 = getProxy(ChapterProxy):PopActBossRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = ActivityBossTotalRewardPanelMediator,
		viewComponent = ActivityBossTotalRewardPanel,
		data = {
			onClose = function()
				pg.m02:sendNotification(GAME.GO_BACK)
			end,
			stopReason = arg1_21,
			rewards = var2_21,
			isAutoFight = var1_21,
			continuousBattleTimes = arg0_21.continuousBattleTimes,
			totalBattleTimes = arg0_21.totalBattleTimes
		}
	}))
end

local function var4_0(arg0_23, arg1_23)
	local var0_23 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)
	local var1_23 = var0_23 and var0_23.data.autoFlag or nil
	local var2_23 = getProxy(ChapterProxy):PopBossSingleRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = BossSingleTotalRewardPanelMediator,
		viewComponent = BossSingleTotalRewardPanel,
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

local function var5_0()
	local var0_25 = pg.GuildMsgBoxMgr.GetInstance()

	if var0_25:GetShouldShowBattleTip() then
		local var1_25 = getProxy(GuildProxy):getRawData()
		local var2_25 = var1_25 and var1_25:getWeeklyTask()

		if var2_25 and var2_25.id ~= 0 then
			var0_25:SubmitTask(function(arg0_26, arg1_26)
				if arg1_26 then
					var0_25:CancelShouldShowBattleTip()
				end
			end)
		end
	end
end

function var0_0.CheckActBossSystem(arg0_27, arg1_27)
	pg.m02:sendNotification(ContinuousOperationMediator.CONTINUE_OPERATION)

	if var2_0(arg1_27) > getProxy(PlayerProxy):getRawData().oil then
		var3_0(arg1_27, i18n("multiple_sorties_stop_reason1"))

		return
	end

	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		var3_0(arg1_27, i18n("multiple_sorties_stop_reason3"))

		return
	end

	local var0_27 = getProxy(FleetProxy):getActivityFleets()[arg1_27.actId][arg1_27.mainFleetId]
	local var1_27 = _.map(_.values(var0_27.ships), function(arg0_28)
		local var0_28 = getProxy(BayProxy):getShipById(arg0_28)

		if var0_28 and var0_28.energy == Ship.ENERGY_LOW then
			return var0_28
		end
	end)

	if #var1_27 > 0 then
		local var2_27 = Fleet.DEFAULT_NAME_BOSS_ACT[arg1_27.mainFleetId]
		local var3_27 = _.map(var1_27, function(arg0_29)
			return "「" .. arg0_29:getConfig("name") .. "」"
		end)

		var3_0(arg1_27, i18n("multiple_sorties_stop_reason2", var2_27, table.concat(var3_27, "")))

		return
	end

	if arg1_27.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
		var3_0(arg1_27, i18n("multiple_sorties_stop_reason4"))

		return
	end

	var5_0()

	local var4_27 = getProxy(ContextProxy)
	local var5_27 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)

	if var5_27 and not var5_27.data.autoFlag then
		var3_0(arg1_27)

		return
	end

	if arg1_27.continuousBattleTimes < 1 then
		var3_0(arg1_27)

		return
	end

	pg.m02:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
end

function var0_0.ContinuousBossRush(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30, arg5_30, arg6_30)
	seriesAsync({
		function(arg0_31)
			arg0_30:addSubLayers(Context.New({
				mediator = ChallengePassedMediator,
				viewComponent = BossRushConst.GetPassedLayer(arg2_30),
				data = {
					curIndex = arg3_30 - 1,
					maxIndex = #arg4_30
				},
				onRemoved = arg0_31
			}))
		end,
		function(arg0_32)
			pg.m02:sendNotification(GAME.BEGIN_STAGE, {
				system = arg1_30,
				actId = arg2_30,
				continuousBattleTimes = arg5_30,
				totalBattleTimes = arg6_30
			})
		end
	})
end

function var0_0.CheckBossRushSystem(arg0_33, arg1_33)
	local var0_33 = getProxy(ContextProxy)
	local var1_33 = arg1_33.score > ys.Battle.BattleConst.BattleScore.C
	local var2_33 = arg1_33.actId
	local var3_33 = getProxy(ActivityProxy):getActivityById(var2_33):GetSeriesData()

	assert(var3_33)

	local var4_33 = var3_33:GetStaegLevel() + 1
	local var5_33 = var3_33:GetExpeditionIds()

	if var0_33:getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
		var5_0()
	end

	local var6_33 = var0_33:getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var7_33 = not var6_33 or var6_33.data.autoFlag
	local var8_33 = not var1_33 or var4_33 > #var5_33 or not var7_33

	arg0_33.contextData.isAutoFight = var7_33

	if not var8_33 then
		arg0_33:ContinuousBossRush(arg1_33.system, var2_33, var4_33, var5_33, arg1_33.continuousBattleTimes, arg1_33.totalBattleTimes)
	end

	return var8_33
end

local function var6_0(arg0_34)
	local var0_34 = getProxy(ActivityProxy):getActivityById(arg0_34.actId):GetEnemyDataByStageId(arg0_34.stageId):GetOilLimit()
	local var1_34 = getProxy(FleetProxy):getActivityFleets()[arg0_34.actId]
	local var2_34 = 0

	local function var3_34(arg0_35, arg1_35)
		local var0_35 = arg0_35:GetCostSum().oil

		if arg1_35 > 0 then
			var0_35 = math.min(var0_35, arg1_35)
		end

		var2_34 = var2_34 + var0_35
	end

	var3_34(var1_34[arg0_34.mainFleetId], var0_34[1] or 0)
	var3_34(var1_34[arg0_34.mainFleetId + 10], var0_34[2] or 0)

	return var2_34
end

function var0_0.CheckBossSingleSystem(arg0_36, arg1_36)
	pg.m02:sendNotification(BossSingleContinuousOperationMediator.CONTINUE_OPERATION)

	if var6_0(arg1_36) > getProxy(PlayerProxy):getRawData().oil then
		var4_0(arg1_36, i18n("multiple_sorties_stop_reason1"))

		return
	end

	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		var4_0(arg1_36, i18n("multiple_sorties_stop_reason3"))

		return
	end

	local var0_36 = getProxy(FleetProxy):getActivityFleets()[arg1_36.actId][arg1_36.mainFleetId]
	local var1_36 = _.map(_.values(var0_36.ships), function(arg0_37)
		local var0_37 = getProxy(BayProxy):getShipById(arg0_37)

		if var0_37 and var0_37.energy == Ship.ENERGY_LOW then
			return var0_37
		end
	end)

	if #var1_36 > 0 then
		local var2_36 = Fleet.DEFAULT_NAME_BOSS_ACT[arg1_36.mainFleetId]
		local var3_36 = _.map(var1_36, function(arg0_38)
			return "「" .. arg0_38:getConfig("name") .. "」"
		end)

		var4_0(arg1_36, i18n("multiple_sorties_stop_reason2", var2_36, table.concat(var3_36, "")))

		return
	end

	if arg1_36.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
		var4_0(arg1_36, i18n("multiple_sorties_stop_reason4"))

		return
	end

	var5_0()

	local var4_36 = getProxy(ContextProxy)
	local var5_36 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)

	if var5_36 and not var5_36.data.autoFlag then
		var4_0(arg1_36)

		return
	end

	if arg1_36.continuousBattleTimes < 1 then
		var4_0(arg1_36)

		return
	end

	pg.m02:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
end

local function var7_0(arg0_39, arg1_39)
	local var0_39 = getProxy(ActivityProxy):getActivityById(arg0_39)
	local var1_39 = var0_39:getConfig("config_id")
	local var2_39 = pg.activity_event_worldboss[var1_39].ticket
	local var3_39 = getProxy(PlayerProxy):getRawData():getResource(var2_39)

	if var0_39:GetStageBonus(arg1_39) == 0 and getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1 and var3_39 > 0 then
		return true
	end

	return false
end

local function var8_0(arg0_40)
	pg.m02:sendNotification(GAME.BEGIN_STAGE, {
		stageId = arg0_40.stageId,
		mainFleetId = arg0_40.mainFleetId,
		system = arg0_40.system,
		actId = arg0_40.actId,
		rivalId = arg0_40.rivalId,
		continuousBattleTimes = arg0_40.continuousBattleTimes,
		totalBattleTimes = arg0_40.totalBattleTimes
	})
end

function var0_0.listNotificationInterests(arg0_41)
	return {
		GAME.BOSSRUSH_SETTLE_DONE,
		ContinuousOperationMediator.ON_REENTER,
		BossSingleContinuousOperationMediator.ON_REENTER
	}
end

function var0_0.handleNotification(arg0_42, arg1_42)
	local var0_42 = arg1_42:getName()
	local var1_42 = arg1_42:getBody()

	if var0_42 == GAME.BOSSRUSH_SETTLE_DONE then
		arg0_42:ExitRushBossSystem(arg0_42.contextData, var1_42)
	elseif var0_42 == ContinuousOperationMediator.ON_REENTER then
		if not var1_42.autoFlag then
			var3_0(arg0_42.contextData)

			return
		end

		if var7_0(arg0_42.contextData.actId, arg0_42.contextData.stageId) then
			pg.m02:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
				stageId = arg0_42.contextData.stageId
			})
		else
			var8_0(arg0_42.contextData)
		end
	elseif var0_42 == BossSingleContinuousOperationMediator.ON_REENTER then
		if not var1_42.autoFlag then
			var4_0(arg0_42.contextData)

			return
		end

		var8_0(arg0_42.contextData)
	end
end

function var0_0.addSubLayers(arg0_43, arg1_43, arg2_43, arg3_43)
	assert(isa(arg1_43, Context), "should be an instance of Context")

	local var0_43 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewBattleResultMediator)

	if arg2_43 then
		while var0_43.parent do
			var0_43 = var0_43.parent
		end
	end

	arg0_43:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0_43,
		context = arg1_43,
		callback = arg3_43
	})
end

function var0_0.Dispose(arg0_44)
	pg.m02:removeMediator(arg0_44.__cname)
end

return var0_0
