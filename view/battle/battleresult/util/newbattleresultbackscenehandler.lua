local var0 = class("NewBattleResultBackSceneHandler", pm.Mediator)

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0)
	pg.m02:registerMediator(arg0)

	arg0.contextData = arg1
end

function var0.Execute(arg0)
	local var0 = arg0.contextData
	local var1 = var0.system

	if var1 == SYSTEM_DUEL then
		arg0:ExitDuelSystem(var0)
	elseif var1 == SYSTEM_ACT_BOSS then
		arg0:ExitActBossSystem(var0)
	elseif var1 == SYSTEM_ROUTINE or var1 == SYSTEM_SUB_ROUTINE then
		arg0:ExitRoutineSystem(var0)
	elseif var1 == SYSTEM_SCENARIO then
		arg0:ExitScenarioSystem(var0)
	elseif var1 == SYSTEM_CHALLENGE then
		arg0:ExitChallengeSystem(var0)
	elseif var1 == SYSTEM_HP_SHARE_ACT_BOSS or var1 == SYSTEM_BOSS_EXPERIMENT or var1 == SYSTEM_ACT_BOSS_SP then
		arg0:ExitShareBossSystem(var0)
	elseif var1 == SYSTEM_WORLD_BOSS then
		arg0:ExitWorldBossSystem(var0)
	elseif var1 == SYSTEM_WORLD then
		arg0:ExitWorldSystem(var0)
	elseif var1 == SYSTEM_BOSS_RUSH or var1 == SYSTEM_BOSS_RUSH_EX then
		if arg0:CheckBossRushSystem(var0) then
			arg0:ResultRushBossSystem(var0)
		end
	elseif var1 == SYSTEM_LIMIT_CHALLENGE then
		arg0:ExitLimitChallengeSystem(var0)
	elseif var1 == SYSTEM_BOSS_SINGLE then
		arg0:ExitBossSingleSystem(var0)
	else
		arg0:ExitCommonSystem(var0)
	end

	getProxy(MetaCharacterProxy):clearLastMetaSkillExpInfoList()
end

function var0.ExitDuelSystem(arg0, arg1)
	local var0 = getProxy(ContextProxy):getContextByMediator(MilitaryExerciseMediator)

	if var0 then
		local var1 = var0:getContextByMediator(ExercisePreCombatMediator)

		var0:removeChild(var1)
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0.ExitActBossSystem(arg0, arg1)
	local var0, var1 = getProxy(ContextProxy):getContextByMediator(ActivityBossPreCombatMediator)

	if var0 then
		var1:removeChild(var0)
	end

	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
		arg0:CheckActBossSystem(arg1)
	else
		pg.m02:sendNotification(GAME.GO_BACK)
	end
end

function var0.ExitRoutineSystem(arg0, arg1)
	local var0 = getProxy(ContextProxy):getContextByMediator(DailyLevelMediator)

	if var0 then
		local var1 = var0:getContextByMediator(PreCombatMediator)

		var0:removeChild(var1)
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0.ExitScenarioSystem(arg0, arg1)
	if arg1.needHelpMessage then
		getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.BATTLE_FAILED)
	end

	local var0 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

	if var0 then
		local var1 = var0:getContextByMediator(ChapterPreCombatMediator)

		if var1 then
			var0:removeChild(var1)
		end
	end

	if arg1.score > ys.Battle.BattleConst.BattleScore.C then
		arg0:ShowExtraChapterActSocre(arg1)
	end

	getProxy(ChapterProxy):WriteBackOnExitBattleResult()
	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0.ExitChallengeSystem(arg0, arg1)
	getProxy(ChallengeProxy):WriteBackOnExitBattleResult(arg0.contextData.score, arg0.contextData.mode)

	if not arg1.goToNext then
		arg1.goToNext = nil

		local var0 = getProxy(ContextProxy):getContextByMediator(ChallengeMainMediator)

		if var0 then
			local var1 = var0:getContextByMediator(ChallengePreCombatMediator)

			var0:removeChild(var1)
		end
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0.ExitShareBossSystem(arg0, arg1)
	local var0, var1 = getProxy(ContextProxy):getContextByMediator(ActivityBossPreCombatMediator)

	if var0 then
		var1:removeChild(var0)
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0.ExitWorldBossSystem(arg0, arg1)
	local var0 = getProxy(ContextProxy):getContextByMediator(WorldBossMediator)
	local var1 = var0:getContextByMediator(WorldBossFormationMediator)

	if var1 then
		var0:removeChild(var1)
	end

	pg.m02:sendNotification(GAME.WORLD_BOSS_BATTLE_QUIT, {
		id = arg1.bossId
	})
	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0.ExitWorldSystem(arg0, arg1)
	local var0 = getProxy(ContextProxy):getContextByMediator(WorldMediator)
	local var1 = var0:getContextByMediator(WorldPreCombatMediator) or var0:getContextByMediator(WorldBossInformationMediator)

	if var1 then
		var0:removeChild(var1)
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0.ResultRushBossSystem(arg0, arg1)
	local var0 = getProxy(ContextProxy):GetPrevContext(1)
	local var1 = var0:getContextByMediator(BossRushPreCombatMediator)

	if var1 then
		var0:removeChild(var1)
	end

	local var2 = var0:getContextByMediator(BossRushFleetSelectMediator)

	if var2 then
		var0:removeChild(var2)
	end

	if not (arg1.score > ys.Battle.BattleConst.BattleScore.C) and arg1.system == SYSTEM_BOSS_RUSH_EX then
		arg0:addSubLayers(Context.New({
			mediator = BattleFailTipMediator,
			viewComponent = BattleFailTipLayer,
			data = {
				mainShips = arg1.newMainShips,
				battleSystem = arg1.system
			},
			onRemoved = function()
				pg.m02:sendNotification(GAME.GO_BACK)
			end
		}))

		return
	end

	pg.m02:sendNotification(GAME.BOSSRUSH_SETTLE, {
		actId = arg1.actId
	})
