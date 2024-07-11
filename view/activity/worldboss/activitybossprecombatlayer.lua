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
	setActive(arg0_2._fleetInfo, true)

	arg0_2._ticket = arg0_2._startBtn:Find("ticket")
	arg0_2._bonus = arg0_2._startBtn:Find("bonus")
	arg0_2._costTip = arg0_2._startBtn:Find("cost_container/popup/tip")
	arg0_2._continuousBtn = arg0_2:findTF("right/multiple")

	setText(arg0_2._continuousBtn:Find("text"), i18n("multiple_sorties_title"))
	setText(arg0_2._continuousBtn:Find("text_en"), i18n("multiple_sorties_title_eng"))
	setText(arg0_2._ticket:Find("title"), i18n("ex_pass_use"))
	setText(arg0_2._bonus:Find("title"), i18n("expedition_extra_drop_tip"))

	arg0_2._formationLogic = BaseFormation.New(arg0_2._tf, arg0_2._heroContainer, arg0_2._heroInfo, arg0_2._gridTFs)

	arg0_2:Register()
end

function var0_0.Register(arg0_3)
	arg0_3._formationLogic:AddLoadComplete(function()
		if arg0_3._currentForm ~= PreCombatLayer.FORM_EDIT then
			arg0_3._formationLogic:SwitchToPreviewMode()
		end
	end)
	arg0_3._formationLogic:AddHeroInfoModify(function(arg0_5, arg1_5)
		setAnchoredPosition(arg0_5, {
			x = 0,
			y = 0
		})
		SetActive(arg0_5, true)

		arg0_5.name = "info"

		local var0_5 = findTF(arg0_5, "info")
		local var1_5 = findTF(var0_5, "stars")
		local var2_5 = arg1_5.energy <= Ship.ENERGY_MID
		local var3_5 = findTF(var0_5, "energy")

		if var2_5 then
			local var4_5, var5_5 = arg1_5:getEnergyPrint()
			local var6_5 = GetSpriteFromAtlas("energy", var4_5)

			if not var6_5 then
				warning("找不到疲劳")
			end

			setImageSprite(var3_5, var6_5)
		end

		local var7_5 = arg0_3.contextData.system
		local var8_5 = pg.battle_cost_template[var7_5]

		setActive(var3_5, var2_5 and var8_5.enter_energy_cost > 0)

		local var9_5 = arg1_5:getStar()

		for iter0_5 = 1, var9_5 do
			cloneTplTo(arg0_3._starTpl, var1_5)
		end

		local var10_5 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_5:getShipType()))

		if not var10_5 then
			warning("找不到船形, shipConfigId: " .. arg1_5.configId)
		end

		setImageSprite(findTF(var0_5, "type"), var10_5, true)
		setText(findTF(var0_5, "frame/lv_contain/lv"), arg1_5.level)

		if var8_5.ship_exp_award > 0 then
			local var11_5 = getProxy(ActivityProxy):getBuffShipList()[arg1_5:getGroupId()]
			local var12_5 = var0_5:Find("expbuff")

			setActive(var12_5, var11_5 ~= nil)

			if var11_5 then
				local var13_5 = var11_5 / 100
				local var14_5 = var11_5 % 100
				local var15_5 = tostring(var13_5)

				if var14_5 > 0 then
					var15_5 = var15_5 .. "." .. tostring(var14_5)
				end

				setText(var12_5:Find("text"), string.format("EXP +%s%%", var15_5))
			end
		else
			local var16_5 = var0_5:Find("expbuff")

			setActive(var16_5, false)
		end
	end)
	arg0_3._formationLogic:AddLongPress(function(arg0_6, arg1_6, arg2_6, arg3_6)
		arg0_3:emit(ActivityBossPreCombatMediator.OPEN_SHIP_INFO, arg1_6.id, arg2_6)
	end)
	arg0_3._formationLogic:AddBeginDrag(function(arg0_7)
		local var0_7 = findTF(arg0_7, "info")

		SetActive(var0_7, false)
	end)
	arg0_3._formationLogic:AddEndDrag(function(arg0_8)
		local var0_8 = findTF(arg0_8, "info")

		SetActive(var0_8, true)
	end)
	arg0_3._formationLogic:AddClick(function(arg0_9, arg1_9, arg2_9)
		return
	end)
	arg0_3._formationLogic:AddShiftOnly(function(arg0_10)
		arg0_3:emit(ActivityBossPreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_10)
	end)
	arg0_3._formationLogic:AddRemoveShip(function(arg0_11, arg1_11)
		return
	end)
	arg0_3._formationLogic:AddCheckRemove(function(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
		arg0_12()
	end)
	arg0_3._formationLogic:AddSwitchToDisplayMode(function()
		arg0_3._currentForm = PreCombatLayer.FORM_EDIT
		arg0_3._checkBtn:GetComponent("Button").interactable = true

		arg0_3:SetFleetStepper()
		setActive(arg0_3._checkBtn:Find("save"), true)
		setActive(arg0_3._checkBtn:Find("edit"), false)
	end)
	arg0_3._formationLogic:AddSwitchToShiftMode(function()
		arg0_3:SetFleetStepper()

		arg0_3._checkBtn:GetComponent("Button").interactable = false
	end)
	arg0_3._formationLogic:AddSwitchToPreviewMode(function()
		arg0_3._currentForm = PreCombatLayer.FORM_PREVIEW
		arg0_3._checkBtn:GetComponent("Button").interactable = true

		arg0_3:SetFleetStepper()
		setActive(arg0_3._checkBtn:Find("save"), false)
		setActive(arg0_3._checkBtn:Find("edit"), true)
	end)
	arg0_3._formationLogic:AddGridTipClick(function(arg0_16, arg1_16)
		return
	end)

	if arg0_3.contextData.system == SYSTEM_ACT_BOSS then
		arg0_3._formationLogic:DisableTip()
	end
end

function var0_0.SetPlayerInfo(arg0_17, arg1_17)
	return
end

function var0_0.SetSubFlag(arg0_18, arg1_18)
	arg0_18._subUseable = arg1_18 or false
end

function var0_0.SetShips(arg0_19, arg1_19)
	arg0_19._shipVOs = arg1_19

	arg0_19._formationLogic:SetShipVOs(arg0_19._shipVOs)
end

function var0_0.SetStageID(arg0_20, arg1_20)
	removeAllChildren(arg0_20._spoilsContainer)

	arg0_20._stageID = arg1_20

	local var0_20 = pg.expedition_data_template[arg1_20]
	local var1_20 = Clone(var0_20.award_display)
	local var2_20 = checkExist(pg.expedition_activity_template[arg1_20], {
		"pt_drop_display"
	})

	if var2_20 and type(var2_20) == "table" then
		local var3_20 = getProxy(ActivityProxy)

		for iter0_20 = #var2_20, 1, -1 do
			local var4_20 = var3_20:getActivityById(var2_20[iter0_20][1])

			if var4_20 and not var4_20:isEnd() then
				table.insert(var1_20, 1, {
					2,
					id2ItemId(var2_20[iter0_20][2])
				})
			end
		end
	end

	if arg0_20.contextData.system ~= SYSTEM_BOSS_EXPERIMENT then
		for iter1_20, iter2_20 in ipairs(var1_20) do
			local var5_20 = cloneTplTo(arg0_20._item, arg0_20._spoilsContainer)
			local var6_20 = {
				id = iter2_20[2],
				type = iter2_20[1]
			}

			updateDrop(var5_20, var6_20)
			onButton(arg0_20, var5_20, function()
				local var0_21 = Item.getConfigData(iter2_20[2])

				if var0_21 and var2_0[var0_21.type] then
					local var1_21 = var0_21.display_icon
					local var2_21 = {}

					for iter0_21, iter1_21 in ipairs(var1_21) do
						local var3_21 = iter1_21[1]
						local var4_21 = iter1_21[2]

						var2_21[#var2_21 + 1] = {
							hideName = true,
							type = var3_21,
							id = var4_21
						}
					end

					arg0_20:emit(var0_0.ON_DROP_LIST, {
						item2Row = true,
						itemList = var2_21,
						content = var0_21.display
					})
				else
					arg0_20:emit(var0_0.ON_DROP, var6_20)
				end
			end, SFX_PANEL)
		end
	end

	local function var7_20(arg0_22, arg1_22)
		if type(arg0_22) == "table" then
			setActive(arg1_22, true)

			local var0_22 = i18n(PreCombatLayer.ObjectiveList[arg0_22[1]], arg0_22[2])

			setWidgetText(arg1_22, var0_22)
		else
			setActive(arg1_22, false)
		end
	end

	local var8_20 = {
		findTF(arg0_20._goals, "goal_tpl"),
		findTF(arg0_20._goals, "goal_sink"),
		findTF(arg0_20._goals, "goal_time")
	}
	local var9_20 = {
		var0_20.objective_1,
		var0_20.objective_2,
		var0_20.objective_3
	}
	local var10_20 = 1

	for iter3_20, iter4_20 in ipairs(var9_20) do
		if type(iter4_20) ~= "string" then
			var7_20(iter4_20, var8_20[var10_20])

			var10_20 = var10_20 + 1
		end
	end

	for iter5_20 = var10_20, #var8_20 do
		var7_20("", var8_20[iter5_20])
	end

	local var11_20 = var0_20.guide_desc and #var0_20.guide_desc > 0

	setActive(arg0_20.guideDesc, var11_20)

	if var11_20 then
		setText(arg0_20.guideDesc, var0_20.guide_desc)
	end
end

function var0_0.SetFleets(arg0_23, arg1_23)
	local var0_23 = _.filter(_.values(arg1_23), function(arg0_24)
		return arg0_24:getFleetType() == FleetType.Normal
	end)

	arg0_23._fleetVOs = {}

	_.each(var0_23, function(arg0_25)
		arg0_23._fleetVOs[arg0_25.id] = arg0_25
	end)
	arg0_23:CheckLegalFleet()
end

function var0_0.SetCurrentFleet(arg0_26, arg1_26)
	arg0_26._currentFleetVO = arg0_26._fleetVOs[arg1_26]

	arg0_26._formationLogic:SetFleetVO(arg0_26._currentFleetVO)
	arg0_26:CheckLegalFleet()

	for iter0_26, iter1_26 in ipairs(arg0_26._legalFleetIdList) do
		if arg0_26._currentFleetVO.id == iter1_26 then
			arg0_26._curFleetIndex = iter0_26

			break
		end
	end
end

function var0_0.SetTicketItemID(arg0_27, arg1_27)
	arg0_27._ticketItemID = arg1_27
end

function var0_0.CheckLegalFleet(arg0_28)
	arg0_28._legalFleetIdList = {}

	for iter0_28, iter1_28 in pairs(arg0_28._fleetVOs) do
		if #iter1_28.ships > 0 and iter1_28.id ~= FleetProxy.PVP_FLEET_ID then
			table.insert(arg0_28._legalFleetIdList, iter1_28.id)
		end
	end

	table.sort(arg0_28._legalFleetIdList)
end

function var0_0.UpdateFleetView(arg0_29, arg1_29)
	arg0_29:displayFleetInfo()
	arg0_29:updateFleetBg()
	arg0_29._formationLogic:UpdateGridVisibility()
	arg0_29._formationLogic:ResetGrid(TeamType.Vanguard, arg0_29._currentForm ~= PreCombatLayer.FORM_EDIT)
	arg0_29._formationLogic:ResetGrid(TeamType.Main, arg0_29._currentForm ~= PreCombatLayer.FORM_EDIT)
	arg0_29._formationLogic:ResetGrid(TeamType.Submarine, arg0_29._currentForm ~= PreCombatLayer.FORM_EDIT)
	arg0_29:resetFormationComponent()

	if arg1_29 then
		arg0_29._formationLogic:LoadAllCharacter()
	else
		arg0_29._formationLogic:SetAllCharacterPos()
	end
end

function var0_0.updateFleetBg(arg0_30)
	local var0_30 = arg0_30._currentFleetVO:getFleetType()

	setActive(arg0_30._bgFleet, var0_30 == FleetType.Normal)
	setActive(arg0_30._bgSub, var0_30 == FleetType.Submarine)
end

function var0_0.resetFormationComponent(arg0_31)
	SetActive(arg0_31._gridTFs.main[1]:Find("flag"), #arg0_31._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
	SetActive(arg0_31._gridTFs.submarine[1]:Find("flag"), #arg0_31._currentFleetVO:getTeamByName(TeamType.Submarine) ~= 0)
end

function var0_0.uiStartAnimating(arg0_32)
	local var0_32 = 0
	local var1_32 = 0.3

	shiftPanel(arg0_32._middle, 0, nil, var1_32, var0_32, true, true)
	shiftPanel(arg0_32._right, 0, nil, var1_32, var0_32, true, true)
end

function var0_0.uiExitAnimating(arg0_33)
	shiftPanel(arg0_33._middle, -840, nil, nil, nil, true, true)
	shiftPanel(arg0_33._right, 470, nil, nil, nil, true, true)
end

function var0_0.quickExitFunc(arg0_34)
	if arg0_34._currentForm == PreCombatLayer.FORM_EDIT then
		arg0_34:emit(ActivityBossPreCombatMediator.ON_ABORT_EDIT)
	end

	var0_0.super.quickExitFunc(arg0_34)
end

function var0_0.didEnter(arg0_35)
	onButton(arg0_35, arg0_35._backBtn, function()
		local var0_36 = {}

		if arg0_35._currentForm == PreCombatLayer.FORM_EDIT then
			table.insert(var0_36, function(arg0_37)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function()
						arg0_35:emit(ActivityBossPreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_37()
						end)
					end,
					onNo = function()
						arg0_35:emit(ActivityBossPreCombatMediator.ON_ABORT_EDIT)
						arg0_37()
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			end)
		end

		seriesAsync(var0_36, function()
			GetOrAddComponent(arg0_35._tf, typeof(CanvasGroup)).interactable = false

			arg0_35:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0_35:emit(var0_0.ON_CLOSE)
			end))
		end)
	end, SFX_CANCEL)
	onButton(arg0_35, arg0_35._startBtn, function()
		local var0_43 = {}

		if arg0_35._currentForm == PreCombatLayer.FORM_EDIT then
			table.insert(var0_43, function(arg0_44)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function()
						arg0_35:emit(ActivityBossPreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_44()
						end)
					end
				})
			end)
		end

		seriesAsync(var0_43, function()
			arg0_35:emit(ActivityBossPreCombatMediator.ON_START, arg0_35._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_35, arg0_35._checkBtn, function()
		if arg0_35._currentForm == PreCombatLayer.FORM_EDIT then
			arg0_35:emit(ActivityBossPreCombatMediator.ON_COMMIT_EDIT, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				arg0_35._formationLogic:SwitchToPreviewMode()
			end)
		elseif arg0_35._currentForm == PreCombatLayer.FORM_PREVIEW then
			arg0_35._formationLogic:SwitchToDisplayMode()
		else
			assert("currentForm error")
		end
	end, SFX_PANEL)

	arg0_35._currentForm = arg0_35.contextData.form
	arg0_35.contextData.form = nil

	arg0_35:UpdateFleetView(true)

	if arg0_35._currentForm == PreCombatLayer.FORM_EDIT then
		arg0_35._formationLogic:SwitchToDisplayMode()
	else
		arg0_35._formationLogic:SwitchToPreviewMode()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_35._tf)
	setActive(arg0_35._autoToggle, true)
	onToggle(arg0_35, arg0_35._autoToggle, function(arg0_50)
		arg0_35:emit(ActivityBossPreCombatMediator.ON_AUTO, {
			isOn = not arg0_50,
			toggle = arg0_35._autoToggle
		})

		if arg0_50 and arg0_35._subUseable == true then
			setActive(arg0_35._autoSubToggle, true)
			onToggle(arg0_35, arg0_35._autoSubToggle, function(arg0_51)
				arg0_35:emit(ActivityBossPreCombatMediator.ON_SUB_AUTO, {
					isOn = not arg0_51,
					toggle = arg0_35._autoSubToggle
				})
			end, SFX_PANEL, SFX_PANEL)
			triggerToggle(arg0_35._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
		else
			setActive(arg0_35._autoSubToggle, false)
		end
	end, SFX_PANEL, SFX_PANEL)
	triggerToggle(arg0_35._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	onNextTick(function()
		arg0_35:uiStartAnimating()
	end)

	local var0_35 = arg0_35.contextData.stageId
	local var1_35 = getProxy(ActivityProxy):getActivityById(arg0_35.contextData.actId)

	setActive(arg0_35._continuousBtn, arg0_35.contextData.system == SYSTEM_ACT_BOSS)

	local var2_35 = var1_35 and var1_35:IsOilLimit(var0_35)

	setActive(arg0_35._continuousBtn:Find("lock"), not var2_35)

	local var3_35 = var2_35 and Color.white or Color.New(0.298039215686275, 0.298039215686275, 0.298039215686275)

	setImageColor(arg0_35._continuousBtn, var3_35)
	setTextColor(arg0_35._continuousBtn:Find("text"), var3_35)
	setTextColor(arg0_35._continuousBtn:Find("text_en"), var3_35)
	onButton(arg0_35, arg0_35._continuousBtn, function()
		if var2_35 then
			arg0_35:emit(ActivityBossPreCombatMediator.SHOW_CONTINUOUS_OPERATION_WINDOW, arg0_35._currentFleetVO.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_locked_tip"))
		end
	end, SFX_PANEL)
end

function var0_0.displayFleetInfo(arg0_54)
	var0_0.super.displayFleetInfo(arg0_54)

	local var0_54 = arg0_54.contextData.system

	setActive(arg0_54._costContainer, true)

	local var1_54 = arg0_54.contextData.stageId
	local var2_54 = getProxy(ActivityProxy):getActivityById(arg0_54.contextData.actId):GetStageBonus(var1_54)

	setActive(arg0_54._bonus, var2_54 > 0)
	setActive(arg0_54._ticket, var2_54 <= 0)
	setText(arg0_54._bonus:Find("Text"), var2_54)

	if var2_54 <= 0 then
		local var3_54 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = arg0_54._ticketItemID
		}):getIcon()
		local var4_54 = LoadSprite(var3_54, "")

		setImageSprite(arg0_54._ticket:Find("icon"), var4_54)

		local var5_54 = getProxy(PlayerProxy):getRawData():getResource(arg0_54._ticketItemID)
		local var6_54 = 1
		local var7_54 = arg0_54._ticket:Find("checkbox")

		if var0_54 == SYSTEM_BOSS_EXPERIMENT then
			var6_54 = 0

			triggerToggle(var7_54, false)
			setToggleEnabled(var7_54, false)
		elseif var0_54 == SYSTEM_HP_SHARE_ACT_BOSS then
			triggerToggle(var7_54, true)
			setToggleEnabled(var7_54, false)
		elseif var0_54 == SYSTEM_ACT_BOSS_SP then
			setActive(arg0_54._ticket, false)
		elseif var0_54 == SYSTEM_ACT_BOSS then
			local var8_54 = var5_54 > 0
			local var9_54 = getProxy(SettingsProxy):isTipActBossExchangeTicket() == 1

			setToggleEnabled(var7_54, var8_54)
			triggerToggle(var7_54, var8_54 and var9_54)
		end

		var5_54 = var5_54 < var6_54 and setColorStr(var5_54, COLOR_RED) or var5_54

		setText(arg0_54._ticket:Find("Text"), var6_54 .. "/" .. var5_54)
		onToggle(arg0_54, var7_54, function(arg0_55)
			getProxy(SettingsProxy):setActBossExchangeTicketTip(arg0_55 and 1 or 0)
		end, SFX_PANEL, SFX_CANCEL)
	end

	local var10_54 = pg.battle_cost_template[var0_54].oil_cost > 0
	local var11_54 = 0
	local var12_54 = 0
	local var13_54 = false

	for iter0_54, iter1_54 in ipairs({
		arg0_54.contextData.fleets[1]
	}) do
		local var14_54 = iter1_54:GetCostSum().oil

		if not var10_54 then
			var14_54 = 0
		end

		var12_54 = var12_54 + var14_54

		local var15_54 = iter0_54 == 1
		local var16_54 = arg0_54.contextData.costLimit[var15_54 and 1 or 2]

		if var16_54 > 0 then
			var13_54 = var13_54 or var16_54 < var14_54
			var14_54 = math.min(var14_54, var16_54)
		end

		var11_54 = var11_54 + var14_54
	end

	setTextColor(arg0_54._costText, var13_54 and Color(0.980392156862745, 0.392156862745098, 0.392156862745098) or Color.white)
	var1_0.tweenNumText(arg0_54._costText, var11_54)
	setActive(arg0_54._costTip, var13_54)

	if var13_54 then
		onButton(arg0_54, arg0_54._costTip, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("use_oil_limit_help", var12_54, var11_54),
				weight = LayerWeightConst.SECOND_LAYER
			})
		end)
	end

	setText(arg0_54._fleetNameText, Fleet.DEFAULT_NAME_BOSS_ACT[arg0_54._currentFleetVO.id])
end

function var0_0.SetFleetStepper(arg0_57)
	SetActive(arg0_57._nextPage, false)
	SetActive(arg0_57._prevPage, false)
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
