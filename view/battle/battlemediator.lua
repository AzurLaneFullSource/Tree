local var0_0 = class("BattleMediator", import("..base.ContextMediator"))

var0_0.ON_BATTLE_RESULT = "BattleMediator:ON_BATTLE_RESULT"
var0_0.ON_PAUSE = "BattleMediator:ON_PAUSE"
var0_0.ENTER = "BattleMediator:ENTER"
var0_0.ON_BACK_PRE_SCENE = "BattleMediator:ON_BACK_PRE_SCENE"
var0_0.ON_LEAVE = "BattleMediator:ON_LEAVE"
var0_0.ON_QUIT_BATTLE_MANUALLY = "BattleMediator:ON_QUIT_BATTLE_MANUALLY"
var0_0.HIDE_ALL_BUTTONS = "BattleMediator:HIDE_ALL_BUTTONS"
var0_0.ON_CHAT = "BattleMediator:ON_CHAT"
var0_0.CLOSE_CHAT = "BattleMediator:CLOSE_CHAT"
var0_0.ON_AUTO = "BattleMediator:ON_AUTO"
var0_0.UPDATE_AUTO_COUNT = "BattleMediator:UPDATE_AUTO_COUNT"
var0_0.ON_PUZZLE_RELIC = "BattleMediator.ON_PUZZLE_RELIC"
var0_0.ON_PUZZLE_CARD = "BattleMediator.ON_PUZZLE_CARD"

function var0_0.register(arg0_1)
	pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(true)
	arg0_1:GenBattleData()

	arg0_1.contextData.battleData = arg0_1._battleData

	local var0_1 = ys.Battle.BattleState.GetInstance()
	local var1_1 = arg0_1.contextData.system

	arg0_1:bind(var0_0.ON_BATTLE_RESULT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.FINISH_STAGE, {
			token = arg0_1.contextData.token,
			mainFleetId = arg0_1.contextData.mainFleetId,
			stageId = arg0_1.contextData.stageId,
			rivalId = arg0_1.contextData.rivalId,
			memory = arg0_1.contextData.memory,
			bossId = arg0_1.contextData.bossId,
			exitCallback = arg0_1.contextData.exitCallback,
			system = var1_1,
			statistics = arg1_2,
			actId = arg0_1.contextData.actId,
			mode = arg0_1.contextData.mode,
			puzzleCombatID = arg0_1.contextData.puzzleCombatID,
			useVariableTicket = arg0_1.contextData.useVariableTicket,
			isSimulate = arg0_1.contextData.isSimulate
		})
	end)
	arg0_1:bind(var0_0.ON_AUTO, function(arg0_3, arg1_3)
		arg0_1:onAutoBtn(arg1_3)
	end)
	arg0_1:bind(var0_0.ON_PAUSE, function(arg0_4)
		arg0_1:onPauseBtn()
	end)
	arg0_1:bind(var0_0.ON_LEAVE, function(arg0_5)
		arg0_1:warnFunc()
	end)
	arg0_1:bind(var0_0.ON_CHAT, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			mediator = NotificationMediator,
			viewComponent = NotificationLayer,
			data = {
				form = NotificationLayer.FORM_BATTLE
			}
		}))
	end)
	arg0_1:bind(var0_0.ENTER, function(arg0_7)
		var0_1:EnterBattle(arg0_1._battleData, arg0_1.contextData.prePause)
	end)
	arg0_1:bind(var0_0.ON_BACK_PRE_SCENE, function()
		local var0_8 = getProxy(ContextProxy)
		local var1_8 = var0_8:getContextByMediator(DailyLevelMediator)
		local var2_8 = var0_8:getContextByMediator(LevelMediator2)
		local var3_8 = var0_8:getContextByMediator(ChallengeMainMediator)
		local var4_8 = var0_8:getContextByMediator(ActivityBossMediatorTemplate)
		local var5_8 = var0_8:getContextByMediator(WorldMediator)
		local var6_8 = var0_8:getContextByMediator(WorldBossMediator)
		local var7_8, var8_8 = var0_8:getContextByMediator(BossSinglePreCombatMediator)

		if var6_8 and arg0_1.contextData.bossId then
			arg0_1:sendNotification(GAME.WORLD_BOSS_BATTLE_QUIT, {
				id = arg0_1.contextData.bossId
			})

			local var9_8 = var6_8:getContextByMediator(WorldBossFormationMediator)

			if var9_8 then
				var6_8:removeChild(var9_8)
			end
		elseif var5_8 then
			local var10_8 = var5_8:getContextByMediator(WorldPreCombatMediator) or var5_8:getContextByMediator(WorldBossInformationMediator)

			if var10_8 then
				var5_8:removeChild(var10_8)
			end
		elseif var1_8 then
			local var11_8 = var1_8:getContextByMediator(PreCombatMediator)

			var1_8:removeChild(var11_8)
		elseif var3_8 then
			arg0_1:sendNotification(GAME.CHALLENGE2_RESET, {
				mode = arg0_1.contextData.mode
			})

			local var12_8 = var3_8:getContextByMediator(ChallengePreCombatMediator)

			var3_8:removeChild(var12_8)
		elseif var2_8 then
			if var1_1 == SYSTEM_DUEL then
				-- block empty
			elseif var1_1 == SYSTEM_SCENARIO then
				local var13_8 = var2_8:getContextByMediator(ChapterPreCombatMediator)

				if var13_8 then
					var2_8:removeChild(var13_8)
				end
			elseif var1_1 ~= SYSTEM_PERFORM and var1_1 ~= SYSTEM_SIMULATION then
				local var14_8 = var2_8:getContextByMediator(PreCombatMediator)

				if var14_8 then
					var2_8:removeChild(var14_8)
				end
			end
		elseif var4_8 then
			local var15_8 = var4_8:getContextByMediator(PreCombatMediator)

			if var15_8 then
				var4_8:removeChild(var15_8)
			end
		elseif var7_8 then
			local var16_8 = var8_8:removeChild(var7_8)
		end

		arg0_1:sendNotification(GAME.GO_BACK)
	end)
	arg0_1:bind(var0_0.ON_QUIT_BATTLE_MANUALLY, function(arg0_9)
		if var1_1 == SYSTEM_SCENARIO then
			getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.MANUAL)
		elseif var1_1 == SYSTEM_WORLD then
			nowWorld():TriggerAutoFight(false)
		elseif var1_1 == SYSTEM_ACT_BOSS then
			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				getProxy(ContextProxy):GetPrevContext(1):addChild(Context.New({
					mediator = ActivityBossTotalRewardPanelMediator,
					viewComponent = ActivityBossTotalRewardPanel,
					data = {
						isAutoFight = false,
						isLayer = true,
						rewards = getProxy(ChapterProxy):PopActBossRewards(),
						continuousBattleTimes = arg0_1.contextData.continuousBattleTimes,
						totalBattleTimes = arg0_1.contextData.totalBattleTimes
					}
				}))
			end
		elseif var1_1 == SYSTEM_BOSS_RUSH or var1_1 == SYSTEM_BOSS_RUSH_COLLABRATE then
			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				local var0_9 = getProxy(ActivityProxy):PopBossRushAwards()

				getProxy(ContextProxy):GetPrevContext(1):addChild(Context.New({
					mediator = BossRushTotalRewardPanelMediator,
					viewComponent = BossRushTotalRewardPanel,
					data = {
						isAutoFight = false,
						isLayer = true,
						rewards = var0_9
					}
				}))
			end
		elseif (var1_1 == SYSTEM_BOSS_SINGLE or var1_1 == SYSTEM_BOSS_SINGLE_VARIABLE) and getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
			getProxy(ContextProxy):GetPrevContext(1):addChild(Context.New({
				mediator = BossSingleTotalRewardPanelMediator,
				viewComponent = BossSingleTotalRewardPanel,
				data = {
					isAutoFight = false,
					isLayer = true,
					rewards = getProxy(ChapterProxy):PopBossSingleRewards(),
					continuousBattleTimes = arg0_1.contextData.continuousBattleTimes,
					totalBattleTimes = arg0_1.contextData.totalBattleTimes
				}
			}))
		end
	end)
	arg0_1:bind(var0_0.ON_PUZZLE_RELIC, function(arg0_10, arg1_10)
		arg0_1:addSubLayers(Context.New({
			mediator = CardPuzzleRelicDeckMediator,
			viewComponent = CardPuzzleRelicDeckLayerCombat,
			data = arg1_10
		}))
		var0_1:Pause()
	end)
	arg0_1:bind(var0_0.ON_PUZZLE_CARD, function(arg0_11, arg1_11)
		arg0_1:addSubLayers(Context.New({
			mediator = CardPuzzleCardDeckMediator,
			viewComponent = CardPuzzleCardDeckLayerCombat,
			data = arg1_11
		}))
		var0_1:Pause()
	end)

	if arg0_1.contextData.continuousBattleTimes and arg0_1.contextData.continuousBattleTimes > 0 then
		if var1_1 == SYSTEM_BOSS_SINGLE or var1_1 == SYSTEM_BOSS_SINGLE_VARIABLE then
			if not getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
				local var2_1 = CreateShell(arg0_1.contextData)

				arg0_1:addSubLayers(Context.New({
					mediator = BossSingleContinuousOperationMediator,
					viewComponent = BossSingleContinuousOperationPanel,
					data = var2_1
				}))
			end
		elseif not getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
			local var3_1 = CreateShell(arg0_1.contextData)

			arg0_1:addSubLayers(Context.New({
				mediator = ContinuousOperationMediator,
				viewComponent = ContinuousOperationPanel,
				data = var3_1
			}))
		end

		arg0_1.contextData.battleData.hideAllButtons = true
	end

	local var4_1 = getProxy(PlayerProxy)

	if var4_1 then
		arg0_1.player = var4_1:getData()

		var4_1:setFlag("battle", true)
	end
