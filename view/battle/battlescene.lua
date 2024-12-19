local var0_0 = class("BattleScene", import("..base.BaseUI"))

var0_0.IN_VIEW_FRIEND_SKILL_OFFSET = Vector3(-5, 0, 6)
var0_0.IN_VIEW_FOE_SKILL_OFFSET = Vector3(-15, 0, 6)
var0_0.FOE_SIDE_X_OFFSET = 250
var0_0.SKILL_FLOAT_SCALE = Vector3(1.5, 1.5, 0)
var0_0.SIDE_ALIGNMENT = {
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

local var1_0

function var0_0.getUIName(arg0_1)
	return "CombatUI" .. ys.Battle.BattleState.GetCombatSkinKey()
end

function var0_0.getBGM(arg0_2)
	local var0_2 = {}

	table.insert(var0_2, arg0_2.contextData.system == SYSTEM_WORLD and checkExist(pg.world_expedition_data[arg0_2.contextData.stageId], {
		"bgm"
	}) or "")
	table.insert(var0_2, pg.expedition_data_template[arg0_2.contextData.stageId].bgm)

	for iter0_2, iter1_2 in ipairs(var0_2) do
		if iter1_2 ~= "" then
			return iter1_2
		end
	end

	return var0_0.super.getBGM(arg0_2)
end

function var0_0.init(arg0_3)
	var1_0 = ys.Battle.BattleVariable

	local var0_3 = pg.UIMgr.GetInstance():GetMainCamera()
	local var1_3 = GameObject.Find("UICamera")

	arg0_3.uiCanvas = findTF(var1_3, "Canvas/UIMain")
	arg0_3.skillTips = arg0_3:findTF("Skill_Activation")
	arg0_3.skillRoot = arg0_3:findTF("Skill_Activation/Root")
	arg0_3.skillTpl = arg0_3:findTF("Skill_Activation/mask").gameObject
	arg0_3._skillFloatPool = pg.Pool.New(arg0_3.skillRoot, arg0_3.skillTpl, 15, 10, true, false):InitSize()
	arg0_3.skillCMDRoot = arg0_3:findTF("Skill_Activation/Root_cmd")
	arg0_3.skillCMDTpl = arg0_3:findTF("Skill_Activation/mask_cmd").gameObject
	arg0_3._skillFloatCMDPool = pg.Pool.New(arg0_3.skillCMDRoot, arg0_3.skillCMDTpl, 2, 4, true, false):InitSize()
	arg0_3.popupTpl = arg0_3:getTpl("popup")

	SetActive(arg0_3._go, false)

	arg0_3._skillPaintings = {}
	arg0_3._skillFloat = true
	arg0_3._cacheSkill = {}
	arg0_3._commanderSkillList = {}
	arg0_3._sideSkillFloatStateList = {}
	arg0_3._sideSkillFloatStateList[ys.Battle.BattleConfig.FRIENDLY_CODE] = {
		{},
		{},
		{}
	}
	arg0_3._sideSkillFloatStateList[ys.Battle.BattleConfig.FOE_CODE] = {
		{},
		{},
		{}
	}

	arg0_3:initPainting()

	arg0_3._fxContainerUpper = arg0_3._tf:Find("FXContainerUpper")
	arg0_3._fxContainerBottom = arg0_3._tf:Find("FXContainerBottom")

	local var2_3 = arg0_3._tf:GetComponentInParent(typeof(UnityEngine.Canvas))

	arg0_3._canvasOrder = var2_3 and var2_3.sortingOrder or 0
	arg0_3._ratioFitter = GetComponent(arg0_3._tf, typeof(AspectRatioFitter))
end

function var0_0.initPainting(arg0_4)
	local var0_4 = ys.Battle.BattleResourceManager.GetInstance():InstSkillPaintingUI()

	setParent(var0_4, arg0_4.uiCanvas, false)

	arg0_4._paintingUI = var0_4
	arg0_4._paintingAnimator = var0_4:GetComponent(typeof(Animator))
	arg0_4._paintingAnimator.enabled = false
	arg0_4._paintingParticleContainer = findTF(var0_4, "particleContainer")
	arg0_4._paintingParticles = findTF(arg0_4._paintingParticleContainer, "effect")
	arg0_4._paintingParticleSystem = arg0_4._paintingParticles:GetComponent(typeof(ParticleSystem))

	arg0_4._paintingParticleSystem:Stop(true)

	arg0_4._paintingFitter = findTF(var0_4, "hero/fitter")

	removeAllChildren(arg0_4._paintingFitter)

	local var1_4 = GetOrAddComponent(arg0_4._paintingFitter, "PaintingScaler")

	var1_4.FrameName = "lihuisha"
	var1_4.Tween = 1

	var0_4:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_5)
		if arg0_4._currentPainting then
			setActive(arg0_4._currentPainting, false)

			arg0_4._currentPainting = nil
		end
	end)
