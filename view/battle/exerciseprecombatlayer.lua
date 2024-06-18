local var0_0 = class("ExercisePreCombatLayer", import("view.battle.PreCombatLayer"))
local var1_0 = import("..ship.FormationUI")

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

function var0_0.CommonInit(arg0_3)
	var0_0.super.CommonInit(arg0_3)

	arg0_3._ticket = arg0_3._costContainer:Find("ticket")
end

function var0_0.Register(arg0_4)
	arg0_4._formationLogic:AddLoadComplete(function()
		if arg0_4._currentForm ~= var0_0.FORM_EDIT then
			arg0_4._formationLogic:SwitchToPreviewMode()
		end
	end)
	arg0_4._formationLogic:AddHeroInfoModify(function(arg0_6, arg1_6, arg2_6)
		arg2_6:SetLocalScale(Vector3(0.65, 0.65, 1))
		SetActive(arg0_6, true)

		local var0_6 = findTF(arg0_6, "info")
		local var1_6 = findTF(var0_6, "stars")
		local var2_6 = arg1_6.energy <= Ship.ENERGY_MID
		local var3_6 = findTF(var0_6, "energy")

		if var2_6 then
			local var4_6, var5_6 = arg1_6:getEnergyPrint()
			local var6_6 = GetSpriteFromAtlas("energy", var4_6)

			if not var6_6 then
				warning("找不到疲劳")
			end

			setImageSprite(var3_6, var6_6)
		end

		setActive(var3_6, var2_6 and arg0_4.contextData.system ~= SYSTEM_DUEL)

		local var7_6 = arg1_6:getStar()

		for iter0_6 = 1, var7_6 do
			cloneTplTo(arg0_4._starTpl, var1_6)
		end

		local var8_6 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_6:getShipType()))

		if not var8_6 then
			warning("找不到船形, shipConfigId: " .. arg1_6.configId)
		end

		setImageSprite(findTF(var0_6, "type"), var8_6, true)
		setText(findTF(var0_6, "frame/lv_contain/lv"), arg1_6.level)

		local var9_6 = var0_6:Find("expbuff")

		setActive(var9_6, false)
	end)
	arg0_4._formationLogic:AddLongPress(function(arg0_7, arg1_7, arg2_7)
		arg0_4:emit(ExercisePreCombatMediator.OPEN_SHIP_INFO, arg1_7.id, arg2_7)
	end)
	arg0_4._formationLogic:AddClick(function(arg0_8, arg1_8, arg2_8)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)
		arg0_4:emit(ExercisePreCombatMediator.CHANGE_FLEET_SHIP, arg0_8, arg2_8, arg1_8)
	end)
	arg0_4._formationLogic:AddBeginDrag(function(arg0_9)
		local var0_9 = findTF(arg0_9, "info")

		SetActive(var0_9, false)
	end)
	arg0_4._formationLogic:AddEndDrag(function(arg0_10)
		local var0_10 = findTF(arg0_10, "info")

		SetActive(var0_10, true)
	end)
	arg0_4._formationLogic:AddShiftOnly(function(arg0_11)
		arg0_4:emit(ExercisePreCombatMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_11)
	end)
	arg0_4._formationLogic:AddRemoveShip(function(arg0_12, arg1_12)
		arg0_4:emit(ExercisePreCombatMediator.REMOVE_SHIP, arg0_12, arg1_12)
	end)
	arg0_4._formationLogic:AddCheckRemove(function(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			zIndex = -100,
			hideNo = false,
			content = i18n("battle_preCombatLayer_quest_leaveFleet", arg2_13:getConfigTable().name),
			onYes = arg1_13,
			onNo = arg0_13
		})
	end)
	arg0_4._formationLogic:AddSwitchToDisplayMode(function()
		arg0_4._currentForm = var0_0.FORM_EDIT
		arg0_4._checkBtn:GetComponent("Button").interactable = true

		setActive(arg0_4._checkBtn:Find("save"), true)
		setActive(arg0_4._checkBtn:Find("edit"), false)
	end)
	arg0_4._formationLogic:AddSwitchToShiftMode(function()
		arg0_4._checkBtn:GetComponent("Button").interactable = false
	end)
	arg0_4._formationLogic:AddSwitchToPreviewMode(function()
		arg0_4._currentForm = var0_0.FORM_PREVIEW
		arg0_4._checkBtn:GetComponent("Button").interactable = true

		setActive(arg0_4._checkBtn:Find("save"), false)
		setActive(arg0_4._checkBtn:Find("edit"), true)
	end)
	arg0_4._formationLogic:AddGridTipClick(function(arg0_17, arg1_17)
		arg0_4:emit(ExercisePreCombatMediator.CHANGE_FLEET_SHIP, nil, arg1_17, arg0_17)
	end)
end

