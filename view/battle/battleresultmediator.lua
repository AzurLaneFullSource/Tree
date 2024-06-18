local var0_0 = class("BattleResultMediator", import("..base.ContextMediator"))

var0_0.ON_BACK_TO_LEVEL_SCENE = "BattleResultMediator.ON_BACK_TO_LEVEL_SCENE"
var0_0.ON_BACK_TO_DUEL_SCENE = "BattleResultMediator.ON_BACK_TO_DUEL_SCENE"
var0_0.ON_GO_TO_TASK_SCENE = "BattleResultMediator.ON_GO_TO_TASK_SCENE"
var0_0.GET_NEW_SHIP = "BattleResultMediator.GET_NEW_SHIP"
var0_0.ON_GO_TO_MAIN_SCENE = "BattleResultMediator.ON_GO_TO_MAIN_SCENE"
var0_0.ON_NEXT_CHALLENGE = "BattleResultMediator.ON_NEXT_CHALLENGE"
var0_0.ON_CHALLENGE_RANK = "BattleResultMediator:ON_CHALLENGE_RANK"
var0_0.ON_CHALLENGE_SHARE = "BattleResultMediator:ON_CHALLENGE_SHARE"
var0_0.ON_CHALLENGE_DEFEAT_SCENE = "BattleResultMediator:ON_CHALLENGE_DEFEAT_SCENE"
var0_0.DIRECT_EXIT = "BattleResultMediator:DIRECT_EXIT"
var0_0.REENTER_STAGE = "BattleResultMediator:REENTER_STAGE"
var0_0.OPEN_FAIL_TIP_LAYER = "BattleResultMediator:OPEN_FAIL_TIP_LAYER"
var0_0.PRE_BATTLE_FAIL_EXIT = "BattleResultMediator:PRE_BATTLE_FAIL_EXIT"
var0_0.ON_ENTER_BATTLE_RESULT = "BattleResultMediator:ON_ENTER_BATTLE_RESULT"
var0_0.SET_SKIP_FLAG = "BattleResultMediator:SET_SKIP_FLAG"
var0_0.ON_COMPLETE_BATTLE_RESULT = "BattleResultMediator:ON_COMPLETE_BATTLE_RESULT"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getData()
	local var1_1 = getProxy(FleetProxy)
	local var2_1 = getProxy(BayProxy)
	local var3_1 = getProxy(ChapterProxy)
	local var4_1 = getProxy(ActivityProxy)
	local var5_1 = arg0_1.contextData.system

	if var5_1 == SYSTEM_DUEL then
		local var6_1 = getProxy(MilitaryExerciseProxy)
		local var7_1 = var6_1:getPreRivalById(arg0_1.contextData.rivalId)

		assert(var7_1, "should exist rival--" .. arg0_1.contextData.rivalId)
		arg0_1.viewComponent:setRivalVO(var7_1)
		arg0_1.viewComponent:setRank(var0_1, var6_1:getSeasonInfo())
	elseif var5_1 == SYSTEM_CHALLENGE then
		local var8_1 = getProxy(ChallengeProxy)
		local var9_1 = var8_1:getUserChallengeInfo(arg0_1.contextData.mode)

		arg0_1.viewComponent:setChallengeInfo(var9_1, var8_1:userSeaonExpire(arg0_1.contextData.mode))
	else
		if var5_1 == SYSTEM_SCENARIO or var5_1 == SYSTEM_ROUTINE or var5_1 == SYSTEM_ACT_BOSS or var5_1 == SYSTEM_BOSS_SINGLE or var5_1 == SYSTEM_HP_SHARE_ACT_BOSS or var5_1 == SYSTEM_SUB_ROUTINE or var5_1 == SYSTEM_WORLD then
			local var10_1 = _.detect(BuffHelper.GetBuffsByActivityType(ActivityConst.ACTIVITY_TYPE_BUFF), function(arg0_2)
				return arg0_2:getConfig("benefit_type") == "rookie_battle_exp"
			end)
			local var11_1 = var4_1:getBuffShipList()

			arg0_1.viewComponent:setExpBuff(var10_1, var11_1)
		end

		arg0_1.viewComponent:setPlayer(var0_1)
	end

	local var12_1

	if var5_1 == SYSTEM_SCENARIO then
		var12_1 = {}

		local var13_1

		if var5_1 == SYSTEM_SCENARIO then
			var13_1 = var3_1:getActiveChapter()
		end

		local var14_1 = var13_1.fleet
		local var15_1 = var14_1[TeamType.Main]
		local var16_1 = var14_1[TeamType.Vanguard]

		for iter0_1, iter1_1 in ipairs(var15_1) do
			table.insert(var12_1, iter1_1)
		end

		for iter2_1, iter3_1 in ipairs(var16_1) do
			table.insert(var12_1, iter3_1)
		end

		local var17_1 = _.detect(var13_1.fleets, function(arg0_3)
			return arg0_3:getFleetType() == FleetType.Submarine
		end)

		if var17_1 then
			local var18_1 = var17_1:getShipsByTeam(TeamType.Submarine, true)

			for iter4_1, iter5_1 in ipairs(var18_1) do
				table.insert(var12_1, iter5_1)
			end
		end

		arg0_1.viewComponent:SetSkipFlag(var3_1:GetChapterAutoFlag(var13_1.id) == 1)
	elseif var5_1 == SYSTEM_WORLD then
		var12_1 = {}

		local var19_1 = nowWorld()
		local var20_1 = var19_1:GetActiveMap()
		local var21_1 = var20_1:GetFleet()
		local var22_1 = var21_1:GetTeamShipVOs(TeamType.Main, true)
		local var23_1 = var21_1:GetTeamShipVOs(TeamType.Vanguard, true)

		for iter6_1, iter7_1 in ipairs(var22_1) do
			table.insert(var12_1, iter7_1)
		end

		for iter8_1, iter9_1 in ipairs(var23_1) do
			table.insert(var12_1, iter9_1)
		end

		local var24_1 = var20_1:GetSubmarineFleet()

		if var24_1 then
			local var25_1 = var24_1:GetTeamShipVOs(TeamType.Submarine, true)

			for iter10_1, iter11_1 in ipairs(var25_1) do
				table.insert(var12_1, iter11_1)
			end
		end

		arg0_1.viewComponent:SetSkipFlag(var19_1.isAutoFight)
	elseif var5_1 == SYSTEM_CHALLENGE then
		arg0_1:bind(var0_0.ON_CHALLENGE_SHARE, function(arg0_4)
			arg0_1:addSubLayers(Context.New({
				mediator = ChallengeShareMediator,
				viewComponent = ChallengeShareLayer,
				data = {
					mode = arg0_1.contextData.mode
				}
			}))
		end)
		arg0_1:bind(var0_0.ON_CHALLENGE_DEFEAT_SCENE, function(arg0_5, arg1_5)
			local var0_5 = arg1_5.callback

			arg0_1:addSubLayers(Context.New({
				mediator = ChallengePassedMediator,
				viewComponent = ChallengePassedLayer,
				data = {
					mode = arg0_1.contextData.mode
				},
				onRemoved = var0_5
			}))
		end)
	elseif var5_1 == SYSTEM_WORLD_BOSS then
		local var26_1 = nowWorld():GetBossProxy():GetFleet(arg0_1.contextData.bossId)

		var12_1 = getProxy(BayProxy):getShipsByFleet(var26_1)

		local var27_1 = arg0_1.contextData.name

		arg0_1.viewComponent:setTitle(var27_1)
	elseif var5_1 == SYSTEM_DODGEM then
		-- block empty
	elseif var5_1 == SYSTEM_SUBMARINE_RUN then
		-- block empty
	elseif var5_1 == SYSTEM_REWARD_PERFORM then
		-- block empty
	elseif var5_1 == SYSTEM_AIRFIGHT then
		-- block empty
	elseif var5_1 == SYSTEM_CARDPUZZLE then
		-- block empty
	elseif var5_1 == SYSTEM_HP_SHARE_ACT_BOSS or var5_1 == SYSTEM_ACT_BOSS or var5_1 == SYSTEM_BOSS_SINGLE or var5_1 == SYSTEM_BOSS_EXPERIMENT then
		local var28_1 = arg0_1.contextData.actId

		if var5_1 == SYSTEM_HP_SHARE_ACT_BOSS then
			arg0_1.viewComponent:setActId(var28_1)
		end

		local var29_1 = var1_1:getActivityFleets()[var28_1]
		local var30_1 = var29_1[arg0_1.contextData.mainFleetId]

		var12_1 = var2_1:getShipsByFleet(var30_1)

		local var31_1 = var29_1[arg0_1.contextData.mainFleetId + 10]
		local var32_1 = var2_1:getShipsByFleet(var31_1)

		for iter12_1, iter13_1 in ipairs(var32_1) do
			table.insert(var12_1, iter13_1)
		end
	elseif var5_1 == SYSTEM_GUILD then
		var12_1 = {}

		local var33_1 = getProxy(GuildProxy):getData():GetActiveEvent():GetBossMission()
		local var34_1 = var33_1:GetMainFleet()

		for iter14_1, iter15_1 in ipairs(var34_1:GetShips()) do
			table.insert(var12_1, iter15_1.ship)
		end

		local var35_1 = var33_1:GetSubFleet()

		for iter16_1, iter17_1 in ipairs(var35_1:GetShips()) do
			table.insert(var12_1, iter17_1.ship)
		end
	elseif var5_1 == SYSTEM_BOSS_RUSH or var5_1 == SYSTEM_BOSS_RUSH_EX then
		local var36_1 = arg0_1.contextData.actId
		local var37_1 = getProxy(ActivityProxy):getActivityById(var36_1):GetSeriesData()

		assert(var37_1)

		local var38_1 = var37_1:GetStaegLevel()
		local var39_1 = var37_1:GetFleetIds()
		local var40_1 = var39_1[var38_1]

		if var37_1:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var40_1 = var39_1[1]
		end

		local var41_1 = var1_1:getActivityFleets()[var36_1][var40_1]

		var12_1 = var2_1:getShipsByFleet(var41_1)
	else
		local var42_1 = arg0_1.contextData.mainFleetId
		local var43_1 = var1_1:getFleetById(var42_1)

		var12_1 = var2_1:getShipsByFleet(var43_1)
	end

	arg0_1.viewComponent:setShips(var12_1)
	arg0_1:bind(var0_0.ON_BACK_TO_LEVEL_SCENE, function(arg0_6, arg1_6)
		local var0_6 = getProxy(ContextProxy)

		if var5_1 == SYSTEM_DUEL then
			arg0_1.viewComponent:emit(BattleResultMediator.ON_BACK_TO_DUEL_SCENE)

			return
		elseif var5_1 == SYSTEM_ACT_BOSS then
			local var1_6, var2_6 = var0_6:getContextByMediator(PreCombatMediator)

			if var1_6 then
				var2_6:removeChild(var1_6)
			end

			if var0_6:getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				arg0_1:sendNotification(ContinuousOperationMediator.CONTINUE_OPERATION)
				existCall(arg0_1.viewComponent.HideConfirmPanel, arg0_1.viewComponent)

				local var3_6 = getProxy(ActivityProxy):getActivityById(arg0_1.contextData.actId)
				local var4_6 = var3_6:getConfig("config_id")
				local var5_6 = pg.activity_event_worldboss[var4_6]
				local var6_6 = var3_6:IsOilLimit(arg0_1.contextData.stageId)
				local var7_6 = getProxy(FleetProxy):getActivityFleets()[arg0_1.contextData.actId]
				local var8_6 = 0
				local var9_6 = var5_6.use_oil_limit[arg0_1.contextData.mainFleetId]

				local function var10_6(arg0_7, arg1_7)
					local var0_7 = arg0_7:GetCostSum().oil

					if arg1_7 > 0 then
						var0_7 = math.min(var0_7, arg1_7)
					end

					var8_6 = var8_6 + var0_7
				end

				var10_6(var7_6[arg0_1.contextData.mainFleetId], var6_6 and var9_6[1] or 0)
				var10_6(var7_6[arg0_1.contextData.mainFleetId + 10], var6_6 and var9_6[2] or 0)

				if var8_6 > getProxy(PlayerProxy):getRawData().oil then
					local var11_6 = i18n("multiple_sorties_stop_reason1")

					arg0_1:DisplayTotalReward(var11_6)

					return
				end

				if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
					local var12_6 = i18n("multiple_sorties_stop_reason3")

					arg0_1:DisplayTotalReward(var12_6)

					return
				end

				local var13_6 = var7_6[arg0_1.contextData.mainFleetId]
				local var14_6 = _.map(_.values(var13_6.ships), function(arg0_8)
					local var0_8 = getProxy(BayProxy):getShipById(arg0_8)

					if var0_8 and var0_8.energy == Ship.ENERGY_LOW then
						return var0_8
					end
				end)

				if #var14_6 > 0 then
					local var15_6 = Fleet.DEFAULT_NAME_BOSS_ACT[arg0_1.contextData.mainFleetId]
					local var16_6 = _.map(var14_6, function(arg0_9)
						return "「" .. arg0_9:getConfig("name") .. "」"
					end)
					local var17_6 = i18n("multiple_sorties_stop_reason2", var15_6, table.concat(var16_6, ""))

					arg0_1:DisplayTotalReward(var17_6)

					return
				end

				if arg0_1.contextData.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
					local var18_6 = i18n("multiple_sorties_stop_reason4")

					arg0_1:DisplayTotalReward(var18_6)

					return
				end

				local var19_6 = pg.GuildMsgBoxMgr.GetInstance()

				if var19_6:GetShouldShowBattleTip() then
					local var20_6 = getProxy(GuildProxy):getRawData()
					local var21_6 = var20_6 and var20_6:getWeeklyTask()

					if var21_6 and var21_6.id ~= 0 then
						var19_6:SubmitTask(function(arg0_10, arg1_10)
							if arg1_10 then
								var19_6:CancelShouldShowBattleTip()
							end
						end)
					end
				end

				local var22_6 = var0_6:getCurrentContext():getContextByMediator(ContinuousOperationMediator)

				if var22_6 and not var22_6.data.autoFlag then
					arg0_1:DisplayTotalReward()

					return
				end

				if arg0_1.contextData.continuousBattleTimes < 1 then
					arg0_1:DisplayTotalReward()

					return
				end

				arg0_1:sendNotification(BattleResultMediator.ON_COMPLETE_BATTLE_RESULT)

				return
			end
		elseif var5_1 == SYSTEM_ROUTINE or var5_1 == SYSTEM_SUB_ROUTINE then
			local var23_6 = var0_6:getContextByMediator(DailyLevelMediator)

			if var23_6 then
				local var24_6 = var23_6:getContextByMediator(PreCombatMediator)

				var23_6:removeChild(var24_6)
			end
		elseif var5_1 == SYSTEM_SCENARIO then
			local var25_6 = var0_6:getContextByMediator(LevelMediator2)
			local var26_6 = var25_6:getContextByMediator(ChapterPreCombatMediator)

			if var26_6 then
				var25_6:removeChild(var26_6)
			end

			if arg0_1.contextData.score > 1 then
				arg0_1:showExtraChapterActSocre()
			end

			local var27_6 = getProxy(ChapterProxy)
			local var28_6 = var27_6:getActiveChapter()

			if var28_6 then
				if var28_6:existOni() then
					var28_6:clearSubmarineFleet()
					var27_6:updateChapter(var28_6)
				elseif var28_6:isPlayingWithBombEnemy() then
					var28_6.fleets = {
						var28_6.fleet
					}
					var28_6.findex = 1

					var27_6:updateChapter(var28_6)
				end
			end
		elseif var5_1 == SYSTEM_CHALLENGE then
			local var29_6 = getProxy(ChallengeProxy)
			local var30_6 = arg0_1.contextData.mode
			local var31_6 = var29_6:getUserChallengeInfo(var30_6)

			if arg0_1.contextData.score < ys.Battle.BattleConst.BattleScore.S then
				arg0_1:sendNotification(GAME.CHALLENGE2_RESET, {
					mode = var30_6
				})
			else
				local var32_6 = var31_6:IsFinish()

				var31_6:updateLevelForward()

				if var31_6:getMode() == ChallengeProxy.MODE_INFINITE and var32_6 then
					var31_6:setInfiniteDungeonIDListByLevel()
				end
			end

			local var33_6 = var29_6:getChallengeInfo()

			if not var29_6:userSeaonExpire(var31_6:getMode()) then
				var33_6:checkRecord(var31_6)
			end

			if not arg1_6.goToNext then
				local var34_6 = var0_6:getContextByMediator(ChallengeMainMediator)

				if var34_6 then
					local var35_6 = var34_6:getContextByMediator(ChallengePreCombatMediator)

					var34_6:removeChild(var35_6)
				end
			end
		elseif var5_1 == SYSTEM_HP_SHARE_ACT_BOSS then
			local var36_6, var37_6 = var0_6:getContextByMediator(PreCombatMediator)

			if var36_6 then
				var37_6:removeChild(var36_6)
			end
		elseif var5_1 == SYSTEM_WORLD_BOSS then
			local var38_6 = var0_6:getContextByMediator(WorldBossMediator)
			local var39_6 = var38_6:getContextByMediator(WorldBossFormationMediator)

			if var39_6 then
				var38_6:removeChild(var39_6)
			end
		elseif var5_1 == SYSTEM_WORLD then
			local var40_6 = var0_6:getContextByMediator(WorldMediator)
			local var41_6 = var40_6:getContextByMediator(WorldPreCombatMediator) or var40_6:getContextByMediator(WorldBossInformationMediator)

			if var41_6 then
				var40_6:removeChild(var41_6)
			end
		elseif var5_1 == SYSTEM_BOSS_RUSH or var5_1 == SYSTEM_BOSS_RUSH_EX then
			local var42_6 = arg0_1.contextData.score > ys.Battle.BattleConst.BattleScore.C
			local var43_6 = arg0_1.contextData.actId
			local var44_6 = getProxy(ActivityProxy):getActivityById(var43_6):GetSeriesData()

			assert(var44_6)

			local var45_6 = var44_6:GetStaegLevel() + 1
			local var46_6 = var44_6:GetExpeditionIds()
			local var47_6 = var0_6:getCurrentContext():getContextByMediator(ContinuousOperationMediator)
			local var48_6 = not var47_6 or var47_6.data.autoFlag

			if var0_6:getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				local var49_6 = pg.GuildMsgBoxMgr.GetInstance()

				if var49_6:GetShouldShowBattleTip() then
					local var50_6 = getProxy(GuildProxy):getRawData()
					local var51_6 = var50_6 and var50_6:getWeeklyTask()

					if var51_6 and var51_6.id ~= 0 then
						var49_6:SubmitTask(function(arg0_11, arg1_11)
							if arg1_11 then
								var49_6:CancelShouldShowBattleTip()
							end
						end)
					end
				end
			end

			if not var42_6 or var45_6 > #var46_6 or not var48_6 then
				local var52_6 = var0_6:GetPrevContext(1)
				local var53_6 = var52_6:getContextByMediator(BossRushPreCombatMediator)

				if var53_6 then
					var52_6:removeChild(var53_6)
				end

				local var54_6 = var52_6:getContextByMediator(BossRushFleetSelectMediator)

				if var54_6 then
					var52_6:removeChild(var54_6)
				end

				arg0_1:sendNotification(GAME.BOSSRUSH_SETTLE, {
					actId = arg0_1.contextData.actId
				})
			else
				seriesAsync({
					function(arg0_12)
						arg0_1:addSubLayers(Context.New({
							mediator = ChallengePassedMediator,
							viewComponent = BossRushPassedLayer,
							data = {
								curIndex = var45_6 - 1,
								maxIndex = #var46_6
							},
							onRemoved = arg0_12
						}))
					end,
					function(arg0_13)
						arg0_1:sendNotification(GAME.BEGIN_STAGE, {
							system = arg0_1.contextData.system,
							actId = var43_6,
							continuousBattleTimes = arg0_1.contextData.continuousBattleTimes,
							totalBattleTimes = arg0_1.contextData.totalBattleTimes
						})
					end
				})
			end

			return
		elseif var5_1 == SYSTEM_CARDPUZZLE then
			-- block empty
		elseif var5_1 == SYSTEM_BOSS_SINGLE then
			local var55_6, var56_6 = var0_6:getContextByMediator(PreCombatMediator)

			if var55_6 then
				var56_6:removeChild(var55_6)
			end

			if var0_6:getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
				arg0_1:sendNotification(BossSingleContinuousOperationMediator.CONTINUE_OPERATION)
				existCall(arg0_1.viewComponent.HideConfirmPanel, arg0_1.viewComponent)

				local var57_6 = getProxy(ActivityProxy):getActivityById(arg0_1.contextData.actId)
				local var58_6 = getProxy(FleetProxy):getActivityFleets()[arg0_1.contextData.actId]
				local var59_6 = 0
				local var60_6 = var57_6:GetOilLimits()[arg0_1.contextData.mainFleetId]

				local function var61_6(arg0_14, arg1_14)
					local var0_14 = arg0_14:GetCostSum().oil

					if arg1_14 > 0 then
						var0_14 = math.min(var0_14, arg1_14)
					end

					var59_6 = var59_6 + var0_14
				end

				var61_6(var58_6[arg0_1.contextData.mainFleetId], var60_6[1] or 0)
				var61_6(var58_6[arg0_1.contextData.mainFleetId + 10], var60_6[2] or 0)

				if var59_6 > getProxy(PlayerProxy):getRawData().oil then
					local var62_6 = i18n("multiple_sorties_stop_reason1")

					arg0_1:DisplayBossSingleTotalReward(var62_6)

					return
				end

				if getProxy(BayProxy):getShipCount() >= getProxy(PlayerProxy):getRawData():getMaxShipBag() then
					local var63_6 = i18n("multiple_sorties_stop_reason3")

					arg0_1:DisplayBossSingleTotalReward(var63_6)

					return
				end

				local var64_6 = var58_6[arg0_1.contextData.mainFleetId]
				local var65_6 = _.map(_.values(var64_6.ships), function(arg0_15)
					local var0_15 = getProxy(BayProxy):getShipById(arg0_15)

					if var0_15 and var0_15.energy == Ship.ENERGY_LOW then
						return var0_15
					end
				end)

				if #var65_6 > 0 then
					local var66_6 = Fleet.DEFAULT_NAME_BOSS_ACT[arg0_1.contextData.mainFleetId]
					local var67_6 = _.map(var65_6, function(arg0_16)
						return "「" .. arg0_16:getConfig("name") .. "」"
					end)
					local var68_6 = i18n("multiple_sorties_stop_reason2", var66_6, table.concat(var67_6, ""))

					arg0_1:DisplayBossSingleTotalReward(var68_6)

					return
				end

				if arg0_1.contextData.statistics._battleScore <= ys.Battle.BattleConst.BattleScore.C then
					local var69_6 = i18n("multiple_sorties_stop_reason4")

					arg0_1:DisplayBossSingleTotalReward(var69_6)

					return
				end

				local var70_6 = pg.GuildMsgBoxMgr.GetInstance()

				if var70_6:GetShouldShowBattleTip() then
					local var71_6 = getProxy(GuildProxy):getRawData()
					local var72_6 = var71_6 and var71_6:getWeeklyTask()

					if var72_6 and var72_6.id ~= 0 then
						var70_6:SubmitTask(function(arg0_17, arg1_17)
							if arg1_17 then
								var70_6:CancelShouldShowBattleTip()
							end
						end)
					end
				end

				local var73_6 = var0_6:getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)

				if var73_6 and not var73_6.data.autoFlag then
					arg0_1:DisplayBossSingleTotalReward()

					return
				end

				if arg0_1.contextData.continuousBattleTimes < 1 then
					arg0_1:DisplayBossSingleTotalReward()

					return
				end

				arg0_1:sendNotification(BattleResultMediator.ON_COMPLETE_BATTLE_RESULT)

				return
			end
		else
			local var74_6 = var0_6:getContextByMediator(LevelMediator2)

			if var74_6 then
				local var75_6 = var74_6:getContextByMediator(PreCombatMediator)

				var74_6:removeChild(var75_6)
			end
		end

		arg0_1:sendNotification(GAME.GO_BACK)
	end)
	arg0_1:bind(var0_0.ON_GO_TO_MAIN_SCENE, function(arg0_18)
		arg0_1:sendNotification(GAME.CHANGE_SCENE, SCENE.MAINUI)
	end)
	arg0_1:bind(var0_0.ON_GO_TO_TASK_SCENE, function(arg0_19)
		local var0_19 = getProxy(ContextProxy):getContextByMediator(LevelMediator2)

		if var0_19 then
			local var1_19 = var0_19:getContextByMediator(PreCombatMediator)

			var0_19:removeChild(var1_19)
		end

		arg0_1:sendNotification(GAME.CHANGE_SCENE, SCENE.TASK)
	end)
	arg0_1:bind(var0_0.ON_BACK_TO_DUEL_SCENE, function(arg0_20)
		local var0_20 = getProxy(ContextProxy):getContextByMediator(MilitaryExerciseMediator)

		if var0_20 then
			local var1_20 = var0_20:getContextByMediator(ExercisePreCombatMediator)

			var0_20:removeChild(var1_20)
		end

		arg0_1:sendNotification(GAME.GO_BACK)
	end)
	arg0_1:bind(var0_0.GET_NEW_SHIP, function(arg0_21, arg1_21, arg2_21, arg3_21)
		arg0_1:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = arg1_21,
				autoExitTime = arg3_21
			},
			onRemoved = arg2_21
		}))
	end)
	arg0_1:bind(var0_0.OPEN_FAIL_TIP_LAYER, function(arg0_22)
		setActive(arg0_1.viewComponent._tf, false)
		arg0_1:addSubLayers(Context.New({
			mediator = BattleFailTipMediator,
			viewComponent = BattleFailTipLayer,
			data = {
				mainShips = var12_1,
				battleSystem = arg0_1.contextData.system
			},
			onRemoved = function()
				arg0_1.viewComponent:emit(BattleResultMediator.ON_BACK_TO_DUEL_SCENE)
			end
		}))
	end)
	arg0_1:bind(var0_0.DIRECT_EXIT, function(arg0_24, arg1_24)
		arg0_1:sendNotification(GAME.GO_BACK)
	end)
	arg0_1:bind(var0_0.REENTER_STAGE, function(arg0_25)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			stageId = arg0_1.contextData.stageId,
			mainFleetId = arg0_1.contextData.mainFleetId,
			system = arg0_1.contextData.system,
			actId = arg0_1.contextData.actId,
			rivalId = arg0_1.contextData.rivalId,
			continuousBattleTimes = arg0_1.contextData.continuousBattleTimes,
			totalBattleTimes = arg0_1.contextData.totalBattleTimes
		})
	end)
	arg0_1:bind(var0_0.PRE_BATTLE_FAIL_EXIT, function(arg0_26)
		if var5_1 == SYSTEM_SCENARIO then
			getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.BATTLE_FAILED)
		end
	end)
	arg0_1:bind(GAME.ACT_BOSS_EXCHANGE_TICKET, function(arg0_27, arg1_27)
		arg0_1:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
			stageId = arg1_27
		})
	end)

	local var44_1 = 0

	if var12_1 then
		for iter18_1, iter19_1 in ipairs(var12_1) do
			var44_1 = iter19_1:getBattleTotalExpend() + var44_1
		end
	end

	originalPrint("耗时：", arg0_1.contextData.statistics._totalTime, "秒")
	originalPrint("编队基础油耗：", var44_1)

	if arg0_1.contextData.statistics._enemyInfoList then
		for iter20_1, iter21_1 in pairs(arg0_1.contextData.statistics._enemyInfoList) do
			originalPrint("目标ID>>", iter21_1.id, "<< 受到伤害共 >>", iter21_1.damage, "<< 点")
		end
	end

	local var45_1 = false

	if var5_1 == SYSTEM_SCENARIO then
		local var46_1 = var3_1:getActiveChapter()

		var45_1 = getProxy(ChapterProxy):GetChapterAutoFlag(var46_1.id) == 1
	elseif var5_1 == SYSTEM_WORLD then
		var45_1 = nowWorld().isAutoFight
	end

	local var47_1 = PlayerPrefs.GetInt(AUTO_BATTLE_LABEL, 0) > 0

	if ys.Battle.BattleState.IsAutoBotActive() and var47_1 and not var45_1 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_AUTO_BATTLE)
		LuaHelper.Vibrate()
	end

	arg0_1:sendNotification(var0_0.ON_ENTER_BATTLE_RESULT)
