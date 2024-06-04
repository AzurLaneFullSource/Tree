local var0 = class("PreCombatLayer", import("..base.BaseUI"))
local var1 = import("..ship.FormationUI")
local var2 = {
	[99] = true
}

var0.FORM_EDIT = "EDIT"
var0.FORM_PREVIEW = "PREVIEW"
var0.ObjectiveList = {
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

function var0.getUIName(arg0)
	return "PreCombatUI"
end

function var0.ResUISettings(arg0)
	return {
		order = 5,
		anim = true,
		showType = PlayerResUI.TYPE_ALL
	}
end

function var0.init(arg0)
	arg0:CommonInit()

	arg0._formationLogic = BaseFormation.New(arg0._tf, arg0._heroContainer, arg0._heroInfo, arg0._gridTFs)

	arg0:Register()
end

function var0.CommonInit(arg0)
	arg0.eventTriggers = {}
	arg0._startBtn = arg0:findTF("right/start")
	arg0._costContainer = arg0:findTF("right/start/cost_container")
	arg0._popup = arg0._costContainer:Find("popup")
	arg0._costText = arg0._popup:Find("Text")
	arg0._moveLayer = arg0:findTF("moveLayer")

	local var0 = arg0:findTF("middle")

	arg0._autoToggle = arg0:findTF("auto_toggle")
	arg0._autoSubToggle = arg0:findTF("sub_toggle_container/sub_toggle")
	arg0._fleetInfo = var0:Find("fleet_info")
	arg0._fleetNameText = var0:Find("fleet_info/fleet_name/Text")
	arg0._fleetNumText = var0:Find("fleet_info/fleet_number")

	setActive(arg0._fleetInfo, arg0.contextData.system ~= SYSTEM_DUEL)

	arg0._mainGS = var0:Find("gear_score/main/Text")
	arg0._vanguardGS = var0:Find("gear_score/vanguard/Text")
	arg0._subGS = var0:Find("gear_score/submarine/Text")
	arg0._bgFleet = var0:Find("mask/grid_bg")
	arg0._bgSub = var0:Find("mask/bg_sub")
	arg0._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0._gridFrame = var0:Find("mask/GridFrame")

	for iter0 = 1, 3 do
		arg0._gridTFs[TeamType.Main][iter0] = arg0._gridFrame:Find("main_" .. iter0)
		arg0._gridTFs[TeamType.Vanguard][iter0] = arg0._gridFrame:Find("vanguard_" .. iter0)
		arg0._gridTFs[TeamType.Submarine][iter0] = arg0._gridFrame:Find("submarine_" .. iter0)
	end

	arg0._nextPage = arg0:findTF("middle/nextPage")
	arg0._prevPage = arg0:findTF("middle/prevPage")
	arg0._heroContainer = var0:Find("HeroContainer")
	arg0._checkBtn = var0:Find("checkBtn")
	arg0._blurPanel = arg0:findTF("blur_panel")
	arg0.topPanel = arg0:findTF("top", arg0._blurPanel)
	arg0.topPanelBg = arg0:findTF("top_bg", arg0._blurPanel)
	arg0._backBtn = arg0:findTF("back_btn", arg0.topPanel)
	arg0._spoilsContainer = arg0:findTF("right/infomation/atlasloot/spoils/items/items_container")
	arg0._item = arg0:findTF("right/infomation/atlasloot/spoils/items/item_tpl")

	SetActive(arg0._item, false)

	arg0._goals = arg0:findTF("right/infomation/target/goal")
	arg0._heroInfo = arg0:getTpl("heroInfo")
	arg0._starTpl = arg0:getTpl("star_tpl")

	setText(findTF(arg0._tf, "middle/gear_score/vanguard/line/Image/Text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0._tf, "middle/gear_score/main/line/Image/Text1"), i18n("pre_combat_main"))
	setText(findTF(arg0._tf, "middle/gear_score/submarine/line/Image/text1"), i18n("pre_combat_submarine"))
	setText(arg0._costContainer:Find("title"), i18n("pre_combat_consume"))
	setText(findTF(arg0._tf, "right/infomation/target/title/GameObject"), i18n("pre_combat_targets"))
	setText(findTF(arg0._tf, "right/infomation/atlasloot/atlasloot/title/GameObject"), i18n("pre_combat_atlasloot"))
	setText(arg0._startBtn:Find("text"), i18n("pre_combat_start"))
	setText(arg0._startBtn:Find("text_en"), i18n("pre_combat_start_en"))

	arg0._middle = arg0:findTF("middle")
	arg0._right = arg0:findTF("right")

	setAnchoredPosition(arg0._middle, {
		x = -840
	})
	setAnchoredPosition(arg0._right, {
		x = 470
	})

	arg0.guideDesc = arg0:findTF("guideDesc", arg0._middle)

	if arg0.contextData.stageId then
		arg0:SetStageID(arg0.contextData.stageId)
	end
end

function var0.Register(arg0)
	arg0._formationLogic:AddLoadComplete(function()
		if arg0._currentForm ~= var0.FORM_EDIT then
			arg0._formationLogic:SwitchToPreviewMode()
		end
	end)
	arg0._formationLogic:AddHeroInfoModify(function(arg0, arg1)
		setAnchoredPosition(arg0, {
			x = 0,
			y = 0
		})
		SetActive(arg0, true)

		arg0.name = "info"

		local var0 = findTF(arg0, "info")
		local var1 = findTF(var0, "stars")
		local var2 = arg1.energy <= Ship.ENERGY_MID
		local var3 = findTF(var0, "energy")

		if var2 then
			local var4, var5 = arg1:getEnergyPrint()
			local var6 = GetSpriteFromAtlas("energy", var4)

			if not var6 then
				warning("找不到疲劳")
			end

			setImageSprite(var3, var6)
		end

		local var7 = arg0.contextData.system
		local var8 = pg.battle_cost_template[var7]

		setActive(var3, var2 and var8.enter_energy_cost > 0)

		local var9 = arg1:getStar()

		for iter0 = 1, var9 do
			cloneTplTo(arg0._starTpl, var1)
		end

		local var10 = GetSpriteFromAtlas("shiptype", shipType2print(arg1:getShipType()))

		if not var10 then
			warning("找不到船形, shipConfigId: " .. arg1.configId)
		end

		setImageSprite(findTF(var0, "type"), var10, true)
		setText(findTF(var0, "frame/lv_contain/lv"), arg1.level)

		if var8.ship_exp_award > 0 then
			local var11 = getProxy(ActivityProxy):getBuffShipList()[arg1:getGroupId()]
			local var12 = var0:Find("expbuff")

			setActive(var12, var11 ~= nil)

			if var11 then
				local var13 = var11 / 100
				local var14 = var11 % 100
				local var15 = tostring(var13)

				if var14 > 0 then
					var15 = var15 .. "." .. tostring(var14)
				end

				setText(var12:Find("text"), string.format("EXP +%s%%", var15))
			end
		else
			local var16 = var0:Find("expbuff")

			setActive(var16, false)
		end
	end)
	arg0._formationLogic:AddLongPress(function(arg0, arg1, arg2, arg3)
		arg0:emit(PreCombatMediator.OPEN_SHIP_INFO, arg1.id, arg2)
	end)
	arg0._formationLogic:AddBeginDrag(function(arg0)
		local var0 = findTF(arg0, "info")

		SetActive(var0, false)
	end)
	arg0._formationLogic:AddEndDrag(function(arg0)
		local var0 = findTF(arg0, "info")

		SetActive(var0, true)
	end)
	arg0._formationLogic:AddClick(function(arg0, arg1, arg2)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)
		arg0:emit(PreCombatMediator.CHANGE_FLEET_SHIP, arg0, arg2, arg1)
	end)
	arg0._formationLogic:AddShiftOnly(function(arg0)
		arg0:emit(PreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0)
	end)
	arg0._formationLogic:AddRemoveShip(function(arg0, arg1)
		arg0:emit(PreCombatMediator.REMOVE_SHIP, arg0, arg1)
	end)
	arg0._formationLogic:AddCheckRemove(function(arg0, arg1, arg2, arg3, arg4)
		if not arg3:canRemove(arg2) then
			local var0, var1 = arg3:getShipPos(arg2)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2:getConfigTable().name, arg3.name, Fleet.C_TEAM_NAME[var1]))
			arg0()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				zIndex = -100,
				hideNo = false,
				content = i18n("battle_preCombatLayer_quest_leaveFleet", arg2:getConfigTable().name),
				onYes = arg1,
				onNo = arg0
			})
		end
	end)
	arg0._formationLogic:AddSwitchToDisplayMode(function()
		arg0._currentForm = var0.FORM_EDIT
		arg0._checkBtn:GetComponent("Button").interactable = true

		arg0:SetFleetStepper()
		setActive(arg0._checkBtn:Find("save"), true)
		setActive(arg0._checkBtn:Find("edit"), false)
	end)
	arg0._formationLogic:AddSwitchToShiftMode(function()
		arg0:SetFleetStepper()

		arg0._checkBtn:GetComponent("Button").interactable = false
	end)
	arg0._formationLogic:AddSwitchToPreviewMode(function()
		arg0._currentForm = var0.FORM_PREVIEW
		arg0._checkBtn:GetComponent("Button").interactable = true

		arg0:SetFleetStepper()
		setActive(arg0._checkBtn:Find("save"), false)
		setActive(arg0._checkBtn:Find("edit"), true)
	end)
	arg0._formationLogic:AddGridTipClick(function(arg0, arg1)
		arg0:emit(PreCombatMediator.CHANGE_FLEET_SHIP, nil, arg0._currentFleetVO, arg0)
	end)
