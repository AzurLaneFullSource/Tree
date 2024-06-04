local var0 = class("BattleMediator", import("..base.ContextMediator"))

var0.ON_BATTLE_RESULT = "BattleMediator:ON_BATTLE_RESULT"
var0.ON_PAUSE = "BattleMediator:ON_PAUSE"
var0.ENTER = "BattleMediator:ENTER"
var0.ON_BACK_PRE_SCENE = "BattleMediator:ON_BACK_PRE_SCENE"
var0.ON_LEAVE = "BattleMediator:ON_LEAVE"
var0.ON_QUIT_BATTLE_MANUALLY = "BattleMediator:ON_QUIT_BATTLE_MANUALLY"
var0.HIDE_ALL_BUTTONS = "BattleMediator:HIDE_ALL_BUTTONS"
var0.ON_CHAT = "BattleMediator:ON_CHAT"
var0.CLOSE_CHAT = "BattleMediator:CLOSE_CHAT"
var0.ON_AUTO = "BattleMediator:ON_AUTO"
var0.ON_PUZZLE_RELIC = "BattleMediator.ON_PUZZLE_RELIC"
var0.ON_PUZZLE_CARD = "BattleMediator.ON_PUZZLE_CARD"

function var0.register(arg0)
	pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(true)
	arg0:GenBattleData()

	arg0.contextData.battleData = arg0._battleData

	local var0 = ys.Battle.BattleState.GetInstance()
	local var1 = arg0.contextData.system

	arg0:bind(var0.ON_BATTLE_RESULT, function(arg0, arg1)
		arg0:sendNotification(GAME.FINISH_STAGE, {
			token = arg0.contextData.token,
			mainFleetId = arg0.contextData.mainFleetId,
			stageId = arg0.contextData.stageId,
			rivalId = arg0.contextData.rivalId,
			memory = arg0.contextData.memory,
			bossId = arg0.contextData.bossId,
			exitCallback = arg0.contextData.exitCallback,
			system = var1,
			statistics = arg1,
			actId = arg0.contextData.actId,
			mode = arg0.contextData.mode,
			puzzleCombatID = arg0.contextData.puzzleCombatID
		})
	end)
	arg0:bind(var0.ON_AUTO, function(arg0, arg1)
		arg0:onAutoBtn(arg1)
	end)
	arg0:bind(var0.ON_PAUSE, function(arg0)
		arg0:onPauseBtn()
	end)
	arg0:bind(var0.ON_LEAVE, function(arg0)
		arg0:warnFunc()
	end)
	arg0:bind(var0.ON_CHAT, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = NotificationMediator,
			viewComponent = NotificationLayer,
			data = {
				form = NotificationLayer.FORM_BATTLE,
				chatViewParent = arg1
			}
		}))
	end)
	arg0:bind(var0.ENTER, function(arg0)
		var0:EnterBattle(arg0._battleData, arg0.contextData.prePause)
	end)
	arg0:bind(var0.ON_BACK_PRE_SCENE, function()
		local var0 = getProxy(ContextProxy)
		local var1 = var0:getContextByMediator(DailyLevelMediator)
		local var2 = var0:getContextByMediator(LevelMediator2)
		local var3 = var0:getContextByMediator(ChallengeMainMediator)
		local var4 = var0:getContextByMediator(ActivityBossMediatorTemplate)
		local var5 = var0:getContextByMediator(WorldMediator)
		local var6 = var0:getContextByMediator(WorldBossMediator)

		if var6 and arg0.contextData.bossId then
			arg0:sendNotification(GAME.WORLD_BOSS_BATTLE_QUIT, {
				id = arg0.contextData.bossId
			})

			local var7 = var6:getContextByMediator(WorldBossFormationMediator)

			if var7 then
				var6:removeChild(var7)
			end
		elseif var5 then
			local var8 = var5:getContextByMediator(WorldPreCombatMediator) or var5:getContextByMediator(WorldBossInformationMediator)

			if var8 then
				var5:removeChild(var8)
			end
		elseif var1 then
			local var9 = var1:getContextByMediator(PreCombatMediator)

			var1:removeChild(var9)
		elseif var3 then
			arg0:sendNotification(GAME.CHALLENGE2_RESET, {
				mode = arg0.contextData.mode
			})

			local var10 = var3:getContextByMediator(ChallengePreCombatMediator)

			var3:removeChild(var10)
		elseif var2 then
			if var1 == SYSTEM_DUEL then
				-- block empty
			elseif var1 == SYSTEM_SCENARIO then
				local var11 = var2:getContextByMediator(ChapterPreCombatMediator)

				if var11 then
					var2:removeChild(var11)
				end
			elseif var1 ~= SYSTEM_PERFORM and var1 ~= SYSTEM_SIMULATION then
				local var12 = var2:getContextByMediator(PreCombatMediator)

				if var12 then
					var2:removeChild(var12)
				end
			end
		elseif var4 then
			local var13 = var4:getContextByMediator(PreCombatMediator)

			if var13 then
				var4:removeChild(var13)
			end
		end

		arg0:sendNotification(GAME.GO_BACK)
	end)
	arg0:bind(var0.ON_QUIT_BATTLE_MANUALLY, function(arg0)
		if var1 == SYSTEM_SCENARIO then
			getProxy(ChapterProxy):StopAutoFight(ChapterConst.AUTOFIGHT_STOP_REASON.MANUAL)
		elseif var1 == SYSTEM_WORLD then
			nowWorld():TriggerAutoFight(false)
		elseif var1 == SYSTEM_ACT_BOSS then
			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				getProxy(ContextProxy):GetPrevContext(1):addChild(Context.New({
					mediator = ActivityBossTotalRewardPanelMediator,
					viewComponent = ActivityBossTotalRewardPanel,
					data = {
						isAutoFight = false,
						isLayer = true,
						rewards = getProxy(ChapterProxy):PopActBossRewards(),
						continuousBattleTimes = arg0.contextData.continuousBattleTimes,
						totalBattleTimes = arg0.contextData.totalBattleTimes
					}
				}))
			end
		elseif var1 == SYSTEM_BOSS_RUSH then
			if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
				local var0 = getProxy(ActivityProxy):PopBossRushAwards()

				getProxy(ContextProxy):GetPrevContext(1):addChild(Context.New({
					mediator = BossRushTotalRewardPanelMediator,
					viewComponent = BossRushTotalRewardPanel,
					data = {
						isLayer = true,
						rewards = var0
					}
				}))
			end
		elseif var1 == SYSTEM_BOSS_SINGLE and getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
			getProxy(ContextProxy):GetPrevContext(1):addChild(Context.New({
				mediator = BossSingleTotalRewardPanelMediator,
				viewComponent = BossSingleTotalRewardPanel,
				data = {
					isAutoFight = false,
					isLayer = true,
					rewards = getProxy(ChapterProxy):PopBossSingleRewards(),
					continuousBattleTimes = arg0.contextData.continuousBattleTimes,
					totalBattleTimes = arg0.contextData.totalBattleTimes
				}
			}))
		end
	end)
	arg0:bind(var0.ON_PUZZLE_RELIC, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CardPuzzleRelicDeckMediator,
			viewComponent = CardPuzzleRelicDeckLayerCombat,
			data = arg1
		}))
		var0:Pause()
	end)
	arg0:bind(var0.ON_PUZZLE_CARD, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CardPuzzleCardDeckMediator,
			viewComponent = CardPuzzleCardDeckLayerCombat,
			data = arg1
		}))
		var0:Pause()
	end)

	if arg0.contextData.continuousBattleTimes and arg0.contextData.continuousBattleTimes > 0 then
		if var1 == SYSTEM_BOSS_SINGLE then
			if not getProxy(ContextProxy):getCurrentContext():getContextByMediator(BossSingleContinuousOperationMediator) then
				local var2 = CreateShell(arg0.contextData)

				var2.LayerWeightMgr_weight = LayerWeightConst.BASE_LAYER

				arg0:addSubLayers(Context.New({
					mediator = BossSingleContinuousOperationMediator,
					viewComponent = BossSingleContinuousOperationPanel,
					data = var2
				}))
			end
		elseif not getProxy(ContextProxy):getCurrentContext():getContextByMediator(ContinuousOperationMediator) then
			local var3 = CreateShell(arg0.contextData)

			var3.LayerWeightMgr_weight = LayerWeightConst.BASE_LAYER

			arg0:addSubLayers(Context.New({
				mediator = ContinuousOperationMediator,
				viewComponent = ContinuousOperationPanel,
				data = var3
			}))
		end

		arg0.contextData.battleData.hideAllButtons = true
	end

	local var4 = getProxy(PlayerProxy)

	if var4 then
		arg0.player = var4:getData()

		var4:setFlag("battle", true)
	end
