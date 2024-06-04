local var0 = class("LimitChallengePreCombatLayer", import("view.base.BaseUI"))
local var1 = import("view.ship.FormationUI")
local var2 = {
	[99] = true
}

function var0.getUIName(arg0)
	return "LimitChallengePreCombatUI"
end

function var0.tempCache(arg0)
	return true
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
	arg0._fleetInfo = arg0._tf:Find("right/fleet_info")
	arg0._fleetNameText = arg0._fleetInfo:Find("fleet_name/Text")
	arg0._fleetNumText = arg0._fleetInfo:Find("fleet_number")

	setActive(arg0._fleetInfo, true)

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
	arg0._bottom = arg0:findTF("bottom")
	arg0.btnRegular = arg0:findTF("fleet_select/regular", arg0._bottom)
	arg0.btnSub = arg0:findTF("fleet_select/sub", arg0._bottom)

	setText(arg0.btnRegular:Find("fleet/CnFleet"), Fleet.DEFAULT_NAME[1])
	setText(arg0.btnSub:Find("fleet/CnFleet"), Fleet.DEFAULT_NAME[1])
	setAnchoredPosition(arg0._middle, {
		x = -840
	})
	setAnchoredPosition(arg0._right, {
		x = 470
	})
	arg0:SetStageID(arg0.contextData.stageId)

	arg0.commanderFormationPanel = LimitChallengeCommanderFormationPage.New(arg0._tf, arg0.event, arg0.contextData)
end

function var0.Register(arg0)
	arg0._formationLogic:AddLoadComplete(function()
		return
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

		setActive(var3, var2 and arg0.contextData.system ~= SYSTEM_DUEL)

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

		local var9 = var0:Find("expbuff")

		setActive(var9, false)
	end)
	arg0._formationLogic:AddLongPress(function(arg0, arg1, arg2, arg3)
		arg0:emit(LimitChallengePreCombatMediator.OPEN_SHIP_INFO, arg1.id, arg2)
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
		arg0:emit(LimitChallengePreCombatMediator.CHANGE_FLEET_SHIP, arg0, arg2, arg1)
	end)
	arg0._formationLogic:AddShiftOnly(function(arg0)
		arg0:emit(LimitChallengePreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0)
	end)
	arg0._formationLogic:AddRemoveShip(function(arg0, arg1)
		arg0:emit(LimitChallengePreCombatMediator.REMOVE_SHIP, arg0, arg1)
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
		return
	end)
	arg0._formationLogic:AddSwitchToShiftMode(function()
		arg0:SetFleetStepper()
	end)
	arg0._formationLogic:AddSwitchToPreviewMode(function()
		arg0:SetFleetStepper()
	end)
	arg0._formationLogic:AddGridTipClick(function(arg0, arg1)
		arg0:emit(LimitChallengePreCombatMediator.CHANGE_FLEET_SHIP, nil, arg0._currentFleetVO, arg0)
	end)
end

function var0.SetPlayerInfo(arg0, arg1)
	return
end

function var0.SetSubFlag(arg0, arg1)
	arg0._subUseable = arg1 or false

	arg0:UpdateSubToggle()
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
						hideName = true,
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

	local function var7(arg0, arg1)
		if type(arg0) == "table" then
			setActive(arg1, true)

			local var0 = i18n(PreCombatLayer.ObjectiveList[arg0[1]], arg0[2])

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
end

function var0.SetFleets(arg0, arg1)
	arg0._fleetVOs = {}
	arg0._legalFleetIdList = {}

	_.each(arg1, function(arg0)
		arg0._fleetVOs[arg0.id] = arg0

		table.insert(arg0._legalFleetIdList, arg0.id)
	end)
end

function var0.SetCurrentFleet(arg0, arg1)
	arg0._currentFleetVO = arg0._fleetVOs[arg1]

	arg0._formationLogic:SetFleetVO(arg0._currentFleetVO)

	for iter0, iter1 in ipairs(arg0._legalFleetIdList) do
		if arg0._currentFleetVO.id == iter1 then
			arg0._curFleetIndex = iter0

			break
		end
	end

	arg0:updateCommanderFormation()
end

function var0.SetOpenCommander(arg0, arg1)
	arg0.isOpenCommander = arg1
end

function var0.CheckLegalFleet(arg0)
	assert(false)
end

function var0.UpdateFleetView(arg0, arg1)
	arg0:displayFleetInfo()
	arg0:updateFleetBg()
	arg0._formationLogic:UpdateGridVisibility()
	arg0._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0._formationLogic:ResetGrid(TeamType.Main)
	arg0._formationLogic:ResetGrid(TeamType.Submarine)
	arg0:resetFormationComponent()

	if arg1 then
		arg0._formationLogic:LoadAllCharacter()
	else
		arg0._formationLogic:SetAllCharacterPos()
	end

	local var0 = arg0._currentFleetVO:getFleetType()

	setActive(arg0.btnRegular:Find("on"), var0 == FleetType.Normal)
	setActive(arg0.btnRegular:Find("off"), var0 ~= FleetType.Normal)
	setActive(arg0.btnSub:Find("on"), var0 == FleetType.Submarine)
	setActive(arg0.btnSub:Find("off"), var0 ~= FleetType.Submarine)
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

