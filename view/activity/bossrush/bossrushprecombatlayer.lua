local var0_0 = class("BossRushPreCombatLayer", import("view.base.BaseUI"))
local var1_0 = import("view.ship.FormationUI")
local var2_0 = {
	[99] = true
}

function var0_0.getUIName(arg0_1)
	return "BossRushPreCombatUI"
end

function var0_0.ResUISettings(arg0_2)
	return true
end

function var0_0.tempCache(arg0_3)
	return true
end

function var0_0.init(arg0_4)
	arg0_4:CommonInit()

	arg0_4._formationLogic = BaseFormation.New(arg0_4._tf, arg0_4._heroContainer, arg0_4._heroInfo, arg0_4._gridTFs)

	arg0_4:Register()
end

function var0_0.CommonInit(arg0_5)
	arg0_5.eventTriggers = {}
	arg0_5._startBtn = arg0_5:findTF("right/start")
	arg0_5._costContainer = arg0_5:findTF("right/start/cost_container")
	arg0_5._popup = arg0_5._costContainer:Find("popup")
	arg0_5._costText = arg0_5._popup:Find("Text")
	arg0_5._moveLayer = arg0_5:findTF("moveLayer")

	local var0_5 = arg0_5:findTF("middle")

	arg0_5._autoToggle = arg0_5:findTF("auto_toggle")
	arg0_5._autoSubToggle = arg0_5:findTF("sub_toggle_container/sub_toggle")
	arg0_5._fleetInfo = var0_5:Find("fleet_info")
	arg0_5._fleetNameText = var0_5:Find("fleet_info/fleet_name/Text")
	arg0_5._fleetNumText = var0_5:Find("fleet_info/fleet_number")

	setActive(arg0_5._fleetInfo, arg0_5.contextData.system ~= SYSTEM_DUEL)

	arg0_5._mainGS = var0_5:Find("gear_score/main/Text")
	arg0_5._vanguardGS = var0_5:Find("gear_score/vanguard/Text")
	arg0_5._subGS = var0_5:Find("gear_score/submarine/Text")
	arg0_5._bgFleet = var0_5:Find("mask/grid_bg")
	arg0_5._bgSub = var0_5:Find("mask/bg_sub")
	arg0_5._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0_5._gridFrame = var0_5:Find("mask/GridFrame")

	for iter0_5 = 1, 3 do
		arg0_5._gridTFs[TeamType.Main][iter0_5] = arg0_5._gridFrame:Find("main_" .. iter0_5)
		arg0_5._gridTFs[TeamType.Vanguard][iter0_5] = arg0_5._gridFrame:Find("vanguard_" .. iter0_5)
		arg0_5._gridTFs[TeamType.Submarine][iter0_5] = arg0_5._gridFrame:Find("submarine_" .. iter0_5)
	end

	arg0_5._nextPage = arg0_5:findTF("middle/nextPage")
	arg0_5._prevPage = arg0_5:findTF("middle/prevPage")
	arg0_5._heroContainer = var0_5:Find("HeroContainer")
	arg0_5._checkBtn = var0_5:Find("checkBtn")
	arg0_5._blurPanel = arg0_5:findTF("blur_panel")
	arg0_5.topPanel = arg0_5:findTF("top", arg0_5._blurPanel)
	arg0_5.topPanelBg = arg0_5:findTF("top_bg", arg0_5._blurPanel)
	arg0_5._backBtn = arg0_5:findTF("back_btn", arg0_5.topPanel)
	arg0_5._spoilsContainer = arg0_5:findTF("right/infomation/atlasloot/spoils/items/items_container")
	arg0_5._item = arg0_5:findTF("right/infomation/atlasloot/spoils/items/item_tpl")

	SetActive(arg0_5._item, false)

	arg0_5._goals = arg0_5:findTF("right/infomation/target/goal")
	arg0_5._heroInfo = arg0_5:getTpl("heroInfo")
	arg0_5._starTpl = arg0_5:getTpl("star_tpl")

	setText(findTF(arg0_5._tf, "middle/gear_score/vanguard/line/Image/Text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0_5._tf, "middle/gear_score/main/line/Image/Text1"), i18n("pre_combat_main"))
	setText(findTF(arg0_5._tf, "middle/gear_score/submarine/line/Image/text1"), i18n("pre_combat_submarine"))
	setText(arg0_5._costContainer:Find("title"), i18n("pre_combat_consume"))
	setText(findTF(arg0_5._tf, "right/infomation/target/title/GameObject"), i18n("pre_combat_targets"))
	setText(findTF(arg0_5._tf, "right/infomation/atlasloot/atlasloot/title/GameObject"), i18n("pre_combat_atlasloot"))
	setText(arg0_5._startBtn:Find("text"), i18n("pre_combat_start"))
	setText(arg0_5._startBtn:Find("text_en"), i18n("pre_combat_start_en"))

	arg0_5._middle = arg0_5:findTF("middle")
	arg0_5._right = arg0_5:findTF("right")

	setAnchoredPosition(arg0_5._middle, {
		x = -840
	})
	setAnchoredPosition(arg0_5._right, {
		x = 470
	})

	arg0_5.guideDesc = arg0_5:findTF("guideDesc", arg0_5._middle)
	arg0_5._costTip = arg0_5._startBtn:Find("cost_container/popup/tip")
	arg0_5._continuousBtn = arg0_5:findTF("right/multiple")

	setText(arg0_5._continuousBtn:Find("text"), i18n("multiple_sorties_title"))
	setText(arg0_5._continuousBtn:Find("text_en"), i18n("multiple_sorties_title_eng"))
end

function var0_0.Register(arg0_6)
	arg0_6._formationLogic:AddLoadComplete(function()
		return
	end)
	arg0_6._formationLogic:AddHeroInfoModify(function(arg0_8, arg1_8)
		setAnchoredPosition(arg0_8, {
			x = 0,
			y = 0
		})
		SetActive(arg0_8, true)

		arg0_8.name = "info"

		local var0_8 = findTF(arg0_8, "info")
		local var1_8 = findTF(var0_8, "stars")
		local var2_8 = arg1_8.energy <= Ship.ENERGY_MID
		local var3_8 = findTF(var0_8, "energy")

		if var2_8 then
			local var4_8, var5_8 = arg1_8:getEnergyPrint()
			local var6_8 = GetSpriteFromAtlas("energy", var4_8)

			if not var6_8 then
				warning("找不到疲劳")
			end

			setImageSprite(var3_8, var6_8)
		end

		setActive(var3_8, var2_8 and arg0_6.contextData.system ~= SYSTEM_DUEL)

		local var7_8 = arg1_8:getStar()

		for iter0_8 = 1, var7_8 do
			cloneTplTo(arg0_6._starTpl, var1_8)
		end

		local var8_8 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_8:getShipType()))

		if not var8_8 then
			warning("找不到船形, shipConfigId: " .. arg1_8.configId)
		end

		setImageSprite(findTF(var0_8, "type"), var8_8, true)
		setText(findTF(var0_8, "frame/lv_contain/lv"), arg1_8.level)

		local var9_8 = var0_8:Find("expbuff")

		setActive(var9_8, false)
	end)
	arg0_6._formationLogic:AddLongPress(function(arg0_9, arg1_9, arg2_9, arg3_9)
		arg0_6:emit(BossRushPreCombatMediator.OPEN_SHIP_INFO, arg1_9.id, arg2_9)
	end)
	arg0_6._formationLogic:AddBeginDrag(function(arg0_10)
		local var0_10 = findTF(arg0_10, "info")

		SetActive(var0_10, false)
	end)
	arg0_6._formationLogic:AddEndDrag(function(arg0_11)
		local var0_11 = findTF(arg0_11, "info")

		SetActive(var0_11, true)
	end)
	arg0_6._formationLogic:AddClick(function(arg0_12, arg1_12, arg2_12)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)
		arg0_6:emit(BossRushPreCombatMediator.CHANGE_FLEET_SHIP, arg0_12, arg2_12, arg1_12)
	end)
	arg0_6._formationLogic:AddShiftOnly(function(arg0_13)
		arg0_6:emit(BossRushPreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_13)
	end)
	arg0_6._formationLogic:AddRemoveShip(function(arg0_14, arg1_14)
		arg0_6:emit(BossRushPreCombatMediator.REMOVE_SHIP, arg0_14, arg1_14)
	end)
	arg0_6._formationLogic:AddCheckRemove(function(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
		if not arg3_15:canRemove(arg2_15) then
			local var0_15, var1_15 = arg3_15:getShipPos(arg2_15)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2_15:getConfigTable().name, arg3_15.name or "", Fleet.C_TEAM_NAME[var1_15]))
			arg0_15()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				zIndex = -100,
				hideNo = false,
				content = i18n("battle_preCombatLayer_quest_leaveFleet", arg2_15:getConfigTable().name),
				onYes = arg1_15,
				onNo = arg0_15
			})
		end
	end)
	arg0_6._formationLogic:AddSwitchToDisplayMode(function()
		arg0_6:SetFleetStepper()
	end)
	arg0_6._formationLogic:AddSwitchToShiftMode(function()
		arg0_6:SetFleetStepper()
	end)
	arg0_6._formationLogic:AddSwitchToPreviewMode(function()
		arg0_6:SetFleetStepper()
	end)
	arg0_6._formationLogic:AddGridTipClick(function(arg0_19, arg1_19)
		arg0_6:emit(BossRushPreCombatMediator.CHANGE_FLEET_SHIP, nil, arg0_6._currentFleetVO, arg0_19)
	end)
