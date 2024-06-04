local var0 = class("WorldBossFormationLayer", import("..base.BaseUI"))
local var1 = import("..ship.FormationUI")

var0.FORM_EDIT = "EDIT"
var0.FORM_PREVIEW = "PREVIEW"

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

function var0.SetBossProxy(arg0, arg1, arg2)
	arg0.boss = arg1:GetBossById(arg2)
end

function var0.init(arg0)
	arg0._startBtn = arg0:findTF("right/start")
	arg0._popup = arg0:findTF("right/start/cost_container/popup")
	arg0._costText = arg0:findTF("right/start/cost_container/popup/Text")
	arg0._backBtn = arg0:findTF("blur_panel/top/back_btn")
	arg0._moveLayer = arg0:findTF("moveLayer")

	local var0 = arg0:findTF("middle")

	arg0._autoToggle = arg0:findTF("auto_toggle")
	arg0.subToggle = arg0:findTF("sub_toggle_container")

	setActive(arg0.subToggle, false)

	arg0._buffContainer = arg0._tf:Find("BuffContainer")

	setActive(arg0._buffContainer, false)

	arg0._fleetInfo = var0:Find("fleet_info")
	arg0._fleetNameText = var0:Find("fleet_info/fleet_name/Text")
	arg0._fleetNumText = var0:Find("fleet_info/fleet_number")

	setActive(arg0._fleetInfo, arg0.contextData.system ~= SYSTEM_DUEL)

	arg0._mainGS = var0:Find("gear_score/main/Text")
	arg0._vanguardGS = var0:Find("gear_score/vanguard/Text")
	arg0._gridTFs = {
		vanguard = {},
		main = {}
	}
	arg0._gridFrame = var0:Find("mask/GridFrame")

	for iter0 = 1, 3 do
		arg0._gridTFs[TeamType.Vanguard][iter0] = arg0._gridFrame:Find("vanguard_" .. iter0)
		arg0._gridTFs[TeamType.Main][iter0] = arg0._gridFrame:Find("main_" .. iter0)
	end

	arg0._nextPage = arg0:findTF("middle/nextPage")
	arg0._prevPage = arg0:findTF("middle/prevPage")

	arg0:disableAllStepper()

	arg0._heroContainer = var0:Find("HeroContainer")
	arg0._checkBtn = var0:Find("checkBtn")
	arg0._spoilsContainer = arg0:findTF("right/infomation/atlasloot/spoils/items/items_container")
	arg0._item = arg0:getTpl("right/infomation/atlasloot/spoils/items/item_tpl")
	arg0._goals = arg0:findTF("right/infomation/target/goal")
	arg0._heroInfo = arg0:getTpl("heroInfo")
	arg0._starTpl = arg0:getTpl("star_tpl")
	arg0._middle = arg0:findTF("middle")
	arg0._right = arg0:findTF("right")
	arg0.topPanel = arg0:findTF("blur_panel/top")

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

	arg0._formationLogic = BaseFormation.New(arg0._tf, arg0._heroContainer, arg0._heroInfo, arg0._gridTFs)

	arg0:Register()
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

		setActive(var3, false)
		setActive(findTF(var0, "expbuff"), false)

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
	end)
	arg0._formationLogic:AddLongPress(function(arg0, arg1, arg2)
		arg0:emit(WorldBossFormationMediator.OPEN_SHIP_INFO, arg1.id, arg2)
	end)
	arg0._formationLogic:AddClick(function(arg0, arg1, arg2)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)
		arg0:emit(WorldBossFormationMediator.CHANGE_FLEET_SHIP, arg0, arg2, arg1)
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
		arg0:emit(WorldBossFormationMediator.CHANGE_FLEET_SHIPS_ORDER)
	end)
	arg0._formationLogic:AddRemoveShip(function(arg0, arg1)
		arg0:emit(WorldBossFormationMediator.REMOVE_SHIP, arg0, arg1)
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

		setActive(arg0._checkBtn:Find("save"), true)
		setActive(arg0._checkBtn:Find("edit"), false)
	end)
	arg0._formationLogic:AddSwitchToShiftMode(function()
		arg0:disableAllStepper()

		arg0._checkBtn:GetComponent("Button").interactable = false
	end)
	arg0._formationLogic:AddSwitchToPreviewMode(function()
		arg0._currentForm = var0.FORM_PREVIEW
		arg0._checkBtn:GetComponent("Button").interactable = true

		setActive(arg0._checkBtn:Find("save"), false)
		setActive(arg0._checkBtn:Find("edit"), true)
	end)
	arg0._formationLogic:AddGridTipClick(function(arg0, arg1)
		arg0:emit(WorldBossFormationMediator.CHANGE_FLEET_SHIP, nil, arg1, arg0)
	end)
