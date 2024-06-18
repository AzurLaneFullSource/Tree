local var0_0 = class("PreCombatLayerSubmarine", import(".PreCombatLayer"))
local var1_0 = import("..ship.FormationUI")

var0_0.FORM_EDIT = "EDIT"
var0_0.FORM_PREVIEW = "PREVIEW"

function var0_0.getUIName(arg0_1)
	return "PreCombatUI"
end

function var0_0.init(arg0_2)
	arg0_2:CommonInit()

	local var0_2 = arg0_2:findTF("middle")
	local var1_2 = var0_2:Find("mask/grid_bg")

	SetActive(var1_2, false)
	SetActive(var0_2:Find("gear_score/main"), false)
	SetActive(var0_2:Find("gear_score/vanguard"), false)
	SetActive(var0_2:Find("gear_score/submarine"), true)

	arg0_2._subBg = var0_2:Find("mask/bg_sub")
	arg0_2._subFrame = var0_2:Find("mask/GridFrame")

	SetActive(arg0_2._subBg, true)

	arg0_2._formationLogic = BaseFormation.New(arg0_2._tf, arg0_2._heroContainer, arg0_2._heroInfo, arg0_2._gridTFs)

	arg0_2:Register()
end

function var0_0.SetFleets(arg0_3, arg1_3)
	local var0_3 = _.filter(_.values(arg1_3), function(arg0_4)
		return arg0_4:getFleetType() == FleetType.Submarine
	end)

	arg0_3._fleetVOs = {}
	arg0_3._fleetIDList = {}

	local var1_3 = 0

	_.each(var0_3, function(arg0_5)
		if #arg0_5.ships > 0 then
			arg0_3._fleetVOs[arg0_5.id] = arg0_5

			table.insert(arg0_3._fleetIDList, arg0_5.id)

			var1_3 = var1_3 + 1
		end
	end)

	if var1_3 == 0 then
		arg0_3._fleetVOs[11] = var0_3[1]

		table.insert(arg0_3._fleetIDList, 11)
	else
		table.sort(arg0_3._fleetIDList, function(arg0_6, arg1_6)
			return arg0_6 < arg1_6
		end)
	end
end

function var0_0.SetCurrentFleet(arg0_7, arg1_7)
	arg1_7 = arg1_7 or arg0_7._fleetIDList[1]
	arg0_7._currentFleetVO = arg0_7._fleetVOs[arg1_7]

	arg0_7._formationLogic:SetFleetVO(arg0_7._currentFleetVO)
end