end

function var0.onAutoBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle
	local var2 = arg1.system

	arg0:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0,
		toggle = var1,
		system = var2
	})
end

function var0.onPauseBtn(arg0)
	local var0 = ys.Battle.BattleState.GetInstance()

	if arg0.contextData.system == SYSTEM_PROLOGUE or arg0.contextData.system == SYSTEM_PERFORM then
		local var1 = {}

		if EPILOGUE_SKIPPABLE then
			local var2 = {
				text = "关爱胡德",
				btnType = pg.MsgboxMgr.BUTTON_RED,
				onCallback = function()
					var0:Deactive()
					arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.CREATE_PLAYER)
				end
			}

			table.insert(var1, 1, var2)
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
			custom = var1
		})
		var0:Pause()
	elseif arg0.contextData.system == SYSTEM_DODGEM then
		local var3 = {
			text = "text_cancel_fight",
			btnType = pg.MsgboxMgr.BUTTON_RED,
			onCallback = function()
				arg0:warnFunc(function()
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
				var3
			}
		})
		var0:Pause()
	elseif arg0.contextData.system == SYSTEM_SIMULATION then
		local var4 = {
			text = "text_cancel_fight",
			btnType = pg.MsgboxMgr.BUTTON_RED,
			onCallback = function()
				arg0:warnFunc(function()
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
				var4
			}
		})
		var0:Pause()
	elseif arg0.contextData.system == SYSTEM_SUBMARINE_RUN or arg0.contextData.system == SYSTEM_SUB_ROUTINE or arg0.contextData.system == SYSTEM_REWARD_PERFORM or arg0.contextData.system == SYSTEM_AIRFIGHT then
		var0:Pause()
		arg0:warnFunc(function()
			ys.Battle.BattleState.GetInstance():Resume()
		end)
	elseif arg0.contextData.system == SYSTEM_CARDPUZZLE then
		arg0:addSubLayers(Context.New({
			mediator = CardPuzzleCombatPauseMediator,
			viewComponent = CardPuzzleCombatPauseLayer
		}))
		var0:Pause()
	else
		arg0.viewComponent:updatePauseWindow()
		var0:Pause()
	end
end

function var0.warnFunc(arg0, arg1)
	local var0 = ys.Battle.BattleState.GetInstance()
	local var1 = arg0.contextData.system
	local var2
	local var3

	local function var4()
		var0:Stop()
	end

	local var5 = arg0.contextData.warnMsg

	if var5 and #var5 > 0 then
		var3 = i18n(var5)
	elseif var1 == SYSTEM_CHALLENGE then
		var3 = i18n("battle_battleMediator_clear_warning")
	elseif var1 == SYSTEM_SIMULATION then
		var3 = i18n("tech_simulate_quit")
	else
		var3 = i18n("battle_battleMediator_quest_exist")
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideNo = true,
		hideYes = true,
		content = var3,
		onClose = arg1,
		custom = {
			{
				text = "text_cancel",
				onCallback = arg1,
				sound = SFX_CANCEL
			},
			{
				text = "text_exit",
				btnType = pg.MsgboxMgr.BUTTON_RED,
				onCallback = var4,
				sound = SFX_CONFIRM
			}
		}
	})
end

function var0.guideDispatch(arg0)
	return
end

