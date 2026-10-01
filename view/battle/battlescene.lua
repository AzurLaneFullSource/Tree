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

function var0_0.getResource(arg0_4, arg1_4)
	local var0_4 = {}
	local var1_4 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Base, arg0_4:getUIName())
	local var2_4 = var1_4 .. ResPathSupport.ConstPath.UI.Atlas

	table.insert(var0_4, var1_4)
	table.insert(var0_4, var2_4)

	local var3_4 = {}

	table.insert(var3_4, arg1_4.system == SYSTEM_WORLD and checkExist(pg.world_expedition_data[arg0_4.contextData.stageId], {
		"bgm"
	}) or "")
	table.insert(var3_4, pg.expedition_data_template[arg1_4.stageId].bgm)
	table.insert(var3_4, var0_0.super.getBGM(arg0_4))
	_.each(var3_4, function(arg0_5)
		if arg0_5 ~= "" then
			table.insertto(var0_4, ResPathSupport.GetSoundResList(arg0_5))
		end
	end)

	return var0_4
end

function var0_0.init(arg0_6)
	var1_0 = ys.Battle.BattleVariable

	local var0_6 = pg.UIMgr.GetInstance():GetMainCamera()
	local var1_6 = GameObject.Find("UICamera")

	arg0_6.uiCanvas = findTF(var1_6, "Canvas/UIMain")
	arg0_6.skillTips = arg0_6._tf:Find("Skill_Activation")
	arg0_6.skillRoot = arg0_6._tf:Find("Skill_Activation/Root")
	arg0_6.skillTpl = arg0_6._tf:Find("Skill_Activation/mask").gameObject
	arg0_6._skillFloatPool = pg.Pool.New(arg0_6.skillRoot, arg0_6.skillTpl, 15, 10, true, false):InitSize()

	arg0_6._skillFloatPool:SetRecycleFuncs(function(arg0_7)
		arg0_7.transform:GetComponent(typeof(DftAniEvent)):OnDestroy()
	end)

	arg0_6.skillCMDRoot = arg0_6._tf:Find("Skill_Activation/Root_cmd")
	arg0_6.skillCMDTpl = arg0_6._tf:Find("Skill_Activation/mask_cmd").gameObject
	arg0_6._skillFloatCMDPool = pg.Pool.New(arg0_6.skillCMDRoot, arg0_6.skillCMDTpl, 2, 4, true, false):InitSize()

	arg0_6._skillFloatCMDPool:SetRecycleFuncs(function(arg0_8)
		arg0_8.transform:GetComponent(typeof(DftAniEvent)):OnDestroy()
	end)

	arg0_6.popupTpl = arg0_6:getTpl("popup")

	SetActive(arg0_6._go, false)

	arg0_6._skillPaintings = {}
	arg0_6._skillFloat = true
	arg0_6._cacheSkill = {}
	arg0_6._commanderSkillList = {}
	arg0_6._sideSkillFloatStateList = {}
	arg0_6._sideSkillFloatStateList[ys.Battle.BattleConfig.FRIENDLY_CODE] = {
		{},
		{},
		{}
	}
	arg0_6._sideSkillFloatStateList[ys.Battle.BattleConfig.FOE_CODE] = {
		{},
		{},
		{}
	}

	arg0_6:initPainting()

	arg0_6._fxContainerUpper = arg0_6._tf:Find("FXContainerUpper")
	arg0_6._fxContainerBottom = arg0_6._tf:Find("FXContainerBottom")

	local var2_6 = arg0_6._tf:GetComponentInParent(typeof(UnityEngine.Canvas))

	arg0_6._canvasOrder = var2_6 and var2_6.sortingOrder or 0
	arg0_6._ratioFitter = GetComponent(arg0_6._tf, typeof(AspectRatioFitter))

	if not BATTLE_DEFAULT_UNIT_DETAIL then
		arg0_6._go:AddComponent(typeof(RectMask2D))
	end
end

