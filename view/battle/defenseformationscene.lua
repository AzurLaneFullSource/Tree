local var0 = class("DefenseFormationScene", import("..base.BaseUI"))

var0.RADIUS = 60
var0.LONGPRESS_Y = 30
var0.INTERVAL = math.pi / 2 / 6
var0.MAX_FLEET_NUM = 6
var0.MAX_SHIPP_NUM = 5
var0.TOGGLE_DETAIL = "_detailToggle"
var0.TOGGLE_FORMATION = "_formationToggle"
var0.BUFF_TYEP = {
	blue = "blue",
	pink = "pink",
	cyan = "cyan"
}

function var0.getUIName(arg0)
	return "ExerciseFormationUI"
end

function var0.init(arg0)
	arg0.eventTriggers = {}
	arg0._blurLayer = arg0:findTF("blur_panel")
	arg0.backBtn = arg0:findTF("top/back_btn", arg0._blurLayer)
	arg0._bottomPanel = arg0:findTF("bottom", arg0._blurLayer)
	arg0._detailToggle = arg0:findTF("toggle_list/detail_toggle", arg0._bottomPanel)
	arg0._formationToggle = arg0:findTF("toggle_list/formation_toggle", arg0._bottomPanel)
	arg0._starTpl = arg0:findTF("star_tpl")
	arg0._heroInfoTpl = arg0:findTF("heroInfo")
	arg0._gridTFs = {
		vanguard = {},
		main = {}
	}
	arg0._gridFrame = arg0:findTF("GridFrame")

	for iter0 = 1, 3 do
		arg0._gridTFs[TeamType.Main][iter0] = arg0._gridFrame:Find("main_" .. iter0)
		arg0._gridTFs[TeamType.Vanguard][iter0] = arg0._gridFrame:Find("vanguard_" .. iter0)
	end

	arg0._heroContainer = arg0:findTF("HeroContainer")
	arg0._fleetInfo = arg0:findTF("fleet_info", arg0._blurLayer)
	arg0._fleetNameText = arg0:findTF("fleet_name/Text", arg0._fleetInfo)
	arg0._buffPanel = arg0:findTF("buff_list")
	arg0._buffGroup = arg0:findTF("buff_group", arg0._buffPanel)
	arg0._buffModel = arg0:getTpl("buff_model", arg0._buffPanel)
	arg0._propertyFrame = arg0:findTF("property_frame", arg0._blurLayer)
	arg0._cannonPower = arg0:findTF("cannon/Text", arg0._propertyFrame)
	arg0._torpedoPower = arg0:findTF("torpedo/Text", arg0._propertyFrame)
	arg0._AAPower = arg0:findTF("antiaircraft/Text", arg0._propertyFrame)
	arg0._airPower = arg0:findTF("air/Text", arg0._propertyFrame)
	arg0._cost = arg0:findTF("cost/Text", arg0._propertyFrame)
	arg0._mainGS = arg0:findTF("gear_score/main/Text")
	arg0._vanguardGS = arg0:findTF("gear_score/vanguard/Text")
	arg0._airDominanceFrame = arg0:findTF("ac", arg0._propertyFrame)

	if arg0._airDominanceFrame then
		setActive(arg0._airDominanceFrame, false)
	end

	arg0._attrFrame = arg0:findTF("attr_frame", arg0._blurLayer)
	arg0._cardTpl = arg0._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0._cards = {}
	arg0._cards[TeamType.Main] = {}
	arg0._cards[TeamType.Vanguard] = {}

	setActive(arg0._attrFrame, false)
	setActive(arg0._cardTpl, false)
	setAnchoredPosition(arg0._bottomPanel, {
		y = -90
	})

	arg0._formationLogic = BaseFormation.New(arg0._tf, arg0._heroContainer, arg0._heroInfoTpl, arg0._gridTFs)

	arg0:Register()
end

