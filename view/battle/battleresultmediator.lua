local var0 = class("BattleResultMediator", import("..base.ContextMediator"))

var0.ON_BACK_TO_LEVEL_SCENE = "BattleResultMediator.ON_BACK_TO_LEVEL_SCENE"
var0.ON_BACK_TO_DUEL_SCENE = "BattleResultMediator.ON_BACK_TO_DUEL_SCENE"
var0.ON_GO_TO_TASK_SCENE = "BattleResultMediator.ON_GO_TO_TASK_SCENE"
var0.GET_NEW_SHIP = "BattleResultMediator.GET_NEW_SHIP"
var0.ON_GO_TO_MAIN_SCENE = "BattleResultMediator.ON_GO_TO_MAIN_SCENE"
var0.ON_NEXT_CHALLENGE = "BattleResultMediator.ON_NEXT_CHALLENGE"
var0.ON_CHALLENGE_RANK = "BattleResultMediator:ON_CHALLENGE_RANK"
var0.ON_CHALLENGE_SHARE = "BattleResultMediator:ON_CHALLENGE_SHARE"
var0.ON_CHALLENGE_DEFEAT_SCENE = "BattleResultMediator:ON_CHALLENGE_DEFEAT_SCENE"
var0.DIRECT_EXIT = "BattleResultMediator:DIRECT_EXIT"
var0.REENTER_STAGE = "BattleResultMediator:REENTER_STAGE"
var0.OPEN_FAIL_TIP_LAYER = "BattleResultMediator:OPEN_FAIL_TIP_LAYER"
var0.PRE_BATTLE_FAIL_EXIT = "BattleResultMediator:PRE_BATTLE_FAIL_EXIT"
var0.ON_ENTER_BATTLE_RESULT = "BattleResultMediator:ON_ENTER_BATTLE_RESULT"
var0.SET_SKIP_FLAG = "BattleResultMediator:SET_SKIP_FLAG"
var0.ON_COMPLETE_BATTLE_RESULT = "BattleResultMediator:ON_COMPLETE_BATTLE_RESULT"

