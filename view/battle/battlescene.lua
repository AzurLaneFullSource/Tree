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

function var0_0.forceRatio(arg0_2)
	local var0_2 = pg.CameraFixMgr.GetInstance().targetRatio

	return math.max(var0_2, 1.77777777777778)
end

function var0_0.getBGM(arg0_3)
	local var0_3 = {}

	table.insert(var0_3, arg0_3.contextData.system == SYSTEM_WORLD and checkExist(pg.world_expedition_data[arg0_3.contextData.stageId], {
		"bgm"
	}) or "")
	table.insert(var0_3, pg.expedition_data_template[arg0_3.contextData.stageId].bgm)

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if iter1_3 ~= "" then
			return iter1_3
		end
	end

	return var0_0.super.getBGM(arg0_3)
end

function var0_0.init(arg0_4)
	var1_0 = ys.Battle.BattleVariable

	local var0_4 = pg.UIMgr.GetInstance():GetMainCamera()
	local var1_4 = GameObject.Find("UICamera")

	arg0_4.uiCanvas = findTF(var1_4, "Canvas/UIMain")
	arg0_4.skillTips = arg0_4._tf:Find("Skill_Activation")
	arg0_4.skillRoot = arg0_4._tf:Find("Skill_Activation/Root")
	arg0_4.skillTpl = arg0_4._tf:Find("Skill_Activation/mask").gameObject
	arg0_4._skillFloatPool = pg.Pool.New(arg0_4.skillRoot, arg0_4.skillTpl, 15, 10, true, false):InitSize()

	arg0_4._skillFloatPool:SetRecycleFuncs(function(arg0_5)
		arg0_5.transform:GetComponent(typeof(DftAniEvent)):OnDestroy()
	end)

	arg0_4.skillCMDRoot = arg0_4._tf:Find("Skill_Activation/Root_cmd")
	arg0_4.skillCMDTpl = arg0_4._tf:Find("Skill_Activation/mask_cmd").gameObject
	arg0_4._skillFloatCMDPool = pg.Pool.New(arg0_4.skillCMDRoot, arg0_4.skillCMDTpl, 2, 4, true, false):InitSize()

	arg0_4._skillFloatCMDPool:SetRecycleFuncs(function(arg0_6)
		arg0_6.transform:GetComponent(typeof(DftAniEvent)):OnDestroy()
	end)

	arg0_4.popupTpl = arg0_4:getTpl("popup")

	SetActive(arg0_4._go, false)

	arg0_4._skillPaintings = {}
	arg0_4._skillFloat = true
	arg0_4._cacheSkill = {}
	arg0_4._commanderSkillList = {}
	arg0_4._sideSkillFloatStateList = {}
	arg0_4._sideSkillFloatStateList[ys.Battle.BattleConfig.FRIENDLY_CODE] = {
		{},
		{},
		{}
	}
	arg0_4._sideSkillFloatStateList[ys.Battle.BattleConfig.FOE_CODE] = {
		{},
		{},
		{}
	}

	arg0_4:initPainting()

	arg0_4._fxContainerUpper = arg0_4._tf:Find("FXContainerUpper")
	arg0_4._fxContainerBottom = arg0_4._tf:Find("FXContainerBottom")

	local var2_4 = arg0_4._tf:GetComponentInParent(typeof(UnityEngine.Canvas))

	arg0_4._canvasOrder = var2_4 and var2_4.sortingOrder or 0
	arg0_4._ratioFitter = GetComponent(arg0_4._tf, typeof(AspectRatioFitter))

	if not BATTLE_DEFAULT_UNIT_DETAIL then
		arg0_4._go:AddComponent(typeof(RectMask2D))
	end
end

