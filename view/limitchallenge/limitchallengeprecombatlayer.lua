local var0_0 = class("LimitChallengePreCombatLayer", import("view.base.BaseUI"))
local var1_0 = import("view.ship.FormationUI")
local var2_0 = {
	[99] = true
}

function var0_0.getUIName(arg0_1)
	return "LimitChallengePreCombatUI"
end

function var0_0.tempCache(arg0_2)
	return true
end

function var0_0.init(arg0_3)
	arg0_3:CommonInit()

	arg0_3._formationLogic = BaseFormation.New(arg0_3._tf, arg0_3._heroContainer, arg0_3._heroInfo, arg0_3._gridTFs)

	arg0_3:Register()
end

function var0_0.CommonInit(arg0_4)
	arg0_4.eventTriggers = {}
	arg0_4._startBtn = arg0_4:findTF("right/start")
	arg0_4._costContainer = arg0_4:findTF("right/start/cost_container")
	arg0_4._popup = arg0_4._costContainer:Find("popup")
	arg0_4._costText = arg0_4._popup:Find("Text")
	arg0_4._moveLayer = arg0_4:findTF("moveLayer")

	local var0_4 = arg0_4:findTF("middle")

	arg0_4._autoToggle = arg0_4:findTF("auto_toggle")
	arg0_4._autoSubToggle = arg0_4:findTF("sub_toggle_container/sub_toggle")
	arg0_4._fleetInfo = arg0_4._tf:Find("right/fleet_info")
	arg0_4._fleetNameText = arg0_4._fleetInfo:Find("fleet_name/Text")
	arg0_4._fleetNumText = arg0_4._fleetInfo:Find("fleet_number")

	setActive(arg0_4._fleetInfo, true)

	arg0_4._mainGS = var0_4:Find("gear_score/main/Text")
	arg0_4._vanguardGS = var0_4:Find("gear_score/vanguard/Text")
	arg0_4._subGS = var0_4:Find("gear_score/submarine/Text")
	arg0_4._bgFleet = var0_4:Find("mask/grid_bg")
	arg0_4._bgSub = var0_4:Find("mask/bg_sub")
	arg0_4._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0_4._gridFrame = var0_4:Find("mask/GridFrame")

	for iter0_4 = 1, 3 do
		arg0_4._gridTFs[TeamType.Main][iter0_4] = arg0_4._gridFrame:Find("main_" .. iter0_4)
		arg0_4._gridTFs[TeamType.Vanguard][iter0_4] = arg0_4._gridFrame:Find("vanguard_" .. iter0_4)
		arg0_4._gridTFs[TeamType.Submarine][iter0_4] = arg0_4._gridFrame:Find("submarine_" .. iter0_4)
	end

	arg0_4._nextPage = arg0_4:findTF("middle/nextPage")
	arg0_4._prevPage = arg0_4:findTF("middle/prevPage")
	arg0_4._heroContainer = var0_4:Find("HeroContainer")
	arg0_4._blurPanel = arg0_4:findTF("blur_panel")
	arg0_4.topPanel = arg0_4:findTF("top", arg0_4._blurPanel)
	arg0_4.topPanelBg = arg0_4:findTF("top_bg", arg0_4._blurPanel)
	arg0_4._backBtn = arg0_4:findTF("back_btn", arg0_4.topPanel)
	arg0_4._spoilsContainer = arg0_4:findTF("right/infomation/atlasloot/spoils/items/items_container")
	arg0_4._item = arg0_4:findTF("right/infomation/atlasloot/spoils/items/item_tpl")

	SetActive(arg0_4._item, false)

	arg0_4._goals = arg0_4:findTF("right/infomation/target/goal")
	arg0_4._heroInfo = arg0_4:getTpl("heroInfo")
	arg0_4._starTpl = arg0_4:getTpl("star_tpl")

	setText(findTF(arg0_4._tf, "middle/gear_score/vanguard/line/Image/Text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0_4._tf, "middle/gear_score/main/line/Image/Text1"), i18n("pre_combat_main"))
	setText(findTF(arg0_4._tf, "middle/gear_score/submarine/line/Image/text1"), i18n("pre_combat_submarine"))
	setText(arg0_4._costContainer:Find("title"), i18n("pre_combat_consume"))
	setText(findTF(arg0_4._tf, "right/infomation/target/title/GameObject"), i18n("pre_combat_targets"))
	setText(findTF(arg0_4._tf, "right/infomation/atlasloot/atlasloot/title/GameObject"), i18n("pre_combat_atlasloot"))
	setText(arg0_4._startBtn:Find("text"), i18n("pre_combat_start"))
	setText(arg0_4._startBtn:Find("text_en"), i18n("pre_combat_start_en"))

	arg0_4._middle = arg0_4:findTF("middle")
	arg0_4._right = arg0_4:findTF("right")
	arg0_4._bottom = arg0_4:findTF("bottom")
	arg0_4.btnRegular = arg0_4:findTF("fleet_select/regular", arg0_4._bottom)
	arg0_4.btnSub = arg0_4:findTF("fleet_select/sub", arg0_4._bottom)

	setText(arg0_4.btnRegular:Find("fleet/CnFleet"), Fleet.DEFAULT_NAME[1])
	setText(arg0_4.btnSub:Find("fleet/CnFleet"), Fleet.DEFAULT_NAME[1])
	setAnchoredPosition(arg0_4._middle, {
		x = -840
	})
	setAnchoredPosition(arg0_4._right, {
		x = 470
	})
	arg0_4:SetStageID(arg0_4.contextData.stageId)

	arg0_4.commanderFormationPanel = LimitChallengeCommanderFormationPage.New(arg0_4._tf, arg0_4.event, arg0_4.contextData)
end

function var0_0.Register(arg0_5)
	arg0_5._formationLogic:AddLoadComplete(function()
		return
	end)
	arg0_5._formationLogic:AddHeroInfoModify(function(arg0_7, arg1_7)
		setAnchoredPosition(arg0_7, {
			x = 0,
			y = 0
		})
		SetActive(arg0_7, true)

		arg0_7.name = "info"

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

		setActive(var3_7, var2_7 and arg0_5.contextData.system ~= SYSTEM_DUEL)

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

		local var9_7 = var0_7:Find("expbuff")

		setActive(var9_7, false)
	end)
	arg0_5._formationLogic:AddLongPress(function(arg0_8, arg1_8, arg2_8, arg3_8)
		arg0_5:emit(LimitChallengePreCombatMediator.OPEN_SHIP_INFO, arg1_8.id, arg2_8)
	end)
	arg0_5._formationLogic:AddBeginDrag(function(arg0_9)
		local var0_9 = findTF(arg0_9, "info")

		SetActive(var0_9, false)
	end)
	arg0_5._formationLogic:AddEndDrag(function(arg0_10)
		local var0_10 = findTF(arg0_10, "info")

		SetActive(var0_10, true)
	end)
	arg0_5._formationLogic:AddClick(function(arg0_11, arg1_11, arg2_11)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)
		arg0_5:emit(LimitChallengePreCombatMediator.CHANGE_FLEET_SHIP, arg0_11, arg2_11, arg1_11)
	end)
	arg0_5._formationLogic:AddShiftOnly(function(arg0_12)
		arg0_5:emit(LimitChallengePreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_12)
	end)
	arg0_5._formationLogic:AddRemoveShip(function(arg0_13, arg1_13)
		arg0_5:emit(LimitChallengePreCombatMediator.REMOVE_SHIP, arg0_13, arg1_13)
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
		return
	end)
	arg0_5._formationLogic:AddSwitchToShiftMode(function()
		arg0_5:SetFleetStepper()
	end)
	arg0_5._formationLogic:AddSwitchToPreviewMode(function()
		arg0_5:SetFleetStepper()
	end)
	arg0_5._formationLogic:AddGridTipClick(function(arg0_18, arg1_18)
		arg0_5:emit(LimitChallengePreCombatMediator.CHANGE_FLEET_SHIP, nil, arg0_5._currentFleetVO, arg0_18)
	end)
end

function var0_0.SetPlayerInfo(arg0_19, arg1_19)
	return
end

function var0_0.SetSubFlag(arg0_20, arg1_20)
	arg0_20._subUseable = arg1_20 or false

	arg0_20:UpdateSubToggle()
end

function var0_0.SetShips(arg0_21, arg1_21)
	arg0_21._shipVOs = arg1_21

	arg0_21._formationLogic:SetShipVOs(arg0_21._shipVOs)
end

function var0_0.SetStageID(arg0_22, arg1_22)
	removeAllChildren(arg0_22._spoilsContainer)

	arg0_22._stageID = arg1_22

	local var0_22 = pg.expedition_data_template[arg1_22]
	local var1_22 = Clone(var0_22.award_display)
	local var2_22 = checkExist(pg.expedition_activity_template[arg1_22], {
		"pt_drop_display"
	})

	if var2_22 and type(var2_22) == "table" then
		local var3_22 = getProxy(ActivityProxy)

		for iter0_22 = #var2_22, 1, -1 do
			local var4_22 = var3_22:getActivityById(var2_22[iter0_22][1])

			if var4_22 and not var4_22:isEnd() then
				table.insert(var1_22, 1, {
					2,
					id2ItemId(var2_22[iter0_22][2])
				})
			end
		end
	end

	for iter1_22, iter2_22 in ipairs(var1_22) do
		local var5_22 = cloneTplTo(arg0_22._item, arg0_22._spoilsContainer)
		local var6_22 = {
			id = iter2_22[2],
			type = iter2_22[1]
		}

		updateDrop(var5_22, var6_22)
		onButton(arg0_22, var5_22, function()
			local var0_23 = Item.getConfigData(iter2_22[2])

			if var0_23 and var2_0[var0_23.type] then
				local var1_23 = var0_23.display_icon
				local var2_23 = {}

				for iter0_23, iter1_23 in ipairs(var1_23) do
					local var3_23 = iter1_23[1]
					local var4_23 = iter1_23[2]

					var2_23[#var2_23 + 1] = {
						hideName = true,
						type = var3_23,
						id = var4_23
					}
				end

				arg0_22:emit(var0_0.ON_DROP_LIST, {
					item2Row = true,
					itemList = var2_23,
					content = var0_23.display
				})
			else
				arg0_22:emit(var0_0.ON_DROP, var6_22)
			end
		end, SFX_PANEL)
	end

	local function var7_22(arg0_24, arg1_24)
		if type(arg0_24) == "table" then
			setActive(arg1_24, true)

			local var0_24 = i18n(PreCombatLayer.ObjectiveList[arg0_24[1]], arg0_24[2])

			setWidgetText(arg1_24, var0_24)
		else
			setActive(arg1_24, false)
		end
	end

	local var8_22 = {
		findTF(arg0_22._goals, "goal_tpl"),
		findTF(arg0_22._goals, "goal_sink"),
		findTF(arg0_22._goals, "goal_time")
	}
	local var9_22 = {
		var0_22.objective_1,
		var0_22.objective_2,
		var0_22.objective_3
	}
	local var10_22 = 1

	for iter3_22, iter4_22 in ipairs(var9_22) do
		if type(iter4_22) ~= "string" then
			var7_22(iter4_22, var8_22[var10_22])

			var10_22 = var10_22 + 1
		end
	end

	for iter5_22 = var10_22, #var8_22 do
		var7_22("", var8_22[iter5_22])
	end
end

function var0_0.SetFleets(arg0_25, arg1_25)
	arg0_25._fleetVOs = {}
	arg0_25._legalFleetIdList = {}

	_.each(arg1_25, function(arg0_26)
		arg0_25._fleetVOs[arg0_26.id] = arg0_26

		table.insert(arg0_25._legalFleetIdList, arg0_26.id)
	end)
end

function var0_0.SetCurrentFleet(arg0_27, arg1_27)
	arg0_27._currentFleetVO = arg0_27._fleetVOs[arg1_27]

	arg0_27._formationLogic:SetFleetVO(arg0_27._currentFleetVO)

	for iter0_27, iter1_27 in ipairs(arg0_27._legalFleetIdList) do
		if arg0_27._currentFleetVO.id == iter1_27 then
			arg0_27._curFleetIndex = iter0_27

			break
		end
	end

	arg0_27:updateCommanderFormation()
end

function var0_0.SetOpenCommander(arg0_28, arg1_28)
	arg0_28.isOpenCommander = arg1_28
end

function var0_0.CheckLegalFleet(arg0_29)
	assert(false)
end

function var0_0.UpdateFleetView(arg0_30, arg1_30)
	arg0_30:displayFleetInfo()
	arg0_30:updateFleetBg()
	arg0_30._formationLogic:UpdateGridVisibility()
	arg0_30._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0_30._formationLogic:ResetGrid(TeamType.Main)
	arg0_30._formationLogic:ResetGrid(TeamType.Submarine)
	arg0_30:resetFormationComponent()

	if arg1_30 then
		arg0_30._formationLogic:LoadAllCharacter()
	else
		arg0_30._formationLogic:SetAllCharacterPos()
	end

	local var0_30 = arg0_30._currentFleetVO:getFleetType()

	setActive(arg0_30.btnRegular:Find("on"), var0_30 == FleetType.Normal)
	setActive(arg0_30.btnRegular:Find("off"), var0_30 ~= FleetType.Normal)
	setActive(arg0_30.btnSub:Find("on"), var0_30 == FleetType.Submarine)
	setActive(arg0_30.btnSub:Find("off"), var0_30 ~= FleetType.Submarine)
end

function var0_0.updateFleetBg(arg0_31)
	local var0_31 = arg0_31._currentFleetVO:getFleetType()

	setActive(arg0_31._bgFleet, var0_31 == FleetType.Normal)
	setActive(arg0_31._bgSub, var0_31 == FleetType.Submarine)
end

function var0_0.resetFormationComponent(arg0_32)
	SetActive(arg0_32._gridTFs.main[1]:Find("flag"), #arg0_32._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
	SetActive(arg0_32._gridTFs.submarine[1]:Find("flag"), #arg0_32._currentFleetVO:getTeamByName(TeamType.Submarine) ~= 0)
end

function var0_0.uiStartAnimating(arg0_33)
	local var0_33 = 0
	local var1_33 = 0.3

	shiftPanel(arg0_33._middle, 0, nil, var1_33, var0_33, true, true)
	shiftPanel(arg0_33._right, 0, nil, var1_33, var0_33, true, true)
end

function var0_0.uiExitAnimating(arg0_34)
	shiftPanel(arg0_34._middle, -840, nil, nil, nil, true, true)
	shiftPanel(arg0_34._right, 470, nil, nil, nil, true, true)
end

function var0_0.didEnter(arg0_35)
	onButton(arg0_35, arg0_35._backBtn, function()
		arg0_35:emit(LimitChallengePreCombatMediator.ON_UPDATE_CUSTOM_FLEET)

		GetOrAddComponent(arg0_35._tf, typeof(CanvasGroup)).interactable = false

		arg0_35:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0_35:closeView()
		end))
	end, SFX_CANCEL)
	onButton(arg0_35, arg0_35._tf:Find("blur_panel/top/option"), function()
		arg0_35:emit(LimitChallengePreCombatMediator.ON_UPDATE_CUSTOM_FLEET)
		arg0_35:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_35, arg0_35._startBtn, function()
		arg0_35:emit(LimitChallengePreCombatMediator.ON_START)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_35, arg0_35._nextPage, function()
		arg0_35:emit(LimitChallengePreCombatMediator.ON_CHANGE_FLEET, arg0_35._legalFleetIdList[arg0_35._curFleetIndex + 1])
	end, SFX_PANEL)
	onButton(arg0_35, arg0_35._prevPage, function()
		arg0_35:emit(LimitChallengePreCombatMediator.ON_CHANGE_FLEET, arg0_35._legalFleetIdList[arg0_35._curFleetIndex - 1])
	end, SFX_PANEL)
	arg0_35:UpdateFleetView(true)
	setActive(arg0_35._autoToggle, true)
	onToggle(arg0_35, arg0_35._autoToggle, function(arg0_42)
		arg0_35:emit(LimitChallengePreCombatMediator.ON_AUTO, {
			isOn = not arg0_42,
			toggle = arg0_35._autoToggle
		})

		arg0_35.autoFlag = arg0_42

		arg0_35:UpdateSubToggle()
	end, SFX_PANEL, SFX_PANEL)
	onToggle(arg0_35, arg0_35._autoSubToggle, function(arg0_43)
		arg0_35:emit(LimitChallengePreCombatMediator.ON_SUB_AUTO, {
			isOn = not arg0_43,
			toggle = arg0_35._autoSubToggle
		})
	end, SFX_PANEL, SFX_PANEL)
	onButton(arg0_35, arg0_35._tf:Find("bottom/fleet_select/regular"), function()
		arg0_35:emit(LimitChallengePreCombatMediator.ON_CHANGE_FLEET, FleetProxy.CHALLENGE_FLEET_ID)
	end, SFX_PANEL)
	onButton(arg0_35, arg0_35._tf:Find("bottom/fleet_select/sub"), function()
		arg0_35:emit(LimitChallengePreCombatMediator.ON_CHANGE_FLEET, FleetProxy.CHALLENGE_SUB_FLEET_ID)
	end, SFX_PANEL)

	if arg0_35.isOpenCommander then
		arg0_35.commanderFormationPanel:ActionInvoke("Show")
	end

	triggerToggle(arg0_35._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	onNextTick(function()
		arg0_35:uiStartAnimating()
	end)
	arg0_35:SetFleetStepper()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_35._tf, {
		groupName = LayerWeightConst.GROUP_FORMATION_PAGE
	})
end

function var0_0.UpdateSubToggle(arg0_47)
	if arg0_47.autoFlag and arg0_47._subUseable == true then
		setActive(arg0_47._autoSubToggle, true)
		triggerToggle(arg0_47._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
	else
		setActive(arg0_47._autoSubToggle, false)
	end
end

function var0_0.displayFleetInfo(arg0_48)
	local var0_48 = arg0_48._currentFleetVO:getFleetType()

	setActive(arg0_48._vanguardGS.parent, var0_48 == FleetType.Normal)
	setActive(arg0_48._mainGS.parent, var0_48 == FleetType.Normal)

	local var1_48 = math.floor(arg0_48._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2_48 = math.floor(arg0_48._currentFleetVO:GetGearScoreSum(TeamType.Main))

	setActive(arg0_48._subGS.parent, var0_48 == FleetType.Submarine)

	local var3_48 = math.floor(arg0_48._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4_48 = arg0_48.contextData.system

	setActive(arg0_48._costContainer, var4_48 ~= SYSTEM_DUEL)
	var1_0.tweenNumText(arg0_48._vanguardGS, var1_48)
	var1_0.tweenNumText(arg0_48._mainGS, var2_48)
	var1_0.tweenNumText(arg0_48._subGS, var3_48)
	setText(arg0_48._fleetNameText, arg0_48._currentFleetVO:GetName())
	setText(arg0_48._fleetNumText, arg0_48._curFleetIndex)

	local var5_48 = arg0_48.contextData.fleets
	local var6_48 = var5_48[#var5_48]
	local var7_48 = _.slice(var5_48, 1, #var5_48 - 1)
	local var8_48 = (function()
		local var0_49 = 0
		local var1_49 = pg.battle_cost_template[var4_48].oil_cost > 0

		local function var2_49(arg0_50, arg1_50)
			local var0_50 = 0

			if var1_49 then
				var0_50 = arg0_50:GetCostSum().oil

				if arg1_50 > 0 then
					var0_50 = math.min(arg1_50, var0_50)
				end
			end

			return var0_50
		end

		return var0_49 + var2_49(var7_48[1], 0) + var2_49(var6_48, 0)
	end)()

	var1_0.tweenNumText(arg0_48._costText, var8_48)
end

function var0_0.SetFleetStepper(arg0_51)
	SetActive(arg0_51._nextPage, arg0_51._curFleetIndex < #arg0_51._legalFleetIdList)
	SetActive(arg0_51._prevPage, arg0_51._curFleetIndex > 1)
end

function var0_0.updateCommanderFormation(arg0_52)
	if arg0_52.isOpenCommander then
		arg0_52.commanderFormationPanel:Load()
		arg0_52.commanderFormationPanel:ActionInvoke("Update", arg0_52._currentFleetVO)
	end
end

function var0_0.onBackPressed(arg0_53)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_53._backBtn)
end

function var0_0.willExit(arg0_54)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_54._tf)
	arg0_54.commanderFormationPanel:Destroy()
	arg0_54._formationLogic:Destroy()

	arg0_54._formationLogic = nil
end

return var0_0