end

function var0_0.onAutoBtn(arg0_12, arg1_12)
	local var0_12 = arg1_12.isOn
	local var1_12 = arg1_12.toggle
	local var2_12 = arg1_12.system

	arg0_12:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_12,
		toggle = var1_12,
		system = var2_12
	})
end

function var0_0.updateAutoCount(arg0_13, arg1_13)
	local var0_13 = ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name):AutoStatistics(arg1_13.isOn)
end

function var0_0.onPauseBtn(arg0_14)
	local var0_14 = ys.Battle.BattleState.GetInstance()

	if arg0_14.contextData.system == SYSTEM_PROLOGUE or arg0_14.contextData.system == SYSTEM_PERFORM then
		local var1_14 = {}

		if EPILOGUE_SKIPPABLE then
			local var2_14 = {
				text = "关爱胡德",
				btnType = pg.MsgboxMgr.BUTTON_RED,
				onCallback = function()
					var0_14:Deactive()
					arg0_14:sendNotification(GAME.CHANGE_SCENE, SCENE.CREATE_PLAYER)
				end
			}

			table.insert(var1_14, 1, var2_14)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_rule"),
			onClose = function()
				ys.Battle.BattleState.GetInstance():Resume()
			end,
			onNo = function()
				ys.Battle.BattleState.GetInstance():Resume()
			end,
			custom = var1_14
		})
		var0_14:Pause()
	elseif arg0_14.contextData.system == SYSTEM_DODGEM then
		local var3_14 = {
			text = "text_cancel_fight",
			btnType = pg.MsgboxMgr.BUTTON_RED,
			onCallback = function()
				arg0_14:warnFunc(function()
					ys.Battle.BattleState.GetInstance():Resume()
				end)
			end
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_warspite"),
			onClose = function()
				ys.Battle.BattleState.GetInstance():Resume()
			end,
			onNo = function()
				ys.Battle.BattleState.GetInstance():Resume()
			end,
			custom = {
				var3_14
			}
		})
		var0_14:Pause()
	elseif arg0_14.contextData.system == SYSTEM_SIMULATION then
		local var4_14 = {
			text = "text_cancel_fight",
			btnType = pg.MsgboxMgr.BUTTON_RED,
			onCallback = function()
				arg0_14:warnFunc(function()
					ys.Battle.BattleState.GetInstance():Resume()
				end)
			end
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_battle_rule"),
			onClose = function()
				ys.Battle.BattleState.GetInstance():Resume()
			end,
			onNo = function()
				ys.Battle.BattleState.GetInstance():Resume()
			end,
			custom = {
				var4_14
			}
		})
		var0_14:Pause()
	elseif arg0_14.contextData.system == SYSTEM_SUBMARINE_RUN or arg0_14.contextData.system == SYSTEM_SUB_ROUTINE or arg0_14.contextData.system == SYSTEM_REWARD_PERFORM or arg0_14.contextData.system == SYSTEM_AIRFIGHT then
		var0_14:Pause()
		arg0_14:warnFunc(function()
			ys.Battle.BattleState.GetInstance():Resume()
		end)
	elseif arg0_14.contextData.system == SYSTEM_CARDPUZZLE then
		arg0_14:addSubLayers(Context.New({
			mediator = CardPuzzleCombatPauseMediator,
			viewComponent = CardPuzzleCombatPauseLayer
		}))
		var0_14:Pause()
	else
		arg0_14.viewComponent:updatePauseWindow()
		var0_14:Pause()
	end
end

function var0_0.warnFunc(arg0_27, arg1_27)
	local var0_27 = ys.Battle.BattleState.GetInstance()
	local var1_27 = arg0_27.contextData.system
	local var2_27
	local var3_27

	local function var4_27()
		var0_27:Stop()
	end

	local var5_27 = arg0_27.contextData.warnMsg

	if var5_27 and #var5_27 > 0 then
		var3_27 = i18n(var5_27)
	elseif var1_27 == SYSTEM_CHALLENGE then
		var3_27 = i18n("battle_battleMediator_clear_warning")
	elseif var1_27 == SYSTEM_SIMULATION then
		var3_27 = i18n("tech_simulate_quit")
	elseif var1_27 == SYSTEM_SCENARIO_SUB_STRIKE then
		var3_27 = i18n("battle_battleMediator_quest_exist_submarine_support")

		function var4_27()
			var0_27:GetCommandByName(ys.Battle.BattleScenarioSubStrikeCommand.__name):CalcBattleEnd()
			arg0_27.viewComponent:ClosePauseWindow()
		end
	else
		var3_27 = i18n("battle_battleMediator_quest_exist")
	end

	local function var6_27()
		if arg1_27 then
			arg1_27()
		end

		local var0_30 = arg0_27.viewComponent.leaveBtn:GetComponent(typeof(Animation))

		if var0_30 then
			var0_30:Play("msgbox_btn_into")
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideNo = true,
		hideYes = true,
		content = var3_27,
		onClose = var6_27,
		custom = {
			{
				text = "text_cancel",
				onCallback = var6_27,
				sound = SFX_CANCEL
			},
			{
				text = "text_exit",
				btnType = pg.MsgboxMgr.BUTTON_RED,
				onCallback = var4_27,
				sound = SFX_CONFIRM
			}
		}
	})
end

function var0_0.guideDispatch(arg0_31)
	return
end