function var0_0.initPainting(arg0_7)
	local var0_7 = ys.Battle.BattleResourceManager.GetInstance():InstSkillPaintingUI()

	setParent(var0_7, arg0_7.uiCanvas, false)

	arg0_7._paintingUI = var0_7
	arg0_7._paintingAnimator = var0_7:GetComponent(typeof(Animator))
	arg0_7._paintingAnimator.enabled = false
	arg0_7._paintingParticleContainer = findTF(var0_7, "particleContainer")
	arg0_7._paintingParticles = findTF(arg0_7._paintingParticleContainer, "effect")
	arg0_7._paintingParticleSystem = arg0_7._paintingParticles:GetComponent(typeof(ParticleSystem))

	arg0_7._paintingParticleSystem:Stop(true)

	arg0_7._paintingFitter = findTF(var0_7, "hero/fitter")

	removeAllChildren(arg0_7._paintingFitter)

	local var1_7 = GetOrAddComponent(arg0_7._paintingFitter, "PaintingScaler")

	var1_7.FrameName = "lihuisha"
	var1_7.Tween = 1

	var0_7:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_8)
		if arg0_7._currentPainting then
			setActive(arg0_7._currentPainting, false)

			arg0_7._currentPainting = nil
		end
	end)
end

function var0_0.EnableSkillFloat(arg0_9, arg1_9)
	if arg1_9 == arg0_9._skillFloat then
		return
	end

	arg0_9._skillFloat = arg1_9

	if arg0_9._skillFloat then
		for iter0_9, iter1_9 in ipairs(arg0_9._cacheSkill) do
			arg0_9:SkillHrzPop(iter1_9.skillName, iter1_9.caster, iter1_9.commander, iter1_9.hrzIcon)
		end

		arg0_9._cacheSkill = {}
	else
		arg0_9._skillFloatPool:AllRecycle()
		arg0_9._skillFloatCMDPool:AllRecycle()

		arg0_9._preCommanderSkillTF = nil
		arg0_9._preSkillTF = nil
	end

	SetActive(arg0_9.skillTips, arg1_9)
end