end

function var0.SetPlayerInfo(arg0, arg1)
	return
end

function var0.SetShips(arg0, arg1)
	arg0._shipVOs = arg1

	arg0._formationLogic:SetShipVOs(arg0._shipVOs)
end

function var0.SetStageID(arg0, arg1)
	removeAllChildren(arg0._spoilsContainer)

	arg0._stageID = arg1

	local var0 = pg.expedition_data_template[arg1]
	local var1 = var0.limit_type
	local var2 = var0.time_limit
	local var3 = var0.sink_limit
	local var4 = var0.award_display

	for iter0, iter1 in ipairs(var4) do
		local var5 = cloneTplTo(arg0._item, arg0._spoilsContainer)
		local var6 = {
			id = iter1[2],
			type = iter1[1]
		}

		updateDrop(var5, var6)
	end

	local var7 = findTF(arg0._goals, "goal_tpl")
	local var8 = findTF(arg0._goals, "goal_sink")
	local var9 = findTF(arg0._goals, "goal_time")

	if var1 == 1 then
		local var10

		if var3 < 2 then
			var10 = i18n("battle_preCombatLayer_undefeated")
		else
			var10 = i18n("battle_preCombatLayer_sink_limit", var3)
		end

		setWidgetText(var7, i18n("battle_preCombatLayer_victory"))
		setWidgetText(var8, var10)
		setWidgetText(var9, i18n("battle_preCombatLayer_time_limit", var2))
	elseif var1 == 2 then
		setActive(var8, false)
		setActive(var9, false)
		setWidgetText(var7, i18n("battle_preCombatLayer_time_hold", var2))
	elseif var1 == 3 then
		setActive(var8, false)
		setActive(var9, false)
		setWidgetText(var7, i18n("battle_result_defeat_all_enemys", var2))
	end

	local var11 = var0.guide_desc and #var0.guide_desc > 0

	setActive(arg0.guideDesc, var11)

	if var11 then
		setText(arg0.guideDesc, var0.guide_desc)
	end
end

function var0.SetCurrentFleet(arg0, arg1)
	arg0._currentFleetVO = arg1

	arg0._formationLogic:SetFleetVO(arg0._currentFleetVO)

	arg0._legalFleetIdList = {
		arg1
	}
	arg0._curFleetIndex = 1
end

function var0.UpdateFleetView(arg0, arg1)
	arg0:displayFleetInfo()
	arg0._formationLogic:ResetGrid(TeamType.Vanguard, arg0._currentForm ~= var0.FORM_EDIT)
	arg0._formationLogic:ResetGrid(TeamType.Main, arg0._currentForm ~= var0.FORM_EDIT)

	if arg1 then
		arg0._formationLogic:LoadAllCharacter()
	else
		arg0._formationLogic:SetAllCharacterPos()
	end
end

function var0.uiStartAnimating(arg0)
	local var0 = 0
	local var1 = 0.3

	setAnchoredPosition(arg0.topPanel, {
		y = 100
	})
	shiftPanel(arg0._middle, 0, nil, var1, var0, true, true)
	shiftPanel(arg0._right, 0, nil, var1, var0, true, true)
	shiftPanel(arg0.topPanel, nil, 0, var1, var0, true, true, nil)
end