function var0_0.initPainting(arg0_9)
	local var0_9 = ys.Battle.BattleResourceManager.GetInstance():InstSkillPaintingUI()

	setParent(var0_9, arg0_9.uiCanvas, false)

	arg0_9._paintingUI = var0_9
	arg0_9._paintingAnimator = var0_9:GetComponent(typeof(Animator))
	arg0_9._paintingAnimator.enabled = false
	arg0_9._paintingParticleContainer = findTF(var0_9, "particleContainer")
	arg0_9._paintingParticles = findTF(arg0_9._paintingParticleContainer, "effect")
	arg0_9._paintingParticleSystem = arg0_9._paintingParticles:GetComponent(typeof(ParticleSystem))

	arg0_9._paintingParticleSystem:Stop(true)

	arg0_9._paintingFitter = findTF(var0_9, "hero/fitter")

	removeAllChildren(arg0_9._paintingFitter)

	local var1_9 = GetOrAddComponent(arg0_9._paintingFitter, "PaintingScaler")

	var1_9.FrameName = "lihuisha"
	var1_9.Tween = 1

	var0_9:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_10)
		if arg0_9._currentPainting then
			setActive(arg0_9._currentPainting, false)

			arg0_9._currentPainting = nil
		end
	end)
end

function var0_0.EnableSkillFloat(arg0_11, arg1_11)
	if arg1_11 == arg0_11._skillFloat then
		return
	end

	arg0_11._skillFloat = arg1_11

	if arg0_11._skillFloat then
		for iter0_11, iter1_11 in ipairs(arg0_11._cacheSkill) do
			arg0_11:SkillHrzPop(iter1_11.skillName, iter1_11.caster, iter1_11.commander, iter1_11.hrzIcon)
		end

		arg0_11._cacheSkill = {}
	else
		arg0_11._skillFloatPool:AllRecycle()
		arg0_11._skillFloatCMDPool:AllRecycle()

		arg0_11._preCommanderSkillTF = nil
		arg0_11._preSkillTF = nil
	end

	SetActive(arg0_11.skillTips, arg1_11)
end

