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
		local var3_36 = {}

		for iter0_36, iter1_36 in ipairs(var2_36) do
			local var4_36 = iter1_36:getConfig("benefit_condition")
			local var5_36 = false

			if var4_36[1] == "chapter" then
				if var1_36 == SYSTEM_SCENARIO and table.contains(var4_36[2], getProxy(ChapterProxy):getActiveChapter().id) then
					var5_36 = true
				end
			else
				var5_36 = true
			end

			if var5_36 then
				table.insert(var3_36, iter1_36:getConfig("benefit_effect"))
			end
		end

		var0_36.GlobalBuffIDs = var3_36
	end

	local var6_36 = pg.battle_cost_template[var1_36]
	local var7_36 = getProxy(BayProxy)
	local var8_36 = {}

	if var1_36 == SYSTEM_SCENARIO then
		local var9_36 = getProxy(ChapterProxy)
		local var10_36 = var9_36:getActiveChapter()

		var0_36.RepressInfo = var10_36:getRepressInfo()

		arg0_36.viewComponent:setChapter(var10_36)

		local var11_36 = var10_36.fleet

		var0_36.KizunaJamming = var10_36:getExtraFlags()
		var0_36.DefeatCount = var11_36:getDefeatCount()
		var0_36.ChapterBuffIDs, var0_36.CommanderList = var10_36:getFleetBattleBuffs(var11_36)
		var0_36.StageWaveFlags = var10_36:GetStageFlags()
		var0_36.ChapterWeatherIDS = var10_36:GetWeather(var11_36.line.row, var11_36.line.column)
		var0_36.MapAuraSkills = var9_36.GetChapterAuraBuffs(var10_36)
		var0_36.MapAidSkills = {}
		var0_36.ChapterType = var10_36:getPlayType()

		local var12_36 = var9_36.GetChapterAidBuffs(var10_36)

		for iter2_36, iter3_36 in pairs(var12_36) do
			local var13_36 = var10_36:getFleetByShipVO(iter2_36)
			local var14_36 = _.values(var13_36:getCommanders())
			local var15_36 = var1_0(var1_36, iter2_36, var14_36)

			table.insert(var0_36.AidUnitList, var15_36)

			for iter4_36, iter5_36 in ipairs(iter3_36) do
				table.insert(var0_36.MapAidSkills, iter5_36)
			end
		end

		local var16_36 = var11_36:getShipsByTeam(TeamType.Main, false)
		local var17_36 = var11_36:getShipsByTeam(TeamType.Vanguard, false)
		local var18_36 = {}
		local var19_36 = _.values(var11_36:getCommanders())
		local var20_36 = {}
		local var21_36, var22_36 = var9_36.getSubAidFlag(var10_36, arg0_36.contextData.stageId)

		if var21_36 == true or var21_36 > 0 then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
			var18_36 = var22_36:getShipsByTeam(TeamType.Submarine, false)
			var20_36 = _.values(var22_36:getCommanders())

			local var23_36, var24_36 = var10_36:getFleetBattleBuffs(var22_36)

			var0_36.SubCommanderList = var24_36
		else
			var0_36.SubFlag = var21_36

			if var21_36 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_36.TotalSubAmmo = 0
			end
		end

		arg0_36.mainShips = {}

		local function var25_36(arg0_37, arg1_37, arg2_37)
			local var0_37 = arg0_37.id
			local var1_37 = arg0_37.hpRant * 0.0001

			if table.contains(var8_36, var0_37) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_36[#var8_36 + 1] = var0_37

			local var2_37 = var1_0(var1_36, arg0_37, arg1_37)

			var2_37.initHPRate = var1_37

			table.insert(arg0_36.mainShips, arg0_37)
			table.insert(arg2_37, var2_37)
		end

		for iter6_36, iter7_36 in ipairs(var16_36) do
			var25_36(iter7_36, var19_36, var0_36.MainUnitList)
		end

		for iter8_36, iter9_36 in ipairs(var17_36) do
			var25_36(iter9_36, var19_36, var0_36.VanguardUnitList)
		end

		for iter10_36, iter11_36 in ipairs(var18_36) do
			var25_36(iter11_36, var20_36, var0_36.SubUnitList)
		end

		local var26_36 = var10_36:getChapterSupportFleet()

		if var26_36 then
			local var27_36 = var26_36:getShips()

			for iter12_36, iter13_36 in pairs(var27_36) do
				var25_36(iter13_36, {}, var0_36.SupportUnitList)
			end
		end

		arg0_36.viewComponent:setFleet(var16_36, var17_36, var18_36)
	elseif var1_36 == SYSTEM_CHALLENGE then
		local var28_36 = arg0_36.contextData.mode
		local var29_36 = getProxy(ChallengeProxy):getUserChallengeInfo(var28_36)

		var0_36.ChallengeInfo = var29_36

		arg0_36.viewComponent:setChapter(var29_36)

		local var30_36 = var29_36:getRegularFleet()

		var0_36.CommanderList = var30_36:buildBattleBuffList()

		local var31_36 = _.values(var30_36:getCommanders())
		local var32_36 = {}
		local var33_36 = var30_36:getShipsByTeam(TeamType.Main, false)
		local var34_36 = var30_36:getShipsByTeam(TeamType.Vanguard, false)
		local var35_36 = {}
		local var36_36 = var29_36:getSubmarineFleet()
		local var37_36 = var36_36:getShipsByTeam(TeamType.Submarine, false)

		if #var37_36 > 0 then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
			var32_36 = _.values(var36_36:getCommanders())
			var0_36.SubCommanderList = var36_36:buildBattleBuffList()
		else
			var0_36.SubFlag = 0
			var0_36.TotalSubAmmo = 0
		end

		arg0_36.mainShips = {}

		local function var38_36(arg0_38, arg1_38, arg2_38)
			local var0_38 = arg0_38.id
			local var1_38 = arg0_38.hpRant * 0.0001

			if table.contains(var8_36, var0_38) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_36[#var8_36 + 1] = var0_38

			local var2_38 = var1_0(var1_36, arg0_38, arg1_38)

			var2_38.initHPRate = var1_38

			table.insert(arg0_36.mainShips, arg0_38)
			table.insert(arg2_38, var2_38)
		end

		for iter14_36, iter15_36 in ipairs(var33_36) do
			var38_36(iter15_36, var31_36, var0_36.MainUnitList)
		end

		for iter16_36, iter17_36 in ipairs(var34_36) do
			var38_36(iter17_36, var31_36, var0_36.VanguardUnitList)
		end

		for iter18_36, iter19_36 in ipairs(var37_36) do
			var38_36(iter19_36, var32_36, var0_36.SubUnitList)
		end

		arg0_36.viewComponent:setFleet(var33_36, var34_36, var37_36)
	elseif var1_36 == SYSTEM_WORLD then
		local var39_36 = nowWorld()
		local var40_36 = var39_36:GetActiveMap()
		local var41_36 = var40_36:GetFleet()
		local var42_36 = var40_36:GetCell(var41_36.row, var41_36.column):GetStageEnemy()

		if arg0_36.contextData.hpRate then
			var0_36.RepressInfo = {
				repressEnemyHpRant = arg0_36.contextData.hpRate
			}
		end

		var0_36.AffixBuffList = table.mergeArray(var42_36:GetBattleLuaBuffs(), var40_36:GetBattleLuaBuffs(WorldMap.FactionEnemy, var42_36))

		local function var43_36(arg0_39)
			local var0_39 = {}

			for iter0_39, iter1_39 in ipairs(arg0_39) do
				local var1_39 = {
					id = ys.Battle.BattleDataFunction.SkillTranform(var1_36, iter1_39.id),
					level = iter1_39.level
				}

				table.insert(var0_39, var1_39)
			end

			return var0_39
		end

		var0_36.DefeatCount = var41_36:getDefeatCount()
		var0_36.ChapterBuffIDs, var0_36.CommanderList = var40_36:getFleetBattleBuffs(var41_36, true)
		var0_36.MapAuraSkills = var40_36:GetChapterAuraBuffs()
		var0_36.MapAuraSkills = var43_36(var0_36.MapAuraSkills)
		var0_36.MapAidSkills = {}

		local var44_36 = var40_36:GetChapterAidBuffs()

		for iter20_36, iter21_36 in pairs(var44_36) do
			local var45_36 = var40_36:GetFleet(iter20_36.fleetId)
			local var46_36 = _.values(var45_36:getCommanders(true))
			local var47_36 = var1_0(var1_36, WorldConst.FetchShipVO(iter20_36.id), var46_36)

			table.insert(var0_36.AidUnitList, var47_36)

			var0_36.MapAidSkills = table.mergeArray(var0_36.MapAidSkills, var43_36(iter21_36))
		end

		local var48_36 = var41_36:GetTeamShipVOs(TeamType.Main, false)
		local var49_36 = var41_36:GetTeamShipVOs(TeamType.Vanguard, false)
		local var50_36 = {}
		local var51_36 = _.values(var41_36:getCommanders(true))
		local var52_36 = {}
		local var53_36 = var39_36:GetSubAidFlag()

		if var53_36 == true then
			local var54_36 = var40_36:GetSubmarineFleet()

			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
			var50_36 = var54_36:GetTeamShipVOs(TeamType.Submarine, false)
			var52_36 = _.values(var54_36:getCommanders(true))

			local var55_36, var56_36 = var40_36:getFleetBattleBuffs(var54_36, true)

			var0_36.SubCommanderList = var56_36
		else
			var0_36.SubFlag = 0

			if var53_36 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_36.TotalSubAmmo = 0
			end
		end

		arg0_36.mainShips = {}

		for iter22_36, iter23_36 in ipairs(var48_36) do
			local var57_36 = iter23_36.id
			local var58_36 = WorldConst.FetchWorldShip(iter23_36.id).hpRant * 0.0001

			if table.contains(var8_36, var57_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_36[#var8_36 + 1] = var57_36

			local var59_36 = var1_0(var1_36, iter23_36, var51_36)

			var59_36.initHPRate = var58_36

			table.insert(arg0_36.mainShips, iter23_36)
			table.insert(var0_36.MainUnitList, var59_36)
		end

		for iter24_36, iter25_36 in ipairs(var49_36) do
			local var60_36 = iter25_36.id
			local var61_36 = WorldConst.FetchWorldShip(iter25_36.id).hpRant * 0.0001

			if table.contains(var8_36, var60_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_36[#var8_36 + 1] = var60_36

			local var62_36 = var1_0(var1_36, iter25_36, var51_36)

			var62_36.initHPRate = var61_36

			table.insert(arg0_36.mainShips, iter25_36)
			table.insert(var0_36.VanguardUnitList, var62_36)
		end

		for iter26_36, iter27_36 in ipairs(var50_36) do
			local var63_36 = iter27_36.id
			local var64_36 = WorldConst.FetchWorldShip(iter27_36.id).hpRant * 0.0001

			if table.contains(var8_36, var63_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_36[#var8_36 + 1] = var63_36

			local var65_36 = var1_0(var1_36, iter27_36, var52_36)

			var65_36.initHPRate = var64_36

			table.insert(arg0_36.mainShips, iter27_36)
			table.insert(var0_36.SubUnitList, var65_36)
		end

		arg0_36.viewComponent:setFleet(var48_36, var49_36, var50_36)

		local var66_36 = pg.expedition_data_template[arg0_36.contextData.stageId]

		if var66_36.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
			var0_36.WorldMapId = var40_36.config.expedition_map_id
			var0_36.WorldLevel = WorldConst.WorldLevelCorrect(var40_36.config.expedition_level, var66_36.type)
		end
	elseif var1_36 == SYSTEM_WORLD_BOSS then
		local var67_36 = nowWorld():GetBossProxy()
		local var68_36 = arg0_36.contextData.bossId
		local var69_36 = var67_36:GetFleet(var68_36)
		local var70_36 = var67_36:GetBossById(var68_36)

		if arg0_36.contextData.hpRate then
			var0_36.RepressInfo = {
				repressEnemyHpRant = arg0_36.contextData.hpRate
			}
		end

		local var71_36 = _.values(var69_36:getCommanders())

		var0_36.CommanderList = var69_36:buildBattleBuffList()
		arg0_36.mainShips = var7_36:getShipsByFleet(var69_36)

		local var72_36 = {}
		local var73_36 = {}
		local var74_36 = {}
		local var75_36 = var69_36:getTeamByName(TeamType.Main)

		for iter28_36, iter29_36 in ipairs(var75_36) do
			if table.contains(var8_36, iter29_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_36[#var8_36 + 1] = iter29_36

			local var76_36 = var7_36:getShipById(iter29_36)
			local var77_36 = var1_0(var1_36, var76_36, var71_36)

			table.insert(var72_36, var76_36)
			table.insert(var0_36.MainUnitList, var77_36)
		end

		local var78_36 = var69_36:getTeamByName(TeamType.Vanguard)

		for iter30_36, iter31_36 in ipairs(var78_36) do
			if table.contains(var8_36, iter31_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_36[#var8_36 + 1] = iter31_36

			local var79_36 = var7_36:getShipById(iter31_36)
			local var80_36 = var1_0(var1_36, var79_36, var71_36)

			table.insert(var73_36, var79_36)
			table.insert(var0_36.VanguardUnitList, var80_36)
		end

		arg0_36.viewComponent:setFleet(var72_36, var73_36, var74_36)

		var0_36.MapAidSkills = {}

		if var70_36 and var70_36:IsSelf() then
			local var81_36, var82_36, var83_36 = var67_36.GetSupportValue()

			if var81_36 then
				table.insert(var0_36.MapAidSkills, {
					level = 1,
					id = var83_36
				})
			end
		end
	elseif var1_36 == SYSTEM_HP_SHARE_ACT_BOSS or var1_36 == SYSTEM_ACT_BOSS or var1_36 == SYSTEM_ACT_BOSS_SP or var1_36 == SYSTEM_BOSS_EXPERIMENT then
		if arg0_36.contextData.mainFleetId then
			local var84_36 = getProxy(FleetProxy):getActivityFleets()[arg0_36.contextData.actId]
			local var85_36 = var84_36[arg0_36.contextData.mainFleetId]
			local var86_36 = _.values(var85_36:getCommanders())

			var0_36.CommanderList = var85_36:buildBattleBuffList()
			arg0_36.mainShips = {}

			local var87_36 = {}
			local var88_36 = {}
			local var89_36 = {}

			local function var90_36(arg0_40, arg1_40, arg2_40, arg3_40)
				if table.contains(var8_36, arg0_40) then
					BattleVertify.cloneShipVertiry = true
				end

				var8_36[#var8_36 + 1] = arg0_40

				local var0_40 = var7_36:getShipById(arg0_40)
				local var1_40 = var1_0(var1_36, var0_40, arg1_40)

				table.insert(arg0_36.mainShips, var0_40)
				table.insert(arg3_40, var0_40)
				table.insert(arg2_40, var1_40)
			end

			local var91_36 = var85_36:getTeamByName(TeamType.Main)
			local var92_36 = var85_36:getTeamByName(TeamType.Vanguard)

			for iter32_36, iter33_36 in ipairs(var91_36) do
				var90_36(iter33_36, var86_36, var0_36.MainUnitList, var87_36)
			end

			for iter34_36, iter35_36 in ipairs(var92_36) do
				var90_36(iter35_36, var86_36, var0_36.VanguardUnitList, var88_36)
			end

			local var93_36 = var84_36[arg0_36.contextData.mainFleetId + 10]
			local var94_36 = _.values(var93_36:getCommanders())
			local var95_36 = var93_36:getTeamByName(TeamType.Submarine)

			for iter36_36, iter37_36 in ipairs(var95_36) do
				var90_36(iter37_36, var94_36, var0_36.SubUnitList, var89_36)
			end

			local var96_36 = getProxy(PlayerProxy):getRawData()
			local var97_36 = getProxy(ActivityProxy):getActivityById(arg0_36.contextData.actId)
			local var98_36 = var97_36:getConfig("config_id")
			local var99_36 = pg.activity_event_worldboss[var98_36].use_oil_limit[arg0_36.contextData.mainFleetId]
			local var100_36 = var97_36:IsOilLimit(arg0_36.contextData.stageId)
			local var101_36 = 0
			local var102_36 = var6_36.oil_cost > 0

			local function var103_36(arg0_41, arg1_41)
				if var102_36 then
					local var0_41 = arg0_41:getEndCost().oil

					if arg1_41 > 0 then
						local var1_41 = arg0_41:getStartCost().oil

						cost = math.clamp(arg1_41 - var1_41, 0, var0_41)
					end

					var101_36 = var101_36 + var0_41
				end
			end

			if var1_36 == SYSTEM_ACT_BOSS_SP then
				local var104_36 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0_36.contextData.actId).buffIds
				local var105_36 = _.map(var104_36, function(arg0_42)
					return ActivityBossBuff.New({
						configId = arg0_42
					})
				end)

				var0_36.ExtraBuffList = _.map(_.select(var105_36, function(arg0_43)
					return arg0_43:CastOnEnemy()
				end), function(arg0_44)
					return arg0_44:GetBuffID()
				end)
				var0_36.ChapterBuffIDs = _.map(_.select(var105_36, function(arg0_45)
					return not arg0_45:CastOnEnemy()
				end), function(arg0_46)
					return arg0_46:GetBuffID()
				end)
			else
				var103_36(var85_36, var100_36 and var99_36[1] or 0)
				var103_36(var93_36, var100_36 and var99_36[2] or 0)
			end

			if var93_36:isLegalToFight() == true and (var1_36 == SYSTEM_BOSS_EXPERIMENT or var101_36 <= var96_36.oil) then
				var0_36.SubFlag = 1
				var0_36.TotalSubAmmo = 1
			end

			var0_36.SubCommanderList = var93_36:buildBattleBuffList()

			arg0_36.viewComponent:setFleet(var87_36, var88_36, var89_36)
		end
	elseif var1_36 == SYSTEM_GUILD then
		local var106_36 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
		local var107_36 = var106_36:GetMainFleet()
		local var108_36 = _.values(var107_36:getCommanders())

		var0_36.CommanderList = var107_36:BuildBattleBuffList()
		arg0_36.mainShips = {}

		local var109_36 = {}
		local var110_36 = {}
		local var111_36 = {}

		local function var112_36(arg0_47, arg1_47, arg2_47, arg3_47)
			local var0_47 = var1_0(var1_36, arg0_47, arg1_47)

			table.insert(arg0_36.mainShips, arg0_47)
			table.insert(arg3_47, arg0_47)
			table.insert(arg2_47, var0_47)
		end

		local var113_36 = {}
		local var114_36 = {}
		local var115_36 = var107_36:GetShips()

		for iter38_36, iter39_36 in pairs(var115_36) do
			local var116_36 = iter39_36.ship

			if var116_36:getTeamType() == TeamType.Main then
				table.insert(var113_36, var116_36)
			elseif var116_36:getTeamType() == TeamType.Vanguard then
				table.insert(var114_36, var116_36)
			end
		end

		for iter40_36, iter41_36 in ipairs(var113_36) do
			var112_36(iter41_36, var108_36, var0_36.MainUnitList, var109_36)
		end

		for iter42_36, iter43_36 in ipairs(var114_36) do
			var112_36(iter43_36, var108_36, var0_36.VanguardUnitList, var110_36)
		end

		local var117_36 = var106_36:GetSubFleet()
		local var118_36 = _.values(var117_36:getCommanders())
		local var119_36 = {}
		local var120_36 = var117_36:GetShips()

		for iter44_36, iter45_36 in pairs(var120_36) do
			local var121_36 = iter45_36.ship

			if var121_36:getTeamType() == TeamType.Submarine then
				table.insert(var119_36, var121_36)
			end
		end

		for iter46_36, iter47_36 in ipairs(var119_36) do
			var112_36(iter47_36, var118_36, var0_36.SubUnitList, var111_36)
		end

		if #var111_36 > 0 then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
		end

		var0_36.SubCommanderList = var117_36:BuildBattleBuffList()

		arg0_36.viewComponent:setFleet(var109_36, var110_36, var111_36)
	elseif var1_36 == SYSTEM_BOSS_RUSH or var1_36 == SYSTEM_BOSS_RUSH_EX or var1_36 == SYSTEM_BOSS_RUSH_COLLABRATE then
		local var122_36 = getProxy(ActivityProxy):getActivityById(arg0_36.contextData.actId):GetSeriesData()

		assert(var122_36)

		local var123_36 = var122_36:GetStaegLevel() + 1
		local var124_36 = var122_36:GetFleetIds()
		local var125_36 = var124_36[var123_36]
		local var126_36 = var124_36[#var124_36]

		if var122_36:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var125_36 = var124_36[1]
		end

		local var127_36 = getProxy(FleetProxy):getActivityFleets()[arg0_36.contextData.actId]

		arg0_36.mainShips = {}

		local var128_36 = {}
		local var129_36 = {}
		local var130_36 = {}

		local function var131_36(arg0_48, arg1_48, arg2_48, arg3_48)
			if table.contains(var8_36, arg0_48) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_36[#var8_36 + 1] = arg0_48

			local var0_48 = var7_36:getShipById(arg0_48)
			local var1_48 = var1_0(var1_36, var0_48, arg1_48)

			table.insert(arg0_36.mainShips, var0_48)
			table.insert(arg3_48, var0_48)
			table.insert(arg2_48, var1_48)
		end

		local var132_36 = var127_36[var125_36]
		local var133_36 = _.values(var132_36:getCommanders())

		var0_36.CommanderList = var132_36:buildBattleBuffList()

		local var134_36 = var132_36:getTeamByName(TeamType.Main)
		local var135_36 = var132_36:getTeamByName(TeamType.Vanguard)

		for iter48_36, iter49_36 in ipairs(var134_36) do
			var131_36(iter49_36, var133_36, var0_36.MainUnitList, var128_36)
		end

		for iter50_36, iter51_36 in ipairs(var135_36) do
			var131_36(iter51_36, var133_36, var0_36.VanguardUnitList, var129_36)
		end

		local var136_36 = var127_36[var126_36]
		local var137_36 = _.values(var136_36:getCommanders())

		var0_36.SubCommanderList = var136_36:buildBattleBuffList()

		local var138_36 = var136_36:getTeamByName(TeamType.Submarine)

		for iter52_36, iter53_36 in ipairs(var138_36) do
			var131_36(iter53_36, var137_36, var0_36.SubUnitList, var130_36)
		end

		local var139_36 = getProxy(PlayerProxy):getRawData()
		local var140_36 = 0
		local var141_36 = var122_36:GetOilLimit()
		local var142_36 = var6_36.oil_cost > 0

		local function var143_36(arg0_49, arg1_49)
			local var0_49 = 0

			if var142_36 then
				local var1_49 = arg0_49:getStartCost().oil
				local var2_49 = arg0_49:getEndCost().oil

				var0_49 = var2_49

				if arg1_49 > 0 then
					var0_49 = math.clamp(arg1_49 - var1_49, 0, var2_49)
				end
			end

			return var0_49
		end

		local var144_36 = var140_36 + var143_36(var132_36, var141_36[1]) + var143_36(var136_36, var141_36[2])

		if var136_36:isLegalToFight() == true and var144_36 <= var139_36.oil then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
		end

		arg0_36.viewComponent:setFleet(var128_36, var129_36, var130_36)

		if var1_36 == SYSTEM_BOSS_RUSH_COLLABRATE then
			var0_36.ChapterBuffIDs = {}

			local var145_36 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)
			local var146_36 = var145_36:GetBuildingIds()

			for iter54_36, iter55_36 in ipairs(var146_36) do
				local var147_36 = var145_36:GetBuildingLevel(iter55_36)
				local var148_36 = var145_36:GetBuildingConfigTable(iter55_36).buff[var147_36]

				if var148_36 ~= 0 then
					local var149_36 = ActivityBuff.New(var145_36.id, var148_36)

					if var149_36:isActivate() and var149_36:getConfig("benefit_type") == ys.Battle.BattleConst.BATTLE_GLOBAL_BUFF then
						local var150_36 = var149_36:getConfig("benefit_effect")

						table.insert(var0_36.ChapterBuffIDs, var150_36)
					end
				end
			end

			var0_36.DALAidBuffIDs = {}

			local var151_36 = var122_36:getConfig("aid_buff")

			if var122_36:GetBossHpRate() <= var151_36[1] then
				table.insert(var0_36.DALAidBuffIDs, var151_36[2])
			end
		end
	elseif var1_36 == SYSTEM_LIMIT_CHALLENGE then
		local var152_36 = LimitChallengeConst.GetChallengeIDByStageID(arg0_36.contextData.stageId)

		var0_36.ExtraBuffList = AcessWithinNull(pg.expedition_constellation_challenge_template[var152_36], "buff_id")

		local var153_36 = FleetProxy.CHALLENGE_FLEET_ID
		local var154_36 = FleetProxy.CHALLENGE_SUB_FLEET_ID
		local var155_36 = getProxy(FleetProxy)
		local var156_36 = var155_36:getFleetById(var153_36)
		local var157_36 = var155_36:getFleetById(var154_36)

		arg0_36.mainShips = {}

		local var158_36 = {}
		local var159_36 = {}
		local var160_36 = {}

		local function var161_36(arg0_50, arg1_50, arg2_50, arg3_50)
			if table.contains(var8_36, arg0_50) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_36[#var8_36 + 1] = arg0_50

			local var0_50 = var7_36:getShipById(arg0_50)
			local var1_50 = var1_0(var1_36, var0_50, arg1_50)

			table.insert(arg0_36.mainShips, var0_50)
			table.insert(arg3_50, var0_50)
			table.insert(arg2_50, var1_50)
		end

		local var162_36 = _.values(var156_36:getCommanders())

		var0_36.CommanderList = var156_36:buildBattleBuffList()

		local var163_36 = var156_36:getTeamByName(TeamType.Main)
		local var164_36 = var156_36:getTeamByName(TeamType.Vanguard)

		for iter56_36, iter57_36 in ipairs(var163_36) do
			var161_36(iter57_36, var162_36, var0_36.MainUnitList, var158_36)
		end

		for iter58_36, iter59_36 in ipairs(var164_36) do
			var161_36(iter59_36, var162_36, var0_36.VanguardUnitList, var159_36)
		end

		local var165_36 = _.values(var157_36:getCommanders())

		var0_36.SubCommanderList = var157_36:buildBattleBuffList()

		local var166_36 = var157_36:getTeamByName(TeamType.Submarine)

		for iter60_36, iter61_36 in ipairs(var166_36) do
			var161_36(iter61_36, var165_36, var0_36.SubUnitList, var160_36)
		end

		local var167_36 = getProxy(PlayerProxy):getRawData()
		local var168_36 = 0
		local var169_36 = var6_36.oil_cost > 0

		local function var170_36(arg0_51, arg1_51)
			local var0_51 = 0

			if var169_36 then
				local var1_51 = arg0_51:getStartCost().oil
				local var2_51 = arg0_51:getEndCost().oil

				var0_51 = var2_51

				if arg1_51 > 0 then
					var0_51 = math.clamp(arg1_51 - var1_51, 0, var2_51)
				end
			end

			return var0_51
		end

		local var171_36 = var168_36 + var170_36(var156_36, 0) + var170_36(var157_36, 0)

		if var157_36:isLegalToFight() == true and var171_36 <= var167_36.oil then
			var0_36.SubFlag = 1
			var0_36.TotalSubAmmo = 1
		end

		arg0_36.viewComponent:setFleet(var158_36, var159_36, var160_36)
	elseif var1_36 == SYSTEM_CARDPUZZLE then
		local var172_36 = {}
		local var173_36 = {}
		local var174_36 = arg0_36.contextData.relics

		for iter62_36, iter63_36 in ipairs(arg0_36.contextData.cardPuzzleFleet) do
			local var175_36 = var2_0(iter63_36, var174_36)
			local var176_36 = var175_36.fleetIndex

			if var176_36 == 1 then
				table.insert(var173_36, var175_36)
				table.insert(var0_36.VanguardUnitList, var175_36)
			elseif var176_36 == 2 then
				table.insert(var172_36, var175_36)
				table.insert(var0_36.MainUnitList, var175_36)
			end
		end

		var0_36.CardPuzzleCardIDList = arg0_36.contextData.cards
		var0_36.CardPuzzleCommonHPValue = arg0_36.contextData.hp
		var0_36.CardPuzzleRelicList = var174_36
		var0_36.CardPuzzleCombatID = arg0_36.contextData.puzzleCombatID
	elseif var1_36 == SYSTEM_BOSS_SINGLE or var1_36 == SYSTEM_BOSS_SINGLE_VARIABLE then
		if arg0_36.contextData.mainFleetId then
			local var177_36 = getProxy(FleetProxy):getActivityFleets()[arg0_36.contextData.actId]
			local var178_36 = var177_36[arg0_36.contextData.mainFleetId]
			local var179_36 = _.values(var178_36:getCommanders())

			var0_36.CommanderList = var178_36:buildBattleBuffList()
			arg0_36.mainShips = {}

			local var180_36 = {}
			local var181_36 = {}
			local var182_36 = {}

			local function var183_36(arg0_52, arg1_52, arg2_52, arg3_52)
				if table.contains(var8_36, arg0_52) then
					BattleVertify.cloneShipVertiry = true
				end

				var8_36[#var8_36 + 1] = arg0_52

				local var0_52 = var7_36:getShipById(arg0_52)
				local var1_52 = var1_0(var1_36, var0_52, arg1_52)

				table.insert(arg0_36.mainShips, var0_52)
				table.insert(arg3_52, var0_52)
				table.insert(arg2_52, var1_52)
			end

			local var184_36 = var178_36:getTeamByName(TeamType.Main)
			local var185_36 = var178_36:getTeamByName(TeamType.Vanguard)

			for iter64_36, iter65_36 in ipairs(var184_36) do
				var183_36(iter65_36, var179_36, var0_36.MainUnitList, var180_36)
			end

			for iter66_36, iter67_36 in ipairs(var185_36) do
				var183_36(iter67_36, var179_36, var0_36.VanguardUnitList, var181_36)
			end

			local var186_36 = var1_36 == SYSTEM_BOSS_SINGLE_VARIABLE and 100 or 10
			local var187_36 = var177_36[arg0_36.contextData.mainFleetId + var186_36]

			if var187_36 then
				local var188_36 = _.values(var187_36:getCommanders())
				local var189_36 = var187_36:getTeamByName(TeamType.Submarine)

				for iter68_36, iter69_36 in ipairs(var189_36) do
					var183_36(iter69_36, var188_36, var0_36.SubUnitList, var182_36)
				end
			end

			local var190_36 = getProxy(PlayerProxy):getRawData()
			local var191_36 = getProxy(ActivityProxy):getActivityById(arg0_36.contextData.actId)

			var0_36.ChapterBuffIDs = var191_36:GetBuffIdsByStageId(arg0_36.contextData.stageId)

			local var192_36 = pg.strategy_data_template

			if arg0_36.contextData.variableBuffList then
				for iter70_36, iter71_36 in ipairs(arg0_36.contextData.variableBuffList) do
					table.insert(var0_36.ChapterBuffIDs, var192_36[iter71_36].buff_id)
				end
			end

			local var193_36 = var191_36:GetEnemyDataByStageId(arg0_36.contextData.stageId):GetOilLimit()
			local var194_36 = 0
			local var195_36 = var6_36.oil_cost > 0

			local function var196_36(arg0_53, arg1_53)
				if var195_36 then
					local var0_53 = arg0_53:getEndCost().oil

					if arg1_53 > 0 then
						local var1_53 = arg0_53:getStartCost().oil

						cost = math.clamp(arg1_53 - var1_53, 0, var0_53)
					end

					var194_36 = var194_36 + var0_53
				end
			end

			var196_36(var178_36, var193_36[1] or 0)

			if var187_36 then
				var196_36(var187_36, var193_36[2] or 0)

				if var187_36:isLegalToFight() == true and var194_36 <= var190_36.oil then
					var0_36.SubFlag = 1
					var0_36.TotalSubAmmo = 1
				end

				var0_36.SubCommanderList = var187_36:buildBattleBuffList()
			end

			arg0_36.viewComponent:setFleet(var180_36, var181_36, var182_36)
		end
	elseif var1_36 == SYSTEM_SCENARIO_SUB_STRIKE then
		local var197_36 = {}

		arg0_36.mainShips = {}

		local function var198_36(arg0_54, arg1_54, arg2_54)
			for iter0_54, iter1_54 in ipairs(arg0_54) do
				if table.contains(var8_36, iter1_54) then
					BattleVertify.cloneShipVertiry = true
				end

				var8_36[#var8_36 + 1] = iter1_54

				local var0_54 = var7_36:getShipById(iter1_54)
				local var1_54 = var1_0(var1_36, var0_54, nil)

				table.insert(arg1_54, var0_54)
				table.insert(arg0_36.mainShips, var0_54)
				table.insert(arg2_54, var1_54)
			end
		end

		local var199_36 = getProxy(ChapterProxy):getActiveChapter()

		arg0_36.viewComponent:setChapter(var199_36)
		arg0_36.viewComponent:setFleet(nil, nil, var197_36)

		local var200_36 = var199_36:getChapterSupportFleet():getTeamByName(TeamType.Submarine)

		var198_36(var200_36, var197_36, var0_36.SubUnitList)
	elseif arg0_36.contextData.mainFleetId then
		local var201_36 = var1_36 == SYSTEM_DUEL
		local var202_36 = getProxy(FleetProxy)
		local var203_36
		local var204_36
		local var205_36 = var202_36:getFleetById(arg0_36.contextData.mainFleetId)

		arg0_36.mainShips = var7_36:getShipsByFleet(var205_36)

		local var206_36 = {}
		local var207_36 = {}
		local var208_36 = {}

		local function var209_36(arg0_55, arg1_55, arg2_55)
			for iter0_55, iter1_55 in ipairs(arg0_55) do
				if table.contains(var8_36, iter1_55) then
					BattleVertify.cloneShipVertiry = true
				end

				var8_36[#var8_36 + 1] = iter1_55

				local var0_55 = var7_36:getShipById(iter1_55)
				local var1_55 = var1_0(var1_36, var0_55, nil, var201_36)

				table.insert(arg1_55, var0_55)
				table.insert(arg2_55, var1_55)
			end
		end

		local var210_36 = var205_36:getTeamByName(TeamType.Main)
		local var211_36 = var205_36:getTeamByName(TeamType.Vanguard)
		local var212_36 = var205_36:getTeamByName(TeamType.Submarine)

		var209_36(var210_36, var206_36, var0_36.MainUnitList)
		var209_36(var211_36, var207_36, var0_36.VanguardUnitList)
		var209_36(var212_36, var208_36, var0_36.SubUnitList)
		arg0_36.viewComponent:setFleet(var206_36, var207_36, var208_36)

		if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
			local var213_36 = var202_36:getFleetById(11)
			local var214_36 = var213_36:getTeamByName(TeamType.Submarine)

			if #var214_36 > 0 then
				var0_36.SubFlag = 1
				var0_36.TotalSubAmmo = 1

				local var215_36 = _.values(var213_36:getCommanders())

				var0_36.SubCommanderList = var213_36:buildBattleBuffList()

				for iter72_36, iter73_36 in ipairs(var214_36) do
					local var216_36 = var7_36:getShipById(iter73_36)
					local var217_36 = var1_0(var1_36, var216_36, var215_36, var201_36)

					table.insert(var208_36, var216_36)
					table.insert(var0_36.SubUnitList, var217_36)
				end
			end
		end
	end

	if var1_36 == SYSTEM_WORLD then
		local var218_36 = nowWorld()
		local var219_36 = var218_36:GetActiveMap()
		local var220_36 = var219_36:GetFleet()
		local var221_36 = var219_36:GetCell(var220_36.row, var220_36.column):GetStageEnemy()
		local var222_36 = pg.world_expedition_data[arg0_36.contextData.stageId]
		local var223_36 = var218_36:GetWorldMapDifficultyBuffLevel()

		var0_36.EnemyMapRewards = {
			var223_36[1] * (1 + var222_36.expedition_sairenvalueA / 10000),
			var223_36[2] * (1 + var222_36.expedition_sairenvalueB / 10000),
			var223_36[3] * (1 + var222_36.expedition_sairenvalueC / 10000)
		}
		var0_36.FleetMapRewards = var218_36:GetWorldMapBuffLevel()
	end

	var0_36.RivalMainUnitList, var0_36.RivalVanguardUnitList = {}, {}

	local var224_36

	if var1_36 == SYSTEM_DUEL and arg0_36.contextData.rivalId then
		local var225_36 = getProxy(MilitaryExerciseProxy)

		var224_36 = var225_36:getRivalById(arg0_36.contextData.rivalId)
		arg0_36.oldRank = var225_36:getSeasonInfo()
	end

	if var224_36 then
		var0_36.RivalVO = var224_36

		local var226_36 = 0

		for iter74_36, iter75_36 in ipairs(var224_36.mainShips) do
			var226_36 = var226_36 + iter75_36.level
		end

		for iter76_36, iter77_36 in ipairs(var224_36.vanguardShips) do
			var226_36 = var226_36 + iter77_36.level
		end

		BattleVertify = BattleVertify or {}
		BattleVertify.rivalLevel = var226_36

		for iter78_36, iter79_36 in ipairs(var224_36.mainShips) do
			if not iter79_36.hpRant or iter79_36.hpRant > 0 then
				local var227_36 = var1_0(var1_36, iter79_36, nil, true)

				if iter79_36.hpRant then
					var227_36.initHPRate = iter79_36.hpRant * 0.0001
				end

				table.insert(var0_36.RivalMainUnitList, var227_36)
			end
		end

		for iter80_36, iter81_36 in ipairs(var224_36.vanguardShips) do
			if not iter81_36.hpRant or iter81_36.hpRant > 0 then
				local var228_36 = var1_0(var1_36, iter81_36, nil, true)

				if iter81_36.hpRant then
					var228_36.initHPRate = iter81_36.hpRant * 0.0001
				end

				table.insert(var0_36.RivalVanguardUnitList, var228_36)
			end
		end
	end

	local var229_36 = arg0_36.contextData.prefabFleet.main_unitList
	local var230_36 = arg0_36.contextData.prefabFleet.vanguard_unitList
	local var231_36 = arg0_36.contextData.prefabFleet.submarine_unitList

	if var229_36 then
		for iter82_36, iter83_36 in ipairs(var229_36) do
			local var232_36 = {}

			for iter84_36, iter85_36 in ipairs(iter83_36.equipment) do
				var232_36[#var232_36 + 1] = {
					skin = 0,
					id = iter85_36
				}
			end

			local var233_36 = {
				id = iter83_36.id,
				tmpID = iter83_36.configId,
				skinId = iter83_36.skinId,
				level = iter83_36.level,
				equipment = var232_36,
				properties = iter83_36.properties,
				baseProperties = iter83_36.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter83_36.skills
			}

			table.insert(var0_36.MainUnitList, var233_36)
		end
	end

	if var230_36 then
		for iter86_36, iter87_36 in ipairs(var230_36) do
			local var234_36 = {}

			for iter88_36, iter89_36 in ipairs(iter87_36.equipment) do
				var234_36[#var234_36 + 1] = {
					skin = 0,
					id = iter89_36
				}
			end

			local var235_36 = {
				id = iter87_36.id,
				tmpID = iter87_36.configId,
				skinId = iter87_36.skinId,
				level = iter87_36.level,
				equipment = var234_36,
				properties = iter87_36.properties,
				baseProperties = iter87_36.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter87_36.skills
			}

			table.insert(var0_36.VanguardUnitList, var235_36)
		end
	end

	if var231_36 then
		for iter90_36, iter91_36 in ipairs(var231_36) do
			local var236_36 = {}

			for iter92_36, iter93_36 in ipairs(iter91_36.equipment) do
				var236_36[#var236_36 + 1] = {
					skin = 0,
					id = iter93_36
				}
			end

			local var237_36 = {
				id = iter91_36.id,
				tmpID = iter91_36.configId,
				skinId = iter91_36.skinId,
				level = iter91_36.level,
				equipment = var236_36,
				properties = iter91_36.properties,
				baseProperties = iter91_36.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter91_36.skills
			}

			table.insert(var0_36.SubUnitList, var237_36)

			if var1_36 == SYSTEM_SIMULATION and #var0_36.SubUnitList > 0 then
				var0_36.SubFlag = 1
				var0_36.TotalSubAmmo = 1
			end
		end
	end
end

function var0_0.listNotificationInterests(arg0_56)
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

function var0_0.handleNotification(arg0_57, arg1_57)
	local var0_57 = arg1_57:getName()
	local var1_57 = arg1_57:getBody()
	local var2_57 = ys.Battle.BattleState.GetInstance()
	local var3_57 = arg0_57.contextData.system

	if var0_57 == GAME.FINISH_STAGE_DONE then
		pg.MsgboxMgr.GetInstance():hide()

		local var4_57 = var1_57.system

		if var4_57 == SYSTEM_PROLOGUE then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_57:sendNotification(GAME.CHANGE_SCENE, SCENE.CREATE_PLAYER)
		elseif var4_57 == SYSTEM_PERFORM or var4_57 == SYSTEM_SIMULATION then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_57.viewComponent:exitBattle()

			if var1_57.exitCallback then
				var1_57.exitCallback()
			end
		else
			local var5_57 = BattleResultMediator.GetResultView(var4_57)
			local var6_57 = {}

			if var4_57 == SYSTEM_SCENARIO then
				var6_57 = getProxy(ChapterProxy):getActiveChapter().operationBuffList
			end

			arg0_57:addSubLayers(Context.New({
				mediator = NewBattleResultMediator,
				viewComponent = NewBattleResultScene,
				data = {
					system = var4_57,
					rivalId = arg0_57.contextData.rivalId,
					mainFleetId = arg0_57.contextData.mainFleetId,
					stageId = arg0_57.contextData.stageId,
					oldMainShips = arg0_57.mainShips or {},
					oldPlayer = arg0_57.player,
					oldRank = arg0_57.oldRank,
					statistics = var1_57.statistics,
					score = var1_57.score,
					drops = var1_57.drops,
					bossId = var1_57.bossId,
					name = var1_57.name,
					prefabFleet = var1_57.prefabFleet,
					commanderExps = var1_57.commanderExps,
					actId = arg0_57.contextData.actId,
					result = var1_57.result,
					extraDrops = var1_57.extraDrops,
					extraBuffList = var6_57,
					isLastBonus = var1_57.isLastBonus,
					continuousBattleTimes = arg0_57.contextData.continuousBattleTimes,
					totalBattleTimes = arg0_57.contextData.totalBattleTimes,
					mode = arg0_57.contextData.mode,
					cmdArgs = arg0_57.contextData.cmdArgs,
					variableBuffList = arg0_57.contextData.variableBuffList,
					useVariableTicket = arg0_57.contextData.useVariableTicket
				}
			}))
		end
	elseif var0_57 == GAME.STORY_BEGIN then
		var2_57:Pause()
	elseif var0_57 == GAME.STORY_END then
		var2_57:Resume()
	elseif var0_57 == GAME.START_GUIDE then
		var2_57:Pause()
	elseif var0_57 == GAME.END_GUIDE then
		var2_57:Resume()
	elseif var0_57 == GAME.PAUSE_BATTLE then
		if not var2_57:IsPause() then
			arg0_57:onPauseBtn()
		end
	elseif var0_57 == GAME.RESUME_BATTLE then
		var2_57:Resume()
	elseif var0_57 == GAME.FINISH_STAGE_ERROR then
		gcAll(true)

		local var7_57 = getProxy(ContextProxy)
		local var8_57 = var7_57:getContextByMediator(DailyLevelMediator)
		local var9_57 = var7_57:getContextByMediator(LevelMediator2)
		local var10_57 = var7_57:getContextByMediator(ChallengeMainMediator)
		local var11_57 = var7_57:getContextByMediator(ActivityBossMediatorTemplate)

		if var8_57 then
			local var12_57 = var8_57:getContextByMediator(PreCombatMediator)

			var8_57:removeChild(var12_57)
		elseif var10_57 then
			local var13_57 = var10_57:getContextByMediator(ChallengePreCombatMediator)

			var10_57:removeChild(var13_57)
		elseif var9_57 then
			if var3_57 == SYSTEM_DUEL then
				-- block empty
			elseif var3_57 == SYSTEM_SCENARIO then
				local var14_57 = var9_57:getContextByMediator(ChapterPreCombatMediator)

				var9_57:removeChild(var14_57)
			elseif var3_57 ~= SYSTEM_PERFORM and var3_57 ~= SYSTEM_SIMULATION then
				local var15_57 = var9_57:getContextByMediator(PreCombatMediator)

				if var15_57 then
					var9_57:removeChild(var15_57)
				end
			end
		elseif var11_57 then
			local var16_57 = var11_57:getContextByMediator(PreCombatMediator)

			if var16_57 then
				var11_57:removeChild(var16_57)
			end
		end

		arg0_57:sendNotification(GAME.GO_BACK)
	elseif var0_57 == var0_0.CLOSE_CHAT then
		arg0_57.viewComponent:OnCloseChat()
	elseif var0_57 == var0_0.HIDE_ALL_BUTTONS then
		ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name):DispatchEvent(ys.Event.New(ys.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
			isActive = var1_57
		}))
	elseif var0_57 == GAME.QUIT_BATTLE then
		var2_57:Stop()
	elseif var0_57 == var0_0.UPDATE_AUTO_COUNT then
		arg0_57:updateAutoCount(var1_57)
	end
end

function var0_0.remove(arg0_58)
	pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)
end

return var0_0