function var0_0.SkillHrzPop(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	if not arg0_10._skillFloat then
		table.insert(arg0_10._cacheSkill, {
			skillName = arg1_10,
			caster = arg2_10,
			commander = arg3_10,
			hrzIcon = arg4_10
		})

		return
	end

	local var0_10 = ys.Battle.BattleResourceManager.GetInstance()
	local var1_10
	local var2_10

	if arg3_10 then
		if arg0_10._commanderSkillList[arg3_10] and arg0_10._commanderSkillList[arg3_10][arg1_10] then
			return
		end

		var1_10 = arg0_10._skillFloatCMDPool

		if ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
			var2_10 = var0_10:GetCommanderHrzIcon(arg3_10)
		else
			var2_10 = var0_10:GetCommanderIcon(arg3_10)
		end
	else
		var1_10 = arg0_10._skillFloatPool

		if arg2_10:GetUnitType() == ys.Battle.BattleConst.UnitType.PLAYER_UNIT then
			local var3_10 = arg4_10 or arg2_10:GetTemplate().painting

			if ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
				var2_10 = var0_10:GetCharacterIcon(var3_10)
			else
				var2_10 = var0_10:GetCharacterSquareIcon(var3_10)
			end
		elseif ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
			var2_10 = var0_10:GetCharacterIcon(pg.enemy_data_statistics[arg2_10:GetTemplateID()].icon)
		else
			var2_10 = var0_10:GetCharacterSquareIcon(pg.enemy_data_statistics[arg2_10:GetTemplateID()].icon)
		end
	end

	local var4_10 = var1_10:GetObject()
	local var5_10 = var4_10.transform

	var5_10.localScale = var0_0.SKILL_FLOAT_SCALE

	setText(findTF(var5_10, "skill/skill_name/Text"), SwitchSpecialChar(HXSet.hxLan(arg1_10)))

	local var6_10 = findTF(var5_10, "skill/icon_mask/icon")
	local var7_10 = findTF(var5_10, "skill/skill_name")
	local var8_10 = var5_10:GetComponent(typeof(Animation))

	if var8_10 then
		local var9_10 = 1

		while var8_10:GetClip("anim_skinui_skill_" .. var9_10) do
			var9_10 = var9_10 + 1
		end

		if var9_10 > 1 then
			var8_10:Play("anim_skinui_skill_" .. math.random(var9_10 - 1))
		end
	end

	var6_10:GetComponent(typeof(Image)).sprite = var2_10

	local var10_10, var11_10 = arg2_10:GetIFF()

	if arg2_10:GetIFF() == ys.Battle.BattleConfig.FRIENDLY_CODE then
		var11_10 = Color.New(1, 1, 1, 1)
	else
		var11_10 = Color.New(1, 0.33, 0.33, 1)
	end

	var7_10:GetComponent(typeof(Image)).color = var11_10
	findTF(var5_10, "skill"):GetComponent(typeof(Image)).color = var11_10

	if arg3_10 then
		arg0_10:commanderSkillFloat(arg3_10, arg1_10, var4_10)
	else
		local var12_10 = var1_0.CameraPosToUICamera(arg2_10:GetPosition():Clone())
		local var13_10 = ys.Battle.BattleCameraUtil.GetInstance():GetCharacterArrowBarPosition(var12_10)
		local var14_10 = table.contains(ShipType.SubShipType, arg2_10:GetTemplate().type)
		local var15_10 = arg2_10:GetMainUnitIndex()

		if var13_10 == nil or var13_10 == nil and var14_10 and not arg2_10:IsMainFleetUnit() then
			if var10_10 == ys.Battle.BattleConfig.FRIENDLY_CODE then
				var12_10 = var1_0.CameraPosToUICamera(arg2_10:GetPosition():Clone():Add(var0_0.IN_VIEW_FRIEND_SKILL_OFFSET))
			else
				var12_10 = var1_0.CameraPosToUICamera(arg2_10:GetPosition():Clone():Add(var0_0.IN_VIEW_FOE_SKILL_OFFSET))
			end

			var5_10.position = Vector3(var12_10.x, var12_10.y, -2)

			local var16_10 = rtf(var5_10).rect.width * 0.5
			local var17_10 = var5_10.anchoredPosition
			local var18_10 = var17_10.x

			if Screen.width * 0.5 < var16_10 + var18_10 then
				var17_10.x = var18_10 - rtf(var5_10).rect.width
				var5_10.anchoredPosition = var17_10
			end

			if arg0_10._preSkillTF then
				arg0_10.handleSkillFloatCld(arg0_10._preSkillTF, var5_10)
			end

			arg0_10._preSkillTF = var5_10

			var5_10:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_11)
				arg0_10._preSkillTF = nil

				var1_10:Recycle(var4_10)
			end)
		else
			local var19_10
			local var20_10 = var0_0.SIDE_ALIGNMENT[var15_10]
			local var21_10 = arg0_10._sideSkillFloatStateList[var10_10][var15_10]

			for iter0_10 = 1, #var21_10 do
				if var21_10[iter0_10] then
					var19_10 = iter0_10

					break
				end
			end

			if var19_10 == nil then
				var19_10 = #var21_10 + 1
			end

			var21_10[var19_10] = false
			var5_10.position = Vector3(var13_10.x, var13_10.y, -2)

			local var22_10 = var5_10.anchoredPosition

			var22_10.y = var20_10[var19_10]

			if var10_10 == ys.Battle.BattleConfig.FOE_CODE then
				var22_10.x = var0_0.FOE_SIDE_X_OFFSET
			end

			var5_10.anchoredPosition = var22_10

			var5_10:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_12)
				var21_10[var19_10] = true

				var1_10:Recycle(var4_10)
			end)
		end
	end
end

function var0_0.SkillHrzPopCover(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13:SkillHrzPop(arg1_13, arg2_13, nil, arg3_13)
end

function var0_0.handleSkillFloatCld(arg0_14, arg1_14)
	local var0_14 = arg1_14.anchoredPosition
	local var1_14 = arg0_14.anchoredPosition.y

	if math.floor(math.abs(var0_14.y - var1_14)) <= 112.5 then
		var0_14.y = var1_14 + 112.5
		arg1_14.anchoredPosition = var0_14
	end
end

function var0_0.handleSkillSinkCld(arg0_15, arg1_15)
	return
end

function var0_0.commanderSkillFloat(arg0_16, arg1_16, arg2_16, arg3_16)
	arg0_16._commanderSkillList[arg1_16] = arg0_16._commanderSkillList[arg1_16] or {}
	arg0_16._commanderSkillList[arg1_16][arg2_16] = true

	local var0_16 = arg3_16.transform
	local var1_16 = var0_16.anchoredPosition

	var1_16.x = 0
	var1_16.y = 0
	var0_16.anchoredPosition = var1_16

	if arg0_16._preCommanderSkillTF then
		local var2_16 = arg0_16._preCommanderSkillTF.anchoredPosition.y

		if math.floor(math.abs(var1_16.y - var2_16)) <= 97.5 then
			var1_16.y = var2_16 - 97.5
		end
	end

	var0_16.anchoredPosition = var1_16
	arg0_16._preCommanderSkillTF = var0_16

	var0_16:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_17)
		arg0_16._commanderSkillList[arg1_16][arg2_16] = nil
		arg0_16._preCommanderSkillTF = nil

		arg0_16._skillFloatCMDPool:Recycle(arg3_16)
	end)
