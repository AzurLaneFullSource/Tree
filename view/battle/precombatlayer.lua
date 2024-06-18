local var0_0 = class("PreCombatLayer", import("..base.BaseUI"))
local var1_0 = import("..ship.FormationUI")
local var2_0 = {
	[99] = true
}

var0_0.FORM_EDIT = "EDIT"
var0_0.FORM_PREVIEW = "PREVIEW"
var0_0.ObjectiveList = {
	"battle_preCombatLayer_victory",
	"battle_preCombatLayer_undefeated",
	"battle_preCombatLayer_sink_limit",
	"battle_preCombatLayer_time_hold",
	"battle_preCombatLayer_time_limit",
	"battle_preCombatLayer_boss_destruct",
	"battle_preCombatLayer_damage_before_end",
	"battle_result_defeat_all_enemys",
	"battle_preCombatLayer_destory_transport_ship"
}

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
	arg0_4._fleetInfo = var0_4:Find("fleet_info")
	arg0_4._fleetNameText = var0_4:Find("fleet_info/fleet_name/Text")
	arg0_4._fleetNumText = var0_4:Find("fleet_info/fleet_number")

	setActive(arg0_4._fleetInfo, arg0_4.contextData.system ~= SYSTEM_DUEL)

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
	arg0_4._checkBtn = var0_4:Find("checkBtn")
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
end

function var0_0.Register(arg0_5)
	arg0_5._formationLogic:AddLoadComplete(function()
		if arg0_5._currentForm ~= var0_0.FORM_EDIT then
			arg0_5._formationLogic:SwitchToPreviewMode()
		end
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

		local var7_7 = arg0_5.contextData.system
		local var8_7 = pg.battle_cost_template[var7_7]

		setActive(var3_7, var2_7 and var8_7.enter_energy_cost > 0)

		local var9_7 = arg1_7:getStar()

		for iter0_7 = 1, var9_7 do
			cloneTplTo(arg0_5._starTpl, var1_7)
		end

		local var10_7 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_7:getShipType()))

		if not var10_7 then
			warning("找不到船形, shipConfigId: " .. arg1_7.configId)
		end

		setImageSprite(findTF(var0_7, "type"), var10_7, true)
		setText(findTF(var0_7, "frame/lv_contain/lv"), arg1_7.level)

		if var8_7.ship_exp_award > 0 then
			local var11_7 = getProxy(ActivityProxy):getBuffShipList()[arg1_7:getGroupId()]
			local var12_7 = var0_7:Find("expbuff")

			setActive(var12_7, var11_7 ~= nil)

			if var11_7 then
				local var13_7 = var11_7 / 100
				local var14_7 = var11_7 % 100
				local var15_7 = tostring(var13_7)

				if var14_7 > 0 then
					var15_7 = var15_7 .. "." .. tostring(var14_7)
				end

				setText(var12_7:Find("text"), string.format("EXP +%s%%", var15_7))
			end
		else
			local var16_7 = var0_7:Find("expbuff")

			setActive(var16_7, false)
		end
	end)
	arg0_5._formationLogic:AddLongPress(function(arg0_8, arg1_8, arg2_8, arg3_8)
		arg0_5:emit(PreCombatMediator.OPEN_SHIP_INFO, arg1_8.id, arg2_8)
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
		arg0_5:emit(PreCombatMediator.CHANGE_FLEET_SHIP, arg0_11, arg2_11, arg1_11)
	end)
	arg0_5._formationLogic:AddShiftOnly(function(arg0_12)
		arg0_5:emit(PreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_12)
	end)
	arg0_5._formationLogic:AddRemoveShip(function(arg0_13, arg1_13)
		arg0_5:emit(PreCombatMediator.REMOVE_SHIP, arg0_13, arg1_13)
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

		arg0_5:SetFleetStepper()
		setActive(arg0_5._checkBtn:Find("save"), true)
		setActive(arg0_5._checkBtn:Find("edit"), false)
	end)
	arg0_5._formationLogic:AddSwitchToShiftMode(function()
		arg0_5:SetFleetStepper()

		arg0_5._checkBtn:GetComponent("Button").interactable = false
	end)
	arg0_5._formationLogic:AddSwitchToPreviewMode(function()
		arg0_5._currentForm = var0_0.FORM_PREVIEW
		arg0_5._checkBtn:GetComponent("Button").interactable = true

		arg0_5:SetFleetStepper()
		setActive(arg0_5._checkBtn:Find("save"), false)
		setActive(arg0_5._checkBtn:Find("edit"), true)
	end)
	arg0_5._formationLogic:AddGridTipClick(function(arg0_18, arg1_18)
		arg0_5:emit(PreCombatMediator.CHANGE_FLEET_SHIP, nil, arg0_5._currentFleetVO, arg0_18)
	end)