function var0_0.UpdateFleetView(arg0_8, arg1_8)
	arg0_8:displayFleetInfo()
	arg0_8._formationLogic:UpdateGridVisibility()
	arg0_8._formationLogic:ResetGrid(TeamType.Submarine, arg0_8._currentForm ~= var0_0.FORM_EDIT)

	if arg1_8 then
		arg0_8._formationLogic:LoadAllCharacter()
	else
		arg0_8._formationLogic:SetAllCharacterPos()
	end
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9._backBtn, function()
		local var0_10 = {}

		if arg0_9._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_10, function(arg0_11)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function()
						arg0_9:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_11()
						end)
					end,
					onNo = function()
						arg0_9:emit(PreCombatMediator.ON_ABORT_EDIT)
						arg0_11()
					end
				})
			end)
		end

		seriesAsync(var0_10, function()
			GetOrAddComponent(arg0_9._tf, typeof(CanvasGroup)).interactable = false

			arg0_9:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0_9:emit(var0_0.ON_CLOSE)
			end))
		end)
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9._startBtn, function()
		local var0_17 = {}

		if arg0_9._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_17, function(arg0_18)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function()
						arg0_9:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_18()
						end)
					end
				})
			end)
		end

		seriesAsync(var0_17, function()
			arg0_9:emit(PreCombatMediator.ON_START, arg0_9._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_9, arg0_9._nextPage, function()
		local var0_22 = arg0_9:getNextFleetID()

		if var0_22 then
			arg0_9:emit(PreCombatMediator.ON_CHANGE_FLEET, var0_22, true)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._prevPage, function()
		local var0_23 = arg0_9:getPrevFleetID()

		if var0_23 then
			arg0_9:emit(PreCombatMediator.ON_CHANGE_FLEET, var0_23, true)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9._checkBtn, function()
		if arg0_9._currentForm == var0_0.FORM_EDIT then
			arg0_9:emit(PreCombatMediator.ON_COMMIT_EDIT, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				arg0_9._formationLogic:SwitchToPreviewMode()
			end)
		elseif arg0_9._currentForm == var0_0.FORM_PREVIEW then
			arg0_9._formationLogic:SwitchToDisplayMode()
		else
			assert("currentForm error")
		end
	end, SFX_PANEL)

	arg0_9._currentForm = arg0_9.contextData.form
	arg0_9.contextData.form = nil

	arg0_9:UpdateFleetView(true)

	if arg0_9._currentForm == var0_0.FORM_EDIT then
		arg0_9._formationLogic:SwitchToDisplayMode()
	else
		arg0_9._formationLogic:SwitchToPreviewMode()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)
	setActive(arg0_9._autoToggle, false)
	setActive(arg0_9._autoSubToggle, false)
	onNextTick(function()
		arg0_9:uiStartAnimating()
	end)

	if arg0_9._currentForm == var0_0.FORM_PREVIEW and arg0_9.contextData.system == SYSTEM_DUEL and #arg0_9._currentFleetVO.mainShips <= 0 then
		triggerButton(arg0_9._checkBtn)
	end
end

function var0_0.getNextFleetID(arg0_27)
	local var0_27

	for iter0_27, iter1_27 in ipairs(arg0_27._fleetIDList) do
		if iter1_27 == arg0_27._currentFleetVO.id then
			var0_27 = iter0_27

			break
		end
	end

	return arg0_27._fleetIDList[var0_27 + 1]
end

function var0_0.getPrevFleetID(arg0_28)
	local var0_28

	for iter0_28, iter1_28 in ipairs(arg0_28._fleetIDList) do
		if iter1_28 == arg0_28._currentFleetVO.id then
			var0_28 = iter0_28

			break
		end
	end

	return arg0_28._fleetIDList[var0_28 - 1]
end

function var0_0.displayFleetInfo(arg0_29)
	local var0_29 = arg0_29._currentFleetVO:GetPropertiesSum()
	local var1_29 = arg0_29._currentFleetVO:GetGearScoreSum(TeamType.Submarine)
	local var2_29 = arg0_29._currentFleetVO:GetCostSum()

	setActive(arg0_29._popup, true)
	var1_0.tweenNumText(arg0_29._costText, var2_29.oil)
	var1_0.tweenNumText(arg0_29._subGS, var1_29)
	setText(arg0_29._fleetNameText, var1_0.defaultFleetName(arg0_29._currentFleetVO))
	setText(arg0_29._fleetNumText, arg0_29._currentFleetVO.id - 10)
end

function var0_0.SetFleetStepper(arg0_30)
	if arg0_30._currentForm == var0_0.FORM_EDIT then
		SetActive(arg0_30._nextPage, false)
		SetActive(arg0_30._prevPage, false)
	else
		setActive(arg0_30._nextPage, arg0_30:getNextFleetID() ~= nil)
		setActive(arg0_30._prevPage, arg0_30:getPrevFleetID() ~= nil)
	end
end

function var0_0.willExit(arg0_31)
	if arg0_31.eventTriggers then
		for iter0_31, iter1_31 in pairs(arg0_31.eventTriggers) do
			ClearEventTrigger(iter0_31)
		end

		arg0_31.eventTriggers = nil
	end

	arg0_31._formationLogic:Destroy()

	arg0_31._formationLogic = nil

	if arg0_31.tweens then
		cancelTweens(arg0_31.tweens)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_31._tf)

	if arg0_31._resPanel then
		arg0_31._resPanel:exit()

		arg0_31._resPanel = nil
	end
end

return var0_0