end

function var0_0.SetPlayerInfo(arg0_20, arg1_20)
	return
end

function var0_0.SetSubFlag(arg0_21, arg1_21)
	arg0_21._subUseable = arg1_21 or false

	arg0_21:UpdateSubToggle()
end

function var0_0.SetShips(arg0_22, arg1_22)
	arg0_22._shipVOs = arg1_22

	arg0_22._formationLogic:SetShipVOs(arg0_22._shipVOs)
end

function var0_0.SetStageIds(arg0_23, arg1_23)
	removeAllChildren(arg0_23._spoilsContainer)

	local var0_23 = {}

	table.Foreach(arg1_23, function(arg0_24, arg1_24)
		local var0_24 = pg.expedition_data_template[arg1_24]
		local var1_24 = Clone(var0_24.award_display)
		local var2_24 = checkExist(pg.expedition_activity_template[arg1_24], {
			"pt_drop_display"
		})

		if var2_24 and type(var2_24) == "table" then
			local var3_24 = getProxy(ActivityProxy)

			for iter0_24 = #var2_24, 1, -1 do
				local var4_24 = var3_24:getActivityById(var2_24[iter0_24][1])

				if var4_24 and not var4_24:isEnd() then
					table.insert(var1_24, 1, {
						2,
						id2ItemId(var2_24[iter0_24][2])
					})
				end
			end
		end

		table.insertto(var0_23, var1_24)

		if arg0_24 > 1 then
			return
		end

		local function var5_24(arg0_25, arg1_25)
			if type(arg0_25) == "table" then
				setActive(arg1_25, true)

				local var0_25 = i18n(PreCombatLayer.ObjectiveList[arg0_25[1]], arg0_25[2])

				setWidgetText(arg1_25, var0_25)
			else
				setActive(arg1_25, false)
			end
		end

		local var6_24 = {
			findTF(arg0_23._goals, "goal_tpl"),
			findTF(arg0_23._goals, "goal_sink"),
			findTF(arg0_23._goals, "goal_time")
		}
		local var7_24 = {
			var0_24.objective_1,
			var0_24.objective_2,
			var0_24.objective_3
		}
		local var8_24 = 1

		for iter1_24, iter2_24 in ipairs(var7_24) do
			if type(iter2_24) ~= "string" then
				var5_24(iter2_24, var6_24[var8_24])

				var8_24 = var8_24 + 1
			end
		end

		for iter3_24 = var8_24, #var6_24 do
			var5_24("", var6_24[iter3_24])
		end
	end)

	local var1_23 = {}

	for iter0_23, iter1_23 in ipairs(var0_23) do
		if (function()
			for iter0_26, iter1_26 in ipairs(var1_23) do
				if iter1_23[1] == iter1_26[1] and iter1_23[2] == iter1_26[2] then
					return false
				end
			end

			return true
		end)() then
			table.insert(var1_23, iter1_23)
		end
	end

	var0_23 = var1_23

	for iter2_23, iter3_23 in ipairs(var0_23) do
		local var2_23 = cloneTplTo(arg0_23._item, arg0_23._spoilsContainer)
		local var3_23 = {
			id = iter3_23[2],
			type = iter3_23[1]
		}

		updateDrop(var2_23, var3_23)
		onButton(arg0_23, var2_23, function()
			local var0_27 = Item.getConfigData(iter3_23[2])

			if var0_27 and var2_0[var0_27.type] then
				local var1_27 = var0_27.display_icon
				local var2_27 = {}

				for iter0_27, iter1_27 in ipairs(var1_27) do
					local var3_27 = iter1_27[1]
					local var4_27 = iter1_27[2]

					var2_27[#var2_27 + 1] = {
						hideName = true,
						type = var3_27,
						id = var4_27
					}
				end

				arg0_23:emit(var0_0.ON_DROP_LIST, {
					item2Row = true,
					itemList = var2_27,
					content = var0_27.display
				})
			else
				arg0_23:emit(var0_0.ON_DROP, var3_23)
			end
		end, SFX_PANEL)
	end