end

function var0.ExitRushBossSystem(arg0, arg1, arg2)
	local var0 = arg1.system
	local var1 = arg1.actId
	local var2 = arg2.seriesData
	local var3 = arg1.score > ys.Battle.BattleConst.BattleScore.C
	local var4 = var0 == SYSTEM_BOSS_RUSH and BossRushBattleResultMediator or BossRushBattleResultMediator
	local var5 = var0 == SYSTEM_BOSS_RUSH and BossRushBattleResultLayer or BossRushEXBattleResultLayer

	arg0:addSubLayers(Context.New({
		mediator = var4,
		viewComponent = var5,
		data = {
			awards = arg2.awards,
			system = var0,
			actId = var1,
			seriesData = var2,
			win = var3
		}
	}), true)
	LoadContextCommand.RemoveLayerByMediator(NewBattleResultMediator)
end

function var0.ExitLimitChallengeSystem(arg0, arg1)
	local var0 = getProxy(ContextProxy):getContextByMediator(LimitChallengeMediator)

	if var0 then
		local var1 = var0:getContextByMediator(LimitChallengePreCombatMediator)

		if var1 then
			var0:removeChild(var1)
		end
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

function var0.ExitBossSingleSystem(arg0, arg1)
	local var0, var1 = getProxy(ContextProxy):getContextByMediator(BossSinglePreCombatMediator)

	if var0 then
		var1:removeChild(var0)
	end

	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
		arg0:CheckBossSingleSystem(arg1)
	else
		pg.m02:sendNotification(GAME.GO_BACK)
	end
end

function var0.ExitCommonSystem(arg0, arg1)
	local var0 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

	if var0 then
		local var1 = var0:getContextByMediator(PreCombatMediator)

		if var1 then
			var0:removeChild(var1)
		end
	end

	pg.m02:sendNotification(GAME.GO_BACK)
end

local function var1()
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK)
	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		if iter1 and not iter1:isEnd() then
			table.insert(var1, iter1)
		end
	end

	return var1
end

function var0.ShowExtraChapterActSocre(arg0, arg1)
	local var0 = getProxy(ChapterProxy)
	local var1 = var0:getActiveChapter()
	local var2 = var1 and var0:getMapById(var1:getConfig("map"))
	local var3 = var1()

	for iter0, iter1 in ipairs(var3) do
		local var4 = iter1:getConfig("config_data")
		local var5 = arg1.stageId

		if var4[1] == var5 and var2 and var2:isActExtra() then
			local var6 = math.floor(arg1.statistics._totalTime)
			local var7 = ActivityLevelConst.getShipsPower(arg1.prefabFleet or arg1.oldMainShips)
			local var8, var9 = ActivityLevelConst.getExtraChapterSocre(var5, var6, var7, iter1)
			local var10 = var9 < var8 and i18n("extra_chapter_record_updated") or i18n("extra_chapter_record_not_updated")

			if var9 < var8 then
				iter1.data1 = var8

				getProxy(ActivityProxy):updateActivity(iter1)

				var9 = var8
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("extra_chapter_socre_tip", var8, var9, var10),
				weight = LayerWeightConst.SECOND_LAYER
			})
		end
	end
end

