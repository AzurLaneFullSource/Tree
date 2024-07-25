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
			puzzleCombatID = arg0_1.contextData.puzzleCombatID
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
				form = NotificationLayer.FORM_BATTLE,
				chatViewParent = arg1_6
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

		if var6_8 and arg0_1.contextData.bossId then
			arg0_1:sendNotification(GAME.WORLD_BOSS_BATTLE_QUIT, {
				id = arg0_1.contextData.bossId
			})

			local var7_8 = var6_8:getContextByMediator(WorldBossFormationMediator)

			if var7_8 then
				var6_8:removeChild(var7_8)
			end
		elseif var5_8 then
			local var8_8 = var5_8:getContextByMediator(WorldPreCombatMediator) or var5_8:getContextByMediator(WorldBossInformationMediator)

			if var8_8 then
				var5_8:removeChild(var8_8)
			end
		elseif var1_8 then
			local var9_8 = var1_8:getContextByMediator(PreCombatMediator)

			var1_8:removeChild(var9_8)
		elseif var3_8 then
			arg0_1:sendNotification(GAME.CHALLENGE2_RESET, {
				mode = arg0_1.contextData.mode
			})

			local var10_8 = var3_8:getContextByMediator(ChallengePreCombatMediator)

			var3_8:removeChild(var10_8)
		elseif var2_8 then
			if var1_1 == SYSTEM_DUEL then
				-- block empty
			elseif var1_1 == SYSTEM_SCENARIO then
				local var11_8 = var2_8:getContextByMediator(ChapterPreCombatMediator)

				if var11_8 then
					var2_8:removeChild(var11_8)
				end
			elseif var1_1 ~= SYSTEM_PERFORM and var1_1 ~= SYSTEM_SIMULATION then
				local var12_8 = var2_8:getContextByMediator(PreCombatMediator)

				if var12_8 then
					var2_8:removeChild(var12_8)
				end
			end
		elseif var4_8 then
			local var13_8 = var4_8:getContextByMediator(PreCombatMediator)

			if var13_8 then
				var4_8:removeChild(var13_8)
			end
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
		elseif var1_1 == SYSTEM_BOSS_RUSH then
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
		elseif var1_1 == SYSTEM_BOSS_SINGLE and getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
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
		if var1_1 == SYSTEM_BOSS_SINGLE then
			if not getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
				local var2_1 = CreateShell(arg0_1.contextData)

				var2_1.LayerWeightMgr_weight = LayerWeightConst.BASE_LAYER

				arg0_1:addSubLayers(Context.New({
					mediator = BossSingleContinuousOperationMediator,
					viewComponent = BossSingleContinuousOperationPanel,
					data = var2_1
				}))
			end
		elseif not getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
			local var3_1 = CreateShell(arg0_1.contextData)

			var3_1.LayerWeightMgr_weight = LayerWeightConst.BASE_LAYER

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

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideNo = true,
		hideYes = true,
		content = var3_27,
		onClose = arg1_27,
		custom = {
			{
				text = "text_cancel",
				onCallback = arg1_27,
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

function var0_0.guideDispatch(arg0_29)
	return
end

local function var1_0(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = {}

	for iter0_30, iter1_30 in ipairs(arg1_30:getActiveEquipments()) do
		if iter1_30 then
			var0_30[#var0_30 + 1] = {
				id = iter1_30.configId,
				skin = iter1_30.skinId,
				equipmentInfo = iter1_30
			}
		else
			var0_30[#var0_30 + 1] = {
				skin = 0,
				id = iter1_30,
				equipmentInfo = iter1_30
			}
		end
	end

	local var1_30 = {}

	local function var2_30(arg0_31)
		local var0_31 = {
			level = arg0_31.level
		}
		local var1_31 = arg0_31.id
		local var2_31 = arg1_30:RemapSkillId(var1_31)

		var0_31.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_30, var2_31)

		return var0_31
	end

	local var3_30 = ys.Battle.BattleDataFunction.GenerateHiddenBuff(arg1_30.configId)

	for iter2_30, iter3_30 in pairs(var3_30) do
		local var4_30 = var2_30(iter3_30)

		var1_30[var4_30.id] = var4_30
	end

	for iter4_30, iter5_30 in pairs(arg1_30.skills) do
		if iter5_30 and iter5_30.id == 14900 and not arg1_30.transforms[16412] then
			-- block empty
		else
			local var5_30 = var2_30(iter5_30)

			var1_30[var5_30.id] = var5_30
		end
	end

	local var6_30 = ys.Battle.BattleDataFunction.GetEquipSkill(var0_30)

	for iter6_30, iter7_30 in ipairs(var6_30) do
		local var7_30 = {}

		var7_30.level = 1
		var7_30.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_30, iter7_30)
		var1_30[var7_30.id] = var7_30
	end

	local var8_30

	;(function()
		var8_30 = arg1_30:GetSpWeapon()

		if not var8_30 then
			return
		end

		local var0_32 = var8_30:GetEffect()

		if var0_32 == 0 then
			return
		end

		local var1_32 = {}

		var1_32.level = 1
		var1_32.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_30, var0_32)
		var1_30[var1_32.id] = var1_32
	end)()

	for iter8_30, iter9_30 in pairs(arg1_30:getTriggerSkills()) do
		local var9_30 = {
			level = iter9_30.level,
			id = ys.Battle.BattleDataFunction.SkillTranform(arg0_30, iter9_30.id)
		}

		var1_30[var9_30.id] = var9_30
	end

	local var10_30 = arg0_30 == SYSTEM_WORLD
	local var11_30 = false

	if var10_30 then
		local var12_30 = WorldConst.FetchWorldShip(arg1_30.id)

		if var12_30 then
			var11_30 = var12_30:IsBroken()
		end
	end

	if var11_30 then
		for iter10_30, iter11_30 in pairs(var1_30) do
			local var13_30 = pg.skill_data_template[iter10_30].world_death_mark[1]

			if var13_30 == ys.Battle.BattleConst.DEATH_MARK_SKILL.DEACTIVE then
				var1_30[iter10_30] = nil
			elseif var13_30 == ys.Battle.BattleConst.DEATH_MARK_SKILL.IGNORE then
				-- block empty
			end
		end
	end

	return {
		id = arg1_30.id,
		tmpID = arg1_30.configId,
		skinId = arg1_30.skinId,
		level = arg1_30.level,
		equipment = var0_30,
		properties = arg1_30:getProperties(arg2_30, arg3_30, var10_30),
		baseProperties = arg1_30:getShipProperties(),
		proficiency = arg1_30:getEquipProficiencyList(),
		rarity = arg1_30:getRarity(),
		intimacy = arg1_30:getCVIntimacy(),
		shipGS = arg1_30:getShipCombatPower(),
		skills = var1_30,
		baseList = arg1_30:getBaseList(),
		preloasList = arg1_30:getPreLoadCount(),
		name = arg1_30:getName(),
		deathMark = var11_30,
		spWeapon = var8_30
	}
