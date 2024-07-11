local var0_0 = class("PreCombatLayerSubmarine", import(".PreCombatLayer"))
local var1_0 = import("..ship.FormationUI")

function var0_0.init(arg0_1)
	arg0_1:CommonInit()

	local var0_1 = arg0_1:findTF("middle")

	SetActive(var0_1:Find("gear_score/main"), false)
	SetActive(var0_1:Find("gear_score/vanguard"), false)
	SetActive(var0_1:Find("gear_score/submarine"), true)
	setActive(arg0_1._bgFleet, false)
	setActive(arg0_1._bgSub, true)

	arg0_1._formationLogic = BaseFormation.New(arg0_1._tf, arg0_1._heroContainer, arg0_1._heroInfo, arg0_1._gridTFs)

	arg0_1:Register()
end

function var0_0.SetFleets(arg0_2, arg1_2)
	local var0_2 = _.filter(_.values(arg1_2), function(arg0_3)
		return arg0_3:getFleetType() == FleetType.Submarine
	end)

	arg0_2._fleetVOs = {}
	arg0_2._fleetIDList = {}

	local var1_2 = 0

	_.each(var0_2, function(arg0_4)
		arg0_2._fleetVOs[arg0_4.id] = arg0_4

		if #arg0_4.ships > 0 then
			table.insert(arg0_2._fleetIDList, arg0_4.id)

			var1_2 = var1_2 + 1
		end
	end)

	if var1_2 == 0 then
		table.insert(arg0_2._fleetIDList, var0_2[1].id)
	end

	table.sort(arg0_2._fleetIDList, function(arg0_5, arg1_5)
		return arg0_5 < arg1_5
	end)
end

function var0_0.SetCurrentFleet(arg0_6, arg1_6)
	arg1_6 = arg1_6 or arg0_6._fleetIDList[1]
	arg0_6._currentFleetVO = arg0_6._fleetVOs[arg1_6]

	arg0_6._formationLogic:SetFleetVO(arg0_6._currentFleetVO)
end

function var0_0.UpdateFleetView(arg0_7, arg1_7)
	arg0_7:displayFleetInfo()
	arg0_7._formationLogic:UpdateGridVisibility()
	arg0_7._formationLogic:ResetGrid(TeamType.Submarine, arg0_7._currentForm ~= var0_0.FORM_EDIT)

	if arg1_7 then
		arg0_7._formationLogic:LoadAllCharacter()
	else
		arg0_7._formationLogic:SetAllCharacterPos()
	end
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8._backBtn, function()
		local var0_9 = {}

		if arg0_8._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_9, function(arg0_10)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function()
						arg0_8:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_10()
						end)
					end,
					onNo = function()
						arg0_8:emit(PreCombatMediator.ON_ABORT_EDIT)
						arg0_10()
					end
				})
			end)
		end

		seriesAsync(var0_9, function()
			GetOrAddComponent(arg0_8._tf, typeof(CanvasGroup)).interactable = false

			arg0_8:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0_8:emit(var0_0.ON_CLOSE)
			end))
		end)
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8._startBtn, function()
		local var0_16 = {}

		if arg0_8._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_16, function(arg0_17)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function()
						arg0_8:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_17()
						end)
					end
				})
			end)
		end

		seriesAsync(var0_16, function()
			arg0_8:emit(PreCombatMediator.ON_START, arg0_8._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_8, arg0_8._nextPage, function()
		local var0_21 = arg0_8:getNextFleetID()

		if var0_21 then
			arg0_8:emit(PreCombatMediator.ON_CHANGE_FLEET, var0_21, true)
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._prevPage, function()
		local var0_22 = arg0_8:getPrevFleetID()

		if var0_22 then
			arg0_8:emit(PreCombatMediator.ON_CHANGE_FLEET, var0_22, true)
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._checkBtn, function()
		if arg0_8._currentForm == var0_0.FORM_EDIT then
			arg0_8:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				arg0_8._formationLogic:SwitchToPreviewMode()
			end)
		elseif arg0_8._currentForm == var0_0.FORM_PREVIEW then
			arg0_8._formationLogic:SwitchToDisplayMode()
		else
			assert("currentForm error")
		end
	end, SFX_PANEL)

	arg0_8._currentForm = arg0_8.contextData.form
	arg0_8.contextData.form = nil

	arg0_8:UpdateFleetView(true)

	if arg0_8._currentForm == var0_0.FORM_EDIT then
		arg0_8._formationLogic:SwitchToDisplayMode()
	else
		arg0_8._formationLogic:SwitchToPreviewMode()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)
	setActive(arg0_8._autoToggle, false)
	setActive(arg0_8._autoSubToggle, false)
	onNextTick(function()
		arg0_8:uiStartAnimating()
	end)
end

function var0_0.getNextFleetID(arg0_26)
	local var0_26

	for iter0_26, iter1_26 in ipairs(arg0_26._fleetIDList) do
		if iter1_26 == arg0_26._currentFleetVO.id then
			var0_26 = iter0_26

			break
		end
	end

	return arg0_26._fleetIDList[var0_26 + 1]
end

function var0_0.getPrevFleetID(arg0_27)
	local var0_27

	for iter0_27, iter1_27 in ipairs(arg0_27._fleetIDList) do
		if iter1_27 == arg0_27._currentFleetVO.id then
			var0_27 = iter0_27

			break
		end
	end

	return arg0_27._fleetIDList[var0_27 - 1]
end

function var0_0.displayFleetInfo(arg0_28)
	local var0_28 = math.floor(arg0_28._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var1_28 = arg0_28._currentFleetVO:GetCostSum()

	setActive(arg0_28._popup, true)
	var1_0.tweenNumText(arg0_28._costText, var1_28.oil)
	var1_0.tweenNumText(arg0_28._subGS, var0_28)
	setText(arg0_28._fleetNameText, var1_0.defaultFleetName(arg0_28._currentFleetVO))
	setText(arg0_28._fleetNumText, arg0_28._currentFleetVO.id - 10)
end

function var0_0.SetFleetStepper(arg0_29)
	if arg0_29._currentForm == var0_0.FORM_EDIT then
		SetActive(arg0_29._nextPage, false)
		SetActive(arg0_29._prevPage, false)
	else
		setActive(arg0_29._nextPage, arg0_29:getNextFleetID() ~= nil)
		setActive(arg0_29._prevPage, arg0_29:getPrevFleetID() ~= nil)
	end
end

return var0_0
