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

	arg0_3._skillFloatPool:SetRecycleFuncs(function(arg0_4)
		arg0_4.transform:GetComponent(typeof(DftAniEvent)):OnDestroy()
	end)

	arg0_3.skillCMDRoot = arg0_3:findTF("Skill_Activation/Root_cmd")
	arg0_3.skillCMDTpl = arg0_3:findTF("Skill_Activation/mask_cmd").gameObject
	arg0_3._skillFloatCMDPool = pg.Pool.New(arg0_3.skillCMDRoot, arg0_3.skillCMDTpl, 2, 4, true, false):InitSize()

	arg0_3._skillFloatCMDPool:SetRecycleFuncs(function(arg0_5)
		arg0_5.transform:GetComponent(typeof(DftAniEvent)):OnDestroy()
	end)

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

function var0_0.initPainting(arg0_6)
	local var0_6 = ys.Battle.BattleResourceManager.GetInstance():InstSkillPaintingUI()

	setParent(var0_6, arg0_6.uiCanvas, false)

	arg0_6._paintingUI = var0_6
	arg0_6._paintingAnimator = var0_6:GetComponent(typeof(Animator))
	arg0_6._paintingAnimator.enabled = false
	arg0_6._paintingParticleContainer = findTF(var0_6, "particleContainer")
	arg0_6._paintingParticles = findTF(arg0_6._paintingParticleContainer, "effect")
	arg0_6._paintingParticleSystem = arg0_6._paintingParticles:GetComponent(typeof(ParticleSystem))

	arg0_6._paintingParticleSystem:Stop(true)

	arg0_6._paintingFitter = findTF(var0_6, "hero/fitter")

	removeAllChildren(arg0_6._paintingFitter)

	local var1_6 = GetOrAddComponent(arg0_6._paintingFitter, "PaintingScaler")

	var1_6.FrameName = "lihuisha"
	var1_6.Tween = 1

	var0_6:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_7)
		if arg0_6._currentPainting then
			setActive(arg0_6._currentPainting, false)

			arg0_6._currentPainting = nil
		end
	end)
end

function var0_0.EnableSkillFloat(arg0_8, arg1_8)
	if arg1_8 == arg0_8._skillFloat then
		return
	end

	arg0_8._skillFloat = arg1_8

	if arg0_8._skillFloat then
		for iter0_8, iter1_8 in ipairs(arg0_8._cacheSkill) do
			arg0_8:SkillHrzPop(iter1_8.skillName, iter1_8.caster, iter1_8.commander, iter1_8.hrzIcon)
		end

		arg0_8._cacheSkill = {}
	else
		arg0_8._skillFloatPool:AllRecycle()
		arg0_8._skillFloatCMDPool:AllRecycle()

		arg0_8._preCommanderSkillTF = nil
		arg0_8._preSkillTF = nil
	end

	SetActive(arg0_8.skillTips, arg1_8)
end