function var0_0.didEnter(arg0_18)
	arg0_18:disableAllStepper()
	onButton(arg0_18, arg0_18._backBtn, function()
		local var0_19 = {}

		if arg0_18._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_19, function(arg0_20)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_confirm"),
					onYes = function()
						arg0_18:emit(ExercisePreCombatMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_20()
						end)
					end,
					onNo = arg0_20,
					weight = LayerWeightConst.TOP_LAYER
				})
			end)
		end

		seriesAsync(var0_19, function()
			GetOrAddComponent(arg0_18._tf, typeof(CanvasGroup)).interactable = false

			arg0_18:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function()
				arg0_18:emit(var0_0.ON_CLOSE)
			end))
		end)
	end, SFX_CANCEL)
	onButton(arg0_18, arg0_18._startBtn, function()
		local var0_25 = {}

		if arg0_18._currentForm == var0_0.FORM_EDIT then
			table.insert(var0_25, function(arg0_26)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					zIndex = -100,
					hideNo = false,
					content = i18n("battle_preCombatLayer_save_march"),
					onYes = function()
						arg0_18:emit(ExercisePreCombatMediator.ON_COMMIT_EDIT, function()
							arg0_18._formationLogic:SwitchToPreviewMode()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0_26()
						end)
					end,
					weight = LayerWeightConst.TOP_LAYER
				})
			end)
		end

		seriesAsync(var0_25, function()
			arg0_18:emit(ExercisePreCombatMediator.ON_START, arg0_18._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0_18, arg0_18._nextPage, function()
		arg0_18:emit(ExercisePreCombatMediator.ON_CHANGE_FLEET, arg0_18._legalFleetIdList[arg0_18._curFleetIndex + 1])
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18._prevPage, function()
		arg0_18:emit(ExercisePreCombatMediator.ON_CHANGE_FLEET, arg0_18._legalFleetIdList[arg0_18._curFleetIndex - 1])
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18._checkBtn, function()
		if arg0_18._currentForm == var0_0.FORM_EDIT then
			arg0_18:emit(ExercisePreCombatMediator.ON_COMMIT_EDIT, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
				arg0_18._formationLogic:SwitchToPreviewMode()
			end)
		elseif arg0_18._currentForm == var0_0.FORM_PREVIEW then
			arg0_18._formationLogic:SwitchToDisplayMode()
		else
			assert("currentForm error")
		end
	end, SFX_PANEL)

	arg0_18._currentForm = arg0_18.contextData.form
	arg0_18.contextData.form = nil

	arg0_18:UpdateFleetView(true)

	if arg0_18._currentForm == var0_0.FORM_EDIT then
		arg0_18._formationLogic:SwitchToDisplayMode()
	else
		arg0_18._formationLogic:SwitchToPreviewMode()
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_18._tf)

	if arg0_18.contextData.system == SYSTEM_DUEL then
		setActive(arg0_18._autoToggle, false)
		setActive(arg0_18._autoSubToggle, false)
	else
		setActive(arg0_18._autoToggle, true)
		onToggle(arg0_18, arg0_18._autoToggle, function(arg0_34)
			arg0_18:emit(ExercisePreCombatMediator.ON_AUTO, {
				isOn = not arg0_34,
				toggle = arg0_18._autoToggle
			})

			if arg0_34 and arg0_18._subUseable == true then
				setActive(arg0_18._autoSubToggle, true)
				onToggle(arg0_18, arg0_18._autoSubToggle, function(arg0_35)
					arg0_18:emit(ExercisePreCombatMediator.ON_SUB_AUTO, {
						isOn = not arg0_35,
						toggle = arg0_18._autoSubToggle
					})
				end, SFX_PANEL, SFX_PANEL)
				triggerToggle(arg0_18._autoSubToggle, ys.Battle.BattleState.IsAutoSubActive())
			else
				setActive(arg0_18._autoSubToggle, false)
			end
		end, SFX_PANEL, SFX_PANEL)
		triggerToggle(arg0_18._autoToggle, ys.Battle.BattleState.IsAutoBotActive())
	end

	onNextTick(function()
		arg0_18:uiStartAnimating()
	end)

	if arg0_18._currentForm == var0_0.FORM_PREVIEW and arg0_18.contextData.system == SYSTEM_DUEL and #arg0_18._currentFleetVO.mainShips <= 0 then
		triggerButton(arg0_18._checkBtn)
	end
end

function var0_0.disableAllStepper(arg0_37)
	SetActive(arg0_37._nextPage, false)
	SetActive(arg0_37._prevPage, false)
end

function var0_0.willExit(arg0_38)
	if arg0_38._currentForm == var0_0.FORM_EDIT then
		local var0_38 = getProxy(FleetProxy)

		arg0_38.contextData.EdittingFleet = var0_38.EdittingFleet

		var0_38:abortEditting()
	end

	var0_0.super.willExit(arg0_38)

	if arg0_38.tweens then
		cancelTweens(arg0_38.tweens)
	end
end

return var0_0
