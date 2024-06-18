local var0_0 = class("WorldBossFormationLayer", import("..base.BaseUI"))
local var1_0 = import("..ship.FormationUI")

var0_0.FORM_EDIT = "EDIT"
var0_0.FORM_PREVIEW = "PREVIEW"

function var0_0.getUIName(arg0_1)
	return "PreCombatUI"
end

function var0_0.ResUISettings(arg0_2)
	return {
		order = 5,
		anim = true,
		showType = PlayerResUI.TYPE_ALL
	}
end

function var0_0.SetBossProxy(arg0_3, arg1_3, arg2_3)
	arg0_3.boss = arg1_3:GetBossById(arg2_3)
end

function var0_0.init(arg0_4)
	arg0_4._startBtn = arg0_4:findTF("right/start")
	arg0_4._popup = arg0_4:findTF("right/start/cost_container/popup")
	arg0_4._costText = arg0_4:findTF("right/start/cost_container/popup/Text")
	arg0_4._backBtn = arg0_4:findTF("blur_panel/top/back_btn")
	arg0_4._moveLayer = arg0_4:findTF("moveLayer")

	local var0_4 = arg0_4:findTF("middle")

	arg0_4._autoToggle = arg0_4:findTF("auto_toggle")
	arg0_4.subToggle = arg0_4:findTF("sub_toggle_container")

	setActive(arg0_4.subToggle, false)

	arg0_4._buffContainer = arg0_4._tf:Find("BuffContainer")

	setActive(arg0_4._buffContainer, false)

	arg0_4._fleetInfo = var0_4:Find("fleet_info")
	arg0_4._fleetNameText = var0_4:Find("fleet_info/fleet_name/Text")
	arg0_4._fleetNumText = var0_4:Find("fleet_info/fleet_number")

	setActive(arg0_4._fleetInfo, arg0_4.contextData.system ~= SYSTEM_DUEL)

	arg0_4._mainGS = var0_4:Find("gear_score/main/Text")
	arg0_4._vanguardGS = var0_4:Find("gear_score/vanguard/Text")
	arg0_4._gridTFs = {
		vanguard = {},
		main = {}
	}
	arg0_4._gridFrame = var0_4:Find("mask/GridFrame")

	for iter0_4 = 1, 3 do
		arg0_4._gridTFs[TeamType.Vanguard][iter0_4] = arg0_4._gridFrame:Find("vanguard_" .. iter0_4)
		arg0_4._gridTFs[TeamType.Main][iter0_4] = arg0_4._gridFrame:Find("main_" .. iter0_4)
	end

	arg0_4._nextPage = arg0_4:findTF("middle/nextPage")
	arg0_4._prevPage = arg0_4:findTF("middle/prevPage")

	arg0_4:disableAllStepper()

	arg0_4._heroContainer = var0_4:Find("HeroContainer")
	arg0_4._checkBtn = var0_4:Find("checkBtn")
	arg0_4._spoilsContainer = arg0_4:findTF("right/infomation/atlasloot/spoils/items/items_container")
	arg0_4._item = arg0_4:getTpl("right/infomation/atlasloot/spoils/items/item_tpl")
	arg0_4._goals = arg0_4:findTF("right/infomation/target/goal")
	arg0_4._heroInfo = arg0_4:getTpl("heroInfo")
	arg0_4._starTpl = arg0_4:getTpl("star_tpl")
	arg0_4._middle = arg0_4:findTF("middle")
	arg0_4._right = arg0_4:findTF("right")
	arg0_4.topPanel = arg0_4:findTF("blur_panel/top")

	setAnchoredPosition(arg0_4._middle, {
		x = -840
	})
	setAnchoredPosition(arg0_4._right, {
		x = 470
	})

	arg0_4.guideDesc = arg0_4:findTF("guideDesc", arg0_4._middle)

	if arg0_4.contextData.stageId then
		arg0_4:SetStageID(arg0_4.contextData.stageId)
	end

	arg0_4._formationLogic = BaseFormation.New(arg0_4._tf, arg0_4._heroContainer, arg0_4._heroInfo, arg0_4._gridTFs)

	arg0_4:Register()
end