function var0_0.SkillHrzPop(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	if not arg0_9._skillFloat then
		table.insert(arg0_9._cacheSkill, {
			skillName = arg1_9,
			caster = arg2_9,
			commander = arg3_9,
			hrzIcon = arg4_9
		})

		return
	end

	local var0_9 = ys.Battle.BattleResourceManager.GetInstance()
	local var1_9
	local var2_9

	if arg3_9 then
		if arg0_9._commanderSkillList[arg3_9] and arg0_9._commanderSkillList[arg3_9][arg1_9] then
			return
		end

		var1_9 = arg0_9._skillFloatCMDPool

		if ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
			var2_9 = var0_9:GetCommanderHrzIcon(arg3_9)
		else
			var2_9 = var0_9:GetCommanderIcon(arg3_9)
		end
	else
		var1_9 = arg0_9._skillFloatPool

		if arg2_9:GetUnitType() == ys.Battle.BattleConst.UnitType.PLAYER_UNIT then
			local var3_9 = arg4_9 or arg2_9:GetTemplate().painting

			if ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
				var2_9 = var0_9:GetCharacterIcon(var3_9)
			else
				var2_9 = var0_9:GetCharacterSquareIcon(var3_9)
			end
		elseif ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
			var2_9 = var0_9:GetCharacterIcon(pg.enemy_data_statistics[arg2_9:GetTemplateID()].icon)
		else
			var2_9 = var0_9:GetCharacterSquareIcon(pg.enemy_data_statistics[arg2_9:GetTemplateID()].icon)
		end
	end

	local var4_9 = var1_9:GetObject()
	local var5_9 = var4_9.transform

	var5_9.localScale = var0_0.SKILL_FLOAT_SCALE

	setText(findTF(var5_9, "skill/skill_name/Text"), SwitchSpecialChar(HXSet.hxLan(arg1_9)))

	local var6_9 = findTF(var5_9, "skill/icon_mask/icon")
	local var7_9 = findTF(var5_9, "skill/skill_name")
	local var8_9 = var5_9:GetComponent(typeof(Animation))

	if var8_9 then
		local var9_9 = 1

		while var8_9:GetClip("anim_skinui_skill_" .. var9_9) do
			var9_9 = var9_9 + 1
		end

		if var9_9 > 1 then
			var8_9:Play("anim_skinui_skill_" .. math.random(var9_9 - 1))
		end
	end

	var6_9:GetComponent(typeof(Image)).sprite = var2_9

	local var10_9, var11_9 = arg2_9:GetIFF()

	if arg2_9:GetIFF() == ys.Battle.BattleConfig.FRIENDLY_CODE then
		var11_9 = Color.New(1, 1, 1, 1)
	else
		var11_9 = Color.New(1, 0.33, 0.33, 1)
	end

	var7_9:GetComponent(typeof(Image)).color = var11_9
	findTF(var5_9, "skill"):GetComponent(typeof(Image)).color = var11_9

	if arg3_9 then
		arg0_9:commanderSkillFloat(arg3_9, arg1_9, var4_9)
	else
		local var12_9 = var1_0.CameraPosToUICamera(arg2_9:GetPosition():Clone())
		local var13_9 = ys.Battle.BattleCameraUtil.GetInstance():GetCharacterArrowBarPosition(var12_9)
		local var14_9 = table.contains(TeamType.SubShipType, arg2_9:GetTemplate().type)
		local var15_9 = arg2_9:GetMainUnitIndex()

		if var13_9 == nil or var13_9 == nil and var14_9 and not arg2_9:IsMainFleetUnit() then
			if var10_9 == ys.Battle.BattleConfig.FRIENDLY_CODE then
				var12_9 = var1_0.CameraPosToUICamera(arg2_9:GetPosition():Clone():Add(var0_0.IN_VIEW_FRIEND_SKILL_OFFSET))
			else
				var12_9 = var1_0.CameraPosToUICamera(arg2_9:GetPosition():Clone():Add(var0_0.IN_VIEW_FOE_SKILL_OFFSET))
			end

			var5_9.position = Vector3(var12_9.x, var12_9.y, -2)

			local var16_9 = rtf(var5_9).rect.width * 0.5
			local var17_9 = var5_9.anchoredPosition
			local var18_9 = var17_9.x

			if Screen.width * 0.5 < var16_9 + var18_9 then
				var17_9.x = var18_9 - rtf(var5_9).rect.width
				var5_9.anchoredPosition = var17_9
			end

			if arg0_9._preSkillTF then
				arg0_9.handleSkillFloatCld(arg0_9._preSkillTF, var5_9)
			end

			arg0_9._preSkillTF = var5_9

			var5_9:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_10)
				arg0_9._preSkillTF = nil

				var1_9:Recycle(var4_9)
			end)
		else
			local var19_9
			local var20_9 = var0_0.SIDE_ALIGNMENT[var15_9]
			local var21_9 = arg0_9._sideSkillFloatStateList[var10_9][var15_9]

			for iter0_9 = 1, #var21_9 do
				if var21_9[iter0_9] then
					var19_9 = iter0_9

					break
				end
			end

			if var19_9 == nil then
				var19_9 = #var21_9 + 1
			end

			var21_9[var19_9] = false
			var5_9.position = var13_9

			local var22_9 = var5_9.anchoredPosition

			var22_9.y = var20_9[var19_9]

			if var10_9 == ys.Battle.BattleConfig.FOE_CODE then
				var22_9.x = var0_0.FOE_SIDE_X_OFFSET
			end

			var5_9.anchoredPosition = var22_9

			var5_9:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_11)
				var21_9[var19_9] = true

				var1_9:Recycle(var4_9)
			end)
		end
	end