end

function var0_0.EnableSkillFloat(arg0_6, arg1_6)
	if arg1_6 == arg0_6._skillFloat then
		return
	end

	arg0_6._skillFloat = arg1_6

	if arg0_6._skillFloat then
		for iter0_6, iter1_6 in ipairs(arg0_6._cacheSkill) do
			arg0_6:SkillHrzPop(iter1_6.skillName, iter1_6.caster, iter1_6.commander, iter1_6.hrzIcon)
		end

		arg0_6._cacheSkill = {}
	else
		arg0_6._skillFloatPool:AllRecycle()
		arg0_6._skillFloatCMDPool:AllRecycle()

		arg0_6._preCommanderSkillTF = nil
		arg0_6._preSkillTF = nil
	end

	SetActive(arg0_6.skillTips, arg1_6)
end

function var0_0.SkillHrzPop(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	if not arg0_7._skillFloat then
		table.insert(arg0_7._cacheSkill, {
			skillName = arg1_7,
			caster = arg2_7,
			commander = arg3_7,
			hrzIcon = arg4_7
		})

		return
	end

	local var0_7 = ys.Battle.BattleResourceManager.GetInstance()
	local var1_7
	local var2_7

	if arg3_7 then
		if arg0_7._commanderSkillList[arg3_7] and arg0_7._commanderSkillList[arg3_7][arg1_7] then
			return
		end

		var1_7 = arg0_7._skillFloatCMDPool

		if ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
			var2_7 = var0_7:GetCommanderHrzIcon(arg3_7)
		else
			var2_7 = var0_7:GetCommanderIcon(arg3_7)
		end
	else
		var1_7 = arg0_7._skillFloatPool

		if arg2_7:GetUnitType() == ys.Battle.BattleConst.UnitType.PLAYER_UNIT then
			local var3_7 = arg4_7 or arg2_7:GetTemplate().painting

			if ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
				var2_7 = var0_7:GetCharacterIcon(var3_7)
			else
				var2_7 = var0_7:GetCharacterSquareIcon(var3_7)
			end
		elseif ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
			var2_7 = var0_7:GetCharacterIcon(pg.enemy_data_statistics[arg2_7:GetTemplateID()].icon)
		else
			var2_7 = var0_7:GetCharacterSquareIcon(pg.enemy_data_statistics[arg2_7:GetTemplateID()].icon)
		end
	end

	local var4_7 = var1_7:GetObject()
	local var5_7 = var4_7.transform

	var5_7.localScale = var0_0.SKILL_FLOAT_SCALE

	setText(findTF(var5_7, "skill/skill_name/Text"), HXSet.hxLan(arg1_7))

	local var6_7 = findTF(var5_7, "skill/icon_mask/icon")
	local var7_7 = findTF(var5_7, "skill/skill_name")
	local var8_7 = var5_7:GetComponent(typeof(Animation))

	if var8_7 then
		local var9_7 = 1

		while var8_7:GetClip("anim_skinui_skill_" .. var9_7) do
			var9_7 = var9_7 + 1
		end

		if var9_7 > 1 then
			var8_7:Play("anim_skinui_skill_" .. math.random(var9_7 - 1))
		end
	end

	var6_7:GetComponent(typeof(Image)).sprite = var2_7

	local var10_7, var11_7 = arg2_7:GetIFF()

	if arg2_7:GetIFF() == ys.Battle.BattleConfig.FRIENDLY_CODE then
		var11_7 = Color.New(1, 1, 1, 1)
	else
		var11_7 = Color.New(1, 0.33, 0.33, 1)
	end

	var7_7:GetComponent(typeof(Image)).color = var11_7
	findTF(var5_7, "skill"):GetComponent(typeof(Image)).color = var11_7

	if arg3_7 then
		arg0_7:commanderSkillFloat(arg3_7, arg1_7, var4_7)
	else
		local var12_7 = var1_0.CameraPosToUICamera(arg2_7:GetPosition():Clone())
		local var13_7 = ys.Battle.BattleCameraUtil.GetInstance():GetCharacterArrowBarPosition(var12_7)
		local var14_7 = table.contains(TeamType.SubShipType, arg2_7:GetTemplate().type)
		local var15_7 = arg2_7:GetMainUnitIndex()

		if var13_7 == nil or var13_7 == nil and var14_7 and not arg2_7:IsMainFleetUnit() then
			if var10_7 == ys.Battle.BattleConfig.FRIENDLY_CODE then
				var12_7 = var1_0.CameraPosToUICamera(arg2_7:GetPosition():Clone():Add(var0_0.IN_VIEW_FRIEND_SKILL_OFFSET))
			else
				var12_7 = var1_0.CameraPosToUICamera(arg2_7:GetPosition():Clone():Add(var0_0.IN_VIEW_FOE_SKILL_OFFSET))
			end

			var5_7.position = Vector3(var12_7.x, var12_7.y, -2)

			local var16_7 = rtf(var5_7).rect.width * 0.5
			local var17_7 = var5_7.anchoredPosition
			local var18_7 = var17_7.x

			if Screen.width * 0.5 < var16_7 + var18_7 then
				var17_7.x = var18_7 - rtf(var5_7).rect.width
				var5_7.anchoredPosition = var17_7
			end

			if arg0_7._preSkillTF then
				arg0_7.handleSkillFloatCld(arg0_7._preSkillTF, var5_7)
			end

			arg0_7._preSkillTF = var5_7

			var5_7:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_8)
				arg0_7._preSkillTF = nil

				var1_7:Recycle(var4_7)
			end)
		else
			local var19_7
			local var20_7 = var0_0.SIDE_ALIGNMENT[var15_7]
			local var21_7 = arg0_7._sideSkillFloatStateList[var10_7][var15_7]

			for iter0_7 = 1, #var21_7 do
				if var21_7[iter0_7] then
					var19_7 = iter0_7

					break
				end
			end

			if var19_7 == nil then
				var19_7 = #var21_7 + 1
			end

			var21_7[var19_7] = false
			var5_7.position = var13_7

			local var22_7 = var5_7.anchoredPosition

			var22_7.y = var20_7[var19_7]

			if var10_7 == ys.Battle.BattleConfig.FOE_CODE then
				var22_7.x = var0_0.FOE_SIDE_X_OFFSET
			end

			var5_7.anchoredPosition = var22_7

			var5_7:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_9)
				var21_7[var19_7] = true

				var1_7:Recycle(var4_7)
			end)
		end
	end