end

function var0_0.CutInPainting(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18)
	if arg0_18._currentPainting then
		arg0_18._paintingAnimator.enabled = false

		setActive(arg0_18._currentPainting, false)
	end

	local var0_18 = arg4_18 or arg1_18.painting or arg1_18.prefab

	if arg0_18._skillPaintings[var0_18] == nil then
		local var1_18 = ys.Battle.BattleResourceManager.GetInstance():InstPainting(var0_18)

		arg0_18._skillPaintings[var0_18] = var1_18

		setParent(var1_18, arg0_18._paintingFitter, false)
	end

	arg0_18._currentPainting = arg0_18._skillPaintings[var0_18]

	setActive(arg0_18._currentPainting, true)
	LuaHelper.SetParticleSpeed(arg0_18._paintingUI, arg2_18)

	local var2_18 = Vector3(arg3_18, 1, 1)

	arg0_18._paintingUI.transform.localScale = var2_18
	arg0_18._paintingParticleContainer.transform.localScale = var2_18
	arg0_18._paintingParticles.transform.localEulerAngles = Vector3(0, 90 * arg3_18, 0)

	arg0_18._paintingParticleSystem:Play(true)

	arg0_18._paintingAnimator.speed = arg2_18
	arg0_18._paintingAnimator.enabled = true

	arg0_18._paintingAnimator:Play("skill_painting", -1, 0)
end

function var0_0.CutInPaintingDAL(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19 = ys.Battle.BattleResourceManager.GetInstance():InstSkillPaintingDALUI()

	setParent(var0_19, arg0_19.uiCanvas, false)

	local var1_19 = findTF(var0_19, "hero/fitter")
	local var2_19 = arg4_19.cutin_cover_DAL
	local var3_19 = GetOrAddComponent(var1_19, "PaintingScaler")

	var3_19.FrameName = "lihuisha"
	var3_19.Tween = 1

	local var4_19 = ys.Battle.BattleResourceManager.GetInstance():InstPainting(var2_19)

	setParent(var4_19, var1_19, false)
	var0_19:GetComponent(typeof(Animator)):Play("skill_painting", -1, 0)
	setText(findTF(var0_19, "pop/text"), arg4_19.cutin_script)
	var0_19:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_20)
		setActive(var0_19, false)
	end)
end

