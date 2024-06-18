local var0_0 = class("ChallengePreCombatLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChapterPreCombatUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.init(arg0_3)
	arg0_3._startBtn = arg0_3:findTF("right/start")
	arg0_3._popup = arg0_3:findTF("right/popup")

	setActive(arg0_3._popup, false)

	arg0_3._backBtn = arg0_3:findTF("top/back_btn")

	local var0_3 = arg0_3:findTF("middle")

	arg0_3._mainGS = var0_3:Find("gear_score/main/Text")
	arg0_3._vanguardGS = var0_3:Find("gear_score/vanguard/Text")

	setText(arg0_3._mainGS, 0)
	setText(arg0_3._vanguardGS, 0)

	arg0_3._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {}
	}
	arg0_3._gridFrame = var0_3:Find("mask/GridFrame")

	for iter0_3 = 1, 3 do
		arg0_3._gridTFs[TeamType.Vanguard][iter0_3] = arg0_3._gridFrame:Find("vanguard_" .. iter0_3)
		arg0_3._gridTFs[TeamType.Main][iter0_3] = arg0_3._gridFrame:Find("main_" .. iter0_3)
	end

	arg0_3._heroContainer = var0_3:Find("HeroContainer")
	arg0_3._strategy = var0_3:Find("strategy")

	setActive(arg0_3._strategy, false)

	arg0_3._formationList = var0_3:Find("formation_list")

	setActive(arg0_3._formationList, false)

	arg0_3._goals = arg0_3:findTF("right/infomation/goal")
	arg0_3._heroInfo = arg0_3:getTpl("heroInfo")
	arg0_3._starTpl = arg0_3:getTpl("star_tpl")
	arg0_3._formationLogic = BaseFormation.New(arg0_3._tf, arg0_3._heroContainer, arg0_3._heroInfo, arg0_3._gridTFs)
	arg0_3._middle = arg0_3:findTF("middle")
	arg0_3._right = arg0_3:findTF("right")
	arg0_3._fleet = arg0_3:findTF("middle/fleet")

	setText(findTF(arg0_3._tf, "middle/gear_score/vanguard/line/Image/Text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0_3._tf, "middle/gear_score/main/line/Image/Text1"), i18n("pre_combat_main"))
	setText(findTF(arg0_3._fleet, "title_bg/Text"), i18n("pre_combat_team"))

	arg0_3._ship_tpl = findTF(arg0_3._fleet, "shiptpl")
	arg0_3._empty_tpl = findTF(arg0_3._fleet, "emptytpl")

	setActive(arg0_3._ship_tpl, false)
	setActive(arg0_3._empty_tpl, false)

	arg0_3._autoToggle = arg0_3:findTF("middle/auto_toggle")
	arg0_3._autoSubToggle = arg0_3:findTF("middle/sub_toggle_container/sub_toggle")
	arg0_3.topPanel = arg0_3:findTF("top")
	arg0_3.strategyInfo = arg0_3:findTF("strategy_info")

	setActive(arg0_3.strategyInfo, false)
	setAnchoredPosition(arg0_3._middle, {
		x = -840
	})
	setAnchoredPosition(arg0_3._right, {
		x = 470
	})
	arg0_3:Register()
end

function var0_0.uiStartAnimating(arg0_4)
	setAnchoredPosition(arg0_4.topPanel, {
		y = 100
	})

	local var0_4 = 0
	local var1_4 = 0.3

	shiftPanel(arg0_4._middle, 0, nil, var1_4, var0_4, true, true)
	shiftPanel(arg0_4._right, 0, nil, var1_4, var0_4, true, true, nil)
	shiftPanel(arg0_4.topPanel, nil, 0, var1_4, var0_4, true, true, nil, nil)
end

function var0_0.uiExitAnimating(arg0_5)
	local var0_5 = 0
	local var1_5 = 0.3

	shiftPanel(arg0_5._middle, -840, nil, var1_5, var0_5, true, true)
	shiftPanel(arg0_5._right, 470, nil, var1_5, var0_5, true, true)
	shiftPanel(arg0_5.topPanel, nil, arg0_5.topPanel.rect.height, var1_5, var0_5, true, true, nil, nil)
end

function var0_0.didEnter(arg0_6)
	onButton(arg0_6, arg0_6._backBtn, function()
		GetOrAddComponent(arg0_6._tf, typeof(CanvasGroup)).interactable = false

		arg0_6:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0_6:emit(var0_0.ON_CLOSE)
		end))
	end, SFX_CANCEL)
	onButton(arg0_6, arg0_6._startBtn, function()
		local var0_9 = arg0_6.fleet.ships

		for iter0_9, iter1_9 in pairs(var0_9) do
			local var1_9, var2_9 = ShipStatus.ShipStatusConflict("inActivity", iter1_9, {
				inActivity = false
			})

			if var1_9 == ShipStatus.STATE_CHANGE_FAIL then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2_9))

				return
			end
		end

		arg0_6:emit(ChallengePreCombatMediator.ON_START)
	end, SFX_UI_WEIGHANCHOR)
	onToggle(arg0_6, arg0_6._autoToggle, function(arg0_10)
		arg0_6:emit(ChallengePreCombatMediator.ON_AUTO, {
			isOn = not arg0_10,
			toggle = arg0_6._autoToggle
		})

		if arg0_10 and arg0_6.subUseable == true then
			setActive(arg0_6._autoSubToggle, true)
			onToggle(arg0_6, arg0_6._autoSubToggle, function(arg0_11)
				arg0_6:emit(ChallengePreCombatMediator.ON_SUB_AUTO, {
					isOn = not arg0_11,
					toggle = arg0_6._autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0_6._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
		else
			setActive(arg0_6._autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf)
	setParent(arg0_6.strategyInfo, arg0_6._tf.parent)
	triggerToggle(arg0_6._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	setAnchoredPosition(arg0_6.topPanel, {
		y = arg0_6.topPanel.rect.height
	})
	onNextTick(function()
		arg0_6:uiStartAnimating()
	end)
end

function var0_0.Register(arg0_13)
	arg0_13._formationLogic:AddHeroInfoModify(function(arg0_14, arg1_14)
		setAnchoredPosition(arg0_14, {
			x = 0,
			y = 0
		})
		SetActive(arg0_14, true)

		arg0_14.name = "info"

		local var0_14 = findTF(arg0_14, "info")
		local var1_14 = findTF(var0_14, "stars")
		local var2_14 = arg1_14:getEnergy() <= Ship.ENERGY_MID
		local var3_14 = findTF(var0_14, "energy")

		if var2_14 then
			local var4_14, var5_14 = arg1_14:getEnergyPrint()
			local var6_14 = GetSpriteFromAtlas("energy", var4_14)

			if not var6_14 then
				warning("找不到疲劳")
			end

			setImageSprite(var3_14, var6_14)
		end

		setActive(var3_14, var2_14)

		local var7_14 = arg1_14:getStar()

		for iter0_14 = 1, var7_14 do
			cloneTplTo(arg0_13._starTpl, var1_14)
		end

		local var8_14 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_14:getShipType()))

		if not var8_14 then
			warning("找不到船形, shipConfigId: " .. arg1_14.configId)
		end

		setImageSprite(findTF(var0_14, "type"), var8_14, true)
		setText(findTF(var0_14, "frame/lv_contain/lv"), arg1_14.level)

		local var9_14 = findTF(var0_14, "blood")
		local var10_14 = findTF(var9_14, "fillarea/green")
		local var11_14 = findTF(var9_14, "fillarea/red")

		setActive(var10_14, arg1_14.hpRant >= ChapterConst.HpGreen)
		setActive(var11_14, arg1_14.hpRant < ChapterConst.HpGreen)

		;(arg1_14.hpRant >= ChapterConst.HpGreen and var10_14 or var11_14):GetComponent("Image").fillAmount = arg1_14.hpRant * 0.0001

		local var12_14 = var0_14:Find("expbuff")

		setActive(var12_14, false)
	end)
	arg0_13._formationLogic:AddShiftOnly(function(arg0_15)
		arg0_13:updateView(false)
	end)
	arg0_13._formationLogic:AddCheckRemove(function(arg0_16, arg1_16)
		arg0_16()
	end)
end

function var0_0.onBackPressed(arg0_17)
	if arg0_17.strategyPanel and arg0_17.strategyPanel._go and isActive(arg0_17.strategyPanel._go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0_17._backBtn)
	end
end

function var0_0.setPlayerInfo(arg0_18, arg1_18)
	return
end

function var0_0.updateChallenge(arg0_19, arg1_19)
	arg0_19.challenge = arg1_19
	arg0_19.fleet = arg1_19:getRegularFleet()

	local var0_19 = arg0_19.fleet.ships

	arg0_19._formationLogic:SetFleetVO(arg0_19.fleet)
	arg0_19._formationLogic:SetShipVOs(var0_19)
	arg0_19:updateView(true)
end

function var0_0.setSubFlag(arg0_20, arg1_20)
	arg0_20.subUseable = arg1_20 or false
end

function var0_0.updateView(arg0_21, arg1_21)
	arg0_21._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0_21._formationLogic:ResetGrid(TeamType.Main)
	SetActive(arg0_21._gridTFs[TeamType.Main][1]:Find("flag"), true)

	if arg1_21 then
		arg0_21:updateStageView()
		arg0_21._formationLogic:LoadAllCharacter()
	else
		arg0_21._formationLogic:SetAllCharacterPos()
	end

	arg0_21:updateBattleFleetView()
	arg0_21:displayFleetInfo()
end

function var0_0.updateStageView(arg0_22)
	local function var0_22(arg0_23, arg1_23)
		if type(arg0_23) == "table" then
			setActive(arg1_23, true)

			local var0_23 = i18n(PreCombatLayer.ObjectiveList[arg0_23[1]], arg0_23[2])

			setWidgetText(arg1_23, var0_23)
		else
			setActive(arg1_23, false)
		end
	end

	local var1_22 = {
		findTF(arg0_22._goals, "goal_tpl"),
		findTF(arg0_22._goals, "goal_sink"),
		findTF(arg0_22._goals, "goal_time")
	}
	local var2_22 = {
		{
			1
		},
		false,
		false
	}
	local var3_22 = 1

	for iter0_22, iter1_22 in ipairs(var2_22) do
		if type(iter1_22) ~= "string" then
			var0_22(iter1_22, var1_22[var3_22])

			var3_22 = var3_22 + 1
		end
	end
end

function var0_0.updateBattleFleetView(arg0_24)
	local function var0_24(arg0_25, arg1_25)
		removeAllChildren(arg0_25)

		for iter0_25 = 1, 3 do
			if arg1_25[iter0_25] then
				local var0_25 = cloneTplTo(arg0_24._ship_tpl, arg0_25)

				updateShip(var0_25, arg1_25[iter0_25])

				local var1_25 = arg1_25[iter0_25].hpRant
				local var2_25 = findTF(var0_25, "blood")
				local var3_25 = findTF(var0_25, "blood/fillarea/green")
				local var4_25 = findTF(var0_25, "blood/fillarea/red")

				setActive(var3_25, var1_25 >= ChapterConst.HpGreen)
				setActive(var4_25, var1_25 < ChapterConst.HpGreen)

				;(var1_25 >= ChapterConst.HpGreen and var3_25 or var4_25):GetComponent("Image").fillAmount = var1_25 * 0.0001
			end
		end
	end

	local var1_24 = arg0_24.challenge:getRegularFleet()

	var0_24(arg0_24._fleet:Find("main"), var1_24:getShipsByTeam(TeamType.Main, true))
	var0_24(arg0_24._fleet:Find("vanguard"), var1_24:getShipsByTeam(TeamType.Vanguard, true))
end

function var0_0.displayFleetInfo(arg0_26)
	local var0_26 = arg0_26.challenge:getRegularFleet()
	local var1_26 = var0_26:getCommanders()
	local var2_26 = _.reduce(var0_26:getShipsByTeam(TeamType.Vanguard, false), 0, function(arg0_27, arg1_27)
		return arg0_27 + arg1_27:getShipCombatPower(var1_26)
	end)
	local var3_26 = _.reduce(var0_26:getShipsByTeam(TeamType.Main, false), 0, function(arg0_28, arg1_28)
		return arg0_28 + arg1_28:getShipCombatPower(var1_26)
	end)

	FormationUI.tweenNumText(arg0_26._vanguardGS, var2_26)
	FormationUI.tweenNumText(arg0_26._mainGS, var3_26)
end

function var0_0.willExit(arg0_29)
	setParent(arg0_29.strategyInfo, arg0_29._tf)
	arg0_29._formationLogic:Destroy()

	arg0_29._formationLogic = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_29._tf)
end

return var0_0