end

function var0_0.SkillHrzPopCover(arg0_10, arg1_10, arg2_10, arg3_10)
	arg0_10:SkillHrzPop(arg1_10, arg2_10, nil, arg3_10)
end

function var0_0.handleSkillFloatCld(arg0_11, arg1_11)
	local var0_11 = arg1_11.anchoredPosition
	local var1_11 = arg0_11.anchoredPosition.y

	if math.floor(math.abs(var0_11.y - var1_11)) <= 112.5 then
		var0_11.y = var1_11 + 112.5
		arg1_11.anchoredPosition = var0_11
	end
end

function var0_0.handleSkillSinkCld(arg0_12, arg1_12)
	return
end

function var0_0.commanderSkillFloat(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13._commanderSkillList[arg1_13] = arg0_13._commanderSkillList[arg1_13] or {}
	arg0_13._commanderSkillList[arg1_13][arg2_13] = true

	local var0_13 = arg3_13.transform
	local var1_13 = var0_13.anchoredPosition

	var1_13.x = 0
	var1_13.y = 0
	var0_13.anchoredPosition = var1_13

	if arg0_13._preCommanderSkillTF then
		local var2_13 = arg0_13._preCommanderSkillTF.anchoredPosition.y

		if math.floor(math.abs(var1_13.y - var2_13)) <= 97.5 then
			var1_13.y = var2_13 - 97.5
		end
	end

	var0_13.anchoredPosition = var1_13
	arg0_13._preCommanderSkillTF = var0_13

	var0_13:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_14)
		arg0_13._commanderSkillList[arg1_13][arg2_13] = nil
		arg0_13._preCommanderSkillTF = nil

		arg0_13._skillFloatCMDPool:Recycle(arg3_13)
	end)