function var0.Register(arg0)
	arg0._formationLogic:AddHeroInfoModify(function(arg0, arg1)
		local var0 = arg1:getConfigTable()
		local var1 = pg.ship_data_template[arg1.configId]
		local var2 = findTF(arg0, "info")
		local var3 = findTF(var2, "stars")
		local var4 = arg1:getStar()

		for iter0 = 1, var4 do
			cloneTplTo(arg0._starTpl, var3)
		end

		local var5 = GetSpriteFromAtlas("shiptype", shipType2print(arg1:getShipType()))

		if not var5 then
			warning("找不到船形, shipConfigId: " .. arg1.configId)
		end

		setImageSprite(findTF(var2, "type"), var5, true)
		setText(findTF(var2, "frame/lv_contain/lv"), arg1.level)
	end)
	arg0._formationLogic:AddLongPress(function(arg0, arg1, arg2)
		arg0:emit(DefenseFormationMedator.OPEN_SHIP_INFO, arg1.id, arg2, var0.TOGGLE_FORMATION)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0._formationLogic:AddClick(function(arg0, arg1)
		arg0:emit(DefenseFormationMedator.CHANGE_FLEET_SHIP, arg0, arg1)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0._formationLogic:AddBeginDrag(function(arg0)
		local var0 = findTF(arg0, "info")

		setButtonEnabled(arg0.backBtn, false)
		setToggleEnabled(arg0._detailToggle, false)
		SetActive(var0, false)
	end)
	arg0._formationLogic:AddEndDrag(function(arg0)
		local var0 = findTF(arg0, "info")

		setButtonEnabled(arg0.backBtn, true)
		setToggleEnabled(arg0._detailToggle, true)
		SetActive(var0, true)
	end)
	arg0._formationLogic:AddShiftOnly(function(arg0)
		arg0:emit(DefenseFormationMedator.CHANGE_FLEET_SHIPS_ORDER, arg0)
	end)
	arg0._formationLogic:AddRemoveShip(function(arg0, arg1)
		arg0:emit(DefenseFormationMedator.REMOVE_SHIP, arg0, arg1)
	end)

	local function var0(arg0)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("defense_formation_tip_npc"),
			onYes = arg0,
			onNo = arg0
		})
	end

	arg0._formationLogic:AddCheckRemove(function(arg0, arg1, arg2, arg3, arg4)
		if not arg3:canRemove(arg2) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2:getName(), "", Fleet.C_TEAM_NAME[arg4]))
			arg0()
		elseif table.getCount(arg3.mainShips) == 1 and arg4 == TeamType.Main or table.getCount(arg3.vanguardShips) == 1 and arg4 == TeamType.Vanguard then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("exercise_clear_fleet_tip"),
				onYes = function()
					if not getProxy(FleetProxy):getFleetById(1):ExistActNpcShip() then
						arg1()
					else
						var0(arg0)
					end
				end,
				onNo = arg0
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				zIndex = -30,
				hideNo = false,
				content = i18n("ship_formationUI_quest_remove", arg2:getName()),
				onYes = arg1,
				onNo = arg0
			})
		end
	end)
	arg0._formationLogic:AddGridTipClick(function(arg0, arg1)
		arg0:emit(DefenseFormationMedator.CHANGE_FLEET_SHIP, nil, arg0)
	end)
end

function var0.setShips(arg0, arg1)
	arg0.shipVOs = arg1

	arg0._formationLogic:SetShipVOs(arg1)
end

function var0.SetFleet(arg0, arg1)
	arg0._currentFleetVO = arg1

	arg0._formationLogic:SetFleetVO(arg1)
end

function var0.UpdateFleetView(arg0, arg1)
	arg0:displayFleetInfo()
	arg0._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0._formationLogic:ResetGrid(TeamType.Main)
	arg0:resetFormationComponent()
	arg0:updateAttrFrame()

	if arg1 then
		arg0._formationLogic:LoadAllCharacter()
	else
		arg0._formationLogic:SetAllCharacterPos()
	end
end