end

function var0.SetPlayerInfo(arg0, arg1)
	return
end

function var0.SetSubFlag(arg0, arg1)
	arg0._subUseable = arg1 or false
end

function var0.SetShips(arg0, arg1)
	arg0._shipVOs = arg1

	arg0._formationLogic:SetShipVOs(arg0._shipVOs)
end

function var0.SetStageID(arg0, arg1)
	removeAllChildren(arg0._spoilsContainer)

	arg0._stageID = arg1

	local var0 = pg.expedition_data_template[arg1]
	local var1 = Clone(var0.award_display)
	local var2 = checkExist(pg.expedition_activity_template[arg1], {
		"pt_drop_display"
	})

	if var2 and type(var2) == "table" then
		local var3 = getProxy(ActivityProxy)

		for iter0 = #var2, 1, -1 do
			local var4 = var3:getActivityById(var2[iter0][1])

			if var4 and not var4:isEnd() then
				table.insert(var1, 1, {
					2,
					id2ItemId(var2[iter0][2])
				})
			end
		end
	end

	if arg0.contextData.system ~= SYSTEM_BOSS_EXPERIMENT then
		for iter1, iter2 in ipairs(var1) do
			local var5 = cloneTplTo(arg0._item, arg0._spoilsContainer)
			local var6 = {
				id = iter2[2],
				type = iter2[1]
			}

			updateDrop(var5, var6)
			onButton(arg0, var5, function()
				local var0 = Item.getConfigData(iter2[2])

				if var0 and var2[var0.type] then
					local var1 = var0.display_icon
					local var2 = {}

					for iter0, iter1 in ipairs(var1) do
						local var3 = iter1[1]
						local var4 = iter1[2]

						var2[#var2 + 1] = {
							type = var3,
							id = var4
						}
					end

					arg0:emit(var0.ON_DROP_LIST, {
						item2Row = true,
						itemList = var2,
						content = var0.display
					})
				else
					arg0:emit(var0.ON_DROP, var6)
				end
			end, SFX_PANEL)
		end
	end

	local function var7(arg0, arg1)
		if type(arg0) == "table" then
			setActive(arg1, true)

			local var0 = i18n(var0.ObjectiveList[arg0[1]], arg0[2])

			setWidgetText(arg1, var0)
		else
			setActive(arg1, false)
		end
	end

	local var8 = {
		findTF(arg0._goals, "goal_tpl"),
		findTF(arg0._goals, "goal_sink"),
		findTF(arg0._goals, "goal_time")
	}
	local var9 = {
		var0.objective_1,
		var0.objective_2,
		var0.objective_3
	}
	local var10 = 1

	for iter3, iter4 in ipairs(var9) do
		if type(iter4) ~= "string" then
			var7(iter4, var8[var10])

			var10 = var10 + 1
		end
	end

	for iter5 = var10, #var8 do
		var7("", var8[iter5])
	end

	local var11 = var0.guide_desc and #var0.guide_desc > 0

	setActive(arg0.guideDesc, var11)

	if var11 then
		setText(arg0.guideDesc, var0.guide_desc)
	end