end

function var0_0.CutInPainting(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	if arg0_15._currentPainting then
		arg0_15._paintingAnimator.enabled = false

		setActive(arg0_15._currentPainting, false)
	end

	local var0_15 = arg4_15 or arg1_15.painting or arg1_15.prefab

	if arg0_15._skillPaintings[var0_15] == nil then
		local var1_15 = ys.Battle.BattleResourceManager.GetInstance():InstPainting(var0_15)

		arg0_15._skillPaintings[var0_15] = var1_15

		setParent(var1_15, arg0_15._paintingFitter, false)
	end

	arg0_15._currentPainting = arg0_15._skillPaintings[var0_15]

	setActive(arg0_15._currentPainting, true)
	LuaHelper.SetParticleSpeed(arg0_15._paintingUI, arg2_15)

	local var2_15 = Vector3(arg3_15, 1, 1)

	arg0_15._paintingUI.transform.localScale = var2_15
	arg0_15._paintingParticleContainer.transform.localScale = var2_15
	arg0_15._paintingParticles.transform.localEulerAngles = Vector3(0, 90 * arg3_15, 0)

	arg0_15._paintingParticleSystem:Play(true)

	arg0_15._paintingAnimator.speed = arg2_15
	arg0_15._paintingAnimator.enabled = true

	arg0_15._paintingAnimator:Play("skill_painting", -1, 0)
end

function var0_0.didEnter(arg0_16)
	setActive(arg0_16._tf, false)

	arg0_16._ratioFitter.enabled = true
	arg0_16._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	arg0_16.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_17, arg1_17)
		arg0_16._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	end)

	local var0_16 = ys.Battle.BattleState.GetInstance()

	var0_16:SetBattleUI(arg0_16)
	onButton(arg0_16, arg0_16:findTF("PauseBtn"), function()
		arg0_16:emit(BattleMediator.ON_PAUSE)
	end, SFX_CONFIRM)

	arg0_16._chatBtn = arg0_16:findTF("chatBtn")

	local var1_16 = arg0_16._chatBtn:GetComponent(typeof(Animation))

	onButton(arg0_16, arg0_16._chatBtn, function()
		arg0_16:emit(BattleMediator.ON_CHAT, arg0_16:findTF("chatContainer"))

		if not var1_16 then
			setActive(arg0_16._chatBtn, false)
		else
			var1_16:Play("chatbtn_out")
		end
	end)
	onToggle(arg0_16, arg0_16:findTF("AutoBtn"), function(arg0_20)
		local var0_20 = var0_16:GetBattleType()

		arg0_16:emit(BattleMediator.ON_AUTO, {
			isOn = not arg0_20,
			toggle = arg0_16:findTF("AutoBtn"),
			system = var0_20
		})
		var0_16:ActiveBot(ys.Battle.BattleState.IsAutoBotActive(var0_20))

		if var0_16:ChatUseable() then
			setActive(arg0_16._chatBtn, true)

			if var1_16 then
				var1_16:Play("chatbtn_in")
			end
		elseif var1_16 then
			var1_16:Play("chatbtn_out")
		else
			setActive(arg0_16._chatBtn, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	onButton(arg0_16, arg0_16:findTF("CardPuzzleConsole/relic/bg"), function()
		local var0_21 = var0_16:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent():GetRelicList()

		arg0_16:emit(BattleMediator.ON_PUZZLE_RELIC, {
			relicList = var0_21
		})
	end, SFX_CONFIRM)
	onButton(arg0_16, arg0_16:findTF("CardPuzzleConsole/deck/bg"), function()
		local var0_22 = var0_16:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent()
		local var1_22 = var0_22:GetDeck():GetCardList()
		local var2_22 = var0_22:GetHand():GetCardList()

		arg0_16:emit(BattleMediator.ON_PUZZLE_CARD, {
			card = var1_22,
			hand = var2_22
		})
	end, SFX_CONFIRM)
	var0_16:ConfigBattleEndFunc(function(arg0_23)
		arg0_16:clear()
		arg0_16:emit(BattleMediator.ON_BATTLE_RESULT, arg0_23)
	end)

	local var2_16 = ys.Battle.BattleConst.BuffEffectType
	local var3_16 = {
		var2_16.ON_START_GAME,
		var2_16.ON_FLAG_SHIP,
		var2_16.ON_CONSORT,
		var2_16.ON_LEADER,
		var2_16.ON_REAR,
		var2_16.ON_SUB_LEADER,
		var2_16.ON_SUB_CONSORT
	}
	local var4_16 = 0

	local function var5_16(arg0_24)
		local var0_24 = 0

		for iter0_24, iter1_24 in ipairs(arg0_24) do
			var0_24 = var0_24 + ys.Battle.BattleDataFunction.GetShipSkillTriggerCount(iter1_24, var3_16)
		end

		return var0_24
	end

	local var6_16 = var4_16 + var5_16(arg0_16.contextData.battleData.MainUnitList) + var5_16(arg0_16.contextData.battleData.VanguardUnitList) + var5_16(arg0_16.contextData.battleData.SubUnitList) + 4

	arg0_16._skillFloatPool = pg.Pool.New(arg0_16.skillRoot, arg0_16.skillTpl, var6_16, 10, true, false):InitSize()

	arg0_16:emit(BattleMediator.ENTER)
	arg0_16:initPauseWindow()

	if arg0_16.contextData.prePause then
		triggerButton(arg0_16:findTF("PauseBtn"))
	end

	setActive(arg0_16._chatBtn, var0_16:ChatUseable())
end

function var0_0.onBackPressed(arg0_25)
	if isActive(arg0_25.pauseWindow) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_25.continueBtn)
	end
end

function var0_0.activeBotHelp(arg0_26, arg1_26)
	local var0_26 = getProxy(PlayerProxy)

	if not arg1_26 then
		if arg0_26.autoBotHelp then
			pg.MsgboxMgr.GetInstance():hide()
		end

		return
	end

	if var0_26.botHelp then
		return
	end

	arg0_26.autoBotHelp = true

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
			arg0_26.autoBotHelp = false
		end
	})

	var0_26.botHelp = true