function var0_0.SkillHrzPop(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	if not arg0_12._skillFloat then
		table.insert(arg0_12._cacheSkill, {
			skillName = arg1_12,
			caster = arg2_12,
			commander = arg3_12,
			hrzIcon = arg4_12
		})

		return
	end

	local var0_12 = ys.Battle.BattleResourceManager.GetInstance()
	local var1_12
	local var2_12

	if arg3_12 then
		if arg0_12._commanderSkillList[arg3_12] and arg0_12._commanderSkillList[arg3_12][arg1_12] then
			return
		end

		var1_12 = arg0_12._skillFloatCMDPool

		if ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
			var2_12 = var0_12:GetCommanderHrzIcon(arg3_12)
		else
			var2_12 = var0_12:GetCommanderIcon(arg3_12)
		end
	else
		var1_12 = arg0_12._skillFloatPool

		if arg2_12:GetUnitType() == ys.Battle.BattleConst.UnitType.PLAYER_UNIT then
			local var3_12 = arg4_12 or arg2_12:GetTemplate().painting

			if ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
				var2_12 = var0_12:GetCharacterIcon(var3_12)
			else
				var2_12 = var0_12:GetCharacterSquareIcon(var3_12)
			end
		elseif ys.Battle.BattleState.GetCombatSkinKey() == "Standard" then
			var2_12 = var0_12:GetCharacterIcon(pg.enemy_data_statistics[arg2_12:GetTemplateID()].icon)
		else
			var2_12 = var0_12:GetCharacterSquareIcon(pg.enemy_data_statistics[arg2_12:GetTemplateID()].icon)
		end
	end

	local var4_12 = var1_12:GetObject()
	local var5_12 = var4_12.transform

	var5_12.localScale = var0_0.SKILL_FLOAT_SCALE

	setText(findTF(var5_12, "skill/skill_name/Text"), SwitchSpecialChar(HXSet.hxLan(arg1_12)))

	local var6_12 = findTF(var5_12, "skill/icon_mask/icon")
	local var7_12 = findTF(var5_12, "skill/skill_name")
	local var8_12 = var5_12:GetComponent(typeof(Animation))

	if var8_12 then
		local var9_12 = 1

		while var8_12:GetClip("anim_skinui_skill_" .. var9_12) do
			var9_12 = var9_12 + 1
		end

		if var9_12 > 1 then
			var8_12:Play("anim_skinui_skill_" .. math.random(var9_12 - 1))
		end
	end

	var6_12:GetComponent(typeof(Image)).sprite = var2_12

	local var10_12, var11_12 = arg2_12:GetIFF()

	if arg2_12:GetIFF() == ys.Battle.BattleConfig.FRIENDLY_CODE then
		var11_12 = Color.New(1, 1, 1, 1)
	else
		var11_12 = Color.New(1, 0.33, 0.33, 1)
	end

	var7_12:GetComponent(typeof(Image)).color = var11_12
	findTF(var5_12, "skill"):GetComponent(typeof(Image)).color = var11_12

	if arg3_12 then
		arg0_12:commanderSkillFloat(arg3_12, arg1_12, var4_12)
	else
		local var12_12 = var1_0.CameraPosToUICamera(arg2_12:GetPosition():Clone())
		local var13_12 = ys.Battle.BattleCameraUtil.GetInstance():GetCharacterArrowBarPosition(var12_12)
		local var14_12 = table.contains(ShipType.SubShipType, arg2_12:GetTemplate().type)
		local var15_12 = arg2_12:GetMainUnitIndex()

		if var13_12 == nil or var13_12 == nil and var14_12 and not arg2_12:IsMainFleetUnit() then
			if var10_12 == ys.Battle.BattleConfig.FRIENDLY_CODE then
				var12_12 = var1_0.CameraPosToUICamera(arg2_12:GetPosition():Clone():Add(var0_0.IN_VIEW_FRIEND_SKILL_OFFSET))
			else
				var12_12 = var1_0.CameraPosToUICamera(arg2_12:GetPosition():Clone():Add(var0_0.IN_VIEW_FOE_SKILL_OFFSET))
			end

			var5_12.position = Vector3(var12_12.x, var12_12.y, -2)

			local var16_12 = rtf(var5_12).rect.width * 0.5
			local var17_12 = var5_12.anchoredPosition
			local var18_12 = var17_12.x

			if Screen.width * 0.5 < var16_12 + var18_12 then
				var17_12.x = var18_12 - rtf(var5_12).rect.width
				var5_12.anchoredPosition = var17_12
			end

			if arg0_12._preSkillTF then
				arg0_12.handleSkillFloatCld(arg0_12._preSkillTF, var5_12)
			end

			arg0_12._preSkillTF = var5_12

			var5_12:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_13)
				arg0_12._preSkillTF = nil

				var1_12:Recycle(var4_12)
			end)
		else
			local var19_12
			local var20_12 = var0_0.SIDE_ALIGNMENT[var15_12]
			local var21_12 = arg0_12._sideSkillFloatStateList[var10_12][var15_12]

			for iter0_12 = 1, #var21_12 do
				if var21_12[iter0_12] then
					var19_12 = iter0_12

					break
				end
			end

			if var19_12 == nil then
				var19_12 = #var21_12 + 1
			end

			var21_12[var19_12] = false
			var5_12.position = Vector3(var13_12.x, var13_12.y, -2)

			local var22_12 = var5_12.anchoredPosition

			var22_12.y = var20_12[var19_12]

			if var10_12 == ys.Battle.BattleConfig.FOE_CODE then
				var22_12.x = var0_0.FOE_SIDE_X_OFFSET
			end

			var5_12.anchoredPosition = var22_12

			var5_12:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_14)
				var21_12[var19_12] = true

				var1_12:Recycle(var4_12)
			end)
		end
	end
end

function var0_0.SkillHrzPopCover(arg0_15, arg1_15, arg2_15, arg3_15)
	arg0_15:SkillHrzPop(arg1_15, arg2_15, nil, arg3_15)
end

function var0_0.handleSkillFloatCld(arg0_16, arg1_16)
	local var0_16 = arg1_16.anchoredPosition
	local var1_16 = arg0_16.anchoredPosition.y

	if math.floor(math.abs(var0_16.y - var1_16)) <= 112.5 then
		var0_16.y = var1_16 + 112.5
		arg1_16.anchoredPosition = var0_16
	end
end

function var0_0.handleSkillSinkCld(arg0_17, arg1_17)
	return
end