local function var2(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.actId)
	local var1 = var0:getConfig("config_id")
	local var2 = pg.activity_event_worldboss[var1]
	local var3 = var0:IsOilLimit(arg0.stageId)
	local var4 = getProxy(FleetProxy):getActivityFleets()[arg0.actId]
	local var5 = 0
	local var6 = var2.use_oil_limit[arg0.mainFleetId]

	local function var7(arg0, arg1)
		local var0 = arg0:GetCostSum().oil

		if arg1 > 0 then
			var0 = math.min(var0, arg1)
		end

		var5 = var5 + var0
	end

	var7(var4[arg0.mainFleetId], var3 and var6[1] or 0)
	var7(var4[arg0.mainFleetId + 10], var3 and var6[2] or 0)

	return var5
end

local function var3(arg0, arg1)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var1 = var0 and var0.data.autoFlag or nil
	local var2 = getProxy(ChapterProxy):PopActBossRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = ActivityBossTotalRewardPanelMediator,
		viewComponent = ActivityBossTotalRewardPanel,
		data = {
			onClose = function()
				pg.m02:sendNotification(GAME.GO_BACK)
			end,
			stopReason = arg1,
			rewards = var2,
			isAutoFight = var1,
			continuousBattleTimes = arg0.continuousBattleTimes,
			totalBattleTimes = arg0.totalBattleTimes
		}
	}))
end

local function var4(arg0, arg1)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)
	local var1 = var0 and var0.data.autoFlag or nil
	local var2 = getProxy(ChapterProxy):PopBossSingleRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = BossSingleTotalRewardPanelMediator,
		viewComponent = BossSingleTotalRewardPanel,
		data = {
			onClose = function()
				pg.m02:sendNotification(GAME.GO_BACK)
			end,
			stopReason = arg1,
			rewards = var2,
			isAutoFight = var1,
			continuousBattleTimes = arg0.continuousBattleTimes,
			totalBattleTimes = arg0.totalBattleTimes
		}
	}))
end

local function var5()
	local var0 = pg.GuildMsgBoxMgr.GetInstance()

	if var0:GetShouldShowBattleTip() then
		local var1 = getProxy(GuildProxy):getRawData()
		local var2 = var1 and var1:getWeeklyTask()

		if var2 and var2.id ~= 0 then
			var0:SubmitTask(function(arg0, arg1)
				if arg1 then
					var0:CancelShouldShowBattleTip()
				end
			end)
		end
	end
end

function var0.CheckActBossSystem(arg0, arg1)
	pg.m02:sendNotification(ContinuousOperationMediator.CONTINUE_OPERATION)

	if var2(arg1) > getProxy(PlayerProxy):getRawData().oil then
		var3(arg1, i18n("multiple_sorties_stop_reason1"))

		return
	end

	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		var3(arg1, i18n("multiple_sorties_stop_reason3"))

		return
	end

	local var0 = getProxy(FleetProxy):getActivityFleets()[arg1.actId][arg1.mainFleetId]
	local var1 = _.map(_.values(var0.ships), function(arg0)
		local var0 = getProxy(BayProxy):getShipById(arg0)

		if var0 and var0.energy == Ship.ENERGY_LOW then
			return var0
		end
	end)

	if #var1 > 0 then
		local var2 = Fleet.DEFAULT_NAME_BOSS_ACT[arg1.mainFleetId]
		local var3 = _.map(var1, function(arg0)
			return "「" .. arg0:getConfig("name") .. "」"
		end)

		var3(arg1, i18n("multiple_sorties_stop_reason2", var2, table.concat(var3, "")))

		return
	end

	if arg1.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
		var3(arg1, i18n("multiple_sorties_stop_reason4"))

		return
	end

	var5()

	local var4 = getProxy(ContextProxy)
	local var5 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)

	if var5 and not var5.data.autoFlag then
		var3(arg1)

		return
	end

	if arg1.continuousBattleTimes < 1 then
		var3(arg1)

		return
	end

	pg.m02:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
end