end

function var0_0.showExtraChapterActSocre(arg0_28)
	local var0_28 = getProxy(ActivityProxy)
	local var1_28 = var0_28:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_EXTRA_CHAPTER_RANK)
	local var2_28 = getProxy(ChapterProxy)
	local var3_28 = var2_28:getActiveChapter()
	local var4_28 = var3_28 and var2_28:getMapById(var3_28:getConfig("map"))

	for iter0_28, iter1_28 in ipairs(var1_28) do
		if iter1_28 and not iter1_28:isEnd() then
			local var5_28 = iter1_28:getConfig("config_data")
			local var6_28 = arg0_28.contextData.stageId

			if var5_28[1] == var6_28 and var4_28 and var4_28:isActExtra() then
				local var7_28 = math.floor(arg0_28.contextData.statistics._totalTime)
				local var8_28 = ActivityLevelConst.getShipsPower(arg0_28.contextData.prefabFleet or arg0_28.contextData.oldMainShips)
				local var9_28, var10_28 = ActivityLevelConst.getExtraChapterSocre(var6_28, var7_28, var8_28, iter1_28)
				local var11_28 = var10_28 < var9_28 and i18n("extra_chapter_record_updated") or i18n("extra_chapter_record_not_updated")

				if var10_28 < var9_28 then
					iter1_28.data1 = var9_28

					var0_28:updateActivity(iter1_28)

					var10_28 = var9_28
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					hideNo = true,
					content = i18n("extra_chapter_socre_tip", var9_28, var10_28, var11_28),
					weight = LayerWeightConst.SECOND_LAYER
				})
			end
		end
	end