function var0_0.commanderSkillFloat(arg0_18, arg1_18, arg2_18, arg3_18)
	arg0_18._commanderSkillList[arg1_18] = arg0_18._commanderSkillList[arg1_18] or {}
	arg0_18._commanderSkillList[arg1_18][arg2_18] = true

	local var0_18 = arg3_18.transform
	local var1_18 = var0_18.anchoredPosition

	var1_18.x = 0
	var1_18.y = 0
	var0_18.anchoredPosition = var1_18

	if arg0_18._preCommanderSkillTF then
		local var2_18 = arg0_18._preCommanderSkillTF.anchoredPosition.y

		if math.floor(math.abs(var1_18.y - var2_18)) <= 97.5 then
			var1_18.y = var2_18 - 97.5
		end
	end

	var0_18.anchoredPosition = var1_18
	arg0_18._preCommanderSkillTF = var0_18

	var0_18:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_19)
		arg0_18._commanderSkillList[arg1_18][arg2_18] = nil
		arg0_18._preCommanderSkillTF = nil

		arg0_18._skillFloatCMDPool:Recycle(arg3_18)
	end)
end

function var0_0.CutInPainting(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	if arg0_20._currentPainting then
		arg0_20._paintingAnimator.enabled = false

		setActive(arg0_20._currentPainting, false)
	end

	local var0_20 = arg4_20 or arg1_20.painting or arg1_20.prefab

	if arg0_20._skillPaintings[var0_20] == nil then
		local var1_20 = ys.Battle.BattleResourceManager.GetInstance():InstPainting(var0_20)

		arg0_20._skillPaintings[var0_20] = var1_20

		setParent(var1_20, arg0_20._paintingFitter, false)
	end

	arg0_20._currentPainting = arg0_20._skillPaintings[var0_20]

	setActive(arg0_20._currentPainting, true)
	LuaHelper.SetParticleSpeed(arg0_20._paintingUI, arg2_20)

	local var2_20 = Vector3(arg3_20, 1, 1)

	arg0_20._paintingUI.transform.localScale = var2_20
	arg0_20._paintingParticleContainer.transform.localScale = var2_20
	arg0_20._paintingParticles.transform.localEulerAngles = Vector3(0, 90 * arg3_20, 0)

	arg0_20._paintingParticleSystem:Play(true)

	arg0_20._paintingAnimator.speed = arg2_20
	arg0_20._paintingAnimator.enabled = true

	arg0_20._paintingAnimator:Play("skill_painting", -1, 0)
end

function var0_0.CutInPaintingDAL(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
	local var0_21 = ys.Battle.BattleResourceManager.GetInstance():InstSkillPaintingDALUI()

	setParent(var0_21, arg0_21.uiCanvas, false)

	local var1_21 = findTF(var0_21, "hero/fitter")
	local var2_21 = arg4_21.cutin_cover_DAL
	local var3_21 = GetOrAddComponent(var1_21, "PaintingScaler")

	var3_21.FrameName = "lihuisha"
	var3_21.Tween = 1

	local var4_21 = ys.Battle.BattleResourceManager.GetInstance():InstPainting(var2_21)

	setParent(var4_21, var1_21, false)
	var0_21:GetComponent(typeof(Animator)):Play("skill_painting", -1, 0)
	setText(findTF(var0_21, "pop/text"), arg4_21.cutin_script)
	var0_21:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_22)
		setActive(var0_21, false)
	end)
end