end

local function var2_0(arg0_33, arg1_33)
	local var0_33 = arg0_33:getProperties(arg1_33)
	local var1_33 = arg0_33:getConfig("id")

	return {
		deathMark = false,
		shipGS = 100,
		rarity = 1,
		intimacy = 100,
		id = var1_33,
		tmpID = var1_33,
		skinId = arg0_33:getConfig("skin_id"),
		level = arg0_33:getConfig("level"),
		equipment = arg0_33:getConfig("default_equip"),
		properties = var0_33,
		baseProperties = var0_33,
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
		name = var1_33,
		fleetIndex = arg0_33:getConfig("location")
	}
end

function var0_0.GenBattleData(arg0_34)
	local var0_34 = {}
	local var1_34 = arg0_34.contextData.system

	arg0_34._battleData = var0_34
	var0_34.battleType = arg0_34.contextData.system
	var0_34.StageTmpId = arg0_34.contextData.stageId
	var0_34.CMDArgs = arg0_34.contextData.cmdArgs
	var0_34.MainUnitList = {}
	var0_34.VanguardUnitList = {}
	var0_34.SubUnitList = {}
	var0_34.AidUnitList = {}
	var0_34.SupportUnitList = {}
	var0_34.SubFlag = -1
	var0_34.ActID = arg0_34.contextData.actId
	var0_34.bossLevel = arg0_34.contextData.bossLevel
	var0_34.bossConfigId = arg0_34.contextData.bossConfigId

	if pg.battle_cost_template[var1_34].global_buff_effected > 0 then
		local var2_34 = BuffHelper.GetBattleBuffs(var1_34)

		var0_34.GlobalBuffIDs = _.map(var2_34, function(arg0_35)
			return arg0_35:getConfig("benefit_effect")
		end) or {}
	end

	local var3_34 = pg.battle_cost_template[var1_34]
	local var4_34 = getProxy(BayProxy)
	local var5_34 = {}

	if var1_34 == SYSTEM_SCENARIO then
		local var6_34 = getProxy(ChapterProxy)
		local var7_34 = var6_34:getActiveChapter()

		var0_34.RepressInfo = var7_34:getRepressInfo()

		arg0_34.viewComponent:setChapter(var7_34)

		local var8_34 = var7_34.fleet

		var0_34.KizunaJamming = var7_34.extraFlagList
		var0_34.DefeatCount = var8_34:getDefeatCount()
		var0_34.ChapterBuffIDs, var0_34.CommanderList = var7_34:getFleetBattleBuffs(var8_34)
		var0_34.StageWaveFlags = var7_34:GetStageFlags()
		var0_34.ChapterWeatherIDS = var7_34:GetWeather(var8_34.line.row, var8_34.line.column)
		var0_34.MapAuraSkills = var6_34.GetChapterAuraBuffs(var7_34)
		var0_34.MapAidSkills = {}

		local var9_34 = var6_34.GetChapterAidBuffs(var7_34)

		for iter0_34, iter1_34 in pairs(var9_34) do
			local var10_34 = var7_34:getFleetByShipVO(iter0_34)
			local var11_34 = _.values(var10_34:getCommanders())
			local var12_34 = var1_0(var1_34, iter0_34, var11_34)

			table.insert(var0_34.AidUnitList, var12_34)

			for iter2_34, iter3_34 in ipairs(iter1_34) do
				table.insert(var0_34.MapAidSkills, iter3_34)
			end
		end

		local var13_34 = var8_34:getShipsByTeam(TeamType.Main, false)
		local var14_34 = var8_34:getShipsByTeam(TeamType.Vanguard, false)
		local var15_34 = {}
		local var16_34 = _.values(var8_34:getCommanders())
		local var17_34 = {}
		local var18_34, var19_34 = var6_34.getSubAidFlag(var7_34, arg0_34.contextData.stageId)

		if var18_34 == true or var18_34 > 0 then
			var0_34.SubFlag = 1
			var0_34.TotalSubAmmo = 1
			var15_34 = var19_34:getShipsByTeam(TeamType.Submarine, false)
			var17_34 = _.values(var19_34:getCommanders())

			local var20_34, var21_34 = var7_34:getFleetBattleBuffs(var19_34)

			var0_34.SubCommanderList = var21_34
		else
			var0_34.SubFlag = var18_34

			if var18_34 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_34.TotalSubAmmo = 0
			end
		end

		arg0_34.mainShips = {}

		local function var22_34(arg0_36, arg1_36, arg2_36)
			local var0_36 = arg0_36.id
			local var1_36 = arg0_36.hpRant * 0.0001

			if table.contains(var5_34, var0_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_34[#var5_34 + 1] = var0_36

			local var2_36 = var1_0(var1_34, arg0_36, arg1_36)

			var2_36.initHPRate = var1_36

			table.insert(arg0_34.mainShips, arg0_36)
			table.insert(arg2_36, var2_36)
		end

		for iter4_34, iter5_34 in ipairs(var13_34) do
			var22_34(iter5_34, var16_34, var0_34.MainUnitList)
		end

		for iter6_34, iter7_34 in ipairs(var14_34) do
			var22_34(iter7_34, var16_34, var0_34.VanguardUnitList)
		end

		for iter8_34, iter9_34 in ipairs(var15_34) do
			var22_34(iter9_34, var17_34, var0_34.SubUnitList)
		end

		local var23_34 = var7_34:getChapterSupportFleet()

		if var23_34 then
			local var24_34 = var23_34:getShips()

			for iter10_34, iter11_34 in pairs(var24_34) do
				var22_34(iter11_34, {}, var0_34.SupportUnitList)
			end
		end

		arg0_34.viewComponent:setFleet(var13_34, var14_34, var15_34)
	elseif var1_34 == SYSTEM_CHALLENGE then
		local var25_34 = arg0_34.contextData.mode
		local var26_34 = getProxy(ChallengeProxy):getUserChallengeInfo(var25_34)

		var0_34.ChallengeInfo = var26_34

		arg0_34.viewComponent:setChapter(var26_34)

		local var27_34 = var26_34:getRegularFleet()

		var0_34.CommanderList = var27_34:buildBattleBuffList()

		local var28_34 = _.values(var27_34:getCommanders())
		local var29_34 = {}
		local var30_34 = var27_34:getShipsByTeam(TeamType.Main, false)
		local var31_34 = var27_34:getShipsByTeam(TeamType.Vanguard, false)
		local var32_34 = {}
		local var33_34 = var26_34:getSubmarineFleet()
		local var34_34 = var33_34:getShipsByTeam(TeamType.Submarine, false)

		if #var34_34 > 0 then
			var0_34.SubFlag = 1
			var0_34.TotalSubAmmo = 1
			var29_34 = _.values(var33_34:getCommanders())
			var0_34.SubCommanderList = var33_34:buildBattleBuffList()
		else
			var0_34.SubFlag = 0
			var0_34.TotalSubAmmo = 0
		end

		arg0_34.mainShips = {}

		local function var35_34(arg0_37, arg1_37, arg2_37)
			local var0_37 = arg0_37.id
			local var1_37 = arg0_37.hpRant * 0.0001

			if table.contains(var5_34, var0_37) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_34[#var5_34 + 1] = var0_37

			local var2_37 = var1_0(var1_34, arg0_37, arg1_37)

			var2_37.initHPRate = var1_37

			table.insert(arg0_34.mainShips, arg0_37)
			table.insert(arg2_37, var2_37)
		end

		for iter12_34, iter13_34 in ipairs(var30_34) do
			var35_34(iter13_34, var28_34, var0_34.MainUnitList)
		end

		for iter14_34, iter15_34 in ipairs(var31_34) do
			var35_34(iter15_34, var28_34, var0_34.VanguardUnitList)
		end

		for iter16_34, iter17_34 in ipairs(var34_34) do
			var35_34(iter17_34, var29_34, var0_34.SubUnitList)
		end

		arg0_34.viewComponent:setFleet(var30_34, var31_34, var34_34)
	elseif var1_34 == SYSTEM_WORLD then
		local var36_34 = nowWorld()
		local var37_34 = var36_34:GetActiveMap()
		local var38_34 = var37_34:GetFleet()
		local var39_34 = var37_34:GetCell(var38_34.row, var38_34.column):GetStageEnemy()

		if arg0_34.contextData.hpRate then
			var0_34.RepressInfo = {
				repressEnemyHpRant = arg0_34.contextData.hpRate
			}
		end

		var0_34.AffixBuffList = table.mergeArray(var39_34:GetBattleLuaBuffs(), var37_34:GetBattleLuaBuffs(WorldMap.FactionEnemy, var39_34))

		local function var40_34(arg0_38)
			local var0_38 = {}

			for iter0_38, iter1_38 in ipairs(arg0_38) do
				local var1_38 = {
					id = ys.Battle.BattleDataFunction.SkillTranform(var1_34, iter1_38.id),
					level = iter1_38.level
				}

				table.insert(var0_38, var1_38)
			end

			return var0_38
		end

		var0_34.DefeatCount = var38_34:getDefeatCount()
		var0_34.ChapterBuffIDs, var0_34.CommanderList = var37_34:getFleetBattleBuffs(var38_34, true)
		var0_34.MapAuraSkills = var37_34:GetChapterAuraBuffs()
		var0_34.MapAuraSkills = var40_34(var0_34.MapAuraSkills)
		var0_34.MapAidSkills = {}

		local var41_34 = var37_34:GetChapterAidBuffs()

		for iter18_34, iter19_34 in pairs(var41_34) do
			local var42_34 = var37_34:GetFleet(iter18_34.fleetId)
			local var43_34 = _.values(var42_34:getCommanders(true))
			local var44_34 = var1_0(var1_34, WorldConst.FetchShipVO(iter18_34.id), var43_34)

			table.insert(var0_34.AidUnitList, var44_34)

			var0_34.MapAidSkills = table.mergeArray(var0_34.MapAidSkills, var40_34(iter19_34))
		end

		local var45_34 = var38_34:GetTeamShipVOs(TeamType.Main, false)
		local var46_34 = var38_34:GetTeamShipVOs(TeamType.Vanguard, false)
		local var47_34 = {}
		local var48_34 = _.values(var38_34:getCommanders(true))
		local var49_34 = {}
		local var50_34 = var36_34:GetSubAidFlag()

		if var50_34 == true then
			local var51_34 = var37_34:GetSubmarineFleet()

			var0_34.SubFlag = 1
			var0_34.TotalSubAmmo = 1
			var47_34 = var51_34:GetTeamShipVOs(TeamType.Submarine, false)
			var49_34 = _.values(var51_34:getCommanders(true))

			local var52_34, var53_34 = var37_34:getFleetBattleBuffs(var51_34, true)

			var0_34.SubCommanderList = var53_34
		else
			var0_34.SubFlag = 0

			if var50_34 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_34.TotalSubAmmo = 0
			end
		end

		arg0_34.mainShips = {}

		for iter20_34, iter21_34 in ipairs(var45_34) do
			local var54_34 = iter21_34.id
			local var55_34 = WorldConst.FetchWorldShip(iter21_34.id).hpRant * 0.0001

			if table.contains(var5_34, var54_34) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_34[#var5_34 + 1] = var54_34

			local var56_34 = var1_0(var1_34, iter21_34, var48_34)

			var56_34.initHPRate = var55_34

			table.insert(arg0_34.mainShips, iter21_34)
			table.insert(var0_34.MainUnitList, var56_34)
		end

		for iter22_34, iter23_34 in ipairs(var46_34) do
			local var57_34 = iter23_34.id
			local var58_34 = WorldConst.FetchWorldShip(iter23_34.id).hpRant * 0.0001

			if table.contains(var5_34, var57_34) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_34[#var5_34 + 1] = var57_34

			local var59_34 = var1_0(var1_34, iter23_34, var48_34)

			var59_34.initHPRate = var58_34

			table.insert(arg0_34.mainShips, iter23_34)
			table.insert(var0_34.VanguardUnitList, var59_34)
		end

		for iter24_34, iter25_34 in ipairs(var47_34) do
			local var60_34 = iter25_34.id
			local var61_34 = WorldConst.FetchWorldShip(iter25_34.id).hpRant * 0.0001

			if table.contains(var5_34, var60_34) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_34[#var5_34 + 1] = var60_34

			local var62_34 = var1_0(var1_34, iter25_34, var49_34)

			var62_34.initHPRate = var61_34

			table.insert(arg0_34.mainShips, iter25_34)
			table.insert(var0_34.SubUnitList, var62_34)
		end

		arg0_34.viewComponent:setFleet(var45_34, var46_34, var47_34)

		local var63_34 = pg.expedition_data_template[arg0_34.contextData.stageId]

		if var63_34.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
			var0_34.WorldMapId = var37_34.config.expedition_map_id
			var0_34.WorldLevel = WorldConst.WorldLevelCorrect(var37_34.config.expedition_level, var63_34.type)
		end
	elseif var1_34 == SYSTEM_WORLD_BOSS then
		local var64_34 = nowWorld():GetBossProxy()
		local var65_34 = arg0_34.contextData.bossId
		local var66_34 = var64_34:GetFleet(var65_34)
		local var67_34 = var64_34:GetBossById(var65_34)

		assert(var67_34, var65_34)

		if arg0_34.contextData.hpRate then
			var0_34.RepressInfo = {
				repressEnemyHpRant = arg0_34.contextData.hpRate
			}
		end

		local var68_34 = _.values(var66_34:getCommanders())

		var0_34.CommanderList = var66_34:buildBattleBuffList()
		arg0_34.mainShips = var4_34:getShipsByFleet(var66_34)

		local var69_34 = {}
		local var70_34 = {}
		local var71_34 = {}
		local var72_34 = var66_34:getTeamByName(TeamType.Main)

		for iter26_34, iter27_34 in ipairs(var72_34) do
			if table.contains(var5_34, iter27_34) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_34[#var5_34 + 1] = iter27_34

			local var73_34 = var4_34:getShipById(iter27_34)
			local var74_34 = var1_0(var1_34, var73_34, var68_34)

			table.insert(var69_34, var73_34)
			table.insert(var0_34.MainUnitList, var74_34)
		end

		local var75_34 = var66_34:getTeamByName(TeamType.Vanguard)

		for iter28_34, iter29_34 in ipairs(var75_34) do
			if table.contains(var5_34, iter29_34) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_34[#var5_34 + 1] = iter29_34

			local var76_34 = var4_34:getShipById(iter29_34)
			local var77_34 = var1_0(var1_34, var76_34, var68_34)

			table.insert(var70_34, var76_34)
			table.insert(var0_34.VanguardUnitList, var77_34)
		end

		arg0_34.viewComponent:setFleet(var69_34, var70_34, var71_34)

		var0_34.MapAidSkills = {}

		if var67_34:IsSelf() then
			local var78_34, var79_34, var80_34 = var64_34.GetSupportValue()

			if var78_34 then
				table.insert(var0_34.MapAidSkills, {
					level = 1,
					id = var80_34
				})
			end
		end
	elseif var1_34 == SYSTEM_HP_SHARE_ACT_BOSS or var1_34 == SYSTEM_ACT_BOSS or var1_34 == SYSTEM_ACT_BOSS_SP or var1_34 == SYSTEM_BOSS_EXPERIMENT then
		if arg0_34.contextData.mainFleetId then
			local var81_34 = getProxy(FleetProxy):getActivityFleets()[arg0_34.contextData.actId]
			local var82_34 = var81_34[arg0_34.contextData.mainFleetId]
			local var83_34 = _.values(var82_34:getCommanders())

			var0_34.CommanderList = var82_34:buildBattleBuffList()
			arg0_34.mainShips = {}

			local var84_34 = {}
			local var85_34 = {}
			local var86_34 = {}

			local function var87_34(arg0_39, arg1_39, arg2_39, arg3_39)
				if table.contains(var5_34, arg0_39) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_34[#var5_34 + 1] = arg0_39

				local var0_39 = var4_34:getShipById(arg0_39)
				local var1_39 = var1_0(var1_34, var0_39, arg1_39)

				table.insert(arg0_34.mainShips, var0_39)
				table.insert(arg3_39, var0_39)
				table.insert(arg2_39, var1_39)
			end

			local var88_34 = var82_34:getTeamByName(TeamType.Main)
			local var89_34 = var82_34:getTeamByName(TeamType.Vanguard)

			for iter30_34, iter31_34 in ipairs(var88_34) do
				var87_34(iter31_34, var83_34, var0_34.MainUnitList, var84_34)
			end

			for iter32_34, iter33_34 in ipairs(var89_34) do
				var87_34(iter33_34, var83_34, var0_34.VanguardUnitList, var85_34)
			end

			local var90_34 = var81_34[arg0_34.contextData.mainFleetId + 10]
			local var91_34 = _.values(var90_34:getCommanders())
			local var92_34 = var90_34:getTeamByName(TeamType.Submarine)

			for iter34_34, iter35_34 in ipairs(var92_34) do
				var87_34(iter35_34, var91_34, var0_34.SubUnitList, var86_34)
			end

			local var93_34 = getProxy(PlayerProxy):getRawData()
			local var94_34 = getProxy(ActivityProxy):getActivityById(arg0_34.contextData.actId)
			local var95_34 = var94_34:getConfig("config_id")
			local var96_34 = pg.activity_event_worldboss[var95_34].use_oil_limit[arg0_34.contextData.mainFleetId]
			local var97_34 = var94_34:IsOilLimit(arg0_34.contextData.stageId)
			local var98_34 = 0
			local var99_34 = var3_34.oil_cost > 0

			local function var100_34(arg0_40, arg1_40)
				if var99_34 then
					local var0_40 = arg0_40:getEndCost().oil

					if arg1_40 > 0 then
						local var1_40 = arg0_40:getStartCost().oil

						cost = math.clamp(arg1_40 - var1_40, 0, var0_40)
					end

					var98_34 = var98_34 + var0_40
				end
			end

			if var1_34 == SYSTEM_ACT_BOSS_SP then
				local var101_34 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0_34.contextData.actId).buffIds
				local var102_34 = _.map(var101_34, function(arg0_41)
					return ActivityBossBuff.New({
						configId = arg0_41
					})
				end)

				var0_34.ExtraBuffList = _.map(_.select(var102_34, function(arg0_42)
					return arg0_42:CastOnEnemy()
				end), function(arg0_43)
					return arg0_43:GetBuffID()
				end)
				var0_34.ChapterBuffIDs = _.map(_.select(var102_34, function(arg0_44)
					return not arg0_44:CastOnEnemy()
				end), function(arg0_45)
					return arg0_45:GetBuffID()
				end)
			else
				var100_34(var82_34, var97_34 and var96_34[1] or 0)
				var100_34(var90_34, var97_34 and var96_34[2] or 0)
			end

			if var90_34:isLegalToFight() == true and (var1_34 == SYSTEM_BOSS_EXPERIMENT or var98_34 <= var93_34.oil) then
				var0_34.SubFlag = 1
				var0_34.TotalSubAmmo = 1
			end

			var0_34.SubCommanderList = var90_34:buildBattleBuffList()

			arg0_34.viewComponent:setFleet(var84_34, var85_34, var86_34)
		end
	elseif var1_34 == SYSTEM_GUILD then
		local var103_34 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
		local var104_34 = var103_34:GetMainFleet()
		local var105_34 = _.values(var104_34:getCommanders())

		var0_34.CommanderList = var104_34:BuildBattleBuffList()
		arg0_34.mainShips = {}

		local var106_34 = {}
		local var107_34 = {}
		local var108_34 = {}

		local function var109_34(arg0_46, arg1_46, arg2_46, arg3_46)
			local var0_46 = var1_0(var1_34, arg0_46, arg1_46)

			table.insert(arg0_34.mainShips, arg0_46)
			table.insert(arg3_46, arg0_46)
			table.insert(arg2_46, var0_46)
		end

		local var110_34 = {}
		local var111_34 = {}
		local var112_34 = var104_34:GetShips()

		for iter36_34, iter37_34 in pairs(var112_34) do
			local var113_34 = iter37_34.ship

			if var113_34:getTeamType() == TeamType.Main then
				table.insert(var110_34, var113_34)
			elseif var113_34:getTeamType() == TeamType.Vanguard then
				table.insert(var111_34, var113_34)
			end
		end

		for iter38_34, iter39_34 in ipairs(var110_34) do
			var109_34(iter39_34, var105_34, var0_34.MainUnitList, var106_34)
		end

		for iter40_34, iter41_34 in ipairs(var111_34) do
			var109_34(iter41_34, var105_34, var0_34.VanguardUnitList, var107_34)
		end

		local var114_34 = var103_34:GetSubFleet()
		local var115_34 = _.values(var114_34:getCommanders())
		local var116_34 = {}
		local var117_34 = var114_34:GetShips()

		for iter42_34, iter43_34 in pairs(var117_34) do
			local var118_34 = iter43_34.ship

			if var118_34:getTeamType() == TeamType.Submarine then
				table.insert(var116_34, var118_34)
			end
		end

		for iter44_34, iter45_34 in ipairs(var116_34) do
			var109_34(iter45_34, var115_34, var0_34.SubUnitList, var108_34)
		end

		if #var108_34 > 0 then
			var0_34.SubFlag = 1
			var0_34.TotalSubAmmo = 1
		end

		var0_34.SubCommanderList = var114_34:BuildBattleBuffList()

		arg0_34.viewComponent:setFleet(var106_34, var107_34, var108_34)
	elseif var1_34 == SYSTEM_BOSS_RUSH or var1_34 == SYSTEM_BOSS_RUSH_EX then
		local var119_34 = getProxy(ActivityProxy):getActivityById(arg0_34.contextData.actId):GetSeriesData()

		assert(var119_34)

		local var120_34 = var119_34:GetStaegLevel() + 1
		local var121_34 = var119_34:GetFleetIds()
		local var122_34 = var121_34[var120_34]
		local var123_34 = var121_34[#var121_34]

		if var119_34:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var122_34 = var121_34[1]
		end

		local var124_34 = getProxy(FleetProxy):getActivityFleets()[arg0_34.contextData.actId]

		arg0_34.mainShips = {}

		local var125_34 = {}
		local var126_34 = {}
		local var127_34 = {}

		local function var128_34(arg0_47, arg1_47, arg2_47, arg3_47)
			if table.contains(var5_34, arg0_47) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_34[#var5_34 + 1] = arg0_47

			local var0_47 = var4_34:getShipById(arg0_47)
			local var1_47 = var1_0(var1_34, var0_47, arg1_47)

			table.insert(arg0_34.mainShips, var0_47)
			table.insert(arg3_47, var0_47)
			table.insert(arg2_47, var1_47)
		end

		local var129_34 = var124_34[var122_34]
		local var130_34 = _.values(var129_34:getCommanders())

		var0_34.CommanderList = var129_34:buildBattleBuffList()

		local var131_34 = var129_34:getTeamByName(TeamType.Main)
		local var132_34 = var129_34:getTeamByName(TeamType.Vanguard)

		for iter46_34, iter47_34 in ipairs(var131_34) do
			var128_34(iter47_34, var130_34, var0_34.MainUnitList, var125_34)
		end

		for iter48_34, iter49_34 in ipairs(var132_34) do
			var128_34(iter49_34, var130_34, var0_34.VanguardUnitList, var126_34)
		end

		local var133_34 = var124_34[var123_34]
		local var134_34 = _.values(var133_34:getCommanders())

		var0_34.SubCommanderList = var133_34:buildBattleBuffList()

		local var135_34 = var133_34:getTeamByName(TeamType.Submarine)

		for iter50_34, iter51_34 in ipairs(var135_34) do
			var128_34(iter51_34, var134_34, var0_34.SubUnitList, var127_34)
		end

		local var136_34 = getProxy(PlayerProxy):getRawData()
		local var137_34 = 0
		local var138_34 = var119_34:GetOilLimit()
		local var139_34 = var3_34.oil_cost > 0

		local function var140_34(arg0_48, arg1_48)
			local var0_48 = 0

			if var139_34 then
				local var1_48 = arg0_48:getStartCost().oil
				local var2_48 = arg0_48:getEndCost().oil

				var0_48 = var2_48

				if arg1_48 > 0 then
					var0_48 = math.clamp(arg1_48 - var1_48, 0, var2_48)
				end
			end

			return var0_48
		end

		local var141_34 = var137_34 + var140_34(var129_34, var138_34[1]) + var140_34(var133_34, var138_34[2])

		if var133_34:isLegalToFight() == true and var141_34 <= var136_34.oil then
			var0_34.SubFlag = 1
			var0_34.TotalSubAmmo = 1
		end

		arg0_34.viewComponent:setFleet(var125_34, var126_34, var127_34)
	elseif var1_34 == SYSTEM_LIMIT_CHALLENGE then
		local var142_34 = LimitChallengeConst.GetChallengeIDByStageID(arg0_34.contextData.stageId)

		var0_34.ExtraBuffList = AcessWithinNull(pg.expedition_constellation_challenge_template[var142_34], "buff_id")

		local var143_34 = FleetProxy.CHALLENGE_FLEET_ID
		local var144_34 = FleetProxy.CHALLENGE_SUB_FLEET_ID
		local var145_34 = getProxy(FleetProxy)
		local var146_34 = var145_34:getFleetById(var143_34)
		local var147_34 = var145_34:getFleetById(var144_34)

		arg0_34.mainShips = {}

		local var148_34 = {}
		local var149_34 = {}
		local var150_34 = {}

		local function var151_34(arg0_49, arg1_49, arg2_49, arg3_49)
			if table.contains(var5_34, arg0_49) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_34[#var5_34 + 1] = arg0_49

			local var0_49 = var4_34:getShipById(arg0_49)
			local var1_49 = var1_0(var1_34, var0_49, arg1_49)

			table.insert(arg0_34.mainShips, var0_49)
			table.insert(arg3_49, var0_49)
			table.insert(arg2_49, var1_49)
		end

		local var152_34 = _.values(var146_34:getCommanders())

		var0_34.CommanderList = var146_34:buildBattleBuffList()

		local var153_34 = var146_34:getTeamByName(TeamType.Main)
		local var154_34 = var146_34:getTeamByName(TeamType.Vanguard)

		for iter52_34, iter53_34 in ipairs(var153_34) do
			var151_34(iter53_34, var152_34, var0_34.MainUnitList, var148_34)
		end

		for iter54_34, iter55_34 in ipairs(var154_34) do
			var151_34(iter55_34, var152_34, var0_34.VanguardUnitList, var149_34)
		end

		local var155_34 = _.values(var147_34:getCommanders())

		var0_34.SubCommanderList = var147_34:buildBattleBuffList()

		local var156_34 = var147_34:getTeamByName(TeamType.Submarine)

		for iter56_34, iter57_34 in ipairs(var156_34) do
			var151_34(iter57_34, var155_34, var0_34.SubUnitList, var150_34)
		end

		local var157_34 = getProxy(PlayerProxy):getRawData()
		local var158_34 = 0
		local var159_34 = var3_34.oil_cost > 0

		local function var160_34(arg0_50, arg1_50)
			local var0_50 = 0

			if var159_34 then
				local var1_50 = arg0_50:getStartCost().oil
				local var2_50 = arg0_50:getEndCost().oil

				var0_50 = var2_50

				if arg1_50 > 0 then
					var0_50 = math.clamp(arg1_50 - var1_50, 0, var2_50)
				end
			end

			return var0_50
		end

		local var161_34 = var158_34 + var160_34(var146_34, 0) + var160_34(var147_34, 0)

		if var147_34:isLegalToFight() == true and var161_34 <= var157_34.oil then
			var0_34.SubFlag = 1
			var0_34.TotalSubAmmo = 1
		end

		arg0_34.viewComponent:setFleet(var148_34, var149_34, var150_34)
	elseif var1_34 == SYSTEM_CARDPUZZLE then
		local var162_34 = {}
		local var163_34 = {}
		local var164_34 = arg0_34.contextData.relics

		for iter58_34, iter59_34 in ipairs(arg0_34.contextData.cardPuzzleFleet) do
			local var165_34 = var2_0(iter59_34, var164_34)
			local var166_34 = var165_34.fleetIndex

			if var166_34 == 1 then
				table.insert(var163_34, var165_34)
				table.insert(var0_34.VanguardUnitList, var165_34)
			elseif var166_34 == 2 then
				table.insert(var162_34, var165_34)
				table.insert(var0_34.MainUnitList, var165_34)
			end
		end

		var0_34.CardPuzzleCardIDList = arg0_34.contextData.cards
		var0_34.CardPuzzleCommonHPValue = arg0_34.contextData.hp
		var0_34.CardPuzzleRelicList = var164_34
		var0_34.CardPuzzleCombatID = arg0_34.contextData.puzzleCombatID
	elseif var1_34 == SYSTEM_BOSS_SINGLE then
		if arg0_34.contextData.mainFleetId then
			local var167_34 = getProxy(FleetProxy):getActivityFleets()[arg0_34.contextData.actId]
			local var168_34 = var167_34[arg0_34.contextData.mainFleetId]
			local var169_34 = _.values(var168_34:getCommanders())

			var0_34.CommanderList = var168_34:buildBattleBuffList()
			arg0_34.mainShips = {}

			local var170_34 = {}
			local var171_34 = {}
			local var172_34 = {}

			local function var173_34(arg0_51, arg1_51, arg2_51, arg3_51)
				if table.contains(var5_34, arg0_51) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_34[#var5_34 + 1] = arg0_51

				local var0_51 = var4_34:getShipById(arg0_51)
				local var1_51 = var1_0(var1_34, var0_51, arg1_51)

				table.insert(arg0_34.mainShips, var0_51)
				table.insert(arg3_51, var0_51)
				table.insert(arg2_51, var1_51)
			end

			local var174_34 = var168_34:getTeamByName(TeamType.Main)
			local var175_34 = var168_34:getTeamByName(TeamType.Vanguard)

			for iter60_34, iter61_34 in ipairs(var174_34) do
				var173_34(iter61_34, var169_34, var0_34.MainUnitList, var170_34)
			end

			for iter62_34, iter63_34 in ipairs(var175_34) do
				var173_34(iter63_34, var169_34, var0_34.VanguardUnitList, var171_34)
			end

			local var176_34 = var167_34[arg0_34.contextData.mainFleetId + 10]
			local var177_34 = _.values(var176_34:getCommanders())
			local var178_34 = var176_34:getTeamByName(TeamType.Submarine)

			for iter64_34, iter65_34 in ipairs(var178_34) do
				var173_34(iter65_34, var177_34, var0_34.SubUnitList, var172_34)
			end

			local var179_34 = getProxy(PlayerProxy):getRawData()
			local var180_34 = getProxy(ActivityProxy):getActivityById(arg0_34.contextData.actId)

			var0_34.ChapterBuffIDs = var180_34:GetBuffIdsByStageId(arg0_34.contextData.stageId)

			local var181_34 = var180_34:GetEnemyDataByStageId(arg0_34.contextData.stageId):GetOilLimit()
			local var182_34 = 0
			local var183_34 = var3_34.oil_cost > 0

			local function var184_34(arg0_52, arg1_52)
				if var183_34 then
					local var0_52 = arg0_52:getEndCost().oil

					if arg1_52 > 0 then
						local var1_52 = arg0_52:getStartCost().oil

						cost = math.clamp(arg1_52 - var1_52, 0, var0_52)
					end

					var182_34 = var182_34 + var0_52
				end
			end

			var184_34(var168_34, var181_34[1] or 0)
			var184_34(var176_34, var181_34[2] or 0)

			if var176_34:isLegalToFight() == true and var182_34 <= var179_34.oil then
				var0_34.SubFlag = 1
				var0_34.TotalSubAmmo = 1
			end

			var0_34.SubCommanderList = var176_34:buildBattleBuffList()

			arg0_34.viewComponent:setFleet(var170_34, var171_34, var172_34)
		end
	elseif arg0_34.contextData.mainFleetId then
		local var185_34 = var1_34 == SYSTEM_DUEL
		local var186_34 = getProxy(FleetProxy)
		local var187_34
		local var188_34
		local var189_34 = var186_34:getFleetById(arg0_34.contextData.mainFleetId)

		arg0_34.mainShips = var4_34:getShipsByFleet(var189_34)

		local var190_34 = {}
		local var191_34 = {}
		local var192_34 = {}

		local function var193_34(arg0_53, arg1_53, arg2_53)
			for iter0_53, iter1_53 in ipairs(arg0_53) do
				if table.contains(var5_34, iter1_53) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_34[#var5_34 + 1] = iter1_53

				local var0_53 = var4_34:getShipById(iter1_53)
				local var1_53 = var1_0(var1_34, var0_53, nil, var185_34)

				table.insert(arg1_53, var0_53)
				table.insert(arg2_53, var1_53)
			end
		end

		local var194_34 = var189_34:getTeamByName(TeamType.Main)
		local var195_34 = var189_34:getTeamByName(TeamType.Vanguard)
		local var196_34 = var189_34:getTeamByName(TeamType.Submarine)

		var193_34(var194_34, var190_34, var0_34.MainUnitList)
		var193_34(var195_34, var191_34, var0_34.VanguardUnitList)
		var193_34(var196_34, var192_34, var0_34.SubUnitList)
		arg0_34.viewComponent:setFleet(var190_34, var191_34, var192_34)

		if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
			local var197_34 = var186_34:getFleetById(11)
			local var198_34 = var197_34:getTeamByName(TeamType.Submarine)

			if #var198_34 > 0 then
				var0_34.SubFlag = 1
				var0_34.TotalSubAmmo = 1

				local var199_34 = _.values(var197_34:getCommanders())

				var0_34.SubCommanderList = var197_34:buildBattleBuffList()

				for iter66_34, iter67_34 in ipairs(var198_34) do
					local var200_34 = var4_34:getShipById(iter67_34)
					local var201_34 = var1_0(var1_34, var200_34, var199_34, var185_34)

					table.insert(var192_34, var200_34)
					table.insert(var0_34.SubUnitList, var201_34)
				end
			end
		end
	end

	if var1_34 == SYSTEM_WORLD then
		local var202_34 = nowWorld()
		local var203_34 = var202_34:GetActiveMap()
		local var204_34 = var203_34:GetFleet()
		local var205_34 = var203_34:GetCell(var204_34.row, var204_34.column):GetStageEnemy()
		local var206_34 = pg.world_expedition_data[arg0_34.contextData.stageId]
		local var207_34 = var202_34:GetWorldMapDifficultyBuffLevel()

		var0_34.EnemyMapRewards = {
			var207_34[1] * (1 + var206_34.expedition_sairenvalueA / 10000),
			var207_34[2] * (1 + var206_34.expedition_sairenvalueB / 10000),
			var207_34[3] * (1 + var206_34.expedition_sairenvalueC / 10000)
		}
		var0_34.FleetMapRewards = var202_34:GetWorldMapBuffLevel()
	end

	var0_34.RivalMainUnitList, var0_34.RivalVanguardUnitList = {}, {}

	local var208_34

	if var1_34 == SYSTEM_DUEL and arg0_34.contextData.rivalId then
		local var209_34 = getProxy(MilitaryExerciseProxy)

		var208_34 = var209_34:getRivalById(arg0_34.contextData.rivalId)
		arg0_34.oldRank = var209_34:getSeasonInfo()
	end

	if var208_34 then
		var0_34.RivalVO = var208_34

		local var210_34 = 0

		for iter68_34, iter69_34 in ipairs(var208_34.mainShips) do
			var210_34 = var210_34 + iter69_34.level
		end

		for iter70_34, iter71_34 in ipairs(var208_34.vanguardShips) do
			var210_34 = var210_34 + iter71_34.level
		end

		BattleVertify = BattleVertify or {}
		BattleVertify.rivalLevel = var210_34

		for iter72_34, iter73_34 in ipairs(var208_34.mainShips) do
			if not iter73_34.hpRant or iter73_34.hpRant > 0 then
				local var211_34 = var1_0(var1_34, iter73_34, nil, true)

				if iter73_34.hpRant then
					var211_34.initHPRate = iter73_34.hpRant * 0.0001
				end

				table.insert(var0_34.RivalMainUnitList, var211_34)
			end
		end

		for iter74_34, iter75_34 in ipairs(var208_34.vanguardShips) do
			if not iter75_34.hpRant or iter75_34.hpRant > 0 then
				local var212_34 = var1_0(var1_34, iter75_34, nil, true)

				if iter75_34.hpRant then
					var212_34.initHPRate = iter75_34.hpRant * 0.0001
				end

				table.insert(var0_34.RivalVanguardUnitList, var212_34)
			end
		end
	end

	local var213_34 = arg0_34.contextData.prefabFleet.main_unitList
	local var214_34 = arg0_34.contextData.prefabFleet.vanguard_unitList
	local var215_34 = arg0_34.contextData.prefabFleet.submarine_unitList

	if var213_34 then
		for iter76_34, iter77_34 in ipairs(var213_34) do
			local var216_34 = {}

			for iter78_34, iter79_34 in ipairs(iter77_34.equipment) do
				var216_34[#var216_34 + 1] = {
					skin = 0,
					id = iter79_34
				}
			end

			local var217_34 = {
				id = iter77_34.id,
				tmpID = iter77_34.configId,
				skinId = iter77_34.skinId,
				level = iter77_34.level,
				equipment = var216_34,
				properties = iter77_34.properties,
				baseProperties = iter77_34.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter77_34.skills
			}

			table.insert(var0_34.MainUnitList, var217_34)
		end
	end

	if var214_34 then
		for iter80_34, iter81_34 in ipairs(var214_34) do
			local var218_34 = {}

			for iter82_34, iter83_34 in ipairs(iter81_34.equipment) do
				var218_34[#var218_34 + 1] = {
					skin = 0,
					id = iter83_34
				}
			end

			local var219_34 = {
				id = iter81_34.id,
				tmpID = iter81_34.configId,
				skinId = iter81_34.skinId,
				level = iter81_34.level,
				equipment = var218_34,
				properties = iter81_34.properties,
				baseProperties = iter81_34.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter81_34.skills
			}

			table.insert(var0_34.VanguardUnitList, var219_34)
		end
	end

	if var215_34 then
		for iter84_34, iter85_34 in ipairs(var215_34) do
			local var220_34 = {}

			for iter86_34, iter87_34 in ipairs(iter85_34.equipment) do
				var220_34[#var220_34 + 1] = {
					skin = 0,
					id = iter87_34
				}
			end

			local var221_34 = {
				id = iter85_34.id,
				tmpID = iter85_34.configId,
				skinId = iter85_34.skinId,
				level = iter85_34.level,
				equipment = var220_34,
				properties = iter85_34.properties,
				baseProperties = iter85_34.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter85_34.skills
			}

			table.insert(var0_34.SubUnitList, var221_34)

			if var1_34 == SYSTEM_SIMULATION and #var0_34.SubUnitList > 0 then
				var0_34.SubFlag = 1
				var0_34.TotalSubAmmo = 1
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
					cmdArgs = arg0_55.contextData.cmdArgs
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