end

function var0_0.SetPlayerInfo(arg0_19, arg1_19)
	return
end

function var0_0.SetSubFlag(arg0_20, arg1_20)
	arg0_20._subUseable = arg1_20 or false
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

	if arg0_22.contextData.system ~= SYSTEM_BOSS_EXPERIMENT then
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
	end

	local function var7_22(arg0_24, arg1_24)
		if type(arg0_24) == "table" then
			setActive(arg1_24, true)

			local var0_24 = i18n(var0_0.ObjectiveList[arg0_24[1]], arg0_24[2])

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

	local var11_22 = var0_22.guide_desc and #var0_22.guide_desc > 0

	setActive(arg0_22.guideDesc, var11_22)

	if var11_22 then
		setText(arg0_22.guideDesc, var0_22.guide_desc)
	end
end

function var0_0.SetFleets(arg0_25, arg1_25)
	local var0_25 = _.filter(_.values(arg1_25), function(arg0_26)
		return arg0_26:getFleetType() == FleetType.Normal
	end)

	arg0_25._fleetVOs = {}

	_.each(var0_25, function(arg0_27)
		arg0_25._fleetVOs[arg0_27.id] = arg0_27
	end)
	arg0_25:CheckLegalFleet()
end

function var0_0.SetCurrentFleet(arg0_28, arg1_28)
	arg0_28._currentFleetVO = arg0_28._fleetVOs[arg1_28]

	arg0_28._formationLogic:SetFleetVO(arg0_28._currentFleetVO)
	arg0_28:CheckLegalFleet()

	for iter0_28, iter1_28 in ipairs(arg0_28._legalFleetIdList) do
		if arg0_28._currentFleetVO.id == iter1_28 then
			arg0_28._curFleetIndex = iter0_28

			break
		end
	end
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
	arg0_30._formationLogic:ResetGrid(TeamType.Vanguard, arg0_30._currentForm ~= var0_0.FORM_EDIT)
	arg0_30._formationLogic:ResetGrid(TeamType.Main, arg0_30._currentForm ~= var0_0.FORM_EDIT)
	arg0_30._formationLogic:ResetGrid(TeamType.Submarine, arg0_30._currentForm ~= var0_0.FORM_EDIT)
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
	if arg0_35._currentForm == var0_0.FORM_EDIT then
		arg0_35:emit(PreCombatMediator.ON_ABORT_EDIT)
	end

	var0_0.super.quickExitFunc(arg0_35)
end