function var0_0.didEnter(arg0_23)
	setActive(arg0_23._tf, false)

	arg0_23._ratioFitter.enabled = true
	arg0_23._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	arg0_23.camEventId = pg.CameraFixMgr.GetInstance():bind(pg.CameraFixMgr.ASPECT_RATIO_UPDATE, function(arg0_24, arg1_24)
		arg0_23._ratioFitter.aspectRatio = pg.CameraFixMgr.GetInstance():GetBattleUIRatio()
	end)

	local var0_23 = ys.Battle.BattleState.GetInstance()

	var0_23:SetBattleUI(arg0_23)
	onButton(arg0_23, arg0_23._tf:Find("PauseBtn"), function()
		arg0_23:emit(BattleMediator.ON_PAUSE)
	end, SFX_CONFIRM)

	arg0_23._chatBtn = arg0_23._tf:Find("chatBtnContainer/chatBtn")

	local var1_23 = arg0_23._chatBtn:GetComponent(typeof(Animation))

	onButton(arg0_23, arg0_23._chatBtn, function()
		arg0_23:emit(BattleMediator.ON_CHAT, arg0_23._tf:Find("chatContainer"))

		if not var1_23 then
			setActive(arg0_23._chatBtn, false)
		else
			var1_23:Play("chatbtn_out")
		end
	end)
	onToggle(arg0_23, arg0_23._tf:Find("AutoBtn"), function(arg0_27)
		local var0_27 = var0_23:GetBattleType()

		arg0_23:emit(BattleMediator.ON_AUTO, {
			isOn = not arg0_27,
			toggle = arg0_23._tf:Find("AutoBtn"),
			system = var0_27
		})
		var0_23:ActiveBot(ys.Battle.BattleState.IsAutoBotActive(var0_27))

		if var0_23:ChatUseable() then
			setActive(arg0_23._chatBtn, true)

			if var1_23 then
				var1_23:Play("chatbtn_in")
			end
		elseif var1_23 then
			var1_23:Play("chatbtn_out")
		else
			setActive(arg0_23._chatBtn, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	onButton(arg0_23, arg0_23._tf:Find("CardPuzzleConsole/relic/bg"), function()
		local var0_28 = var0_23:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent():GetRelicList()

		arg0_23:emit(BattleMediator.ON_PUZZLE_RELIC, {
			relicList = var0_28
		})
	end, SFX_CONFIRM)
	onButton(arg0_23, arg0_23._tf:Find("CardPuzzleConsole/deck/bg"), function()
		local var0_29 = var0_23:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE):GetCardPuzzleComponent()
		local var1_29 = var0_29:GetDeck():GetCardList()
		local var2_29 = var0_29:GetHand():GetCardList()

		arg0_23:emit(BattleMediator.ON_PUZZLE_CARD, {
			card = var1_29,
			hand = var2_29
		})
	end, SFX_CONFIRM)
	var0_23:ConfigBattleEndFunc(function(arg0_30)
		arg0_23:clear()
		arg0_23:emit(BattleMediator.ON_BATTLE_RESULT, arg0_30)
	end)

	local var2_23 = ys.Battle.BattleConst.BuffEffectType
	local var3_23 = {
		var2_23.ON_START_GAME,
		var2_23.ON_FLAG_SHIP,
		var2_23.ON_CONSORT,
		var2_23.ON_LEADER,
		var2_23.ON_REAR,
		var2_23.ON_SUB_LEADER,
		var2_23.ON_SUB_CONSORT
	}
	local var4_23 = 0

	local function var5_23(arg0_31)
		local var0_31 = 0

		for iter0_31, iter1_31 in ipairs(arg0_31) do
			var0_31 = var0_31 + ys.Battle.BattleDataFunction.GetShipSkillTriggerCount(iter1_31, var3_23)
		end

		return var0_31
	end

	local var6_23 = var4_23 + var5_23(arg0_23.contextData.battleData.MainUnitList) + var5_23(arg0_23.contextData.battleData.VanguardUnitList) + var5_23(arg0_23.contextData.battleData.SubUnitList) + 4

	arg0_23._skillFloatPool = pg.Pool.New(arg0_23.skillRoot, arg0_23.skillTpl, var6_23, 10, true, false):InitSize()

	arg0_23._skillFloatPool:SetRecycleFuncs(function(arg0_32)
		arg0_32.transform:GetComponent(typeof(DftAniEvent)):OnDestroy()
	end)
	arg0_23:emit(BattleMediator.ENTER)
	arg0_23:initPauseWindow()

	if arg0_23.contextData.prePause then
		triggerButton(arg0_23._tf:Find("PauseBtn"))
	end

	setActive(arg0_23._chatBtn, var0_23:ChatUseable())
end

function var0_0.onBackPressed(arg0_33)
	if isActive(arg0_33.pauseWindow) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_33.continueBtn)
	end
end

function var0_0.activeBotHelp(arg0_34, arg1_34)
	local var0_34 = getProxy(PlayerProxy)

	if not arg1_34 then
		if arg0_34.autoBotHelp then
			pg.MsgboxMgr.GetInstance():hide()
		end

		return
	end

	if var0_34.botHelp then
		return
	end

	arg0_34.autoBotHelp = true

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
			arg0_34.autoBotHelp = false
		end
	})

	var0_34.botHelp = true
end

function var0_0.exitBattle(arg0_36, arg1_36)
	if not arg1_36 then
		arg0_36:emit(BattleMediator.ON_QUIT_BATTLE_MANUALLY)
		arg0_36:emit(BattleMediator.ON_BACK_PRE_SCENE)
	elseif arg1_36 == "kick" then
		-- block empty
	end
end

function var0_0.setChapter(arg0_37, arg1_37)
	arg0_37._chapter = arg1_37
