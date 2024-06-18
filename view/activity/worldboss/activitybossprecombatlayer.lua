local var0_0 = class("ActivityBossPreCombatLayer", import("view.battle.PreCombatLayer"))
local var1_0 = import("view.ship.FormationUI")
local var2_0 = {
	[99] = true
}

function var0_0.getUIName(arg0_1)
	return "ActivityBossPrecombatUI"
end

function var0_0.init(arg0_2)
	arg0_2:CommonInit()

	arg0_2._formationLogic = BaseFormation.New(arg0_2._tf, arg0_2._heroContainer, arg0_2._heroInfo, arg0_2._gridTFs)

	arg0_2:Register()
end

function var0_0.CommonInit(arg0_3)
	arg0_3.eventTriggers = {}
	arg0_3._startBtn = arg0_3:findTF("right/start")
	arg0_3._costContainer = arg0_3:findTF("right/start/cost_container")
	arg0_3._popup = arg0_3._costContainer:Find("popup")
	arg0_3._costText = arg0_3._popup:Find("Text")
	arg0_3._moveLayer = arg0_3:findTF("moveLayer")

	local var0_3 = arg0_3:findTF("middle")

	arg0_3._autoToggle = arg0_3:findTF("auto_toggle")
	arg0_3._autoSubToggle = arg0_3:findTF("sub_toggle_container/sub_toggle")
	arg0_3._fleetInfo = var0_3:Find("fleet_info")
	arg0_3._fleetNameText = var0_3:Find("fleet_info/fleet_name/Text")
	arg0_3._fleetNumText = var0_3:Find("fleet_info/fleet_number")

	setActive(arg0_3._fleetInfo, true)

	arg0_3._mainGS = var0_3:Find("gear_score/main/Text")
	arg0_3._vanguardGS = var0_3:Find("gear_score/vanguard/Text")
	arg0_3._subGS = var0_3:Find("gear_score/submarine/Text")
	arg0_3._bgFleet = var0_3:Find("mask/grid_bg")
	arg0_3._bgSub = var0_3:Find("mask/bg_sub")
	arg0_3._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0_3._gridFrame = var0_3:Find("mask/GridFrame")

	for iter0_3 = 1, 3 do
		arg0_3._gridTFs[TeamType.Main][iter0_3] = arg0_3._gridFrame:Find("main_" .. iter0_3)
		arg0_3._gridTFs[TeamType.Vanguard][iter0_3] = arg0_3._gridFrame:Find("vanguard_" .. iter0_3)
		arg0_3._gridTFs[TeamType.Submarine][iter0_3] = arg0_3._gridFrame:Find("submarine_" .. iter0_3)
	end

	arg0_3._nextPage = arg0_3:findTF("middle/nextPage")
	arg0_3._prevPage = arg0_3:findTF("middle/prevPage")
	arg0_3._heroContainer = var0_3:Find("HeroContainer")
	arg0_3._checkBtn = var0_3:Find("checkBtn")
	arg0_3._blurPanel = arg0_3:findTF("blur_panel")
	arg0_3.topPanel = arg0_3:findTF("top", arg0_3._blurPanel)
	arg0_3.topPanelBg = arg0_3:findTF("top_bg", arg0_3._blurPanel)
	arg0_3._backBtn = arg0_3:findTF("back_btn", arg0_3.topPanel)
	arg0_3._spoilsContainer = arg0_3:findTF("right/infomation/atlasloot/spoils/items/items_container")
	arg0_3._item = arg0_3:findTF("right/infomation/atlasloot/spoils/items/item_tpl")

	SetActive(arg0_3._item, false)

	arg0_3._goals = arg0_3:findTF("right/infomation/target/goal")
	arg0_3._heroInfo = arg0_3:getTpl("heroInfo")
	arg0_3._starTpl = arg0_3:getTpl("star_tpl")

	setText(findTF(arg0_3._tf, "middle/gear_score/vanguard/line/Image/Text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0_3._tf, "middle/gear_score/main/line/Image/Text1"), i18n("pre_combat_main"))
	setText(findTF(arg0_3._tf, "middle/gear_score/submarine/line/Image/text1"), i18n("pre_combat_submarine"))
	setText(arg0_3._costContainer:Find("title"), i18n("pre_combat_consume"))
	setText(findTF(arg0_3._tf, "right/infomation/target/title/GameObject"), i18n("pre_combat_targets"))
	setText(findTF(arg0_3._tf, "right/infomation/atlasloot/atlasloot/title/GameObject"), i18n("pre_combat_atlasloot"))
	setText(arg0_3._startBtn:Find("text"), i18n("pre_combat_start"))
	setText(arg0_3._startBtn:Find("text_en"), i18n("pre_combat_start_en"))

	arg0_3._middle = arg0_3:findTF("middle")
	arg0_3._right = arg0_3:findTF("right")

	setAnchoredPosition(arg0_3._middle, {
		x = -840
	})
	setAnchoredPosition(arg0_3._right, {
		x = 470
	})

	arg0_3.guideDesc = arg0_3:findTF("guideDesc", arg0_3._middle)

	if arg0_3.contextData.stageId then
		arg0_3:SetStageID(arg0_3.contextData.stageId)
	end

	arg0_3._ticket = arg0_3._startBtn:Find("ticket")
	arg0_3._bonus = arg0_3._startBtn:Find("bonus")
	arg0_3._costTip = arg0_3._startBtn:Find("cost_container/popup/tip")
	arg0_3._continuousBtn = arg0_3:findTF("right/multiple")

	setText(arg0_3._continuousBtn:Find("text"), i18n("multiple_sorties_title"))
	setText(arg0_3._continuousBtn:Find("text_en"), i18n("multiple_sorties_title_eng"))
	setText(arg0_3._ticket:Find("title"), i18n("ex_pass_use"))
	setText(arg0_3._bonus:Find("title"), i18n("expedition_extra_drop_tip"))
end

function var0_0.Register(arg0_4)
	arg0_4._formationLogic:AddLoadComplete(function()
		if arg0_4._currentForm ~= PreCombatLayer.FORM_EDIT then
			arg0_4._formationLogic:SwitchToPreviewMode()
		end
	end)
	arg0_4._formationLogic:AddHeroInfoModify(function(arg0_6, arg1_6)
		setAnchoredPosition(arg0_6, {
			x = 0,
			y = 0
		})
		SetActive(arg0_6, true)

		arg0_6.name = "info"

		local var0_6 = findTF(arg0_6, "info")
		local var1_6 = findTF(var0_6, "stars")
		local var2_6 = arg1_6.energy <= Ship.ENERGY_MID
		local var3_6 = findTF(var0_6, "energy")

		if var2_6 then
			local var4_6, var5_6 = arg1_6:getEnergyPrint()
			local var6_6 = GetSpriteFromAtlas("energy", var4_6)

			if not var6_6 then
				warning("找不到疲劳")
			end

			setImageSprite(var3_6, var6_6)
		end

		local var7_6 = arg0_4.contextData.system
		local var8_6 = pg.battle_cost_template[var7_6]

		setActive(var3_6, var2_6 and var8_6.enter_energy_cost > 0)

		local var9_6 = arg1_6:getStar()

		for iter0_6 = 1, var9_6 do
			cloneTplTo(arg0_4._starTpl, var1_6)
		end

		local var10_6 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_6:getShipType()))

		if not var10_6 then
			warning("找不到船形, shipConfigId: " .. arg1_6.configId)
		end

		setImageSprite(findTF(var0_6, "type"), var10_6, true)
		setText(findTF(var0_6, "frame/lv_contain/lv"), arg1_6.level)

		if var8_6.ship_exp_award > 0 then
			local var11_6 = getProxy(ActivityProxy):getBuffShipList()[arg1_6:getGroupId()]
			local var12_6 = var0_6:Find("expbuff")

			setActive(var12_6, var11_6 ~= nil)

			if var11_6 then
				local var13_6 = var11_6 / 100
				local var14_6 = var11_6 % 100
				local var15_6 = tostring(var13_6)

				if var14_6 > 0 then
					var15_6 = var15_6 .. "." .. tostring(var14_6)
				end

				setText(var12_6:Find("text"), string.format("EXP +%s%%", var15_6))
			end
		else
			local var16_6 = var0_6:Find("expbuff")

			setActive(var16_6, false)
		end
	end)
	arg0_4._formationLogic:AddLongPress(function(arg0_7, arg1_7, arg2_7, arg3_7)
		arg0_4:emit(ActivityBossPreCombatMediator.OPEN_SHIP_INFO, arg1_7.id, arg2_7)
	end)
	arg0_4._formationLogic:AddBeginDrag(function(arg0_8)
		local var0_8 = findTF(arg0_8, "info")

		SetActive(var0_8, false)
	end)
	arg0_4._formationLogic:AddEndDrag(function(arg0_9)
		local var0_9 = findTF(arg0_9, "info")

		SetActive(var0_9, true)
	end)
	arg0_4._formationLogic:AddClick(function(arg0_10, arg1_10, arg2_10)
		return
	end)
	arg0_4._formationLogic:AddShiftOnly(function(arg0_11)
		arg0_4:emit(ActivityBossPreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_11)
	end)
	arg0_4._formationLogic:AddRemoveShip(function(arg0_12, arg1_12)
		return
	end)
	arg0_4._formationLogic:AddCheckRemove(function(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
		arg0_13()
	end)
	arg0_4._formationLogic:AddSwitchToDisplayMode(function()
		arg0_4._currentForm = PreCombatLayer.FORM_EDIT
		arg0_4._checkBtn:GetComponent("Button").interactable = true

		arg0_4:SetFleetStepper()
		setActive(arg0_4._checkBtn:Find("save"), true)
		setActive(arg0_4._checkBtn:Find("edit"), false)
	end)
	arg0_4._formationLogic:AddSwitchToShiftMode(function()
		arg0_4:SetFleetStepper()

		arg0_4._checkBtn:GetComponent("Button").interactable = false
	end)
	arg0_4._formationLogic:AddSwitchToPreviewMode(function()
		arg0_4._currentForm = PreCombatLayer.FORM_PREVIEW
		arg0_4._checkBtn:GetComponent("Button").interactable = true

		arg0_4:SetFleetStepper()
		setActive(arg0_4._checkBtn:Find("save"), false)
		setActive(arg0_4._checkBtn:Find("edit"), true)
	end)
	arg0_4._formationLogic:AddGridTipClick(function(arg0_17, arg1_17)
		return
	end)

	if arg0_4.contextData.system == SYSTEM_ACT_BOSS then
		arg0_4._formationLogic:DisableTip()
	end
end

function var0_0.SetPlayerInfo(arg0_18, arg1_18)
	return
end

function var0_0.SetSubFlag(arg0_19, arg1_19)
	arg0_19._subUseable = arg1_19 or false
end

function var0_0.SetShips(arg0_20, arg1_20)
	arg0_20._shipVOs = arg1_20

	arg0_20._formationLogic:SetShipVOs(arg0_20._shipVOs)
end

function var0_0.SetStageID(arg0_21, arg1_21)
	removeAllChildren(arg0_21._spoilsContainer)

	arg0_21._stageID = arg1_21

	local var0_21 = pg.expedition_data_template[arg1_21]
	local var1_21 = Clone(var0_21.award_display)
	local var2_21 = checkExist(pg.expedition_activity_template[arg1_21], {
		"pt_drop_display"
	})

	if var2_21 and type(var2_21) == "table" then
		local var3_21 = getProxy(ActivityProxy)

		for iter0_21 = #var2_21, 1, -1 do
			local var4_21 = var3_21:getActivityById(var2_21[iter0_21][1])

			if var4_21 and not var4_21:isEnd() then
				table.insert(var1_21, 1, {
					2,
					id2ItemId(var2_21[iter0_21][2])
				})
			end
		end
	end

	if arg0_21.contextData.system ~= SYSTEM_BOSS_EXPERIMENT then
		for iter1_21, iter2_21 in ipairs(var1_21) do
			local var5_21 = cloneTplTo(arg0_21._item, arg0_21._spoilsContainer)
			local var6_21 = {
				id = iter2_21[2],
				type = iter2_21[1]
			}

			updateDrop(var5_21, var6_21)
			onButton(arg0_21, var5_21, function()
				local var0_22 = Item.getConfigData(iter2_21[2])

				if var0_22 and var2_0[var0_22.type] then
					local var1_22 = var0_22.display_icon
					local var2_22 = {}

					for iter0_22, iter1_22 in ipairs(var1_22) do
						local var3_22 = iter1_22[1]
						local var4_22 = iter1_22[2]

						var2_22[#var2_22 + 1] = {
							hideName = true,
							type = var3_22,
							id = var4_22
						}
					end

					arg0_21:emit(var0_0.ON_DROP_LIST, {
						item2Row = true,
						itemList = var2_22,
						content = var0_22.display
					})
				else
					arg0_21:emit(var0_0.ON_DROP, var6_21)
				end
			end, SFX_PANEL)
		end
	end

	local function var7_21(arg0_23, arg1_23)
		if type(arg0_23) == "table" then
			setActive(arg1_23, true)

			local var0_23 = i18n(PreCombatLayer.ObjectiveList[arg0_23[1]], arg0_23[2])

			setWidgetText(arg1_23, var0_23)
		else
			setActive(arg1_23, false)
		end
	end

	local var8_21 = {
		findTF(arg0_21._goals, "goal_tpl"),
		findTF(arg0_21._goals, "goal_sink"),
		findTF(arg0_21._goals, "goal_time")
	}
	local var9_21 = {
		var0_21.objective_1,
		var0_21.objective_2,
		var0_21.objective_3
	}
	local var10_21 = 1

	for iter3_21, iter4_21 in ipairs(var9_21) do
		if type(iter4_21) ~= "string" then
			var7_21(iter4_21, var8_21[var10_21])

			var10_21 = var10_21 + 1
		end
	end

	for iter5_21 = var10_21, #var8_21 do
		var7_21("", var8_21[iter5_21])
	end

	local var11_21 = var0_21.guide_desc and #var0_21.guide_desc > 0

	setActive(arg0_21.guideDesc, var11_21)

	if var11_21 then
		setText(arg0_21.guideDesc, var0_21.guide_desc)
	end
end

function var0_0.SetFleets(arg0_24, arg1_24)
	local var0_24 = _.filter(_.values(arg1_24), function(arg0_25)
		return arg0_25:getFleetType() == FleetType.Normal
	end)

	arg0_24._fleetVOs = {}

	_.each(var0_24, function(arg0_26)
		arg0_24._fleetVOs[arg0_26.id] = arg0_26
	end)
	arg0_24:CheckLegalFleet()
end

function var0_0.SetCurrentFleet(arg0_27, arg1_27)
	arg0_27._currentFleetVO = arg0_27._fleetVOs[arg1_27]

	arg0_27._formationLogic:SetFleetVO(arg0_27._currentFleetVO)
	arg0_27:CheckLegalFleet()

	for iter0_27, iter1_27 in ipairs(arg0_27._legalFleetIdList) do
		if arg0_27._currentFleetVO.id == iter1_27 then
			arg0_27._curFleetIndex = iter0_27

			break
		end
	end
end

function var0_0.SetTicketItemID(arg0_28, arg1_28)
	arg0_28._ticketItemID = arg1_28
end

function var0_0.CheckLegalFleet(arg0_29)
	arg0_29._legalFleetIdList = {}

	for iter0_29, iter1_29 in pairs(arg0_29._fleetVOs) do
		if #iter1_29.ships > 0 and iter1_29.id ~= FleetProxy.PVP_FLEET_ID then
			table.insert(arg0_29._legalFleetIdList, iter1_29.id)
		end
	end

	table.sort(arg0_29._legalFleetIdList)
end

function var0_0.UpdateFleetView(arg0_30, arg1_30)
	arg0_30:displayFleetInfo()
	arg0_30:updateFleetBg()
	arg0_30._formationLogic:UpdateGridVisibility()
	arg0_30._formationLogic:ResetGrid(TeamType.Vanguard, arg0_30._currentForm ~= PreCombatLayer.FORM_EDIT)
	arg0_30._formationLogic:ResetGrid(TeamType.Main, arg0_30._currentForm ~= PreCombatLayer.FORM_EDIT)
	arg0_30._formationLogic:ResetGrid(TeamType.Submarine, arg0_30._currentForm ~= PreCombatLayer.FORM_EDIT)
	arg0_30:resetFormationComponent()

	if arg1_30 then
		arg0_30._formationLogic:LoadAllCharacter()
	else
		arg0_30._formationLogic:SetAllCharacterPos()
	end
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

function var0_0.quickExitFunc(arg0_35)
	if arg0_35._currentForm == PreCombatLayer.FORM_EDIT then
		arg0_35:emit(ActivityBossPreCombatMediator.ON_ABORT_EDIT)
	end

	var0_0.super.quickExitFunc(arg0_35)
end

function var0_0.didEnter(arg0_36)
	onButton(arg0_36, arg0_36._backBtn, function()
		local var0_37 = {}

		if arg0_36._currentForm == PreCombatLayer.FORM_EDIT then
			table.insert(var0_37, function(arg0_38)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function()
						arg0_36:emit(ActivityBossPreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_38()
						end)
					end,
					onNo = function()
						arg0_36:emit(ActivityBossPreCombatMediator.ON_ABORT_EDIT)
						arg0_38()
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			end)
		end

		seriesAsync(var0_37, function()
			GetOrAddComponent(arg0_36._tf, typeof(CanvasGroup)).interactable = false

			arg0_36:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0_36:emit(var0_0.ON_CLOSE)
			end))
		end)
	end, SFX_CANCEL)
	onButton(arg0_36, arg0_36._startBtn, function()
		local var0_44 = {}

		if arg0_36._currentForm == PreCombatLayer.FORM_EDIT then
			table.insert(var0_44, function(arg0_45)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function()
						arg0_36:emit(ActivityBossPreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_45()
						end)
					end
				})
			end)
		end

		seriesAsync(var0_44, function()
			arg0_36:emit(ActivityBossPreCombatMediator.ON_START, arg0_36._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_36, arg0_36._checkBtn, function()
		if arg0_36._currentForm == PreCombatLayer.FORM_EDIT then
			arg0_36:emit(ActivityBossPreCombatMediator.ON_COMMIT_EDIT, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				arg0_36._formationLogic:SwitchToPreviewMode()
			end)
		elseif arg0_36._currentForm == PreCombatLayer.FORM_PREVIEW then
			arg0_36._formationLogic:SwitchToDisplayMode()
		else
			assert("currentForm error")
		end
	end, SFX_PANEL)

	arg0_36._currentForm = arg0_36.contextData.form
	arg0_36.contextData.form = nil

	arg0_36:UpdateFleetView(true)

	if arg0_36._currentForm == PreCombatLayer.FORM_EDIT then
		arg0_36._formationLogic:SwitchToDisplayMode()
	else
		arg0_36._formationLogic:SwitchToPreviewMode()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_36._tf)
	setActive(arg0_36._autoToggle, true)
	onToggle(arg0_36, arg0_36._autoToggle, function(arg0_51)
		arg0_36:emit(ActivityBossPreCombatMediator.ON_AUTO, {
			isOn = not arg0_51,
			toggle = arg0_36._autoToggle
		})

		if arg0_51 and arg0_36._subUseable == true then
			setActive(arg0_36._autoSubToggle, true)
			onToggle(arg0_36, arg0_36._autoSubToggle, function(arg0_52)
				arg0_36:emit(ActivityBossPreCombatMediator.ON_SUB_AUTO, {
					isOn = not arg0_52,
					toggle = arg0_36._autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0_36._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
		else
			setActive(arg0_36._autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	triggerToggle(arg0_36._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	onNextTick(function()
		arg0_36:uiStartAnimating()
	end)

	local var0_36 = arg0_36.contextData.stageId
	local var1_36 = getProxy(ActivityProxy):getActivityById(arg0_36.contextData.actId)

	setActive(arg0_36._continuousBtn, arg0_36.contextData.system == SYSTEM_ACT_BOSS)

	local var2_36 = var1_36 and var1_36:IsOilLimit(var0_36)

	setActive(arg0_36._continuousBtn:Find("lock"), not var2_36)

	local var3_36 = var2_36 and Color.white or Color.New(0.298039215686275, 0.298039215686275, 0.298039215686275)

	setImageColor(arg0_36._continuousBtn, var3_36)
	setTextColor(arg0_36._continuousBtn:Find("text"), var3_36)
	setTextColor(arg0_36._continuousBtn:Find("text_en"), var3_36)
	onButton(arg0_36, arg0_36._continuousBtn, function()
		if var2_36 then
			arg0_36:emit(ActivityBossPreCombatMediator.SHOW_CONTINUOUS_OPERATION_WINDOW, arg0_36._currentFleetVO.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_locked_tip"))
		end
	end, SFX_PANEL)
end

function var0_0.displayFleetInfo(arg0_55)
	local var0_55 = arg0_55._currentFleetVO:getFleetType()

	setActive(arg0_55._vanguardGS.parent, var0_55 == FleetType.Normal)
	setActive(arg0_55._mainGS.parent, var0_55 == FleetType.Normal)

	local var1_55 = math.floor(arg0_55._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2_55 = math.floor(arg0_55._currentFleetVO:GetGearScoreSum(TeamType.Main))

	setActive(arg0_55._subGS.parent, var0_55 == FleetType.Submarine)

	local var3_55 = math.floor(arg0_55._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4_55 = arg0_55._currentFleetVO:GetCostSum()
	local var5_55 = arg0_55.contextData.system
	local var6_55 = pg.battle_cost_template[var5_55].oil_cost == 0 and 0 or var4_55.oil

	setActive(arg0_55._costContainer, true)
	var1_0.tweenNumText(arg0_55._costText, var6_55)
	var1_0.tweenNumText(arg0_55._vanguardGS, var1_55)
	var1_0.tweenNumText(arg0_55._mainGS, var2_55)
	var1_0.tweenNumText(arg0_55._subGS, var3_55)
	setText(arg0_55._fleetNameText, var1_0.defaultFleetName(arg0_55._currentFleetVO))
	setText(arg0_55._fleetNumText, arg0_55._currentFleetVO.id)

	local var7_55 = arg0_55.contextData.stageId
	local var8_55 = getProxy(ActivityProxy):getActivityById(arg0_55.contextData.actId):GetStageBonus(var7_55)

	setActive(arg0_55._bonus, var8_55 > 0)
	setActive(arg0_55._ticket, var8_55 <= 0)
	setText(arg0_55._bonus:Find("Text"), var8_55)

	if var8_55 <= 0 then
		local var9_55 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = arg0_55._ticketItemID
		}):getIcon()
		local var10_55 = LoadSprite(var9_55, "")

		setImageSprite(arg0_55._ticket:Find("icon"), var10_55)

		local var11_55 = getProxy(PlayerProxy):getRawData():getResource(arg0_55._ticketItemID)
		local var12_55 = 1
		local var13_55 = arg0_55._ticket:Find("checkbox")

		if var5_55 == SYSTEM_BOSS_EXPERIMENT then
			var12_55 = 0

			triggerToggle(var13_55, false)
			setToggleEnabled(var13_55, false)
		elseif var5_55 == SYSTEM_HP_SHARE_ACT_BOSS then
			triggerToggle(var13_55, true)
			setToggleEnabled(var13_55, false)
		elseif var5_55 == SYSTEM_ACT_BOSS_SP then
			setActive(arg0_55._ticket, false)
		elseif var5_55 == SYSTEM_ACT_BOSS then
			local var14_55 = var11_55 > 0
			local var15_55 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1

			setToggleEnabled(var13_55, var14_55)
			triggerToggle(var13_55, var14_55 and var15_55)
		end

		var11_55 = var11_55 < var12_55 and setColorStr(var11_55, COLOR_RED) or var11_55

		setText(arg0_55._ticket:Find("Text"), var12_55 .. "/" .. var11_55)
		onToggle(arg0_55, var13_55, function(arg0_56)
			getProxy(SettingsProxy):setActBossExchangeTicketTip(arg0_56 and 1 or 0)
		end, SFX_PANEL, SFX_CANCEL)
	end

	local var16_55 = pg.battle_cost_template[var5_55].oil_cost > 0
	local var17_55 = 0
	local var18_55 = 0
	local var19_55 = false

	for iter0_55, iter1_55 in ipairs({
		arg0_55.contextData.fleets[1]
	}) do
		local var20_55 = iter1_55:GetCostSum().oil

		if not var16_55 then
			var20_55 = 0
		end

		var18_55 = var18_55 + var20_55

		local var21_55 = iter0_55 == 1
		local var22_55 = arg0_55.contextData.costLimit[var21_55 and 1 or 2]

		if var22_55 > 0 then
			var19_55 = var19_55 or var22_55 < var20_55
			var20_55 = math.min(var20_55, var22_55)
		end

		var17_55 = var17_55 + var20_55
	end

	setTextColor(arg0_55._costText, var19_55 and Color(0.980392156862745, 0.392156862745098, 0.392156862745098) or Color.white)
	var1_0.tweenNumText(arg0_55._costText, var17_55)
	setActive(arg0_55._costTip, var19_55)

	if var19_55 then
		onButton(arg0_55, arg0_55._costTip, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("use_oil_limit_help", var18_55, var17_55),
				weight = LayerWeightConst.SECOND_LAYER
			})
		end)
	end

	setText(arg0_55._fleetNameText, Fleet.DEFAULT_NAME_BOSS_ACT[arg0_55._currentFleetVO.id])
end

function var0_0.SetFleetStepper(arg0_58)
	SetActive(arg0_58._nextPage, false)
	SetActive(arg0_58._prevPage, false)
end

function var0_0.onBackPressed(arg0_59)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_59._backBtn)
end

function var0_0.willExit(arg0_60)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_60._tf)
	arg0_60._formationLogic:Destroy()

	arg0_60._formationLogic = nil
end

return var0_0