end

function var0_0.exitBattle(arg0_28, arg1_28)
	if not arg1_28 then
		arg0_28:emit(BattleMediator.ON_QUIT_BATTLE_MANUALLY)
		arg0_28:emit(BattleMediator.ON_BACK_PRE_SCENE)
	elseif arg1_28 == "kick" then
		-- block empty
	end
end

function var0_0.setChapter(arg0_29, arg1_29)
	arg0_29._chapter = arg1_29
end

function var0_0.setFleet(arg0_30, arg1_30, arg2_30)
	arg0_30._mainShipVOs = arg1_30
	arg0_30._vanShipVOs = arg2_30
end

function var0_0.initPauseWindow(arg0_31)
	arg0_31.pauseWindow = arg0_31:findTF("Msgbox")
	arg0_31.LeftTimeContainer = arg0_31:findTF("window/LeftTime", arg0_31.pauseWindow)
	arg0_31.LeftTime = arg0_31:findTF("window/LeftTime/Text", arg0_31.pauseWindow)
	arg0_31.mainTFs = {}
	arg0_31.vanTFs = {}

	setText(arg0_31:findTF("label", arg0_31.LeftTimeContainer), i18n("battle_battleMediator_remainTime"))
	setText(arg0_31:findTF("window/van/power/title", arg0_31.pauseWindow), i18n("word_vanguard_fleet"))
	setText(arg0_31:findTF("window/main/power/title", arg0_31.pauseWindow), i18n("word_main_fleet"))

	local function var0_31(arg0_32, arg1_32, arg2_32)
		for iter0_32 = 1, 3 do
			local var0_32 = arg1_32:Find("ship_" .. iter0_32)

			setActive(var0_32, arg2_32 and iter0_32 <= #arg2_32)

			if arg2_32 and iter0_32 <= #arg2_32 then
				updateShip(var0_32, arg2_32[iter0_32])
			end

			table.insert(arg0_32 and arg0_31.mainTFs or arg0_31.vanTFs, var0_32)
		end

		if arg2_32 then
			local var1_32 = 0

			for iter1_32, iter2_32 in ipairs(arg2_32) do
				var1_32 = var1_32 + iter2_32:getShipCombatPower()
			end

			setText(arg1_32:Find("power/value"), var1_32)
		end
	end

	if arg0_31._mainShipVOs then
		var0_31(true, arg0_31:findTF("window/main", arg0_31.pauseWindow), arg0_31._mainShipVOs)
		var0_31(false, arg0_31:findTF("window/van", arg0_31.pauseWindow), arg0_31._vanShipVOs)
	end

	local var1_31 = ys.Battle.BattleState.GetInstance()
	local var2_31 = findTF(arg0_31.pauseWindow, "window/Chapter")
	local var3_31 = findTF(arg0_31.pauseWindow, "window/Chapter/Text")

	arg0_31.continueBtn = arg0_31:findTF("window/button_container/continue", arg0_31.pauseWindow)
	arg0_31.leaveBtn = arg0_31:findTF("window/button_container/leave", arg0_31.pauseWindow)

	setText(arg0_31:findTF("pic", arg0_31.continueBtn), i18n("battle_battleMediator_goOnFight"))
	setText(arg0_31:findTF("pic", arg0_31.leaveBtn), i18n("battle_battleMediator_existFight"))

	local var4_31 = var1_31:GetBattleType()

	if var4_31 == SYSTEM_SCENARIO then
		local var5_31 = arg0_31._chapter:getConfigTable()

		setText(var2_31, var5_31.chapter_name)
		setText(var3_31, string.split(var5_31.name, "|")[1])
	elseif var4_31 == SYSTEM_ROUTINE or var4_31 == SYSTEM_DUEL or var4_31 == SYSTEM_HP_SHARE_ACT_BOSS or var4_31 == SYSTEM_BOSS_EXPERIMENT or var4_31 == SYSTEM_ACT_BOSS or var4_31 == SYSTEM_ACT_BOSS_SP or var4_31 == SYSTEM_BOSS_RUSH or var4_31 == SYSTEM_BOSS_RUSH_EX or var4_31 == SYSTEM_LIMIT_CHALLENGE or var4_31 == SYSTEM_BOSS_SINGLE then
		setText(var2_31, "SP")

		local var6_31 = var1_31:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().StageTmpId
		local var7_31 = pg.expedition_data_template[var6_31]

		setText(var3_31, var7_31.name)
	elseif var4_31 == SYSTEM_DEBUG then
		setText(var2_31, "??")
		setText(var3_31, "碧蓝梦境")
	elseif var4_31 == SYSTEM_CHALLENGE then
		local var8_31 = arg0_31._chapter:getNextExpedition()

		setText(var2_31, "SP")
		setText(var3_31, var8_31.chapter_name[2])
		setActive(arg0_31.LeftTimeContainer, true)
	elseif var4_31 == SYSTEM_WORLD_BOSS or var4_31 == SYSTEM_WORLD then
		setText(var2_31, i18n("world_battle_pause"))
		setText(var3_31, i18n("world_battle_pause2"))

		if var4_31 == SYSTEM_WORLD_BOSS then
			setActive(arg0_31.leaveBtn, false)
		end
	elseif var4_31 == SYSTEM_GUILD then
		local var9_31 = var1_31:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().ActID
		local var10_31 = pg.guild_boss_event[var9_31]

		setText(var2_31, "BOSS")
		setText(var3_31, var10_31 and var10_31.name or "")
	elseif var4_31 == SYSTEM_TEST or var4_31 == SYSTEM_SUB_ROUTINE or var4_31 == SYSTEM_PERFORM or var4_31 == SYSTEM_PROLOGUE or var4_31 == SYSTEM_DODGEM or var4_31 == SYSTEM_SIMULATION or var4_31 == SYSTEM_SUBMARINE_RUN or var4_31 == SYSTEM_BOSS_EXPERIMENT or var4_31 == SYSTEM_REWARD_PERFORM or var4_31 == SYSTEM_AIRFIGHT then
		-- block empty
	elseif var4_31 == SYSTEM_CARDPUZZLE then
		-- block empty
	else
		assert(false, "System not defined " .. (var4_31 or "NIL"))
	end

	onButton(arg0_31, arg0_31.leaveBtn, function()
		arg0_31:emit(BattleMediator.ON_LEAVE)

		local var0_33 = arg0_31.leaveBtn:GetComponent(typeof(Animation))

		if var0_33 and var0_33:GetClip("msgbox_btn_blink") then
			var0_33:Play("msgbox_btn_blink")
		end
	end)
	onButton(arg0_31, arg0_31.continueBtn, function()
		local var0_34 = arg0_31.continueBtn:GetComponent(typeof(Animation))

		if var0_34 and var0_34:GetClip("msgbox_btn_blink") then
			var0_34:Play("msgbox_btn_blink")
		end

		local var1_34 = arg0_31.pauseWindow:GetComponent(typeof(Animation))

		if var1_34 then
			if var1_34:IsPlaying("msgbox_out") then
				var1_34:Stop("msgbox_out")
				var1_34:Play("msgbox_in")
			else
				var1_34:Play("msgbox_out")
				arg0_31.pauseWindow:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_35)
					setActive(arg0_31.pauseWindow, false)
					pg.UIMgr.GetInstance():UnblurPanel(arg0_31.pauseWindow, arg0_31._tf)
					var1_31:Resume()
				end)
			end
		else
			setActive(arg0_31.pauseWindow, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_31.pauseWindow, arg0_31._tf)
			var1_31:Resume()
		end
	end)
	onButton(arg0_31, arg0_31:findTF("help", arg0_31.pauseWindow), function()
		if BATTLE_DEBUG and PLATFORM == 7 then
			setActive(arg0_31.pauseWindow, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_31.pauseWindow, arg0_31._tf)
			var1_31:Resume()
			var1_31:OpenConsole()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("help_battle_rule")
			})
		end
	end)
	onButton(arg0_31, arg0_31:findTF("window/top/btnBack", arg0_31.pauseWindow), function()
		triggerButton(arg0_31.continueBtn)
	end)
	onButton(arg0_31, arg0_31.pauseWindow, function()
		triggerButton(arg0_31.continueBtn)
	end)
	setActive(arg0_31.pauseWindow, false)
