local var0 = class("PreCombatLayerSubmarine", import(".PreCombatLayer"))
local var1 = import("..ship.FormationUI")

var0.FORM_EDIT = "EDIT"
var0.FORM_PREVIEW = "PREVIEW"

function var0.getUIName(arg0)
	return "PreCombatUI"
end

function var0.init(arg0)
	arg0:CommonInit()

	local var0 = arg0:findTF("middle")
	local var1 = var0:Find("mask/grid_bg")

	SetActive(var1, false)
	SetActive(var0:Find("gear_score/main"), false)
	SetActive(var0:Find("gear_score/vanguard"), false)
	SetActive(var0:Find("gear_score/submarine"), true)

	arg0._subBg = var0:Find("mask/bg_sub")
	arg0._subFrame = var0:Find("mask/GridFrame")

	SetActive(arg0._subBg, true)

	arg0._formationLogic = BaseFormation.New(arg0._tf, arg0._heroContainer, arg0._heroInfo, arg0._gridTFs)

	arg0:Register()
end

function var0.SetFleets(arg0, arg1)
	local var0 = _.filter(_.values(arg1), function(arg0)
		return arg0:getFleetType() == FleetType.Submarine
	end)

	arg0._fleetVOs = {}
	arg0._fleetIDList = {}

	local var1 = 0

	_.each(var0, function(arg0)
		if #arg0.ships > 0 then
			arg0._fleetVOs[arg0.id] = arg0

			table.insert(arg0._fleetIDList, arg0.id)

			var1 = var1 + 1
		end
	end)

	if var1 == 0 then
		arg0._fleetVOs[11] = var0[1]

		table.insert(arg0._fleetIDList, 11)
	else
		table.sort(arg0._fleetIDList, function(arg0, arg1)
			return arg0 < arg1
		end)
	end
end

function var0.SetCurrentFleet(arg0, arg1)
	arg1 = arg1 or arg0._fleetIDList[1]
	arg0._currentFleetVO = arg0._fleetVOs[arg1]

	arg0._formationLogic:SetFleetVO(arg0._currentFleetVO)
end

function var0.UpdateFleetView(arg0, arg1)
	arg0:displayFleetInfo()
	arg0._formationLogic:UpdateGridVisibility()
	arg0._formationLogic:ResetGrid(TeamType.Submarine, arg0._currentForm ~= var0.FORM_EDIT)

	if arg1 then
		arg0._formationLogic:LoadAllCharacter()
	else
		arg0._formationLogic:SetAllCharacterPos()
	end
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
					end
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
		local var0 = arg0:getNextFleetID()

		if var0 then
			arg0:emit(PreCombatMediator.ON_CHANGE_FLEET, var0, true)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0._prevPage, function()
		local var0 = arg0:getPrevFleetID()

		if var0 then
			arg0:emit(PreCombatMediator.ON_CHANGE_FLEET, var0, true)
		end
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
	setActive(arg0._autoToggle, false)
	setActive(arg0._autoSubToggle, false)
	onNextTick(function()
		arg0:uiStartAnimating()
	end)

	if arg0._currentForm == var0.FORM_PREVIEW and arg0.contextData.system == SYSTEM_DUEL and #arg0._currentFleetVO.mainShips <= 0 then
		triggerButton(arg0._checkBtn)
	end
end

function var0.getNextFleetID(arg0)
	local var0

	for iter0, iter1 in ipairs(arg0._fleetIDList) do
		if iter1 == arg0._currentFleetVO.id then
			var0 = iter0

			break
		end
	end

	return arg0._fleetIDList[var0 + 1]
end

function var0.getPrevFleetID(arg0)
	local var0

	for iter0, iter1 in ipairs(arg0._fleetIDList) do
		if iter1 == arg0._currentFleetVO.id then
			var0 = iter0

			break
		end
	end

	return arg0._fleetIDList[var0 - 1]
end

function var0.displayFleetInfo(arg0)
	local var0 = arg0._currentFleetVO:GetPropertiesSum()
	local var1 = arg0._currentFleetVO:GetGearScoreSum(TeamType.Submarine)
	local var2 = arg0._currentFleetVO:GetCostSum()

	setActive(arg0._popup, true)
	var1.tweenNumText(arg0._costText, var2.oil)
	var1.tweenNumText(arg0._subGS, var1)
	setText(arg0._fleetNameText, var1.defaultFleetName(arg0._currentFleetVO))
	setText(arg0._fleetNumText, arg0._currentFleetVO.id - 10)
end

function var0.SetFleetStepper(arg0)
	if arg0._currentForm == var0.FORM_EDIT then
		SetActive(arg0._nextPage, false)
		SetActive(arg0._prevPage, false)
	else
		setActive(arg0._nextPage, arg0:getNextFleetID() ~= nil)
		setActive(arg0._prevPage, arg0:getPrevFleetID() ~= nil)
	end
end

function var0.willExit(arg0)
	if arg0.eventTriggers then
		for iter0, iter1 in pairs(arg0.eventTriggers) do
			ClearEventTrigger(iter0)
		end

		arg0.eventTriggers = nil
	end

	arg0._formationLogic:Destroy()

	arg0._formationLogic = nil

	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)

	if arg0._resPanel then
		arg0._resPanel:exit()

		arg0._resPanel = nil
	end
end

return var0