local function var1(arg0, arg1, arg2, arg3)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1:getActiveEquipments()) do
		if iter1 then
			var0[#var0 + 1] = {
				id = iter1.configId,
				skin = iter1.skinId,
				equipmentInfo = iter1
			}
		else
			var0[#var0 + 1] = {
				skin = 0,
				id = iter1,
				equipmentInfo = iter1
			}
		end
	end

	local var1 = {}

	local function var2(arg0)
		local var0 = {
			level = arg0.level
		}
		local var1 = arg0.id
		local var2 = arg1:RemapSkillId(var1)

		var0.id = ys.Battle.BattleDataFunction.SkillTranform(arg0, var2)

		return var0
	end

	local var3 = ys.Battle.BattleDataFunction.GenerateHiddenBuff(arg1.configId)

	for iter2, iter3 in pairs(var3) do
		local var4 = var2(iter3)

		var1[var4.id] = var4
	end

	for iter4, iter5 in pairs(arg1.skills) do
		if iter5 and iter5.id == 14900 and not arg1.transforms[16412] then
			-- block empty
		else
			local var5 = var2(iter5)

			var1[var5.id] = var5
		end
	end

	local var6 = ys.Battle.BattleDataFunction.GetEquipSkill(var0)

	for iter6, iter7 in ipairs(var6) do
		local var7 = {}

		var7.level = 1
		var7.id = ys.Battle.BattleDataFunction.SkillTranform(arg0, iter7)
		var1[var7.id] = var7
	end

	local var8

	;(function()
		var8 = arg1:GetSpWeapon()

		if not var8 then
			return
		end

		local var0 = var8:GetEffect()

		if var0 == 0 then
			return
		end

		local var1 = {}

		var1.level = 1
		var1.id = ys.Battle.BattleDataFunction.SkillTranform(arg0, var0)
		var1[var1.id] = var1
	end)()

	for iter8, iter9 in pairs(arg1:getTriggerSkills()) do
		local var9 = {
			level = iter9.level,
			id = ys.Battle.BattleDataFunction.SkillTranform(arg0, iter9.id)
		}

		var1[var9.id] = var9
	end

	local var10 = arg0 == SYSTEM_WORLD
	local var11 = false

	if var10 then
		local var12 = WorldConst.FetchWorldShip(arg1.id)

		if var12 then
			var11 = var12:IsBroken()
		end
	end

	if var11 then
		for iter10, iter11 in pairs(var1) do
			local var13 = pg.skill_data_template[iter10].world_death_mark[1]

			if var13 == ys.Battle.BattleConst.DEATH_MARK_SKILL.DEACTIVE then
				var1[iter10] = nil
			elseif var13 == ys.Battle.BattleConst.DEATH_MARK_SKILL.IGNORE then
				-- block empty
			end
		end
	end

	return {
		id = arg1.id,
		tmpID = arg1.configId,
		skinId = arg1.skinId,
		level = arg1.level,
		equipment = var0,
		properties = arg1:getProperties(arg2, arg3, var10),
		baseProperties = arg1:getShipProperties(),
		proficiency = arg1:getEquipProficiencyList(),
		rarity = arg1:getRarity(),
		intimacy = arg1:getCVIntimacy(),
		shipGS = arg1:getShipCombatPower(),
		skills = var1,
		baseList = arg1:getBaseList(),
		preloasList = arg1:getPreLoadCount(),
		name = arg1:getName(),
		deathMark = var11,
		spWeapon = var8
	}
end

local function var2(arg0, arg1)
	local var0 = arg0:getProperties(arg1)
	local var1 = arg0:getConfig("id")

	return {
		deathMark = false,
		shipGS = 100,
		rarity = 1,
		intimacy = 100,
		id = var1,
		tmpID = var1,
		skinId = arg0:getConfig("skin_id"),
		level = arg0:getConfig("level"),
		equipment = arg0:getConfig("default_equip"),
		properties = var0,
		baseProperties = var0,
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
		name = var1,
		fleetIndex = arg0:getConfig("location")
	}
end