function var0.register(arg0)
	local var0 = getProxy(PlayerProxy):getData()
	local var1 = getProxy(FleetProxy)
	local var2 = getProxy(BayProxy)
	local var3 = getProxy(ChapterProxy)
	local var4 = getProxy(ActivityProxy)
	local var5 = arg0.contextData.system

	if var5 == SYSTEM_DUEL then
		local var6 = getProxy(MilitaryExerciseProxy)
		local var7 = var6:getPreRivalById(arg0.contextData.rivalId)

		assert(var7, "should exist rival--" .. arg0.contextData.rivalId)
		arg0.viewComponent:setRivalVO(var7)
		arg0.viewComponent:setRank(var0, var6:getSeasonInfo())
	elseif var5 == SYSTEM_CHALLENGE then
		local var8 = getProxy(ChallengeProxy)
		local var9 = var8:getUserChallengeInfo(arg0.contextData.mode)

		arg0.viewComponent:setChallengeInfo(var9, var8:userSeaonExpire(arg0.contextData.mode))
	else
		if var5 == SYSTEM_SCENARIO or var5 == SYSTEM_ROUTINE or var5 == SYSTEM_ACT_BOSS or var5 == SYSTEM_BOSS_SINGLE or var5 == SYSTEM_HP_SHARE_ACT_BOSS or var5 == SYSTEM_SUB_ROUTINE or var5 == SYSTEM_WORLD then
			local var10 = _.detect(BuffHelper.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF), function(arg0)
				return arg0:getConfig("benefit_type") == "rookie_battle_exp"
			end)
			local var11 = var4:getBuffShipList()

			arg0.viewComponent:setExpBuff(var10, var11)
		end

		arg0.viewComponent:setPlayer(var0)
	end

	local var12

	if var5 == SYSTEM_SCENARIO then
		var12 = {}

		local var13

		if var5 == SYSTEM_SCENARIO then
			var13 = var3:getActiveChapter()
		end

		local var14 = var13.fleet
		local var15 = var14[TeamType.Main]
		local var16 = var14[TeamType.Vanguard]

		for iter0, iter1 in ipairs(var15) do
			table.insert(var12, iter1)
		end

		for iter2, iter3 in ipairs(var16) do
			table.insert(var12, iter3)
		end

		local var17 = _.detect(var13.fleets, function(arg0)
			return arg0:getFleetType() == FleetType.Submarine
		end)

		if var17 then
			local var18 = var17:getShipsByTeam(TeamType.Submarine, true)

			for iter4, iter5 in ipairs(var18) do
				table.insert(var12, iter5)
			end
		end

		arg0.viewComponent:SetSkipFlag(var3:GetChapterAutoFlag(var13.id) == 1)
	elseif var5 == SYSTEM_WORLD then
		var12 = {}

		local var19 = nowWorld()
		local var20 = var19:GetActiveMap()
		local var21 = var20:GetFleet()
		local var22 = var21:GetTeamShipVOs(TeamType.Main, true)
		local var23 = var21:GetTeamShipVOs(TeamType.Vanguard, true)

		for iter6, iter7 in ipairs(var22) do
			table.insert(var12, iter7)
		end

		for iter8, iter9 in ipairs(var23) do
			table.insert(var12, iter9)
		end

		local var24 = var20:GetSubmarineFleet()

		if var24 then
			local var25 = var24:GetTeamShipVOs(TeamType.Submarine, true)

			for iter10, iter11 in ipairs(var25) do
				table.insert(var12, iter11)
			end
		end

		arg0.viewComponent:SetSkipFlag(var19.isAutoFight)
	elseif var5 == SYSTEM_CHALLENGE then
		arg0:bind(var0.ON_CHALLENGE_SHARE, function(arg0)
			arg0:addSubLayers(Context.New({
				mediator = ChallengeShareMediator,
				viewComponent = ChallengeShareLayer,
				data = {
					mode = arg0.contextData.mode
				}
			}))
		end)
		arg0:bind(var0.ON_CHALLENGE_DEFEAT_SCENE, function(arg0, arg1)
			local var0 = arg1.callback

			arg0:addSubLayers(Context.New({
				mediator = ChallengePassedMediator,
				viewComponent = ChallengePassedLayer,
				data = {
					mode = arg0.contextData.mode
				},
				onRemoved = var0
			}))
		end)
	elseif var5 == SYSTEM_WORLD_BOSS then
		local var26 = nowWorld():GetBossProxy():GetFleet(arg0.contextData.bossId)

		var12 = getProxy(BayProxy):getShipsByFleet(var26)

		local var27 = arg0.contextData.name

		arg0.viewComponent:setTitle(var27)
	elseif var5 == SYSTEM_DODGEM then
		-- block empty
	elseif var5 == SYSTEM_SUBMARINE_RUN then
		-- block empty
	elseif var5 == SYSTEM_REWARD_PERFORM then
		-- block empty
	elseif var5 == SYSTEM_AIRFIGHT then
		-- block empty
	elseif var5 == SYSTEM_CARDPUZZLE then
		-- block empty
	elseif var5 == SYSTEM_HP_SHARE_ACT_BOSS or var5 == SYSTEM_ACT_BOSS or var5 == SYSTEM_BOSS_SINGLE or var5 == SYSTEM_BOSS_EXPERIMENT then
		local var28 = arg0.contextData.actId

		if var5 == SYSTEM_HP_SHARE_ACT_BOSS then
			arg0.viewComponent:setActId(var28)
		end

		local var29 = var1:getActivityFleets()[var28]
		local var30 = var29[arg0.contextData.mainFleetId]

		var12 = var2:getShipsByFleet(var30)

		local var31 = var29[arg0.contextData.mainFleetId + 10]
		local var32 = var2:getShipsByFleet(var31)

		for iter12, iter13 in ipairs(var32) do
			table.insert(var12, iter13)
		end
	elseif var5 == SYSTEM_GUILD then
		var12 = {}

		local var33 = getProxy(GuildProxy):getData():GetActiveEvent():GetBossMission()
		local var34 = var33:GetMainFleet()

		for iter14, iter15 in ipairs(var34:GetShips()) do
			table.insert(var12, iter15.ship)
		end

		local var35 = var33:GetSubFleet()

		for iter16, iter17 in ipairs(var35:GetShips()) do
			table.insert(var12, iter17.ship)
		end
	elseif var5 == SYSTEM_BOSS_RUSH or var5 == SYSTEM_BOSS_RUSH_EX then
		local var36 = arg0.contextData.actId
		local var37 = getProxy(ActivityProxy):getActivityById(var36):GetSeriesData()

		assert(var37)

		local var38 = var37:GetStaegLevel()
		local var39 = var37:GetFleetIds()
		local var40 = var39[var38]

		if var37:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var40 = var39[1]
		end

		local var41 = var1:getActivityFleets()[var36][var40]

		var12 = var2:getShipsByFleet(var41)
	else
		local var42 = arg0.contextData.mainFleetId
		local var43 = var1:getFleetById(var42)

		var12 = var2:getShipsByFleet(var43)
	end

	arg0.viewComponent:setShips(var12)
	arg0:bind(var0.ON_BACK_TO_LEVEL_SCENE, function(arg0, arg1)
		local var0 = getProxy(ContextProxy)

		if var5 == SYSTEM_DUEL then
			arg0.viewComponent:emit(BattleResultMediator.ON_BACK_TO_DUEL_SCENE)

			return
		elseif var5 == SYSTEM_ACT_BOSS then
			local var1, var2 = var0:getContextByMediator(PreCombatMediator)

			if var1 then
				var2:removeChild(var1)
			end

			if var0:getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				arg0:sendNotification(ContinuousOperationMediator.CONTINUE_OPERATION)
				existCall(arg0.viewComponent.HideConfirmPanel, arg0.viewComponent)

				local var3 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId)
				local var4 = var3:getConfig("config_id")
				local var5 = pg.activity_event_worldboss[var4]
				local var6 = var3:IsOilLimit(arg0.contextData.stageId)
				local var7 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.actId]
				local var8 = 0
				local var9 = var5.use_oil_limit[arg0.contextData.mainFleetId]

				local function var10(arg0, arg1)
					local var0 = arg0:GetCostSum().oil

					if arg1 > 0 then
						var0 = math.min(var0, arg1)
					end

					var8 = var8 + var0
				end

				var10(var7[arg0.contextData.mainFleetId], var6 and var9[1] or 0)
				var10(var7[arg0.contextData.mainFleetId + 10], var6 and var9[2] or 0)

				if var8 > getProxy(PlayerProxy):getRawData().oil then
					local var11 = i18n("multiple_sorties_stop_reason1")

					arg0:DisplayTotalReward(var11)

					return
				end

				if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
					local var12 = i18n("multiple_sorties_stop_reason3")

					arg0:DisplayTotalReward(var12)

					return
				end

				local var13 = var7[arg0.contextData.mainFleetId]
				local var14 = _.map(_.values(var13.ships), function(arg0)
					local var0 = getProxy(BayProxy):getShipById(arg0)

					if var0 and var0.energy == Ship.ENERGY_LOW then
						return var0
					end
				end)

				if #var14 > 0 then
					local var15 = Fleet.DEFAULT_NAME_BOSS_ACT[arg0.contextData.mainFleetId]
					local var16 = _.map(var14, function(arg0)
						return "「" .. arg0:getConfig("name") .. "」"
					end)
					local var17 = i18n("multiple_sorties_stop_reason2", var15, table.concat(var16, ""))

					arg0:DisplayTotalReward(var17)

					return
				end

				if arg0.contextData.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
					local var18 = i18n("multiple_sorties_stop_reason4")

					arg0:DisplayTotalReward(var18)

					return
				end

				local var19 = pg.GuildMsgBoxMgr.GetInstance()

				if var19:GetShouldShowBattleTip() then
					local var20 = getProxy(GuildProxy):getRawData()
					local var21 = var20 and var20:getWeeklyTask()

					if var21 and var21.id ~= 0 then
						var19:SubmitTask(function(arg0, arg1)
							if arg1 then
								var19:CancelShouldShowBattleTip()
							end
						end)
					end
				end

				local var22 = var0:getCurrentContext():getContextByMediator(ContinuousOperationMediator)

				if var22 and not var22.data.autoFlag then
					arg0:DisplayTotalReward()

					return
				end

				if arg0.contextData.continuousBattleTimes < 1 then
					arg0:DisplayTotalReward()

					return
				end

				arg0:sendNotification(BattleResultMediator.ON_COMPLETE_BATTLE_RESULT)

				return
			end
		elseif var5 == SYSTEM_ROUTINE or var5 == SYSTEM_SUB_ROUTINE then
			local var23 = var0:getContextByMediator(DailyLevelMediator)

			if var23 then
				local var24 = var23:getContextByMediator(PreCombatMediator)

				var23:removeChild(var24)
			end
		elseif var5 == SYSTEM_SCENARIO then
			local var25 = var0:getContextByMediator(LevelMediator2)
			local var26 = var25:getContextByMediator(ChapterPreCombatMediator)

			if var26 then
				var25:removeChild(var26)
			end

			if arg0.contextData.score > 1 then
				arg0:showExtraChapterActSocre()
			end

			local var27 = getProxy(ChapterProxy)
			local var28 = var27:getActiveChapter()

			if var28 then
				if var28:existOni() then
					var28:clearSubmarineFleet()
					var27:updateChapter(var28)
				elseif var28:isPlayingWithBombEnemy() then
					var28.fleets = {
						var28.fleet
					}
					var28.findex = 1

					var27:updateChapter(var28)
				end
			end
		elseif var5 == SYSTEM_CHALLENGE then
			local var29 = getProxy(ChallengeProxy)
			local var30 = arg0.contextData.mode
			local var31 = var29:getUserChallengeInfo(var30)

			if arg0.contextData.score < ys.Battle.BattleConst.BattleScore.S then
				arg0:sendNotification(GAME.CHALLENGE2_RESET, {
					mode = var30
				})
			else
				local var32 = var31:IsFinish()

				var31:updateLevelForward()

				if var31:getMode() == ChallengeProxy.MODE_INFINITE and var32 then
					var31:setInfiniteDungeonIDListByLevel()
				end
			end

			local var33 = var29:getChallengeInfo()

			if not var29:userSeaonExpire(var31:getMode()) then
				var33:checkRecord(var31)
			end

			if not arg1.goToNext then
				local var34 = var0:getContextByMediator(ChallengeMainMediator)

				if var34 then
					local var35 = var34:getContextByMediator(ChallengePreCombatMediator)

					var34:removeChild(var35)
				end
			end
		elseif var5 == SYSTEM_HP_SHARE_ACT_BOSS then
			local var36, var37 = var0:getContextByMediator(PreCombatMediator)

			if var36 then
				var37:removeChild(var36)
			end
		elseif var5 == SYSTEM_WORLD_BOSS then
			local var38 = var0:getContextByMediator(WorldBossMediator)
			local var39 = var38:getContextByMediator(WorldBossFormationMediator)

			if var39 then
				var38:removeChild(var39)
			end
		elseif var5 == SYSTEM_WORLD then
			local var40 = var0:getContextByMediator(WorldMediator)
			local var41 = var40:getContextByMediator(WorldPreCombatMediator) or var40:getContextByMediator(WorldBossInformationMediator)

			if var41 then
				var40:removeChild(var41)
			end
		elseif var5 == SYSTEM_BOSS_RUSH or var5 == SYSTEM_BOSS_RUSH_EX then
			local var42 = arg0.contextData.score > ys.Battle.BattleConst.BattleScore.C
			local var43 = arg0.contextData.actId
			local var44 = getProxy(ActivityProxy):getActivityById(var43):GetSeriesData()

			assert(var44)

			local var45 = var44:GetStaegLevel() + 1
			local var46 = var44:GetExpeditionIds()
			local var47 = var0:getCurrentContext():getContextByMediator(ContinuousOperationMediator)
			local var48 = not var47 or var47.data.autoFlag

			if var0:getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				local var49 = pg.GuildMsgBoxMgr.GetInstance()

				if var49:GetShouldShowBattleTip() then
					local var50 = getProxy(GuildProxy):getRawData()
					local var51 = var50 and var50:getWeeklyTask()

					if var51 and var51.id ~= 0 then
						var49:SubmitTask(function(arg0, arg1)
							if arg1 then
								var49:CancelShouldShowBattleTip()
							end
						end)
					end
				end
			end

			if not var42 or var45 > #var46 or not var48 then
				local var52 = var0:GetPrevContext(1)
				local var53 = var52:getContextByMediator(BossRushPreCombatMediator)

				if var53 then
					var52:removeChild(var53)
				end

				local var54 = var52:getContextByMediator(BossRushFleetSelectMediator)

				if var54 then
					var52:removeChild(var54)
				end

				arg0:sendNotification(GAME.BOSSRUSH_SETTLE, {
					actId = arg0.contextData.actId
				})
			else
				seriesAsync({
					function(arg0)
						arg0:addSubLayers(Context.New({
							mediator = ChallengePassedMediator,
							viewComponent = BossRushPassedLayer,
							data = {
								curIndex = var45 - 1,
								maxIndex = #var46
							},
							onRemoved = arg0
						}))
					end,
					function(arg0)
						arg0:sendNotification(GAME.BEGIN_STAGE, {
							system = arg0.contextData.system,
							actId = var43,
							continuousBattleTimes = arg0.contextData.continuousBattleTimes,
							totalBattleTimes = arg0.contextData.totalBattleTimes
						})
					end
				})
			end

			return
		elseif var5 == SYSTEM_CARDPUZZLE then
			-- block empty
		elseif var5 == SYSTEM_BOSS_SINGLE then
			local var55, var56 = var0:getContextByMediator(PreCombatMediator)

			if var55 then
				var56:removeChild(var55)
			end

			if var0:getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
				arg0:sendNotification(BossSingleContinuousOperationMediator.CONTINUE_OPERATION)
				existCall(arg0.viewComponent.HideConfirmPanel, arg0.viewComponent)

				local var57 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId)
				local var58 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.actId]
				local var59 = 0
				local var60 = var57:GetOilLimits()[arg0.contextData.mainFleetId]

				local function var61(arg0, arg1)
					local var0 = arg0:GetCostSum().oil

					if arg1 > 0 then
						var0 = math.min(var0, arg1)
					end

					var59 = var59 + var0
				end

				var61(var58[arg0.contextData.mainFleetId], var60[1] or 0)
				var61(var58[arg0.contextData.mainFleetId + 10], var60[2] or 0)

				if var59 > getProxy(PlayerProxy):getRawData().oil then
					local var62 = i18n("multiple_sorties_stop_reason1")

					arg0:DisplayBossSingleTotalReward(var62)

					return
				end

				if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
					local var63 = i18n("multiple_sorties_stop_reason3")

					arg0:DisplayBossSingleTotalReward(var63)

					return
				end

				local var64 = var58[arg0.contextData.mainFleetId]
				local var65 = _.map(_.values(var64.ships), function(arg0)
					local var0 = getProxy(BayProxy):getShipById(arg0)

					if var0 and var0.energy == Ship.ENERGY_LOW then
						return var0
					end
				end)

				if #var65 > 0 then
					local var66 = Fleet.DEFAULT_NAME_BOSS_ACT[arg0.contextData.mainFleetId]
					local var67 = _.map(var65, function(arg0)
						return "「" .. arg0:getConfig("name") .. "」"
					end)
					local var68 = i18n("multiple_sorties_stop_reason2", var66, table.concat(var67, ""))

					arg0:DisplayBossSingleTotalReward(var68)

					return
				end

				if arg0.contextData.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
					local var69 = i18n("multiple_sorties_stop_reason4")

					arg0:DisplayBossSingleTotalReward(var69)

					return
				end

				local var70 = pg.GuildMsgBoxMgr.GetInstance()

				if var70:GetShouldShowBattleTip() then
					local var71 = getProxy(GuildProxy):getRawData()
					local var72 = var71 and var71:getWeeklyTask()

					if var72 and var72.id ~= 0 then
						var70:SubmitTask(function(arg0, arg1)
							if arg1 then
								var70:CancelShouldShowBattleTip()
							end
						end)
					end
				end

				local var73 = var0:getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)

				if var73 and not var73.data.autoFlag then
					arg0:DisplayBossSingleTotalReward()

					return
				end

				if arg0.contextData.continuousBattleTimes < 1 then
					arg0:DisplayBossSingleTotalReward()

					return
				end

				arg0:sendNotification(BattleResultMediator.ON_COMPLETE_BATTLE_RESULT)

				return
			end
		else
			local var74 = var0:getContextByMediator(LevelMediator2)

			if var74 then
				local var75 = var74:getContextByMediator(PreCombatMediator)

				var74:removeChild(var75)
			end
		end

		arg0:sendNotification(GAME.GO_BACK)
	end)
	arg0:bind(var0.ON_GO_TO_MAIN_SCENE, function(arg0)
		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.MAINUI)
	end)
	arg0:bind(var0.ON_GO_TO_TASK_SCENE, function(arg0)
		local var0 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

		if var0 then
			local var1 = var0:getContextByMediator(PreCombatMediator)

			var0:removeChild(var1)
		end

		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.TASK)
	end)
	arg0:bind(var0.ON_BACK_TO_DUEL_SCENE, function(arg0)
		local var0 = getProxy(ContextProxy):getContextByMediator(MilitaryExerciseMediator)

		if var0 then
			local var1 = var0:getContextByMediator(ExercisePreCombatMediator)

			var0:removeChild(var1)
		end

		arg0:sendNotification(GAME.GO_BACK)
	end)
	arg0:bind(var0.GET_NEW_SHIP, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = arg1,
				autoExitTime = arg3
			},
			onRemoved = arg2
		}))
	end)
	arg0:bind(var0.OPEN_FAIL_TIP_LAYER, function(arg0)
		setActive(arg0.viewComponent._tf, false)
		arg0:addSubLayers(Context.New({
			mediator = BattleFailTipMediator,
			viewComponent = BattleFailTipLayer,
			data = {
				mainShips = var12,
				battleSystem = arg0.contextData.system
			},
			onRemoved = function()
				arg0.viewComponent:emit(BattleResultMediator.ON_BACK_TO_DUEL_SCENE)
			end
		}))
	end)
	arg0:bind(var0.DIRECT_EXIT, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_BACK)
	end)
	arg0:bind(var0.REENTER_STAGE, function(arg0)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			stageId = arg0.contextData.stageId,
			mainFleetId = arg0.contextData.mainFleetId,
			system = arg0.contextData.system,
			actId = arg0.contextData.actId,
			rivalId = arg0.contextData.rivalId,
			continuousBattleTimes = arg0.contextData.continuousBattleTimes,
			totalBattleTimes = arg0.contextData.totalBattleTimes
		})
	end)
	arg0:bind(var0.PRE_BATTLE_FAIL_EXIT, function(arg0)
		if var5 == SYSTEM_SCENARIO then
			getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.BATTLE_FAILED)
		end
	end)
	arg0:bind(GAME.ACT_BOSS_EXCHANGE_TICKET, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
			stageId = arg1
		})
	end)

	local var44 = 0

	if var12 then
		for iter18, iter19 in ipairs(var12) do
			var44 = iter19:getBattleTotalExpend() + var44
		end
	end

	originalPrint("耗时：", arg0.contextData.statistics._totalTime, "秒")
	originalPrint("编队基础油耗：", var44)

	if arg0.contextData.statistics._enemyInfoList then
		for iter20, iter21 in pairs(arg0.contextData.statistics._enemyInfoList) do
			originalPrint("目标ID>>", iter21.id, "<< 受到伤害共 >>", iter21.damage, "<< 点")
		end
	end

	local var45 = false

	if var5 == SYSTEM_SCENARIO then
		local var46 = var3:getActiveChapter()

		var45 = getProxy(ChapterProxy):GetChapterAutoFlag(var46.id) == 1
	elseif var5 == SYSTEM_WORLD then
		var45 = nowWorld().isAutoFight
	end

	local var47 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	if ys.Battle.BattleState.IsAutoBotActive() and var47 and not var45 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
		LuaHelper.Vibrate()
	end

	arg0:sendNotification(var0.ON_ENTER_BATTLE_RESULT)