end

function var0.SetFleets(arg0, arg1)
	local var0 = _.filter(_.values(arg1), function(arg0)
		return arg0:getFleetType() == FleetType.Normal
	end)

	arg0._fleetVOs = {}

	_.each(var0, function(arg0)
		arg0._fleetVOs[arg0.id] = arg0
	end)
	arg0:CheckLegalFleet()
end

function var0.SetCurrentFleet(arg0, arg1)
	arg0._currentFleetVO = arg0._fleetVOs[arg1]

	arg0._formationLogic:SetFleetVO(arg0._currentFleetVO)
	arg0:CheckLegalFleet()

	for iter0, iter1 in ipairs(arg0._legalFleetIdList) do
		if arg0._currentFleetVO.id == iter1 then
			arg0._curFleetIndex = iter0

			break
		end
	end
end

function var0.CheckLegalFleet(arg0)
	arg0._legalFleetIdList = {}

	for iter0, iter1 in pairs(arg0._fleetVOs) do
		if #iter1.ships > 0 and iter1.id ~= FleetProxy.PVP_FLEET_ID then
			table.insert(arg0._legalFleetIdList, iter1.id)
		end
	end

	table.sort(arg0._legalFleetIdList)
end

function var0.UpdateFleetView(arg0, arg1)
	arg0:displayFleetInfo()
	arg0:updateFleetBg()
	arg0._formationLogic:UpdateGridVisibility()
	arg0._formationLogic:ResetGrid(TeamType.Vanguard, arg0._currentForm ~= var0.FORM_EDIT)
	arg0._formationLogic:ResetGrid(TeamType.Main, arg0._currentForm ~= var0.FORM_EDIT)
	arg0._formationLogic:ResetGrid(TeamType.Submarine, arg0._currentForm ~= var0.FORM_EDIT)
	arg0:resetFormationComponent()

	if arg1 then
		arg0._formationLogic:LoadAllCharacter()
	else
		arg0._formationLogic:SetAllCharacterPos()
	end