function var0.GenBattleData(arg0)
	local var0 = {}
	local var1 = arg0.contextData.system

	arg0._battleData = var0
	var0.battleType = arg0.contextData.system
	var0.StageTmpId = arg0.contextData.stageId
	var0.CMDArgs = arg0.contextData.cmdArgs
	var0.MainUnitList = {}
	var0.VanguardUnitList = {}
	var0.SubUnitList = {}
	var0.AidUnitList = {}
	var0.SupportUnitList = {}
	var0.SubFlag = -1
	var0.ActID = arg0.contextData.actId
	var0.bossLevel = arg0.contextData.bossLevel
	var0.bossConfigId = arg0.contextData.bossConfigId

	if pg.battle_cost_template[var1].global_buff_effected > 0 then
		local var2 = BuffHelper.GetBattleBuffs(var1)

		var0.GlobalBuffIDs = _.map(var2, function(arg0)
			return arg0:getConfig("benefit_effect")
		end) or {}
	end

	local var3 = pg.battle_cost_template[var1]
	local var4 = getProxy(BayProxy)
	local var5 = {}

	if var1 == SYSTEM_SCENARIO then
		local var6 = getProxy(ChapterProxy)
		local var7 = var6:getActiveChapter()

		var0.RepressInfo = var7:getRepressInfo()

		arg0.viewComponent:setChapter(var7)

		local var8 = var7.fleet

		var0.KizunaJamming = var7.extraFlagList
		var0.DefeatCount = var8:getDefeatCount()
		var0.ChapterBuffIDs, var0.CommanderList = var7:getFleetBattleBuffs(var8)
		var0.StageWaveFlags = var7:GetStageFlags()
		var0.ChapterWeatherIDS = var7:GetWeather(var8.line.row, var8.line.column)
		var0.MapAuraSkills = var6.GetChapterAuraBuffs(var7)
		var0.MapAidSkills = {}

		local var9 = var6.GetChapterAidBuffs(var7)

		for iter0, iter1 in pairs(var9) do
			local var10 = var7:getFleetByShipVO(iter0)
			local var11 = _.values(var10:getCommanders())
			local var12 = var1(var1, iter0, var11)

			table.insert(var0.AidUnitList, var12)

			for iter2, iter3 in ipairs(iter1) do
				table.insert(var0.MapAidSkills, iter3)
			end
		end

		local var13 = var8:getShipsByTeam(TeamType.Main, false)
		local var14 = var8:getShipsByTeam(TeamType.Vanguard, false)
		local var15 = {}
		local var16 = _.values(var8:getCommanders())
		local var17 = {}
		local var18, var19 = var6.getSubAidFlag(var7, arg0.contextData.stageId)

		if var18 == true or var18 > 0 then
			var0.SubFlag = 1
			var0.TotalSubAmmo = 1
			var15 = var19:getShipsByTeam(TeamType.Submarine, false)
			var17 = _.values(var19:getCommanders())

			local var20, var21 = var7:getFleetBattleBuffs(var19)

			var0.SubCommanderList = var21
		else
			var0.SubFlag = var18

			if var18 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0.TotalSubAmmo = 0
			end
		end

		arg0.mainShips = {}

		local function var22(arg0, arg1, arg2)
			local var0 = arg0.id
			local var1 = arg0.hpRant * 0.0001

			if table.contains(var5, var0) then
				BattleVertify.cloneShipVertiry = true
			end

			var5[#var5 + 1] = var0

			local var2 = var1(var1, arg0, arg1)

			var2.initHPRate = var1

			table.insert(arg0.mainShips, arg0)
			table.insert(arg2, var2)
		end

		for iter4, iter5 in ipairs(var13) do
			var22(iter5, var16, var0.MainUnitList)
		end

		for iter6, iter7 in ipairs(var14) do
			var22(iter7, var16, var0.VanguardUnitList)
		end

		for iter8, iter9 in ipairs(var15) do
			var22(iter9, var17, var0.SubUnitList)
		end

		local var23 = var7:getChapterSupportFleet()

		if var23 then
			local var24 = var23:getShips()

			for iter10, iter11 in pairs(var24) do
				var22(iter11, {}, var0.SupportUnitList)
			end
		end

		arg0.viewComponent:setFleet(var13, var14, var15)
	elseif var1 == SYSTEM_CHALLENGE then
		local var25 = arg0.contextData.mode
		local var26 = getProxy(ChallengeProxy):getUserChallengeInfo(var25)

		var0.ChallengeInfo = var26

		arg0.viewComponent:setChapter(var26)

		local var27 = var26:getRegularFleet()

		var0.CommanderList = var27:buildBattleBuffList()

		local var28 = _.values(var27:getCommanders())
		local var29 = {}
		local var30 = var27:getShipsByTeam(TeamType.Main, false)
		local var31 = var27:getShipsByTeam(TeamType.Vanguard, false)
		local var32 = {}
		local var33 = var26:getSubmarineFleet()
		local var34 = var33:getShipsByTeam(TeamType.Submarine, false)

		if #var34 > 0 then
			var0.SubFlag = 1
			var0.TotalSubAmmo = 1
			var29 = _.values(var33:getCommanders())
			var0.SubCommanderList = var33:buildBattleBuffList()
		else
			var0.SubFlag = 0
			var0.TotalSubAmmo = 0
		end

		arg0.mainShips = {}

		local function var35(arg0, arg1, arg2)
			local var0 = arg0.id
			local var1 = arg0.hpRant * 0.0001

			if table.contains(var5, var0) then
				BattleVertify.cloneShipVertiry = true
			end

			var5[#var5 + 1] = var0

			local var2 = var1(var1, arg0, arg1)

			var2.initHPRate = var1

			table.insert(arg0.mainShips, arg0)
			table.insert(arg2, var2)
		end

		for iter12, iter13 in ipairs(var30) do
			var35(iter13, var28, var0.MainUnitList)
		end

		for iter14, iter15 in ipairs(var31) do
			var35(iter15, var28, var0.VanguardUnitList)
		end

		for iter16, iter17 in ipairs(var34) do
			var35(iter17, var29, var0.SubUnitList)
		end

		arg0.viewComponent:setFleet(var30, var31, var34)
	elseif var1 == SYSTEM_WORLD then
		local var36 = nowWorld()
		local var37 = var36:GetActiveMap()
		local var38 = var37:GetFleet()
		local var39 = var37:GetCell(var38.row, var38.column):GetStageEnemy()
		local var40 = var39:GetHP()

		if var40 then
			var0.RepressInfo = {
				repressEnemyHpRant = var40 / var39:GetMaxHP()
			}
		end

		var0.AffixBuffList = table.mergeArray(var39:GetBattleLuaBuffs(), var37:GetBattleLuaBuffs(WorldMap.FactionEnemy, var39))

		local function var41(arg0)
			local var0 = {}

			for iter0, iter1 in ipairs(arg0) do
				local var1 = {
					id = ys.Battle.BattleDataFunction.SkillTranform(var1, iter1.id),
					level = iter1.level
				}

				table.insert(var0, var1)
			end

			return var0
		end

		var0.DefeatCount = var38:getDefeatCount()
		var0.ChapterBuffIDs, var0.CommanderList = var37:getFleetBattleBuffs(var38, true)
		var0.MapAuraSkills = var37:GetChapterAuraBuffs()
		var0.MapAuraSkills = var41(var0.MapAuraSkills)
		var0.MapAidSkills = {}

		local var42 = var37:GetChapterAidBuffs()

		for iter18, iter19 in pairs(var42) do
			local var43 = var37:GetFleet(iter18.fleetId)
			local var44 = _.values(var43:getCommanders(true))
			local var45 = var1(var1, WorldConst.FetchShipVO(iter18.id), var44)

			table.insert(var0.AidUnitList, var45)

			var0.MapAidSkills = table.mergeArray(var0.MapAidSkills, var41(iter19))
		end

		local var46 = var38:GetTeamShipVOs(TeamType.Main, false)
		local var47 = var38:GetTeamShipVOs(TeamType.Vanguard, false)
		local var48 = {}
		local var49 = _.values(var38:getCommanders(true))
		local var50 = {}
		local var51 = var36:GetSubAidFlag()

		if var51 == true then
			local var52 = var37:GetSubmarineFleet()

			var0.SubFlag = 1
			var0.TotalSubAmmo = 1
			var48 = var52:GetTeamShipVOs(TeamType.Submarine, false)
			var50 = _.values(var52:getCommanders(true))

			local var53, var54 = var37:getFleetBattleBuffs(var52, true)

			var0.SubCommanderList = var54
		else
			var0.SubFlag = 0

			if var51 ~= ys.Battle.BattleConst.SubAidFlag.AID_EMPTY then
				var0.TotalSubAmmo = 0
			end
		end

		arg0.mainShips = {}

		for iter20, iter21 in ipairs(var46) do
			local var55 = iter21.id
			local var56 = WorldConst.FetchWorldShip(iter21.id).hpRant * 0.0001

			if table.contains(var5, var55) then
				BattleVertify.cloneShipVertiry = true
			end

			var5[#var5 + 1] = var55

			local var57 = var1(var1, iter21, var49)

			var57.initHPRate = var56

			table.insert(arg0.mainShips, iter21)
			table.insert(var0.MainUnitList, var57)
		end

		for iter22, iter23 in ipairs(var47) do
			local var58 = iter23.id
			local var59 = WorldConst.FetchWorldShip(iter23.id).hpRant * 0.0001

			if table.contains(var5, var58) then
				BattleVertify.cloneShipVertiry = true
			end

			var5[#var5 + 1] = var58

			local var60 = var1(var1, iter23, var49)

			var60.initHPRate = var59

			table.insert(arg0.mainShips, iter23)
			table.insert(var0.VanguardUnitList, var60)
		end

		for iter24, iter25 in ipairs(var48) do
			local var61 = iter25.id
			local var62 = WorldConst.FetchWorldShip(iter25.id).hpRant * 0.0001

			if table.contains(var5, var61) then
				BattleVertify.cloneShipVertiry = true
			end

			var5[#var5 + 1] = var61

			local var63 = var1(var1, iter25, var50)

			var63.initHPRate = var62

			table.insert(arg0.mainShips, iter25)
			table.insert(var0.SubUnitList, var63)
		end

		arg0.viewComponent:setFleet(var46, var47, var48)

		local var64 = pg.expedition_data_template[arg0.contextData.stageId]

		if var64.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
			var0.WorldMapId = var37.config.expedition_map_id
			var0.WorldLevel = WorldConst.WorldLevelCorrect(var37.config.expedition_level, var64.type)
		end
	elseif var1 == SYSTEM_WORLD_BOSS then
		local var65 = nowWorld():GetBossProxy()
		local var66 = arg0.contextData.bossId
		local var67 = var65:GetFleet(var66)
		local var68 = var65:GetBossById(var66)

		assert(var68, var66)

		local var69 = var68:GetHP()

		if var69 then
			if var68:IsSelf() then
				var0.RepressInfo = {
					repressEnemyHpRant = var69 / var68:GetMaxHp()
				}
			else
				var0.RepressInfo = {
					repressEnemyHpRant = 1
				}
			end
		end

		local var70 = _.values(var67:getCommanders())

		var0.CommanderList = var67:buildBattleBuffList()
		arg0.mainShips = var4:getShipsByFleet(var67)

		local var71 = {}
		local var72 = {}
		local var73 = {}
		local var74 = var67:getTeamByName(TeamType.Main)

		for iter26, iter27 in ipairs(var74) do
			if table.contains(var5, iter27) then
				BattleVertify.cloneShipVertiry = true
			end

			var5[#var5 + 1] = iter27

			local var75 = var4:getShipById(iter27)
			local var76 = var1(var1, var75, var70)

			table.insert(var71, var75)
			table.insert(var0.MainUnitList, var76)
		end

		local var77 = var67:getTeamByName(TeamType.Vanguard)

		for iter28, iter29 in ipairs(var77) do
			if table.contains(var5, iter29) then
				BattleVertify.cloneShipVertiry = true
			end

			var5[#var5 + 1] = iter29

			local var78 = var4:getShipById(iter29)
			local var79 = var1(var1, var78, var70)

			table.insert(var72, var78)
			table.insert(var0.VanguardUnitList, var79)
		end

		arg0.viewComponent:setFleet(var71, var72, var73)

		var0.MapAidSkills = {}

		if var68:IsSelf() then
			local var80, var81, var82 = var65.GetSupportValue()

			if var80 then
				table.insert(var0.MapAidSkills, {
					level = 1,
					id = var82
				})
			end
		end
	elseif var1 == SYSTEM_HP_SHARE_ACT_BOSS or var1 == SYSTEM_ACT_BOSS or var1 == SYSTEM_ACT_BOSS_SP or var1 == SYSTEM_BOSS_EXPERIMENT then
		if arg0.contextData.mainFleetId then
			local var83 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.actId]
			local var84 = var83[arg0.contextData.mainFleetId]
			local var85 = _.values(var84:getCommanders())

			var0.CommanderList = var84:buildBattleBuffList()
			arg0.mainShips = {}

			local var86 = {}
			local var87 = {}
			local var88 = {}

			local function var89(arg0, arg1, arg2, arg3)
				if table.contains(var5, arg0) then
					BattleVertify.cloneShipVertiry = true
				end

				var5[#var5 + 1] = arg0

				local var0 = var4:getShipById(arg0)
				local var1 = var1(var1, var0, arg1)

				table.insert(arg0.mainShips, var0)
				table.insert(arg3, var0)
				table.insert(arg2, var1)
			end

			local var90 = var84:getTeamByName(TeamType.Main)
			local var91 = var84:getTeamByName(TeamType.Vanguard)

			for iter30, iter31 in ipairs(var90) do
				var89(iter31, var85, var0.MainUnitList, var86)
			end

			for iter32, iter33 in ipairs(var91) do
				var89(iter33, var85, var0.VanguardUnitList, var87)
			end

			local var92 = var83[arg0.contextData.mainFleetId + 10]
			local var93 = _.values(var92:getCommanders())
			local var94 = var92:getTeamByName(TeamType.Submarine)

			for iter34, iter35 in ipairs(var94) do
				var89(iter35, var93, var0.SubUnitList, var88)
			end

			local var95 = getProxy(PlayerProxy):getRawData()
			local var96 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId)
			local var97 = var96:getConfig("config_id")
			local var98 = pg.activity_event_worldboss[var97].use_oil_limit[arg0.contextData.mainFleetId]
			local var99 = var96:IsOilLimit(arg0.contextData.stageId)
			local var100 = 0
			local var101 = var3.oil_cost > 0

			local function var102(arg0, arg1)
				if var101 then
					local var0 = arg0:getEndCost().oil

					if arg1 > 0 then
						local var1 = arg0:getStartCost().oil

						cost = math.clamp(arg1 - var1, 0, var0)
					end

					var100 = var100 + var0
				end
			end

			if var1 == SYSTEM_ACT_BOSS_SP then
				local var103 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0.contextData.actId).buffIds
				local var104 = _.map(var103, function(arg0)
					return ActivityBossBuff.New({
						configId = arg0
					})
				end)

				var0.ExtraBuffList = _.map(_.select(var104, function(arg0)
					return arg0:CastOnEnemy()
				end), function(arg0)
					return arg0:GetBuffID()
				end)
				var0.ChapterBuffIDs = _.map(_.select(var104, function(arg0)
					return not arg0:CastOnEnemy()
				end), function(arg0)
					return arg0:GetBuffID()
				end)
			else
				var102(var84, var99 and var98[1] or 0)
				var102(var92, var99 and var98[2] or 0)
			end

			if var92:isLegalToFight() == true and (var1 == SYSTEM_BOSS_EXPERIMENT or var100 <= var95.oil) then
				var0.SubFlag = 1
				var0.TotalSubAmmo = 1
			end

			var0.SubCommanderList = var92:buildBattleBuffList()

			arg0.viewComponent:setFleet(var86, var87, var88)
		end
	elseif var1 == SYSTEM_GUILD then
		local var105 = getProxy(GuildProxy):getRawData():GetActiveEvent():GetBossMission()
		local var106 = var105:GetMainFleet()
		local var107 = _.values(var106:getCommanders())

		var0.CommanderList = var106:BuildBattleBuffList()
		arg0.mainShips = {}

		local var108 = {}
		local var109 = {}
		local var110 = {}

		local function var111(arg0, arg1, arg2, arg3)
			local var0 = var1(var1, arg0, arg1)

			table.insert(arg0.mainShips, arg0)
			table.insert(arg3, arg0)
			table.insert(arg2, var0)
		end

		local var112 = {}
		local var113 = {}
		local var114 = var106:GetShips()

		for iter36, iter37 in pairs(var114) do
			local var115 = iter37.ship

			if var115:getTeamType() == TeamType.Main then
				table.insert(var112, var115)
			elseif var115:getTeamType() == TeamType.Vanguard then
				table.insert(var113, var115)
			end
		end

		for iter38, iter39 in ipairs(var112) do
			var111(iter39, var107, var0.MainUnitList, var108)
		end

		for iter40, iter41 in ipairs(var113) do
			var111(iter41, var107, var0.VanguardUnitList, var109)
		end

		local var116 = var105:GetSubFleet()
		local var117 = _.values(var116:getCommanders())
		local var118 = {}
		local var119 = var116:GetShips()

		for iter42, iter43 in pairs(var119) do
			local var120 = iter43.ship

			if var120:getTeamType() == TeamType.Submarine then
				table.insert(var118, var120)
			end
		end

		for iter44, iter45 in ipairs(var118) do
			var111(iter45, var117, var0.SubUnitList, var110)
		end

		if #var110 > 0 then
			var0.SubFlag = 1
			var0.TotalSubAmmo = 1
		end

		var0.SubCommanderList = var116:BuildBattleBuffList()

		arg0.viewComponent:setFleet(var108, var109, var110)
	elseif var1 == SYSTEM_BOSS_RUSH or var1 == SYSTEM_BOSS_RUSH_EX then
		local var121 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId):GetSeriesData()

		assert(var121)

		local var122 = var121:GetStaegLevel() + 1
		local var123 = var121:GetFleetIds()
		local var124 = var123[var122]
		local var125 = var123[#var123]

		if var121:GetMode() == BossRushSeriesData.MODE.SINGLE then
			var124 = var123[1]
		end

		local var126 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.actId]

		arg0.mainShips = {}

		local var127 = {}
		local var128 = {}
		local var129 = {}

		local function var130(arg0, arg1, arg2, arg3)
			if table.contains(var5, arg0) then
				BattleVertify.cloneShipVertiry = true
			end

			var5[#var5 + 1] = arg0

			local var0 = var4:getShipById(arg0)
			local var1 = var1(var1, var0, arg1)

			table.insert(arg0.mainShips, var0)
			table.insert(arg3, var0)
			table.insert(arg2, var1)
		end

		local var131 = var126[var124]
		local var132 = _.values(var131:getCommanders())

		var0.CommanderList = var131:buildBattleBuffList()

		local var133 = var131:getTeamByName(TeamType.Main)
		local var134 = var131:getTeamByName(TeamType.Vanguard)

		for iter46, iter47 in ipairs(var133) do
			var130(iter47, var132, var0.MainUnitList, var127)
		end

		for iter48, iter49 in ipairs(var134) do
			var130(iter49, var132, var0.VanguardUnitList, var128)
		end

		local var135 = var126[var125]
		local var136 = _.values(var135:getCommanders())

		var0.SubCommanderList = var135:buildBattleBuffList()

		local var137 = var135:getTeamByName(TeamType.Submarine)

		for iter50, iter51 in ipairs(var137) do
			var130(iter51, var136, var0.SubUnitList, var129)
		end

		local var138 = getProxy(PlayerProxy):getRawData()
		local var139 = 0
		local var140 = var121:GetOilLimit()
		local var141 = var3.oil_cost > 0

		local function var142(arg0, arg1)
			local var0 = 0

			if var141 then
				local var1 = arg0:getStartCost().oil
				local var2 = arg0:getEndCost().oil

				var0 = var2

				if arg1 > 0 then
					var0 = math.clamp(arg1 - var1, 0, var2)
				end
			end

			return var0
		end

		local var143 = var139 + var142(var131, var140[1]) + var142(var135, var140[2])

		if var135:isLegalToFight() == true and var143 <= var138.oil then
			var0.SubFlag = 1
			var0.TotalSubAmmo = 1
		end

		arg0.viewComponent:setFleet(var127, var128, var129)
	elseif var1 == SYSTEM_LIMIT_CHALLENGE then
		local var144 = LimitChallengeConst.GetChallengeIDByStageID(arg0.contextData.stageId)

		var0.ExtraBuffList = AcessWithinNull(pg.expedition_constellation_challenge_template[var144], "buff_id")

		local var145 = FleetProxy.CHALLENGE_FLEET_ID
		local var146 = FleetProxy.CHALLENGE_SUB_FLEET_ID
		local var147 = getProxy(FleetProxy)
		local var148 = var147:getFleetById(var145)
		local var149 = var147:getFleetById(var146)

		arg0.mainShips = {}

		local var150 = {}
		local var151 = {}
		local var152 = {}

		local function var153(arg0, arg1, arg2, arg3)
			if table.contains(var5, arg0) then
				BattleVertify.cloneShipVertiry = true
			end

			var5[#var5 + 1] = arg0

			local var0 = var4:getShipById(arg0)
			local var1 = var1(var1, var0, arg1)

			table.insert(arg0.mainShips, var0)
			table.insert(arg3, var0)
			table.insert(arg2, var1)
		end

		local var154 = _.values(var148:getCommanders())

		var0.CommanderList = var148:buildBattleBuffList()

		local var155 = var148:getTeamByName(TeamType.Main)
		local var156 = var148:getTeamByName(TeamType.Vanguard)

		for iter52, iter53 in ipairs(var155) do
			var153(iter53, var154, var0.MainUnitList, var150)
		end

		for iter54, iter55 in ipairs(var156) do
			var153(iter55, var154, var0.VanguardUnitList, var151)
		end

		local var157 = _.values(var149:getCommanders())

		var0.SubCommanderList = var149:buildBattleBuffList()

		local var158 = var149:getTeamByName(TeamType.Submarine)

		for iter56, iter57 in ipairs(var158) do
			var153(iter57, var157, var0.SubUnitList, var152)
		end

		local var159 = getProxy(PlayerProxy):getRawData()
		local var160 = 0
		local var161 = var3.oil_cost > 0

		local function var162(arg0, arg1)
			local var0 = 0

			if var161 then
				local var1 = arg0:getStartCost().oil
				local var2 = arg0:getEndCost().oil

				var0 = var2

				if arg1 > 0 then
					var0 = math.clamp(arg1 - var1, 0, var2)
				end
			end

			return var0
		end

		local var163 = var160 + var162(var148, 0) + var162(var149, 0)

		if var149:isLegalToFight() == true and var163 <= var159.oil then
			var0.SubFlag = 1
			var0.TotalSubAmmo = 1
		end

		arg0.viewComponent:setFleet(var150, var151, var152)
	elseif var1 == SYSTEM_CARDPUZZLE then
		local var164 = {}
		local var165 = {}
		local var166 = arg0.contextData.relics

		for iter58, iter59 in ipairs(arg0.contextData.cardPuzzleFleet) do
			local var167 = var2(iter59, var166)
			local var168 = var167.fleetIndex

			if var168 == 1 then
				table.insert(var165, var167)
				table.insert(var0.VanguardUnitList, var167)
			elseif var168 == 2 then
				table.insert(var164, var167)
				table.insert(var0.MainUnitList, var167)
			end
		end

		var0.CardPuzzleCardIDList = arg0.contextData.cards
		var0.CardPuzzleCommonHPValue = arg0.contextData.hp
		var0.CardPuzzleRelicList = var166
		var0.CardPuzzleCombatID = arg0.contextData.puzzleCombatID
	elseif var1 == SYSTEM_BOSS_SINGLE then
		if arg0.contextData.mainFleetId then
			local var169 = getProxy(FleetProxy):getActivityFleets()[arg0.contextData.actId]
			local var170 = var169[arg0.contextData.mainFleetId]
			local var171 = _.values(var170:getCommanders())

			var0.CommanderList = var170:buildBattleBuffList()
			arg0.mainShips = {}

			local var172 = {}
			local var173 = {}
			local var174 = {}

			local function var175(arg0, arg1, arg2, arg3)
				if table.contains(var5, arg0) then
					BattleVertify.cloneShipVertiry = true
				end

				var5[#var5 + 1] = arg0

				local var0 = var4:getShipById(arg0)
				local var1 = var1(var1, var0, arg1)

				table.insert(arg0.mainShips, var0)
				table.insert(arg3, var0)
				table.insert(arg2, var1)
			end

			local var176 = var170:getTeamByName(TeamType.Main)
			local var177 = var170:getTeamByName(TeamType.Vanguard)

			for iter60, iter61 in ipairs(var176) do
				var175(iter61, var171, var0.MainUnitList, var172)
			end

			for iter62, iter63 in ipairs(var177) do
				var175(iter63, var171, var0.VanguardUnitList, var173)
			end

			local var178 = var169[arg0.contextData.mainFleetId + 10]
			local var179 = _.values(var178:getCommanders())
			local var180 = var178:getTeamByName(TeamType.Submarine)

			for iter64, iter65 in ipairs(var180) do
				var175(iter65, var179, var0.SubUnitList, var174)
			end

			local var181 = getProxy(PlayerProxy):getRawData()
			local var182 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId)

			var0.ChapterBuffIDs = var182:GetBuffIdsByStageId(arg0.contextData.stageId)

			local var183 = var182:GetEnemyDataByStageId(arg0.contextData.stageId):GetOilLimit()
			local var184 = 0
			local var185 = var3.oil_cost > 0

			local function var186(arg0, arg1)
				if var185 then
					local var0 = arg0:getEndCost().oil

					if arg1 > 0 then
						local var1 = arg0:getStartCost().oil

						cost = math.clamp(arg1 - var1, 0, var0)
					end

					var184 = var184 + var0
				end
			end

			var186(var170, var183[1] or 0)
			var186(var178, var183[2] or 0)

			if var178:isLegalToFight() == true and var184 <= var181.oil then
				var0.SubFlag = 1
				var0.TotalSubAmmo = 1
			end

			var0.SubCommanderList = var178:buildBattleBuffList()

			arg0.viewComponent:setFleet(var172, var173, var174)
		end
	elseif arg0.contextData.mainFleetId then
		local var187 = var1 == SYSTEM_DUEL
		local var188 = getProxy(FleetProxy)
		local var189
		local var190
		local var191 = var188:getFleetById(arg0.contextData.mainFleetId)

		arg0.mainShips = var4:getShipsByFleet(var191)

		local var192 = {}
		local var193 = {}
		local var194 = {}

		local function var195(arg0, arg1, arg2)
			for iter0, iter1 in ipairs(arg0) do
				if table.contains(var5, iter1) then
					BattleVertify.cloneShipVertiry = true
				end

				var5[#var5 + 1] = iter1

				local var0 = var4:getShipById(iter1)
				local var1 = var1(var1, var0, nil, var187)

				table.insert(arg1, var0)
				table.insert(arg2, var1)
			end
		end

		local var196 = var191:getTeamByName(TeamType.Main)
		local var197 = var191:getTeamByName(TeamType.Vanguard)
		local var198 = var191:getTeamByName(TeamType.Submarine)

		var195(var196, var192, var0.MainUnitList)
		var195(var197, var193, var0.VanguardUnitList)
		var195(var198, var194, var0.SubUnitList)
		arg0.viewComponent:setFleet(var192, var193, var194)

		if BATTLE_DEBUG and BATTLE_FREE_SUBMARINE then
			local var199 = var188:getFleetById(11)
			local var200 = var199:getTeamByName(TeamType.Submarine)

			if #var200 > 0 then
				var0.SubFlag = 1
				var0.TotalSubAmmo = 1

				local var201 = _.values(var199:getCommanders())

				var0.SubCommanderList = var199:buildBattleBuffList()

				for iter66, iter67 in ipairs(var200) do
					local var202 = var4:getShipById(iter67)
					local var203 = var1(var1, var202, var201, var187)

					table.insert(var194, var202)
					table.insert(var0.SubUnitList, var203)
				end
			end
		end
	end

	if var1 == SYSTEM_WORLD then
		local var204 = nowWorld()
		local var205 = var204:GetActiveMap()
		local var206 = var205:GetFleet()
		local var207 = var205:GetCell(var206.row, var206.column):GetStageEnemy()
		local var208 = pg.world_expedition_data[arg0.contextData.stageId]
		local var209 = var204:GetWorldMapDifficultyBuffLevel()

		var0.EnemyMapRewards = {
			var209[1] * (1 + var208.expedition_sairenvalueA / 10000),
			var209[2] * (1 + var208.expedition_sairenvalueB / 10000),
			var209[3] * (1 + var208.expedition_sairenvalueC / 10000)
		}
		var0.FleetMapRewards = var204:GetWorldMapBuffLevel()
	end

	var0.RivalMainUnitList, var0.RivalVanguardUnitList = {}, {}

	local var210

	if var1 == SYSTEM_DUEL and arg0.contextData.rivalId then
		local var211 = getProxy(MilitaryExerciseProxy)

		var210 = var211:getRivalById(arg0.contextData.rivalId)
		arg0.oldRank = var211:getSeasonInfo()
	end

	if var210 then
		var0.RivalVO = var210

		local var212 = 0

		for iter68, iter69 in ipairs(var210.mainShips) do
			var212 = var212 + iter69.level
		end

		for iter70, iter71 in ipairs(var210.vanguardShips) do
			var212 = var212 + iter71.level
		end

		BattleVertify = BattleVertify or {}
		BattleVertify.rivalLevel = var212

		for iter72, iter73 in ipairs(var210.mainShips) do
			if not iter73.hpRant or iter73.hpRant > 0 then
				local var213 = var1(var1, iter73, nil, true)

				if iter73.hpRant then
					var213.initHPRate = iter73.hpRant * 0.0001
				end

				table.insert(var0.RivalMainUnitList, var213)
			end
		end

		for iter74, iter75 in ipairs(var210.vanguardShips) do
			if not iter75.hpRant or iter75.hpRant > 0 then
				local var214 = var1(var1, iter75, nil, true)

				if iter75.hpRant then
					var214.initHPRate = iter75.hpRant * 0.0001
				end

				table.insert(var0.RivalVanguardUnitList, var214)
			end
		end
	end

	local var215 = arg0.contextData.prefabFleet.main_unitList
	local var216 = arg0.contextData.prefabFleet.vanguard_unitList
	local var217 = arg0.contextData.prefabFleet.submarine_unitList

	if var215 then
		for iter76, iter77 in ipairs(var215) do
			local var218 = {}

			for iter78, iter79 in ipairs(iter77.equipment) do
				var218[#var218 + 1] = {
					skin = 0,
					id = iter79
				}
			end

			local var219 = {
				id = iter77.id,
				tmpID = iter77.configId,
				skinId = iter77.skinId,
				level = iter77.level,
				equipment = var218,
				properties = iter77.properties,
				baseProperties = iter77.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter77.skills
			}

			table.insert(var0.MainUnitList, var219)
		end
	end

	if var216 then
		for iter80, iter81 in ipairs(var216) do
			local var220 = {}

			for iter82, iter83 in ipairs(iter81.equipment) do
				var220[#var220 + 1] = {
					skin = 0,
					id = iter83
				}
			end

			local var221 = {
				id = iter81.id,
				tmpID = iter81.configId,
				skinId = iter81.skinId,
				level = iter81.level,
				equipment = var220,
				properties = iter81.properties,
				baseProperties = iter81.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter81.skills
			}

			table.insert(var0.VanguardUnitList, var221)
		end
	end

	if var217 then
		for iter84, iter85 in ipairs(var217) do
			local var222 = {}

			for iter86, iter87 in ipairs(iter85.equipment) do
				var222[#var222 + 1] = {
					skin = 0,
					id = iter87
				}
			end

			local var223 = {
				id = iter85.id,
				tmpID = iter85.configId,
				skinId = iter85.skinId,
				level = iter85.level,
				equipment = var222,
				properties = iter85.properties,
				baseProperties = iter85.properties,
				proficiency = {
					1,
					1,
					1
				},
				skills = iter85.skills
			}

			table.insert(var0.SubUnitList, var223)

			if var1 == SYSTEM_SIMULATION and #var0.SubUnitList > 0 then
				var0.SubFlag = 1
				var0.TotalSubAmmo = 1
			end
		end
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.FINISH_STAGE_DONE,
		GAME.FINISH_STAGE_ERROR,
		GAME.STORY_BEGIN,
		GAME.STORY_END,
		GAME.END_GUIDE,
		GAME.START_GUIDE,
		GAME.PAUSE_BATTLE,
		GAME.RESUME_BATTLE,
		var0.CLOSE_CHAT,
		GAME.QUIT_BATTLE,
		var0.HIDE_ALL_BUTTONS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = ys.Battle.BattleState.GetInstance()
	local var3 = arg0.contextData.system

	if var0 == GAME.FINISH_STAGE_DONE then
		pg.MsgboxMgr.GetInstance():hide()

		local var4 = var1.system

		if var4 == SYSTEM_PROLOGUE then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.CREATE_PLAYER)
		elseif var4 == SYSTEM_PERFORM or var4 == SYSTEM_SIMULATION then
			ys.Battle.BattleState.GetInstance():Deactive()
			arg0.viewComponent:exitBattle()

			if var1.exitCallback then
				var1.exitCallback()
			end
		else
			local var5 = BattleResultMediator.GetResultView(var4)
			local var6 = {}

			if var4 == SYSTEM_SCENARIO then
				var6 = getProxy(ChapterProxy):getActiveChapter().operationBuffList
			end

			arg0:addSubLayers(Context.New({
				mediator = NewBattleResultMediator,
				viewComponent = NewBattleResultScene,
				data = {
					system = var4,
					rivalId = arg0.contextData.rivalId,
					mainFleetId = arg0.contextData.mainFleetId,
					stageId = arg0.contextData.stageId,
					oldMainShips = arg0.mainShips or {},
					oldPlayer = arg0.player,
					oldRank = arg0.oldRank,
					statistics = var1.statistics,
					score = var1.score,
					drops = var1.drops,
					bossId = var1.bossId,
					name = var1.name,
					prefabFleet = var1.prefabFleet,
					commanderExps = var1.commanderExps,
					actId = arg0.contextData.actId,
					result = var1.result,
					extraDrops = var1.extraDrops,
					extraBuffList = var6,
					isLastBonus = var1.isLastBonus,
					continuousBattleTimes = arg0.contextData.continuousBattleTimes,
					totalBattleTimes = arg0.contextData.totalBattleTimes,
					mode = arg0.contextData.mode,
					cmdArgs = arg0.contextData.cmdArgs
				}
			}))
		end
	elseif var0 == GAME.STORY_BEGIN then
		var2:Pause()
	elseif var0 == GAME.STORY_END then
		var2:Resume()
	elseif var0 == GAME.START_GUIDE then
		var2:Pause()
	elseif var0 == GAME.END_GUIDE then
		var2:Resume()
	elseif var0 == GAME.PAUSE_BATTLE then
		if not var2:IsPause() then
			arg0:onPauseBtn()
		end
	elseif var0 == GAME.RESUME_BATTLE then
		var2:Resume()
	elseif var0 == GAME.FINISH_STAGE_ERROR then
		gcAll(true)

		local var7 = getProxy(ContextProxy)
		local var8 = var7:getContextByMediator(DailyLevelMediator)
		local var9 = var7:getContextByMediator(LevelMediator2)
		local var10 = var7:getContextByMediator(ChallengeMainMediator)
		local var11 = var7:getContextByMediator(ActivityBossMediatorTemplate)

		if var8 then
			local var12 = var8:getContextByMediator(PreCombatMediator)

			var8:removeChild(var12)
		elseif var10 then
			local var13 = var10:getContextByMediator(ChallengePreCombatMediator)

			var10:removeChild(var13)
		elseif var9 then
			if var3 == SYSTEM_DUEL then
				-- block empty
			elseif var3 == SYSTEM_SCENARIO then
				local var14 = var9:getContextByMediator(ChapterPreCombatMediator)

				var9:removeChild(var14)
			elseif var3 ~= SYSTEM_PERFORM and var3 ~= SYSTEM_SIMULATION then
				local var15 = var9:getContextByMediator(PreCombatMediator)

				if var15 then
					var9:removeChild(var15)
				end
			end
		elseif var11 then
			local var16 = var11:getContextByMediator(PreCombatMediator)

			if var16 then
				var11:removeChild(var16)
			end
		end

		arg0:sendNotification(GAME.GO_BACK)
	elseif var0 == var0.CLOSE_CHAT then
		arg0.viewComponent:OnCloseChat()
	elseif var0 == var0.HIDE_ALL_BUTTONS then
		ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name):DispatchEvent(ys.Event.New(ys.Battle.BattleEvent.HIDE_INTERACTABLE_BUTTONS, {
			isActive = var1
		}))
	elseif var0 == GAME.QUIT_BATTLE then
		var2:Stop()
	end
end

function var0.remove(arg0)
	pg.BrightnessMgr.GetInstance():SetScreenNeverSleep(false)
end

return var0