end

function var0_0.SetFleets(arg0_28, arg1_28)
	arg0_28._fleetVOs = {}
	arg0_28._legalFleetIdList = {}

	_.each(arg1_28, function(arg0_29)
		arg0_28._fleetVOs[arg0_29.id] = arg0_29

		table.insert(arg0_28._legalFleetIdList, arg0_29.id)
	end)
end

function var0_0.SetCurrentFleet(arg0_30, arg1_30)
	arg0_30._currentFleetVO = arg0_30._fleetVOs[arg1_30]

	arg0_30._formationLogic:SetFleetVO(arg0_30._currentFleetVO)

	for iter0_30, iter1_30 in ipairs(arg0_30._legalFleetIdList) do
		if arg0_30._currentFleetVO.id == iter1_30 then
			arg0_30._curFleetIndex = iter0_30

			break
		end
	end
end

function var0_0.CheckLegalFleet(arg0_31)
	assert(false)
end

function var0_0.UpdateFleetView(arg0_32, arg1_32)
	arg0_32:displayFleetInfo()
	arg0_32:updateFleetBg()
	arg0_32._formationLogic:UpdateGridVisibility()
	arg0_32._formationLogic:ResetGrid(TeamType.Vanguard, false)
	arg0_32._formationLogic:ResetGrid(TeamType.Main, false)
	arg0_32._formationLogic:ResetGrid(TeamType.Submarine, false)
	arg0_32:resetFormationComponent()

	if arg1_32 then
		arg0_32._formationLogic:LoadAllCharacter()
	else
		arg0_32._formationLogic:SetAllCharacterPos()
	end
