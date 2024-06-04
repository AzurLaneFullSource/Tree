local var0 = class("BattleScene", import("..base.BaseUI"))

var0.IN_VIEW_FRIEND_SKILL_OFFSET = Vector3(-5, 0, 6)
var0.IN_VIEW_FOE_SKILL_OFFSET = Vector3(-15, 0, 6)
var0.FOE_SIDE_X_OFFSET = 250
var0.SKILL_FLOAT_SCALE = Vector3(1.5, 1.5, 0)
var0.SIDE_ALIGNMENT = {
	{
		-120,
		-7.5,
		-232.5
	},
	{
		105,
		217.5,
		330
	},
	{
		-345,
		-457.5,
		-570
	}
}

local var1

function var0.getUIName(arg0)
	return "CombatUI"
end

function var0.getBGM(arg0)
	local var0 = {}

	table.insert(var0, arg0.contextData.system == SYSTEM_WORLD and checkExist(pg.world_expedition_data[arg0.contextData.stageId], {
		"bgm"
	}) or "")
	table.insert(var0, pg.expedition_data_template[arg0.contextData.stageId].bgm)

	for iter0, iter1 in ipairs(var0) do
		if iter1 ~= "" then
			return iter1
		end
	end

	return var0.super.getBGM(arg0)
end

function var0.init(arg0)
	var1 = ys.Battle.BattleVariable

	local var0 = pg.UIMgr.GetInstance():GetMainCamera()
	local var1 = GameObject.Find("UICamera")

	arg0.uiCanvas = findTF(var1, "Canvas/UIMain")
	arg0.skillTips = arg0:findTF("Skill_Activation")
	arg0.skillRoot = arg0:findTF("Skill_Activation/Root")
	arg0.skillTpl = arg0:findTF("Skill_Activation/mask").gameObject
	arg0._skillFloatPool = pg.Pool.New(arg0.skillRoot, arg0.skillTpl, 15, 10, true, false):InitSize()
	arg0.skillCMDRoot = arg0:findTF("Skill_Activation/Root_cmd")
	arg0.skillCMDTpl = arg0:findTF("Skill_Activation/mask_cmd").gameObject
	arg0._skillFloatCMDPool = pg.Pool.New(arg0.skillCMDRoot, arg0.skillCMDTpl, 2, 4, true, false):InitSize()
	arg0.popupTpl = arg0:getTpl("popup")

	SetActive(arg0._go, false)

	arg0._skillPaintings = {}
	arg0._skillFloat = true
	arg0._cacheSkill = {}
	arg0._commanderSkillList = {}
	arg0._sideSkillFloatStateList = {}
	arg0._sideSkillFloatStateList[ys.Battle.BattleConfig.FRIENDLY_CODE] = {
		{},
		{},
		{}
	}
	arg0._sideSkillFloatStateList[ys.Battle.BattleConfig.FOE_CODE] = {
		{},
		{},
		{}
	}

	arg0:initPainting()

	arg0._fxContainerUpper = arg0._tf:Find("FXContainerUpper")
	arg0._fxContainerBottom = arg0._tf:Find("FXContainerBottom")

	local var2 = arg0._tf:GetComponentInParent(typeof(UnityEngine.Canvas))

	arg0._canvasOrder = var2 and var2.sortingOrder or 0
	arg0._ratioFitter = GetComponent(arg0._tf, typeof(AspectRatioFitter))
end

function var0.initPainting(arg0)
	local var0 = ys.Battle.BattleResourceManager.GetInstance():InstSkillPaintingUI()

	setParent(var0, arg0.uiCanvas, false)

	arg0._paintingUI = var0
	arg0._paintingAnimator = var0:GetComponent(typeof(Animator))
	arg0._paintingAnimator.enabled = false
	arg0._paintingParticleContainer = findTF(var0, "particleContainer")
	arg0._paintingParticles = findTF(arg0._paintingParticleContainer, "effect")
	arg0._paintingParticleSystem = arg0._paintingParticles:GetComponent(typeof(ParticleSystem))

	arg0._paintingParticleSystem:Stop(true)

	arg0._paintingFitter = findTF(var0, "hero/fitter")

	removeAllChildren(arg0._paintingFitter)

	local var1 = GetOrAddComponent(arg0._paintingFitter, "PaintingScaler")

	var1.FrameName = "lihuisha"
	var1.Tween = 1

	var0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		if arg0._currentPainting then
			setActive(arg0._currentPainting, false)

			arg0._currentPainting = nil
		end
	end)