function var0_0.didEnter(arg0_21)
	setActive(arg0_21._tf, false)

	arg0_21._ratioFitter.enabled = true
	arg0_21._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	arg0_21.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_22, arg1_22)
		arg0_21._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	end)

	local var0_21 = ys.Battle.BattleState.GetInstance()

	var0_21:SetBattleUI(arg0_21)
	onButton(arg0_21, arg0_21._tf:Find("PauseBtn"), function()
		arg0_21:emit(BattleMediator.ON_PAUSE)
	end, SFX_CONFIRM)

	arg0_21._chatBtn = arg0_21._tf:Find("chatBtnContainer/chatBtn")

	local var1_21 = arg0_21._chatBtn:GetComponent(typeof(Animation))

	onButton(arg0_21, arg0_21._chatBtn, function()
		arg0_21:emit(BattleMediator.ON_CHAT, arg0_21._tf:Find("chatContainer"))

		if not var1_21 then
			setActive(arg0_21._chatBtn, false)
		else
			var1_21:Play("chatbtn_out")
		end
	end)
	onToggle(arg0_21, arg0_21._tf:Find("AutoBtn"), function(arg0_25)
		local var0_25 = var0_21:GetBattleType()

		arg0_21:emit(BattleMediator.ON_AUTO, {
			isOn = not arg0_25,
			toggle = arg0_21._tf:Find("AutoBtn"),
			system = var0_25
		})
		var0_21:ActiveBot(ys.Battle.BattleState.IsAutoBotActive(var0_25))

		if var0_21:ChatUseable() then
			setActive(arg0_21._chatBtn, true)

			if var1_21 then
				var1_21:Play("chatbtn_in")
			end
		elseif var1_21 then
			var1_21:Play("chatbtn_out")
		else
			setActive(arg0_21._chatBtn, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	onButton(arg0_21, arg0_21._tf:Find("CardPuzzleConsole/relic/bg"), function()
		local var0_26 = var0_21:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent():GetRelicList()

		arg0_21:emit(BattleMediator.ON_PUZZLE_RELIC, {
			relicList = var0_26
		})
	end, SFX_CONFIRM)
	onButton(arg0_21, arg0_21._tf:Find("CardPuzzleConsole/deck/bg"), function()
		local var0_27 = var0_21:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent()
		local var1_27 = var0_27:GetDeck():GetCardList()
		local var2_27 = var0_27:GetHand():GetCardList()

		arg0_21:emit(BattleMediator.ON_PUZZLE_CARD, {
			card = var1_27,
			hand = var2_27
		})
	end, SFX_CONFIRM)
	var0_21:ConfigBattleEndFunc(function(arg0_28)
		arg0_21:clear()
		arg0_21:emit(BattleMediator.ON_BATTLE_RESULT, arg0_28)
	end)

	local var2_21 = ys.Battle.BattleConst.BuffEffectType
	local var3_21 = {
		var2_21.ON_START_GAME,
		var2_21.ON_FLAG_SHIP,
		var2_21.ON_CONSORT,
		var2_21.ON_LEADER,
		var2_21.ON_REAR,
		var2_21.ON_SUB_LEADER,
		var2_21.ON_SUB_CONSORT
	}
	local var4_21 = 0

	local function var5_21(arg0_29)
		local var0_29 = 0

		for iter0_29, iter1_29 in ipairs(arg0_29) do
			var0_29 = var0_29 + ys.Battle.BattleDataFunction.GetShipSkillTriggerCount(iter1_29, var3_21)
		end

		return var0_29
	end

	local var6_21 = var4_21 + var5_21(arg0_21.contextData.battleData.MainUnitList) + var5_21(arg0_21.contextData.battleData.VanguardUnitList) + var5_21(arg0_21.contextData.battleData.SubUnitList) + 4

	arg0_21._skillFloatPool = pg.Pool.New(arg0_21.skillRoot, arg0_21.skillTpl, var6_21, 10, true, false):InitSize()

	arg0_21._skillFloatPool:SetRecycleFuncs(function(arg0_30)
		arg0_30.transform:GetComponent(typeof(DftAniEvent)):OnDestroy()
	end)
	arg0_21:emit(BattleMediator.ENTER)
	arg0_21:initPauseWindow()

	if arg0_21.contextData.prePause then
		triggerButton(arg0_21._tf:Find("PauseBtn"))
	end

	setActive(arg0_21._chatBtn, var0_21:ChatUseable())
end

function var0_0.onBackPressed(arg0_31)
	if isActive(arg0_31.pauseWindow) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_31.continueBtn)
	end
end

function var0_0.activeBotHelp(arg0_32, arg1_32)
	local var0_32 = getProxy(PlayerProxy)

	if not arg1_32 then
		if arg0_32.autoBotHelp then
			pg.MsgboxMgr.GetInstance():hide()
		end

		return
	end

	if var0_32.botHelp then
		return
	end

	arg0_32.autoBotHelp = true

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
			arg0_32.autoBotHelp = false
		end
	})

	var0_32.botHelp = true
end

function var0_0.exitBattle(arg0_34, arg1_34)
	if not arg1_34 then
		arg0_34:emit(BattleMediator.ON_QUIT_BATTLE_MANUALLY)
		arg0_34:emit(BattleMediator.ON_BACK_PRE_SCENE)
	elseif arg1_34 == "kick" then
		-- block empty
	end
end

function var0_0.setChapter(arg0_35, arg1_35)
	arg0_35._chapter = arg1_35
end