function var0_0.Register(arg0_5)
	arg0_5._formationLogic:AddLoadComplete(function()
		if arg0_5._currentForm ~= var0_0.FORM_EDIT then
			arg0_5._formationLogic:SwitchToPreviewMode()
		end
	end)
	arg0_5._formationLogic:AddHeroInfoModify(function(arg0_7, arg1_7, arg2_7)
		arg2_7:SetLocalScale(Vector3(0.65, 0.65, 1))
		SetActive(arg0_7, true)

		local var0_7 = findTF(arg0_7, "info")
		local var1_7 = findTF(var0_7, "stars")
		local var2_7 = arg1_7.energy <= Ship.ENERGY_MID
		local var3_7 = findTF(var0_7, "energy")

		if var2_7 then
			local var4_7, var5_7 = arg1_7:getEnergyPrint()
			local var6_7 = GetSpriteFromAtlas("energy", var4_7)

			if not var6_7 then
				warning("找不到疲劳")
			end

			setImageSprite(var3_7, var6_7)
		end

		setActive(var3_7, false)
		setActive(findTF(var0_7, "expbuff"), false)

		local var7_7 = arg1_7:getStar()

		for iter0_7 = 1, var7_7 do
			cloneTplTo(arg0_5._starTpl, var1_7)
		end

		local var8_7 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_7:getShipType()))

		if not var8_7 then
			warning("找不到船形, shipConfigId: " .. arg1_7.configId)
		end

		setImageSprite(findTF(var0_7, "type"), var8_7, true)
		setText(findTF(var0_7, "frame/lv_contain/lv"), arg1_7.level)
	end)
	arg0_5._formationLogic:AddLongPress(function(arg0_8, arg1_8, arg2_8)
		arg0_5:emit(WorldBossFormationMediator.OPEN_SHIP_INFO, arg1_8.id, arg2_8)
	end)
	arg0_5._formationLogic:AddClick(function(arg0_9, arg1_9, arg2_9)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)
		arg0_5:emit(WorldBossFormationMediator.CHANGE_FLEET_SHIP, arg0_9, arg2_9, arg1_9)
	end)
	arg0_5._formationLogic:AddBeginDrag(function(arg0_10)
		local var0_10 = findTF(arg0_10, "info")

		SetActive(var0_10, false)
	end)
	arg0_5._formationLogic:AddEndDrag(function(arg0_11)
		local var0_11 = findTF(arg0_11, "info")

		SetActive(var0_11, true)
	end)
	arg0_5._formationLogic:AddShiftOnly(function(arg0_12)
		arg0_5:emit(WorldBossFormationMediator.CHANGE_FLEET_SHIPS_ORDER)
	end)
	arg0_5._formationLogic:AddRemoveShip(function(arg0_13, arg1_13)
		arg0_5:emit(WorldBossFormationMediator.REMOVE_SHIP, arg0_13, arg1_13)
	end)
	arg0_5._formationLogic:AddCheckRemove(function(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
		if not arg3_14:canRemove(arg2_14) then
			local var0_14, var1_14 = arg3_14:getShipPos(arg2_14)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2_14:getConfigTable().name, arg3_14.name, Fleet.C_TEAM_NAME[var1_14]))
			arg0_14()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				zIndex = -100,
				hideNo = false,
				content = i18n("battle_preCombatLayer_quest_leaveFleet", arg2_14:getConfigTable().name),
				onYes = arg1_14,
				onNo = arg0_14
			})
		end
	end)
	arg0_5._formationLogic:AddSwitchToDisplayMode(function()
		arg0_5._currentForm = var0_0.FORM_EDIT
		arg0_5._checkBtn:GetComponent("Button").interactable = true

		setActive(arg0_5._checkBtn:Find("save"), true)
		setActive(arg0_5._checkBtn:Find("edit"), false)
	end)
	arg0_5._formationLogic:AddSwitchToShiftMode(function()
		arg0_5:disableAllStepper()

		arg0_5._checkBtn:GetComponent("Button").interactable = false
	end)
	arg0_5._formationLogic:AddSwitchToPreviewMode(function()
		arg0_5._currentForm = var0_0.FORM_PREVIEW
		arg0_5._checkBtn:GetComponent("Button").interactable = true

		setActive(arg0_5._checkBtn:Find("save"), false)
		setActive(arg0_5._checkBtn:Find("edit"), true)
	end)
	arg0_5._formationLogic:AddGridTipClick(function(arg0_18, arg1_18)
		arg0_5:emit(WorldBossFormationMediator.CHANGE_FLEET_SHIP, nil, arg1_18, arg0_18)
	end)
end

function var0_0.SetPlayerInfo(arg0_19, arg1_19)
	return
end

function var0_0.SetShips(arg0_20, arg1_20)
	arg0_20._shipVOs = arg1_20

	arg0_20._formationLogic:SetShipVOs(arg0_20._shipVOs)
end