function var0.ContinuousBossRush(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	seriesAsync({
		function(arg0)
			arg0:addSubLayers(Context.New({
				mediator = ChallengePassedMediator,
				viewComponent = BossRushPassedLayer,
				data = {
					curIndex = arg3 - 1,
					maxIndex = #arg4
				},
				onRemoved = arg0
			}))
		end,
		function(arg0)
			pg.m02:sendNotification(GAME.BEGIN_STAGE, {
				system = arg1,
				actId = arg2,
				continuousBattleTimes = arg5,
				totalBattleTimes = arg6
			})
		end
	})
end

function var0.CheckBossRushSystem(arg0, arg1)
	local var0 = getProxy(ContextProxy)
	local var1 = arg1.score > ys.Battle.BattleConst.BattleScore.C
	local var2 = arg1.actId
	local var3 = getProxy(ActivityProxy):getActivityById(var2):GetSeriesData()

	assert(var3)

	local var4 = var3:GetStaegLevel() + 1
	local var5 = var3:GetExpeditionIds()

	if var0:getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
		var5()
	end

	local var6 = var0:getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var7 = not var6 or var6.data.autoFlag
	local var8 = not var1 or var4 > #var5 or not var7

	if not var8 then
		arg0:ContinuousBossRush(arg1.system, var2, var4, var5, arg1.continuousBattleTimes, arg1.totalBattleTimes)
	end

	return var8
end

local function var6(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0.actId):GetEnemyDataByStageId(arg0.stageId):GetOilLimit()
	local var1 = getProxy(FleetProxy):getActivityFleets()[arg0.actId]
	local var2 = 0

	local function var3(arg0, arg1)
		local var0 = arg0:GetCostSum().oil

		if arg1 > 0 then
			var0 = math.min(var0, arg1)
		end

		var2 = var2 + var0
	end

	var3(var1[arg0.mainFleetId], var0[1] or 0)
	var3(var1[arg0.mainFleetId + 10], var0[2] or 0)

	return var2
end

function var0.CheckBossSingleSystem(arg0, arg1)
	pg.m02:sendNotification(BossSingleContinuousOperationMediator.CONTINUE_OPERATION)

	if var6(arg1) > getProxy(PlayerProxy):getRawData().oil then
		var4(arg1, i18n("multiple_sorties_stop_reason1"))

		return
	end

	if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
		var4(arg1, i18n("multiple_sorties_stop_reason3"))

		return
	end

	local var0 = getProxy(FleetProxy):getActivityFleets()[arg1.actId][arg1.mainFleetId]
	local var1 = _.map(_.values(var0.ships), function(arg0)
		local var0 = getProxy(BayProxy):getShipById(arg0)

		if var0 and var0.energy == Ship.ENERGY_LOW then
			return var0
		end
	end)

	if #var1 > 0 then
		local var2 = Fleet.DEFAULT_NAME_BOSS_ACT[arg1.mainFleetId]
		local var3 = _.map(var1, function(arg0)
			return "「" .. arg0:getConfig("name") .. "」"
		end)

		var4(arg1, i18n("multiple_sorties_stop_reason2", var2, table.concat(var3, "")))

		return
	end

	if arg1.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
		var4(arg1, i18n("multiple_sorties_stop_reason4"))

		return
	end

	var5()

	local var4 = getProxy(ContextProxy)
	local var5 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)

	if var5 and not var5.data.autoFlag then
		var4(arg1)

		return
	end

	if arg1.continuousBattleTimes < 1 then
		var4(arg1)

		return
	end

	pg.m02:sendNotification(NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT)
end

local function var7(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(arg0)
	local var1 = var0:getConfig("config_id")
	local var2 = pg.activity_event_worldboss[var1].ticket
	local var3 = getProxy(PlayerProxy):getRawData():getResource(var2)

	if var0:GetStageBonus(arg1) == 0 and getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1 and var3 > 0 then
		return true
	end

	return false
end

local function var8(arg0)
	pg.m02:sendNotification(GAME.BEGIN_STAGE, {
		stageId = arg0.stageId,
		mainFleetId = arg0.mainFleetId,
		system = arg0.system,
		actId = arg0.actId,
		rivalId = arg0.rivalId,
		continuousBattleTimes = arg0.continuousBattleTimes,
		totalBattleTimes = arg0.totalBattleTimes
	})
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BOSSRUSH_SETTLE_DONE,
		ContinuousOperationMediator.ON_REENTER,
		BossSingleContinuousOperationMediator.ON_REENTER
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BOSSRUSH_SETTLE_DONE then
		arg0:ExitRushBossSystem(arg0.contextData, var1)
	elseif var0 == ContinuousOperationMediator.ON_REENTER then
		if not var1.autoFlag then
			var3(arg0.contextData)

			return
		end

		if var7(arg0.contextData.actId, arg0.contextData.stageId) then
			pg.m02:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
				stageId = arg0.contextData.stageId
			})
		else
			var8(arg0.contextData)
		end
	elseif var0 == BossSingleContinuousOperationMediator.ON_REENTER then
		if not var1.autoFlag then
			var4(arg0.contextData)

			return
		end

		var8(arg0.contextData)
	end
end

function var0.addSubLayers(arg0, arg1, arg2, arg3)
	assert(isa(arg1, Context), "should be an instance of Context")

	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(NewBattleResultMediator)

	if arg2 then
		while var0.parent do
			var0 = var0.parent
		end
	end

	arg0:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = var0,
		context = arg1,
		callback = arg3
	})
end

function var0.Dispose(arg0)
	pg.m02:removeMediator(arg0.__cname)
end

return var0
