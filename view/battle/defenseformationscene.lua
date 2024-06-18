local var0_0 = class("DefenseFormationScene", import("..base.BaseUI"))

var0_0.RADIUS = 60
var0_0.LONGPRESS_Y = 30
var0_0.INTERVAL = math.pi / 2 / 6
var0_0.MAX_FLEET_NUM = 6
var0_0.MAX_SHIPP_NUM = 5
var0_0.TOGGLE_DETAIL = "_detailToggle"
var0_0.TOGGLE_FORMATION = "_formationToggle"
var0_0.BUFF_TYEP = {
	blue = "blue",
	pink = "pink",
	cyan = "cyan"
}

function var0_0.getUIName(arg0_1)
	return "ExerciseFormationUI"
end

function var0_0.init(arg0_2)
	arg0_2.eventTriggers = {}
	arg0_2._blurLayer = arg0_2:findTF("blur_panel")
	arg0_2.backBtn = arg0_2:findTF("top/back_btn", arg0_2._blurLayer)
	arg0_2._bottomPanel = arg0_2:findTF("bottom", arg0_2._blurLayer)
	arg0_2._detailToggle = arg0_2:findTF("toggle_list/detail_toggle", arg0_2._bottomPanel)
	arg0_2._formationToggle = arg0_2:findTF("toggle_list/formation_toggle", arg0_2._bottomPanel)
	arg0_2._starTpl = arg0_2:findTF("star_tpl")
	arg0_2._heroInfoTpl = arg0_2:findTF("heroInfo")
	arg0_2._gridTFs = {
		vanguard = {},
		main = {}
	}
	arg0_2._gridFrame = arg0_2:findTF("GridFrame")

	for iter0_2 = 1, 3 do
		arg0_2._gridTFs[TeamType.Main][iter0_2] = arg0_2._gridFrame:Find("main_" .. iter0_2)
		arg0_2._gridTFs[TeamType.Vanguard][iter0_2] = arg0_2._gridFrame:Find("vanguard_" .. iter0_2)
	end

	arg0_2._heroContainer = arg0_2:findTF("HeroContainer")
	arg0_2._fleetInfo = arg0_2:findTF("fleet_info", arg0_2._blurLayer)
	arg0_2._fleetNameText = arg0_2:findTF("fleet_name/Text", arg0_2._fleetInfo)
	arg0_2._buffPanel = arg0_2:findTF("buff_list")
	arg0_2._buffGroup = arg0_2:findTF("buff_group", arg0_2._buffPanel)
	arg0_2._buffModel = arg0_2:getTpl("buff_model", arg0_2._buffPanel)
	arg0_2._propertyFrame = arg0_2:findTF("property_frame", arg0_2._blurLayer)
	arg0_2._cannonPower = arg0_2:findTF("cannon/Text", arg0_2._propertyFrame)
	arg0_2._torpedoPower = arg0_2:findTF("torpedo/Text", arg0_2._propertyFrame)
	arg0_2._AAPower = arg0_2:findTF("antiaircraft/Text", arg0_2._propertyFrame)
	arg0_2._airPower = arg0_2:findTF("air/Text", arg0_2._propertyFrame)
	arg0_2._cost = arg0_2:findTF("cost/Text", arg0_2._propertyFrame)
	arg0_2._mainGS = arg0_2:findTF("gear_score/main/Text")
	arg0_2._vanguardGS = arg0_2:findTF("gear_score/vanguard/Text")
	arg0_2._airDominanceFrame = arg0_2:findTF("ac", arg0_2._propertyFrame)

	if arg0_2._airDominanceFrame then
		setActive(arg0_2._airDominanceFrame, false)
	end

	arg0_2._attrFrame = arg0_2:findTF("attr_frame", arg0_2._blurLayer)
	arg0_2._cardTpl = arg0_2._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0_2._cards = {}
	arg0_2._cards[TeamType.Main] = {}
	arg0_2._cards[TeamType.Vanguard] = {}

	setActive(arg0_2._attrFrame, false)
	setActive(arg0_2._cardTpl, false)
	setAnchoredPosition(arg0_2._bottomPanel, {
		y = -90
	})

	arg0_2._formationLogic = BaseFormation.New(arg0_2._tf, arg0_2._heroContainer, arg0_2._heroInfoTpl, arg0_2._gridTFs)

	arg0_2:Register()