function var0_0.SetStageID(arg0_21, arg1_21)
	removeAllChildren(arg0_21._spoilsContainer)

	arg0_21._stageID = arg1_21

	local var0_21 = pg.expedition_data_template[arg1_21]
	local var1_21 = var0_21.limit_type
	local var2_21 = var0_21.time_limit
	local var3_21 = var0_21.sink_limit
	local var4_21 = var0_21.award_display

	for iter0_21, iter1_21 in ipairs(var4_21) do
		local var5_21 = cloneTplTo(arg0_21._item, arg0_21._spoilsContainer)
		local var6_21 = {
			id = iter1_21[2],
			type = iter1_21[1]
		}

		updateDrop(var5_21, var6_21)
	end

	local var7_21 = findTF(arg0_21._goals, "goal_tpl")
	local var8_21 = findTF(arg0_21._goals, "goal_sink")
	local var9_21 = findTF(arg0_21._goals, "goal_time")

	if var1_21 == 1 then
		local var10_21

		if var3_21 < 2 then
			var10_21 = i18n("battle_preCombatLayer_undefeated")
		else
			var10_21 = i18n("battle_preCombatLayer_sink_limit", var3_21)
		end

		setWidgetText(var7_21, i18n("battle_preCombatLayer_victory"))
		setWidgetText(var8_21, var10_21)
		setWidgetText(var9_21, i18n("battle_preCombatLayer_time_limit", var2_21))
	elseif var1_21 == 2 then
		setActive(var8_21, false)
		setActive(var9_21, false)
		setWidgetText(var7_21, i18n("battle_preCombatLayer_time_hold", var2_21))
	elseif var1_21 == 3 then
		setActive(var8_21, false)
		setActive(var9_21, false)
		setWidgetText(var7_21, i18n("battle_result_defeat_all_enemys", var2_21))
	end

	local var11_21 = var0_21.guide_desc and #var0_21.guide_desc > 0

	setActive(arg0_21.guideDesc, var11_21)

	if var11_21 then
		setText(arg0_21.guideDesc, var0_21.guide_desc)
	end
end

function var0_0.SetCurrentFleet(arg0_22, arg1_22)
	arg0_22._currentFleetVO = arg1_22

	arg0_22._formationLogic:SetFleetVO(arg0_22._currentFleetVO)

	arg0_22._legalFleetIdList = {
		arg1_22
	}
	arg0_22._curFleetIndex = 1
end

function var0_0.UpdateFleetView(arg0_23, arg1_23)
	arg0_23:displayFleetInfo()
	arg0_23._formationLogic:ResetGrid(TeamType.Vanguard, arg0_23._currentForm ~= var0_0.FORM_EDIT)
	arg0_23._formationLogic:ResetGrid(TeamType.Main, arg0_23._currentForm ~= var0_0.FORM_EDIT)

	if arg1_23 then
		arg0_23._formationLogic:LoadAllCharacter()
	else
		arg0_23._formationLogic:SetAllCharacterPos()
	end
end

function var0_0.uiStartAnimating(arg0_24)
	local var0_24 = 0
	local var1_24 = 0.3

	setAnchoredPosition(arg0_24.topPanel, {
		y = 100
	})
	shiftPanel(arg0_24._middle, 0, nil, var1_24, var0_24, true, true)
	shiftPanel(arg0_24._right, 0, nil, var1_24, var0_24, true, true)
	shiftPanel(arg0_24.topPanel, nil, 0, var1_24, var0_24, true, true, nil)
end

function var0_0.uiExitAnimating(arg0_25)
	shiftPanel(arg0_25._middle, -840, nil, nil, nil, true, true)
	shiftPanel(arg0_25._right, 470, nil, nil, nil, true, true)
	shiftPanel(arg0_25.topPanel, nil, arg0_25.topPanel.rect.height, nil, nil, true, true, nil)
end