function var0_0.setFleet(arg0_36, arg1_36, arg2_36, arg3_36)
	arg0_36._mainShipVOs = arg1_36
	arg0_36._vanShipVOs = arg2_36
	arg0_36._subShipVOs = arg3_36
end

function var0_0.initPauseWindow(arg0_37)
	arg0_37.pauseWindow = arg0_37._tf:Find("Msgbox")
	arg0_37.LeftTimeContainer = arg0_37.pauseWindow:Find("window/LeftTime")
	arg0_37.LeftTime = arg0_37.pauseWindow:Find("window/LeftTime/Text")
	arg0_37.mainTFs = {}
	arg0_37.vanTFs = {}

	setText(arg0_37.LeftTimeContainer:Find("label"), i18n("battle_battleMediator_remainTime"))
	setText(arg0_37.pauseWindow:Find("window/van/power/title"), i18n("word_vanguard_fleet"))
	setText(arg0_37.pauseWindow:Find("window/main/power/title"), i18n("word_main_fleet"))

	local function var0_37(arg0_38, arg1_38, arg2_38)
		for iter0_38 = 1, 3 do
			local var0_38 = arg1_38:Find("ship_" .. iter0_38)

			setActive(var0_38, arg2_38 and iter0_38 <= #arg2_38)

			if arg2_38 and iter0_38 <= #arg2_38 then
				updateShip(var0_38, arg2_38[iter0_38])
			end

			table.insert(arg0_38, var0_38)
		end

		if arg2_38 then
			local var1_38 = 0

			for iter1_38, iter2_38 in ipairs(arg2_38) do
				var1_38 = var1_38 + iter2_38:getShipCombatPower()
			end

			setText(arg1_38:Find("power/value"), var1_38)
		end
	end

	local var1_37 = ys.Battle.BattleState.GetInstance()
	local var2_37 = var1_37:GetBattleType()

	if arg0_37._mainShipVOs then
		var0_37(arg0_37.mainTFs, arg0_37.pauseWindow:Find("window/main"), arg0_37._mainShipVOs)
		var0_37(arg0_37.vanTFs, arg0_37.pauseWindow:Find("window/van"), arg0_37._vanShipVOs)
	elseif var2_37 == SYSTEM_SCENARIO_SUB_STRIKE then
		arg0_37.subTFs = {}

		local var3_37 = arg0_37.pauseWindow:Find("window/main")

		setActive(arg0_37.pauseWindow:Find("window/van"), false)
		setActive(arg0_37.pauseWindow:Find("window/bg_fleet/Image (1)"), false)
		var0_37(arg0_37.subTFs, var3_37, arg0_37._subShipVOs)
		setText(var3_37:Find("power/title"), i18n("index_shipType_qianTing"))

		local var4_37 = var3_37.localPosition

		var3_37.localPosition = Vector3(0, var4_37.y, 0)
	end

	local var5_37 = findTF(arg0_37.pauseWindow, "window/Chapter")
	local var6_37 = findTF(arg0_37.pauseWindow, "window/Chapter/Text")

	arg0_37.continueBtn = arg0_37.pauseWindow:Find("window/button_container/continue")
	arg0_37.leaveBtn = arg0_37.pauseWindow:Find("window/button_container/leave")

	setText(arg0_37.continueBtn:Find("pic"), i18n("battle_battleMediator_goOnFight"))
	setText(arg0_37.leaveBtn:Find("pic"), i18n("battle_battleMediator_existFight"))

	if var2_37 == SYSTEM_SCENARIO or var2_37 == SYSTEM_SCENARIO_SUB_STRIKE then
		local var7_37 = arg0_37._chapter:getConfigTable()

		setText(var5_37, var7_37.chapter_name)
		setText(var6_37, string.split(var7_37.name, "|")[1])
	elseif var2_37 == SYSTEM_ROUTINE or var2_37 == SYSTEM_DUEL or var2_37 == SYSTEM_HP_SHARE_ACT_BOSS or var2_37 == SYSTEM_BOSS_EXPERIMENT or var2_37 == SYSTEM_ACT_BOSS or var2_37 == SYSTEM_ACT_BOSS_SP or var2_37 == SYSTEM_BOSS_RUSH or var2_37 == SYSTEM_BOSS_RUSH_EX or var2_37 == SYSTEM_BOSS_RUSH_COLLABRATE or var2_37 == SYSTEM_LIMIT_CHALLENGE or var2_37 == SYSTEM_BOSS_SINGLE or var2_37 == SYSTEM_BOSS_SINGLE_VARIABLE then
		setText(var5_37, "SP")

		local var8_37 = var1_37:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().StageTmpId
		local var9_37 = pg.expedition_data_template[var8_37]

		setText(var6_37, var9_37.name)
	elseif var2_37 == SYSTEM_DEBUG then
		setText(var5_37, "??")
		setText(var6_37, "碧蓝梦境")
	elseif var2_37 == SYSTEM_CHALLENGE then
		local var10_37 = arg0_37._chapter:getNextExpedition()

		setText(var5_37, "SP")
		setText(var6_37, var10_37.chapter_name[2])
		setActive(arg0_37.LeftTimeContainer, true)
	elseif var2_37 == SYSTEM_WORLD_BOSS or var2_37 == SYSTEM_WORLD then
		setText(var5_37, i18n("world_battle_pause"))
		setText(var6_37, i18n("world_battle_pause2"))

		if var2_37 == SYSTEM_WORLD_BOSS then
			setActive(arg0_37.leaveBtn, false)
		end
	elseif var2_37 == SYSTEM_GUILD then
		local var11_37 = var1_37:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().ActID
		local var12_37 = pg.guild_boss_event[var11_37]

		setText(var5_37, "BOSS")
		setText(var6_37, var12_37 and var12_37.name or "")
	elseif var2_37 == SYSTEM_TEST or var2_37 == SYSTEM_SUB_ROUTINE or var2_37 == SYSTEM_SCENARIO_SUB_STRIKE or var2_37 == SYSTEM_PERFORM or var2_37 == SYSTEM_PROLOGUE or var2_37 == SYSTEM_DODGEM or var2_37 == SYSTEM_SIMULATION or var2_37 == SYSTEM_SUBMARINE_RUN or var2_37 == SYSTEM_BOSS_EXPERIMENT or var2_37 == SYSTEM_REWARD_PERFORM or var2_37 == SYSTEM_AIRFIGHT then
		-- block empty
	elseif var2_37 == SYSTEM_CARDPUZZLE then
		-- block empty
	else
		assert(false, "System not defined " .. (var2_37 or "NIL"))
	end

	onButton(arg0_37, arg0_37.leaveBtn, function()
		arg0_37:emit(BattleMediator.ON_LEAVE)

		local var0_39 = arg0_37.leaveBtn:GetComponent(typeof(Animation))

		if var0_39 and var0_39:GetClip("msgbox_btn_blink") then
			var0_39:Play("msgbox_btn_blink")
		end
	end)
	onButton(arg0_37, arg0_37.continueBtn, function()
		local var0_40 = arg0_37.continueBtn:GetComponent(typeof(Animation))

		if var0_40 and var0_40:GetClip("msgbox_btn_blink") then
			var0_40:Play("msgbox_btn_blink")
		end

		local var1_40 = arg0_37.pauseWindow:GetComponent(typeof(Animation))

		if var1_40 then
			if var1_40:IsPlaying("msgbox_out") then
				var1_40:Stop("msgbox_out")
				var1_40:Play("msgbox_in")
			else
				var1_40:Play("msgbox_out")
				arg0_37.pauseWindow:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_41)
					arg0_37:ClosePauseWindow()
					var1_37:Resume()
				end)
			end
		else
			arg0_37:ClosePauseWindow()
			var1_37:Resume()
		end
	end)
	onButton(arg0_37, arg0_37.pauseWindow:Find("help"), function()
		if BATTLE_DEBUG and PLATFORM == 7 then
			arg0_37:ClosePauseWindow()
			var1_37:Resume()
			var1_37:OpenConsole()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("help_battle_rule")
			})
		end
	end)
	onButton(arg0_37, arg0_37.pauseWindow:Find("window/top/btnBack"), function()
		triggerButton(arg0_37.continueBtn)
	end)
	onButton(arg0_37, arg0_37.pauseWindow, function()
		triggerButton(arg0_37.continueBtn)
	end)
	onButton(arg0_37, arg0_37.pauseWindow, function()
		local var0_45 = arg0_37.pauseWindow:GetComponent(typeof(Animation))

		if var0_45 and var0_45:IsPlaying("msgbox_out") then
			-- block empty
		else
			triggerButton(arg0_37.continueBtn)
		end
	end)
	setActive(arg0_37.pauseWindow, false)