local function var1_0(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = {}

	for iter0_32, iter1_32 in ipairs(arg1_32:getActiveEquipments()) do
		if iter1_32 then
			var0_32[#var0_32 + 1] = {
				id = iter1_32.configId,
				skin = iter1_32.skinId,
				equipmentInfo = iter1_32
			}
		else
			var0_32[#var0_32 + 1] = {
				skin = 0,
				id = iter1_32,
				equipmentInfo = iter1_32
			}
		end
	end

	local var1_32 = {}

	local function var2_32(arg0_33)
		local var0_33 = {
			level = arg0_33.level
		}
		local var1_33 = arg0_33.id
		local var2_33 = arg1_32:RemapSkillId(var1_33, true)

		var0_33.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_32, var2_33)

		return var0_33
	end

	local var3_32 = ys.Battle.BattleDataFunction.GenerateHiddenBuff(arg1_32.configId)

	for iter2_32, iter3_32 in pairs(var3_32) do
		local var4_32 = var2_32(iter3_32)

		var1_32[var4_32.id] = var4_32
	end

	for iter4_32, iter5_32 in pairs(arg1_32.skills) do
		if iter5_32 and iter5_32.id == 14900 and not arg1_32.transforms[16412] then
			-- block empty
		else
			local var5_32 = var2_32(iter5_32)

			var1_32[var5_32.id] = var5_32
		end
	end

	local var6_32 = ys.Battle.BattleDataFunction.GetEquipSkill(var0_32)

	for iter6_32, iter7_32 in ipairs(var6_32) do
		local var7_32 = {
			level = iter7_32.buffLV,
			id = ys.Battle.BattleDataFunction.SkillTranform(arg0_32, iter7_32.buffID)
		}

		var1_32[var7_32.id] = var7_32
	end

	local var8_32

	;(function()
		var8_32 = arg1_32:GetSpWeapon()

		if not var8_32 then
			return
		end

		local var0_34 = var8_32:GetEffect()

		if var0_34 == 0 then
			return
		end

		local var1_34 = {}

		var1_34.level = 1
		var1_34.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_32, var0_34)
		var1_32[var1_34.id] = var1_34
	end)()

	for iter8_32, iter9_32 in pairs(arg1_32:getTriggerSkills()) do
		local var9_32 = {
			level = iter9_32.level,
			id = ys.Battle.BattleDataFunction.SkillTranform(arg0_32, iter9_32.id)
		}

		var1_32[var9_32.id] = var9_32
	end

	local var10_32 = arg0_32 == SYSTEM_WORLD
	local var11_32 = false

	if var10_32 then
		local var12_32 = WorldConst.FetchWorldShip(arg1_32.id)

		if var12_32 then
			var11_32 = var12_32:IsBroken()
		end
	end

	if var11_32 then
		for iter10_32, iter11_32 in pairs(var1_32) do
			local var13_32 = pg.skill_data_template[iter10_32].world_death_mark[1]

			if var13_32 == ys.Battle.BattleConst.DEATH_MARK_SKILL.DEACTIVE then
				var1_32[iter10_32] = nil
			elseif var13_32 == ys.Battle.BattleConst.DEATH_MARK_SKILL.IGNORE then
				-- block empty
			end
		end
	end

	return {
		id = arg1_32.id,
		tmpID = arg1_32.configId,
		skinId = arg1_32.skinId,
		level = arg1_32.level,
		equipment = var0_32,
		properties = arg1_32:getProperties(arg2_32, arg3_32, var10_32),
		baseProperties = arg1_32:getShipProperties(),
		proficiency = arg1_32:getEquipProficiencyList(),
		rarity = arg1_32:getRarity(),
		intimacy = arg1_32:getCVIntimacy(),
		shipGS = arg1_32:getShipCombatPower(),
		skills = var1_32,
		baseList = arg1_32:getBaseList(),
		preloasList = arg1_32:getPreLoadCount(),
		name = arg1_32:getName(),
		deathMark = var11_32,
		spWeapon = var8_32
	}
end

local function var2_0(arg0_35, arg1_35)
	local var0_35 = arg0_35:getProperties(arg1_35)
	local var1_35 = arg0_35:getConfig("id")

	return {
		deathMark = false,
		shipGS = 100,
		rarity = 1,
		intimacy = 100,
		id = var1_35,
		tmpID = var1_35,
		skinId = arg0_35:getConfig("skin_id"),
		level = arg0_35:getConfig("level"),
		equipment = arg0_35:getConfig("default_equip"),
		properties = var0_35,
		baseProperties = var0_35,
		proficiency = {
			1,
			1,
			1
		},
		skills = {},
		baseList = {
			1,
			1,
			1
		},
		preloasList = {
			0,
			0,
			0
		},
		name = var1_35,
		fleetIndex = arg0_35:getConfig("location")
	}
end