function var0_0.didEnter(arg0_26)
	onButton(arg0_26, arg0_26._backBtn, function()
		local var0_27 = {}

		if arg0_26._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_27, function(arg0_28)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function()
						arg0_26:emit(WorldBossFormationMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_28()
						end)
					end,
					onNo = arg0_28
				})
			end)
		end

		seriesAsync(var0_27, function()
			GetOrAddComponent(arg0_26._tf, typeof(CanvasGroup)).interactable = false

			arg0_26:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function()
				nowWorld():GetBossProxy():UnlockCacheBoss()
				arg0_26:emit(var0_0.ON_CLOSE)
			end))
		end)
	end, SFX_CANCEL)
	onButton(arg0_26, arg0_26._startBtn, function()
		local var0_33 = {}

		if arg0_26._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_33, function(arg0_34)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function()
						arg0_26:emit(WorldBossFormationMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_34()
						end)
					end
				})
			end)
		end

		seriesAsync(var0_33, function()
			arg0_26:emit(WorldBossFormationMediator.ON_START, arg0_26._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_26, arg0_26._checkBtn, function()
		if arg0_26._currentForm == var0_0.FORM_EDIT then
			arg0_26:emit(WorldBossFormationMediator.ON_COMMIT_EDIT, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				arg0_26._formationLogic:SwitchToPreviewMode()
			end)
		elseif arg0_26._currentForm == var0_0.FORM_PREVIEW then
			arg0_26._formationLogic:SwitchToDisplayMode()
		else
			assert("currentForm error")
		end
	end, SFX_PANEL)

	arg0_26._currentForm = arg0_26.contextData.form
	arg0_26.contextData.form = nil

	arg0_26:UpdateFleetView(true)

	if arg0_26._currentForm == var0_0.FORM_EDIT then
		arg0_26._formationLogic:SwitchToDisplayMode()
	else
		arg0_26._formationLogic:SwitchToPreviewMode()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_26._tf)

	if arg0_26.contextData.system == SYSTEM_DUEL then
		setActive(arg0_26._autoToggle, false)
	else
		setActive(arg0_26._autoToggle, true)
		onToggle(arg0_26, arg0_26._autoToggle, function(arg0_40)
			arg0_26:emit(WorldBossFormationMediator.ON_AUTO, {
				isOn = not arg0_40,
				toggle = arg0_26._autoToggle
			})
		end, SFX_PANEL, SFX_PANEL)
		triggerToggle(arg0_26._autoToggle, ys.Battle.BattleState.IsAutoBotActive(SYSTEM_WORLD))
	end

	setAnchoredPosition(arg0_26.topPanel, {
		y = arg0_26.topPanel.rect.height
	})
	onNextTick(function()
		arg0_26:uiStartAnimating()
	end)

	if arg0_26._currentForm == var0_0.FORM_PREVIEW and arg0_26._currentFleetVO:isLegalToFight() ~= true then
		triggerButton(arg0_26._checkBtn)
	end

	arg0_26:UpdateBuffContainer()
	arg0_26:TryPlayGuide()
end

function var0_0.onBackPressed(arg0_42)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_42._backBtn)
end

function var0_0.displayFleetInfo(arg0_43)
	local var0_43 = arg0_43._currentFleetVO:GetPropertiesSum()
	local var1_43 = arg0_43._currentFleetVO:GetGearScoreSum(TeamType.Vanguard)
	local var2_43 = arg0_43._currentFleetVO:GetGearScoreSum(TeamType.Main)
	local var3_43 = 0

	if arg0_43.boss and arg0_43.boss:IsSelf() and arg0_43.boss:GetSelfFightCnt() > 0 then
		var3_43 = arg0_43.boss:GetOilConsume()
	end

	setActive(arg0_43._popup, arg0_43.contextData.system ~= SYSTEM_DUEL)
	var1_0.tweenNumText(arg0_43._costText, var3_43)
	var1_0.tweenNumText(arg0_43._vanguardGS, var1_43)
	var1_0.tweenNumText(arg0_43._mainGS, var2_43)
	setText(arg0_43._fleetNameText, var1_0.defaultFleetName(arg0_43._currentFleetVO))
	setText(arg0_43._fleetNumText, arg0_43._currentFleetVO.id)
end

function var0_0.disableAllStepper(arg0_44)
	SetActive(arg0_44._nextPage, false)
	SetActive(arg0_44._prevPage, false)
end

function var0_0.GetActiveStgs(arg0_45)
	local var0_45 = {}
	local var1_45, var2_45, var3_45 = WorldBossProxy.GetSupportValue()

	if var1_45 and arg0_45.boss and arg0_45.boss:IsSelf() then
		table.insert(var0_45, var3_45)
	end

	return var0_45
end

function var0_0.UpdateBuffContainer(arg0_46)
	local var0_46 = arg0_46:GetActiveStgs()
	local var1_46 = #var0_46 > 0

	setActive(arg0_46._buffContainer, var1_46)

	if not var1_46 then
		return
	end

	UIItemList.StaticAlign(arg0_46._buffContainer, arg0_46._buffContainer:GetChild(0), #var0_46, function(arg0_47, arg1_47, arg2_47)
		if arg0_47 ~= UIItemList.EventUpdate then
			return
		end

		local var0_47 = pg.strategy_data_template[var0_46[arg1_47 + 1]]

		GetImageSpriteFromAtlasAsync("strategyicon/" .. var0_47.icon, "", arg2_47)
		onButton(arg0_46, arg2_47, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = "",
				yesText = "text_confirm",
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = DROP_TYPE_STRATEGY,
					id = var0_47.id,
					cfg = var0_47
				}
			})
		end, SFX_PANEL)
	end)
end

function var0_0.TryPlayGuide(arg0_49)
	if #arg0_49:GetActiveStgs() > 0 then
		WorldGuider.GetInstance():PlayGuide("WorldG200")
	end
end

function var0_0.willExit(arg0_50)
	if arg0_50._currentForm == var0_0.FORM_EDIT then
		arg0_50.contextData.editingFleetVO = arg0_50._currentFleetVO
	end

	arg0_50._formationLogic:Destroy()

	if arg0_50.tweens then
		cancelTweens(arg0_50.tweens)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_50._tf)
end

return var0_0
