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
	else
		var3_27 = i18n("battle_battleMediator_quest_exist")
	end

	local function var6_27()
		if arg1_27 then
			arg1_27()
		end

		local var0_29 = arg0_27.viewComponent.leaveBtn:GetComponent(typeof(Animation))

		if var0_29 then
			var0_29:Play("msgbox_btn_into")
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

function var0_0.guideDispatch(arg0_30)
	return
end

local function var1_0(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = {}

	for iter0_31, iter1_31 in ipairs(arg1_31:getActiveEquipments()) do
		if iter1_31 then
			var0_31[#var0_31 + 1] = {
				id = iter1_31.configId,
				skin = iter1_31.skinId,
				equipmentInfo = iter1_31
			}
		else
			var0_31[#var0_31 + 1] = {
				skin = 0,
				id = iter1_31,
				equipmentInfo = iter1_31
			}
		end
	end

	local var1_31 = {}

	local function var2_31(arg0_32)
		local var0_32 = {
			level = arg0_32.level
		}
		local var1_32 = arg0_32.id
		local var2_32 = arg1_31:RemapSkillId(var1_32)

		var0_32.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_31, var2_32)

		return var0_32
	end

	local var3_31 = ys.Battle.BattleDataFunction.GenerateHiddenBuff(arg1_31.configId)

	for iter2_31, iter3_31 in pairs(var3_31) do
		local var4_31 = var2_31(iter3_31)

		var1_31[var4_31.id] = var4_31
	end

	for iter4_31, iter5_31 in pairs(arg1_31.skills) do
		if iter5_31 and iter5_31.id == 14900 and not arg1_31.transforms[16412] then
			-- block empty
		else
			local var5_31 = var2_31(iter5_31)

			var1_31[var5_31.id] = var5_31
		end
	end

	local var6_31 = ys.Battle.BattleDataFunction.GetEquipSkill(var0_31)

	for iter6_31, iter7_31 in ipairs(var6_31) do
		local var7_31 = {
			level = iter7_31.buffLV,
			id = ys.Battle.BattleDataFunction.SkillTranform(arg0_31, iter7_31.buffID)
		}

		var1_31[var7_31.id] = var7_31
	end

	local var8_31

	;(function()
		var8_31 = arg1_31:GetSpWeapon()

		if not var8_31 then
			return
		end

		local var0_33 = var8_31:GetEffect()

		if var0_33 == 0 then
			return
		end

		local var1_33 = {}

		var1_33.level = 1
		var1_33.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_31, var0_33)
		var1_31[var1_33.id] = var1_33
	end)()

	for iter8_31, iter9_31 in pairs(arg1_31:getTriggerSkills()) do
		local var9_31 = {
			level = iter9_31.level,
			id = ys.Battle.BattleDataFunction.SkillTranform(arg0_31, iter9_31.id)
		}

		var1_31[var9_31.id] = var9_31
	end

	local var10_31 = arg0_31 == SYSTEM_WORLD
	local var11_31 = false

	if var10_31 then
		local var12_31 = WorldConst.FetchWorldShip(arg1_31.id)

		if var12_31 then
			var11_31 = var12_31:IsBroken()
		end
	end

	if var11_31 then
		for iter10_31, iter11_31 in pairs(var1_31) do
			local var13_31 = pg.skill_data_template[iter10_31].world_death_mark[1]

			if var13_31 == ys.Battle.BattleConst.DEATH_MARK_SKILL.DEACTIVE then
				var1_31[iter10_31] = nil
			elseif var13_31 == ys.Battle.BattleConst.DEATH_MARK_SKILL.IGNORE then
				-- block empty
			end
		end
	end

	return {
		id = arg1_31.id,
		tmpID = arg1_31.configId,
		skinId = arg1_31.skinId,
		level = arg1_31.level,
		equipment = var0_31,
		properties = arg1_31:getProperties(arg2_31, arg3_31, var10_31),
		baseProperties = arg1_31:getShipProperties(),
		proficiency = arg1_31:getEquipProficiencyList(),
		rarity = arg1_31:getRarity(),
		intimacy = arg1_31:getCVIntimacy(),
		shipGS = arg1_31:getShipCombatPower(),
		skills = var1_31,
		baseList = arg1_31:getBaseList(),
		preloasList = arg1_31:getPreLoadCount(),
		name = arg1_31:getName(),
		deathMark = var11_31,
		spWeapon = var8_31
	}
end

local function var2_0(arg0_34, arg1_34)
	local var0_34 = arg0_34:getProperties(arg1_34)
	local var1_34 = arg0_34:getConfig("id")

	return {
		deathMark = false,
		shipGS = 100,
		rarity = 1,
		intimacy = 100,
		id = var1_34,
		tmpID = var1_34,
		skinId = arg0_34:getConfig("skin_id"),
		level = arg0_34:getConfig("level"),
		equipment = arg0_34:getConfig("default_equip"),
		properties = var0_34,
		baseProperties = var0_34,
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
		name = var1_34,
		fleetIndex = arg0_34:getConfig("location")
	}
end

