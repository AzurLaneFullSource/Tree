local var0 = class("BossRushPreCombatLayer", import("view.base.BaseUI"))
local var1 = import("view.ship.FormationUI")
local var2 = {
	[99] = true
}

function var0.getUIName(arg0)
	return "BossRushPreCombatUI"
end

function var0.ResUISettings(arg0)
	return true
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
	arg0._costTip = arg0._startBtn:Find("cost_container/popup/tip")
	arg0._continuousBtn = arg0:findTF("right/multiple")

	setText(arg0._continuousBtn:Find("text"), i18n("multiple_sorties_title"))
	setText(arg0._continuousBtn:Find("text_en"), i18n("multiple_sorties_title_eng"))
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
		arg0:emit(BossRushPreCombatMediator.OPEN_SHIP_INFO, arg1.id, arg2)
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
		arg0:emit(BossRushPreCombatMediator.CHANGE_FLEET_SHIP, arg0, arg2, arg1)
	end)
	arg0._formationLogic:AddShiftOnly(function(arg0)
		arg0:emit(BossRushPreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0)
	end)
	arg0._formationLogic:AddRemoveShip(function(arg0, arg1)
		arg0:emit(BossRushPreCombatMediator.REMOVE_SHIP, arg0, arg1)
	end)
	arg0._formationLogic:AddCheckRemove(function(arg0, arg1, arg2, arg3, arg4)
		if not arg3:canRemove(arg2) then
			local var0, var1 = arg3:getShipPos(arg2)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2:getConfigTable().name, arg3.name or "", Fleet.C_TEAM_NAME[var1]))
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
		arg0:SetFleetStepper()
	end)
	arg0._formationLogic:AddSwitchToShiftMode(function()
		arg0:SetFleetStepper()
	end)
	arg0._formationLogic:AddSwitchToPreviewMode(function()
		arg0:SetFleetStepper()
	end)
	arg0._formationLogic:AddGridTipClick(function(arg0, arg1)
		arg0:emit(BossRushPreCombatMediator.CHANGE_FLEET_SHIP, nil, arg0._currentFleetVO, arg0)
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

function var0.SetStageIds(arg0, arg1)
	removeAllChildren(arg0._spoilsContainer)

	local var0 = {}

	table.Foreach(arg1, function(arg0, arg1)
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

		table.insertto(var0, var1)

		if arg0 > 1 then
			return
		end

		local function var5(arg0, arg1)
			if type(arg0) == "table" then
				setActive(arg1, true)

				local var0 = i18n(PreCombatLayer.ObjectiveList[arg0[1]], arg0[2])

				setWidgetText(arg1, var0)
			else
				setActive(arg1, false)
			end
		end

		local var6 = {
			findTF(arg0._goals, "goal_tpl"),
			findTF(arg0._goals, "goal_sink"),
			findTF(arg0._goals, "goal_time")
		}
		local var7 = {
			var0.objective_1,
			var0.objective_2,
			var0.objective_3
		}
		local var8 = 1

		for iter1, iter2 in ipairs(var7) do
			if type(iter2) ~= "string" then
				var5(iter2, var6[var8])

				var8 = var8 + 1
			end
		end

		for iter3 = var8, #var6 do
			var5("", var6[iter3])
		end
	end)

	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		if (function()
			for iter0, iter1 in ipairs(var1) do
				if iter1[1] == iter1[1] and iter1[2] == iter1[2] then
					return false
				end
			end

			return true
		end)() then
			table.insert(var1, iter1)
		end
	end

	var0 = var1

	for iter2, iter3 in ipairs(var0) do
		local var2 = cloneTplTo(arg0._item, arg0._spoilsContainer)
		local var3 = {
			id = iter3[2],
			type = iter3[1]
		}

		updateDrop(var2, var3)
		onButton(arg0, var2, function()
			local var0 = Item.getConfigData(iter3[2])

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
				arg0:emit(var0.ON_DROP, var3)
			end
		end, SFX_PANEL)
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
end

function var0.CheckLegalFleet(arg0)
	assert(false)
end

function var0.UpdateFleetView(arg0, arg1)
	arg0:displayFleetInfo()
	arg0:updateFleetBg()
	arg0._formationLogic:UpdateGridVisibility()
	arg0._formationLogic:ResetGrid(TeamType.Vanguard, false)
	arg0._formationLogic:ResetGrid(TeamType.Main, false)
	arg0._formationLogic:ResetGrid(TeamType.Submarine, false)
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

function var0.didEnter(arg0)
	onButton(arg0, arg0._backBtn, function()
		GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

		arg0:uiExitAnimating()
		LeanTween.delayedCall(0.3, System.Action(function()
			arg0:emit(var0.ON_CLOSE)
		end))
		arg0:emit(BossRushPreCombatMediator.ON_UPDATE_CUSTOM_FLEET)
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("blur_panel/top/option"), function()
		arg0:quickExitFunc()
		arg0:emit(BossRushPreCombatMediator.ON_UPDATE_CUSTOM_FLEET)
	end, SFX_PANEL)
	onButton(arg0, arg0._startBtn, function()
		arg0:emit(BossRushPreCombatMediator.ON_START)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0, arg0._nextPage, function()
		arg0:emit(BossRushPreCombatMediator.ON_CHANGE_FLEET, arg0._legalFleetIdList[arg0._curFleetIndex + 1])
	end, SFX_PANEL)
	onButton(arg0, arg0._prevPage, function()
		arg0:emit(BossRushPreCombatMediator.ON_CHANGE_FLEET, arg0._legalFleetIdList[arg0._curFleetIndex - 1])
	end, SFX_PANEL)
	arg0:UpdateFleetView(true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._autoToggle, true)
	onToggle(arg0, arg0._autoToggle, function(arg0)
		arg0:emit(BossRushPreCombatMediator.ON_AUTO, {
			isOn = not arg0,
			toggle = arg0._autoToggle
		})

		arg0.autoFlag = arg0

		arg0:UpdateSubToggle()
	end, SFX_PANEL, SFX_PANEL)
	onToggle(arg0, arg0._autoSubToggle, function(arg0)
		arg0:emit(BossRushPreCombatMediator.ON_SUB_AUTO, {
			isOn = not arg0,
			toggle = arg0._autoSubToggle
		})
	end, SFX_PANEL, SFX_PANEL)
	triggerToggle(arg0._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	onNextTick(function()
		arg0:uiStartAnimating()
	end)

	local var0 = getProxy(ActivityProxy):getActivityById(arg0.contextData.actId)
	local var1 = arg0.contextData.seriesData

	;(function()
		local var0 = var1:GetType() == BossRushSeriesData.TYPE.NORMAL

		setActive(arg0._continuousBtn, var0)

		if not var0 then
			return
		end

		local var1 = var0:HasPassSeries(var1.id)

		setActive(arg0._continuousBtn:Find("lock"), not var1)

		local var2 = var1 and Color.white or Color.New(0.298039215686275, 0.298039215686275, 0.298039215686275)

		setImageColor(arg0._continuousBtn, var2)
		setTextColor(arg0._continuousBtn:Find("text"), var2)
		setTextColor(arg0._continuousBtn:Find("text_en"), var2)
		onButton(arg0, arg0._continuousBtn, function()
			if var1 then
				arg0:emit(BossRushPreCombatMediator.SHOW_CONTINUOUS_OPERATION_WINDOW, arg0._currentFleetVO.id)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_locked_tip"))
			end
		end, SFX_PANEL)
	end)()

	local var2 = var1:GetExpeditionIds()
	local var3 = var1:GetBossIcons()
	local var4 = arg0._tf:Find("middle/Boss")

	UIItemList.StaticAlign(var4, var4:GetChild(0), #var2, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var2[arg1 + 1]
		local var1 = var3[arg1 + 1][1]
		local var2 = pg.expedition_data_template[var0].level
		local var3 = arg2:Find("shiptpl")
		local var4 = findTF(var3, "icon_bg")
		local var5 = findTF(var3, "icon_bg/frame")

		SetCompomentEnabled(var4, "Image", false)
		SetCompomentEnabled(var5, "Image", false)
		setActive(arg2:Find("shiptpl/icon_bg/lv"), false)

		local var6 = arg2:Find("shiptpl/icon_bg/icon")

		GetImageSpriteFromAtlasAsync("SquareIcon/" .. var1, "", var6)

		local var7 = findTF(var3, "ship_type")

		if var7 then
			setActive(var7, true)
			setImageSprite(var7, GetSpriteFromAtlas("shiptype", shipType2print(var3[arg1 + 1][2])))
		end
	end)
	arg0:SetFleetStepper()
	arg0:SetStageIds(arg0.contextData.stageIds)
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
	setText(arg0._fleetNameText, Fleet.DEFAULT_NAME[arg0._curFleetIndex])
	setText(arg0._fleetNumText, arg0._curFleetIndex)

	local var5 = arg0.contextData.seriesData
	local var6 = var5:GetExpeditionIds()
	local var7 = arg0._tf:Find("middle/Boss")

	UIItemList.StaticAlign(var7, var7:GetChild(0), #var6, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = arg1 + 1 == arg0._curFleetIndex or arg0._curFleetIndex > #var6 or arg0.contextData.mode == BossRushSeriesData.MODE.SINGLE

		setActive(arg2:Find("Select"), var0)
		setActive(arg2:Find("Image"), var0)
	end)

	local var8 = arg0.contextData.fleets
	local var9 = var8[#var8]
	local var10 = _.slice(var8, 1, #var8 - 1)
	local var11 = arg0.contextData.mode
	local var12 = false
	local var13 = (function()
		local var0 = 0
		local var1 = pg.battle_cost_template[var4]
		local var2 = var5:GetOilLimit()
		local var3 = var1.oil_cost > 0

		local function var4(arg0, arg1)
			local var0 = 0

			if var3 then
				var0 = arg0:GetCostSum().oil

				if arg1 > 0 then
					var0 = math.min(arg1, var0)
					var12 = var12 and var0 < arg1
				end
			end

			return var0
		end

		local var5 = #var5:GetExpeditionIds()

		if var11 == BossRushSeriesData.MODE.SINGLE then
			var0 = var0 + var4(var10[1], var2[1])
			var0 = var0 + var4(var9, var2[2])
			var0 = var0 * var5
		else
			var0 = var4(var9, var2[2]) * var5

			_.each(var10, function(arg0)
				var0 = var0 + var4(arg0, var2[1])
			end)
		end

		return var0
	end)()

	local function var14()
		local var0 = 0
		local var1 = pg.battle_cost_template[var4]
		local var2 = var5:GetOilLimit()
		local var3 = var1.oil_cost > 0

		local function var4(arg0, arg1)
			local var0 = 0

			if var3 then
				var0 = arg0:GetCostSum().oil
			end

			return var0
		end

		local var5 = #var5:GetExpeditionIds()

		if var11 == BossRushSeriesData.MODE.SINGLE then
			var0 = var0 + var4(var10[1], var2[1])
			var0 = var0 + var4(var9, var2[2])
			var0 = var0 * var5
		else
			var0 = var4(var9, var2[2]) * var5

			_.each(var10, function(arg0)
				var0 = var0 + var4(arg0, var2[1])
			end)
		end

		return var0
	end

	local var15 = 0

	if var12 then
		var15 = var14()
	end

	var1.tweenNumText(arg0._costText, var13)
	setActive(arg0._costTip, var12)

	if var12 then
		onButton(arg0, arg0._costTip, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("use_oil_limit_help", var15, var13),
				weight = LayerWeightConst.SECOND_LAYER
			})
		end)
	end
end

function var0.SetFleetStepper(arg0)
	SetActive(arg0._nextPage, arg0._curFleetIndex < #arg0._legalFleetIdList)
	SetActive(arg0._prevPage, arg0._curFleetIndex > 1)
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