end

function var0_0.SkillHrzPopCover(arg0_12, arg1_12, arg2_12, arg3_12)
	arg0_12:SkillHrzPop(arg1_12, arg2_12, nil, arg3_12)
end

function var0_0.handleSkillFloatCld(arg0_13, arg1_13)
	local var0_13 = arg1_13.anchoredPosition
	local var1_13 = arg0_13.anchoredPosition.y

	if math.floor(math.abs(var0_13.y - var1_13)) <= 112.5 then
		var0_13.y = var1_13 + 112.5
		arg1_13.anchoredPosition = var0_13
	end
end

function var0_0.handleSkillSinkCld(arg0_14, arg1_14)
	return
end

function var0_0.commanderSkillFloat(arg0_15, arg1_15, arg2_15, arg3_15)
	arg0_15._commanderSkillList[arg1_15] = arg0_15._commanderSkillList[arg1_15] or {}
	arg0_15._commanderSkillList[arg1_15][arg2_15] = true

	local var0_15 = arg3_15.transform
	local var1_15 = var0_15.anchoredPosition

	var1_15.x = 0
	var1_15.y = 0
	var0_15.anchoredPosition = var1_15

	if arg0_15._preCommanderSkillTF then
		local var2_15 = arg0_15._preCommanderSkillTF.anchoredPosition.y

		if math.floor(math.abs(var1_15.y - var2_15)) <= 97.5 then
			var1_15.y = var2_15 - 97.5
		end
	end

	var0_15.anchoredPosition = var1_15
	arg0_15._preCommanderSkillTF = var0_15

	var0_15:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_16)
		arg0_15._commanderSkillList[arg1_15][arg2_15] = nil
		arg0_15._preCommanderSkillTF = nil

		arg0_15._skillFloatCMDPool:Recycle(arg3_15)
	end)
end