end

function var0_0.updatePauseWindow(arg0_39)
	if not arg0_39.pauseWindow then
		return
	end

	setActive(arg0_39.pauseWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_39.pauseWindow, nil, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	local var0_39 = ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name)
	local var1_39 = var0_39:GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE)
	local var2_39 = var1_39:GetMainList()
	local var3_39 = var1_39:GetScoutList()

	local function var4_39(arg0_40, arg1_40, arg2_40)
		if not arg0_40 then
			return
		end

		for iter0_40 = 1, #arg0_40 do
			local var0_40 = arg0_40[iter0_40].id

			if var1_39:GetFreezeShipByID(var0_40) then
				local var1_40 = var1_39:GetFreezeShipByID(var0_40)

				setSlider(arg2_40[iter0_40]:Find("blood"), 0, 1, var1_40:GetHPRate())
				SetActive(arg2_40[iter0_40]:Find("mask"), false)
			elseif var1_39:GetShipByID(var0_40) then
				local var2_40 = var1_39:GetShipByID(var0_40)

				setSlider(arg2_40[iter0_40]:Find("blood"), 0, 1, var2_40:GetHPRate())
				SetActive(arg2_40[iter0_40]:Find("mask"), false)
			else
				setSlider(arg2_40[iter0_40]:Find("blood"), 0, 1, 0)
				SetActive(arg2_40[iter0_40]:Find("mask"), true)
			end
		end
	end

	var4_39(arg0_39._mainShipVOs, var2_39, arg0_39.mainTFs)
	var4_39(arg0_39._vanShipVOs, var3_39, arg0_39.vanTFs)
	setText(arg0_39.LeftTime, ys.Battle.BattleTimerView.formatTime(math.floor(var0_39:GetCountDown())))