end

function var0_0.updatePauseWindow(arg0_46)
	if not arg0_46.pauseWindow then
		return
	end

	setActive(arg0_46.pauseWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_46.pauseWindow)

	local var0_46 = ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name)
	local var1_46 = var0_46:GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE)

	local function var2_46(arg0_47, arg1_47)
		if not arg0_47 then
			return
		end

		for iter0_47 = 1, #arg0_47 do
			local var0_47 = arg0_47[iter0_47].id

			if var1_46:GetFreezeShipByID(var0_47) then
				local var1_47 = var1_46:GetFreezeShipByID(var0_47)

				setSlider(arg1_47[iter0_47]:Find("blood"), 0, 1, var1_47:GetHPRate())
				SetActive(arg1_47[iter0_47]:Find("mask"), false)
			elseif var1_46:GetShipByID(var0_47) then
				local var2_47 = var1_46:GetShipByID(var0_47)

				setSlider(arg1_47[iter0_47]:Find("blood"), 0, 1, var2_47:GetHPRate())
				SetActive(arg1_47[iter0_47]:Find("mask"), false)
			else
				setSlider(arg1_47[iter0_47]:Find("blood"), 0, 1, 0)
				SetActive(arg1_47[iter0_47]:Find("mask"), true)
			end
		end
	end

	var2_46(arg0_46._mainShipVOs, arg0_46.mainTFs)
	var2_46(arg0_46._vanShipVOs, arg0_46.vanTFs)

	if arg0_46.subTFs then
		var2_46(arg0_46._subShipVOs, arg0_46.subTFs)
	end

	setText(arg0_46.LeftTime, ys.Battle.BattleTimerView.formatTime(math.floor(var0_46:GetCountDown())))