function var0_0.CutInPainting(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	if arg0_17._currentPainting then
		arg0_17._paintingAnimator.enabled = false

		setActive(arg0_17._currentPainting, false)
	end

	local var0_17 = arg4_17 or arg1_17.painting or arg1_17.prefab

	if arg0_17._skillPaintings[var0_17] == nil then
		local var1_17 = ys.Battle.BattleResourceManager.GetInstance():InstPainting(var0_17)

		arg0_17._skillPaintings[var0_17] = var1_17

		setParent(var1_17, arg0_17._paintingFitter, false)
	end

	arg0_17._currentPainting = arg0_17._skillPaintings[var0_17]

	setActive(arg0_17._currentPainting, true)
	LuaHelper.SetParticleSpeed(arg0_17._paintingUI, arg2_17)

	local var2_17 = Vector3(arg3_17, 1, 1)

	arg0_17._paintingUI.transform.localScale = var2_17
	arg0_17._paintingParticleContainer.transform.localScale = var2_17
	arg0_17._paintingParticles.transform.localEulerAngles = Vector3(0, 90 * arg3_17, 0)

	arg0_17._paintingParticleSystem:Play(true)

	arg0_17._paintingAnimator.speed = arg2_17
	arg0_17._paintingAnimator.enabled = true

	arg0_17._paintingAnimator:Play("skill_painting", -1, 0)
end

function var0_0.didEnter(arg0_18)
	setActive(arg0_18._tf, false)

	arg0_18._ratioFitter.enabled = true
	arg0_18._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	arg0_18.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_19, arg1_19)
		arg0_18._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	end)

	local var0_18 = ys.Battle.BattleState.GetInstance()

	var0_18:SetBattleUI(arg0_18)
	onButton(arg0_18, arg0_18:findTF("PauseBtn"), function()
		arg0_18:emit(BattleMediator.ON_PAUSE)
	end, SFX_CONFIRM)

	arg0_18._chatBtn = arg0_18:findTF("chatBtn")

	local var1_18 = arg0_18._chatBtn:GetComponent(typeof(Animation))

	onButton(arg0_18, arg0_18._chatBtn, function()
		arg0_18:emit(BattleMediator.ON_CHAT, arg0_18:findTF("chatContainer"))

		if not var1_18 then
			setActive(arg0_18._chatBtn, false)
		else
			var1_18:Play("chatbtn_out")
		end
	end)
	onToggle(arg0_18, arg0_18:findTF("AutoBtn"), function(arg0_22)
		local var0_22 = var0_18:GetBattleType()

		arg0_18:emit(BattleMediator.ON_AUTO, {
			isOn = not arg0_22,
			toggle = arg0_18:findTF("AutoBtn"),
			system = var0_22
		})
		var0_18:ActiveBot(ys.Battle.BattleState.IsAutoBotActive(var0_22))

		if var0_18:ChatUseable() then
			setActive(arg0_18._chatBtn, true)

			if var1_18 then
				var1_18:Play("chatbtn_in")
			end
		elseif var1_18 then
			var1_18:Play("chatbtn_out")
		else
			setActive(arg0_18._chatBtn, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	onButton(arg0_18, arg0_18:findTF("CardPuzzleConsole/relic/bg"), function()
		local var0_23 = var0_18:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent():GetRelicList()

		arg0_18:emit(BattleMediator.ON_PUZZLE_RELIC, {
			relicList = var0_23
		})
	end, SFX_CONFIRM)
	onButton(arg0_18, arg0_18:findTF("CardPuzzleConsole/deck/bg"), function()
		local var0_24 = var0_18:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent()
		local var1_24 = var0_24:GetDeck():GetCardList()
		local var2_24 = var0_24:GetHand():GetCardList()

		arg0_18:emit(BattleMediator.ON_PUZZLE_CARD, {
			card = var1_24,
			hand = var2_24
		})
	end, SFX_CONFIRM)
	var0_18:ConfigBattleEndFunc(function(arg0_25)
		arg0_18:clear()
		arg0_18:emit(BattleMediator.ON_BATTLE_RESULT, arg0_25)
	end)

	local var2_18 = ys.Battle.BattleConst.BuffEffectType
	local var3_18 = {
		var2_18.ON_START_GAME,
		var2_18.ON_FLAG_SHIP,
		var2_18.ON_CONSORT,
		var2_18.ON_LEADER,
		var2_18.ON_REAR,
		var2_18.ON_SUB_LEADER,
		var2_18.ON_SUB_CONSORT
	}
	local var4_18 = 0

	local function var5_18(arg0_26)
		local var0_26 = 0

		for iter0_26, iter1_26 in ipairs(arg0_26) do
			var0_26 = var0_26 + ys.Battle.BattleDataFunction.GetShipSkillTriggerCount(iter1_26, var3_18)
		end

		return var0_26
	end

	local var6_18 = var4_18 + var5_18(arg0_18.contextData.battleData.MainUnitList) + var5_18(arg0_18.contextData.battleData.VanguardUnitList) + var5_18(arg0_18.contextData.battleData.SubUnitList) + 4

	arg0_18._skillFloatPool = pg.Pool.New(arg0_18.skillRoot, arg0_18.skillTpl, var6_18, 10, true, false):InitSize()

	arg0_18._skillFloatPool:SetRecycleFuncs(function(arg0_27)
		arg0_27.transform:GetComponent(typeof(DftAniEvent)):OnDestroy()
	end)
	arg0_18:emit(BattleMediator.ENTER)
	arg0_18:initPauseWindow()

	if arg0_18.contextData.prePause then
		triggerButton(arg0_18:findTF("PauseBtn"))
	end

	setActive(arg0_18._chatBtn, var0_18:ChatUseable())
end

function var0_0.onBackPressed(arg0_28)
	if isActive(arg0_28.pauseWindow) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_28.continueBtn)
	end
end

function var0_0.activeBotHelp(arg0_29, arg1_29)
	local var0_29 = getProxy(PlayerProxy)

	if not arg1_29 then
		if arg0_29.autoBotHelp then
			pg.MsgboxMgr.GetInstance():hide()
		end

		return
	end

	if var0_29.botHelp then
		return
	end

	arg0_29.autoBotHelp = true

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
			arg0_29.autoBotHelp = false
		end
	})

	var0_29.botHelp = true