function var0_0.GenBattleData(arg0_35)
	local var0_35 = {}
	local var1_35 = arg0_35.contextData.system

	arg0_35._battleData = var0_35
	var0_35.battleType = arg0_35.contextData.system
	var0_35.StageTmpId = arg0_35.contextData.stageId
	var0_35.CMDArgs = arg0_35.contextData.cmdArgs
	var0_35.isMemory = arg0_35.contextData.memory
	var0_35.MainUnitList = {}
	var0_35.VanguardUnitList = {}
	var0_35.SubUnitList = {}
	var0_35.AidUnitList = {}
	var0_35.SupportUnitList = {}
	var0_35.SubFlag = -1
	var0_35.ActID = arg0_35.contextData.actId
	var0_35.bossLevel = arg0_35.contextData.bossLevel
	var0_35.bossConfigId = arg0_35.contextData.bossConfigId

	if pg.battle_cost_template[var1_35].global_buff_effected > 0 then
		local var2_35 = BuffHelper.GetBattleBuffs(var1_35)
		local var3_35 = {}

		for iter0_35, iter1_35 in ipairs(var2_35) do
			local var4_35 = iter1_35:getConfig("benefit_condition")
			local var5_35 = false

			if var4_35[1] == "chapter" then
				if var1_35 == SYSTEM_SCENARIO and table.contains(var4_35[2], getProxy(ChapterProxy):getActiveChapter().id) then
					var5_35 = true
				end
			else
				var5_35 = true
			end

			if var5_35 then
				table.insert(var3_35, iter1_35:getConfig("benefit_effect"))
			end
		end

		var0_35.GlobalBuffIDs = var3_35
	end

	local var6_35 = pg.battle_cost_template[var1_35]
	local var7_35 = getProxy(BayProxy)
	local var8_35 = {}

	if var1_35 == SYSTEM_SCENARIO then
		local var9_35 = getProxy(ChapterProxy)
		local var10_35 = var9_35:getActiveChapter()

		var0_35.RepressInfo = var10_35:getRepressInfo()

		arg0_35.viewComponent:setChapter(var10_35)

		local var11_35 = var10_35.fleet

		var0_35.KizunaJamming = var10_35.extraFlagList
		var0_35.DefeatCount = var11_35:getDefeatCount()
		var0_35.ChapterBuffIDs, var0_35.CommanderList = var10_35:getFleetBattleBuffs(var11_35)
		var0_35.StageWaveFlags = var10_35:GetStageFlags()
		var0_35.ChapterWeatherIDS = var10_35:GetWeather(var11_35.line.row, var11_35.line.column)
		var0_35.MapAuraSkills = var9_35.GetChapterAuraBuffs(var10_35)
		var0_35.MapAidSkills = {}
		var0_35.ChapterType = var10_35:getPlayType()

		local var12_35 = var9_35.GetChapterAidBuffs(var10_35)

		for iter2_35, iter3_35 in pairs(var12_35) do
			local var13_35 = var10_35:getFleetByShipVO(iter2_35)
			local var14_35 = _.values(var13_35:getCommanders())
			local var15_35 = var1_0(var1_35, iter2_35, var14_35)

			table.insert(var0_35.AidUnitList, var15_35)

			for iter4_35, iter5_35 in ipairs(iter3_35) do
				table.insert(var0_35.MapAidSkills, iter5_35)
			end
		end

		local var16_35 = var11_35:getShipsByTeam(TeamType.Main, false)
		local var17_35 = var11_35:getShipsByTeam(TeamType.Vanguard, false)
		local var18_35 = {}
		local var19_35 = _.values(var11_35:getCommanders())
		local var20_35 = {}
		local var21_35, var22_35 = var9_35.getSubAidFlag(var10_35, arg0_35.contextData.stageId)

		if var21_35 == true or var21_35 > 0 then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
			var18_35 = var22_35:getShipsByTeam(TeamType.Submarine, false)
			var20_35 = _.values(var22_35:getCommanders())

			local var23_35, var24_35 = var10_35:getFleetBattleBuffs(var22_35)

			var0_35.SubCommanderList = var24_35
		else
			var0_35.SubFlag = var21_35

			if var21_35 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_35.TotalSubAmmo = 0
			end
		end

		arg0_35.mainShips = {}

		local function var25_35(arg0_36, arg1_36, arg2_36)
			local var0_36 = arg0_36.id
			local var1_36 = arg0_36.hpRant * 0.0001

			if table.contains(var8_35, var0_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_35[#var8_35 + 1] = var0_36

			local var2_36 = var1_0(var1_35, arg0_36, arg1_36)

			var2_36.initHPRate = var1_36

			table.insert(arg0_35.mainShips, arg0_36)
			table.insert(arg2_36, var2_36)
		end

		for iter6_35, iter7_35 in ipairs(var16_35) do
			var25_35(iter7_35, var19_35, var0_35.MainUnitList)
		end

		for iter8_35, iter9_35 in ipairs(var17_35) do
			var25_35(iter9_35, var19_35, var0_35.VanguardUnitList)
		end

		for iter10_35, iter11_35 in ipairs(var18_35) do
			var25_35(iter11_35, var20_35, var0_35.SubUnitList)
		end

		local var26_35 = var10_35:getChapterSupportFleet()

		if var26_35 then
			local var27_35 = var26_35:getShips()

			for iter12_35, iter13_35 in pairs(var27_35) do
				var25_35(iter13_35, {}, var0_35.SupportUnitList)
			end
		end

		arg0_35.viewComponent:setFleet(var16_35, var17_35, var18_35)
	elseif var1_35 == SYSTEM_CHALLENGE then
		local var28_35 = arg0_35.contextData.mode
		local var29_35 = getProxy(ChallengeProxy):getUserChallengeInfo(var28_35)

		var0_35.ChallengeInfo = var29_35

		arg0_35.viewComponent:setChapter(var29_35)

		local var30_35 = var29_35:getRegularFleet()

		var0_35.CommanderList = var30_35:buildBattleBuffList()

		local var31_35 = _.values(var30_35:getCommanders())
		local var32_35 = {}
		local var33_35 = var30_35:getShipsByTeam(TeamType.Main, false)
		local var34_35 = var30_35:getShipsByTeam(TeamType.Vanguard, false)
		local var35_35 = {}
		local var36_35 = var29_35:getSubmarineFleet()
		local var37_35 = var36_35:getShipsByTeam(TeamType.Submarine, false)

		if #var37_35 > 0 then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
			var32_35 = _.values(var36_35:getCommanders())
			var0_35.SubCommanderList = var36_35:buildBattleBuffList()
		else
			var0_35.SubFlag = 0
			var0_35.TotalSubAmmo = 0
		end

		arg0_35.mainShips = {}

		local function var38_35(arg0_37, arg1_37, arg2_37)
			local var0_37 = arg0_37.id
			local var1_37 = arg0_37.hpRant * 0.0001

			if table.contains(var8_35, var0_37) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_35[#var8_35 + 1] = var0_37

			local var2_37 = var1_0(var1_35, arg0_37, arg1_37)

			var2_37.initHPRate = var1_37

			table.insert(arg0_35.mainShips, arg0_37)
			table.insert(arg2_37, var2_37)
		end

		for iter14_35, iter15_35 in ipairs(var33_35) do
			var38_35(iter15_35, var31_35, var0_35.MainUnitList)
		end

		for iter16_35, iter17_35 in ipairs(var34_35) do
			var38_35(iter17_35, var31_35, var0_35.VanguardUnitList)
		end

		for iter18_35, iter19_35 in ipairs(var37_35) do
			var38_35(iter19_35, var32_35, var0_35.SubUnitList)
		end

		arg0_35.viewComponent:setFleet(var33_35, var34_35, var37_35)
	elseif var1_35 == SYSTEM_WORLD then
		local var39_35 = nowWorld()
		local var40_35 = var39_35:GetActiveMap()
		local var41_35 = var40_35:GetFleet()
		local var42_35 = var40_35:GetCell(var41_35.row, var41_35.column):GetStageEnemy()

		if arg0_35.contextData.hpRate then
			var0_35.RepressInfo = {
				repressEnemyHpRant = arg0_35.contextData.hpRate
			}
		end

		var0_35.AffixBuffList = table.mergeArray(var42_35:GetBattleLuaBuffs(), var40_35:GetBattleLuaBuffs(WorldMap.FactionEnemy, var42_35))

		local function var43_35(arg0_38)
			local var0_38 = {}

			for iter0_38, iter1_38 in ipairs(arg0_38) do
				local var1_38 = {
					id = ys.Battle.BattleDataFunction.SkillTranform(var1_35, iter1_38.id),
					level = iter1_38.level
				}

				table.insert(var0_38, var1_38)
			end

			return var0_38
		end

		var0_35.DefeatCount = var41_35:getDefeatCount()
		var0_35.ChapterBuffIDs, var0_35.CommanderList = var40_35:getFleetBattleBuffs(var41_35, true)
		var0_35.MapAuraSkills = var40_35:GetChapterAuraBuffs()
		var0_35.MapAuraSkills = var43_35(var0_35.MapAuraSkills)
		var0_35.MapAidSkills = {}

		local var44_35 = var40_35:GetChapterAidBuffs()

		for iter20_35, iter21_35 in pairs(var44_35) do
			local var45_35 = var40_35:GetFleet(iter20_35.fleetId)
			local var46_35 = _.values(var45_35:getCommanders(true))
			local var47_35 = var1_0(var1_35, WorldConst.FetchShipVO(iter20_35.id), var46_35)

			table.insert(var0_35.AidUnitList, var47_35)

			var0_35.MapAidSkills = table.mergeArray(var0_35.MapAidSkills, var43_35(iter21_35))
		end

		local var48_35 = var41_35:GetTeamShipVOs(TeamType.Main, false)
		local var49_35 = var41_35:GetTeamShipVOs(TeamType.Vanguard, false)
		local var50_35 = {}
		local var51_35 = _.values(var41_35:getCommanders(true))
		local var52_35 = {}
		local var53_35 = var39_35:GetSubAidFlag()

		if var53_35 == true then
			local var54_35 = var40_35:GetSubmarineFleet()

			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
			var50_35 = var54_35:GetTeamShipVOs(TeamType.Submarine, false)
			var52_35 = _.values(var54_35:getCommanders(true))

			local var55_35, var56_35 = var40_35:getFleetBattleBuffs(var54_35, true)

			var0_35.SubCommanderList = var56_35
		else
			var0_35.SubFlag = 0

			if var53_35 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_35.TotalSubAmmo = 0
			end
		end

		arg0_35.mainShips = {}

		for iter22_35, iter23_35 in ipairs(var48_35) do
			local var57_35 = iter23_35.id
			local var58_35 = WorldConst.FetchWorldShip(iter23_35.id).hpRant * 0.0001

			if table.contains(var8_35, var57_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_35[#var8_35 + 1] = var57_35

			local var59_35 = var1_0(var1_35, iter23_35, var51_35)

			var59_35.initHPRate = var58_35

			table.insert(arg0_35.mainShips, iter23_35)
			table.insert(var0_35.MainUnitList, var59_35)
		end

		for iter24_35, iter25_35 in ipairs(var49_35) do
			local var60_35 = iter25_35.id
			local var61_35 = WorldConst.FetchWorldShip(iter25_35.id).hpRant * 0.0001

			if table.contains(var8_35, var60_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_35[#var8_35 + 1] = var60_35

			local var62_35 = var1_0(var1_35, iter25_35, var51_35)

			var62_35.initHPRate = var61_35

			table.insert(arg0_35.mainShips, iter25_35)
			table.insert(var0_35.VanguardUnitList, var62_35)
		end

		for iter26_35, iter27_35 in ipairs(var50_35) do
			local var63_35 = iter27_35.id
			local var64_35 = WorldConst.FetchWorldShip(iter27_35.id).hpRant * 0.0001

			if table.contains(var8_35, var63_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_35[#var8_35 + 1] = var63_35

			local var65_35 = var1_0(var1_35, iter27_35, var52_35)

			var65_35.initHPRate = var64_35

			table.insert(arg0_35.mainShips, iter27_35)
			table.insert(var0_35.SubUnitList, var65_35)
		end

		arg0_35.viewComponent:setFleet(var48_35, var49_35, var50_35)

		local var66_35 = pg.expedition_data_template[arg0_35.contextData.stageId]

		if var66_35.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
			var0_35.WorldMapId = var40_35.config.expedition_map_id
			var0_35.WorldLevel = WorldConst.WorldLevelCorrect(var40_35.config.expedition_level, var66_35.type)
		end
	elseif var1_35 == SYSTEM_WORLD_BOSS then
		local var67_35 = nowWorld():GetBossProxy()
		local var68_35 = arg0_35.contextData.bossId
		local var69_35 = var67_35:GetFleet(var68_35)
		local var70_35 = var67_35:GetBossById(var68_35)

		if arg0_35.contextData.hpRate then
			var0_35.RepressInfo = {
				repressEnemyHpRant = arg0_35.contextData.hpRate
			}
		end

		local var71_35 = _.values(var69_35:getCommanders())

		var0_35.CommanderList = var69_35:buildBattleBuffList()
		arg0_35.mainShips = var7_35:getShipsByFleet(var69_35)

		local var72_35 = {}
		local var73_35 = {}
		local var74_35 = {}
		local var75_35 = var69_35:getTeamByName(TeamType.Main)

		for iter28_35, iter29_35 in ipairs(var75_35) do
			if table.contains(var8_35, iter29_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_35[#var8_35 + 1] = iter29_35

			local var76_35 = var7_35:getShipById(iter29_35)
			local var77_35 = var1_0(var1_35, var76_35, var71_35)

			table.insert(var72_35, var76_35)
			table.insert(var0_35.MainUnitList, var77_35)
		end

		local var78_35 = var69_35:getTeamByName(TeamType.Vanguard)

		for iter30_35, iter31_35 in ipairs(var78_35) do
			if table.contains(var8_35, iter31_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_35[#var8_35 + 1] = iter31_35

			local var79_35 = var7_35:getShipById(iter31_35)
			local var80_35 = var1_0(var1_35, var79_35, var71_35)

			table.insert(var73_35, var79_35)
			table.insert(var0_35.VanguardUnitList, var80_35)
		end

		arg0_35.viewComponent:setFleet(var72_35, var73_35, var74_35)

		var0_35.MapAidSkills = {}

		if var70_35 and var70_35:IsSelf() then
			local var81_35, var82_35, var83_35 = var67_35.GetSupportValue()

			if var81_35 then
				table.insert(var0_35.MapAidSkills, {
					level = 1,
					id = var83_35
				})
			end
		end
	elseif var1_35 == SYSTEM_HP_SHARE_ACT_BOSS or var1_35 == SYSTEM_ACT_BOSS or var1_35 == SYSTEM_ACT_BOSS_SP or var1_35 == SYSTEM_BOSS_EXPERIMENT then
		if arg0_35.contextData.mainFleetId then
			local var84_35 = getProxy(FleetProxy):getActivityFleets()[arg0_35.contextData.actId]
			local var85_35 = var84_35[arg0_35.contextData.mainFleetId]
			local var86_35 = _.values(var85_35:getCommanders())

			var0_35.CommanderList = var85_35:buildBattleBuffList()
			arg0_35.mainShips = {}

			local var87_35 = {}
			local var88_35 = {}
			local var89_35 = {}

			local function var90_35(arg0_39, arg1_39, arg2_39, arg3_39)
				if table.contains(var8_35, arg0_39) then
					BattleVertify.cloneShipVertiry = true
				end

				var8_35[#var8_35 + 1] = arg0_39

				local var0_39 = var7_35:getShipById(arg0_39)
				local var1_39 = var1_0(var1_35, var0_39, arg1_39)

				table.insert(arg0_35.mainShips, var0_39)
				table.insert(arg3_39, var0_39)
				table.insert(arg2_39, var1_39)
			end

			local var91_35 = var85_35:getTeamByName(TeamType.Main)
			local var92_35 = var85_35:getTeamByName(TeamType.Vanguard)

			for iter32_35, iter33_35 in ipairs(var91_35) do
				var90_35(iter33_35, var86_35, var0_35.MainUnitList, var87_35)
			end

			for iter34_35, iter35_35 in ipairs(var92_35) do
				var90_35(iter35_35, var86_35, var0_35.VanguardUnitList, var88_35)
			end

			local var93_35 = var84_35[arg0_35.contextData.mainFleetId + 10]
			local var94_35 = _.values(var93_35:getCommanders())
			local var95_35 = var93_35:getTeamByName(TeamType.Submarine)

			for iter36_35, iter37_35 in ipairs(var95_35) do
				var90_35(iter37_35, var94_35, var0_35.SubUnitList, var89_35)
			end

			local var96_35 = getProxy(PlayerProxy):getRawData()
			local var97_35 = getProxy(ActivityProxy):getActivityById(arg0_35.contextData.actId)
			local var98_35 = var97_35:getConfig("config_id")
			local var99_35 = pg.activity_event_worldboss[var98_35].use_oil_limit[arg0_35.contextData.mainFleetId]
			local var100_35 = var97_35:IsOilLimit(arg0_35.contextData.stageId)
			local var101_35 = 0
			local var102_35 = var6_35.oil_cost > 0

			local function var103_35(arg0_40, arg1_40)
				if var102_35 then
					local var0_40 = arg0_40:getEndCost().oil

					if arg1_40 > 0 then
						local var1_40 = arg0_40:getStartCost().oil

						cost = math.clamp(arg1_40 - var1_40, 0, var0_40)
					end

					var101_35 = var101_35 + var0_40
				end
			end

			if var1_35 == SYSTEM_ACT_BOSS_SP then
				local var104_35 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0_35.contextData.actId).buffIds
				local var105_35 = _.map(var104_35, function(arg0_41)
					return ActivityBossBuff.New({
						configId = arg0_41
					})
				end)

				var0_35.ExtraBuffList = _.map(_.select(var105_35, function(arg0_42)
					return arg0_42:CastOnEnemy()
				end), function(arg0_43)
					return arg0_43:GetBuffID()
				end)
				var0_35.ChapterBuffIDs = _.map(_.select(var105_35, function(arg0_44)
					return not arg0_44:CastOnEnemy()
				end), function(arg0_45)
					return arg0_45:GetBuffID()
				end)
			else
				var103_35(var85_35, var100_35 and var99_35[1] or 0)
				var103_35(var93_35, var100_35 and var99_35[2] or 0)
			end

			if var93_35:isLegalToFight() == true and (var1_35 == SYSTEM_BOSS_EXPERIMENT or var101_35 <= var96_35.oil) then
				var0_35.SubFlag = 1
				var0_35.TotalSubAmmo = 1
			end

			var0_35.SubCommanderList = var93_35:buildBattleBuffList()

			arg0_35.viewComponent:setFleet(var87_35, var88_35, var89_35)
		end
	elseif var1_35 == SYSTEM_GUILD then
		local var106_35 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
		local var107_35 = var106_35:GetMainFleet()
		local var108_35 = _.values(var107_35:getCommanders())

		var0_35.CommanderList = var107_35:BuildBattleBuffList()
		arg0_35.mainShips = {}

		local var109_35 = {}
		local var110_35 = {}
		local var111_35 = {}

		local function var112_35(arg0_46, arg1_46, arg2_46, arg3_46)
			local var0_46 = var1_0(var1_35, arg0_46, arg1_46)

			table.insert(arg0_35.mainShips, arg0_46)
			table.insert(arg3_46, arg0_46)
			table.insert(arg2_46, var0_46)
		end

		local var113_35 = {}
		local var114_35 = {}
		local var115_35 = var107_35:GetShips()

		for iter38_35, iter39_35 in pairs(var115_35) do
			local var116_35 = iter39_35.ship

			if var116_35:getTeamType() == TeamType.Main then
				table.insert(var113_35, var116_35)
			elseif var116_35:getTeamType() == TeamType.Vanguard then
				table.insert(var114_35, var116_35)
			end
		end

		for iter40_35, iter41_35 in ipairs(var113_35) do
			var112_35(iter41_35, var108_35, var0_35.MainUnitList, var109_35)
		end

		for iter42_35, iter43_35 in ipairs(var114_35) do
			var112_35(iter43_35, var108_35, var0_35.VanguardUnitList, var110_35)
		end

		local var117_35 = var106_35:GetSubFleet()
		local var118_35 = _.values(var117_35:getCommanders())
		local var119_35 = {}
		local var120_35 = var117_35:GetShips()

		for iter44_35, iter45_35 in pairs(var120_35) do
			local var121_35 = iter45_35.ship

			if var121_35:getTeamType() == TeamType.Submarine then
				table.insert(var119_35, var121_35)
			end
		end

		for iter46_35, iter47_35 in ipairs(var119_35) do
			var112_35(iter47_35, var118_35, var0_35.SubUnitList, var111_35)
		end

		if #var111_35 > 0 then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
		end

		var0_35.SubCommanderList = var117_35:BuildBattleBuffList()

		arg0_35.viewComponent:setFleet(var109_35, var110_35, var111_35)
	elseif var1_35 == SYSTEM_BOSS_RUSH or var1_35 == SYSTEM_BOSS_RUSH_EX or var1_35 == SYSTEM_BOSS_RUSH_COLLABRATE then
		local var122_35 = getProxy(ActivityProxy):getActivityById(arg0_35.contextData.actId):GetSeriesData()

		assert(var122_35)

		local var123_35 = var122_35:GetStaegLevel() + 1
		local var124_35 = var122_35:GetFleetIds()
		local var125_35 = var124_35[var123_35]
		local var126_35 = var124_35[#var124_35]

		if var122_35:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var125_35 = var124_35[1]
		end

		local var127_35 = getProxy(FleetProxy):getActivityFleets()[arg0_35.contextData.actId]

		arg0_35.mainShips = {}

		local var128_35 = {}
		local var129_35 = {}
		local var130_35 = {}

		local function var131_35(arg0_47, arg1_47, arg2_47, arg3_47)
			if table.contains(var8_35, arg0_47) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_35[#var8_35 + 1] = arg0_47

			local var0_47 = var7_35:getShipById(arg0_47)
			local var1_47 = var1_0(var1_35, var0_47, arg1_47)

			table.insert(arg0_35.mainShips, var0_47)
			table.insert(arg3_47, var0_47)
			table.insert(arg2_47, var1_47)
		end

		local var132_35 = var127_35[var125_35]
		local var133_35 = _.values(var132_35:getCommanders())

		var0_35.CommanderList = var132_35:buildBattleBuffList()

		local var134_35 = var132_35:getTeamByName(TeamType.Main)
		local var135_35 = var132_35:getTeamByName(TeamType.Vanguard)

		for iter48_35, iter49_35 in ipairs(var134_35) do
			var131_35(iter49_35, var133_35, var0_35.MainUnitList, var128_35)
		end

		for iter50_35, iter51_35 in ipairs(var135_35) do
			var131_35(iter51_35, var133_35, var0_35.VanguardUnitList, var129_35)
		end

		local var136_35 = var127_35[var126_35]
		local var137_35 = _.values(var136_35:getCommanders())

		var0_35.SubCommanderList = var136_35:buildBattleBuffList()

		local var138_35 = var136_35:getTeamByName(TeamType.Submarine)

		for iter52_35, iter53_35 in ipairs(var138_35) do
			var131_35(iter53_35, var137_35, var0_35.SubUnitList, var130_35)
		end

		local var139_35 = getProxy(PlayerProxy):getRawData()
		local var140_35 = 0
		local var141_35 = var122_35:GetOilLimit()
		local var142_35 = var6_35.oil_cost > 0

		local function var143_35(arg0_48, arg1_48)
			local var0_48 = 0

			if var142_35 then
				local var1_48 = arg0_48:getStartCost().oil
				local var2_48 = arg0_48:getEndCost().oil

				var0_48 = var2_48

				if arg1_48 > 0 then
					var0_48 = math.clamp(arg1_48 - var1_48, 0, var2_48)
				end
			end

			return var0_48
		end

		local var144_35 = var140_35 + var143_35(var132_35, var141_35[1]) + var143_35(var136_35, var141_35[2])

		if var136_35:isLegalToFight() == true and var144_35 <= var139_35.oil then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
		end

		arg0_35.viewComponent:setFleet(var128_35, var129_35, var130_35)

		if var1_35 == SYSTEM_BOSS_RUSH_COLLABRATE then
			var0_35.ChapterBuffIDs = {}

			local var145_35 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BUILDING_BUFF)
			local var146_35 = var145_35:GetBuildingIds()

			for iter54_35, iter55_35 in ipairs(var146_35) do
				local var147_35 = var145_35:GetBuildingLevel(iter55_35)
				local var148_35 = var145_35:GetBuildingConfigTable(iter55_35).buff[var147_35]

				if var148_35 ~= 0 then
					local var149_35 = ActivityBuff.New(var145_35.id, var148_35)

					if var149_35:isActivate() and var149_35:getConfig("benefit_type") == ys.Battle.BattleConst.BATTLE_GLOBAL_BUFF then
						local var150_35 = var149_35:getConfig("benefit_effect")

						table.insert(var0_35.ChapterBuffIDs, var150_35)
					end
				end
			end

			var0_35.DALAidBuffIDs = {}

			local var151_35 = var122_35:getConfig("aid_buff")

			if var122_35:GetBossHpRate() <= var151_35[1] then
				table.insert(var0_35.DALAidBuffIDs, var151_35[2])
			end
		end
	elseif var1_35 == SYSTEM_LIMIT_CHALLENGE then
		local var152_35 = LimitChallengeConst.GetChallengeIDByStageID(arg0_35.contextData.stageId)

		var0_35.ExtraBuffList = AcessWithinNull(pg.expedition_constellation_challenge_template[var152_35], "buff_id")

		local var153_35 = FleetProxy.CHALLENGE_FLEET_ID
		local var154_35 = FleetProxy.CHALLENGE_SUB_FLEET_ID
		local var155_35 = getProxy(FleetProxy)
		local var156_35 = var155_35:getFleetById(var153_35)
		local var157_35 = var155_35:getFleetById(var154_35)

		arg0_35.mainShips = {}

		local var158_35 = {}
		local var159_35 = {}
		local var160_35 = {}

		local function var161_35(arg0_49, arg1_49, arg2_49, arg3_49)
			if table.contains(var8_35, arg0_49) then
				BattleVertify.cloneShipVertiry = true
			end

			var8_35[#var8_35 + 1] = arg0_49

			local var0_49 = var7_35:getShipById(arg0_49)
			local var1_49 = var1_0(var1_35, var0_49, arg1_49)

			table.insert(arg0_35.mainShips, var0_49)
			table.insert(arg3_49, var0_49)
			table.insert(arg2_49, var1_49)
		end

		local var162_35 = _.values(var156_35:getCommanders())

		var0_35.CommanderList = var156_35:buildBattleBuffList()

		local var163_35 = var156_35:getTeamByName(TeamType.Main)
		local var164_35 = var156_35:getTeamByName(TeamType.Vanguard)

		for iter56_35, iter57_35 in ipairs(var163_35) do
			var161_35(iter57_35, var162_35, var0_35.MainUnitList, var158_35)
		end

		for iter58_35, iter59_35 in ipairs(var164_35) do
			var161_35(iter59_35, var162_35, var0_35.VanguardUnitList, var159_35)
		end

		local var165_35 = _.values(var157_35:getCommanders())

		var0_35.SubCommanderList = var157_35:buildBattleBuffList()

		local var166_35 = var157_35:getTeamByName(TeamType.Submarine)

		for iter60_35, iter61_35 in ipairs(var166_35) do
			var161_35(iter61_35, var165_35, var0_35.SubUnitList, var160_35)
		end

		local var167_35 = getProxy(PlayerProxy):getRawData()
		local var168_35 = 0
		local var169_35 = var6_35.oil_cost > 0

		local function var170_35(arg0_50, arg1_50)
			local var0_50 = 0

			if var169_35 then
				local var1_50 = arg0_50:getStartCost().oil
				local var2_50 = arg0_50:getEndCost().oil

				var0_50 = var2_50

				if arg1_50 > 0 then
					var0_50 = math.clamp(arg1_50 - var1_50, 0, var2_50)
				end
			end

			return var0_50
		end

		local var171_35 = var168_35 + var170_35(var156_35, 0) + var170_35(var157_35, 0)

		if var157_35:isLegalToFight() == true and var171_35 <= var167_35.oil then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
		end

		arg0_35.viewComponent:setFleet(var158_35, var159_35, var160_35)
	elseif var1_35 == SYSTEM_CARDPUZZLE then
		local var172_35 = {}
		local var173_35 = {}
		local var174_35 = arg0_35.contextData.relics

		for iter62_35, iter63_35 in ipairs(arg0_35.contextData.cardPuzzleFleet) do
			local var175_35 = var2_0(iter63_35, var174_35)
			local var176_35 = var175_35.fleetIndex

			if var176_35 == 1 then
				table.insert(var173_35, var175_35)
				table.insert(var0_35.VanguardUnitList, var175_35)
			elseif var176_35 == 2 then
				table.insert(var172_35, var175_35)
				table.insert(var0_35.MainUnitList, var175_35)
			end
		end

		var0_35.CardPuzzleCardIDList = arg0_35.contextData.cards
		var0_35.CardPuzzleCommonHPValue = arg0_35.contextData.hp
		var0_35.CardPuzzleRelicList = var174_35
		var0_35.CardPuzzleCombatID = arg0_35.contextData.puzzleCombatID
	elseif var1_35 == SYSTEM_BOSS_SINGLE or var1_35 == SYSTEM_BOSS_SINGLE_VARIABLE then
		if arg0_35.contextData.mainFleetId then
			local var177_35 = getProxy(FleetProxy):getActivityFleets()[arg0_35.contextData.actId]
			local var178_35 = var177_35[arg0_35.contextData.mainFleetId]
			local var179_35 = _.values(var178_35:getCommanders())

			var0_35.CommanderList = var178_35:buildBattleBuffList()
			arg0_35.mainShips = {}

			local var180_35 = {}
			local var181_35 = {}
			local var182_35 = {}

			local function var183_35(arg0_51, arg1_51, arg2_51, arg3_51)
				if table.contains(var8_35, arg0_51) then
					BattleVertify.cloneShipVertiry = true
				end

				var8_35[#var8_35 + 1] = arg0_51

				local var0_51 = var7_35:getShipById(arg0_51)
				local var1_51 = var1_0(var1_35, var0_51, arg1_51)

				table.insert(arg0_35.mainShips, var0_51)
				table.insert(arg3_51, var0_51)
				table.insert(arg2_51, var1_51)
			end

			local var184_35 = var178_35:getTeamByName(TeamType.Main)
			local var185_35 = var178_35:getTeamByName(TeamType.Vanguard)

			for iter64_35, iter65_35 in ipairs(var184_35) do
				var183_35(iter65_35, var179_35, var0_35.MainUnitList, var180_35)
			end

			for iter66_35, iter67_35 in ipairs(var185_35) do
				var183_35(iter67_35, var179_35, var0_35.VanguardUnitList, var181_35)
			end

			local var186_35 = var1_35 == SYSTEM_BOSS_SINGLE_VARIABLE and 100 or 10
			local var187_35 = var177_35[arg0_35.contextData.mainFleetId + var186_35]

			if var187_35 then
				local var188_35 = _.values(var187_35:getCommanders())
				local var189_35 = var187_35:getTeamByName(TeamType.Submarine)

				for iter68_35, iter69_35 in ipairs(var189_35) do
					var183_35(iter69_35, var188_35, var0_35.SubUnitList, var182_35)
				end
			end

			local var190_35 = getProxy(PlayerProxy):getRawData()
			local var191_35 = getProxy(ActivityProxy):getActivityById(arg0_35.contextData.actId)

			var0_35.ChapterBuffIDs = var191_35:GetBuffIdsByStageId(arg0_35.contextData.stageId)

			local var192_35 = pg.strategy_data_template

			if arg0_35.contextData.variableBuffList then
				for iter70_35, iter71_35 in ipairs(arg0_35.contextData.variableBuffList) do
					table.insert(var0_35.ChapterBuffIDs, var192_35[iter71_35].buff_id)
				end
			end

			local var193_35 = var191_35:GetEnemyDataByStageId(arg0_35.contextData.stageId):GetOilLimit()
			local var194_35 = 0
			local var195_35 = var6_35.oil_cost > 0

			local function var196_35(arg0_52, arg1_52)
				if var195_35 then
					local var0_52 = arg0_52:getEndCost().oil

					if arg1_52 > 0 then
						local var1_52 = arg0_52:getStartCost().oil

						cost = math.clamp(arg1_52 - var1_52, 0, var0_52)
					end

					var194_35 = var194_35 + var0_52
				end
			end

			var196_35(var178_35, var193_35[1] or 0)

			if var187_35 then
				var196_35(var187_35, var193_35[2] or 0)

				if var187_35:isLegalToFight() == true and var194_35 <= var190_35.oil then
					var0_35.SubFlag = 1
					var0_35.TotalSubAmmo = 1
				end

				var0_35.SubCommanderList = var187_35:buildBattleBuffList()
			end

			arg0_35.viewComponent:setFleet(var180_35, var181_35, var182_35)
		end
	elseif arg0_35.contextData.mainFleetId then
		local var197_35 = var1_35 == SYSTEM_DUEL
		local var198_35 = getProxy(FleetProxy)
		local var199_35
		local var200_35
		local var201_35 = var198_35:getFleetById(arg0_35.contextData.mainFleetId)

		arg0_35.mainShips = var7_35:getShipsByFleet(var201_35)

		local var202_35 = {}
		local var203_35 = {}
		local var204_35 = {}

		local function var205_35(arg0_53, arg1_53, arg2_53)
			for iter0_53, iter1_53 in ipairs(arg0_53) do
				if table.contains(var8_35, iter1_53) then
					BattleVertify.cloneShipVertiry = true
				end

				var8_35[#var8_35 + 1] = iter1_53

				local var0_53 = var7_35:getShipById(iter1_53)
				local var1_53 = var1_0(var1_35, var0_53, nil, var197_35)

				table.insert(arg1_53, var0_53)
				table.insert(arg2_53, var1_53)
			end
		end

		local var206_35 = var201_35:getTeamByName(TeamType.Main)
		local var207_35 = var201_35:getTeamByName(TeamType.Vanguard)
		local var208_35 = var201_35:getTeamByName(TeamType.Submarine)

		var205_35(var206_35, var202_35, var0_35.MainUnitList)
		var205_35(var207_35, var203_35, var0_35.VanguardUnitList)
		var205_35(var208_35, var204_35, var0_35.SubUnitList)
		arg0_35.viewComponent:setFleet(var202_35, var203_35, var204_35)

		if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
			local var209_35 = var198_35:getFleetById(11)
			local var210_35 = var209_35:getTeamByName(TeamType.Submarine)

			if #var210_35 > 0 then
				var0_35.SubFlag = 1
				var0_35.TotalSubAmmo = 1

				local var211_35 = _.values(var209_35:getCommanders())

				var0_35.SubCommanderList = var209_35:buildBattleBuffList()

				for iter72_35, iter73_35 in ipairs(var210_35) do
					local var212_35 = var7_35:getShipById(iter73_35)
					local var213_35 = var1_0(var1_35, var212_35, var211_35, var197_35)

					table.insert(var204_35, var212_35)
					table.insert(var0_35.SubUnitList, var213_35)
				end
			end
		end
	end

	if var1_35 == SYSTEM_WORLD then
		local var214_35 = nowWorld()
		local var215_35 = var214_35:GetActiveMap()
		local var216_35 = var215_35:GetFleet()
		local var217_35 = var215_35:GetCell(var216_35.row, var216_35.column):GetStageEnemy()
		local var218_35 = pg.world_expedition_data[arg0_35.contextData.stageId]
		local var219_35 = var214_35:GetWorldMapDifficultyBuffLevel()

		var0_35.EnemyMapRewards = {
			var219_35[1] * (1 + var218_35.expedition_sairenvalueA / 10000),
			var219_35[2] * (1 + var218_35.expedition_sairenvalueB / 10000),
			var219_35[3] * (1 + var218_35.expedition_sairenvalueC / 10000)
		}
		var0_35.FleetMapRewards = var214_35:GetWorldMapBuffLevel()
	end

	var0_35.RivalMainUnitList, var0_35.RivalVanguardUnitList = {}, {}

	local var220_35

	if var1_35 == SYSTEM_DUEL and arg0_35.contextData.rivalId then
		local var221_35 = getProxy(MilitaryExerciseProxy)

		var220_35 = var221_35:getRivalById(arg0_35.contextData.rivalId)
		arg0_35.oldRank = var221_35:getSeasonInfo()
	end

	if var220_35 then
		var0_35.RivalVO = var220_35

		local var222_35 = 0

		for iter74_35, iter75_35 in ipairs(var220_35.mainShips) do
			var222_35 = var222_35 + iter75_35.level
		end

		for iter76_35, iter77_35 in ipairs(var220_35.vanguardShips) do
			var222_35 = var222_35 + iter77_35.level
		end

		BattleVertify = BattleVertify or {}
		BattleVertify.rivalLevel = var222_35

		for iter78_35, iter79_35 in ipairs(var220_35.mainShips) do
			if not iter79_35.hpRant or iter79_35.hpRant > 0 then
				local var223_35 = var1_0(var1_35, iter79_35, nil, true)

				if iter79_35.hpRant then
					var223_35.initHPRate = iter79_35.hpRant * 0.0001
				end

				table.insert(var0_35.RivalMainUnitList, var223_35)
			end
		end

		for iter80_35, iter81_35 in ipairs(var220_35.vanguardShips) do
			if not iter81_35.hpRant or iter81_35.hpRant > 0 then
				local var224_35 = var1_0(var1_35, iter81_35, nil, true)

				if iter81_35.hpRant then
					var224_35.initHPRate = iter81_35.hpRant * 0.0001
				end

				table.insert(var0_35.RivalVanguardUnitList, var224_35)
			end
		end
	end

	local var225_35 = arg0_35.contextData.prefabFleet.main_unitList
	local var226_35 = arg0_35.contextData.prefabFleet.vanguard_unitList
	local var227_35 = arg0_35.contextData.prefabFleet.submarine_unitList

	if var225_35 then
		for iter82_35, iter83_35 in ipairs(var225_35) do
			local var228_35 = {}

			for iter84_35, iter85_35 in ipairs(iter83_35.equipment) do
				var228_35[#var228_35 + 1] = {
					skin = 0,
					id = iter85_35
				}
			end

			local var229_35 = {
				id = iter83_35.id,
				tmpID = iter83_35.configId,
				skinId = iter83_35.skinId,
				level = iter83_35.level,
				equipment = var228_35,
				properties = iter83_35.properties,
				baseProperties = iter83_35.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter83_35.skills
			}

			table.insert(var0_35.MainUnitList, var229_35)
		end
	end

	if var226_35 then
		for iter86_35, iter87_35 in ipairs(var226_35) do
			local var230_35 = {}

			for iter88_35, iter89_35 in ipairs(iter87_35.equipment) do
				var230_35[#var230_35 + 1] = {
					skin = 0,
					id = iter89_35
				}
			end

			local var231_35 = {
				id = iter87_35.id,
				tmpID = iter87_35.configId,
				skinId = iter87_35.skinId,
				level = iter87_35.level,
				equipment = var230_35,
				properties = iter87_35.properties,
				baseProperties = iter87_35.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter87_35.skills
			}

			table.insert(var0_35.VanguardUnitList, var231_35)
		end
	end

	if var227_35 then
		for iter90_35, iter91_35 in ipairs(var227_35) do
			local var232_35 = {}

			for iter92_35, iter93_35 in ipairs(iter91_35.equipment) do
				var232_35[#var232_35 + 1] = {
					skin = 0,
					id = iter93_35
				}
			end

			local var233_35 = {
				id = iter91_35.id,
				tmpID = iter91_35.configId,
				skinId = iter91_35.skinId,
				level = iter91_35.level,
				equipment = var232_35,
				properties = iter91_35.properties,
				baseProperties = iter91_35.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter91_35.skills
			}

			table.insert(var0_35.SubUnitList, var233_35)

			if var1_35 == SYSTEM_SIMULATION and #var0_35.SubUnitList > 0 then
				var0_35.SubFlag = 1
				var0_35.TotalSubAmmo = 1
			end
		end
	end
end

function var0_0.listNotificationInterests(arg0_54)
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

function var0_0.handleNotification(arg0_55, arg1_55)
	local var0_55 = arg1_55:getName()
	local var1_55 = arg1_55:getBody()
	local var2_55 = ys.Battle.BattleState.GetInstance()
	local var3_55 = arg0_55.contextData.system

	if var0_55 == GAME.FINISH_STAGE_DONE then
		pg.MsgboxMgr.GetInstance():hide()

		local var4_55 = var1_55.system

		if var4_55 == SYSTEM_PROLOGUE then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_55:sendNotification(GAME.CHANGE_SCENE, SCENE.CREATE_PLAYER)
		elseif var4_55 == SYSTEM_PERFORM or var4_55 == SYSTEM_SIMULATION then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_55.viewComponent:exitBattle()

			if var1_55.exitCallback then
				var1_55.exitCallback()
			end
		else
			local var5_55 = BattleResultMediator.GetResultView(var4_55)
			local var6_55 = {}

			if var4_55 == SYSTEM_SCENARIO then
				var6_55 = getProxy(ChapterProxy):getActiveChapter().operationBuffList
			end

			arg0_55:addSubLayers(Context.New({
				mediator = NewBattleResultMediator,
				viewComponent = NewBattleResultScene,
				data = {
					system = var4_55,
					rivalId = arg0_55.contextData.rivalId,
					mainFleetId = arg0_55.contextData.mainFleetId,
					stageId = arg0_55.contextData.stageId,
					oldMainShips = arg0_55.mainShips or {},
					oldPlayer = arg0_55.player,
					oldRank = arg0_55.oldRank,
					statistics = var1_55.statistics,
					score = var1_55.score,
					drops = var1_55.drops,
					bossId = var1_55.bossId,
					name = var1_55.name,
					prefabFleet = var1_55.prefabFleet,
					commanderExps = var1_55.commanderExps,
					actId = arg0_55.contextData.actId,
					result = var1_55.result,
					extraDrops = var1_55.extraDrops,
					extraBuffList = var6_55,
					isLastBonus = var1_55.isLastBonus,
					continuousBattleTimes = arg0_55.contextData.continuousBattleTimes,
					totalBattleTimes = arg0_55.contextData.totalBattleTimes,
					mode = arg0_55.contextData.mode,
					cmdArgs = arg0_55.contextData.cmdArgs,
					variableBuffList = arg0_55.contextData.variableBuffList,
					useVariableTicket = arg0_55.contextData.useVariableTicket
				}
			}))
		end
	elseif var0_55 == GAME.STORY_BEGIN then
		var2_55:Pause()
	elseif var0_55 == GAME.STORY_END then
		var2_55:Resume()
	elseif var0_55 == GAME.START_GUIDE then
		var2_55:Pause()
	elseif var0_55 == GAME.END_GUIDE then
		var2_55:Resume()
	elseif var0_55 == GAME.PAUSE_BATTLE then
		if not var2_55:IsPause() then
			arg0_55:onPauseBtn()
		end
	elseif var0_55 == GAME.RESUME_BATTLE then
		var2_55:Resume()
	elseif var0_55 == GAME.FINISH_STAGE_ERROR then
		gcAll(true)

		local var7_55 = getProxy(ContextProxy)
		local var8_55 = var7_55:getContextByMediator(DailyLevelMediator)
		local var9_55 = var7_55:getContextByMediator(LevelMediator2)
		local var10_55 = var7_55:getContextByMediator(ChallengeMainMediator)
		local var11_55 = var7_55:getContextByMediator(ActivityBossMediatorTemplate)

		if var8_55 then
			local var12_55 = var8_55:getContextByMediator(PreCombatMediator)

			var8_55:removeChild(var12_55)
		elseif var10_55 then
			local var13_55 = var10_55:getContextByMediator(ChallengePreCombatMediator)

			var10_55:removeChild(var13_55)
		elseif var9_55 then
			if var3_55 == SYSTEM_DUEL then
				-- block empty
			elseif var3_55 == SYSTEM_SCENARIO then
				local var14_55 = var9_55:getContextByMediator(ChapterPreCombatMediator)

				var9_55:removeChild(var14_55)
			elseif var3_55 ~= SYSTEM_PERFORM and var3_55 ~= SYSTEM_SIMULATION then
				local var15_55 = var9_55:getContextByMediator(PreCombatMediator)

				if var15_55 then
					var9_55:removeChild(var15_55)
				end
			end
		elseif var11_55 then
			local var16_55 = var11_55:getContextByMediator(PreCombatMediator)

			if var16_55 then
				var11_55:removeChild(var16_55)
			end
		end

		arg0_55:sendNotification(GAME.GO_BACK)
	elseif var0_55 == var0_0.CLOSE_CHAT then
		arg0_55.viewComponent:OnCloseChat()
	elseif var0_55 == var0_0.HIDE_ALL_BUTTONS then
		ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name):DispatchEvent(ys.Event.New(ys.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
			isActive = var1_55
		}))
	elseif var0_55 == GAME.QUIT_BATTLE then
		var2_55:Stop()
	elseif var0_55 == var0_0.UPDATE_AUTO_COUNT then
		arg0_55:updateAutoCount(var1_55)
	end
end

function var0_0.remove(arg0_56)
	pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)
end

return var0_0