end

function var0.showExtraChapterActSocre(arg0)
	local var0 = getProxy(ActivityProxy)
	local var1 = var0:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK)
	local var2 = getProxy(ChapterProxy)
	local var3 = var2:getActiveChapter()
	local var4 = var3 and var2:getMapById(var3:getConfig("map"))

	for iter0, iter1 in ipairs(var1) do
		if iter1 and not iter1:isEnd() then
			local var5 = iter1:getConfig("config_data")
			local var6 = arg0.contextData.stageId

			if var5[1] == var6 and var4 and var4:isActExtra() then
				local var7 = math.floor(arg0.contextData.statistics._totalTime)
				local var8 = ActivityLevelConst.getShipsPower(arg0.contextData.prefabFleet or arg0.contextData.oldMainShips)
				local var9, var10 = ActivityLevelConst.getExtraChapterSocre(var6, var7, var8, iter1)
				local var11 = var10 < var9 and i18n("extra_chapter_record_updated") or i18n("extra_chapter_record_not_updated")

				if var10 < var9 then
					iter1.data1 = var9

					var0:updateActivity(iter1)

					var10 = var9
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					content = i18n("extra_chapter_socre_tip", var9, var10, var11),
					weight = LayerWeightConst.SECOND_LAYER
				})
			end
		end
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BEGIN_STAGE_DONE,
		GAME.ACT_BOSS_EXCHANGE_TICKET_DONE,
		ContinuousOperationMediator.CONTINUE_OPERATION,
		var0.SET_SKIP_FLAG,
		GAME.BOSSRUSH_SETTLE_DONE,
		ContinuousOperationMediator.ON_REENTER,
		BossSingleContinuousOperationMediator.CONTINUE_OPERATION,
		BossSingleContinuousOperationMediator.ON_REENTER
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == GAME.ACT_BOSS_EXCHANGE_TICKET_DONE then
		existCall(arg0.viewComponent.OnActBossExchangeTicket, arg0.viewComponent)
	elseif var0 == var0.SET_SKIP_FLAG then
		arg0.viewComponent:SetSkipFlag(var1)
	elseif var0 == ContinuousOperationMediator.CONTINUE_OPERATION then
		arg0.contextData.continuousBattleTimes = arg0.contextData.continuousBattleTimes - 1
	elseif var0 == GAME.BOSSRUSH_SETTLE_DONE then
		local var2 = arg0.contextData.system
		local var3 = arg0.contextData.actId
		local var4 = var1.seriesData
		local var5 = arg0.contextData.score > ys.Battle.BattleConst.BattleScore.C

		if not var5 and var2 == SYSTEM_BOSS_RUSH_EX then
			arg0.viewComponent:emit(BattleResultMediator.OPEN_FAIL_TIP_LAYER)

			return
		end

		local var6 = var2 == SYSTEM_BOSS_RUSH and BossRushBattleResultMediator or BossRushBattleResultMediator
		local var7 = var2 == SYSTEM_BOSS_RUSH and BossRushBattleResultLayer or BossRushEXBattleResultLayer

		arg0:addSubLayers(Context.New({
			mediator = var6,
			viewComponent = var7,
			data = {
				awards = var1.awards,
				system = arg0.contextData.system,
				actId = var3,
				seriesData = var4,
				win = var5
			}
		}), true)
		arg0.viewComponent:closeView()
	elseif var0 == ContinuousOperationMediator.ON_REENTER then
		if not var1.autoFlag then
			arg0:DisplayTotalReward()

			return
		end

		local var8 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId)
		local var9 = var8:getConfig("config_id")
		local var10 = pg.activity_event_worldboss[var9].ticket
		local var11 = getProxy(PlayerProxy):getRawData():getResource(var10)

		if var8:GetStageBonus(arg0.contextData.stageId) == 0 and getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1 and var11 > 0 then
			arg0:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
				stageId = arg0.contextData.stageId
			})

			return
		end

		arg0.viewComponent:emit(var0.REENTER_STAGE)
	elseif var0 == BossSingleContinuousOperationMediator.CONTINUE_OPERATION then
		arg0.contextData.continuousBattleTimes = arg0.contextData.continuousBattleTimes - 1
	elseif var0 == BossSingleContinuousOperationMediator.ON_REENTER then
		if not var1.autoFlag then
			arg0:DisplayBossSingleTotalReward()

			return
		end

		arg0.viewComponent:emit(var0.REENTER_STAGE)
	end