end

function var0_0.listNotificationInterests(arg0_29)
	return {
		GAME.BEGIN_STAGE_DONE,
		GAME.ACT_BOSS_EXCHANGE_TICKET_DONE,
		ContinuousOperationMediator.CONTINUE_OPERATION,
		var0_0.SET_SKIP_FLAG,
		GAME.BOSSRUSH_SETTLE_DONE,
		ContinuousOperationMediator.ON_REENTER,
		BossSingleContinuousOperationMediator.CONTINUE_OPERATION,
		BossSingleContinuousOperationMediator.ON_REENTER
	}
end

function var0_0.handleNotification(arg0_30, arg1_30)
	local var0_30 = arg1_30:getName()
	local var1_30 = arg1_30:getBody()

	if var0_30 == GAME.BEGIN_STAGE_DONE then
		arg0_30:sendNotification(GAME.CHANGE_SCENE, SCENE.COMBATLOAD, var1_30)
	elseif var0_30 == GAME.ACT_BOSS_EXCHANGE_TICKET_DONE then
		existCall(arg0_30.viewComponent.OnActBossExchangeTicket, arg0_30.viewComponent)
	elseif var0_30 == var0_0.SET_SKIP_FLAG then
		arg0_30.viewComponent:SetSkipFlag(var1_30)
	elseif var0_30 == ContinuousOperationMediator.CONTINUE_OPERATION then
		arg0_30.contextData.continuousBattleTimes = arg0_30.contextData.continuousBattleTimes - 1
	elseif var0_30 == GAME.BOSSRUSH_SETTLE_DONE then
		local var2_30 = arg0_30.contextData.system
		local var3_30 = arg0_30.contextData.actId
		local var4_30 = var1_30.seriesData
		local var5_30 = arg0_30.contextData.score > ys.Battle.BattleConst.BattleScore.C

		if not var5_30 and var2_30 == SYSTEM_BOSS_RUSH_EX then
			arg0_30.viewComponent:emit(BattleResultMediator.OPEN_FAIL_TIP_LAYER)

			return
		end

		local var6_30 = var2_30 == SYSTEM_BOSS_RUSH and BossRushBattleResultMediator or BossRushBattleResultMediator
		local var7_30 = var2_30 == SYSTEM_BOSS_RUSH and BossRushBattleResultLayer or BossRushEXBattleResultLayer

		arg0_30:addSubLayers(Context.New({
			mediator = var6_30,
			viewComponent = var7_30,
			data = {
				awards = var1_30.awards,
				system = arg0_30.contextData.system,
				actId = var3_30,
				seriesData = var4_30,
				win = var5_30
			}
		}), true)
		arg0_30.viewComponent:closeView()
	elseif var0_30 == ContinuousOperationMediator.ON_REENTER then
		if not var1_30.autoFlag then
			arg0_30:DisplayTotalReward()

			return
		end

		local var8_30 = getProxy(ActivityProxy):getActivityById(arg0_30.contextData.actId)
		local var9_30 = var8_30:getConfig("config_id")
		local var10_30 = pg.activity_event_worldboss[var9_30].ticket
		local var11_30 = getProxy(PlayerProxy):getRawData():getResource(var10_30)

		if var8_30:GetStageBonus(arg0_30.contextData.stageId) == 0 and getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1 and var11_30 > 0 then
			arg0_30:sendNotification(GAME.ACT_BOSS_EXCHANGE_TICKET, {
				stageId = arg0_30.contextData.stageId
			})

			return
		end

		arg0_30.viewComponent:emit(var0_0.REENTER_STAGE)
	elseif var0_30 == BossSingleContinuousOperationMediator.CONTINUE_OPERATION then
		arg0_30.contextData.continuousBattleTimes = arg0_30.contextData.continuousBattleTimes - 1
	elseif var0_30 == BossSingleContinuousOperationMediator.ON_REENTER then
		if not var1_30.autoFlag then
			arg0_30:DisplayBossSingleTotalReward()

			return
		end

		arg0_30.viewComponent:emit(var0_0.REENTER_STAGE)
	end