end

function var0.EnableSkillFloat(arg0, arg1)
	if arg1 == arg0._skillFloat then
		return
	end

	arg0._skillFloat = arg1

	if arg0._skillFloat then
		for iter0, iter1 in ipairs(arg0._cacheSkill) do
			arg0:SkillHrzPop(iter1.skillName, iter1.caster, iter1.commander, iter1.hrzIcon)
		end

		arg0._cacheSkill = {}
	else
		arg0._skillFloatPool:AllRecycle()
		arg0._skillFloatCMDPool:AllRecycle()

		arg0._preCommanderSkillTF = nil
		arg0._preSkillTF = nil
	end

	SetActive(arg0.skillTips, arg1)
end

function var0.SkillHrzPop(arg0, arg1, arg2, arg3, arg4)
	if not arg0._skillFloat then
		table.insert(arg0._cacheSkill, {
			skillName = arg1,
			caster = arg2,
			commander = arg3,
			hrzIcon = arg4
		})

		return
	end

	local var0 = ys.Battle.BattleResourceManager.GetInstance()
	local var1
	local var2

	if arg3 then
		if arg0._commanderSkillList[arg3] and arg0._commanderSkillList[arg3][arg1] then
			return
		end

		var1 = arg0._skillFloatCMDPool
		var2 = var0:GetCommanderHrzIcon(arg3)
	else
		var1 = arg0._skillFloatPool

		if arg2:GetUnitType() == ys.Battle.BattleConst.UnitType.PLAYER_UNIT then
			local var3 = arg4 or arg2:GetTemplate().painting

			var2 = var0:GetCharacterIcon(var3)
		else
			var2 = var0:GetCharacterIcon(pg.enemy_data_statistics[arg2:GetTemplateID()].icon)
		end
	end

	local var4 = var1:GetObject()
	local var5 = var4.transform

	var5.localScale = var0.SKILL_FLOAT_SCALE

	setText(findTF(var5, "skill/skill_name/Text"), HXSet.hxLan(arg1))

	local var6 = findTF(var5, "skill/icon")
	local var7 = findTF(var5, "skill/skill_name")

	var6:GetComponent(typeof(Image)).sprite = var2

	local var8, var9 = arg2:GetIFF()

	if arg2:GetIFF() == ys.Battle.BattleConfig.FRIENDLY_CODE then
		var9 = Color.New(1, 1, 1, 1)
	else
		var9 = Color.New(1, 0.33, 0.33, 1)
	end

	var7:GetComponent(typeof(Image)).color = var9
	findTF(var5, "skill"):GetComponent(typeof(Image)).color = var9

	if arg3 then
		arg0:commanderSkillFloat(arg3, arg1, var4)
	else
		local var10 = var1.CameraPosToUICamera(arg2:GetPosition():Clone())
		local var11 = ys.Battle.BattleCameraUtil.GetInstance():GetCharacterArrowBarPosition(var10)
		local var12 = table.contains(TeamType.SubShipType, arg2:GetTemplate().type)
		local var13 = arg2:GetMainUnitIndex()

		if var11 == nil or var11 == nil and var12 and not arg2:IsMainFleetUnit() then
			if var8 == ys.Battle.BattleConfig.FRIENDLY_CODE then
				var10 = var1.CameraPosToUICamera(arg2:GetPosition():Clone():Add(var0.IN_VIEW_FRIEND_SKILL_OFFSET))
			else
				var10 = var1.CameraPosToUICamera(arg2:GetPosition():Clone():Add(var0.IN_VIEW_FOE_SKILL_OFFSET))
			end

			var5.position = Vector3(var10.x, var10.y, -2)

			local var14 = rtf(var5).rect.width * 0.5
			local var15 = var5.anchoredPosition
			local var16 = var15.x

			if Screen.width * 0.5 < var14 + var16 then
				var15.x = var16 - rtf(var5).rect.width
				var5.anchoredPosition = var15
			end

			if arg0._preSkillTF then
				arg0.handleSkillFloatCld(arg0._preSkillTF, var5)
			end

			arg0._preSkillTF = var5

			var5:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
				arg0._preSkillTF = nil

				var1:Recycle(var4)
			end)
		else
			local var17
			local var18 = var0.SIDE_ALIGNMENT[var13]
			local var19 = arg0._sideSkillFloatStateList[var8][var13]

			for iter0 = 1, #var19 do
				if var19[iter0] then
					var17 = iter0

					break
				end
			end

			if var17 == nil then
				var17 = #var19 + 1
			end

			var19[var17] = false
			var5.position = var11

			local var20 = var5.anchoredPosition

			var20.y = var18[var17]

			if var8 == ys.Battle.BattleConfig.FOE_CODE then
				var20.x = var0.FOE_SIDE_X_OFFSET
			end

			var5.anchoredPosition = var20

			var5:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
				var19[var17] = true

				var1:Recycle(var4)
			end)
		end
	end