end

function var0.DisplayTotalReward(arg0, arg1)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var1 = var0 and var0.data.autoFlag or nil
	local var2 = getProxy(ChapterProxy):PopActBossRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = ActivityBossTotalRewardPanelMediator,
		viewComponent = ActivityBossTotalRewardPanel,
		data = {
			onClose = function()
				arg0.viewComponent:emit(BaseUI.ON_BACK)
			end,
			stopReason = arg1,
			rewards = var2,
			isAutoFight = var1,
			continuousBattleTimes = arg0.contextData.continuousBattleTimes,
			totalBattleTimes = arg0.contextData.totalBattleTimes
		}
	}))
end

function var0.DisplayBossSingleTotalReward(arg0, arg1)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)
	local var1 = var0 and var0.data.autoFlag or nil
	local var2 = getProxy(ChapterProxy):PopBossSingleRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = BossSingleTotalRewardPanelMediator,
		viewComponent = BossSingleTotalRewardPanel,
		data = {
			onClose = function()
				arg0.viewComponent:emit(BaseUI.ON_BACK)
			end,
			stopReason = arg1,
			rewards = var2,
			isAutoFight = var1,
			continuousBattleTimes = arg0.contextData.continuousBattleTimes,
			totalBattleTimes = arg0.contextData.totalBattleTimes
		}
	}))