end

function var0_0.Register(arg0_3)
	arg0_3._formationLogic:AddHeroInfoModify(function(arg0_4, arg1_4)
		local var0_4 = arg1_4:getConfigTable()
		local var1_4 = pg.ship_data_template[arg1_4.configId]
		local var2_4 = findTF(arg0_4, "info")
		local var3_4 = findTF(var2_4, "stars")
		local var4_4 = arg1_4:getStar()

		for iter0_4 = 1, var4_4 do
			cloneTplTo(arg0_3._starTpl, var3_4)
		end

		local var5_4 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_4:getShipType()))

		if not var5_4 then
			warning("找不到船形, shipConfigId: " .. arg1_4.configId)
		end

		setImageSprite(findTF(var2_4, "type"), var5_4, true)
		setText(findTF(var2_4, "frame/lv_contain/lv"), arg1_4.level)
	end)
	arg0_3._formationLogic:AddLongPress(function(arg0_5, arg1_5, arg2_5)
		arg0_3:emit(DefenseFormationMedator.OPEN_SHIP_INFO, arg1_5.id, arg2_5, var0_0.TOGGLE_FORMATION)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_3._formationLogic:AddClick(function(arg0_6, arg1_6)
		arg0_3:emit(DefenseFormationMedator.CHANGE_FLEET_SHIP, arg0_6, arg1_6)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_3._formationLogic:AddBeginDrag(function(arg0_7)
		local var0_7 = findTF(arg0_7, "info")

		setButtonEnabled(arg0_3.backBtn, false)
		setToggleEnabled(arg0_3._detailToggle, false)
		SetActive(var0_7, false)
	end)
	arg0_3._formationLogic:AddEndDrag(function(arg0_8)
		local var0_8 = findTF(arg0_8, "info")

		setButtonEnabled(arg0_3.backBtn, true)
		setToggleEnabled(arg0_3._detailToggle, true)
		SetActive(var0_8, true)
	end)
	arg0_3._formationLogic:AddShiftOnly(function(arg0_9)
		arg0_3:emit(DefenseFormationMedator.CHANGE_FLEET_SHIPS_ORDER, arg0_9)
	end)
	arg0_3._formationLogic:AddRemoveShip(function(arg0_10, arg1_10)
		arg0_3:emit(DefenseFormationMedator.REMOVE_SHIP, arg0_10, arg1_10)
	end)

	local function var0_3(arg0_11)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("defense_formation_tip_npc"),
			onYes = arg0_11,
			onNo = arg0_11
		})
	end

	arg0_3._formationLogic:AddCheckRemove(function(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
		if not arg3_12:canRemove(arg2_12) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2_12:getName(), "", Fleet.C_TEAM_NAME[arg4_12]))
			arg0_12()
		elseif table.getCount(arg3_12.mainShips) == 1 and arg4_12 == TeamType.Main or table.getCount(arg3_12.vanguardShips) == 1 and arg4_12 == TeamType.Vanguard then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("exercise_clear_fleet_tip"),
				onYes = function()
					if not getProxy(FleetProxy):getFleetById(1):ExistActNpcShip() then
						arg1_12()
					else
						var0_3(arg0_12)
					end
				end,
				onNo = arg0_12
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				zIndex = -30,
				hideNo = false,
				content = i18n("ship_formationUI_quest_remove", arg2_12:getName()),
				onYes = arg1_12,
				onNo = arg0_12
			})
		end
	end)
	arg0_3._formationLogic:AddGridTipClick(function(arg0_14, arg1_14)
		arg0_3:emit(DefenseFormationMedator.CHANGE_FLEET_SHIP, nil, arg0_14)
	end)
end