function var0_0.didEnter(arg0_36)
	onButton(arg0_36, arg0_36._backBtn, function()
		local var0_37 = {}

		if arg0_36._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_37, function(arg0_38)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function()
						arg0_36:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_38()
						end)
					end,
					onNo = function()
						arg0_36:emit(PreCombatMediator.ON_ABORT_EDIT)
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

		if arg0_36._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_44, function(arg0_45)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function()
						arg0_36:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_45()
						end)
					end
				})
			end)
		end

		seriesAsync(var0_44, function()
			arg0_36:emit(PreCombatMediator.ON_START, arg0_36._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_36, arg0_36._nextPage, function()
		arg0_36:emit(PreCombatMediator.ON_CHANGE_FLEET, arg0_36._legalFleetIdList[arg0_36._curFleetIndex + 1])
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36._prevPage, function()
		arg0_36:emit(PreCombatMediator.ON_CHANGE_FLEET, arg0_36._legalFleetIdList[arg0_36._curFleetIndex - 1])
	end, SFX_PANEL)
	onButton(arg0_36, arg0_36._checkBtn, function()
		if arg0_36._currentForm == var0_0.FORM_EDIT then
			arg0_36:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				arg0_36._formationLogic:SwitchToPreviewMode()
			end)
		elseif arg0_36._currentForm == var0_0.FORM_PREVIEW then
			arg0_36._formationLogic:SwitchToDisplayMode()
		else
			assert("currentForm error")
		end
	end, SFX_PANEL)

	arg0_36._currentForm = arg0_36.contextData.form
	arg0_36.contextData.form = nil

	arg0_36:UpdateFleetView(true)

	if arg0_36._currentForm == var0_0.FORM_EDIT then
		arg0_36._formationLogic:SwitchToDisplayMode()
	else
		arg0_36._formationLogic:SwitchToPreviewMode()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_36._tf)
	setActive(arg0_36._autoToggle, true)
	onToggle(arg0_36, arg0_36._autoToggle, function(arg0_53)
		arg0_36:emit(PreCombatMediator.ON_AUTO, {
			isOn = not arg0_53,
			toggle = arg0_36._autoToggle
		})

		if arg0_53 and arg0_36._subUseable == true then
			setActive(arg0_36._autoSubToggle, true)
			onToggle(arg0_36, arg0_36._autoSubToggle, function(arg0_54)
				arg0_36:emit(PreCombatMediator.ON_SUB_AUTO, {
					isOn = not arg0_54,
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
end

function var0_0.displayFleetInfo(arg0_56)
	local var0_56 = arg0_56._currentFleetVO:getFleetType()

	setActive(arg0_56._vanguardGS.parent, var0_56 == FleetType.Normal)
	setActive(arg0_56._mainGS.parent, var0_56 == FleetType.Normal)

	local var1_56 = math.floor(arg0_56._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2_56 = math.floor(arg0_56._currentFleetVO:GetGearScoreSum(TeamType.Main))

	setActive(arg0_56._subGS.parent, var0_56 == FleetType.Submarine)

	local var3_56 = math.floor(arg0_56._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4_56 = arg0_56._currentFleetVO:GetCostSum()
	local var5_56 = arg0_56.contextData.system
	local var6_56 = pg.battle_cost_template[var5_56].oil_cost == 0 and 0 or var4_56.oil

	setActive(arg0_56._costContainer, var5_56 ~= SYSTEM_DUEL)
	var1_0.tweenNumText(arg0_56._costText, var6_56)
	var1_0.tweenNumText(arg0_56._vanguardGS, var1_56)
	var1_0.tweenNumText(arg0_56._mainGS, var2_56)
	var1_0.tweenNumText(arg0_56._subGS, var3_56)
	setText(arg0_56._fleetNameText, var1_0.defaultFleetName(arg0_56._currentFleetVO))
	setText(arg0_56._fleetNumText, arg0_56._currentFleetVO.id)
end

function var0_0.SetFleetStepper(arg0_57)
	if arg0_57.contextData.system == SYSTEM_DUEL or arg0_57._currentForm == var0_0.FORM_EDIT then
		SetActive(arg0_57._nextPage, false)
		SetActive(arg0_57._prevPage, false)
	else
		SetActive(arg0_57._nextPage, arg0_57._curFleetIndex < #arg0_57._legalFleetIdList)
		SetActive(arg0_57._prevPage, arg0_57._curFleetIndex > 1)
	end
end

function var0_0.onBackPressed(arg0_58)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_58._backBtn)
end

function var0_0.willExit(arg0_59)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_59._tf)
	arg0_59._formationLogic:Destroy()

	arg0_59._formationLogic = nil
end

return var0_0