end

function var0.SkillHrzPopCover(arg0, arg1, arg2, arg3)
	arg0:SkillHrzPop(arg1, arg2, nil, arg3)
end

function var0.handleSkillFloatCld(arg0, arg1)
	local var0 = arg1.anchoredPosition
	local var1 = arg0.anchoredPosition.y

	if math.floor(math.abs(var0.y - var1)) <= 112.5 then
		var0.y = var1 + 112.5
		arg1.anchoredPosition = var0
	end
end

function var0.handleSkillSinkCld(arg0, arg1)
	return
end

function var0.commanderSkillFloat(arg0, arg1, arg2, arg3)
	arg0._commanderSkillList[arg1] = arg0._commanderSkillList[arg1] or {}
	arg0._commanderSkillList[arg1][arg2] = true

	local var0 = arg3.transform
	local var1 = var0.anchoredPosition

	var1.x = 0
	var1.y = 0
	var0.anchoredPosition = var1

	if arg0._preCommanderSkillTF then
		local var2 = arg0._preCommanderSkillTF.anchoredPosition.y

		if math.floor(math.abs(var1.y - var2)) <= 97.5 then
			var1.y = var2 - 97.5
		end
	end

	var0.anchoredPosition = var1
	arg0._preCommanderSkillTF = var0

	var0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0)
		arg0._commanderSkillList[arg1][arg2] = nil
		arg0._preCommanderSkillTF = nil

		arg0._skillFloatCMDPool:Recycle(arg3)
	end)
end

function var0.CutInPainting(arg0, arg1, arg2, arg3, arg4)
	if arg0._currentPainting then
		arg0._paintingAnimator.enabled = false

		setActive(arg0._currentPainting, false)
	end

	local var0 = arg4 or arg1.painting or arg1.prefab

	if arg0._skillPaintings[var0] == nil then
		local var1 = ys.Battle.BattleResourceManager.GetInstance():InstPainting(var0)

		arg0._skillPaintings[var0] = var1

		setParent(var1, arg0._paintingFitter, false)
	end

	arg0._currentPainting = arg0._skillPaintings[var0]

	setActive(arg0._currentPainting, true)
	LuaHelper.SetParticleSpeed(arg0._paintingUI, arg2)

	local var2 = Vector3(arg3, 1, 1)

	arg0._paintingUI.transform.localScale = var2
	arg0._paintingParticleContainer.transform.localScale = var2
	arg0._paintingParticles.transform.localEulerAngles = Vector3(0, 90 * arg3, 0)

	arg0._paintingParticleSystem:Play(true)

	arg0._paintingAnimator.speed = arg2
	arg0._paintingAnimator.enabled = true

	arg0._paintingAnimator:Play("skill_painting", -1, 0)
end

