local var0 = class("ExercisePreCombatLayer", import("view.battle.PreCombatLayer"))
local var1 = import("..ship.FormationUI")

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

function var0.CommonInit(arg0)
	var0.super.CommonInit(arg0)

	arg0._ticket = arg0._costContainer:Find("ticket")
end

function var0.Register(arg0)
	arg0._formationLogic:AddLoadComplete(function()
		if arg0._currentForm ~= var0.FORM_EDIT then
			arg0._formationLogic:SwitchToPreviewMode()
		end
	end)
	arg0._formationLogic:AddHeroInfoModify(function(arg0, arg1, arg2)
		arg2:SetLocalScale(Vector3(0.65, 0.65, 1))
		SetActive(arg0, true)

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
	arg0._formationLogic:AddLongPress(function(arg0, arg1, arg2)
		arg0:emit(ExercisePreCombatMediator.OPEN_SHIP_INFO, arg1.id, arg2)
	end)
	arg0._formationLogic:AddClick(function(arg0, arg1, arg2)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)
		arg0:emit(ExercisePreCombatMediator.CHANGE_FLEET_SHIP, arg0, arg2, arg1)
	end)
	arg0._formationLogic:AddBeginDrag(function(arg0)
		local var0 = findTF(arg0, "info")

		SetActive(var0, false)
	end)
	arg0._formationLogic:AddEndDrag(function(arg0)
		local var0 = findTF(arg0, "info")

		SetActive(var0, true)
	end)
	arg0._formationLogic:AddShiftOnly(function(arg0)
		arg0:emit(ExercisePreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0)
	end)
	arg0._formationLogic:AddRemoveShip(function(arg0, arg1)
		arg0:emit(ExercisePreCombatMediator.REMOVE_SHIP, arg0, arg1)
	end)
	arg0._formationLogic:AddCheckRemove(function(arg0, arg1, arg2, arg3, arg4)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			zIndex = -100,
			hideNo = false,
			content = i18n("battle_preCombatLayer_quest_leaveFleet", arg2:getConfigTable().name),
			onYes = arg1,
			onNo = arg0
		})
	end)
	arg0._formationLogic:AddSwitchToDisplayMode(function()
		arg0._currentForm = var0.FORM_EDIT
		arg0._checkBtn:GetComponent("Button").interactable = true

		setActive(arg0._checkBtn:Find("save"), true)
		setActive(arg0._checkBtn:Find("edit"), false)
	end)
	arg0._formationLogic:AddSwitchToShiftMode(function()
		arg0._checkBtn:GetComponent("Button").interactable = false
	end)
	arg0._formationLogic:AddSwitchToPreviewMode(function()
		arg0._currentForm = var0.FORM_PREVIEW
		arg0._checkBtn:GetComponent("Button").interactable = true

		setActive(arg0._checkBtn:Find("save"), false)
		setActive(arg0._checkBtn:Find("edit"), true)
	end)
	arg0._formationLogic:AddGridTipClick(function(arg0, arg1)
		arg0:emit(ExercisePreCombatMediator.CHANGE_FLEET_SHIP, nil, arg1, arg0)
	end)
end

function var0.didEnter(arg0)
	arg0:disableAllStepper()
	onButton(arg0, arg0._backBtn, function()
		local var0 = {}

		if arg0._currentForm == var0.FORM_EDIT then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function()
						arg0:emit(ExercisePreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0()
						end)
					end,
					onNo = arg0,
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
						arg0:emit(ExercisePreCombatMediator.ON_COMMIT_EDIT, function()
							arg0._formationLogic:SwitchToPreviewMode()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0()
						end)
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			end)
		end

		seriesAsync(var0, function()
			arg0:emit(ExercisePreCombatMediator.ON_START, arg0._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0, arg0._nextPage, function()
		arg0:emit(ExercisePreCombatMediator.ON_CHANGE_FLEET, arg0._legalFleetIdList[arg0._curFleetIndex + 1])
	end, SFX_PANEL)
	onButton(arg0, arg0._prevPage, function()
		arg0:emit(ExercisePreCombatMediator.ON_CHANGE_FLEET, arg0._legalFleetIdList[arg0._curFleetIndex - 1])
	end, SFX_PANEL)
	onButton(arg0, arg0._checkBtn, function()
		if arg0._currentForm == var0.FORM_EDIT then
			arg0:emit(ExercisePreCombatMediator.ON_COMMIT_EDIT, function()
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

	if arg0.contextData.system == SYSTEM_DUEL then
		setActive(arg0._autoToggle, false)
		setActive(arg0._autoSubToggle, false)
	else
		setActive(arg0._autoToggle, true)
		onToggle(arg0, arg0._autoToggle, function(arg0)
			arg0:emit(ExercisePreCombatMediator.ON_AUTO, {
				isOn = not arg0,
				toggle = arg0._autoToggle
			})

			if arg0 and arg0._subUseable == true then
				setActive(arg0._autoSubToggle, true)
				onToggle(arg0, arg0._autoSubToggle, function(arg0)
					arg0:emit(ExercisePreCombatMediator.ON_SUB_AUTO, {
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
	end

	onNextTick(function()
		arg0:uiStartAnimating()
	end)

	if arg0._currentForm == var0.FORM_PREVIEW and arg0.contextData.system == SYSTEM_DUEL and #arg0._currentFleetVO.mainShips <= 0 then
		triggerButton(arg0._checkBtn)
	end
end

function var0.disableAllStepper(arg0)
	SetActive(arg0._nextPage, false)
	SetActive(arg0._prevPage, false)
end

function var0.willExit(arg0)
	if arg0._currentForm == var0.FORM_EDIT then
		local var0 = getProxy(FleetProxy)

		arg0.contextData.EdittingFleet = var0.EdittingFleet

		var0:abortEditting()
	end

	var0.super.willExit(arg0)

	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end
end

return var0