end

function var0_0.setFleet(arg0_38, arg1_38, arg2_38, arg3_38)
	arg0_38._mainShipVOs = arg1_38
	arg0_38._vanShipVOs = arg2_38
	arg0_38._subShipVOs = arg3_38
end

function var0_0.initPauseWindow(arg0_39)
	arg0_39.pauseWindow = arg0_39._tf:Find("Msgbox")
	arg0_39.LeftTimeContainer = arg0_39.pauseWindow:Find("window/LeftTime")
	arg0_39.LeftTime = arg0_39.pauseWindow:Find("window/LeftTime/Text")
	arg0_39.mainTFs = {}
	arg0_39.vanTFs = {}

	setText(arg0_39.LeftTimeContainer:Find("label"), i18n("battle_battleMediator_remainTime"))
	setText(arg0_39.pauseWindow:Find("window/van/power/title"), i18n("word_vanguard_fleet"))
	setText(arg0_39.pauseWindow:Find("window/main/power/title"), i18n("word_main_fleet"))

	local function var0_39(arg0_40, arg1_40, arg2_40)
		for iter0_40 = 1, 3 do
			local var0_40 = arg1_40:Find("ship_" .. iter0_40)

			setActive(var0_40, arg2_40 and iter0_40 <= #arg2_40)

			if arg2_40 and iter0_40 <= #arg2_40 then
				updateShip(var0_40, arg2_40[iter0_40])
			end

			table.insert(arg0_40, var0_40)
		end

		if arg2_40 then
			local var1_40 = 0

			for iter1_40, iter2_40 in ipairs(arg2_40) do
				var1_40 = var1_40 + iter2_40:getShipCombatPower()
			end

			setText(arg1_40:Find("power/value"), var1_40)
		end
	end

	local var1_39 = ys.Battle.BattleState.GetInstance()
	local var2_39 = var1_39:GetBattleType()

	if arg0_39._mainShipVOs then
		var0_39(arg0_39.mainTFs, arg0_39.pauseWindow:Find("window/main"), arg0_39._mainShipVOs)
		var0_39(arg0_39.vanTFs, arg0_39.pauseWindow:Find("window/van"), arg0_39._vanShipVOs)
	elseif var2_39 == SYSTEM_SCENARIO_SUB_STRIKE then
		arg0_39.subTFs = {}

		local var3_39 = arg0_39.pauseWindow:Find("window/main")

		setActive(arg0_39.pauseWindow:Find("window/van"), false)
		setActive(arg0_39.pauseWindow:Find("window/bg_fleet/Image (1)"), false)
		var0_39(arg0_39.subTFs, var3_39, arg0_39._subShipVOs)
		setText(var3_39:Find("power/title"), i18n("index_shipType_qianTing"))

		local var4_39 = var3_39.localPosition

		var3_39.localPosition = Vector3(0, var4_39.y, 0)
	end

	local var5_39 = findTF(arg0_39.pauseWindow, "window/Chapter")
	local var6_39 = findTF(arg0_39.pauseWindow, "window/Chapter/Text")

	arg0_39.continueBtn = arg0_39.pauseWindow:Find("window/button_container/continue")
	arg0_39.leaveBtn = arg0_39.pauseWindow:Find("window/button_container/leave")

	setText(arg0_39.continueBtn:Find("pic"), i18n("battle_battleMediator_goOnFight"))
	setText(arg0_39.leaveBtn:Find("pic"), i18n("battle_battleMediator_existFight"))

	if var2_39 == SYSTEM_SCENARIO or var2_39 == SYSTEM_SCENARIO_SUB_STRIKE then
		local var7_39 = arg0_39._chapter:getConfigTable()

		setText(var5_39, var7_39.chapter_name)
		setText(var6_39, string.split(var7_39.name, "|")[1])
	elseif var2_39 == SYSTEM_ROUTINE or var2_39 == SYSTEM_DUEL or var2_39 == SYSTEM_HP_SHARE_ACT_BOSS or var2_39 == SYSTEM_BOSS_EXPERIMENT or var2_39 == SYSTEM_ACT_BOSS or var2_39 == SYSTEM_ACT_BOSS_SP or var2_39 == SYSTEM_BOSS_RUSH or var2_39 == SYSTEM_BOSS_RUSH_EX or var2_39 == SYSTEM_BOSS_RUSH_COLLABRATE or var2_39 == SYSTEM_LIMIT_CHALLENGE or var2_39 == SYSTEM_BOSS_SINGLE or var2_39 == SYSTEM_BOSS_SINGLE_VARIABLE then
		setText(var5_39, "SP")

		local var8_39 = var1_39:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().StageTmpId
		local var9_39 = pg.expedition_data_template[var8_39]

		setText(var6_39, var9_39.name)
	elseif var2_39 == SYSTEM_DEBUG then
		setText(var5_39, "??")
		setText(var6_39, "碧蓝梦境")
	elseif var2_39 == SYSTEM_CHALLENGE then
		local var10_39 = arg0_39._chapter:getNextExpedition()

		setText(var5_39, "SP")
		setText(var6_39, var10_39.chapter_name[2])
		setActive(arg0_39.LeftTimeContainer, true)
	elseif var2_39 == SYSTEM_WORLD_BOSS or var2_39 == SYSTEM_WORLD then
		setText(var5_39, i18n("world_battle_pause"))
		setText(var6_39, i18n("world_battle_pause2"))

		if var2_39 == SYSTEM_WORLD_BOSS then
			setActive(arg0_39.leaveBtn, false)
		end
	elseif var2_39 == SYSTEM_GUILD then
		local var11_39 = var1_39:GetProxyByName(ys.Battle.BattleDataProxy.__name):GetInitData().ActID
		local var12_39 = pg.guild_boss_event[var11_39]

		setText(var5_39, "BOSS")
		setText(var6_39, var12_39 and var12_39.name or "")
	elseif var2_39 == SYSTEM_TEST or var2_39 == SYSTEM_SUB_ROUTINE or var2_39 == SYSTEM_SCENARIO_SUB_STRIKE or var2_39 == SYSTEM_PERFORM or var2_39 == SYSTEM_PROLOGUE or var2_39 == SYSTEM_DODGEM or var2_39 == SYSTEM_SIMULATION or var2_39 == SYSTEM_SUBMARINE_RUN or var2_39 == SYSTEM_BOSS_EXPERIMENT or var2_39 == SYSTEM_REWARD_PERFORM or var2_39 == SYSTEM_AIRFIGHT then
		-- block empty
	elseif var2_39 == SYSTEM_CARDPUZZLE then
		-- block empty
	else
		assert(false, "System not defined " .. (var2_39 or "NIL"))
	end

	onButton(arg0_39, arg0_39.leaveBtn, function()
		arg0_39:emit(BattleMediator.ON_LEAVE)

		local var0_41 = arg0_39.leaveBtn:GetComponent(typeof(Animation))

		if var0_41 and var0_41:GetClip("msgbox_btn_blink") then
			var0_41:Play("msgbox_btn_blink")
		end
	end)
	onButton(arg0_39, arg0_39.continueBtn, function()
		local var0_42 = arg0_39.continueBtn:GetComponent(typeof(Animation))

		if var0_42 and var0_42:GetClip("msgbox_btn_blink") then
			var0_42:Play("msgbox_btn_blink")
		end

		local var1_42 = arg0_39.pauseWindow:GetComponent(typeof(Animation))

		if var1_42 then
			if var1_42:IsPlaying("msgbox_out") then
				var1_42:Stop("msgbox_out")
				var1_42:Play("msgbox_in")
			else
				var1_42:Play("msgbox_out")
				arg0_39.pauseWindow:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_43)
					arg0_39:ClosePauseWindow()
					var1_39:Resume()
				end)
			end
		else
			arg0_39:ClosePauseWindow()
			var1_39:Resume()
		end
	end)
	onButton(arg0_39, arg0_39.pauseWindow:Find("help"), function()
		if BATTLE_DEBUG and PLATFORM == 7 then
			arg0_39:ClosePauseWindow()
			var1_39:Resume()
			var1_39:OpenConsole()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("help_battle_rule")
			})
		end
	end)
	onButton(arg0_39, arg0_39.pauseWindow:Find("window/top/btnBack"), function()
		triggerButton(arg0_39.continueBtn)
	end)
	onButton(arg0_39, arg0_39.pauseWindow, function()
		triggerButton(arg0_39.continueBtn)
	end)
	onButton(arg0_39, arg0_39.pauseWindow, function()
		local var0_47 = arg0_39.pauseWindow:GetComponent(typeof(Animation))

		if var0_47 and var0_47:IsPlaying("msgbox_out") then
			-- block empty
		else
			triggerButton(arg0_39.continueBtn)
		end
	end)
	setActive(arg0_39.pauseWindow, false)