function var0.didEnter(arg0)
	setActive(arg0._tf, false)

	arg0._ratioFitter.enabled = true
	arg0._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	arg0.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0, arg1)
		arg0._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	end)

	local var0 = ys.Battle.BattleState.GetInstance()

	var0:SetBattleUI(arg0)
	onButton(arg0, arg0:findTF("PauseBtn"), function()
		arg0:emit(BattleMediator.ON_PAUSE)
	end, SFX_CONFIRM)

	local var1 = arg0:findTF("chatBtn")

	onButton(arg0, var1, function()
		arg0:emit(BattleMediator.ON_CHAT, arg0:findTF("chatContainer"))
		setActive(var1, false)
	end)
	onToggle(arg0, arg0:findTF("AutoBtn"), function(arg0)
		local var0 = var0:GetBattleType()

		arg0:emit(BattleMediator.ON_AUTO, {
			isOn = not arg0,
			toggle = arg0:findTF("AutoBtn"),
			system = var0
		})
		var0:ActiveBot(ys.Battle.BattleState.IsAutoBotActive(var0))
		setActive(var1, var0:ChatUseable())
	end, SFX_PANEL, SFX_PANEL)
	onButton(arg0, arg0:findTF("CardPuzzleConsole/relic/bg"), function()
		local var0 = var0:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent():GetRelicList()

		arg0:emit(BattleMediator.ON_PUZZLE_RELIC, {
			relicList = var0
		})
	end, SFX_CONFIRM)
	onButton(arg0, arg0:findTF("CardPuzzleConsole/deck/bg"), function()
		local var0 = var0:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent()
		local var1 = var0:GetDeck():GetCardList()
		local var2 = var0:GetHand():GetCardList()

		arg0:emit(BattleMediator.ON_PUZZLE_CARD, {
			card = var1,
			hand = var2
		})
	end, SFX_CONFIRM)
	var0:ConfigBattleEndFunc(function(arg0)
		arg0:clear()
		arg0:emit(BattleMediator.ON_BATTLE_RESULT, arg0)
	end)

	local var2 = ys.Battle.BattleConst.BuffEffectType
	local var3 = {
		var2.ON_START_GAME,
		var2.ON_FLAG_SHIP,
		var2.ON_CONSORT,
		var2.ON_LEADER,
		var2.ON_REAR,
		var2.ON_SUB_LEADER,
		var2.ON_SUB_CONSORT
	}
	local var4 = 0

	local function var5(arg0)
		local var0 = 0

		for iter0, iter1 in ipairs(arg0) do
			var0 = var0 + ys.Battle.BattleDataFunction.GetShipSkillTriggerCount(iter1, var3)
		end

		return var0
	end

	local var6 = var4 + var5(arg0.contextData.battleData.MainUnitList) + var5(arg0.contextData.battleData.VanguardUnitList) + var5(arg0.contextData.battleData.SubUnitList) + 4

	arg0._skillFloatPool = pg.Pool.New(arg0.skillRoot, arg0.skillTpl, var6, 10, true, false):InitSize()

	arg0:emit(BattleMediator.ENTER)
	arg0:initPauseWindow()

	if arg0.contextData.prePause then
		triggerButton(arg0:findTF("PauseBtn"))
	end

	setActive(var1, var0:ChatUseable())
end

function var0.onBackPressed(arg0)
	if isActive(arg0.pauseWindow) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0.continueBtn)
	end
end

function var0.activeBotHelp(arg0, arg1)
	local var0 = getProxy(PlayerProxy)

	if not arg1 then
		if arg0.autoBotHelp then
			pg.MsgboxMgr.GetInstance():hide()
		end

		return
	end

	if var0.botHelp then
		return
	end

	arg0.autoBotHelp = true

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		type = MSGBOX_TYPE_HELP,
		helps = i18n("help_battle_auto"),
		custom = {
			{
				text = "text_iknow",
				sound = SFX_CANCEL
			}
		},
		onClose = function()
			arg0.autoBotHelp = false
		end
	})

	var0.botHelp = true
end

function var0.exitBattle(arg0, arg1)
	if not arg1 then
		arg0:emit(BattleMediator.ON_QUIT_BATTLE_MANUALLY)
		arg0:emit(BattleMediator.ON_BACK_PRE_SCENE)
	elseif arg1 == "kick" then
		-- block empty
	end
end

function var0.setChapter(arg0, arg1)
	arg0._chapter = arg1