end

function var0_0.updateFleetBg(arg0_33)
	local var0_33 = arg0_33._currentFleetVO:getFleetType()

	setActive(arg0_33._bgFleet, var0_33 == FleetType.Normal)
	setActive(arg0_33._bgSub, var0_33 == FleetType.Submarine)
end

function var0_0.resetFormationComponent(arg0_34)
	SetActive(arg0_34._gridTFs.main[1]:Find("flag"), #arg0_34._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
	SetActive(arg0_34._gridTFs.submarine[1]:Find("flag"), #arg0_34._currentFleetVO:getTeamByName(TeamType.Submarine) ~= 0)
end

function var0_0.uiStartAnimating(arg0_35)
	local var0_35 = 0
	local var1_35 = 0.3

	shiftPanel(arg0_35._middle, 0, nil, var1_35, var0_35, true, true)
	shiftPanel(arg0_35._right, 0, nil, var1_35, var0_35, true, true)
end

function var0_0.uiExitAnimating(arg0_36)
	shiftPanel(arg0_36._middle, -840, nil, nil, nil, true, true)
	shiftPanel(arg0_36._right, 470, nil, nil, nil, true, true)
end

function var0_0.didEnter(arg0_37)
	onButton(arg0_37, arg0_37._backBtn, function()
		GetOrAddComponent(arg0_37._tf, typeof(CanvasGroup)).interactable = false

		arg0_37:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0_37:emit(var0_0.ON_CLOSE)
		end))
		arg0_37:emit(BossRushPreCombatMediator.ON_UPDATE_CUSTOM_FLEET)
	end, SFX_CANCEL)
	onButton(arg0_37, arg0_37._tf:Find("blur_panel/top/option"), function()
		arg0_37:quickExitFunc()
		arg0_37:emit(BossRushPreCombatMediator.ON_UPDATE_CUSTOM_FLEET)
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37._startBtn, function()
		arg0_37:emit(BossRushPreCombatMediator.ON_START)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_37, arg0_37._nextPage, function()
		arg0_37:emit(BossRushPreCombatMediator.ON_CHANGE_FLEET, arg0_37._legalFleetIdList[arg0_37._curFleetIndex + 1])
	end, SFX_PANEL)
	onButton(arg0_37, arg0_37._prevPage, function()
		arg0_37:emit(BossRushPreCombatMediator.ON_CHANGE_FLEET, arg0_37._legalFleetIdList[arg0_37._curFleetIndex - 1])
	end, SFX_PANEL)
	arg0_37:UpdateFleetView(true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_37._tf)
	setActive(arg0_37._autoToggle, true)
	onToggle(arg0_37, arg0_37._autoToggle, function(arg0_44)
		arg0_37:emit(BossRushPreCombatMediator.ON_AUTO, {
			isOn = not arg0_44,
			toggle = arg0_37._autoToggle
		})

		arg0_37.autoFlag = arg0_44

		arg0_37:UpdateSubToggle()
	end, SFX_PANEL, SFX_PANEL)
	onToggle(arg0_37, arg0_37._autoSubToggle, function(arg0_45)
		arg0_37:emit(BossRushPreCombatMediator.ON_SUB_AUTO, {
			isOn = not arg0_45,
			toggle = arg0_37._autoSubToggle
		})
	end, SFX_PANEL, SFX_PANEL)
	triggerToggle(arg0_37._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	onNextTick(function()
		arg0_37:uiStartAnimating()
	end)

	local var0_37 = getProxy(ActivityProxy):getActivityById(arg0_37.contextData.actId)
	local var1_37 = arg0_37.contextData.seriesData

	;(function()
		local var0_47 = var1_37:GetType() == BossRushSeriesData.TYPE.NORMAL

		setActive(arg0_37._continuousBtn, var0_47)

		if not var0_47 then
			return
		end

		local var1_47 = var0_37:HasPassSeries(var1_37.id)

		setActive(arg0_37._continuousBtn:Find("lock"), not var1_47)

		local var2_47 = var1_47 and Color.white or Color.New(0.298039215686275, 0.298039215686275, 0.298039215686275)

		setImageColor(arg0_37._continuousBtn, var2_47)
		setTextColor(arg0_37._continuousBtn:Find("text"), var2_47)
		setTextColor(arg0_37._continuousBtn:Find("text_en"), var2_47)
		onButton(arg0_37, arg0_37._continuousBtn, function()
			if var1_47 then
				arg0_37:emit(BossRushPreCombatMediator.SHOW_CONTINUOUS_OPERATION_WINDOW, arg0_37._currentFleetVO.id)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_locked_tip"))
			end
		end, SFX_PANEL)
	end)()

	local var2_37 = var1_37:GetExpeditionIds()
	local var3_37 = var1_37:GetBossIcons()
	local var4_37 = arg0_37._tf:Find("middle/Boss")

	UIItemList.StaticAlign(var4_37, var4_37:GetChild(0), #var2_37, function(arg0_49, arg1_49, arg2_49)
		if arg0_49 ~= UIItemList.EventUpdate then
			return
		end

		local var0_49 = var2_37[arg1_49 + 1]
		local var1_49 = var3_37[arg1_49 + 1][1]
		local var2_49 = pg.expedition_data_template[var0_49].level
		local var3_49 = arg2_49:Find("shiptpl")
		local var4_49 = findTF(var3_49, "icon_bg")
		local var5_49 = findTF(var3_49, "icon_bg/frame")

		SetCompomentEnabled(var4_49, "Image", false)
		SetCompomentEnabled(var5_49, "Image", false)
		setActive(arg2_49:Find("shiptpl/icon_bg/lv"), false)

		local var6_49 = arg2_49:Find("shiptpl/icon_bg/icon")

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1_49, "", var6_49)

		local var7_49 = findTF(var3_49, "ship_type")

		if var7_49 then
			setActive(var7_49, true)
			setImageSprite(var7_49, GetSpriteFromAtlas("shiptype", shipType2print(var3_37[arg1_49 + 1][2])))
		end
	end)
	arg0_37:SetFleetStepper()
	arg0_37:SetStageIds(arg0_37.contextData.stageIds)