end

function var0_0.updatePauseWindow(arg0_48)
	if not arg0_48.pauseWindow then
		return
	end

	setActive(arg0_48.pauseWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_48.pauseWindow)

	local var0_48 = ys.Battle.BattleState.GetInstance():GetProxyByName(ys.Battle.BattleDataProxy.__name)
	local var1_48 = var0_48:GetFleetByIFF(ys.Battle.BattleConfig.FRIENDLY_CODE)

	local function var2_48(arg0_49, arg1_49)
		if not arg0_49 then
			return
		end

		for iter0_49 = 1, #arg0_49 do
			local var0_49 = arg0_49[iter0_49].id

			if var1_48:GetFreezeShipByID(var0_49) then
				local var1_49 = var1_48:GetFreezeShipByID(var0_49)

				setSlider(arg1_49[iter0_49]:Find("blood"), 0, 1, var1_49:GetHPRate())
				SetActive(arg1_49[iter0_49]:Find("mask"), false)
			elseif var1_48:GetShipByID(var0_49) then
				local var2_49 = var1_48:GetShipByID(var0_49)

				setSlider(arg1_49[iter0_49]:Find("blood"), 0, 1, var2_49:GetHPRate())
				SetActive(arg1_49[iter0_49]:Find("mask"), false)
			else
				setSlider(arg1_49[iter0_49]:Find("blood"), 0, 1, 0)
				SetActive(arg1_49[iter0_49]:Find("mask"), true)
			end
		end
	end

	var2_48(arg0_48._mainShipVOs, arg0_48.mainTFs)
	var2_48(arg0_48._vanShipVOs, arg0_48.vanTFs)

	if arg0_48.subTFs then
		var2_48(arg0_48._subShipVOs, arg0_48.subTFs)
	end

	setText(arg0_48.LeftTime, ys.Battle.BattleTimerView.formatTime(math.floor(var0_48:GetCountDown())))