function var0.didEnter(arg0)
	onButton(arg0, arg0._backBtn, function()
		arg0:emit(LimitChallengePreCombatMediator.ON_UPDATE_CUSTOM_FLEET)

		GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

		arg0:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0:closeView()
		end))
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("blur_panel/top/option"), function()
		arg0:emit(LimitChallengePreCombatMediator.ON_UPDATE_CUSTOM_FLEET)
		arg0:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0, arg0._startBtn, function()
		arg0:emit(LimitChallengePreCombatMediator.ON_START)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0, arg0._nextPage, function()
		arg0:emit(LimitChallengePreCombatMediator.ON_CHANGE_FLEET, arg0._legalFleetIdList[arg0._curFleetIndex + 1])
	end, SFX_PANEL)
	onButton(arg0, arg0._prevPage, function()
		arg0:emit(LimitChallengePreCombatMediator.ON_CHANGE_FLEET, arg0._legalFleetIdList[arg0._curFleetIndex - 1])
	end, SFX_PANEL)
	arg0:UpdateFleetView(true)
	setActive(arg0._autoToggle, true)
	onToggle(arg0, arg0._autoToggle, function(arg0)
		arg0:emit(LimitChallengePreCombatMediator.ON_AUTO, {
			isOn = not arg0,
			toggle = arg0._autoToggle
		})

		arg0.autoFlag = arg0

		arg0:UpdateSubToggle()
	end, SFX_PANEL, SFX_PANEL)
	onToggle(arg0, arg0._autoSubToggle, function(arg0)
		arg0:emit(LimitChallengePreCombatMediator.ON_SUB_AUTO, {
			isOn = not arg0,
			toggle = arg0._autoSubToggle
		})
	end, SFX_PANEL, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("bottom/fleet_select/regular"), function()
		arg0:emit(LimitChallengePreCombatMediator.ON_CHANGE_FLEET, FleetProxy.CHALLENGE_FLEET_ID)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("bottom/fleet_select/sub"), function()
		arg0:emit(LimitChallengePreCombatMediator.ON_CHANGE_FLEET, FleetProxy.CHALLENGE_SUB_FLEET_ID)
	end, SFX_PANEL)

	if arg0.isOpenCommander then
		arg0.commanderFormationPanel:ActionInvoke("Show")
	end

	triggerToggle(arg0._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	onNextTick(function()
		arg0:uiStartAnimating()
	end)
	arg0:SetFleetStepper()
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = LayerWeightConst.GROUP_FORMATION_PAGE
	})
end

function var0.UpdateSubToggle(arg0)
	if arg0.autoFlag and arg0._subUseable == true then
		setActive(arg0._autoSubToggle, true)
		triggerToggle(arg0._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
	else
		setActive(arg0._autoSubToggle, false)
	end
end

function var0.displayFleetInfo(arg0)
	local var0 = arg0._currentFleetVO:getFleetType()

	setActive(arg0._vanguardGS.parent, var0 == FleetType.Normal)
	setActive(arg0._mainGS.parent, var0 == FleetType.Normal)

	local var1 = math.floor(arg0._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2 = math.floor(arg0._currentFleetVO:GetGearScoreSum(TeamType.Main))

	setActive(arg0._subGS.parent, var0 == FleetType.Submarine)

	local var3 = math.floor(arg0._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4 = arg0.contextData.system

	setActive(arg0._costContainer, var4 ~= SYSTEM_DUEL)
	var1.tweenNumText(arg0._vanguardGS, var1)
	var1.tweenNumText(arg0._mainGS, var2)
	var1.tweenNumText(arg0._subGS, var3)
	setText(arg0._fleetNameText, arg0._currentFleetVO:GetName())
	setText(arg0._fleetNumText, arg0._curFleetIndex)

	local var5 = arg0.contextData.fleets
	local var6 = var5[#var5]
	local var7 = _.slice(var5, 1, #var5 - 1)
	local var8 = (function()
		local var0 = 0
		local var1 = pg.battle_cost_template[var4].oil_cost > 0

		local function var2(arg0, arg1)
			local var0 = 0

			if var1 then
				var0 = arg0:GetCostSum().oil

				if arg1 > 0 then
					var0 = math.min(arg1, var0)
				end
			end

			return var0
		end

		return var0 + var2(var7[1], 0) + var2(var6, 0)
	end)()

	var1.tweenNumText(arg0._costText, var8)
end

function var0.SetFleetStepper(arg0)
	SetActive(arg0._nextPage, arg0._curFleetIndex < #arg0._legalFleetIdList)
	SetActive(arg0._prevPage, arg0._curFleetIndex > 1)
end

function var0.updateCommanderFormation(arg0)
	if arg0.isOpenCommander then
		arg0.commanderFormationPanel:Load()
		arg0.commanderFormationPanel:ActionInvoke("Update", arg0._currentFleetVO)
	end
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0._backBtn)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	arg0.commanderFormationPanel:Destroy()
	arg0._formationLogic:Destroy()

	arg0._formationLogic = nil
end

return var0