end

function var0_0.AddUIFX(arg0_41, arg1_41, arg2_41)
	arg2_41 = arg2_41 or 1

	local var0_41 = arg2_41 > 0

	arg1_41 = tf(arg1_41)

	local var1_41 = var0_41 and arg0_41._fxContainerUpper or arg0_41._fxContainerBottom

	arg1_41:SetParent(var1_41)
	pg.ViewUtils.SetSortingOrder(arg1_41, arg0_41._canvasOrder + arg2_41)
	pg.ViewUtils.SetLayer(arg1_41, Layer.UI)

	return var1_41.localScale
end

function var0_0.OnCloseChat(arg0_42)
	local var0_42 = ys.Battle.BattleState.GetInstance():IsBotActive()
	local var1_42 = arg0_42._chatBtn:GetComponent(typeof(Animation))

	if var0_42 then
		setActive(arg0_42._chatBtn, true)

		if var1_42 then
			var1_42:Play("chatbtn_in")
		end
	elseif var1_42 then
		var1_42:Play("chatbtn_out")
	else
		setActive(arg0_42._chatBtn, false)
	end
end

function var0_0.clear(arg0_43)
	arg0_43._preSkillTF = nil
	arg0_43._preCommanderSkillTF = nil
	arg0_43._commanderSkillList = nil
	arg0_43._skillPaintings = nil
	arg0_43._currentPainting = nil

	Destroy(arg0_43._paintingUI)
end

function var0_0.willExit(arg0_44)
	arg0_44._skillFloatPool:Dispose()
	arg0_44._skillFloatCMDPool:Dispose()
	ys.Battle.BattleState.GetInstance():ExitBattle()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_44.pauseWindow, arg0_44._tf)
	ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCemera(false)
	pg.CameraFixMgr.GetInstance():disconnect(arg0_44.camEventId)
end

return var0_0