function var0.SetFleetNameLabel(arg0)
	setText(arg0._fleetNameText, i18n("exercise_formation_title"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		if arg0._currentDragDelegate then
			LuaHelper.triggerEndDrag(arg0._currentDragDelegate)
		end

		if arg0._attrFrame.gameObject.activeSelf then
			triggerToggle(arg0._formationToggle, true)
		else
			local var0 = function()
				arg0:emit(var0.ON_BACK)
			end

			arg0:emit(DefenseFormationMedator.COMMIT_FLEET, var0)
		end
	end, SOUND_BACK)
	onToggle(arg0, arg0._detailToggle, function(arg0)
		if arg0._currentDragDelegate then
			LuaHelper.triggerEndDrag(arg0._currentDragDelegate)
		end

		if arg0 then
			arg0:displayAttrFrame()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0._formationToggle, function(arg0)
		if arg0._currentDragDelegate then
			LuaHelper.triggerEndDrag(arg0._currentDragDelegate)
		end

		if arg0 then
			arg0:hideAttrFrame()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0._attrFrame, function()
		triggerToggle(arg0._formationToggle, true)
	end, SFX_PANEL)
	arg0:UpdateFleetView(true)

	if arg0.contextData.toggle ~= nil then
		triggerToggle(arg0[arg0.contextData.toggle], true)
	end

	shiftPanel(arg0._bottomPanel, nil, 0, nil, 0.5, true, true)
end

function var0.resetFormationComponent(arg0)
	local var0 = {}

	removeAllChildren(arg0._buffGroup)

	for iter0, iter1 in ipairs(var0) do
		local var1 = cloneTplTo(arg0._buffModel, arg0._buffGroup)

		tf(var1):SetAsFirstSibling()
		SetActive(var1:Find("dot_list/" .. iter1.type), true)

		var1:Find("buff_describe"):GetComponent(typeof(Text)).text = iter1.describe
	end

	SetActive(arg0._gridTFs.main[1]:Find("flag"), #arg0._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
end

function var0.shiftCard(arg0, arg1, arg2, arg3)
	local var0 = arg0._cards[arg3]

	if #var0 > 0 then
		var0[arg1], var0[arg2] = var0[arg2], var0[arg1]
	end

	arg0._shiftIndex = arg2
end

function var0.sortCardSiblingIndex(arg0)
	local var0 = arg0._cards[TeamType.Main]
	local var1 = arg0._cards[TeamType.Vanguard]

	if #var0 > 0 or #var1 > 0 then
		for iter0 = 1, #var0 do
			var0[iter0].tr:SetSiblingIndex(iter0)
		end

		for iter1 = 1, #var1 do
			var1[iter1].tr:SetSiblingIndex(iter1)
		end
	end
end

function var0.displayFleetInfo(arg0)
	local var0 = arg0._currentFleetVO:GetPropertiesSum()
	local var1 = arg0._currentFleetVO:GetGearScoreSum(TeamType.Vanguard)
	local var2 = arg0._currentFleetVO:GetGearScoreSum(TeamType.Main)
	local var3 = arg0._currentFleetVO:GetCostSum()

	arg0.tweenNumText(arg0._cannonPower, var0.cannon)
	arg0.tweenNumText(arg0._torpedoPower, var0.torpedo)
	arg0.tweenNumText(arg0._AAPower, var0.antiAir)
	arg0.tweenNumText(arg0._airPower, var0.air)
	arg0.tweenNumText(arg0._cost, var3.oil)
	arg0.tweenNumText(arg0._vanguardGS, var1)
	arg0.tweenNumText(arg0._mainGS, var2)
	setActive(arg0:findTF("gear_score"), true)
	arg0:SetFleetNameLabel()
end

function var0.hideAttrFrame(arg0)
	SetActive(arg0._attrFrame, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._blurLayer, arg0._tf)
end

function var0.displayAttrFrame(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._blurLayer, false)
	SetActive(arg0._attrFrame, true)
	arg0:initAttrFrame()
end

function var0.initAttrFrame(arg0)
	local var0 = {
		[TeamType.Main] = "main",
		[TeamType.Vanguard] = "vanguard"
	}
	local var1 = {
		[TeamType.Main] = arg0._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0._currentFleetVO.vanguardShips
	}
	local var2 = false

	for iter0, iter1 in pairs(var1) do
		local var3 = arg0._cards[iter0]

		if #var3 == 0 then
			local var4 = arg0:findTF(var0[iter0] .. "/list", arg0._attrFrame)

			for iter2 = 1, 3 do
				local var5 = cloneTplTo(arg0._cardTpl, var4).gameObject

				table.insert(var3, FormationCard.New(var5))
			end

			var2 = true
		end
	end

	if var2 then
		arg0:updateAttrFrame()
	end
end

function var0.updateAttrFrame(arg0)
	local var0 = {
		[TeamType.Main] = arg0._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0._currentFleetVO.vanguardShips
	}

	for iter0, iter1 in pairs(var0) do
		local var1 = arg0._cards[iter0]

		if #var1 > 0 then
			for iter2 = 1, 3 do
				if iter2 <= #iter1 then
					local var2 = arg0.shipVOs[iter1[iter2]]

					var1[iter2]:update(var2)
					var1[iter2]:updateProps(arg0:getCardAttrProps(var2))
				else
					var1[iter2]:update(nil)
				end

				arg0:attachOnCardButton(var1[iter2], iter0)
			end
		end
	end

	arg0:updateUltimateTitle()
	setActive(arg0:findTF(TeamType.Submarine, arg0._attrFrame), false)
end

function var0.updateUltimateTitle(arg0)
	local var0 = arg0._cards[TeamType.Main]

	if #var0 > 0 then
		for iter0 = 1, #var0 do
			setActive(var0[iter0].shipState, iter0 == 1)
		end
	end

	local var1 = arg0._cards[TeamType.Vanguard]

	if #var1 > 0 then
		for iter1 = 1, #var1 do
			setActive(var1[iter1].shipState, false)
		end
	end
end

function var0.getCardAttrProps(arg0, arg1)
	local var0 = arg1:getProperties()
	local var1 = arg1:getShipCombatPower()
	local var2 = arg1:getBattleTotalExpend()

	return {
		{
			i18n("word_attr_durability"),
			tostring(math.floor(var0.durability))
		},
		{
			i18n("word_attr_luck"),
			"" .. tostring(math.floor(var2))
		},
		{
			i18n("word_synthesize_power"),
			"<color=#ffff00>" .. var1 .. "</color>"
		}
	}
end

function var0.attachOnCardButton(arg0, arg1, arg2)
	local var0 = GetOrAddComponent(arg1.go, "EventTriggerListener")

	arg0.eventTriggers[var0] = true

	var0:RemovePointClickFunc()
	var0:RemoveBeginDragFunc()
	var0:RemoveDragFunc()
	var0:RemoveDragEndFunc()
	var0:AddPointClickFunc(function(arg0, arg1)
		if not arg0.carddrag and arg0 == arg1.go then
			if arg1.shipVO then
				arg0:emit(DefenseFormationMedator.OPEN_SHIP_INFO, arg1.shipVO.id, arg0._currentFleetVO, var0.TOGGLE_DETAIL)
			else
				arg0:emit(DefenseFormationMedator.CHANGE_FLEET_SHIP, arg1.shipVO, arg2)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end)

	if arg1.shipVO then
		local var1 = arg0._cards[arg2]
		local var2 = arg1.tr.parent:GetComponent("ContentSizeFitter")
		local var3 = arg1.tr.parent:GetComponent("HorizontalLayoutGroup")
		local var4 = arg1.tr.rect.width * 0.5
		local var5
		local var6 = 0
		local var7 = {}

		local function var8()
			for iter0 = 1, #var1 do
				if var1[iter0] ~= arg1 then
					var1[iter0].tr.anchoredPosition = var1[iter0].tr.anchoredPosition * 0.5 + Vector2(var7[iter0].x, var7[iter0].y) * 0.5
				end
			end

			if var5 and var6 <= Time.realtimeSinceStartup then
				var0:OnDrag(var5)

				var5 = nil
			end
		end

		local function var9()
			for iter0 = 1, #var1 do
				var1[iter0].tr.anchoredPosition = var7[iter0]
			end
		end

		local var10 = Timer.New(var8, 0.0333333333333333, -1)

		var0:AddBeginDragFunc(function()
			if arg0.carddrag then
				return
			end

			arg0._currentDragDelegate = var0
			arg0.carddrag = arg1
			var2.enabled = false
			var3.enabled = false

			arg1.tr:SetSiblingIndex(#var1)

			for iter0 = 1, #var1 do
				if var1[iter0] == arg1 then
					arg0._shiftIndex = iter0
				end

				var7[iter0] = var1[iter0].tr.anchoredPosition
			end

			var10:Start()
			LeanTween.scale(arg1.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		end)
		var0:AddDragFunc(function(arg0, arg1)
			if arg0.carddrag ~= arg1 then
				return
			end

			local var0 = arg1.tr.localPosition

			var0.x = arg0:change2ScrPos(arg1.tr.parent, arg1.position).x
			arg1.tr.localPosition = var0

			if var6 > Time.realtimeSinceStartup then
				var5 = arg1

				return
			end

			local var1 = 1

			for iter0 = 1, #var1 do
				if var1[iter0] ~= arg1 and var1[iter0].shipVO and arg1.tr.localPosition.x > var1[iter0].tr.localPosition.x + (var1 < arg0._shiftIndex and 1.1 or -1.1) * var4 then
					var1 = var1 + 1
				end
			end

			if arg0._shiftIndex ~= var1 then
				arg0._formationLogic:Shift(arg0._shiftIndex, var1, arg2)
				arg0:shiftCard(arg0._shiftIndex, var1, arg2)

				var6 = Time.realtimeSinceStartup + 0.15
			end
		end)
		var0:AddDragEndFunc(function(arg0, arg1)
			if arg0.carddrag ~= arg1 then
				return
			end

			arg0._currentDragDelegate = nil
			var0.enabled = false

			local var0 = math.min(math.abs(arg1.tr.anchoredPosition.x - var7[arg0._shiftIndex].x) / 200, 1) * 0.3

			LeanTween.value(arg1.go, arg1.tr.anchoredPosition.x, var7[arg0._shiftIndex].x, var0):setEase(LeanTweenType.easeOutCubic):setOnUpdate(System.Action_float(function(arg0)
				local var0 = arg1.tr.anchoredPosition

				var0.x = arg0
				arg1.tr.anchoredPosition = var0
			end)):setOnComplete(System.Action(function()
				var9()

				var2.enabled = true
				var3.enabled = true
				arg0._shiftIndex = nil

				var10:Stop()
				arg0:updateUltimateTitle()
				arg0._formationLogic:SortSiblingIndex()
				arg0:sortCardSiblingIndex()
				arg0:emit(DefenseFormationMedator.CHANGE_FLEET_SHIPS_ORDER, arg0._currentFleetVO)
				LeanTween.scale(arg1.paintingTr, Vector3(1, 1, 0), 0.3)

				var0.enabled = true
				arg0.carddrag = nil
			end))
		end)
	end
end

function var0.change2ScrPos(arg0, arg1, arg2)
	local var0 = GameObject.Find("OverlayCamera"):GetComponent("Camera")

	return (LuaHelper.ScreenToLocal(arg1, arg2, var0))
end

function var0.tweenNumText(arg0, arg1, arg2)
	LeanTween.value(go(arg0), 0, math.floor(arg1), arg2 or 0.7):setOnUpdate(System.Action_float(function(arg0)
		setText(arg0, math.floor(arg0))
	end))
end

function var0.GetFleetCount(arg0)
	return 1
end

function var0.recyclePainting(arg0)
	for iter0, iter1 in pairs(arg0._cards) do
		for iter2, iter3 in ipairs(iter1) do
			iter3:clear()
		end
	end
end

function var0.willExit(arg0)
	if arg0.eventTriggers then
		for iter0, iter1 in pairs(arg0.eventTriggers) do
			ClearEventTrigger(iter0)
		end

		arg0.eventTriggers = nil
	end

	if arg0._attrFrame.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnblurPanel(arg0._blurLayer, arg0._tf)
	end

	pg.TimeMgr.GetInstance():RemoveTimer(arg0.ActiveToggletimer1)

	arg0.ActiveToggletimer1 = nil

	pg.TimeMgr.GetInstance():RemoveTimer(arg0.ActiveToggletimer)

	arg0.ActiveToggletimer = nil

	arg0._formationLogic:Destroy()
	arg0:recyclePainting()
end

return var0