end

function var0_0.UpdateSubToggle(arg0_50)
	if arg0_50.autoFlag and arg0_50._subUseable == true then
		setActive(arg0_50._autoSubToggle, true)
		triggerToggle(arg0_50._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
	else
		setActive(arg0_50._autoSubToggle, false)
	end
end

function var0_0.displayFleetInfo(arg0_51)
	local var0_51 = arg0_51._currentFleetVO:getFleetType()

	setActive(arg0_51._vanguardGS.parent, var0_51 == FleetType.Normal)
	setActive(arg0_51._mainGS.parent, var0_51 == FleetType.Normal)

	local var1_51 = math.floor(arg0_51._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2_51 = math.floor(arg0_51._currentFleetVO:GetGearScoreSum(TeamType.Main))

	setActive(arg0_51._subGS.parent, var0_51 == FleetType.Submarine)

	local var3_51 = math.floor(arg0_51._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4_51 = arg0_51.contextData.system

	setActive(arg0_51._costContainer, var4_51 ~= SYSTEM_DUEL)
	var1_0.tweenNumText(arg0_51._vanguardGS, var1_51)
	var1_0.tweenNumText(arg0_51._mainGS, var2_51)
	var1_0.tweenNumText(arg0_51._subGS, var3_51)
	setText(arg0_51._fleetNameText, Fleet.DEFAULT_NAME[arg0_51._curFleetIndex])
	setText(arg0_51._fleetNumText, arg0_51._curFleetIndex)

	local var5_51 = arg0_51.contextData.seriesData
	local var6_51 = var5_51:GetExpeditionIds()
	local var7_51 = arg0_51._tf:Find("middle/Boss")

	UIItemList.StaticAlign(var7_51, var7_51:GetChild(0), #var6_51, function(arg0_52, arg1_52, arg2_52)
		if arg0_52 ~= UIItemList.EventUpdate then
			return
		end

		local var0_52 = arg1_52 + 1 == arg0_51._curFleetIndex or arg0_51._curFleetIndex > #var6_51 or arg0_51.contextData.mode == BossRushSeriesData.MODE.SINGLE

		setActive(arg2_52:Find("Select"), var0_52)
		setActive(arg2_52:Find("Image"), var0_52)
	end)

	local var8_51 = arg0_51.contextData.fleets
	local var9_51 = var8_51[#var8_51]
	local var10_51 = _.slice(var8_51, 1, #var8_51 - 1)
	local var11_51 = arg0_51.contextData.mode
	local var12_51 = false
	local var13_51 = (function()
		local var0_53 = 0
		local var1_53 = pg.battle_cost_template[var4_51]
		local var2_53 = var5_51:GetOilLimit()
		local var3_53 = var1_53.oil_cost > 0

		local function var4_53(arg0_54, arg1_54)
			local var0_54 = 0

			if var3_53 then
				var0_54 = arg0_54:GetCostSum().oil

				if arg1_54 > 0 then
					var0_54 = math.min(arg1_54, var0_54)
					var12_51 = var12_51 and var0_54 < arg1_54
				end
			end

			return var0_54
		end

		local var5_53 = #var5_51:GetExpeditionIds()

		if var11_51 == BossRushSeriesData.MODE.SINGLE then
			var0_53 = var0_53 + var4_53(var10_51[1], var2_53[1])
			var0_53 = var0_53 + var4_53(var9_51, var2_53[2])
			var0_53 = var0_53 * var5_53
		else
			var0_53 = var4_53(var9_51, var2_53[2]) * var5_53

			_.each(var10_51, function(arg0_55)
				var0_53 = var0_53 + var4_53(arg0_55, var2_53[1])
			end)
		end

		return var0_53
	end)()

	local function var14_51()
		local var0_56 = 0
		local var1_56 = pg.battle_cost_template[var4_51]
		local var2_56 = var5_51:GetOilLimit()
		local var3_56 = var1_56.oil_cost > 0

		local function var4_56(arg0_57, arg1_57)
			local var0_57 = 0

			if var3_56 then
				var0_57 = arg0_57:GetCostSum().oil
			end

			return var0_57
		end

		local var5_56 = #var5_51:GetExpeditionIds()

		if var11_51 == BossRushSeriesData.MODE.SINGLE then
			var0_56 = var0_56 + var4_56(var10_51[1], var2_56[1])
			var0_56 = var0_56 + var4_56(var9_51, var2_56[2])
			var0_56 = var0_56 * var5_56
		else
			var0_56 = var4_56(var9_51, var2_56[2]) * var5_56

			_.each(var10_51, function(arg0_58)
				var0_56 = var0_56 + var4_56(arg0_58, var2_56[1])
			end)
		end

		return var0_56
	end

	local var15_51 = 0

	if var12_51 then
		var15_51 = var14_51()
	end

	var1_0.tweenNumText(arg0_51._costText, var13_51)
	setActive(arg0_51._costTip, var12_51)

	if var12_51 then
		onButton(arg0_51, arg0_51._costTip, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("use_oil_limit_help", var15_51, var13_51),
				weight = LayerWeightConst.SECOND_LAYER
			})
		end)
	end
end

function var0_0.SetFleetStepper(arg0_60)
	SetActive(arg0_60._nextPage, arg0_60._curFleetIndex < #arg0_60._legalFleetIdList)
	SetActive(arg0_60._prevPage, arg0_60._curFleetIndex > 1)
end

function var0_0.onBackPressed(arg0_61)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_61._backBtn)
end

function var0_0.willExit(arg0_62)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_62._tf)
	arg0_62._formationLogic:Destroy()

	arg0_62._formationLogic = nil
end

return var0_0
