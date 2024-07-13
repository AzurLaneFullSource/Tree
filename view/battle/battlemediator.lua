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

function var0_0.onPauseBtn(arg0_13)
	local var0_13 = ys.Battle.BattleState.GetInstance()

	if arg0_13.contextData.system == SYSTEM_PROLOGUE or arg0_13.contextData.system == SYSTEM_PERFORM then
		local var1_13 = {}

		if EPILOGUE_SKIPPABLE then
			local var2_13 = {
				text = "关爱胡德",
				btnType = pg.MsgboxMgr.BUTTON_RED,
				onCallback = function()
					var0_13:Deactive()
					arg0_13:sendNotification(GAME.CHANGE_SCENE, SCENE.CREATE_PLAYER)
				end
			}

			table.insert(var1_13, 1, var2_13)
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
			custom = var1_13
		})
		var0_13:Pause()
	elseif arg0_13.contextData.system == SYSTEM_DODGEM then
		local var3_13 = {
			text = "text_cancel_fight",
			btnType = pg.MsgboxMgr.BUTTON_RED,
			onCallback = function()
				arg0_13:warnFunc(function()
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
				var3_13
			}
		})
		var0_13:Pause()
	elseif arg0_13.contextData.system == SYSTEM_SIMULATION then
		local var4_13 = {
			text = "text_cancel_fight",
			btnType = pg.MsgboxMgr.BUTTON_RED,
			onCallback = function()
				arg0_13:warnFunc(function()
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
				var4_13
			}
		})
		var0_13:Pause()
	elseif arg0_13.contextData.system == SYSTEM_SUBMARINE_RUN or arg0_13.contextData.system == SYSTEM_SUB_ROUTINE or arg0_13.contextData.system == SYSTEM_REWARD_PERFORM or arg0_13.contextData.system == SYSTEM_AIRFIGHT then
		var0_13:Pause()
		arg0_13:warnFunc(function()
			ys.Battle.BattleState.GetInstance():Resume()
		end)
	elseif arg0_13.contextData.system == SYSTEM_CARDPUZZLE then
		arg0_13:addSubLayers(Context.New({
			mediator = CardPuzzleCombatPauseMediator,
			viewComponent = CardPuzzleCombatPauseLayer
		}))
		var0_13:Pause()
	else
		arg0_13.viewComponent:updatePauseWindow()
		var0_13:Pause()
	end
end

function var0_0.warnFunc(arg0_26, arg1_26)
	local var0_26 = ys.Battle.BattleState.GetInstance()
	local var1_26 = arg0_26.contextData.system
	local var2_26
	local var3_26

	local function var4_26()
		var0_26:Stop()
	end

	local var5_26 = arg0_26.contextData.warnMsg

	if var5_26 and #var5_26 > 0 then
		var3_26 = i18n(var5_26)
	elseif var1_26 == SYSTEM_CHALLENGE then
		var3_26 = i18n("battle_battleMediator_clear_warning")
	elseif var1_26 == SYSTEM_SIMULATION then
		var3_26 = i18n("tech_simulate_quit")
	else
		var3_26 = i18n("battle_battleMediator_quest_exist")
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideNo = true,
		hideYes = true,
		content = var3_26,
		onClose = arg1_26,
		custom = {
			{
				text = "text_cancel",
				onCallback = arg1_26,
				sound = SFX_CANCEL
			},
			{
				text = "text_exit",
				btnType = pg.MsgboxMgr.BUTTON_RED,
				onCallback = var4_26,
				sound = SFX_CONFIRM
			}
		}
	})
end

function var0_0.guideDispatch(arg0_28)
	return
end

local function var1_0(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = {}

	for iter0_29, iter1_29 in ipairs(arg1_29:getActiveEquipments()) do
		if iter1_29 then
			var0_29[#var0_29 + 1] = {
				id = iter1_29.configId,
				skin = iter1_29.skinId,
				equipmentInfo = iter1_29
			}
		else
			var0_29[#var0_29 + 1] = {
				skin = 0,
				id = iter1_29,
				equipmentInfo = iter1_29
			}
		end
	end

	local var1_29 = {}

	local function var2_29(arg0_30)
		local var0_30 = {
			level = arg0_30.level
		}
		local var1_30 = arg0_30.id
		local var2_30 = arg1_29:RemapSkillId(var1_30)

		var0_30.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_29, var2_30)

		return var0_30
	end

	local var3_29 = ys.Battle.BattleDataFunction.GenerateHiddenBuff(arg1_29.configId)

	for iter2_29, iter3_29 in pairs(var3_29) do
		local var4_29 = var2_29(iter3_29)

		var1_29[var4_29.id] = var4_29
	end

	for iter4_29, iter5_29 in pairs(arg1_29.skills) do
		if iter5_29 and iter5_29.id == 14900 and not arg1_29.transforms[16412] then
			-- block empty
		else
			local var5_29 = var2_29(iter5_29)

			var1_29[var5_29.id] = var5_29
		end
	end

	local var6_29 = ys.Battle.BattleDataFunction.GetEquipSkill(var0_29)

	for iter6_29, iter7_29 in ipairs(var6_29) do
		local var7_29 = {}

		var7_29.level = 1
		var7_29.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_29, iter7_29)
		var1_29[var7_29.id] = var7_29
	end

	local var8_29

	;(function()
		var8_29 = arg1_29:GetSpWeapon()

		if not var8_29 then
			return
		end

		local var0_31 = var8_29:GetEffect()

		if var0_31 == 0 then
			return
		end

		local var1_31 = {}

		var1_31.level = 1
		var1_31.id = ys.Battle.BattleDataFunction.SkillTranform(arg0_29, var0_31)
		var1_29[var1_31.id] = var1_31
	end)()

	for iter8_29, iter9_29 in pairs(arg1_29:getTriggerSkills()) do
		local var9_29 = {
			level = iter9_29.level,
			id = ys.Battle.BattleDataFunction.SkillTranform(arg0_29, iter9_29.id)
		}

		var1_29[var9_29.id] = var9_29
	end

	local var10_29 = arg0_29 == SYSTEM_WORLD
	local var11_29 = false

	if var10_29 then
		local var12_29 = WorldConst.FetchWorldShip(arg1_29.id)

		if var12_29 then
			var11_29 = var12_29:IsBroken()
		end
	end

	if var11_29 then
		for iter10_29, iter11_29 in pairs(var1_29) do
			local var13_29 = pg.skill_data_template[iter10_29].world_death_mark[1]

			if var13_29 == ys.Battle.BattleConst.DEATH_MARK_SKILL.DEACTIVE then
				var1_29[iter10_29] = nil
			elseif var13_29 == ys.Battle.BattleConst.DEATH_MARK_SKILL.IGNORE then
				-- block empty
			end
		end
	end

	return {
		id = arg1_29.id,
		tmpID = arg1_29.configId,
		skinId = arg1_29.skinId,
		level = arg1_29.level,
		equipment = var0_29,
		properties = arg1_29:getProperties(arg2_29, arg3_29, var10_29),
		baseProperties = arg1_29:getShipProperties(),
		proficiency = arg1_29:getEquipProficiencyList(),
		rarity = arg1_29:getRarity(),
		intimacy = arg1_29:getCVIntimacy(),
		shipGS = arg1_29:getShipCombatPower(),
		skills = var1_29,
		baseList = arg1_29:getBaseList(),
		preloasList = arg1_29:getPreLoadCount(),
		name = arg1_29:getName(),
		deathMark = var11_29,
		spWeapon = var8_29
	}