end

function var0_0.ClosePauseWindow(arg0_50)
	setActive(arg0_50.pauseWindow, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_50.pauseWindow, arg0_50._tf)
end

function var0_0.AddUIFX(arg0_51, arg1_51, arg2_51)
	arg2_51 = arg2_51 or 1

	local var0_51 = arg2_51 > 0

	arg1_51 = tf(arg1_51)

	local var1_51 = var0_51 and arg0_51._fxContainerUpper or arg0_51._fxContainerBottom

	arg1_51:SetParent(var1_51)
	pg.ViewUtils.SetSortingOrder(arg1_51, arg0_51._canvasOrder + arg2_51)
	pg.ViewUtils.SetLayer(arg1_51, Layer.UI)

	return var1_51.localScale
end

function var0_0.OnCloseChat(arg0_52)
	local var0_52 = ys.Battle.BattleState.GetInstance():IsBotActive()
	local var1_52 = arg0_52._chatBtn:GetComponent(typeof(Animation))

	if var0_52 then
		setActive(arg0_52._chatBtn, true)

		if var1_52 then
			var1_52:Play("chatbtn_in")
		end
	elseif var1_52 then
		var1_52:Play("chatbtn_out")
	else
		setActive(arg0_52._chatBtn, false)
	end
end

function var0_0.clear(arg0_53)
	arg0_53._preSkillTF = nil

	arg0_53._skillFloatPool:AllRecycle()
	arg0_53._skillFloatCMDPool:AllRecycle()

	arg0_53._preCommanderSkillTF = nil
	arg0_53._commanderSkillList = nil
	arg0_53._skillPaintings = nil
	arg0_53._currentPainting = nil

	Destroy(arg0_53._paintingUI)
end

function var0_0.willExit(arg0_54)
	arg0_54._skillFloatPool:Dispose()
	arg0_54._skillFloatCMDPool:Dispose()
	ys.Battle.BattleState.GetInstance():ExitBattle()
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_54.pauseWindow, arg0_54._tf)
	ys.Battle.BattleCameraUtil.GetInstance().ActiveMainCamera(false)
	pg.CameraFixMgr.GetInstance():disconnect(arg0_54.camEventId)
end

return var0_0