end

function var0_0.ClosePauseWindow(arg0_48)
	setActive(arg0_48.pauseWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_48.pauseWindow, arg0_48._tf)
end

function var0_0.AddUIFX(arg0_49, arg1_49, arg2_49)
	arg2_49 = arg2_49 or 1

	local var0_49 = arg2_49 > 0

	arg1_49 = tf(arg1_49)

	local var1_49 = var0_49 and arg0_49._fxContainerUpper or arg0_49._fxContainerBottom

	arg1_49:SetParent(var1_49)
	pg.ViewUtils.SetSortingOrder(arg1_49, arg0_49._canvasOrder + arg2_49)
	pg.ViewUtils.SetLayer(arg1_49, Layer.UI)

	return var1_49.localScale
end

function var0_0.OnCloseChat(arg0_50)
	local var0_50 = ys.Battle.BattleState.GetInstance():IsBotActive()
	local var1_50 = arg0_50._chatBtn:GetComponent(typeof(Animation))

	if var0_50 then
		setActive(arg0_50._chatBtn, true)

		if var1_50 then
			var1_50:Play("chatbtn_in")
		end
	elseif var1_50 then
		var1_50:Play("chatbtn_out")
	else
		setActive(arg0_50._chatBtn, false)
	end
end

function var0_0.clear(arg0_51)
	arg0_51._preSkillTF = nil

	arg0_51._skillFloatPool:AllRecycle()
	arg0_51._skillFloatCMDPool:AllRecycle()

	arg0_51._preCommanderSkillTF = nil
	arg0_51._commanderSkillList = nil
	arg0_51._skillPaintings = nil
	arg0_51._currentPainting = nil

	Destroy(arg0_51._paintingUI)
end

function var0_0.willExit(arg0_52)
	arg0_52._skillFloatPool:Dispose()
	arg0_52._skillFloatCMDPool:Dispose()
	ys.Battle.BattleState.GetInstance():ExitBattle()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_52.pauseWindow, arg0_52._tf)
	ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCamera(false)
	pg.CameraFixMgr.GetInstance():disconnect(arg0_52.camEventId)
end

return var0_0
