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

		var0_35.GlobalBuffIDs = _.map(var2_35, function(arg0_36)
			return arg0_36:getConfig("benefit_effect")
		end) or {}
	end

	local var3_35 = pg.battle_cost_template[var1_35]
	local var4_35 = getProxy(BayProxy)
	local var5_35 = {}

	if var1_35 == SYSTEM_SCENARIO then
		local var6_35 = getProxy(ChapterProxy)
		local var7_35 = var6_35:getActiveChapter()

		var0_35.RepressInfo = var7_35:getRepressInfo()

		arg0_35.viewComponent:setChapter(var7_35)

		local var8_35 = var7_35.fleet

		var0_35.KizunaJamming = var7_35.extraFlagList
		var0_35.DefeatCount = var8_35:getDefeatCount()
		var0_35.ChapterBuffIDs, var0_35.CommanderList = var7_35:getFleetBattleBuffs(var8_35)
		var0_35.StageWaveFlags = var7_35:GetStageFlags()
		var0_35.ChapterWeatherIDS = var7_35:GetWeather(var8_35.line.row, var8_35.line.column)
		var0_35.MapAuraSkills = var6_35.GetChapterAuraBuffs(var7_35)
		var0_35.MapAidSkills = {}

		local var9_35 = var6_35.GetChapterAidBuffs(var7_35)

		for iter0_35, iter1_35 in pairs(var9_35) do
			local var10_35 = var7_35:getFleetByShipVO(iter0_35)
			local var11_35 = _.values(var10_35:getCommanders())
			local var12_35 = var1_0(var1_35, iter0_35, var11_35)

			table.insert(var0_35.AidUnitList, var12_35)

			for iter2_35, iter3_35 in ipairs(iter1_35) do
				table.insert(var0_35.MapAidSkills, iter3_35)
			end
		end

		local var13_35 = var8_35:getShipsByTeam(TeamType.Main, false)
		local var14_35 = var8_35:getShipsByTeam(TeamType.Vanguard, false)
		local var15_35 = {}
		local var16_35 = _.values(var8_35:getCommanders())
		local var17_35 = {}
		local var18_35, var19_35 = var6_35.getSubAidFlag(var7_35, arg0_35.contextData.stageId)

		if var18_35 == true or var18_35 > 0 then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
			var15_35 = var19_35:getShipsByTeam(TeamType.Submarine, false)
			var17_35 = _.values(var19_35:getCommanders())

			local var20_35, var21_35 = var7_35:getFleetBattleBuffs(var19_35)

			var0_35.SubCommanderList = var21_35
		else
			var0_35.SubFlag = var18_35

			if var18_35 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_35.TotalSubAmmo = 0
			end
		end

		arg0_35.mainShips = {}

		local function var22_35(arg0_37, arg1_37, arg2_37)
			local var0_37 = arg0_37.id
			local var1_37 = arg0_37.hpRant * 0.0001

			if table.contains(var5_35, var0_37) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_35[#var5_35 + 1] = var0_37

			local var2_37 = var1_0(var1_35, arg0_37, arg1_37)

			var2_37.initHPRate = var1_37

			table.insert(arg0_35.mainShips, arg0_37)
			table.insert(arg2_37, var2_37)
		end

		for iter4_35, iter5_35 in ipairs(var13_35) do
			var22_35(iter5_35, var16_35, var0_35.MainUnitList)
		end

		for iter6_35, iter7_35 in ipairs(var14_35) do
			var22_35(iter7_35, var16_35, var0_35.VanguardUnitList)
		end

		for iter8_35, iter9_35 in ipairs(var15_35) do
			var22_35(iter9_35, var17_35, var0_35.SubUnitList)
		end

		local var23_35 = var7_35:getChapterSupportFleet()

		if var23_35 then
			local var24_35 = var23_35:getShips()

			for iter10_35, iter11_35 in pairs(var24_35) do
				var22_35(iter11_35, {}, var0_35.SupportUnitList)
			end
		end

		arg0_35.viewComponent:setFleet(var13_35, var14_35, var15_35)
	elseif var1_35 == SYSTEM_CHALLENGE then
		local var25_35 = arg0_35.contextData.mode
		local var26_35 = getProxy(ChallengeProxy):getUserChallengeInfo(var25_35)

		var0_35.ChallengeInfo = var26_35

		arg0_35.viewComponent:setChapter(var26_35)

		local var27_35 = var26_35:getRegularFleet()

		var0_35.CommanderList = var27_35:buildBattleBuffList()

		local var28_35 = _.values(var27_35:getCommanders())
		local var29_35 = {}
		local var30_35 = var27_35:getShipsByTeam(TeamType.Main, false)
		local var31_35 = var27_35:getShipsByTeam(TeamType.Vanguard, false)
		local var32_35 = {}
		local var33_35 = var26_35:getSubmarineFleet()
		local var34_35 = var33_35:getShipsByTeam(TeamType.Submarine, false)

		if #var34_35 > 0 then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
			var29_35 = _.values(var33_35:getCommanders())
			var0_35.SubCommanderList = var33_35:buildBattleBuffList()
		else
			var0_35.SubFlag = 0
			var0_35.TotalSubAmmo = 0
		end

		arg0_35.mainShips = {}

		local function var35_35(arg0_38, arg1_38, arg2_38)
			local var0_38 = arg0_38.id
			local var1_38 = arg0_38.hpRant * 0.0001

			if table.contains(var5_35, var0_38) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_35[#var5_35 + 1] = var0_38

			local var2_38 = var1_0(var1_35, arg0_38, arg1_38)

			var2_38.initHPRate = var1_38

			table.insert(arg0_35.mainShips, arg0_38)
			table.insert(arg2_38, var2_38)
		end

		for iter12_35, iter13_35 in ipairs(var30_35) do
			var35_35(iter13_35, var28_35, var0_35.MainUnitList)
		end

		for iter14_35, iter15_35 in ipairs(var31_35) do
			var35_35(iter15_35, var28_35, var0_35.VanguardUnitList)
		end

		for iter16_35, iter17_35 in ipairs(var34_35) do
			var35_35(iter17_35, var29_35, var0_35.SubUnitList)
		end

		arg0_35.viewComponent:setFleet(var30_35, var31_35, var34_35)
	elseif var1_35 == SYSTEM_WORLD then
		local var36_35 = nowWorld()
		local var37_35 = var36_35:GetActiveMap()
		local var38_35 = var37_35:GetFleet()
		local var39_35 = var37_35:GetCell(var38_35.row, var38_35.column):GetStageEnemy()

		if arg0_35.contextData.hpRate then
			var0_35.RepressInfo = {
				repressEnemyHpRant = arg0_35.contextData.hpRate
			}
		end

		var0_35.AffixBuffList = table.mergeArray(var39_35:GetBattleLuaBuffs(), var37_35:GetBattleLuaBuffs(WorldMap.FactionEnemy, var39_35))

		local function var40_35(arg0_39)
			local var0_39 = {}

			for iter0_39, iter1_39 in ipairs(arg0_39) do
				local var1_39 = {
					id = ys.Battle.BattleDataFunction.SkillTranform(var1_35, iter1_39.id),
					level = iter1_39.level
				}

				table.insert(var0_39, var1_39)
			end

			return var0_39
		end

		var0_35.DefeatCount = var38_35:getDefeatCount()
		var0_35.ChapterBuffIDs, var0_35.CommanderList = var37_35:getFleetBattleBuffs(var38_35, true)
		var0_35.MapAuraSkills = var37_35:GetChapterAuraBuffs()
		var0_35.MapAuraSkills = var40_35(var0_35.MapAuraSkills)
		var0_35.MapAidSkills = {}

		local var41_35 = var37_35:GetChapterAidBuffs()

		for iter18_35, iter19_35 in pairs(var41_35) do
			local var42_35 = var37_35:GetFleet(iter18_35.fleetId)
			local var43_35 = _.values(var42_35:getCommanders(true))
			local var44_35 = var1_0(var1_35, WorldConst.FetchShipVO(iter18_35.id), var43_35)

			table.insert(var0_35.AidUnitList, var44_35)

			var0_35.MapAidSkills = table.mergeArray(var0_35.MapAidSkills, var40_35(iter19_35))
		end

		local var45_35 = var38_35:GetTeamShipVOs(TeamType.Main, false)
		local var46_35 = var38_35:GetTeamShipVOs(TeamType.Vanguard, false)
		local var47_35 = {}
		local var48_35 = _.values(var38_35:getCommanders(true))
		local var49_35 = {}
		local var50_35 = var36_35:GetSubAidFlag()

		if var50_35 == true then
			local var51_35 = var37_35:GetSubmarineFleet()

			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
			var47_35 = var51_35:GetTeamShipVOs(TeamType.Submarine, false)
			var49_35 = _.values(var51_35:getCommanders(true))

			local var52_35, var53_35 = var37_35:getFleetBattleBuffs(var51_35, true)

			var0_35.SubCommanderList = var53_35
		else
			var0_35.SubFlag = 0

			if var50_35 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0_35.TotalSubAmmo = 0
			end
		end

		arg0_35.mainShips = {}

		for iter20_35, iter21_35 in ipairs(var45_35) do
			local var54_35 = iter21_35.id
			local var55_35 = WorldConst.FetchWorldShip(iter21_35.id).hpRant * 0.0001

			if table.contains(var5_35, var54_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_35[#var5_35 + 1] = var54_35

			local var56_35 = var1_0(var1_35, iter21_35, var48_35)

			var56_35.initHPRate = var55_35

			table.insert(arg0_35.mainShips, iter21_35)
			table.insert(var0_35.MainUnitList, var56_35)
		end

		for iter22_35, iter23_35 in ipairs(var46_35) do
			local var57_35 = iter23_35.id
			local var58_35 = WorldConst.FetchWorldShip(iter23_35.id).hpRant * 0.0001

			if table.contains(var5_35, var57_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_35[#var5_35 + 1] = var57_35

			local var59_35 = var1_0(var1_35, iter23_35, var48_35)

			var59_35.initHPRate = var58_35

			table.insert(arg0_35.mainShips, iter23_35)
			table.insert(var0_35.VanguardUnitList, var59_35)
		end

		for iter24_35, iter25_35 in ipairs(var47_35) do
			local var60_35 = iter25_35.id
			local var61_35 = WorldConst.FetchWorldShip(iter25_35.id).hpRant * 0.0001

			if table.contains(var5_35, var60_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_35[#var5_35 + 1] = var60_35

			local var62_35 = var1_0(var1_35, iter25_35, var49_35)

			var62_35.initHPRate = var61_35

			table.insert(arg0_35.mainShips, iter25_35)
			table.insert(var0_35.SubUnitList, var62_35)
		end

		arg0_35.viewComponent:setFleet(var45_35, var46_35, var47_35)

		local var63_35 = pg.expedition_data_template[arg0_35.contextData.stageId]

		if var63_35.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
			var0_35.WorldMapId = var37_35.config.expedition_map_id
			var0_35.WorldLevel = WorldConst.WorldLevelCorrect(var37_35.config.expedition_level, var63_35.type)
		end
	elseif var1_35 == SYSTEM_WORLD_BOSS then
		local var64_35 = nowWorld():GetBossProxy()
		local var65_35 = arg0_35.contextData.bossId
		local var66_35 = var64_35:GetFleet(var65_35)
		local var67_35 = var64_35:GetBossById(var65_35)

		assert(var67_35, var65_35)

		if arg0_35.contextData.hpRate then
			var0_35.RepressInfo = {
				repressEnemyHpRant = arg0_35.contextData.hpRate
			}
		end

		local var68_35 = _.values(var66_35:getCommanders())

		var0_35.CommanderList = var66_35:buildBattleBuffList()
		arg0_35.mainShips = var4_35:getShipsByFleet(var66_35)

		local var69_35 = {}
		local var70_35 = {}
		local var71_35 = {}
		local var72_35 = var66_35:getTeamByName(TeamType.Main)

		for iter26_35, iter27_35 in ipairs(var72_35) do
			if table.contains(var5_35, iter27_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_35[#var5_35 + 1] = iter27_35

			local var73_35 = var4_35:getShipById(iter27_35)
			local var74_35 = var1_0(var1_35, var73_35, var68_35)

			table.insert(var69_35, var73_35)
			table.insert(var0_35.MainUnitList, var74_35)
		end

		local var75_35 = var66_35:getTeamByName(TeamType.Vanguard)

		for iter28_35, iter29_35 in ipairs(var75_35) do
			if table.contains(var5_35, iter29_35) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_35[#var5_35 + 1] = iter29_35

			local var76_35 = var4_35:getShipById(iter29_35)
			local var77_35 = var1_0(var1_35, var76_35, var68_35)

			table.insert(var70_35, var76_35)
			table.insert(var0_35.VanguardUnitList, var77_35)
		end

		arg0_35.viewComponent:setFleet(var69_35, var70_35, var71_35)

		var0_35.MapAidSkills = {}

		if var67_35:IsSelf() then
			local var78_35, var79_35, var80_35 = var64_35.GetSupportValue()

			if var78_35 then
				table.insert(var0_35.MapAidSkills, {
					level = 1,
					id = var80_35
				})
			end
		end
	elseif var1_35 == SYSTEM_HP_SHARE_ACT_BOSS or var1_35 == SYSTEM_ACT_BOSS or var1_35 == SYSTEM_ACT_BOSS_SP or var1_35 == SYSTEM_BOSS_EXPERIMENT then
		if arg0_35.contextData.mainFleetId then
			local var81_35 = getProxy(FleetProxy):getActivityFleets()[arg0_35.contextData.actId]
			local var82_35 = var81_35[arg0_35.contextData.mainFleetId]
			local var83_35 = _.values(var82_35:getCommanders())

			var0_35.CommanderList = var82_35:buildBattleBuffList()
			arg0_35.mainShips = {}

			local var84_35 = {}
			local var85_35 = {}
			local var86_35 = {}

			local function var87_35(arg0_40, arg1_40, arg2_40, arg3_40)
				if table.contains(var5_35, arg0_40) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_35[#var5_35 + 1] = arg0_40

				local var0_40 = var4_35:getShipById(arg0_40)
				local var1_40 = var1_0(var1_35, var0_40, arg1_40)

				table.insert(arg0_35.mainShips, var0_40)
				table.insert(arg3_40, var0_40)
				table.insert(arg2_40, var1_40)
			end

			local var88_35 = var82_35:getTeamByName(TeamType.Main)
			local var89_35 = var82_35:getTeamByName(TeamType.Vanguard)

			for iter30_35, iter31_35 in ipairs(var88_35) do
				var87_35(iter31_35, var83_35, var0_35.MainUnitList, var84_35)
			end

			for iter32_35, iter33_35 in ipairs(var89_35) do
				var87_35(iter33_35, var83_35, var0_35.VanguardUnitList, var85_35)
			end

			local var90_35 = var81_35[arg0_35.contextData.mainFleetId + 10]
			local var91_35 = _.values(var90_35:getCommanders())
			local var92_35 = var90_35:getTeamByName(TeamType.Submarine)

			for iter34_35, iter35_35 in ipairs(var92_35) do
				var87_35(iter35_35, var91_35, var0_35.SubUnitList, var86_35)
			end

			local var93_35 = getProxy(PlayerProxy):getRawData()
			local var94_35 = getProxy(ActivityProxy):getActivityById(arg0_35.contextData.actId)
			local var95_35 = var94_35:getConfig("config_id")
			local var96_35 = pg.activity_event_worldboss[var95_35].use_oil_limit[arg0_35.contextData.mainFleetId]
			local var97_35 = var94_35:IsOilLimit(arg0_35.contextData.stageId)
			local var98_35 = 0
			local var99_35 = var3_35.oil_cost > 0

			local function var100_35(arg0_41, arg1_41)
				if var99_35 then
					local var0_41 = arg0_41:getEndCost().oil

					if arg1_41 > 0 then
						local var1_41 = arg0_41:getStartCost().oil

						cost = math.clamp(arg1_41 - var1_41, 0, var0_41)
					end

					var98_35 = var98_35 + var0_41
				end
			end

			if var1_35 == SYSTEM_ACT_BOSS_SP then
				local var101_35 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0_35.contextData.actId).buffIds
				local var102_35 = _.map(var101_35, function(arg0_42)
					return ActivityBossBuff.New({
						configId = arg0_42
					})
				end)

				var0_35.ExtraBuffList = _.map(_.select(var102_35, function(arg0_43)
					return arg0_43:CastOnEnemy()
				end), function(arg0_44)
					return arg0_44:GetBuffID()
				end)
				var0_35.ChapterBuffIDs = _.map(_.select(var102_35, function(arg0_45)
					return not arg0_45:CastOnEnemy()
				end), function(arg0_46)
					return arg0_46:GetBuffID()
				end)
			else
				var100_35(var82_35, var97_35 and var96_35[1] or 0)
				var100_35(var90_35, var97_35 and var96_35[2] or 0)
			end

			if var90_35:isLegalToFight() == true and (var1_35 == SYSTEM_BOSS_EXPERIMENT or var98_35 <= var93_35.oil) then
				var0_35.SubFlag = 1
				var0_35.TotalSubAmmo = 1
			end

			var0_35.SubCommanderList = var90_35:buildBattleBuffList()

			arg0_35.viewComponent:setFleet(var84_35, var85_35, var86_35)
		end
	elseif var1_35 == SYSTEM_GUILD then
		local var103_35 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
		local var104_35 = var103_35:GetMainFleet()
		local var105_35 = _.values(var104_35:getCommanders())

		var0_35.CommanderList = var104_35:BuildBattleBuffList()
		arg0_35.mainShips = {}

		local var106_35 = {}
		local var107_35 = {}
		local var108_35 = {}

		local function var109_35(arg0_47, arg1_47, arg2_47, arg3_47)
			local var0_47 = var1_0(var1_35, arg0_47, arg1_47)

			table.insert(arg0_35.mainShips, arg0_47)
			table.insert(arg3_47, arg0_47)
			table.insert(arg2_47, var0_47)
		end

		local var110_35 = {}
		local var111_35 = {}
		local var112_35 = var104_35:GetShips()

		for iter36_35, iter37_35 in pairs(var112_35) do
			local var113_35 = iter37_35.ship

			if var113_35:getTeamType() == TeamType.Main then
				table.insert(var110_35, var113_35)
			elseif var113_35:getTeamType() == TeamType.Vanguard then
				table.insert(var111_35, var113_35)
			end
		end

		for iter38_35, iter39_35 in ipairs(var110_35) do
			var109_35(iter39_35, var105_35, var0_35.MainUnitList, var106_35)
		end

		for iter40_35, iter41_35 in ipairs(var111_35) do
			var109_35(iter41_35, var105_35, var0_35.VanguardUnitList, var107_35)
		end

		local var114_35 = var103_35:GetSubFleet()
		local var115_35 = _.values(var114_35:getCommanders())
		local var116_35 = {}
		local var117_35 = var114_35:GetShips()

		for iter42_35, iter43_35 in pairs(var117_35) do
			local var118_35 = iter43_35.ship

			if var118_35:getTeamType() == TeamType.Submarine then
				table.insert(var116_35, var118_35)
			end
		end

		for iter44_35, iter45_35 in ipairs(var116_35) do
			var109_35(iter45_35, var115_35, var0_35.SubUnitList, var108_35)
		end

		if #var108_35 > 0 then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
		end

		var0_35.SubCommanderList = var114_35:BuildBattleBuffList()

		arg0_35.viewComponent:setFleet(var106_35, var107_35, var108_35)
	elseif var1_35 == SYSTEM_BOSS_RUSH or var1_35 == SYSTEM_BOSS_RUSH_EX then
		local var119_35 = getProxy(ActivityProxy):getActivityById(arg0_35.contextData.actId):GetSeriesData()

		assert(var119_35)

		local var120_35 = var119_35:GetStaegLevel() + 1
		local var121_35 = var119_35:GetFleetIds()
		local var122_35 = var121_35[var120_35]
		local var123_35 = var121_35[#var121_35]

		if var119_35:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var122_35 = var121_35[1]
		end

		local var124_35 = getProxy(FleetProxy):getActivityFleets()[arg0_35.contextData.actId]

		arg0_35.mainShips = {}

		local var125_35 = {}
		local var126_35 = {}
		local var127_35 = {}

		local function var128_35(arg0_48, arg1_48, arg2_48, arg3_48)
			if table.contains(var5_35, arg0_48) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_35[#var5_35 + 1] = arg0_48

			local var0_48 = var4_35:getShipById(arg0_48)
			local var1_48 = var1_0(var1_35, var0_48, arg1_48)

			table.insert(arg0_35.mainShips, var0_48)
			table.insert(arg3_48, var0_48)
			table.insert(arg2_48, var1_48)
		end

		local var129_35 = var124_35[var122_35]
		local var130_35 = _.values(var129_35:getCommanders())

		var0_35.CommanderList = var129_35:buildBattleBuffList()

		local var131_35 = var129_35:getTeamByName(TeamType.Main)
		local var132_35 = var129_35:getTeamByName(TeamType.Vanguard)

		for iter46_35, iter47_35 in ipairs(var131_35) do
			var128_35(iter47_35, var130_35, var0_35.MainUnitList, var125_35)
		end

		for iter48_35, iter49_35 in ipairs(var132_35) do
			var128_35(iter49_35, var130_35, var0_35.VanguardUnitList, var126_35)
		end

		local var133_35 = var124_35[var123_35]
		local var134_35 = _.values(var133_35:getCommanders())

		var0_35.SubCommanderList = var133_35:buildBattleBuffList()

		local var135_35 = var133_35:getTeamByName(TeamType.Submarine)

		for iter50_35, iter51_35 in ipairs(var135_35) do
			var128_35(iter51_35, var134_35, var0_35.SubUnitList, var127_35)
		end

		local var136_35 = getProxy(PlayerProxy):getRawData()
		local var137_35 = 0
		local var138_35 = var119_35:GetOilLimit()
		local var139_35 = var3_35.oil_cost > 0

		local function var140_35(arg0_49, arg1_49)
			local var0_49 = 0

			if var139_35 then
				local var1_49 = arg0_49:getStartCost().oil
				local var2_49 = arg0_49:getEndCost().oil

				var0_49 = var2_49

				if arg1_49 > 0 then
					var0_49 = math.clamp(arg1_49 - var1_49, 0, var2_49)
				end
			end

			return var0_49
		end

		local var141_35 = var137_35 + var140_35(var129_35, var138_35[1]) + var140_35(var133_35, var138_35[2])

		if var133_35:isLegalToFight() == true and var141_35 <= var136_35.oil then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
		end

		arg0_35.viewComponent:setFleet(var125_35, var126_35, var127_35)
	elseif var1_35 == SYSTEM_LIMIT_CHALLENGE then
		local var142_35 = LimitChallengeConst.GetChallengeIDByStageID(arg0_35.contextData.stageId)

		var0_35.ExtraBuffList = AcessWithinNull(pg.expedition_constellation_challenge_template[var142_35], "buff_id")

		local var143_35 = FleetProxy.CHALLENGE_FLEET_ID
		local var144_35 = FleetProxy.CHALLENGE_SUB_FLEET_ID
		local var145_35 = getProxy(FleetProxy)
		local var146_35 = var145_35:getFleetById(var143_35)
		local var147_35 = var145_35:getFleetById(var144_35)

		arg0_35.mainShips = {}

		local var148_35 = {}
		local var149_35 = {}
		local var150_35 = {}

		local function var151_35(arg0_50, arg1_50, arg2_50, arg3_50)
			if table.contains(var5_35, arg0_50) then
				BattleVertify.cloneShipVertiry = true
			end

			var5_35[#var5_35 + 1] = arg0_50

			local var0_50 = var4_35:getShipById(arg0_50)
			local var1_50 = var1_0(var1_35, var0_50, arg1_50)

			table.insert(arg0_35.mainShips, var0_50)
			table.insert(arg3_50, var0_50)
			table.insert(arg2_50, var1_50)
		end

		local var152_35 = _.values(var146_35:getCommanders())

		var0_35.CommanderList = var146_35:buildBattleBuffList()

		local var153_35 = var146_35:getTeamByName(TeamType.Main)
		local var154_35 = var146_35:getTeamByName(TeamType.Vanguard)

		for iter52_35, iter53_35 in ipairs(var153_35) do
			var151_35(iter53_35, var152_35, var0_35.MainUnitList, var148_35)
		end

		for iter54_35, iter55_35 in ipairs(var154_35) do
			var151_35(iter55_35, var152_35, var0_35.VanguardUnitList, var149_35)
		end

		local var155_35 = _.values(var147_35:getCommanders())

		var0_35.SubCommanderList = var147_35:buildBattleBuffList()

		local var156_35 = var147_35:getTeamByName(TeamType.Submarine)

		for iter56_35, iter57_35 in ipairs(var156_35) do
			var151_35(iter57_35, var155_35, var0_35.SubUnitList, var150_35)
		end

		local var157_35 = getProxy(PlayerProxy):getRawData()
		local var158_35 = 0
		local var159_35 = var3_35.oil_cost > 0

		local function var160_35(arg0_51, arg1_51)
			local var0_51 = 0

			if var159_35 then
				local var1_51 = arg0_51:getStartCost().oil
				local var2_51 = arg0_51:getEndCost().oil

				var0_51 = var2_51

				if arg1_51 > 0 then
					var0_51 = math.clamp(arg1_51 - var1_51, 0, var2_51)
				end
			end

			return var0_51
		end

		local var161_35 = var158_35 + var160_35(var146_35, 0) + var160_35(var147_35, 0)

		if var147_35:isLegalToFight() == true and var161_35 <= var157_35.oil then
			var0_35.SubFlag = 1
			var0_35.TotalSubAmmo = 1
		end

		arg0_35.viewComponent:setFleet(var148_35, var149_35, var150_35)
	elseif var1_35 == SYSTEM_CARDPUZZLE then
		local var162_35 = {}
		local var163_35 = {}
		local var164_35 = arg0_35.contextData.relics

		for iter58_35, iter59_35 in ipairs(arg0_35.contextData.cardPuzzleFleet) do
			local var165_35 = var2_0(iter59_35, var164_35)
			local var166_35 = var165_35.fleetIndex

			if var166_35 == 1 then
				table.insert(var163_35, var165_35)
				table.insert(var0_35.VanguardUnitList, var165_35)
			elseif var166_35 == 2 then
				table.insert(var162_35, var165_35)
				table.insert(var0_35.MainUnitList, var165_35)
			end
		end

		var0_35.CardPuzzleCardIDList = arg0_35.contextData.cards
		var0_35.CardPuzzleCommonHPValue = arg0_35.contextData.hp
		var0_35.CardPuzzleRelicList = var164_35
		var0_35.CardPuzzleCombatID = arg0_35.contextData.puzzleCombatID
	elseif var1_35 == SYSTEM_BOSS_SINGLE then
		if arg0_35.contextData.mainFleetId then
			local var167_35 = getProxy(FleetProxy):getActivityFleets()[arg0_35.contextData.actId]
			local var168_35 = var167_35[arg0_35.contextData.mainFleetId]
			local var169_35 = _.values(var168_35:getCommanders())

			var0_35.CommanderList = var168_35:buildBattleBuffList()
			arg0_35.mainShips = {}

			local var170_35 = {}
			local var171_35 = {}
			local var172_35 = {}

			local function var173_35(arg0_52, arg1_52, arg2_52, arg3_52)
				if table.contains(var5_35, arg0_52) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_35[#var5_35 + 1] = arg0_52

				local var0_52 = var4_35:getShipById(arg0_52)
				local var1_52 = var1_0(var1_35, var0_52, arg1_52)

				table.insert(arg0_35.mainShips, var0_52)
				table.insert(arg3_52, var0_52)
				table.insert(arg2_52, var1_52)
			end

			local var174_35 = var168_35:getTeamByName(TeamType.Main)
			local var175_35 = var168_35:getTeamByName(TeamType.Vanguard)

			for iter60_35, iter61_35 in ipairs(var174_35) do
				var173_35(iter61_35, var169_35, var0_35.MainUnitList, var170_35)
			end

			for iter62_35, iter63_35 in ipairs(var175_35) do
				var173_35(iter63_35, var169_35, var0_35.VanguardUnitList, var171_35)
			end

			local var176_35 = var167_35[arg0_35.contextData.mainFleetId + 10]
			local var177_35 = _.values(var176_35:getCommanders())
			local var178_35 = var176_35:getTeamByName(TeamType.Submarine)

			for iter64_35, iter65_35 in ipairs(var178_35) do
				var173_35(iter65_35, var177_35, var0_35.SubUnitList, var172_35)
			end

			local var179_35 = getProxy(PlayerProxy):getRawData()
			local var180_35 = getProxy(ActivityProxy):getActivityById(arg0_35.contextData.actId)

			var0_35.ChapterBuffIDs = var180_35:GetBuffIdsByStageId(arg0_35.contextData.stageId)

			local var181_35 = var180_35:GetEnemyDataByStageId(arg0_35.contextData.stageId):GetOilLimit()
			local var182_35 = 0
			local var183_35 = var3_35.oil_cost > 0

			local function var184_35(arg0_53, arg1_53)
				if var183_35 then
					local var0_53 = arg0_53:getEndCost().oil

					if arg1_53 > 0 then
						local var1_53 = arg0_53:getStartCost().oil

						cost = math.clamp(arg1_53 - var1_53, 0, var0_53)
					end

					var182_35 = var182_35 + var0_53
				end
			end

			var184_35(var168_35, var181_35[1] or 0)
			var184_35(var176_35, var181_35[2] or 0)

			if var176_35:isLegalToFight() == true and var182_35 <= var179_35.oil then
				var0_35.SubFlag = 1
				var0_35.TotalSubAmmo = 1
			end

			var0_35.SubCommanderList = var176_35:buildBattleBuffList()

			arg0_35.viewComponent:setFleet(var170_35, var171_35, var172_35)
		end
	elseif arg0_35.contextData.mainFleetId then
		local var185_35 = var1_35 == SYSTEM_DUEL
		local var186_35 = getProxy(FleetProxy)
		local var187_35
		local var188_35
		local var189_35 = var186_35:getFleetById(arg0_35.contextData.mainFleetId)

		arg0_35.mainShips = var4_35:getShipsByFleet(var189_35)

		local var190_35 = {}
		local var191_35 = {}
		local var192_35 = {}

		local function var193_35(arg0_54, arg1_54, arg2_54)
			for iter0_54, iter1_54 in ipairs(arg0_54) do
				if table.contains(var5_35, iter1_54) then
					BattleVertify.cloneShipVertiry = true
				end

				var5_35[#var5_35 + 1] = iter1_54

				local var0_54 = var4_35:getShipById(iter1_54)
				local var1_54 = var1_0(var1_35, var0_54, nil, var185_35)

				table.insert(arg1_54, var0_54)
				table.insert(arg2_54, var1_54)
			end
		end

		local var194_35 = var189_35:getTeamByName(TeamType.Main)
		local var195_35 = var189_35:getTeamByName(TeamType.Vanguard)
		local var196_35 = var189_35:getTeamByName(TeamType.Submarine)

		var193_35(var194_35, var190_35, var0_35.MainUnitList)
		var193_35(var195_35, var191_35, var0_35.VanguardUnitList)
		var193_35(var196_35, var192_35, var0_35.SubUnitList)
		arg0_35.viewComponent:setFleet(var190_35, var191_35, var192_35)

		if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
			local var197_35 = var186_35:getFleetById(11)
			local var198_35 = var197_35:getTeamByName(TeamType.Submarine)

			if #var198_35 > 0 then
				var0_35.SubFlag = 1
				var0_35.TotalSubAmmo = 1

				local var199_35 = _.values(var197_35:getCommanders())

				var0_35.SubCommanderList = var197_35:buildBattleBuffList()

				for iter66_35, iter67_35 in ipairs(var198_35) do
					local var200_35 = var4_35:getShipById(iter67_35)
					local var201_35 = var1_0(var1_35, var200_35, var199_35, var185_35)

					table.insert(var192_35, var200_35)
					table.insert(var0_35.SubUnitList, var201_35)
				end
			end
		end
	end

	if var1_35 == SYSTEM_WORLD then
		local var202_35 = nowWorld()
		local var203_35 = var202_35:GetActiveMap()
		local var204_35 = var203_35:GetFleet()
		local var205_35 = var203_35:GetCell(var204_35.row, var204_35.column):GetStageEnemy()
		local var206_35 = pg.world_expedition_data[arg0_35.contextData.stageId]
		local var207_35 = var202_35:GetWorldMapDifficultyBuffLevel()

		var0_35.EnemyMapRewards = {
			var207_35[1] * (1 + var206_35.expedition_sairenvalueA / 10000),
			var207_35[2] * (1 + var206_35.expedition_sairenvalueB / 10000),
			var207_35[3] * (1 + var206_35.expedition_sairenvalueC / 10000)
		}
		var0_35.FleetMapRewards = var202_35:GetWorldMapBuffLevel()
	end

	var0_35.RivalMainUnitList, var0_35.RivalVanguardUnitList = {}, {}

	local var208_35

	if var1_35 == SYSTEM_DUEL and arg0_35.contextData.rivalId then
		local var209_35 = getProxy(MilitaryExerciseProxy)

		var208_35 = var209_35:getRivalById(arg0_35.contextData.rivalId)
		arg0_35.oldRank = var209_35:getSeasonInfo()
	end

	if var208_35 then
		var0_35.RivalVO = var208_35

		local var210_35 = 0

		for iter68_35, iter69_35 in ipairs(var208_35.mainShips) do
			var210_35 = var210_35 + iter69_35.level
		end

		for iter70_35, iter71_35 in ipairs(var208_35.vanguardShips) do
			var210_35 = var210_35 + iter71_35.level
		end

		BattleVertify = BattleVertify or {}
		BattleVertify.rivalLevel = var210_35

		for iter72_35, iter73_35 in ipairs(var208_35.mainShips) do
			if not iter73_35.hpRant or iter73_35.hpRant > 0 then
				local var211_35 = var1_0(var1_35, iter73_35, nil, true)

				if iter73_35.hpRant then
					var211_35.initHPRate = iter73_35.hpRant * 0.0001
				end

				table.insert(var0_35.RivalMainUnitList, var211_35)
			end
		end

		for iter74_35, iter75_35 in ipairs(var208_35.vanguardShips) do
			if not iter75_35.hpRant or iter75_35.hpRant > 0 then
				local var212_35 = var1_0(var1_35, iter75_35, nil, true)

				if iter75_35.hpRant then
					var212_35.initHPRate = iter75_35.hpRant * 0.0001
				end

				table.insert(var0_35.RivalVanguardUnitList, var212_35)
			end
		end
	end

	local var213_35 = arg0_35.contextData.prefabFleet.main_unitList
	local var214_35 = arg0_35.contextData.prefabFleet.vanguard_unitList
	local var215_35 = arg0_35.contextData.prefabFleet.submarine_unitList

	if var213_35 then
		for iter76_35, iter77_35 in ipairs(var213_35) do
			local var216_35 = {}

			for iter78_35, iter79_35 in ipairs(iter77_35.equipment) do
				var216_35[#var216_35 + 1] = {
					skin = 0,
					id = iter79_35
				}
			end

			local var217_35 = {
				id = iter77_35.id,
				tmpID = iter77_35.configId,
				skinId = iter77_35.skinId,
				level = iter77_35.level,
				equipment = var216_35,
				properties = iter77_35.properties,
				baseProperties = iter77_35.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter77_35.skills
			}

			table.insert(var0_35.MainUnitList, var217_35)
		end
	end

	if var214_35 then
		for iter80_35, iter81_35 in ipairs(var214_35) do
			local var218_35 = {}

			for iter82_35, iter83_35 in ipairs(iter81_35.equipment) do
				var218_35[#var218_35 + 1] = {
					skin = 0,
					id = iter83_35
				}
			end

			local var219_35 = {
				id = iter81_35.id,
				tmpID = iter81_35.configId,
				skinId = iter81_35.skinId,
				level = iter81_35.level,
				equipment = var218_35,
				properties = iter81_35.properties,
				baseProperties = iter81_35.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter81_35.skills
			}

			table.insert(var0_35.VanguardUnitList, var219_35)
		end
	end

	if var215_35 then
		for iter84_35, iter85_35 in ipairs(var215_35) do
			local var220_35 = {}

			for iter86_35, iter87_35 in ipairs(iter85_35.equipment) do
				var220_35[#var220_35 + 1] = {
					skin = 0,
					id = iter87_35
				}
			end

			local var221_35 = {
				id = iter85_35.id,
				tmpID = iter85_35.configId,
				skinId = iter85_35.skinId,
				level = iter85_35.level,
				equipment = var220_35,
				properties = iter85_35.properties,
				baseProperties = iter85_35.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter85_35.skills
			}

			table.insert(var0_35.SubUnitList, var221_35)

			if var1_35 == SYSTEM_SIMULATION and #var0_35.SubUnitList > 0 then
				var0_35.SubFlag = 1
				var0_35.TotalSubAmmo = 1
			end
		end
	end
end

function var0_0.listNotificationInterests(arg0_55)
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

function var0_0.handleNotification(arg0_56, arg1_56)
	local var0_56 = arg1_56:getName()
	local var1_56 = arg1_56:getBody()
	local var2_56 = ys.Battle.BattleState.GetInstance()
	local var3_56 = arg0_56.contextData.system

	if var0_56 == GAME.FINISH_STAGE_DONE then
		pg.MsgboxMgr.GetInstance():hide()

		local var4_56 = var1_56.system

		if var4_56 == SYSTEM_PROLOGUE then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_56:sendNotification(GAME.CHANGE_SCENE, SCENE.CREATE_PLAYER)
		elseif var4_56 == SYSTEM_PERFORM or var4_56 == SYSTEM_SIMULATION then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0_56.viewComponent:exitBattle()

			if var1_56.exitCallback then
				var1_56.exitCallback()
			end
		else
			local var5_56 = BattleResultMediator.GetResultView(var4_56)
			local var6_56 = {}

			if var4_56 == SYSTEM_SCENARIO then
				var6_56 = getProxy(ChapterProxy):getActiveChapter().operationBuffList
			end

			arg0_56:addSubLayers(Context.New({
				mediator = NewBattleResultMediator,
				viewComponent = NewBattleResultScene,
				data = {
					system = var4_56,
					rivalId = arg0_56.contextData.rivalId,
					mainFleetId = arg0_56.contextData.mainFleetId,
					stageId = arg0_56.contextData.stageId,
					oldMainShips = arg0_56.mainShips or {},
					oldPlayer = arg0_56.player,
					oldRank = arg0_56.oldRank,
					statistics = var1_56.statistics,
					score = var1_56.score,
					drops = var1_56.drops,
					bossId = var1_56.bossId,
					name = var1_56.name,
					prefabFleet = var1_56.prefabFleet,
					commanderExps = var1_56.commanderExps,
					actId = arg0_56.contextData.actId,
					result = var1_56.result,
					extraDrops = var1_56.extraDrops,
					extraBuffList = var6_56,
					isLastBonus = var1_56.isLastBonus,
					continuousBattleTimes = arg0_56.contextData.continuousBattleTimes,
					totalBattleTimes = arg0_56.contextData.totalBattleTimes,
					mode = arg0_56.contextData.mode,
					cmdArgs = arg0_56.contextData.cmdArgs
				}
			}))
		end
	elseif var0_56 == GAME.STORY_BEGIN then
		var2_56:Pause()
	elseif var0_56 == GAME.STORY_END then
		var2_56:Resume()
	elseif var0_56 == GAME.START_GUIDE then
		var2_56:Pause()
	elseif var0_56 == GAME.END_GUIDE then
		var2_56:Resume()
	elseif var0_56 == GAME.PAUSE_BATTLE then
		if not var2_56:IsPause() then
			arg0_56:onPauseBtn()
		end
	elseif var0_56 == GAME.RESUME_BATTLE then
		var2_56:Resume()
	elseif var0_56 == GAME.FINISH_STAGE_ERROR then
		gcAll(true)

		local var7_56 = getProxy(ContextProxy)
		local var8_56 = var7_56:getContextByMediator(DailyLevelMediator)
		local var9_56 = var7_56:getContextByMediator(LevelMediator2)
		local var10_56 = var7_56:getContextByMediator(ChallengeMainMediator)
		local var11_56 = var7_56:getContextByMediator(ActivityBossMediatorTemplate)

		if var8_56 then
			local var12_56 = var8_56:getContextByMediator(PreCombatMediator)

			var8_56:removeChild(var12_56)
		elseif var10_56 then
			local var13_56 = var10_56:getContextByMediator(ChallengePreCombatMediator)

			var10_56:removeChild(var13_56)
		elseif var9_56 then
			if var3_56 == SYSTEM_DUEL then
				-- block empty
			elseif var3_56 == SYSTEM_SCENARIO then
				local var14_56 = var9_56:getContextByMediator(ChapterPreCombatMediator)

				var9_56:removeChild(var14_56)
			elseif var3_56 ~= SYSTEM_PERFORM and var3_56 ~= SYSTEM_SIMULATION then
				local var15_56 = var9_56:getContextByMediator(PreCombatMediator)

				if var15_56 then
					var9_56:removeChild(var15_56)
				end
			end
		elseif var11_56 then
			local var16_56 = var11_56:getContextByMediator(PreCombatMediator)

			if var16_56 then
				var11_56:removeChild(var16_56)
			end
		end

		arg0_56:sendNotification(GAME.GO_BACK)
	elseif var0_56 == var0_0.CLOSE_CHAT then
		arg0_56.viewComponent:OnCloseChat()
	elseif var0_56 == var0_0.HIDE_ALL_BUTTONS then
		ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name):DispatchEvent(ys.Event.New(ys.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
			isActive = var1_56
		}))
	elseif var0_56 == GAME.QUIT_BATTLE then
		var2_56:Stop()
	elseif var0_56 == var0_0.UPDATE_AUTO_COUNT then
		arg0_56:updateAutoCount(var1_56)
	end
end

function var0_0.remove(arg0_57)
	pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)
end

return var0_0