end

function var0.GetResultView(arg0)
	var0.RESULT_VIEW_TRANSFORM = var0.RESULT_VIEW_TRANSFORM or {
		[SYSTEM_CHALLENGE] = BattleChallengeResultLayer,
		[SYSTEM_DODGEM] = BattleDodgemResultLayer,
		[SYSTEM_SUBMARINE_RUN] = BattleSubmarineRunResultLayer,
		[SYSTEM_SUB_ROUTINE] = BattleSubmarineRoutineResultLayer,
		[SYSTEM_HP_SHARE_ACT_BOSS] = BattleContributionResultLayer,
		[SYSTEM_BOSS_EXPERIMENT] = BattleExperimentResultLayer,
		[SYSTEM_ACT_BOSS] = BattleActivityBossResultLayer,
		[SYSTEM_WORLD_BOSS] = BattleWorldBossResultLayer,
		[SYSTEM_REWARD_PERFORM] = BattleRewardPerformResultLayer,
		[SYSTEM_AIRFIGHT] = BattleAirFightResultLayer,
		[SYSTEM_GUILD] = BattleGuildBossResultLayer,
		[SYSTEM_CARDPUZZLE] = BattleAirFightResultLayer
	}

	return var0.RESULT_VIEW_TRANSFORM[arg0] or BattleResultLayer
end

return var0