function var0_0.GenBattleData(arg0_36)
	local var0_36 = {}
	local var1_36 = arg0_36.contextData.system

	arg0_36._battleData = var0_36
	var0_36.battleType = arg0_36.contextData.system
	var0_36.StageTmpId = arg0_36.contextData.stageId
	var0_36.CMDArgs = arg0_36.contextData.cmdArgs
	var0_36.isMemory = arg0_36.contextData.memory
	var0_36.MainUnitList = {}
	var0_36.VanguardUnitList = {}
	var0_36.SubUnitList = {}
	var0_36.AidUnitList = {}
	var0_36.SupportUnitList = {}
	var0_36.SubFlag = -1
	var0_36.ActID = arg0_36.contextData.actId
	var0_36.bossLevel = arg0_36.contextData.bossLevel
	var0_36.bossConfigId = arg0_36.contextData.bossConfigId

	if pg.battle_cost_template[var1_36].global_buff_effected > 0 then
		local var2_36 = BuffHelper.GetBattleBuffs(var1_36)

		var0_36.GlobalBuffIDs = underscore.filter(var2_36, function(arg0_37)
			local var0_37
			local var1_37 = {
				"dungeon"
			}

			if var1_36 == SYSTEM_SCENARIO then
				table.insert(var1_37, "chapter")

				var0_37 = getProxy(ChapterProxy):getActiveChapter().id
			end

			return underscore.all(var1_37, function(arg0_38)
				return switch(arg0_38, {
					chapter = function()
						return arg0_37:checkChaper(var0_37)
					end,
					dungeon = function()
						return arg0_37:checkDungeon(arg0_36.contextData.stageId)
					end
				}, function()
					return false
				end)
			end)
		end)
	end

	local var3_36 = pg.battle_cost_template[var1_36]
	local var4_36 = getProxy(BayProxy)
	local var5_36 = {}

	if var1_36 == SYSTEM_SCENARIO then
		local var6_36 = getProxy(ChapterProxy)
		local var7_36 = var6_36:getActiveChapter()

		var0_36.RepressInfo = var7_36:getRepressInfo()

		arg0_36.viewComponent:setChapter(var7_36)

		local var8_36 = var7_36.fleet

		var0_36.KizunaJamming = var7_36:getExtraFlags()
		var0_36.DefeatCount = var8_36:getDefeatCount()
		var0_36.ChapterBuffIDs, var0_36.CommanderList = var7_36:getFleetBattleBuffs(var8_36)
		var0_36.StageWaveFlags = var7_36:GetStageFlags()
		var0_36.ChapterWeatherIDS = var7_36:GetWeather(var8_36.line.row, var8_36.line.column)
		var0_36.MapAuraSkills = var6_36.GetChapterAuraBuffs(var7_36)
		var0_36.MapAidSkills = {}
		var0_36.ChapterType = var7_36:getPlayType()

		local var9_36 = var6_36.GetChapterAidBuffs(var7_36)

		for iter0_36, iter1_36 in pairs(var9_36) do
			local var10_36 = var7_36:getFleetByShipVO(iter0_36)
			local var11_36 = _.values(var10_36:getCommanders())
			local var12_36 = var1_0(var1_36, iter0_36, var11_36)

			table.insert(var0_36.AidUnitList, var12_36)

			for iter2_36, iter3_36 in ipairs(iter1_36) do
				table.insert(var0_36.MapAidSkills, iter3_36)
			end
		end

		local var13_36 = var8_36:getShipsByTeam(TeamType.Main, false)
		local var14_36 = var8_36:getShipsByTeam(TeamType.Vanguard, false)
		local var15_36 = {}
		local var16_36 = _.values(var8_36:getCommanders())
		local var17_36 = {}
		local var18_36, var19_36 = var6_36.getSubAidFlag(var7_36, arg0_36.contextData.stageId)

		if var18_36 == true or var18_36 > 0 then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
			var15_36 = var19_36:getShipsByTeam(TeamType.Submarine, false)
			var17_36 = _.values(var19_36:getCommanders())

			local var20_36, var21_36 = var7_36:getFleetBattleBuffs(var19_36)

			var0_36.SubCommanderList = var21_36
		else
			var0_36.SubFlag = var18_36

			if var18_36 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_36.TotalSubAmmo = 0
			end
		end

		arg0_36.mainShips = {}

		local function var22_36(arg0_42, arg1_42, arg2_42)
			local var0_42 = arg0_42.id
			local var1_42 = arg0_42.hpRant * 0.0001

			if table.contains(var5_36, var0_42) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_36[#var5_36 + 1] = var0_42

			local var2_42 = var1_0(var1_36, arg0_42, arg1_42)

			var2_42.initHPRate = var1_42

			table.insert(arg0_36.mainShips, arg0_42)
			table.insert(arg2_42, var2_42)
		end

		for iter4_36, iter5_36 in ipairs(var13_36) do
			var22_36(iter5_36, var16_36, var0_36.MainUnitList)
		end

		for iter6_36, iter7_36 in ipairs(var14_36) do
			var22_36(iter7_36, var16_36, var0_36.VanguardUnitList)
		end

		for iter8_36, iter9_36 in ipairs(var15_36) do
			var22_36(iter9_36, var17_36, var0_36.SubUnitList)
		end

		local var23_36 = var7_36:getChapterSupportFleet()

		if var23_36 then
			local var24_36 = var23_36:getShips()

			for iter10_36, iter11_36 in pairs(var24_36) do
				var22_36(iter11_36, {}, var0_36.SupportUnitList)
			end
		end

		arg0_36.viewComponent:setFleet(var13_36, var14_36, var15_36)
	elseif var1_36 == SYSTEM_CHALLENGE then
		local var25_36 = arg0_36.contextData.mode
		local var26_36 = getProxy(ChallengeProxy):getUserChallengeInfo(var25_36)

		var0_36.ChallengeInfo = var26_36

		arg0_36.viewComponent:setChapter(var26_36)

		local var27_36 = var26_36:getRegularFleet()

		var0_36.CommanderList = var27_36:buildBattleBuffList()

		local var28_36 = _.values(var27_36:getCommanders())
		local var29_36 = {}
		local var30_36 = var27_36:getShipsByTeam(TeamType.Main, false)
		local var31_36 = var27_36:getShipsByTeam(TeamType.Vanguard, false)
		local var32_36 = {}
		local var33_36 = var26_36:getSubmarineFleet()
		local var34_36 = var33_36:getShipsByTeam(TeamType.Submarine, false)

		if #var34_36 > 0 then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
			var29_36 = _.values(var33_36:getCommanders())
			var0_36.SubCommanderList = var33_36:buildBattleBuffList()
		else
			var0_36.SubFlag = 0
			var0_36.TotalSubAmmo = 0
		end

		arg0_36.mainShips = {}

		local function var35_36(arg0_43, arg1_43, arg2_43)
			local var0_43 = arg0_43.id
			local var1_43 = arg0_43.hpRant * 0.0001

			if table.contains(var5_36, var0_43) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_36[#var5_36 + 1] = var0_43

			local var2_43 = var1_0(var1_36, arg0_43, arg1_43)

			var2_43.initHPRate = var1_43

			table.insert(arg0_36.mainShips, arg0_43)
			table.insert(arg2_43, var2_43)
		end

		for iter12_36, iter13_36 in ipairs(var30_36) do
			var35_36(iter13_36, var28_36, var0_36.MainUnitList)
		end

		for iter14_36, iter15_36 in ipairs(var31_36) do
			var35_36(iter15_36, var28_36, var0_36.VanguardUnitList)
		end

		for iter16_36, iter17_36 in ipairs(var34_36) do
			var35_36(iter17_36, var29_36, var0_36.SubUnitList)
		end

		arg0_36.viewComponent:setFleet(var30_36, var31_36, var34_36)
	elseif var1_36 == SYSTEM_WORLD then
		local var36_36 = nowWorld()
		local var37_36 = var36_36:GetActiveMap()
		local var38_36 = var37_36:GetFleet()
		local var39_36 = var37_36:GetCell(var38_36.row, var38_36.column):GetStageEnemy()

		if arg0_36.contextData.hpRate then
			var0_36.RepressInfo = {
				repressEnemyHpRant = arg0_36.contextData.hpRate
			}
		end

		var0_36.AffixBuffList = table.mergeArray(var39_36:GetBattleLuaBuffs(), var37_36:GetBattleLuaBuffs(WorldMap.FactionEnemy, var39_36))

		local function var40_36(arg0_44)
			local var0_44 = {}

			for iter0_44, iter1_44 in ipairs(arg0_44) do
				local var1_44 = {
					id = ys.Battle.BattleDataFunction.SkillTranform(var1_36, iter1_44.id),
					level = iter1_44.level
				}

				table.insert(var0_44, var1_44)
			end

			return var0_44
		end

		var0_36.DefeatCount = var38_36:getDefeatCount()
		var0_36.ChapterBuffIDs, var0_36.CommanderList = var37_36:getFleetBattleBuffs(var38_36, true)
		var0_36.MapAuraSkills = var37_36:GetChapterAuraBuffs()
		var0_36.MapAuraSkills = var40_36(var0_36.MapAuraSkills)
		var0_36.MapAidSkills = {}

		local var41_36 = var37_36:GetChapterAidBuffs()

		for iter18_36, iter19_36 in pairs(var41_36) do
			local var42_36 = var37_36:GetFleet(iter18_36.fleetId)
			local var43_36 = _.values(var42_36:getCommanders(true))
			local var44_36 = var1_0(var1_36, WorldConst.FetchShipVO(iter18_36.id), var43_36)

			table.insert(var0_36.AidUnitList, var44_36)

			var0_36.MapAidSkills = table.mergeArray(var0_36.MapAidSkills, var40_36(iter19_36))
		end

		local var45_36 = var38_36:GetTeamShipVOs(TeamType.Main, false)
		local var46_36 = var38_36:GetTeamShipVOs(TeamType.Vanguard, false)
		local var47_36 = {}
		local var48_36 = _.values(var38_36:getCommanders(true))
		local var49_36 = {}
		local var50_36 = var36_36:GetSubAidFlag()

		if var50_36 == true then
			local var51_36 = var37_36:GetSubmarineFleet()

			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
			var47_36 = var51_36:GetTeamShipVOs(TeamType.Submarine, false)
			var49_36 = _.values(var51_36:getCommanders(true))

			local var52_36, var53_36 = var37_36:getFleetBattleBuffs(var51_36, true)

			var0_36.SubCommanderList = var53_36
		else
			var0_36.SubFlag = 0

			if var50_36 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_36.TotalSubAmmo = 0
			end
		end

		arg0_36.mainShips = {}

		for iter20_36, iter21_36 in ipairs(var45_36) do
			local var54_36 = iter21_36.id
			local var55_36 = WorldConst.FetchWorldShip(iter21_36.id).hpRant * 0.0001

			if table.contains(var5_36, var54_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_36[#var5_36 + 1] = var54_36

			local var56_36 = var1_0(var1_36, iter21_36, var48_36)

			var56_36.initHPRate = var55_36

			table.insert(arg0_36.mainShips, iter21_36)
			table.insert(var0_36.MainUnitList, var56_36)
		end

		for iter22_36, iter23_36 in ipairs(var46_36) do
			local var57_36 = iter23_36.id
			local var58_36 = WorldConst.FetchWorldShip(iter23_36.id).hpRant * 0.0001

			if table.contains(var5_36, var57_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_36[#var5_36 + 1] = var57_36

			local var59_36 = var1_0(var1_36, iter23_36, var48_36)

			var59_36.initHPRate = var58_36

			table.insert(arg0_36.mainShips, iter23_36)
			table.insert(var0_36.VanguardUnitList, var59_36)
		end

		for iter24_36, iter25_36 in ipairs(var47_36) do
			local var60_36 = iter25_36.id
			local var61_36 = WorldConst.FetchWorldShip(iter25_36.id).hpRant * 0.0001

			if table.contains(var5_36, var60_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_36[#var5_36 + 1] = var60_36

			local var62_36 = var1_0(var1_36, iter25_36, var49_36)

			var62_36.initHPRate = var61_36

			table.insert(arg0_36.mainShips, iter25_36)
			table.insert(var0_36.SubUnitList, var62_36)
		end

		arg0_36.viewComponent:setFleet(var45_36, var46_36, var47_36)

		local var63_36 = pg.expedition_data_template[arg0_36.contextData.stageId]

		if var63_36.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
			var0_36.WorldMapId = var37_36.config.expedition_map_id
			var0_36.WorldLevel = WorldConst.WorldLevelCorrect(var37_36.config.expedition_level, var63_36.type)
		end
	elseif var1_36 == SYSTEM_WORLD_BOSS then
		local var64_36 = nowWorld():GetBossProxy()
		local var65_36 = arg0_36.contextData.bossId
		local var66_36 = var64_36:GetFleet(var65_36)
		local var67_36 = var64_36:GetBossById(var65_36)

		if arg0_36.contextData.hpRate then
			var0_36.RepressInfo = {
				repressEnemyHpRant = arg0_36.contextData.hpRate
			}
		end

		local var68_36 = _.values(var66_36:getCommanders())

		var0_36.CommanderList = var66_36:buildBattleBuffList()
		arg0_36.mainShips = var4_36:getShipsByFleet(var66_36)

		local var69_36 = {}
		local var70_36 = {}
		local var71_36 = {}
		local var72_36 = var66_36:getTeamByName(TeamType.Main)

		for iter26_36, iter27_36 in ipairs(var72_36) do
			if table.contains(var5_36, iter27_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_36[#var5_36 + 1] = iter27_36

			local var73_36 = var4_36:getShipById(iter27_36)
			local var74_36 = var1_0(var1_36, var73_36, var68_36)

			table.insert(var69_36, var73_36)
			table.insert(var0_36.MainUnitList, var74_36)
		end

		local var75_36 = var66_36:getTeamByName(TeamType.Vanguard)

		for iter28_36, iter29_36 in ipairs(var75_36) do
			if table.contains(var5_36, iter29_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_36[#var5_36 + 1] = iter29_36

			local var76_36 = var4_36:getShipById(iter29_36)
			local var77_36 = var1_0(var1_36, var76_36, var68_36)

			table.insert(var70_36, var76_36)
			table.insert(var0_36.VanguardUnitList, var77_36)
		end

		arg0_36.viewComponent:setFleet(var69_36, var70_36, var71_36)

		var0_36.MapAidSkills = {}

		if var67_36 and var67_36:IsSelf() then
			local var78_36, var79_36, var80_36 = var64_36.GetSupportValue()

			if var78_36 then
				table.insert(var0_36.MapAidSkills, {
					level = 1,
					id = var80_36
				})
			end
		end
	elseif var1_36 == SYSTEM_HP_SHARE_ACT_BOSS or var1_36 == SYSTEM_ACT_BOSS or var1_36 == SYSTEM_ACT_BOSS_SP or var1_36 == SYSTEM_BOSS_EXPERIMENT then
		if arg0_36.contextData.mainFleetId then
			local var81_36 = getProxy(FleetProxy):getActivityFleets()[arg0_36.contextData.actId]
			local var82_36 = var81_36[arg0_36.contextData.mainFleetId]
			local var83_36 = _.values(var82_36:getCommanders())

			var0_36.CommanderList = var82_36:buildBattleBuffList()
			arg0_36.mainShips = {}

			local var84_36 = {}
			local var85_36 = {}
			local var86_36 = {}

			local function var87_36(arg0_45, arg1_45, arg2_45, arg3_45)
				if table.contains(var5_36, arg0_45) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_36[#var5_36 + 1] = arg0_45

				local var0_45 = var4_36:getShipById(arg0_45)
				local var1_45 = var1_0(var1_36, var0_45, arg1_45)

				table.insert(arg0_36.mainShips, var0_45)
				table.insert(arg3_45, var0_45)
				table.insert(arg2_45, var1_45)
			end

			local var88_36 = var82_36:getTeamByName(TeamType.Main)
			local var89_36 = var82_36:getTeamByName(TeamType.Vanguard)

			for iter30_36, iter31_36 in ipairs(var88_36) do
				var87_36(iter31_36, var83_36, var0_36.MainUnitList, var84_36)
			end

			for iter32_36, iter33_36 in ipairs(var89_36) do
				var87_36(iter33_36, var83_36, var0_36.VanguardUnitList, var85_36)
			end

			local var90_36 = var81_36[arg0_36.contextData.mainFleetId + 10]
			local var91_36 = _.values(var90_36:getCommanders())
			local var92_36 = var90_36:getTeamByName(TeamType.Submarine)

			for iter34_36, iter35_36 in ipairs(var92_36) do
				var87_36(iter35_36, var91_36, var0_36.SubUnitList, var86_36)
			end

			local var93_36 = getProxy(PlayerProxy):getRawData()
			local var94_36 = getProxy(ActivityProxy):getActivityById(arg0_36.contextData.actId)
			local var95_36 = var94_36:getConfig("config_id")
			local var96_36 = pg.activity_event_worldboss[var95_36].use_oil_limit[arg0_36.contextData.mainFleetId]
			local var97_36 = var94_36:IsOilLimit(arg0_36.contextData.stageId)
			local var98_36 = 0
			local var99_36 = var3_36.oil_cost > 0

			local function var100_36(arg0_46, arg1_46)
				if var99_36 then
					local var0_46 = arg0_46:getEndCost().oil

					if arg1_46 > 0 then
						local var1_46 = arg0_46:getStartCost().oil

						cost = math.clamp(arg1_46 - var1_46, 0, var0_46)
					end

					var98_36 = var98_36 + var0_46
				end
			end

			if var1_36 == SYSTEM_ACT_BOSS_SP then
				local var101_36 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0_36.contextData.actId).buffIds
				local var102_36 = _.map(var101_36, function(arg0_47)
					return ActivityBossBuff.New({
						configId = arg0_47
					})
				end)

				var0_36.ExtraBuffList = _.map(_.select(var102_36, function(arg0_48)
					return arg0_48:CastOnEnemy()
				end), function(arg0_49)
					return arg0_49:GetBuffID()
				end)
				var0_36.ChapterBuffIDs = _.map(_.select(var102_36, function(arg0_50)
					return not arg0_50:CastOnEnemy()
				end), function(arg0_51)
					return arg0_51:GetBuffID()
				end)
			else
				var100_36(var82_36, var97_36 and var96_36[1] or 0)
				var100_36(var90_36, var97_36 and var96_36[2] or 0)
			end

			if var90_36:isLegalToFight() == true and (var1_36 == SYSTEM_BOSS_EXPERIMENT or var98_36 <= var93_36.oil) then
				var0_36.SubFlag = 1
				var0_36.TotalSubAmmo = 1
			end

			var0_36.SubCommanderList = var90_36:buildBattleBuffList()

			arg0_36.viewComponent:setFleet(var84_36, var85_36, var86_36)
		end
	elseif var1_36 == SYSTEM_GUILD then
		local var103_36 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
		local var104_36 = var103_36:GetMainFleet()
		local var105_36 = _.values(var104_36:getCommanders())

		var0_36.CommanderList = var104_36:BuildBattleBuffList()
		arg0_36.mainShips = {}

		local var106_36 = {}
		local var107_36 = {}
		local var108_36 = {}

		local function var109_36(arg0_52, arg1_52, arg2_52, arg3_52)
			local var0_52 = var1_0(var1_36, arg0_52, arg1_52)

			table.insert(arg0_36.mainShips, arg0_52)
			table.insert(arg3_52, arg0_52)
			table.insert(arg2_52, var0_52)
		end

		local var110_36 = {}
		local var111_36 = {}
		local var112_36 = var104_36:GetShips()

		for iter36_36, iter37_36 in pairs(var112_36) do
			local var113_36 = iter37_36.ship

			if var113_36:getTeamType() == TeamType.Main then
				table.insert(var110_36, var113_36)
			elseif var113_36:getTeamType() == TeamType.Vanguard then
				table.insert(var111_36, var113_36)
			end
		end

		for iter38_36, iter39_36 in ipairs(var110_36) do
			var109_36(iter39_36, var105_36, var0_36.MainUnitList, var106_36)
		end

		for iter40_36, iter41_36 in ipairs(var111_36) do
			var109_36(iter41_36, var105_36, var0_36.VanguardUnitList, var107_36)
		end

		local var114_36 = var103_36:GetSubFleet()
		local var115_36 = _.values(var114_36:getCommanders())
		local var116_36 = {}
		local var117_36 = var114_36:GetShips()

		for iter42_36, iter43_36 in pairs(var117_36) do
			local var118_36 = iter43_36.ship

			if var118_36:getTeamType() == TeamType.Submarine then
				table.insert(var116_36, var118_36)
			end
		end

		for iter44_36, iter45_36 in ipairs(var116_36) do
			var109_36(iter45_36, var115_36, var0_36.SubUnitList, var108_36)
		end

		if #var108_36 > 0 then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
		end

		var0_36.SubCommanderList = var114_36:BuildBattleBuffList()

		arg0_36.viewComponent:setFleet(var106_36, var107_36, var108_36)
	elseif var1_36 == SYSTEM_BOSS_RUSH or var1_36 == SYSTEM_BOSS_RUSH_EX or var1_36 == SYSTEM_BOSS_RUSH_COLLABRATE then
		local var119_36 = getProxy(ActivityProxy):getActivityById(arg0_36.contextData.actId):GetSeriesData()

		assert(var119_36)

		local var120_36 = var119_36:GetStaegLevel() + 1
		local var121_36 = var119_36:GetMode()
		local var122_36, var123_36 = var119_36:GetStageFleets(var121_36, var120_36)
		local var124_36 = getProxy(FleetProxy):getActivityFleets()[arg0_36.contextData.actId]

		arg0_36.mainShips = {}

		local var125_36 = {}
		local var126_36 = {}
		local var127_36 = {}

		local function var128_36(arg0_53, arg1_53, arg2_53, arg3_53)
			if table.contains(var5_36, arg0_53) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_36[#var5_36 + 1] = arg0_53

			local var0_53 = var4_36:getShipById(arg0_53)
			local var1_53 = var1_0(var1_36, var0_53, arg1_53)

			table.insert(arg0_36.mainShips, var0_53)
			table.insert(arg3_53, var0_53)
			table.insert(arg2_53, var1_53)
		end

		local var129_36 = var124_36[var122_36]
		local var130_36 = _.values(var129_36:getCommanders())

		var0_36.CommanderList = var129_36:buildBattleBuffList()

		local var131_36 = var129_36:getTeamByName(TeamType.Main)
		local var132_36 = var129_36:getTeamByName(TeamType.Vanguard)

		for iter46_36, iter47_36 in ipairs(var131_36) do
			var128_36(iter47_36, var130_36, var0_36.MainUnitList, var125_36)
		end

		for iter48_36, iter49_36 in ipairs(var132_36) do
			var128_36(iter49_36, var130_36, var0_36.VanguardUnitList, var126_36)
		end

		local var133_36 = var124_36[var123_36]
		local var134_36 = _.values(var133_36:getCommanders())

		var0_36.SubCommanderList = var133_36:buildBattleBuffList()

		local var135_36 = var133_36:getTeamByName(TeamType.Submarine)

		for iter50_36, iter51_36 in ipairs(var135_36) do
			var128_36(iter51_36, var134_36, var0_36.SubUnitList, var127_36)
		end

		local var136_36 = getProxy(PlayerProxy):getRawData()
		local var137_36 = 0
		local var138_36 = var119_36:GetOilLimit()
		local var139_36 = var3_36.oil_cost > 0

		local function var140_36(arg0_54, arg1_54)
			local var0_54 = 0

			if var139_36 then
				local var1_54 = arg0_54:getStartCost().oil
				local var2_54 = arg0_54:getEndCost().oil

				var0_54 = var2_54

				if arg1_54 > 0 then
					var0_54 = math.clamp(arg1_54 - var1_54, 0, var2_54)
				end
			end

			return var0_54
		end

		local var141_36 = var137_36 + var140_36(var129_36, var138_36[1]) + var140_36(var133_36, var138_36[2])

		if var133_36:isLegalToFight() == true and var141_36 <= var136_36.oil then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
		end

		arg0_36.viewComponent:setFleet(var125_36, var126_36, var127_36)

		if var1_36 == SYSTEM_BOSS_RUSH_COLLABRATE then
			var0_36.ChapterBuffIDs = {}
			var0_36.DALAidBuffIDs = {}

			local var142_36 = var119_36:getConfig("aid_buff")

			if var119_36:GetBossHpRate() <= var142_36[1] then
				table.insert(var0_36.DALAidBuffIDs, var142_36[2])
			end
		end
	elseif var1_36 == SYSTEM_LIMIT_CHALLENGE then
		local var143_36 = LimitChallengeConst.GetChallengeIDByStageID(arg0_36.contextData.stageId)

		var0_36.ExtraBuffList = AcessWithinNull(pg.expedition_constellation_challenge_template[var143_36], "buff_id")

		local var144_36 = FleetProxy.CHALLENGE_FLEET_ID
		local var145_36 = FleetProxy.CHALLENGE_SUB_FLEET_ID
		local var146_36 = getProxy(FleetProxy)
		local var147_36 = var146_36:getFleetById(var144_36)
		local var148_36 = var146_36:getFleetById(var145_36)

		arg0_36.mainShips = {}

		local var149_36 = {}
		local var150_36 = {}
		local var151_36 = {}

		local function var152_36(arg0_55, arg1_55, arg2_55, arg3_55)
			if table.contains(var5_36, arg0_55) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_36[#var5_36 + 1] = arg0_55

			local var0_55 = var4_36:getShipById(arg0_55)
			local var1_55 = var1_0(var1_36, var0_55, arg1_55)

			table.insert(arg0_36.mainShips, var0_55)
			table.insert(arg3_55, var0_55)
			table.insert(arg2_55, var1_55)
		end

		local var153_36 = _.values(var147_36:getCommanders())

		var0_36.CommanderList = var147_36:buildBattleBuffList()

		local var154_36 = var147_36:getTeamByName(TeamType.Main)
		local var155_36 = var147_36:getTeamByName(TeamType.Vanguard)

		for iter52_36, iter53_36 in ipairs(var154_36) do
			var152_36(iter53_36, var153_36, var0_36.MainUnitList, var149_36)
		end

		for iter54_36, iter55_36 in ipairs(var155_36) do
			var152_36(iter55_36, var153_36, var0_36.VanguardUnitList, var150_36)
		end

		local var156_36 = _.values(var148_36:getCommanders())

		var0_36.SubCommanderList = var148_36:buildBattleBuffList()

		local var157_36 = var148_36:getTeamByName(TeamType.Submarine)

		for iter56_36, iter57_36 in ipairs(var157_36) do
			var152_36(iter57_36, var156_36, var0_36.SubUnitList, var151_36)
		end

		local var158_36 = getProxy(PlayerProxy):getRawData()
		local var159_36 = 0
		local var160_36 = var3_36.oil_cost > 0

		local function var161_36(arg0_56, arg1_56)
			local var0_56 = 0

			if var160_36 then
				local var1_56 = arg0_56:getStartCost().oil
				local var2_56 = arg0_56:getEndCost().oil

				var0_56 = var2_56

				if arg1_56 > 0 then
					var0_56 = math.clamp(arg1_56 - var1_56, 0, var2_56)
				end
			end

			return var0_56
		end

		local var162_36 = var159_36 + var161_36(var147_36, 0) + var161_36(var148_36, 0)

		if var148_36:isLegalToFight() == true and var162_36 <= var158_36.oil then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
		end

		arg0_36.viewComponent:setFleet(var149_36, var150_36, var151_36)
	elseif var1_36 == SYSTEM_CARDPUZZLE then
		local var163_36 = {}
		local var164_36 = {}
		local var165_36 = arg0_36.contextData.relics

		for iter58_36, iter59_36 in ipairs(arg0_36.contextData.cardPuzzleFleet) do
			local var166_36 = var2_0(iter59_36, var165_36)
			local var167_36 = var166_36.fleetIndex

			if var167_36 == 1 then
				table.insert(var164_36, var166_36)
				table.insert(var0_36.VanguardUnitList, var166_36)
			elseif var167_36 == 2 then
				table.insert(var163_36, var166_36)
				table.insert(var0_36.MainUnitList, var166_36)
			end
		end

		var0_36.CardPuzzleCardIDList = arg0_36.contextData.cards
		var0_36.CardPuzzleCommonHPValue = arg0_36.contextData.hp
		var0_36.CardPuzzleRelicList = var165_36
		var0_36.CardPuzzleCombatID = arg0_36.contextData.puzzleCombatID
	elseif var1_36 == SYSTEM_BOSS_SINGLE or var1_36 == SYSTEM_BOSS_SINGLE_VARIABLE then
		if arg0_36.contextData.mainFleetId then
			local var168_36 = getProxy(FleetProxy):getActivityFleets()[arg0_36.contextData.actId]
			local var169_36 = var168_36[arg0_36.contextData.mainFleetId]
			local var170_36 = _.values(var169_36:getCommanders())

			var0_36.CommanderList = var169_36:buildBattleBuffList()
			arg0_36.mainShips = {}

			local var171_36 = {}
			local var172_36 = {}
			local var173_36 = {}

			local function var174_36(arg0_57, arg1_57, arg2_57, arg3_57)
				if table.contains(var5_36, arg0_57) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_36[#var5_36 + 1] = arg0_57

				local var0_57 = var4_36:getShipById(arg0_57)
				local var1_57 = var1_0(var1_36, var0_57, arg1_57)

				table.insert(arg0_36.mainShips, var0_57)
				table.insert(arg3_57, var0_57)
				table.insert(arg2_57, var1_57)
			end

			local var175_36 = var169_36:getTeamByName(TeamType.Main)
			local var176_36 = var169_36:getTeamByName(TeamType.Vanguard)

			for iter60_36, iter61_36 in ipairs(var175_36) do
				var174_36(iter61_36, var170_36, var0_36.MainUnitList, var171_36)
			end

			for iter62_36, iter63_36 in ipairs(var176_36) do
				var174_36(iter63_36, var170_36, var0_36.VanguardUnitList, var172_36)
			end

			local var177_36 = var1_36 == SYSTEM_BOSS_SINGLE_VARIABLE and 100 or 10
			local var178_36 = var168_36[arg0_36.contextData.mainFleetId + var177_36]

			if var178_36 then
				local var179_36 = _.values(var178_36:getCommanders())
				local var180_36 = var178_36:getTeamByName(TeamType.Submarine)

				for iter64_36, iter65_36 in ipairs(var180_36) do
					var174_36(iter65_36, var179_36, var0_36.SubUnitList, var173_36)
				end
			end

			local var181_36 = getProxy(PlayerProxy):getRawData()
			local var182_36 = getProxy(ActivityProxy):getActivityById(arg0_36.contextData.actId)

			var0_36.ChapterBuffIDs = var182_36:GetBuffIdsByStageId(arg0_36.contextData.stageId)

			local var183_36 = pg.strategy_data_template

			if arg0_36.contextData.variableBuffList then
				for iter66_36, iter67_36 in ipairs(arg0_36.contextData.variableBuffList) do
					table.insert(var0_36.ChapterBuffIDs, var183_36[iter67_36].buff_id)
				end
			end

			local var184_36 = var182_36:GetEnemyDataByStageId(arg0_36.contextData.stageId):GetOilLimit()
			local var185_36 = 0
			local var186_36 = var3_36.oil_cost > 0

			local function var187_36(arg0_58, arg1_58)
				if var186_36 then
					local var0_58 = arg0_58:getEndCost().oil

					if arg1_58 > 0 then
						local var1_58 = arg0_58:getStartCost().oil

						cost = math.clamp(arg1_58 - var1_58, 0, var0_58)
					end

					var185_36 = var185_36 + var0_58
				end
			end

			var187_36(var169_36, var184_36[1] or 0)

			if var178_36 then
				var187_36(var178_36, var184_36[2] or 0)

				if var178_36:isLegalToFight() == true and var185_36 <= var181_36.oil then
					var0_36.SubFlag = 1
					var0_36.TotalSubAmmo = 1
				end

				var0_36.SubCommanderList = var178_36:buildBattleBuffList()
			end

			arg0_36.viewComponent:setFleet(var171_36, var172_36, var173_36)
		end
	elseif var1_36 == SYSTEM_SCENARIO_SUB_STRIKE then
		local var188_36 = {}

		arg0_36.mainShips = {}

		local function var189_36(arg0_59, arg1_59, arg2_59)
			for iter0_59, iter1_59 in ipairs(arg0_59) do
				if table.contains(var5_36, iter1_59) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_36[#var5_36 + 1] = iter1_59

				local var0_59 = var4_36:getShipById(iter1_59)
				local var1_59 = var1_0(var1_36, var0_59, nil)

				table.insert(arg1_59, var0_59)
				table.insert(arg0_36.mainShips, var0_59)
				table.insert(arg2_59, var1_59)
			end
		end

		local var190_36 = getProxy(ChapterProxy):getActiveChapter()

		arg0_36.viewComponent:setChapter(var190_36)
		arg0_36.viewComponent:setFleet(nil, nil, var188_36)

		local var191_36 = var190_36:getChapterSupportFleet():getTeamByName(TeamType.Submarine)

		var189_36(var191_36, var188_36, var0_36.SubUnitList)
	elseif arg0_36.contextData.mainFleetId then
		local var192_36 = var1_36 == SYSTEM_DUEL
		local var193_36 = getProxy(FleetProxy)
		local var194_36
		local var195_36
		local var196_36 = var193_36:getFleetById(arg0_36.contextData.mainFleetId)

		arg0_36.mainShips = var4_36:getShipsByFleet(var196_36)

		local var197_36 = {}
		local var198_36 = {}
		local var199_36 = {}

		local function var200_36(arg0_60, arg1_60, arg2_60)
			for iter0_60, iter1_60 in ipairs(arg0_60) do
				if table.contains(var5_36, iter1_60) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_36[#var5_36 + 1] = iter1_60

				local var0_60 = var4_36:getShipById(iter1_60)
				local var1_60 = var1_0(var1_36, var0_60, nil, var192_36)

				table.insert(arg1_60, var0_60)
				table.insert(arg2_60, var1_60)
			end
		end

		local var201_36 = var196_36:getTeamByName(TeamType.Main)
		local var202_36 = var196_36:getTeamByName(TeamType.Vanguard)
		local var203_36 = var196_36:getTeamByName(TeamType.Submarine)

		var200_36(var201_36, var197_36, var0_36.MainUnitList)
		var200_36(var202_36, var198_36, var0_36.VanguardUnitList)
		var200_36(var203_36, var199_36, var0_36.SubUnitList)
		arg0_36.viewComponent:setFleet(var197_36, var198_36, var199_36)

		if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
			local var204_36 = var193_36:getFleetById(11)
			local var205_36 = var204_36:getTeamByName(TeamType.Submarine)

			if #var205_36 > 0 then
				var0_36.SubFlag = 1
				var0_36.TotalSubAmmo = 1

				local var206_36 = _.values(var204_36:getCommanders())

				var0_36.SubCommanderList = var204_36:buildBattleBuffList()

				for iter68_36, iter69_36 in ipairs(var205_36) do
					local var207_36 = var4_36:getShipById(iter69_36)
					local var208_36 = var1_0(var1_36, var207_36, var206_36, var192_36)

					table.insert(var199_36, var207_36)
					table.insert(var0_36.SubUnitList, var208_36)
				end
			end
		end
	end

	if var1_36 == SYSTEM_WORLD then
		local var209_36 = nowWorld()
		local var210_36 = var209_36:GetActiveMap()
		local var211_36 = var210_36:GetFleet()
		local var212_36 = var210_36:GetCell(var211_36.row, var211_36.column):GetStageEnemy()
		local var213_36 = pg.world_expedition_data[arg0_36.contextData.stageId]
		local var214_36 = var209_36:GetWorldMapDifficultyBuffLevel()

		var0_36.EnemyMapRewards = {
			var214_36[1] * (1 + var213_36.expedition_sairenvalueA / 10000),
			var214_36[2] * (1 + var213_36.expedition_sairenvalueB / 10000),
			var214_36[3] * (1 + var213_36.expedition_sairenvalueC / 10000)
		}
		var0_36.FleetMapRewards = var209_36:GetWorldMapBuffLevel()
	end

	var0_36.RivalMainUnitList, var0_36.RivalVanguardUnitList = {}, {}

	local var215_36

	if var1_36 == SYSTEM_DUEL and arg0_36.contextData.rivalId then
		local var216_36 = getProxy(MilitaryExerciseProxy)

		var215_36 = var216_36:getRivalById(arg0_36.contextData.rivalId)
		arg0_36.oldRank = var216_36:getSeasonInfo()
	end

	if var215_36 then
		var0_36.RivalVO = var215_36

		local var217_36 = 0

		for iter70_36, iter71_36 in ipairs(var215_36.mainShips) do
			var217_36 = var217_36 + iter71_36.level
		end

		for iter72_36, iter73_36 in ipairs(var215_36.vanguardShips) do
			var217_36 = var217_36 + iter73_36.level
		end

		BattleVertify = BattleVertify or {}
		BattleVertify.rivalLevel = var217_36

		for iter74_36, iter75_36 in ipairs(var215_36.mainShips) do
			if not iter75_36.hpRant or iter75_36.hpRant > 0 then
				local var218_36 = var1_0(var1_36, iter75_36, nil, true)

				if iter75_36.hpRant then
					var218_36.initHPRate = iter75_36.hpRant * 0.0001
				end

				table.insert(var0_36.RivalMainUnitList, var218_36)
			end
		end

		for iter76_36, iter77_36 in ipairs(var215_36.vanguardShips) do
			if not iter77_36.hpRant or iter77_36.hpRant > 0 then
				local var219_36 = var1_0(var1_36, iter77_36, nil, true)

				if iter77_36.hpRant then
					var219_36.initHPRate = iter77_36.hpRant * 0.0001
				end

				table.insert(var0_36.RivalVanguardUnitList, var219_36)
			end
		end
	end

	local var220_36 = arg0_36.contextData.prefabFleet.main_unitList
	local var221_36 = arg0_36.contextData.prefabFleet.vanguard_unitList
	local var222_36 = arg0_36.contextData.prefabFleet.submarine_unitList

	if var220_36 then
		for iter78_36, iter79_36 in ipairs(var220_36) do
			local var223_36 = {}

			for iter80_36, iter81_36 in ipairs(iter79_36.equipment) do
				var223_36[#var223_36 + 1] = {
					skin = 0,
					id = iter81_36
				}
			end

			local var224_36 = {
				id = iter79_36.id,
				tmpID = iter79_36.configId,
				skinId = iter79_36.skinId,
				level = iter79_36.level,
				equipment = var223_36,
				properties = iter79_36.properties,
				baseProperties = iter79_36.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter79_36.skills
			}

			table.insert(var0_36.MainUnitList, var224_36)
		end
	end

	if var221_36 then
		for iter82_36, iter83_36 in ipairs(var221_36) do
			local var225_36 = {}

			for iter84_36, iter85_36 in ipairs(iter83_36.equipment) do
				var225_36[#var225_36 + 1] = {
					skin = 0,
					id = iter85_36
				}
			end

			local var226_36 = {
				id = iter83_36.id,
				tmpID = iter83_36.configId,
				skinId = iter83_36.skinId,
				level = iter83_36.level,
				equipment = var225_36,
				properties = iter83_36.properties,
				baseProperties = iter83_36.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter83_36.skills
			}

			table.insert(var0_36.VanguardUnitList, var226_36)
		end
	end

	if var222_36 then
		for iter86_36, iter87_36 in ipairs(var222_36) do
			local var227_36 = {}

			for iter88_36, iter89_36 in ipairs(iter87_36.equipment) do
				var227_36[#var227_36 + 1] = {
					skin = 0,
					id = iter89_36
				}
			end

			local var228_36 = {
				id = iter87_36.id,
				tmpID = iter87_36.configId,
				skinId = iter87_36.skinId,
				level = iter87_36.level,
				equipment = var227_36,
				properties = iter87_36.properties,
				baseProperties = iter87_36.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter87_36.skills
			}

			table.insert(var0_36.SubUnitList, var228_36)

			if var1_36 == SYSTEM_SIMULATION and #var0_36.SubUnitList > 0 then
				var0_36.SubFlag = 1
				var0_36.TotalSubAmmo = 1
			end
		end
	end
end

function var0_0.listNotificationInterests(arg0_61)
	return {
		GAME.FINISH_STAGE_DONE,
		GAME.FINISH_STAGE_ERROR,
		GAME.STORY_BEGIN,
		GAME.STORY_END,
		GAME.END_GUIDE,
		GAME.START_GUIDE,
		GAME.PAUSE_BATTLE,
		GAME.RESUME_BATTLE,
		var0_0.CLOSE_CHAT,
		GAME.QUIT_BATTLE,
		var0_0.HIDE_ALL_BUTTONS,
		var0_0.UPDATE_AUTO_COUNT
	}
end

function var0_0.handleNotification(arg0_62, arg1_62)
	local var0_62 = arg1_62:getName()
	local var1_62 = arg1_62:getBody()
	local var2_62 = ys.Battle.BattleState.GetInstance()
	local var3_62 = arg0_62.contextData.system

	if var0_62 == GAME.FINISH_STAGE_DONE then
		pg.MsgboxMgr.GetInstance():hide()

		local var4_62 = var1_62.system

		if var4_62 == SYSTEM_PROLOGUE then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_62:sendNotification(GAME.CHANGE_SCENE, SCENE.CREATE_PLAYER)
		elseif var4_62 == SYSTEM_PERFORM or var4_62 == SYSTEM_SIMULATION then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_62.viewComponent:exitBattle()

			if var1_62.exitCallback then
				var1_62.exitCallback()
			end
		else
			local var5_62 = BattleResultMediator.GetResultView(var4_62)
			local var6_62 = {}

			if var4_62 == SYSTEM_SCENARIO then
				var6_62 = getProxy(ChapterProxy):getActiveChapter().operationBuffList
			end

			arg0_62:addSubLayers(Context.New({
				mediator = NewBattleResultMediator,
				viewComponent = NewBattleResultScene,
				data = {
					system = var4_62,
					rivalId = arg0_62.contextData.rivalId,
					mainFleetId = arg0_62.contextData.mainFleetId,
					stageId = arg0_62.contextData.stageId,
					oldMainShips = arg0_62.mainShips or {},
					oldPlayer = arg0_62.player,
					oldRank = arg0_62.oldRank,
					statistics = var1_62.statistics,
					score = var1_62.score,
					drops = var1_62.drops,
					bossId = var1_62.bossId,
					name = var1_62.name,
					prefabFleet = var1_62.prefabFleet,
					commanderExps = var1_62.commanderExps,
					actId = arg0_62.contextData.actId,
					result = var1_62.result,
					extraDrops = var1_62.extraDrops,
					extraBuffList = var6_62,
					isLastBonus = var1_62.isLastBonus,
					continuousBattleTimes = arg0_62.contextData.continuousBattleTimes,
					totalBattleTimes = arg0_62.contextData.totalBattleTimes,
					mode = arg0_62.contextData.mode,
					cmdArgs = arg0_62.contextData.cmdArgs,
					variableBuffList = arg0_62.contextData.variableBuffList,
					useVariableTicket = arg0_62.contextData.useVariableTicket
				}
			}))
		end
	elseif var0_62 == GAME.STORY_BEGIN then
		var2_62:Pause()
	elseif var0_62 == GAME.STORY_END then
		var2_62:Resume()
	elseif var0_62 == GAME.START_GUIDE then
		var2_62:Pause()
	elseif var0_62 == GAME.END_GUIDE then
		var2_62:Resume()
	elseif var0_62 == GAME.PAUSE_BATTLE then
		if not var2_62:IsPause() then
			arg0_62:onPauseBtn()
		end
	elseif var0_62 == GAME.RESUME_BATTLE then
		var2_62:Resume()
	elseif var0_62 == GAME.FINISH_STAGE_ERROR then
		gcAll(true)

		local var7_62 = getProxy(ContextProxy)
		local var8_62 = var7_62:getContextByMediator(DailyLevelMediator)
		local var9_62 = var7_62:getContextByMediator(LevelMediator2)
		local var10_62 = var7_62:getContextByMediator(ChallengeMainMediator)
		local var11_62 = var7_62:getContextByMediator(ActivityBossMediatorTemplate)

		if var8_62 then
			local var12_62 = var8_62:getContextByMediator(PreCombatMediator)

			var8_62:removeChild(var12_62)
		elseif var10_62 then
			local var13_62 = var10_62:getContextByMediator(ChallengePreCombatMediator)

			var10_62:removeChild(var13_62)
		elseif var9_62 then
			if var3_62 == SYSTEM_DUEL then
				-- block empty
			elseif var3_62 == SYSTEM_SCENARIO then
				local var14_62 = var9_62:getContextByMediator(ChapterPreCombatMediator)

				var9_62:removeChild(var14_62)
			elseif var3_62 ~= SYSTEM_PERFORM and var3_62 ~= SYSTEM_SIMULATION then
				local var15_62 = var9_62:getContextByMediator(PreCombatMediator)

				if var15_62 then
					var9_62:removeChild(var15_62)
				end
			end
		elseif var11_62 then
			local var16_62 = var11_62:getContextByMediator(PreCombatMediator)

			if var16_62 then
				var11_62:removeChild(var16_62)
			end
		end

		arg0_62:sendNotification(GAME.GO_BACK)
	elseif var0_62 == var0_0.CLOSE_CHAT then
		arg0_62.viewComponent:OnCloseChat()
	elseif var0_62 == var0_0.HIDE_ALL_BUTTONS then
		ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name):DispatchEvent(ys.Event.New(ys.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
			isActive = var1_62
		}))
	elseif var0_62 == GAME.QUIT_BATTLE then
		var2_62:Stop()
	elseif var0_62 == var0_0.UPDATE_AUTO_COUNT then
		arg0_62:updateAutoCount(var1_62)
	end
end

function var0_0.remove(arg0_63)
	pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)
end

return var0_0