end

local function var2_0(arg0_32, arg1_32)
	local var0_32 = arg0_32:getProperties(arg1_32)
	local var1_32 = arg0_32:getConfig("id")

	return {
		deathMark = false,
		shipGS = 100,
		rarity = 1,
		intimacy = 100,
		id = var1_32,
		tmpID = var1_32,
		skinId = arg0_32:getConfig("skin_id"),
		level = arg0_32:getConfig("level"),
		equipment = arg0_32:getConfig("default_equip"),
		properties = var0_32,
		baseProperties = var0_32,
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
		name = var1_32,
		fleetIndex = arg0_32:getConfig("location")
	}
end

function var0_0.GenBattleData(arg0_33)
	local var0_33 = {}
	local var1_33 = arg0_33.contextData.system

	arg0_33._battleData = var0_33
	var0_33.battleType = arg0_33.contextData.system
	var0_33.StageTmpId = arg0_33.contextData.stageId
	var0_33.CMDArgs = arg0_33.contextData.cmdArgs
	var0_33.MainUnitList = {}
	var0_33.VanguardUnitList = {}
	var0_33.SubUnitList = {}
	var0_33.AidUnitList = {}
	var0_33.SupportUnitList = {}
	var0_33.SubFlag = -1
	var0_33.ActID = arg0_33.contextData.actId
	var0_33.bossLevel = arg0_33.contextData.bossLevel
	var0_33.bossConfigId = arg0_33.contextData.bossConfigId

	if pg.battle_cost_template[var1_33].global_buff_effected > 0 then
		local var2_33 = BuffHelper.GetBattleBuffs(var1_33)

		var0_33.GlobalBuffIDs = _.map(var2_33, function(arg0_34)
			return arg0_34:getConfig("benefit_effect")
		end) or {}
	end

	local var3_33 = pg.battle_cost_template[var1_33]
	local var4_33 = getProxy(BayProxy)
	local var5_33 = {}

	if var1_33 == SYSTEM_SCENARIO then
		local var6_33 = getProxy(ChapterProxy)
		local var7_33 = var6_33:getActiveChapter()

		var0_33.RepressInfo = var7_33:getRepressInfo()

		arg0_33.viewComponent:setChapter(var7_33)

		local var8_33 = var7_33.fleet

		var0_33.KizunaJamming = var7_33.extraFlagList
		var0_33.DefeatCount = var8_33:getDefeatCount()
		var0_33.ChapterBuffIDs, var0_33.CommanderList = var7_33:getFleetBattleBuffs(var8_33)
		var0_33.StageWaveFlags = var7_33:GetStageFlags()
		var0_33.ChapterWeatherIDS = var7_33:GetWeather(var8_33.line.row, var8_33.line.column)
		var0_33.MapAuraSkills = var6_33.GetChapterAuraBuffs(var7_33)
		var0_33.MapAidSkills = {}

		local var9_33 = var6_33.GetChapterAidBuffs(var7_33)

		for iter0_33, iter1_33 in pairs(var9_33) do
			local var10_33 = var7_33:getFleetByShipVO(iter0_33)
			local var11_33 = _.values(var10_33:getCommanders())
			local var12_33 = var1_0(var1_33, iter0_33, var11_33)

			table.insert(var0_33.AidUnitList, var12_33)

			for iter2_33, iter3_33 in ipairs(iter1_33) do
				table.insert(var0_33.MapAidSkills, iter3_33)
			end
		end

		local var13_33 = var8_33:getShipsByTeam(TeamType.Main, false)
		local var14_33 = var8_33:getShipsByTeam(TeamType.Vanguard, false)
		local var15_33 = {}
		local var16_33 = _.values(var8_33:getCommanders())
		local var17_33 = {}
		local var18_33, var19_33 = var6_33.getSubAidFlag(var7_33, arg0_33.contextData.stageId)

		if var18_33 == true or var18_33 > 0 then
			var0_33.SubFlag = 1
			var0_33.TotalSubAmmo = 1
			var15_33 = var19_33:getShipsByTeam(TeamType.Submarine, false)
			var17_33 = _.values(var19_33:getCommanders())

			local var20_33, var21_33 = var7_33:getFleetBattleBuffs(var19_33)

			var0_33.SubCommanderList = var21_33
		else
			var0_33.SubFlag = var18_33

			if var18_33 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_33.TotalSubAmmo = 0
			end
		end

		arg0_33.mainShips = {}

		local function var22_33(arg0_35, arg1_35, arg2_35)
			local var0_35 = arg0_35.id
			local var1_35 = arg0_35.hpRant * 0.0001

			if table.contains(var5_33, var0_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_33[#var5_33 + 1] = var0_35

			local var2_35 = var1_0(var1_33, arg0_35, arg1_35)

			var2_35.initHPRate = var1_35

			table.insert(arg0_33.mainShips, arg0_35)
			table.insert(arg2_35, var2_35)
		end

		for iter4_33, iter5_33 in ipairs(var13_33) do
			var22_33(iter5_33, var16_33, var0_33.MainUnitList)
		end

		for iter6_33, iter7_33 in ipairs(var14_33) do
			var22_33(iter7_33, var16_33, var0_33.VanguardUnitList)
		end

		for iter8_33, iter9_33 in ipairs(var15_33) do
			var22_33(iter9_33, var17_33, var0_33.SubUnitList)
		end

		local var23_33 = var7_33:getChapterSupportFleet()

		if var23_33 then
			local var24_33 = var23_33:getShips()

			for iter10_33, iter11_33 in pairs(var24_33) do
				var22_33(iter11_33, {}, var0_33.SupportUnitList)
			end
		end

		arg0_33.viewComponent:setFleet(var13_33, var14_33, var15_33)
	elseif var1_33 == SYSTEM_CHALLENGE then
		local var25_33 = arg0_33.contextData.mode
		local var26_33 = getProxy(ChallengeProxy):getUserChallengeInfo(var25_33)

		var0_33.ChallengeInfo = var26_33

		arg0_33.viewComponent:setChapter(var26_33)

		local var27_33 = var26_33:getRegularFleet()

		var0_33.CommanderList = var27_33:buildBattleBuffList()

		local var28_33 = _.values(var27_33:getCommanders())
		local var29_33 = {}
		local var30_33 = var27_33:getShipsByTeam(TeamType.Main, false)
		local var31_33 = var27_33:getShipsByTeam(TeamType.Vanguard, false)
		local var32_33 = {}
		local var33_33 = var26_33:getSubmarineFleet()
		local var34_33 = var33_33:getShipsByTeam(TeamType.Submarine, false)

		if #var34_33 > 0 then
			var0_33.SubFlag = 1
			var0_33.TotalSubAmmo = 1
			var29_33 = _.values(var33_33:getCommanders())
			var0_33.SubCommanderList = var33_33:buildBattleBuffList()
		else
			var0_33.SubFlag = 0
			var0_33.TotalSubAmmo = 0
		end

		arg0_33.mainShips = {}

		local function var35_33(arg0_36, arg1_36, arg2_36)
			local var0_36 = arg0_36.id
			local var1_36 = arg0_36.hpRant * 0.0001

			if table.contains(var5_33, var0_36) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_33[#var5_33 + 1] = var0_36

			local var2_36 = var1_0(var1_33, arg0_36, arg1_36)

			var2_36.initHPRate = var1_36

			table.insert(arg0_33.mainShips, arg0_36)
			table.insert(arg2_36, var2_36)
		end

		for iter12_33, iter13_33 in ipairs(var30_33) do
			var35_33(iter13_33, var28_33, var0_33.MainUnitList)
		end

		for iter14_33, iter15_33 in ipairs(var31_33) do
			var35_33(iter15_33, var28_33, var0_33.VanguardUnitList)
		end

		for iter16_33, iter17_33 in ipairs(var34_33) do
			var35_33(iter17_33, var29_33, var0_33.SubUnitList)
		end

		arg0_33.viewComponent:setFleet(var30_33, var31_33, var34_33)
	elseif var1_33 == SYSTEM_WORLD then
		local var36_33 = nowWorld()
		local var37_33 = var36_33:GetActiveMap()
		local var38_33 = var37_33:GetFleet()
		local var39_33 = var37_33:GetCell(var38_33.row, var38_33.column):GetStageEnemy()
		local var40_33 = var39_33:GetHP()

		if var40_33 then
			var0_33.RepressInfo = {
				repressEnemyHpRant = var40_33 / var39_33:GetMaxHP()
			}
		end

		var0_33.AffixBuffList = table.mergeArray(var39_33:GetBattleLuaBuffs(), var37_33:GetBattleLuaBuffs(WorldMap.FactionEnemy, var39_33))

		local function var41_33(arg0_37)
			local var0_37 = {}

			for iter0_37, iter1_37 in ipairs(arg0_37) do
				local var1_37 = {
					id = ys.Battle.BattleDataFunction.SkillTranform(var1_33, iter1_37.id),
					level = iter1_37.level
				}

				table.insert(var0_37, var1_37)
			end

			return var0_37
		end

		var0_33.DefeatCount = var38_33:getDefeatCount()
		var0_33.ChapterBuffIDs, var0_33.CommanderList = var37_33:getFleetBattleBuffs(var38_33, true)
		var0_33.MapAuraSkills = var37_33:GetChapterAuraBuffs()
		var0_33.MapAuraSkills = var41_33(var0_33.MapAuraSkills)
		var0_33.MapAidSkills = {}

		local var42_33 = var37_33:GetChapterAidBuffs()

		for iter18_33, iter19_33 in pairs(var42_33) do
			local var43_33 = var37_33:GetFleet(iter18_33.fleetId)
			local var44_33 = _.values(var43_33:getCommanders(true))
			local var45_33 = var1_0(var1_33, WorldConst.FetchShipVO(iter18_33.id), var44_33)

			table.insert(var0_33.AidUnitList, var45_33)

			var0_33.MapAidSkills = table.mergeArray(var0_33.MapAidSkills, var41_33(iter19_33))
		end

		local var46_33 = var38_33:GetTeamShipVOs(TeamType.Main, false)
		local var47_33 = var38_33:GetTeamShipVOs(TeamType.Vanguard, false)
		local var48_33 = {}
		local var49_33 = _.values(var38_33:getCommanders(true))
		local var50_33 = {}
		local var51_33 = var36_33:GetSubAidFlag()

		if var51_33 == true then
			local var52_33 = var37_33:GetSubmarineFleet()

			var0_33.SubFlag = 1
			var0_33.TotalSubAmmo = 1
			var48_33 = var52_33:GetTeamShipVOs(TeamType.Submarine, false)
			var50_33 = _.values(var52_33:getCommanders(true))

			local var53_33, var54_33 = var37_33:getFleetBattleBuffs(var52_33, true)

			var0_33.SubCommanderList = var54_33
		else
			var0_33.SubFlag = 0

			if var51_33 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_33.TotalSubAmmo = 0
			end
		end

		arg0_33.mainShips = {}

		for iter20_33, iter21_33 in ipairs(var46_33) do
			local var55_33 = iter21_33.id
			local var56_33 = WorldConst.FetchWorldShip(iter21_33.id).hpRant * 0.0001

			if table.contains(var5_33, var55_33) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_33[#var5_33 + 1] = var55_33

			local var57_33 = var1_0(var1_33, iter21_33, var49_33)

			var57_33.initHPRate = var56_33

			table.insert(arg0_33.mainShips, iter21_33)
			table.insert(var0_33.MainUnitList, var57_33)
		end

		for iter22_33, iter23_33 in ipairs(var47_33) do
			local var58_33 = iter23_33.id
			local var59_33 = WorldConst.FetchWorldShip(iter23_33.id).hpRant * 0.0001

			if table.contains(var5_33, var58_33) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_33[#var5_33 + 1] = var58_33

			local var60_33 = var1_0(var1_33, iter23_33, var49_33)

			var60_33.initHPRate = var59_33

			table.insert(arg0_33.mainShips, iter23_33)
			table.insert(var0_33.VanguardUnitList, var60_33)
		end

		for iter24_33, iter25_33 in ipairs(var48_33) do
			local var61_33 = iter25_33.id
			local var62_33 = WorldConst.FetchWorldShip(iter25_33.id).hpRant * 0.0001

			if table.contains(var5_33, var61_33) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_33[#var5_33 + 1] = var61_33

			local var63_33 = var1_0(var1_33, iter25_33, var50_33)

			var63_33.initHPRate = var62_33

			table.insert(arg0_33.mainShips, iter25_33)
			table.insert(var0_33.SubUnitList, var63_33)
		end

		arg0_33.viewComponent:setFleet(var46_33, var47_33, var48_33)

		local var64_33 = pg.expedition_data_template[arg0_33.contextData.stageId]

		if var64_33.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
			var0_33.WorldMapId = var37_33.config.expedition_map_id
			var0_33.WorldLevel = WorldConst.WorldLevelCorrect(var37_33.config.expedition_level, var64_33.type)
		end
	elseif var1_33 == SYSTEM_WORLD_BOSS then
		local var65_33 = nowWorld():GetBossProxy()
		local var66_33 = arg0_33.contextData.bossId
		local var67_33 = var65_33:GetFleet(var66_33)
		local var68_33 = var65_33:GetBossById(var66_33)

		assert(var68_33, var66_33)

		local var69_33 = var68_33:GetHP()

		if var69_33 then
			if var68_33:IsSelf() then
				var0_33.RepressInfo = {
					repressEnemyHpRant = var69_33 / var68_33:GetMaxHp()
				}
			else
				var0_33.RepressInfo = {
					repressEnemyHpRant = 1
				}
			end
		end

		local var70_33 = _.values(var67_33:getCommanders())

		var0_33.CommanderList = var67_33:buildBattleBuffList()
		arg0_33.mainShips = var4_33:getShipsByFleet(var67_33)

		local var71_33 = {}
		local var72_33 = {}
		local var73_33 = {}
		local var74_33 = var67_33:getTeamByName(TeamType.Main)

		for iter26_33, iter27_33 in ipairs(var74_33) do
			if table.contains(var5_33, iter27_33) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_33[#var5_33 + 1] = iter27_33

			local var75_33 = var4_33:getShipById(iter27_33)
			local var76_33 = var1_0(var1_33, var75_33, var70_33)

			table.insert(var71_33, var75_33)
			table.insert(var0_33.MainUnitList, var76_33)
		end

		local var77_33 = var67_33:getTeamByName(TeamType.Vanguard)

		for iter28_33, iter29_33 in ipairs(var77_33) do
			if table.contains(var5_33, iter29_33) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_33[#var5_33 + 1] = iter29_33

			local var78_33 = var4_33:getShipById(iter29_33)
			local var79_33 = var1_0(var1_33, var78_33, var70_33)

			table.insert(var72_33, var78_33)
			table.insert(var0_33.VanguardUnitList, var79_33)
		end

		arg0_33.viewComponent:setFleet(var71_33, var72_33, var73_33)

		var0_33.MapAidSkills = {}

		if var68_33:IsSelf() then
			local var80_33, var81_33, var82_33 = var65_33.GetSupportValue()

			if var80_33 then
				table.insert(var0_33.MapAidSkills, {
					level = 1,
					id = var82_33
				})
			end
		end
	elseif var1_33 == SYSTEM_HP_SHARE_ACT_BOSS or var1_33 == SYSTEM_ACT_BOSS or var1_33 == SYSTEM_ACT_BOSS_SP or var1_33 == SYSTEM_BOSS_EXPERIMENT then
		if arg0_33.contextData.mainFleetId then
			local var83_33 = getProxy(FleetProxy):getActivityFleets()[arg0_33.contextData.actId]
			local var84_33 = var83_33[arg0_33.contextData.mainFleetId]
			local var85_33 = _.values(var84_33:getCommanders())

			var0_33.CommanderList = var84_33:buildBattleBuffList()
			arg0_33.mainShips = {}

			local var86_33 = {}
			local var87_33 = {}
			local var88_33 = {}

			local function var89_33(arg0_38, arg1_38, arg2_38, arg3_38)
				if table.contains(var5_33, arg0_38) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_33[#var5_33 + 1] = arg0_38

				local var0_38 = var4_33:getShipById(arg0_38)
				local var1_38 = var1_0(var1_33, var0_38, arg1_38)

				table.insert(arg0_33.mainShips, var0_38)
				table.insert(arg3_38, var0_38)
				table.insert(arg2_38, var1_38)
			end

			local var90_33 = var84_33:getTeamByName(TeamType.Main)
			local var91_33 = var84_33:getTeamByName(TeamType.Vanguard)

			for iter30_33, iter31_33 in ipairs(var90_33) do
				var89_33(iter31_33, var85_33, var0_33.MainUnitList, var86_33)
			end

			for iter32_33, iter33_33 in ipairs(var91_33) do
				var89_33(iter33_33, var85_33, var0_33.VanguardUnitList, var87_33)
			end

			local var92_33 = var83_33[arg0_33.contextData.mainFleetId + 10]
			local var93_33 = _.values(var92_33:getCommanders())
			local var94_33 = var92_33:getTeamByName(TeamType.Submarine)

			for iter34_33, iter35_33 in ipairs(var94_33) do
				var89_33(iter35_33, var93_33, var0_33.SubUnitList, var88_33)
			end

			local var95_33 = getProxy(PlayerProxy):getRawData()
			local var96_33 = getProxy(ActivityProxy):getActivityById(arg0_33.contextData.actId)
			local var97_33 = var96_33:getConfig("config_id")
			local var98_33 = pg.activity_event_worldboss[var97_33].use_oil_limit[arg0_33.contextData.mainFleetId]
			local var99_33 = var96_33:IsOilLimit(arg0_33.contextData.stageId)
			local var100_33 = 0
			local var101_33 = var3_33.oil_cost > 0

			local function var102_33(arg0_39, arg1_39)
				if var101_33 then
					local var0_39 = arg0_39:getEndCost().oil

					if arg1_39 > 0 then
						local var1_39 = arg0_39:getStartCost().oil

						cost = math.clamp(arg1_39 - var1_39, 0, var0_39)
					end

					var100_33 = var100_33 + var0_39
				end
			end

			if var1_33 == SYSTEM_ACT_BOSS_SP then
				local var103_33 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0_33.contextData.actId).buffIds
				local var104_33 = _.map(var103_33, function(arg0_40)
					return ActivityBossBuff.New({
						configId = arg0_40
					})
				end)

				var0_33.ExtraBuffList = _.map(_.select(var104_33, function(arg0_41)
					return arg0_41:CastOnEnemy()
				end), function(arg0_42)
					return arg0_42:GetBuffID()
				end)
				var0_33.ChapterBuffIDs = _.map(_.select(var104_33, function(arg0_43)
					return not arg0_43:CastOnEnemy()
				end), function(arg0_44)
					return arg0_44:GetBuffID()
				end)
			else
				var102_33(var84_33, var99_33 and var98_33[1] or 0)
				var102_33(var92_33, var99_33 and var98_33[2] or 0)
			end

			if var92_33:isLegalToFight() == true and (var1_33 == SYSTEM_BOSS_EXPERIMENT or var100_33 <= var95_33.oil) then
				var0_33.SubFlag = 1
				var0_33.TotalSubAmmo = 1
			end

			var0_33.SubCommanderList = var92_33:buildBattleBuffList()

			arg0_33.viewComponent:setFleet(var86_33, var87_33, var88_33)
		end
	elseif var1_33 == SYSTEM_GUILD then
		local var105_33 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
		local var106_33 = var105_33:GetMainFleet()
		local var107_33 = _.values(var106_33:getCommanders())

		var0_33.CommanderList = var106_33:BuildBattleBuffList()
		arg0_33.mainShips = {}

		local var108_33 = {}
		local var109_33 = {}
		local var110_33 = {}

		local function var111_33(arg0_45, arg1_45, arg2_45, arg3_45)
			local var0_45 = var1_0(var1_33, arg0_45, arg1_45)

			table.insert(arg0_33.mainShips, arg0_45)
			table.insert(arg3_45, arg0_45)
			table.insert(arg2_45, var0_45)
		end

		local var112_33 = {}
		local var113_33 = {}
		local var114_33 = var106_33:GetShips()

		for iter36_33, iter37_33 in pairs(var114_33) do
			local var115_33 = iter37_33.ship

			if var115_33:getTeamType() == TeamType.Main then
				table.insert(var112_33, var115_33)
			elseif var115_33:getTeamType() == TeamType.Vanguard then
				table.insert(var113_33, var115_33)
			end
		end

		for iter38_33, iter39_33 in ipairs(var112_33) do
			var111_33(iter39_33, var107_33, var0_33.MainUnitList, var108_33)
		end

		for iter40_33, iter41_33 in ipairs(var113_33) do
			var111_33(iter41_33, var107_33, var0_33.VanguardUnitList, var109_33)
		end

		local var116_33 = var105_33:GetSubFleet()
		local var117_33 = _.values(var116_33:getCommanders())
		local var118_33 = {}
		local var119_33 = var116_33:GetShips()

		for iter42_33, iter43_33 in pairs(var119_33) do
			local var120_33 = iter43_33.ship

			if var120_33:getTeamType() == TeamType.Submarine then
				table.insert(var118_33, var120_33)
			end
		end

		for iter44_33, iter45_33 in ipairs(var118_33) do
			var111_33(iter45_33, var117_33, var0_33.SubUnitList, var110_33)
		end

		if #var110_33 > 0 then
			var0_33.SubFlag = 1
			var0_33.TotalSubAmmo = 1
		end

		var0_33.SubCommanderList = var116_33:BuildBattleBuffList()

		arg0_33.viewComponent:setFleet(var108_33, var109_33, var110_33)
	elseif var1_33 == SYSTEM_BOSS_RUSH or var1_33 == SYSTEM_BOSS_RUSH_EX then
		local var121_33 = getProxy(ActivityProxy):getActivityById(arg0_33.contextData.actId):GetSeriesData()

		assert(var121_33)

		local var122_33 = var121_33:GetStaegLevel() + 1
		local var123_33 = var121_33:GetFleetIds()
		local var124_33 = var123_33[var122_33]
		local var125_33 = var123_33[#var123_33]

		if var121_33:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var124_33 = var123_33[1]
		end

		local var126_33 = getProxy(FleetProxy):getActivityFleets()[arg0_33.contextData.actId]

		arg0_33.mainShips = {}

		local var127_33 = {}
		local var128_33 = {}
		local var129_33 = {}

		local function var130_33(arg0_46, arg1_46, arg2_46, arg3_46)
			if table.contains(var5_33, arg0_46) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_33[#var5_33 + 1] = arg0_46

			local var0_46 = var4_33:getShipById(arg0_46)
			local var1_46 = var1_0(var1_33, var0_46, arg1_46)

			table.insert(arg0_33.mainShips, var0_46)
			table.insert(arg3_46, var0_46)
			table.insert(arg2_46, var1_46)
		end

		local var131_33 = var126_33[var124_33]
		local var132_33 = _.values(var131_33:getCommanders())

		var0_33.CommanderList = var131_33:buildBattleBuffList()

		local var133_33 = var131_33:getTeamByName(TeamType.Main)
		local var134_33 = var131_33:getTeamByName(TeamType.Vanguard)

		for iter46_33, iter47_33 in ipairs(var133_33) do
			var130_33(iter47_33, var132_33, var0_33.MainUnitList, var127_33)
		end

		for iter48_33, iter49_33 in ipairs(var134_33) do
			var130_33(iter49_33, var132_33, var0_33.VanguardUnitList, var128_33)
		end

		local var135_33 = var126_33[var125_33]
		local var136_33 = _.values(var135_33:getCommanders())

		var0_33.SubCommanderList = var135_33:buildBattleBuffList()

		local var137_33 = var135_33:getTeamByName(TeamType.Submarine)

		for iter50_33, iter51_33 in ipairs(var137_33) do
			var130_33(iter51_33, var136_33, var0_33.SubUnitList, var129_33)
		end

		local var138_33 = getProxy(PlayerProxy):getRawData()
		local var139_33 = 0
		local var140_33 = var121_33:GetOilLimit()
		local var141_33 = var3_33.oil_cost > 0

		local function var142_33(arg0_47, arg1_47)
			local var0_47 = 0

			if var141_33 then
				local var1_47 = arg0_47:getStartCost().oil
				local var2_47 = arg0_47:getEndCost().oil

				var0_47 = var2_47

				if arg1_47 > 0 then
					var0_47 = math.clamp(arg1_47 - var1_47, 0, var2_47)
				end
			end

			return var0_47
		end

		local var143_33 = var139_33 + var142_33(var131_33, var140_33[1]) + var142_33(var135_33, var140_33[2])

		if var135_33:isLegalToFight() == true and var143_33 <= var138_33.oil then
			var0_33.SubFlag = 1
			var0_33.TotalSubAmmo = 1
		end

		arg0_33.viewComponent:setFleet(var127_33, var128_33, var129_33)
	elseif var1_33 == SYSTEM_LIMIT_CHALLENGE then
		local var144_33 = LimitChallengeConst.GetChallengeIDByStageID(arg0_33.contextData.stageId)

		var0_33.ExtraBuffList = AcessWithinNull(pg.expedition_constellation_challenge_template[var144_33], "buff_id")

		local var145_33 = FleetProxy.CHALLENGE_FLEET_ID
		local var146_33 = FleetProxy.CHALLENGE_SUB_FLEET_ID
		local var147_33 = getProxy(FleetProxy)
		local var148_33 = var147_33:getFleetById(var145_33)
		local var149_33 = var147_33:getFleetById(var146_33)

		arg0_33.mainShips = {}

		local var150_33 = {}
		local var151_33 = {}
		local var152_33 = {}

		local function var153_33(arg0_48, arg1_48, arg2_48, arg3_48)
			if table.contains(var5_33, arg0_48) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_33[#var5_33 + 1] = arg0_48

			local var0_48 = var4_33:getShipById(arg0_48)
			local var1_48 = var1_0(var1_33, var0_48, arg1_48)

			table.insert(arg0_33.mainShips, var0_48)
			table.insert(arg3_48, var0_48)
			table.insert(arg2_48, var1_48)
		end

		local var154_33 = _.values(var148_33:getCommanders())

		var0_33.CommanderList = var148_33:buildBattleBuffList()

		local var155_33 = var148_33:getTeamByName(TeamType.Main)
		local var156_33 = var148_33:getTeamByName(TeamType.Vanguard)

		for iter52_33, iter53_33 in ipairs(var155_33) do
			var153_33(iter53_33, var154_33, var0_33.MainUnitList, var150_33)
		end

		for iter54_33, iter55_33 in ipairs(var156_33) do
			var153_33(iter55_33, var154_33, var0_33.VanguardUnitList, var151_33)
		end

		local var157_33 = _.values(var149_33:getCommanders())

		var0_33.SubCommanderList = var149_33:buildBattleBuffList()

		local var158_33 = var149_33:getTeamByName(TeamType.Submarine)

		for iter56_33, iter57_33 in ipairs(var158_33) do
			var153_33(iter57_33, var157_33, var0_33.SubUnitList, var152_33)
		end

		local var159_33 = getProxy(PlayerProxy):getRawData()
		local var160_33 = 0
		local var161_33 = var3_33.oil_cost > 0

		local function var162_33(arg0_49, arg1_49)
			local var0_49 = 0

			if var161_33 then
				local var1_49 = arg0_49:getStartCost().oil
				local var2_49 = arg0_49:getEndCost().oil

				var0_49 = var2_49

				if arg1_49 > 0 then
					var0_49 = math.clamp(arg1_49 - var1_49, 0, var2_49)
				end
			end

			return var0_49
		end

		local var163_33 = var160_33 + var162_33(var148_33, 0) + var162_33(var149_33, 0)

		if var149_33:isLegalToFight() == true and var163_33 <= var159_33.oil then
			var0_33.SubFlag = 1
			var0_33.TotalSubAmmo = 1
		end

		arg0_33.viewComponent:setFleet(var150_33, var151_33, var152_33)
	elseif var1_33 == SYSTEM_CARDPUZZLE then
		local var164_33 = {}
		local var165_33 = {}
		local var166_33 = arg0_33.contextData.relics

		for iter58_33, iter59_33 in ipairs(arg0_33.contextData.cardPuzzleFleet) do
			local var167_33 = var2_0(iter59_33, var166_33)
			local var168_33 = var167_33.fleetIndex

			if var168_33 == 1 then
				table.insert(var165_33, var167_33)
				table.insert(var0_33.VanguardUnitList, var167_33)
			elseif var168_33 == 2 then
				table.insert(var164_33, var167_33)
				table.insert(var0_33.MainUnitList, var167_33)
			end
		end

		var0_33.CardPuzzleCardIDList = arg0_33.contextData.cards
		var0_33.CardPuzzleCommonHPValue = arg0_33.contextData.hp
		var0_33.CardPuzzleRelicList = var166_33
		var0_33.CardPuzzleCombatID = arg0_33.contextData.puzzleCombatID
	elseif var1_33 == SYSTEM_BOSS_SINGLE then
		if arg0_33.contextData.mainFleetId then
			local var169_33 = getProxy(FleetProxy):getActivityFleets()[arg0_33.contextData.actId]
			local var170_33 = var169_33[arg0_33.contextData.mainFleetId]
			local var171_33 = _.values(var170_33:getCommanders())

			var0_33.CommanderList = var170_33:buildBattleBuffList()
			arg0_33.mainShips = {}

			local var172_33 = {}
			local var173_33 = {}
			local var174_33 = {}

			local function var175_33(arg0_50, arg1_50, arg2_50, arg3_50)
				if table.contains(var5_33, arg0_50) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_33[#var5_33 + 1] = arg0_50

				local var0_50 = var4_33:getShipById(arg0_50)
				local var1_50 = var1_0(var1_33, var0_50, arg1_50)

				table.insert(arg0_33.mainShips, var0_50)
				table.insert(arg3_50, var0_50)
				table.insert(arg2_50, var1_50)
			end

			local var176_33 = var170_33:getTeamByName(TeamType.Main)
			local var177_33 = var170_33:getTeamByName(TeamType.Vanguard)

			for iter60_33, iter61_33 in ipairs(var176_33) do
				var175_33(iter61_33, var171_33, var0_33.MainUnitList, var172_33)
			end

			for iter62_33, iter63_33 in ipairs(var177_33) do
				var175_33(iter63_33, var171_33, var0_33.VanguardUnitList, var173_33)
			end

			local var178_33 = var169_33[arg0_33.contextData.mainFleetId + 10]
			local var179_33 = _.values(var178_33:getCommanders())
			local var180_33 = var178_33:getTeamByName(TeamType.Submarine)

			for iter64_33, iter65_33 in ipairs(var180_33) do
				var175_33(iter65_33, var179_33, var0_33.SubUnitList, var174_33)
			end

			local var181_33 = getProxy(PlayerProxy):getRawData()
			local var182_33 = getProxy(ActivityProxy):getActivityById(arg0_33.contextData.actId)

			var0_33.ChapterBuffIDs = var182_33:GetBuffIdsByStageId(arg0_33.contextData.stageId)

			local var183_33 = var182_33:GetEnemyDataByStageId(arg0_33.contextData.stageId):GetOilLimit()
			local var184_33 = 0
			local var185_33 = var3_33.oil_cost > 0

			local function var186_33(arg0_51, arg1_51)
				if var185_33 then
					local var0_51 = arg0_51:getEndCost().oil

					if arg1_51 > 0 then
						local var1_51 = arg0_51:getStartCost().oil

						cost = math.clamp(arg1_51 - var1_51, 0, var0_51)
					end

					var184_33 = var184_33 + var0_51
				end
			end

			var186_33(var170_33, var183_33[1] or 0)
			var186_33(var178_33, var183_33[2] or 0)

			if var178_33:isLegalToFight() == true and var184_33 <= var181_33.oil then
				var0_33.SubFlag = 1
				var0_33.TotalSubAmmo = 1
			end

			var0_33.SubCommanderList = var178_33:buildBattleBuffList()

			arg0_33.viewComponent:setFleet(var172_33, var173_33, var174_33)
		end
	elseif arg0_33.contextData.mainFleetId then
		local var187_33 = var1_33 == SYSTEM_DUEL
		local var188_33 = getProxy(FleetProxy)
		local var189_33
		local var190_33
		local var191_33 = var188_33:getFleetById(arg0_33.contextData.mainFleetId)

		arg0_33.mainShips = var4_33:getShipsByFleet(var191_33)

		local var192_33 = {}
		local var193_33 = {}
		local var194_33 = {}

		local function var195_33(arg0_52, arg1_52, arg2_52)
			for iter0_52, iter1_52 in ipairs(arg0_52) do
				if table.contains(var5_33, iter1_52) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_33[#var5_33 + 1] = iter1_52

				local var0_52 = var4_33:getShipById(iter1_52)
				local var1_52 = var1_0(var1_33, var0_52, nil, var187_33)

				table.insert(arg1_52, var0_52)
				table.insert(arg2_52, var1_52)
			end
		end

		local var196_33 = var191_33:getTeamByName(TeamType.Main)
		local var197_33 = var191_33:getTeamByName(TeamType.Vanguard)
		local var198_33 = var191_33:getTeamByName(TeamType.Submarine)

		var195_33(var196_33, var192_33, var0_33.MainUnitList)
		var195_33(var197_33, var193_33, var0_33.VanguardUnitList)
		var195_33(var198_33, var194_33, var0_33.SubUnitList)
		arg0_33.viewComponent:setFleet(var192_33, var193_33, var194_33)

		if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
			local var199_33 = var188_33:getFleetById(11)
			local var200_33 = var199_33:getTeamByName(TeamType.Submarine)

			if #var200_33 > 0 then
				var0_33.SubFlag = 1
				var0_33.TotalSubAmmo = 1

				local var201_33 = _.values(var199_33:getCommanders())

				var0_33.SubCommanderList = var199_33:buildBattleBuffList()

				for iter66_33, iter67_33 in ipairs(var200_33) do
					local var202_33 = var4_33:getShipById(iter67_33)
					local var203_33 = var1_0(var1_33, var202_33, var201_33, var187_33)

					table.insert(var194_33, var202_33)
					table.insert(var0_33.SubUnitList, var203_33)
				end
			end
		end
	end

	if var1_33 == SYSTEM_WORLD then
		local var204_33 = nowWorld()
		local var205_33 = var204_33:GetActiveMap()
		local var206_33 = var205_33:GetFleet()
		local var207_33 = var205_33:GetCell(var206_33.row, var206_33.column):GetStageEnemy()
		local var208_33 = pg.world_expedition_data[arg0_33.contextData.stageId]
		local var209_33 = var204_33:GetWorldMapDifficultyBuffLevel()

		var0_33.EnemyMapRewards = {
			var209_33[1] * (1 + var208_33.expedition_sairenvalueA / 10000),
			var209_33[2] * (1 + var208_33.expedition_sairenvalueB / 10000),
			var209_33[3] * (1 + var208_33.expedition_sairenvalueC / 10000)
		}
		var0_33.FleetMapRewards = var204_33:GetWorldMapBuffLevel()
	end

	var0_33.RivalMainUnitList, var0_33.RivalVanguardUnitList = {}, {}

	local var210_33

	if var1_33 == SYSTEM_DUEL and arg0_33.contextData.rivalId then
		local var211_33 = getProxy(MilitaryExerciseProxy)

		var210_33 = var211_33:getRivalById(arg0_33.contextData.rivalId)
		arg0_33.oldRank = var211_33:getSeasonInfo()
	end

	if var210_33 then
		var0_33.RivalVO = var210_33

		local var212_33 = 0

		for iter68_33, iter69_33 in ipairs(var210_33.mainShips) do
			var212_33 = var212_33 + iter69_33.level
		end

		for iter70_33, iter71_33 in ipairs(var210_33.vanguardShips) do
			var212_33 = var212_33 + iter71_33.level
		end

		BattleVertify = BattleVertify or {}
		BattleVertify.rivalLevel = var212_33

		for iter72_33, iter73_33 in ipairs(var210_33.mainShips) do
			if not iter73_33.hpRant or iter73_33.hpRant > 0 then
				local var213_33 = var1_0(var1_33, iter73_33, nil, true)

				if iter73_33.hpRant then
					var213_33.initHPRate = iter73_33.hpRant * 0.0001
				end

				table.insert(var0_33.RivalMainUnitList, var213_33)
			end
		end

		for iter74_33, iter75_33 in ipairs(var210_33.vanguardShips) do
			if not iter75_33.hpRant or iter75_33.hpRant > 0 then
				local var214_33 = var1_0(var1_33, iter75_33, nil, true)

				if iter75_33.hpRant then
					var214_33.initHPRate = iter75_33.hpRant * 0.0001
				end

				table.insert(var0_33.RivalVanguardUnitList, var214_33)
			end
		end
	end

	local var215_33 = arg0_33.contextData.prefabFleet.main_unitList
	local var216_33 = arg0_33.contextData.prefabFleet.vanguard_unitList
	local var217_33 = arg0_33.contextData.prefabFleet.submarine_unitList

	if var215_33 then
		for iter76_33, iter77_33 in ipairs(var215_33) do
			local var218_33 = {}

			for iter78_33, iter79_33 in ipairs(iter77_33.equipment) do
				var218_33[#var218_33 + 1] = {
					skin = 0,
					id = iter79_33
				}
			end

			local var219_33 = {
				id = iter77_33.id,
				tmpID = iter77_33.configId,
				skinId = iter77_33.skinId,
				level = iter77_33.level,
				equipment = var218_33,
				properties = iter77_33.properties,
				baseProperties = iter77_33.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter77_33.skills
			}

			table.insert(var0_33.MainUnitList, var219_33)
		end
	end

	if var216_33 then
		for iter80_33, iter81_33 in ipairs(var216_33) do
			local var220_33 = {}

			for iter82_33, iter83_33 in ipairs(iter81_33.equipment) do
				var220_33[#var220_33 + 1] = {
					skin = 0,
					id = iter83_33
				}
			end

			local var221_33 = {
				id = iter81_33.id,
				tmpID = iter81_33.configId,
				skinId = iter81_33.skinId,
				level = iter81_33.level,
				equipment = var220_33,
				properties = iter81_33.properties,
				baseProperties = iter81_33.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter81_33.skills
			}

			table.insert(var0_33.VanguardUnitList, var221_33)
		end
	end

	if var217_33 then
		for iter84_33, iter85_33 in ipairs(var217_33) do
			local var222_33 = {}

			for iter86_33, iter87_33 in ipairs(iter85_33.equipment) do
				var222_33[#var222_33 + 1] = {
					skin = 0,
					id = iter87_33
				}
			end

			local var223_33 = {
				id = iter85_33.id,
				tmpID = iter85_33.configId,
				skinId = iter85_33.skinId,
				level = iter85_33.level,
				equipment = var222_33,
				properties = iter85_33.properties,
				baseProperties = iter85_33.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter85_33.skills
			}

			table.insert(var0_33.SubUnitList, var223_33)

			if var1_33 == SYSTEM_SIMULATION and #var0_33.SubUnitList > 0 then
				var0_33.SubFlag = 1
				var0_33.TotalSubAmmo = 1
			end
		end
	end
end

function var0_0.listNotificationInterests(arg0_53)
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
		var0_0.HIDE_ALL_BUTTONS
	}
end

function var0_0.handleNotification(arg0_54, arg1_54)
	local var0_54 = arg1_54:getName()
	local var1_54 = arg1_54:getBody()
	local var2_54 = ys.Battle.BattleState.GetInstance()
	local var3_54 = arg0_54.contextData.system

	if var0_54 == GAME.FINISH_STAGE_DONE then
		pg.MsgboxMgr.GetInstance():hide()

		local var4_54 = var1_54.system

		if var4_54 == SYSTEM_PROLOGUE then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_54:sendNotification(GAME.CHANGE_SCENE, SCENE.CREATE_PLAYER)
		elseif var4_54 == SYSTEM_PERFORM or var4_54 == SYSTEM_SIMULATION then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_54.viewComponent:exitBattle()

			if var1_54.exitCallback then
				var1_54.exitCallback()
			end
		else
			local var5_54 = BattleResultMediator.GetResultView(var4_54)
			local var6_54 = {}

			if var4_54 == SYSTEM_SCENARIO then
				var6_54 = getProxy(ChapterProxy):getActiveChapter().operationBuffList
			end

			arg0_54:addSubLayers(Context.New({
				mediator = NewBattleResultMediator,
				viewComponent = NewBattleResultScene,
				data = {
					system = var4_54,
					rivalId = arg0_54.contextData.rivalId,
					mainFleetId = arg0_54.contextData.mainFleetId,
					stageId = arg0_54.contextData.stageId,
					oldMainShips = arg0_54.mainShips or {},
					oldPlayer = arg0_54.player,
					oldRank = arg0_54.oldRank,
					statistics = var1_54.statistics,
					score = var1_54.score,
					drops = var1_54.drops,
					bossId = var1_54.bossId,
					name = var1_54.name,
					prefabFleet = var1_54.prefabFleet,
					commanderExps = var1_54.commanderExps,
					actId = arg0_54.contextData.actId,
					result = var1_54.result,
					extraDrops = var1_54.extraDrops,
					extraBuffList = var6_54,
					isLastBonus = var1_54.isLastBonus,
					continuousBattleTimes = arg0_54.contextData.continuousBattleTimes,
					totalBattleTimes = arg0_54.contextData.totalBattleTimes,
					mode = arg0_54.contextData.mode,
					cmdArgs = arg0_54.contextData.cmdArgs
				}
			}))
		end
	elseif var0_54 == GAME.STORY_BEGIN then
		var2_54:Pause()
	elseif var0_54 == GAME.STORY_END then
		var2_54:Resume()
	elseif var0_54 == GAME.START_GUIDE then
		var2_54:Pause()
	elseif var0_54 == GAME.END_GUIDE then
		var2_54:Resume()
	elseif var0_54 == GAME.PAUSE_BATTLE then
		if not var2_54:IsPause() then
			arg0_54:onPauseBtn()
		end
	elseif var0_54 == GAME.RESUME_BATTLE then
		var2_54:Resume()
	elseif var0_54 == GAME.FINISH_STAGE_ERROR then
		gcAll(true)

		local var7_54 = getProxy(ContextProxy)
		local var8_54 = var7_54:getContextByMediator(DailyLevelMediator)
		local var9_54 = var7_54:getContextByMediator(LevelMediator2)
		local var10_54 = var7_54:getContextByMediator(ChallengeMainMediator)
		local var11_54 = var7_54:getContextByMediator(ActivityBossMediatorTemplate)

		if var8_54 then
			local var12_54 = var8_54:getContextByMediator(PreCombatMediator)

			var8_54:removeChild(var12_54)
		elseif var10_54 then
			local var13_54 = var10_54:getContextByMediator(ChallengePreCombatMediator)

			var10_54:removeChild(var13_54)
		elseif var9_54 then
			if var3_54 == SYSTEM_DUEL then
				-- block empty
			elseif var3_54 == SYSTEM_SCENARIO then
				local var14_54 = var9_54:getContextByMediator(ChapterPreCombatMediator)

				var9_54:removeChild(var14_54)
			elseif var3_54 ~= SYSTEM_PERFORM and var3_54 ~= SYSTEM_SIMULATION then
				local var15_54 = var9_54:getContextByMediator(PreCombatMediator)

				if var15_54 then
					var9_54:removeChild(var15_54)
				end
			end
		elseif var11_54 then
			local var16_54 = var11_54:getContextByMediator(PreCombatMediator)

			if var16_54 then
				var11_54:removeChild(var16_54)
			end
		end

		arg0_54:sendNotification(GAME.GO_BACK)
	elseif var0_54 == var0_0.CLOSE_CHAT then
		arg0_54.viewComponent:OnCloseChat()
	elseif var0_54 == var0_0.HIDE_ALL_BUTTONS then
		ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name):DispatchEvent(ys.Event.New(ys.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
			isActive = var1_54
		}))
	elseif var0_54 == GAME.QUIT_BATTLE then
		var2_54:Stop()
	end
end

function var0_0.remove(arg0_55)
	pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)
end

return var0_0
