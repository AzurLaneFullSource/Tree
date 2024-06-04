local var0 = class("ChallengePreCombatLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "ChapterPreCombatUI"
end

function var0.ResUISettings(arg0)
	return true
end

function var0.init(arg0)
	arg0._startBtn = arg0:findTF("right/start")
	arg0._popup = arg0:findTF("right/popup")

	setActive(arg0._popup, false)

	arg0._backBtn = arg0:findTF("top/back_btn")

	local var0 = arg0:findTF("middle")

	arg0._mainGS = var0:Find("gear_score/main/Text")
	arg0._vanguardGS = var0:Find("gear_score/vanguard/Text")

	setText(arg0._mainGS, 0)
	setText(arg0._vanguardGS, 0)

	arg0._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {}
	}
	arg0._gridFrame = var0:Find("mask/GridFrame")

	for iter0 = 1, 3 do
		arg0._gridTFs[TeamType.Vanguard][iter0] = arg0._gridFrame:Find("vanguard_" .. iter0)
		arg0._gridTFs[TeamType.Main][iter0] = arg0._gridFrame:Find("main_" .. iter0)
	end

	arg0._heroContainer = var0:Find("HeroContainer")
	arg0._strategy = var0:Find("strategy")

	setActive(arg0._strategy, false)

	arg0._formationList = var0:Find("formation_list")

	setActive(arg0._formationList, false)

	arg0._goals = arg0:findTF("right/infomation/goal")
	arg0._heroInfo = arg0:getTpl("heroInfo")
	arg0._starTpl = arg0:getTpl("star_tpl")
	arg0._formationLogic = BaseFormation.New(arg0._tf, arg0._heroContainer, arg0._heroInfo, arg0._gridTFs)
	arg0._middle = arg0:findTF("middle")
	arg0._right = arg0:findTF("right")
	arg0._fleet = arg0:findTF("middle/fleet")

	setText(findTF(arg0._tf, "middle/gear_score/vanguard/line/Image/Text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0._tf, "middle/gear_score/main/line/Image/Text1"), i18n("pre_combat_main"))
	setText(findTF(arg0._fleet, "title_bg/Text"), i18n("pre_combat_team"))

	arg0._ship_tpl = findTF(arg0._fleet, "shiptpl")
	arg0._empty_tpl = findTF(arg0._fleet, "emptytpl")

	setActive(arg0._ship_tpl, false)
	setActive(arg0._empty_tpl, false)

	arg0._autoToggle = arg0:findTF("middle/auto_toggle")
	arg0._autoSubToggle = arg0:findTF("middle/sub_toggle_container/sub_toggle")
	arg0.topPanel = arg0:findTF("top")
	arg0.strategyInfo = arg0:findTF("strategy_info")

	setActive(arg0.strategyInfo, false)
	setAnchoredPosition(arg0._middle, {
		x = -840
	})
	setAnchoredPosition(arg0._right, {
		x = 470
	})
	arg0:Register()
end

function var0.uiStartAnimating(arg0)
	setAnchoredPosition(arg0.topPanel, {
		y = 100
	})

	local var0 = 0
	local var1 = 0.3

	shiftPanel(arg0._middle, 0, nil, var1, var0, true, true)
	shiftPanel(arg0._right, 0, nil, var1, var0, true, true, nil)
	shiftPanel(arg0.topPanel, nil, 0, var1, var0, true, true, nil, nil)
end

function var0.uiExitAnimating(arg0)
	local var0 = 0
	local var1 = 0.3

	shiftPanel(arg0._middle, -840, nil, var1, var0, true, true)
	shiftPanel(arg0._right, 470, nil, var1, var0, true, true)
	shiftPanel(arg0.topPanel, nil, arg0.topPanel.rect.height, var1, var0, true, true, nil, nil)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._backBtn, function()
		GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

		arg0:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0:emit(var0.ON_CLOSE)
		end))
	end, SFX_CANCEL)
	onButton(arg0, arg0._startBtn, function()
		local var0 = arg0.fleet.ships

		for iter0, iter1 in pairs(var0) do
			local var1, var2 = ShipStatus.ShipStatusConflict("inActivity", iter1, {
				inActivity = false
			})

			if var1 == ShipStatus.STATE_CHANGE_FAIL then
				pg.TipsMgr.GetInstance():ShowTips(i18n(var2))

				return
			end
		end

		arg0:emit(ChallengePreCombatMediator.ON_START)
	end, SFX_UI_WEIGHANCHOR)
	onToggle(arg0, arg0._autoToggle, function(arg0)
		arg0:emit(ChallengePreCombatMediator.ON_AUTO, {
			isOn = not arg0,
			toggle = arg0._autoToggle
		})

		if arg0 and arg0.subUseable == true then
			setActive(arg0._autoSubToggle, true)
			onToggle(arg0, arg0._autoSubToggle, function(arg0)
				arg0:emit(ChallengePreCombatMediator.ON_SUB_AUTO, {
					isOn = not arg0,
					toggle = arg0._autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
		else
			setActive(arg0._autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setParent(arg0.strategyInfo, arg0._tf.parent)
	triggerToggle(arg0._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	setAnchoredPosition(arg0.topPanel, {
		y = arg0.topPanel.rect.height
	})
	onNextTick(function()
		arg0:uiStartAnimating()
	end)
end

function var0.Register(arg0)
	arg0._formationLogic:AddHeroInfoModify(function(arg0, arg1)
		setAnchoredPosition(arg0, {
			x = 0,
			y = 0
		})
		SetActive(arg0, true)

		arg0.name = "info"

		local var0 = findTF(arg0, "info")
		local var1 = findTF(var0, "stars")
		local var2 = arg1:getEnergy() <= Ship.ENERGY_MID
		local var3 = findTF(var0, "energy")

		if var2 then
			local var4, var5 = arg1:getEnergyPrint()
			local var6 = GetSpriteFromAtlas("energy", var4)

			if not var6 then
				warning("找不到疲劳")
			end

			setImageSprite(var3, var6)
		end

		setActive(var3, var2)

		local var7 = arg1:getStar()

		for iter0 = 1, var7 do
			cloneTplTo(arg0._starTpl, var1)
		end

		local var8 = GetSpriteFromAtlas("shiptype", shipType2print(arg1:getShipType()))

		if not var8 then
			warning("找不到船形, shipConfigId: " .. arg1.configId)
		end

		setImageSprite(findTF(var0, "type"), var8, true)
		setText(findTF(var0, "frame/lv_contain/lv"), arg1.level)

		local var9 = findTF(var0, "blood")
		local var10 = findTF(var9, "fillarea/green")
		local var11 = findTF(var9, "fillarea/red")

		setActive(var10, arg1.hpRant >= ChapterConst.HpGreen)
		setActive(var11, arg1.hpRant < ChapterConst.HpGreen)

		;(arg1.hpRant >= ChapterConst.HpGreen and var10 or var11):GetComponent("Image").fillAmount = arg1.hpRant * 0.0001

		local var12 = var0:Find("expbuff")

		setActive(var12, false)
	end)
	arg0._formationLogic:AddShiftOnly(function(arg0)
		arg0:updateView(false)
	end)
	arg0._formationLogic:AddCheckRemove(function(arg0, arg1)
		arg0()
	end)
end

function var0.onBackPressed(arg0)
	if arg0.strategyPanel and arg0.strategyPanel._go and isActive(arg0.strategyPanel._go) then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		triggerButton(arg0._backBtn)
	end
end

function var0.setPlayerInfo(arg0, arg1)
	return
end

function var0.updateChallenge(arg0, arg1)
	arg0.challenge = arg1
	arg0.fleet = arg1:getRegularFleet()

	local var0 = arg0.fleet.ships

	arg0._formationLogic:SetFleetVO(arg0.fleet)
	arg0._formationLogic:SetShipVOs(var0)
	arg0:updateView(true)
end

function var0.setSubFlag(arg0, arg1)
	arg0.subUseable = arg1 or false
end

function var0.updateView(arg0, arg1)
	arg0._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0._formationLogic:ResetGrid(TeamType.Main)
	SetActive(arg0._gridTFs[TeamType.Main][1]:Find("flag"), true)

	if arg1 then
		arg0:updateStageView()
		arg0._formationLogic:LoadAllCharacter()
	else
		arg0._formationLogic:SetAllCharacterPos()
	end

	arg0:updateBattleFleetView()
	arg0:displayFleetInfo()
end

function var0.updateStageView(arg0)
	local function var0(arg0, arg1)
		if type(arg0) == "table" then
			setActive(arg1, true)

			local var0 = i18n(PreCombatLayer.ObjectiveList[arg0[1]], arg0[2])

			setWidgetText(arg1, var0)
		else
			setActive(arg1, false)
		end
	end

	local var1 = {
		findTF(arg0._goals, "goal_tpl"),
		findTF(arg0._goals, "goal_sink"),
		findTF(arg0._goals, "goal_time")
	}
	local var2 = {
		{
			1
		},
		false,
		false
	}
	local var3 = 1

	for iter0, iter1 in ipairs(var2) do
		if type(iter1) ~= "string" then
			var0(iter1, var1[var3])

			var3 = var3 + 1
		end
	end
end

function var0.updateBattleFleetView(arg0)
	local function var0(arg0, arg1)
		removeAllChildren(arg0)

		for iter0 = 1, 3 do
			if arg1[iter0] then
				local var0 = cloneTplTo(arg0._ship_tpl, arg0)

				updateShip(var0, arg1[iter0])

				local var1 = arg1[iter0].hpRant
				local var2 = findTF(var0, "blood")
				local var3 = findTF(var0, "blood/fillarea/green")
				local var4 = findTF(var0, "blood/fillarea/red")

				setActive(var3, var1 >= ChapterConst.HpGreen)
				setActive(var4, var1 < ChapterConst.HpGreen)

				;(var1 >= ChapterConst.HpGreen and var3 or var4):GetComponent("Image").fillAmount = var1 * 0.0001
			end
		end
	end

	local var1 = arg0.challenge:getRegularFleet()

	var0(arg0._fleet:Find("main"), var1:getShipsByTeam(TeamType.Main, true))
	var0(arg0._fleet:Find("vanguard"), var1:getShipsByTeam(TeamType.Vanguard, true))
end

function var0.displayFleetInfo(arg0)
	local var0 = arg0.challenge:getRegularFleet()
	local var1 = var0:getCommanders()
	local var2 = _.reduce(var0:getShipsByTeam(TeamType.Vanguard, false), 0, function(arg0, arg1)
		return arg0 + arg1:getShipCombatPower(var1)
	end)
	local var3 = _.reduce(var0:getShipsByTeam(TeamType.Main, false), 0, function(arg0, arg1)
		return arg0 + arg1:getShipCombatPower(var1)
	end)

	FormationUI.tweenNumText(arg0._vanguardGS, var2)
	FormationUI.tweenNumText(arg0._mainGS, var3)
end

function var0.willExit(arg0)
	setParent(arg0.strategyInfo, arg0._tf)
	arg0._formationLogic:Destroy()

	arg0._formationLogic = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