function var0_0.setShips(arg0_15, arg1_15)
	arg0_15.shipVOs = arg1_15

	arg0_15._formationLogic:SetShipVOs(arg1_15)
end

function var0_0.SetFleet(arg0_16, arg1_16)
	arg0_16._currentFleetVO = arg1_16

	arg0_16._formationLogic:SetFleetVO(arg1_16)
end

function var0_0.UpdateFleetView(arg0_17, arg1_17)
	arg0_17:displayFleetInfo()
	arg0_17._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0_17._formationLogic:ResetGrid(TeamType.Main)
	arg0_17:resetFormationComponent()
	arg0_17:updateAttrFrame()

	if arg1_17 then
		arg0_17._formationLogic:LoadAllCharacter()
	else
		arg0_17._formationLogic:SetAllCharacterPos()
	end
end

function var0_0.SetFleetNameLabel(arg0_18)
	setText(arg0_18._fleetNameText, i18n("exercise_formation_title"))
end

function var0_0.didEnter(arg0_19)
	onButton(arg0_19, arg0_19.backBtn, function()
		if arg0_19._currentDragDelegate then
			LuaHelper.triggerEndDrag(arg0_19._currentDragDelegate)
		end

		if arg0_19._attrFrame.gameObject.activeSelf then
			triggerToggle(arg0_19._formationToggle, true)
		else
			local function var0_20()
				arg0_19:emit(var0_0.ON_BACK)
			end

			arg0_19:emit(DefenseFormationMedator.COMMIT_FLEET, var0_20)
		end
	end, SOUND_BACK)
	onToggle(arg0_19, arg0_19._detailToggle, function(arg0_22)
		if arg0_19._currentDragDelegate then
			LuaHelper.triggerEndDrag(arg0_19._currentDragDelegate)
		end

		if arg0_22 then
			arg0_19:displayAttrFrame()
		end
	end, SFX_PANEL)
	onToggle(arg0_19, arg0_19._formationToggle, function(arg0_23)
		if arg0_19._currentDragDelegate then
			LuaHelper.triggerEndDrag(arg0_19._currentDragDelegate)
		end

		if arg0_23 then
			arg0_19:hideAttrFrame()
		end
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19._attrFrame, function()
		triggerToggle(arg0_19._formationToggle, true)
	end, SFX_PANEL)
	arg0_19:UpdateFleetView(true)

	if arg0_19.contextData.toggle ~= nil then
		triggerToggle(arg0_19[arg0_19.contextData.toggle], true)
	end

	shiftPanel(arg0_19._bottomPanel, nil, 0, nil, 0.5, true, true)
end