end

function var0_0.exitBattle(arg0_31, arg1_31)
	if not arg1_31 then
		arg0_31:emit(BattleMediator.ON_QUIT_BATTLE_MANUALLY)
		arg0_31:emit(BattleMediator.ON_BACK_PRE_SCENE)
	elseif arg1_31 == "kick" then
		-- block empty
	end
end

function var0_0.setChapter(arg0_32, arg1_32)
	arg0_32._chapter = arg1_32
end

function var0_0.setFleet(arg0_33, arg1_33, arg2_33)
	arg0_33._mainShipVOs = arg1_33
	arg0_33._vanShipVOs = arg2_33
end

function var0_0.initPauseWindow(arg0_34)
	arg0_34.pauseWindow = arg0_34:findTF("Msgbox")
	arg0_34.LeftTimeContainer = arg0_34:findTF("window/LeftTime", arg0_34.pauseWindow)
	arg0_34.LeftTime = arg0_34:findTF("window/LeftTime/Text", arg0_34.pauseWindow)
	arg0_34.mainTFs = {}
	arg0_34.vanTFs = {}

	setText(arg0_34:findTF("label", arg0_34.LeftTimeContainer), i18n("battle_battleMediator_remainTime"))
	setText(arg0_34:findTF("window/van/power/title", arg0_34.pauseWindow), i18n("word_vanguard_fleet"))
	setText(arg0_34:findTF("window/main/power/title", arg0_34.pauseWindow), i18n("word_main_fleet"))

	local function var0_34(arg0_35, arg1_35, arg2_35)
		for iter0_35 = 1, 3 do
			local var0_35 = arg1_35:Find("ship_" .. iter0_35)

			setActive(var0_35, arg2_35 and iter0_35 <= #arg2_35)

			if arg2_35 and iter0_35 <= #arg2_35 then
				updateShip(var0_35, arg2_35[iter0_35])
			end

			table.insert(arg0_35 and arg0_34.mainTFs or arg0_34.vanTFs, var0_35)
		end

		if arg2_35 then
			local var1_35 = 0

			for iter1_35, iter2_35 in ipairs(arg2_35) do
				var1_35 = var1_35 + iter2_35:getShipCombatPower()
			end

			setText(arg1_35:Find("power/value"), var1_35)
		end
	end

	if arg0_34._mainShipVOs then
		var0_34(true, arg0_34:findTF("window/main", arg0_34.pauseWindow), arg0_34._mainShipVOs)
		var0_34(false, arg0_34:findTF("window/van", arg0_34.pauseWindow), arg0_34._vanShipVOs)
	end

	local var1_34 = ys.Battle.BattleState.GetInstance()
	local var2_34 = findTF(arg0_34.pauseWindow, "window/Chapter")
	local var3_34 = findTF(arg0_34.pauseWindow, "window/Chapter/Text")

	arg0_34.continueBtn = arg0_34:findTF("window/button_container/continue", arg0_34.pauseWindow)
	arg0_34.leaveBtn = arg0_34:findTF("window/button_container/leave", arg0_34.pauseWindow)

	setText(arg0_34:findTF("pic", arg0_34.continueBtn), i18n("battle_battleMediator_goOnFight"))
	setText(arg0_34:findTF("pic", arg0_34.leaveBtn), i18n("battle_battleMediator_existFight"))

	local var4_34 = var1_34:GetBattleType()

	if var4_34 == SYSTEM_SCENARIO then
		local var5_34 = arg0_34._chapter:getConfigTable()

		setText(var2_34, var5_34.chapter_name)
		setText(var3_34, string.split(var5_34.name, "|")[1])
	elseif var4_34 == SYSTEM_ROUTINE or var4_34 == SYSTEM_DUEL or var4_34 == SYSTEM_HP_SHARE_ACT_BOSS or var4_34 == SYSTEM_BOSS_EXPERIMENT or var4_34 == SYSTEM_ACT_BOSS or var4_34 == SYSTEM_ACT_BOSS_SP or var4_34 == SYSTEM_BOSS_RUSH or var4_34 == SYSTEM_BOSS_RUSH_EX or var4_34 == SYSTEM_LIMIT_CHALLENGE or var4_34 == SYSTEM_BOSS_SINGLE or var4_34 == SYSTEM_BOSS_SINGLE_VARIABLE then
		setText(var2_34, "SP")

		local var6_34 = var1_34:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().StageTmpId
		local var7_34 = pg.expedition_data_template[var6_34]

		setText(var3_34, var7_34.name)
	elseif var4_34 == SYSTEM_DEBUG then
		setText(var2_34, "??")
		setText(var3_34, "碧蓝梦境")
	elseif var4_34 == SYSTEM_CHALLENGE then
		local var8_34 = arg0_34._chapter:getNextExpedition()

		setText(var2_34, "SP")
		setText(var3_34, var8_34.chapter_name[2])
		setActive(arg0_34.LeftTimeContainer, true)
	elseif var4_34 == SYSTEM_WORLD_BOSS or var4_34 == SYSTEM_WORLD then
		setText(var2_34, i18n("world_battle_pause"))
		setText(var3_34, i18n("world_battle_pause2"))

		if var4_34 == SYSTEM_WORLD_BOSS then
			setActive(arg0_34.leaveBtn, false)
		end
	elseif var4_34 == SYSTEM_GUILD then
		local var9_34 = var1_34:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().ActID
		local var10_34 = pg.guild_boss_event[var9_34]

		setText(var2_34, "BOSS")
		setText(var3_34, var10_34 and var10_34.name or "")
	elseif var4_34 == SYSTEM_TEST or var4_34 == SYSTEM_SUB_ROUTINE or var4_34 == SYSTEM_PERFORM or var4_34 == SYSTEM_PROLOGUE or var4_34 == SYSTEM_DODGEM or var4_34 == SYSTEM_SIMULATION or var4_34 == SYSTEM_SUBMARINE_RUN or var4_34 == SYSTEM_BOSS_EXPERIMENT or var4_34 == SYSTEM_REWARD_PERFORM or var4_34 == SYSTEM_AIRFIGHT then
		-- block empty
	elseif var4_34 == SYSTEM_CARDPUZZLE then
		-- block empty
	else
		assert(false, "System not defined " .. (var4_34 or "NIL"))
	end

	onButton(arg0_34, arg0_34.leaveBtn, function()
		arg0_34:emit(BattleMediator.ON_LEAVE)

		local var0_36 = arg0_34.leaveBtn:GetComponent(typeof(Animation))

		if var0_36 and var0_36:GetClip("msgbox_btn_blink") then
			var0_36:Play("msgbox_btn_blink")
		end
	end)
	onButton(arg0_34, arg0_34.continueBtn, function()
		local var0_37 = arg0_34.continueBtn:GetComponent(typeof(Animation))

		if var0_37 and var0_37:GetClip("msgbox_btn_blink") then
			var0_37:Play("msgbox_btn_blink")
		end

		local var1_37 = arg0_34.pauseWindow:GetComponent(typeof(Animation))

		if var1_37 then
			if var1_37:IsPlaying("msgbox_out") then
				var1_37:Stop("msgbox_out")
				var1_37:Play("msgbox_in")
			else
				var1_37:Play("msgbox_out")
				arg0_34.pauseWindow:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_38)
					setActive(arg0_34.pauseWindow, false)
					pg.UIMgr.GetInstance():UnblurPanel(arg0_34.pauseWindow, arg0_34._tf)
					var1_34:Resume()
				end)
			end
		else
			setActive(arg0_34.pauseWindow, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_34.pauseWindow, arg0_34._tf)
			var1_34:Resume()
		end
	end)
	onButton(arg0_34, arg0_34:findTF("help", arg0_34.pauseWindow), function()
		if BATTLE_DEBUG and PLATFORM == 7 then
			setActive(arg0_34.pauseWindow, false)
			pg.UIMgr.GetInstance():UnblurPanel(arg0_34.pauseWindow, arg0_34._tf)
			var1_34:Resume()
			var1_34:OpenConsole()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("help_battle_rule")
			})
		end
	end)
	onButton(arg0_34, arg0_34:findTF("window/top/btnBack", arg0_34.pauseWindow), function()
		triggerButton(arg0_34.continueBtn)
	end)
	onButton(arg0_34, arg0_34.pauseWindow, function()
		triggerButton(arg0_34.continueBtn)
	end)
	onButton(arg0_34, arg0_34.pauseWindow, function()
		local var0_42 = arg0_34.pauseWindow:GetComponent(typeof(Animation))

		if var0_42 and var0_42:IsPlaying("msgbox_out") then
			-- block empty
		else
			triggerButton(arg0_34.continueBtn)
		end
	end)
	setActive(arg0_34.pauseWindow, false)