function var0.uiExitAnimating(arg0)
	shiftPanel(arg0._middle, -840, nil, nil, nil, true, true)
	shiftPanel(arg0._right, 470, nil, nil, nil, true, true)
	shiftPanel(arg0.topPanel, nil, arg0.topPanel.rect.height, nil, nil, true, true, nil)
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
						arg0:emit(WorldBossFormationMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0()
						end)
					end,
					onNo = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

			arg0:uiExitAnimating()
			LeanTween.delayedCall(0.3, System.Action(function()
				nowWorld():GetBossProxy():UnlockCacheBoss()
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
						arg0:emit(WorldBossFormationMediator.ON_COMMIT_EDIT, function()
							pg.TipsMgr.GetInstance():ShowTips(i18n("battle_preCombatLayer_save_success"))
							arg0()
						end)
					end
				})
			end)
		end

		seriesAsync(var0, function()
			arg0:emit(WorldBossFormationMediator.ON_START, arg0._currentFleetVO.id)
		end)
	end, SFX_UI_WEIGHANCHOR)
	onButton(arg0, arg0._checkBtn, function()
		if arg0._currentForm == var0.FORM_EDIT then
			arg0:emit(WorldBossFormationMediator.ON_COMMIT_EDIT, function()
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
	else
		setActive(arg0._autoToggle, true)
		onToggle(arg0, arg0._autoToggle, function(arg0)
			arg0:emit(WorldBossFormationMediator.ON_AUTO, {
				isOn = not arg0,
				toggle = arg0._autoToggle
			})
		end, SFX_PANEL, SFX_PANEL)
		triggerToggle(arg0._autoToggle, ys.Battle.BattleState.IsAutoBotActive(SYSTEM_WORLD))
	end

	setAnchoredPosition(arg0.topPanel, {
		y = arg0.topPanel.rect.height
	})
	onNextTick(function()
		arg0:uiStartAnimating()
	end)

	if arg0._currentForm == var0.FORM_PREVIEW and arg0._currentFleetVO:isLegalToFight() ~= true then
		triggerButton(arg0._checkBtn)
	end

	arg0:UpdateBuffContainer()
	arg0:TryPlayGuide()
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0._backBtn)
end

function var0.displayFleetInfo(arg0)
	local var0 = arg0._currentFleetVO:GetPropertiesSum()
	local var1 = arg0._currentFleetVO:GetGearScoreSum(TeamType.Vanguard)
	local var2 = arg0._currentFleetVO:GetGearScoreSum(TeamType.Main)
	local var3 = 0

	if arg0.boss and arg0.boss:IsSelf() and arg0.boss:GetSelfFightCnt() > 0 then
		var3 = arg0.boss:GetOilConsume()
	end

	setActive(arg0._popup, arg0.contextData.system ~= SYSTEM_DUEL)
	var1.tweenNumText(arg0._costText, var3)
	var1.tweenNumText(arg0._vanguardGS, var1)
	var1.tweenNumText(arg0._mainGS, var2)
	setText(arg0._fleetNameText, var1.defaultFleetName(arg0._currentFleetVO))
	setText(arg0._fleetNumText, arg0._currentFleetVO.id)
end

function var0.disableAllStepper(arg0)
	SetActive(arg0._nextPage, false)
	SetActive(arg0._prevPage, false)
end

function var0.GetActiveStgs(arg0)
	local var0 = {}
	local var1, var2, var3 = WorldBossProxy.GetSupportValue()

	if var1 and arg0.boss and arg0.boss:IsSelf() then
		table.insert(var0, var3)
	end

	return var0
end

function var0.UpdateBuffContainer(arg0)
	local var0 = arg0:GetActiveStgs()
	local var1 = #var0 > 0

	setActive(arg0._buffContainer, var1)

	if not var1 then
		return
	end

	UIItemList.StaticAlign(arg0._buffContainer, arg0._buffContainer:GetChild(0), #var0, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = pg.strategy_data_template[var0[arg1 + 1]]

		GetImageSpriteFromAtlasAsync("strategyicon/" .. var0.icon, "", arg2)
		onButton(arg0, arg2, function()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = "",
				yesText = "text_confirm",
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = {
					type = DROP_TYPE_STRATEGY,
					id = var0.id,
					cfg = var0
				}
			})
		end, SFX_PANEL)
	end)
end

function var0.TryPlayGuide(arg0)
	if #arg0:GetActiveStgs() > 0 then
		WorldGuider.GetInstance():PlayGuide("WorldG200")
	end
end

function var0.willExit(arg0)
	if arg0._currentForm == var0.FORM_EDIT then
		arg0.contextData.editingFleetVO = arg0._currentFleetVO
	end

	arg0._formationLogic:Destroy()

	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