function var0_0.resetFormationComponent(arg0_25)
	local var0_25 = {}

	removeAllChildren(arg0_25._buffGroup)

	for iter0_25, iter1_25 in ipairs(var0_25) do
		local var1_25 = cloneTplTo(arg0_25._buffModel, arg0_25._buffGroup)

		tf(var1_25):SetAsFirstSibling()
		SetActive(var1_25:Find("dot_list/" .. iter1_25.type), true)

		var1_25:Find("buff_describe"):GetComponent(typeof(Text)).text = iter1_25.describe
	end

	SetActive(arg0_25._gridTFs.main[1]:Find("flag"), #arg0_25._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
end

function var0_0.shiftCard(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = arg0_26._cards[arg3_26]

	if #var0_26 > 0 then
		var0_26[arg1_26], var0_26[arg2_26] = var0_26[arg2_26], var0_26[arg1_26]
	end

	arg0_26._shiftIndex = arg2_26
end

function var0_0.sortCardSiblingIndex(arg0_27)
	local var0_27 = arg0_27._cards[TeamType.Main]
	local var1_27 = arg0_27._cards[TeamType.Vanguard]

	if #var0_27 > 0 or #var1_27 > 0 then
		for iter0_27 = 1, #var0_27 do
			var0_27[iter0_27].tr:SetSiblingIndex(iter0_27)
		end

		for iter1_27 = 1, #var1_27 do
			var1_27[iter1_27].tr:SetSiblingIndex(iter1_27)
		end
	end
end

function var0_0.displayFleetInfo(arg0_28)
	local var0_28 = arg0_28._currentFleetVO:GetPropertiesSum()
	local var1_28 = arg0_28._currentFleetVO:GetGearScoreSum(TeamType.Vanguard)
	local var2_28 = arg0_28._currentFleetVO:GetGearScoreSum(TeamType.Main)
	local var3_28 = arg0_28._currentFleetVO:GetCostSum()

	arg0_28.tweenNumText(arg0_28._cannonPower, var0_28.cannon)
	arg0_28.tweenNumText(arg0_28._torpedoPower, var0_28.torpedo)
	arg0_28.tweenNumText(arg0_28._AAPower, var0_28.antiAir)
	arg0_28.tweenNumText(arg0_28._airPower, var0_28.air)
	arg0_28.tweenNumText(arg0_28._cost, var3_28.oil)
	arg0_28.tweenNumText(arg0_28._vanguardGS, var1_28)
	arg0_28.tweenNumText(arg0_28._mainGS, var2_28)
	setActive(arg0_28:findTF("gear_score"), true)
	arg0_28:SetFleetNameLabel()
end

function var0_0.hideAttrFrame(arg0_29)
	SetActive(arg0_29._attrFrame, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_29._blurLayer, arg0_29._tf)
end

function var0_0.displayAttrFrame(arg0_30)
	pg.UIMgr.GetInstance():BlurPanel(arg0_30._blurLayer, false)
	SetActive(arg0_30._attrFrame, true)
	arg0_30:initAttrFrame()
end

function var0_0.initAttrFrame(arg0_31)
	local var0_31 = {
		[TeamType.Main] = "main",
		[TeamType.Vanguard] = "vanguard"
	}
	local var1_31 = {
		[TeamType.Main] = arg0_31._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_31._currentFleetVO.vanguardShips
	}
	local var2_31 = false

	for iter0_31, iter1_31 in pairs(var1_31) do
		local var3_31 = arg0_31._cards[iter0_31]

		if #var3_31 == 0 then
			local var4_31 = arg0_31:findTF(var0_31[iter0_31] .. "/list", arg0_31._attrFrame)

			for iter2_31 = 1, 3 do
				local var5_31 = cloneTplTo(arg0_31._cardTpl, var4_31).gameObject

				table.insert(var3_31, FormationCard.New(var5_31))
			end

			var2_31 = true
		end
	end

	if var2_31 then
		arg0_31:updateAttrFrame()
	end
end

function var0_0.updateAttrFrame(arg0_32)
	local var0_32 = {
		[TeamType.Main] = arg0_32._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_32._currentFleetVO.vanguardShips
	}

	for iter0_32, iter1_32 in pairs(var0_32) do
		local var1_32 = arg0_32._cards[iter0_32]

		if #var1_32 > 0 then
			for iter2_32 = 1, 3 do
				if iter2_32 <= #iter1_32 then
					local var2_32 = arg0_32.shipVOs[iter1_32[iter2_32]]

					var1_32[iter2_32]:update(var2_32)
					var1_32[iter2_32]:updateProps(arg0_32:getCardAttrProps(var2_32))
				else
					var1_32[iter2_32]:update(nil)
				end

				arg0_32:attachOnCardButton(var1_32[iter2_32], iter0_32)
			end
		end
	end

	arg0_32:updateUltimateTitle()
	setActive(arg0_32:findTF(TeamType.Submarine, arg0_32._attrFrame), false)
end

function var0_0.updateUltimateTitle(arg0_33)
	local var0_33 = arg0_33._cards[TeamType.Main]

	if #var0_33 > 0 then
		for iter0_33 = 1, #var0_33 do
			setActive(var0_33[iter0_33].shipState, iter0_33 == 1)
		end
	end

	local var1_33 = arg0_33._cards[TeamType.Vanguard]

	if #var1_33 > 0 then
		for iter1_33 = 1, #var1_33 do
			setActive(var1_33[iter1_33].shipState, false)
		end
	end
end

function var0_0.getCardAttrProps(arg0_34, arg1_34)
	local var0_34 = arg1_34:getProperties()
	local var1_34 = arg1_34:getShipCombatPower()
	local var2_34 = arg1_34:getBattleTotalExpend()

	return {
		{
			i18n("word_attr_durability"),
			tostring(math.floor(var0_34.durability))
		},
		{
			i18n("word_attr_luck"),
			"" .. tostring(math.floor(var2_34))
		},
		{
			i18n("word_synthesize_power"),
			"<color=#ffff00>" .. var1_34 .. "</color>"
		}
	}
end

function var0_0.attachOnCardButton(arg0_35, arg1_35, arg2_35)
	local var0_35 = GetOrAddComponent(arg1_35.go, "EventTriggerListener")

	arg0_35.eventTriggers[var0_35] = true

	var0_35:RemovePointClickFunc()
	var0_35:RemoveBeginDragFunc()
	var0_35:RemoveDragFunc()
	var0_35:RemoveDragEndFunc()
	var0_35:AddPointClickFunc(function(arg0_36, arg1_36)
		if not arg0_35.carddrag and arg0_36 == arg1_35.go then
			if arg1_35.shipVO then
				arg0_35:emit(DefenseFormationMedator.OPEN_SHIP_INFO, arg1_35.shipVO.id, arg0_35._currentFleetVO, var0_0.TOGGLE_DETAIL)
			else
				arg0_35:emit(DefenseFormationMedator.CHANGE_FLEET_SHIP, arg1_35.shipVO, arg2_35)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end)

	if arg1_35.shipVO then
		local var1_35 = arg0_35._cards[arg2_35]
		local var2_35 = arg1_35.tr.parent:GetComponent("ContentSizeFitter")
		local var3_35 = arg1_35.tr.parent:GetComponent("HorizontalLayoutGroup")
		local var4_35 = arg1_35.tr.rect.width * 0.5
		local var5_35
		local var6_35 = 0
		local var7_35 = {}

		local function var8_35()
			for iter0_37 = 1, #var1_35 do
				if var1_35[iter0_37] ~= arg1_35 then
					var1_35[iter0_37].tr.anchoredPosition = var1_35[iter0_37].tr.anchoredPosition * 0.5 + Vector2(var7_35[iter0_37].x, var7_35[iter0_37].y) * 0.5
				end
			end

			if var5_35 and var6_35 <= Time.realtimeSinceStartup then
				var0_35:OnDrag(var5_35)

				var5_35 = nil
			end
		end

		local function var9_35()
			for iter0_38 = 1, #var1_35 do
				var1_35[iter0_38].tr.anchoredPosition = var7_35[iter0_38]
			end
		end

		local var10_35 = Timer.New(var8_35, 0.0333333333333333, -1)

		var0_35:AddBeginDragFunc(function()
			if arg0_35.carddrag then
				return
			end

			arg0_35._currentDragDelegate = var0_35
			arg0_35.carddrag = arg1_35
			var2_35.enabled = false
			var3_35.enabled = false

			arg1_35.tr:SetSiblingIndex(#var1_35)

			for iter0_39 = 1, #var1_35 do
				if var1_35[iter0_39] == arg1_35 then
					arg0_35._shiftIndex = iter0_39
				end

				var7_35[iter0_39] = var1_35[iter0_39].tr.anchoredPosition
			end

			var10_35:Start()
			LeanTween.scale(arg1_35.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		end)
		var0_35:AddDragFunc(function(arg0_40, arg1_40)
			if arg0_35.carddrag ~= arg1_35 then
				return
			end

			local var0_40 = arg1_35.tr.localPosition

			var0_40.x = arg0_35:change2ScrPos(arg1_35.tr.parent, arg1_40.position).x
			arg1_35.tr.localPosition = var0_40

			if var6_35 > Time.realtimeSinceStartup then
				var5_35 = arg1_40

				return
			end

			local var1_40 = 1

			for iter0_40 = 1, #var1_35 do
				if var1_35[iter0_40] ~= arg1_35 and var1_35[iter0_40].shipVO and arg1_35.tr.localPosition.x > var1_35[iter0_40].tr.localPosition.x + (var1_40 < arg0_35._shiftIndex and 1.1 or -1.1) * var4_35 then
					var1_40 = var1_40 + 1
				end
			end

			if arg0_35._shiftIndex ~= var1_40 then
				arg0_35._formationLogic:Shift(arg0_35._shiftIndex, var1_40, arg2_35)
				arg0_35:shiftCard(arg0_35._shiftIndex, var1_40, arg2_35)

				var6_35 = Time.realtimeSinceStartup + 0.15
			end
		end)
		var0_35:AddDragEndFunc(function(arg0_41, arg1_41)
			if arg0_35.carddrag ~= arg1_35 then
				return
			end

			arg0_35._currentDragDelegate = nil
			var0_35.enabled = false

			local var0_41 = math.min(math.abs(arg1_35.tr.anchoredPosition.x - var7_35[arg0_35._shiftIndex].x) / 200, 1) * 0.3

			LeanTween.value(arg1_35.go, arg1_35.tr.anchoredPosition.x, var7_35[arg0_35._shiftIndex].x, var0_41):setEase(LeanTweenType.easeOutCubic):setOnUpdate(System.Action_float(function(arg0_42)
				local var0_42 = arg1_35.tr.anchoredPosition

				var0_42.x = arg0_42
				arg1_35.tr.anchoredPosition = var0_42
			end)):setOnComplete(System.Action(function()
				var9_35()

				var2_35.enabled = true
				var3_35.enabled = true
				arg0_35._shiftIndex = nil

				var10_35:Stop()
				arg0_35:updateUltimateTitle()
				arg0_35._formationLogic:SortSiblingIndex()
				arg0_35:sortCardSiblingIndex()
				arg0_35:emit(DefenseFormationMedator.CHANGE_FLEET_SHIPS_ORDER, arg0_35._currentFleetVO)
				LeanTween.scale(arg1_35.paintingTr, Vector3(1, 1, 0), 0.3)

				var0_35.enabled = true
				arg0_35.carddrag = nil
			end))
		end)
	end
end

function var0_0.change2ScrPos(arg0_44, arg1_44, arg2_44)
	local var0_44 = GameObject.Find("OverlayCamera"):GetComponent("Camera")

	return (LuaHelper.ScreenToLocal(arg1_44, arg2_44, var0_44))
end

function var0_0.tweenNumText(arg0_45, arg1_45, arg2_45)
	LeanTween.value(go(arg0_45), 0, math.floor(arg1_45), arg2_45 or 0.7):setOnUpdate(System.Action_float(function(arg0_46)
		setText(arg0_45, math.floor(arg0_46))
	end))
end

function var0_0.GetFleetCount(arg0_47)
	return 1
end

function var0_0.recyclePainting(arg0_48)
	for iter0_48, iter1_48 in pairs(arg0_48._cards) do
		for iter2_48, iter3_48 in ipairs(iter1_48) do
			iter3_48:clear()
		end
	end
end

function var0_0.willExit(arg0_49)
	if arg0_49.eventTriggers then
		for iter0_49, iter1_49 in pairs(arg0_49.eventTriggers) do
			ClearEventTrigger(iter0_49)
		end

		arg0_49.eventTriggers = nil
	end

	if arg0_49._attrFrame.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_49._blurLayer, arg0_49._tf)
	end

	pg.TimeMgr.GetInstance():RemoveTimer(arg0_49.ActiveToggletimer1)

	arg0_49.ActiveToggletimer1 = nil

	pg.TimeMgr.GetInstance():RemoveTimer(arg0_49.ActiveToggletimer)

	arg0_49.ActiveToggletimer = nil

	arg0_49._formationLogic:Destroy()
	arg0_49:recyclePainting()
end

return var0_0