end

function var0.setFleet(arg0, arg1, arg2)
	arg0._mainShipVOs = arg1
	arg0._vanShipVOs = arg2
end

function var0.initPauseWindow(arg0)
	arg0.pauseWindow = arg0:findTF("Msgbox")
	arg0.LeftTimeContainer = arg0:findTF("window/LeftTime", arg0.pauseWindow)
	arg0.LeftTime = arg0:findTF("window/LeftTime/Text", arg0.pauseWindow)
	arg0.mainTFs = {}
	arg0.vanTFs = {}

	local function var0(arg0, arg1, arg2)
		for iter0 = 1, 3 do
			local var0 = arg1:Find("ship_" .. iter0)

			setActive(var0, arg2 and iter0 <= #arg2)

			if arg2 and iter0 <= #arg2 then
				updateShip(var0, arg2[iter0])
			end

			table.insert(arg0 and arg0.mainTFs or arg0.vanTFs, var0)
		end

		if arg2 then
			local var1 = 0

			for iter1, iter2 in ipairs(arg2) do
				var1 = var1 + iter2:getShipCombatPower()
			end

			setText(arg1:Find("power/value"), var1)
		end
	end

	if arg0._mainShipVOs then
		var0(true, arg0:findTF("window/main", arg0.pauseWindow), arg0._mainShipVOs)
		var0(false, arg0:findTF("window/van", arg0.pauseWindow), arg0._vanShipVOs)
	end

	local var1 = ys.Battle.BattleState.GetInstance()
	local var2 = findTF(arg0.pauseWindow, "window/Chapter")
	local var3 = findTF(arg0.pauseWindow, "window/Chapter/Text")

	arg0.continueBtn = arg0:findTF("window/button_container/continue", arg0.pauseWindow)
	arg0.leaveBtn = arg0:findTF("window/button_container/leave", arg0.pauseWindow)

	local var4 = var1:GetBattleType()

	if var4 == SYSTEM_SCENARIO then
		local var5 = arg0._chapter:getConfigTable()

		setText(var2, var5.chapter_name)
		setText(var3, string.split(var5.name, "|")[1])
	elseif var4 == SYSTEM_ROUTINE or var4 == SYSTEM_DUEL or var4 == SYSTEM_HP_SHARE_ACT_BOSS or var4 == SYSTEM_BOSS_EXPERIMENT or var4 == SYSTEM_ACT_BOSS or var4 == SYSTEM_ACT_BOSS_SP or var4 == SYSTEM_BOSS_RUSH or var4 == SYSTEM_BOSS_RUSH_EX or var4 == SYSTEM_LIMIT_CHALLENGE or var4 == SYSTEM_BOSS_SINGLE then
		setText(var2, "SP")

		local var6 = var1:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().StageTmpId
		local var7 = pg.expedition_data_template[var6]

		setText(var3, var7.name)
	elseif var4 == SYSTEM_DEBUG then
		setText(var2, "??")
		setText(var3, "碧蓝梦境")
	elseif var4 == SYSTEM_CHALLENGE then
		local var8 = arg0._chapter:getNextExpedition()

		setText(var2, "SP")
		setText(var3, var8.chapter_name[2])
		setActive(arg0.LeftTimeContainer, true)
	elseif var4 == SYSTEM_WORLD_BOSS or var4 == SYSTEM_WORLD then
		setText(var2, i18n("world_battle_pause"))
		setText(var3, i18n("world_battle_pause2"))

		if var4 == SYSTEM_WORLD_BOSS then
			setActive(arg0.leaveBtn, false)
		end
	elseif var4 == SYSTEM_GUILD then
		local var9 = var1:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().ActID
		local var10 = pg.guild_boss_event[var9]

		setText(var2, "BOSS")
		setText(var3, var10 and var10.name or "")
	elseif var4 == SYSTEM_TEST or var4 == SYSTEM_SUB_ROUTINE or var4 == SYSTEM_PERFORM or var4 == SYSTEM_PROLOGUE or var4 == SYSTEM_DODGEM or var4 == SYSTEM_SIMULATION or var4 == SYSTEM_SUBMARINE_RUN or var4 == SYSTEM_BOSS_EXPERIMENT or var4 == SYSTEM_REWARD_PERFORM or var4 == SYSTEM_AIRFIGHT then
		-- block empty
	elseif var4 == SYSTEM_CARDPUZZLE then
		-- block empty
	else
		assert(false, "System not defined " .. (var4 or "NIL"))
	end

	onButton(arg0, arg0.leaveBtn, function()
		arg0:emit(BattleMediator.ON_LEAVE)
	end)
	onButton(arg0, arg0.continueBtn, function()
		setActive(arg0.pauseWindow, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.pauseWindow, arg0._tf)
		var1:Resume()
	end)
	onButton(arg0, arg0:findTF("help", arg0.pauseWindow), function()
		if BATTLE_DEBUG and PLATFORM == 7 then
			setActive(arg0.pauseWindow, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0.pauseWindow, arg0._tf)
			var1:Resume()
			var1:OpenConsole()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("help_battle_rule")
			})
		end
	end)
	onButton(arg0, arg0:findTF("window/top/btnBack", arg0.pauseWindow), function()
		triggerButton(arg0.continueBtn)
	end)
	onButton(arg0, arg0.pauseWindow, function()
		triggerButton(arg0.continueBtn)
	end)
	setActive(arg0.pauseWindow, false)