end

function var0.updateFleetBg(arg0)
	local var0 = arg0._currentFleetVO:getFleetType()

	setActive(arg0._bgFleet, var0 == FleetType.Normal)
	setActive(arg0._bgSub, var0 == FleetType.Submarine)
end

function var0.resetFormationComponent(arg0)
	SetActive(arg0._gridTFs.main[1]:Find("flag"), #arg0._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
	SetActive(arg0._gridTFs.submarine[1]:Find("flag"), #arg0._currentFleetVO:getTeamByName(TeamType.Submarine) ~= 0)
end

function var0.uiStartAnimating(arg0)
	local var0 = 0
	local var1 = 0.3

	shiftPanel(arg0._middle, 0, nil, var1, var0, true, true)
	shiftPanel(arg0._right, 0, nil, var1, var0, true, true)
end

function var0.uiExitAnimating(arg0)
	shiftPanel(arg0._middle, -840, nil, nil, nil, true, true)
	shiftPanel(arg0._right, 470, nil, nil, nil, true, true)
end

function var0.quickExitFunc(arg0)
	if arg0._currentForm == var0.FORM_EDIT then
		arg0:emit(PreCombatMediator.ON_ABORT_EDIT)
	end

	var0.super.quickExitFunc(arg0)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._backBtn, function()
		local var0 = {}

		if arg0._currentForm == var0.FORM_EDIT then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function()
						arg0:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0()
						end)
					end,
					onNo = function()
						arg0:emit(PreCombatMediator.ON_ABORT_EDIT)
						arg0()
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			end)
		end

		seriesAsync(var0, function()
			GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

			arg0:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0:emit(var0.ON_CLOSE)
			end))
		end)
	end, SFX_CANCEL)
	onButton(arg0, arg0._startBtn, function()
		local var0 = {}

		if arg0._currentForm == var0.FORM_EDIT then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function()
						arg0:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0()
						end)
					end
				})
			end)
		end

		seriesAsync(var0, function()
			arg0:emit(PreCombatMediator.ON_START, arg0._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0, arg0._nextPage, function()
		arg0:emit(PreCombatMediator.ON_CHANGE_FLEET, arg0._legalFleetIdList[arg0._curFleetIndex + 1])
	end, SFX_PANEL)
	onButton(arg0, arg0._prevPage, function()
		arg0:emit(PreCombatMediator.ON_CHANGE_FLEET, arg0._legalFleetIdList[arg0._curFleetIndex - 1])
	end, SFX_PANEL)
	onButton(arg0, arg0._checkBtn, function()
		if arg0._currentForm == var0.FORM_EDIT then
			arg0:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				arg0._formationLogic:SwitchToPreviewMode()
			end)
		elseif arg0._currentForm == var0.FORM_PREVIEW then
			arg0._formationLogic:SwitchToDisplayMode()
		else
			assert("currentForm error")
		end
	end, SFX_PANEL)

	arg0._currentForm = arg0.contextData.form
	arg0.contextData.form = nil

	arg0:UpdateFleetView(true)

	if arg0._currentForm == var0.FORM_EDIT then
		arg0._formationLogic:SwitchToDisplayMode()
	else
		arg0._formationLogic:SwitchToPreviewMode()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._autoToggle, true)
	onToggle(arg0, arg0._autoToggle, function(arg0)
		arg0:emit(PreCombatMediator.ON_AUTO, {
			isOn = not arg0,
			toggle = arg0._autoToggle
		})

		if arg0 and arg0._subUseable == true then
			setActive(arg0._autoSubToggle, true)
			onToggle(arg0, arg0._autoSubToggle, function(arg0)
				arg0:emit(PreCombatMediator.ON_SUB_AUTO, {
					isOn = not arg0,
					toggle = arg0._autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
		else
			setActive(arg0._autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	triggerToggle(arg0._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	onNextTick(function()
		arg0:uiStartAnimating()
	end)
end

function var0.displayFleetInfo(arg0)
	local var0 = arg0._currentFleetVO:getFleetType()

	setActive(arg0._vanguardGS.parent, var0 == FleetType.Normal)
	setActive(arg0._mainGS.parent, var0 == FleetType.Normal)

	local var1 = math.floor(arg0._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2 = math.floor(arg0._currentFleetVO:GetGearScoreSum(TeamType.Main))

	setActive(arg0._subGS.parent, var0 == FleetType.Submarine)

	local var3 = math.floor(arg0._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4 = arg0._currentFleetVO:GetCostSum()
	local var5 = arg0.contextData.system
	local var6 = pg.battle_cost_template[var5].oil_cost == 0 and 0 or var4.oil

	setActive(arg0._costContainer, var5 ~= SYSTEM_DUEL)
	var1.tweenNumText(arg0._costText, var6)
	var1.tweenNumText(arg0._vanguardGS, var1)
	var1.tweenNumText(arg0._mainGS, var2)
	var1.tweenNumText(arg0._subGS, var3)
	setText(arg0._fleetNameText, var1.defaultFleetName(arg0._currentFleetVO))
	setText(arg0._fleetNumText, arg0._currentFleetVO.id)
end

function var0.SetFleetStepper(arg0)
	if arg0.contextData.system == SYSTEM_DUEL or arg0._currentForm == var0.FORM_EDIT then
		SetActive(arg0._nextPage, false)
		SetActive(arg0._prevPage, false)
	else
		SetActive(arg0._nextPage, arg0._curFleetIndex < #arg0._legalFleetIdList)
		SetActive(arg0._prevPage, arg0._curFleetIndex > 1)
	end
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0._backBtn)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0._formationLogic:Destroy()

	arg0._formationLogic = nil
end

return var0