end

function var0_0.updatePauseWindow(arg0_43)
	if not arg0_43.pauseWindow then
		return
	end

	setActive(arg0_43.pauseWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_43.pauseWindow, nil, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	local var0_43 = ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name)
	local var1_43 = var0_43:GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE)
	local var2_43 = var1_43:GetMainList()
	local var3_43 = var1_43:GetScoutList()

	local function var4_43(arg0_44, arg1_44, arg2_44)
		if not arg0_44 then
			return
		end

		for iter0_44 = 1, #arg0_44 do
			local var0_44 = arg0_44[iter0_44].id

			if var1_43:GetFreezeShipByID(var0_44) then
				local var1_44 = var1_43:GetFreezeShipByID(var0_44)

				setSlider(arg2_44[iter0_44]:Find("blood"), 0, 1, var1_44:GetHPRate())
				SetActive(arg2_44[iter0_44]:Find("mask"), false)
			elseif var1_43:GetShipByID(var0_44) then
				local var2_44 = var1_43:GetShipByID(var0_44)

				setSlider(arg2_44[iter0_44]:Find("blood"), 0, 1, var2_44:GetHPRate())
				SetActive(arg2_44[iter0_44]:Find("mask"), false)
			else
				setSlider(arg2_44[iter0_44]:Find("blood"), 0, 1, 0)
				SetActive(arg2_44[iter0_44]:Find("mask"), true)
			end
		end
	end

	var4_43(arg0_43._mainShipVOs, var2_43, arg0_43.mainTFs)
	var4_43(arg0_43._vanShipVOs, var3_43, arg0_43.vanTFs)
	setText(arg0_43.LeftTime, ys.Battle.BattleTimerView.formatTime(math.floor(var0_43:GetCountDown())))