end

function var0.updatePauseWindow(arg0)
	if not arg0.pauseWindow then
		return
	end

	setActive(arg0.pauseWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.pauseWindow, nil, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	local var0 = ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name)
	local var1 = var0:GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE)
	local var2 = var1:GetMainList()
	local var3 = var1:GetScoutList()

	local function var4(arg0, arg1, arg2)
		if not arg0 then
			return
		end

		for iter0 = 1, #arg0 do
			local var0 = arg0[iter0].id

			if var1:GetFreezeShipByID(var0) then
				local var1 = var1:GetFreezeShipByID(var0)

				setSlider(arg2[iter0]:Find("blood"), 0, 1, var1:GetHPRate())
				SetActive(arg2[iter0]:Find("mask"), false)
			elseif var1:GetShipByID(var0) then
				local var2 = var1:GetShipByID(var0)

				setSlider(arg2[iter0]:Find("blood"), 0, 1, var2:GetHPRate())
				SetActive(arg2[iter0]:Find("mask"), false)
			else
				setSlider(arg2[iter0]:Find("blood"), 0, 1, 0)
				SetActive(arg2[iter0]:Find("mask"), true)
			end
		end
	end

	var4(arg0._mainShipVOs, var2, arg0.mainTFs)
	var4(arg0._vanShipVOs, var3, arg0.vanTFs)
	setText(arg0.LeftTime, ys.Battle.BattleTimerView.formatTime(math.floor(var0:GetCountDown())))
end

function var0.AddUIFX(arg0, arg1, arg2)
	arg2 = arg2 or 1

	local var0 = arg2 > 0

	arg1 = tf(arg1)

	local var1 = var0 and arg0._fxContainerUpper or arg0._fxContainerBottom

	arg1:SetParent(var1)
	pg.ViewUtils.SetSortingOrder(arg1, arg0._canvasOrder + arg2)
	pg.ViewUtils.SetLayer(arg1, Layer.UI)

	return var1.localScale
end

function var0.OnCloseChat(arg0)
	local var0 = arg0:findTF("chatBtn")

	setActive(var0, ys.Battle.BattleState.GetInstance():IsBotActive())
end

function var0.clear(arg0)
	arg0._preSkillTF = nil
	arg0._preCommanderSkillTF = nil
	arg0._commanderSkillList = nil
	arg0._skillPaintings = nil
	arg0._currentPainting = nil

	Destroy(arg0._paintingUI)
end

function var0.willExit(arg0)
	arg0._skillFloatPool:Dispose()
	arg0._skillFloatCMDPool:Dispose()
	ys.Battle.BattleState.GetInstance():ExitBattle()
	pg.UIMgr.GetInstance():UnblurPanel(arg0.pauseWindow, arg0._tf)
	pg.CameraFixMgr.GetInstance():disconnect(arg0.camEventId)
end

return var0