end

function var0_0.DisplayTotalReward(arg0_31, arg1_31)
	local var0_31 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator)
	local var1_31 = var0_31 and var0_31.data.autoFlag or nil
	local var2_31 = getProxy(ChapterProxy):PopActBossRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = ActivityBossTotalRewardPanelMediator,
		viewComponent = ActivityBossTotalRewardPanel,
		data = {
			onClose = function()
				arg0_31.viewComponent:emit(BaseUI.ON_BACK)
			end,
			stopReason = arg1_31,
			rewards = var2_31,
			isAutoFight = var1_31,
			continuousBattleTimes = arg0_31.contextData.continuousBattleTimes,
			totalBattleTimes = arg0_31.contextData.totalBattleTimes
		}
	}))
end

function var0_0.DisplayBossSingleTotalReward(arg0_33, arg1_33)
	local var0_33 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator)
	local var1_33 = var0_33 and var0_33.data.autoFlag or nil
	local var2_33 = getProxy(ChapterProxy):PopBossSingleRewards()

	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = BossSingleTotalRewardPanelMediator,
		viewComponent = BossSingleTotalRewardPanel,
		data = {
			onClose = function()
				arg0_33.viewComponent:emit(BaseUI.ON_BACK)
			end,
			stopReason = arg1_33,
			rewards = var2_33,
			isAutoFight = var1_33,
			continuousBattleTimes = arg0_33.contextData.continuousBattleTimes,
			totalBattleTimes = arg0_33.contextData.totalBattleTimes
		}
	}))
end

function var0_0.GetResultView(arg0_35)
	var0_0.RESULT_VIEW_TRANSFORM = var0_0.RESULT_VIEW_TRANSFORM or {
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

	return var0_0.RESULT_VIEW_TRANSFORM[arg0_35] or BattleResultLayer
end

return var0_0