end

function var0_0.AddUIFX(arg0_45, arg1_45, arg2_45)
	arg2_45 = arg2_45 or 1

	local var0_45 = arg2_45 > 0

	arg1_45 = tf(arg1_45)

	local var1_45 = var0_45 and arg0_45._fxContainerUpper or arg0_45._fxContainerBottom

	arg1_45:SetParent(var1_45)
	pg.ViewUtils.SetSortingOrder(arg1_45, arg0_45._canvasOrder + arg2_45)
	pg.ViewUtils.SetLayer(arg1_45, Layer.UI)

	return var1_45.localScale
end

function var0_0.OnCloseChat(arg0_46)
	local var0_46 = ys.Battle.BattleState.GetInstance():IsBotActive()
	local var1_46 = arg0_46._chatBtn:GetComponent(typeof(Animation))

	if var0_46 then
		setActive(arg0_46._chatBtn, true)

		if var1_46 then
			var1_46:Play("chatbtn_in")
		end
	elseif var1_46 then
		var1_46:Play("chatbtn_out")
	else
		setActive(arg0_46._chatBtn, false)
	end
end

function var0_0.clear(arg0_47)
	arg0_47._preSkillTF = nil

	arg0_47._skillFloatPool:AllRecycle()
	arg0_47._skillFloatCMDPool:AllRecycle()

	arg0_47._preCommanderSkillTF = nil
	arg0_47._commanderSkillList = nil
	arg0_47._skillPaintings = nil
	arg0_47._currentPainting = nil

	Destroy(arg0_47._paintingUI)
end

function var0_0.willExit(arg0_48)
	arg0_48._skillFloatPool:Dispose()
	arg0_48._skillFloatCMDPool:Dispose()
	ys.Battle.BattleState.GetInstance():ExitBattle()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_48.pauseWindow, arg0_48._tf)
	ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCamera(false)
	pg.CameraFixMgr.GetInstance():disconnect(arg0_48.camEventId)
end

return var0_0
