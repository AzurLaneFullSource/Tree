local var0_0 = class("FormationUI", import("..base.BaseUI"))

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
var0_0.TeamNum = {
	"FIRST",
	"SECOND",
	"THIRD",
	"FOURTH",
	"FIFTH",
	"SIXTH"
}

function var0_0.getUIName(arg0_1)
	return "FormationUI"
end

function var0_0.preloadUIList(arg0_2)
	return {
		arg0_2:getUIName(),
		"CommanderFormationUI"
	}
end

function var0_0.getResource(arg0_3)
	local var0_3 = {
		"shiptype",
		"energy",
		"shipframeb",
		"ui/proposeshipcard"
	}

	return table.insertto(var0_3, var0_0.super.getResource(arg0_3))
end

function var0_0.getFleetShipResList(arg0_4, arg1_4)
	local var0_4 = {}
	local var1_4 = arg0_4.shipVOs or {}

	if arg1_4 then
		_.each(arg1_4:getShipIds(), function(arg0_5)
			local var0_5 = var1_4[arg0_5]

			if var0_5 then
				local var1_5 = ResPathSupport.GetSpineCharListByPrefabName(var0_5:getPrefab())

				table.insertto(var0_4, var1_5)

				if pg.ship_skin_expression[var0_5:getPrefab()] then
					table.insert(var0_4, "paintingface/" .. var0_5:getPrefab())
				end

				local var2_5 = var0_5:getPainting()

				table.insertto(var0_4, ResPathSupport.GetPaintingListByPaintingName(var2_5))

				local var3_5 = string.format(ResPathSupport.ConstPath.BG.ShipCard, var0_5:rarity2bgPrint())

				table.insert(var0_4, var3_5)

				local var4_5, var5_5 = var0_5:GetFrameAndEffect(true)
				local var6_5 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, var5_5)

				table.insert(var0_4, var6_5)
				_.each(var0_5:getAttachmentPrefab(), function(arg0_6)
					local var0_6 = arg0_6.config
					local var1_6 = var0_6 and var0_6.orbit_ui

					if noEmptyStr(var1_6) then
						table.insert(var0_4, ys.Battle.BattleResourceManager.GetOrbitPath(var1_6))
					end
				end)
			end
		end)
	end

	return var0_4
end

function var0_0.setPlayer(arg0_7, arg1_7)
	arg0_7.player = arg1_7
end

function var0_0.setCommanderPrefabFleet(arg0_8, arg1_8)
	arg0_8.commanderPrefabFleets = arg1_8
end

function var0_0.init(arg0_9)
	arg0_9.eventTriggers = {}
	arg0_9.backBtn = arg0_9._blurLayer:Find("top/back_btn")
	arg0_9._bgFleet = arg0_9._adapt:Find("bg_fleet")
	arg0_9._bgSub = arg0_9._adapt:Find("bg_sub")
	arg0_9._bottomPanel = arg0_9._blurLayer:Find("bottom")
	arg0_9._detailToggle = arg0_9._bottomPanel:Find("toggle_list/detail_toggle")
	arg0_9._formationToggle = arg0_9._bottomPanel:Find("toggle_list/formation_toggle")
	arg0_9._nextPage = arg0_9._adapt:Find("nextPage")
	arg0_9._prevPage = arg0_9._adapt:Find("prevPage")
	arg0_9._starTpl = arg0_9._tf:Find("star_tpl")
	arg0_9._heroInfoTpl = arg0_9._tf:Find("heroInfo")
	arg0_9.topPanel = arg0_9._blurLayer:Find("top")
	arg0_9._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0_9._gridFrame = arg0_9._adapt:Find("GridFrame")

	for iter0_9 = 1, 3 do
		arg0_9._gridTFs[TeamType.Main][iter0_9] = arg0_9._gridFrame:Find("main_" .. iter0_9)
		arg0_9._gridTFs[TeamType.Vanguard][iter0_9] = arg0_9._gridFrame:Find("vanguard_" .. iter0_9)
		arg0_9._gridTFs[TeamType.Submarine][iter0_9] = arg0_9._gridFrame:Find("submarine_" .. iter0_9)
	end

	arg0_9._heroContainer = arg0_9._adapt:Find("HeroContainer")
	arg0_9._formationLogic = BaseFormation.New(arg0_9._tf, arg0_9._heroContainer, arg0_9._heroInfoTpl, arg0_9._gridTFs)
	arg0_9._fleetInfo = arg0_9._blurLayer:Find("fleet_info")
	arg0_9._fleetNumText = arg0_9._fleetInfo:Find("fleet_number")
	arg0_9._fleetNameText = arg0_9._fleetInfo:Find("fleet_name/Text")
	arg0_9._fleetNameEditBtn = arg0_9._fleetInfo:Find("edit_btn")
	arg0_9._renamePanel = arg0_9._tf:Find("changeName_panel")
	arg0_9._renameConfirmBtn = arg0_9._renamePanel:Find("frame/queren")
	arg0_9._renameCancelBtn = arg0_9._renamePanel:Find("frame/cancel")

	setLocalPosition(arg0_9._renamePanel, {
		z = -45
	})

	arg0_9._propertyFrame = arg0_9._blurLayer:Find("property_frame")
	arg0_9._cannonPower = arg0_9._propertyFrame:Find("cannon/Text")
	arg0_9._torpedoPower = arg0_9._propertyFrame:Find("torpedo/Text")
	arg0_9._AAPower = arg0_9._propertyFrame:Find("antiaircraft/Text")
	arg0_9._airPower = arg0_9._propertyFrame:Find("air/Text")
	arg0_9._airDominance = arg0_9._propertyFrame:Find("ac/Text")
	arg0_9._cost = arg0_9._propertyFrame:Find("cost/Text")
	arg0_9._mainGS = arg0_9._adapt:Find("gear_score/main")
	arg0_9._vanguardGS = arg0_9._adapt:Find("gear_score/vanguard")
	arg0_9._subGS = arg0_9._adapt:Find("gear_score/submarine")
	arg0_9._arrUpVan = arg0_9._vanguardGS:Find("up")
	arg0_9._arrDownVan = arg0_9._vanguardGS:Find("down")
	arg0_9._arrUpMain = arg0_9._mainGS:Find("up")
	arg0_9._arrDownMain = arg0_9._mainGS:Find("down")
	arg0_9._arrUpSub = arg0_9._subGS:Find("up")
	arg0_9._arrDownSub = arg0_9._subGS:Find("down")
	arg0_9._attrFrame = arg0_9._blurLayer:Find("attr_frame")
	arg0_9._cardTpl = arg0_9._tf:Find("RectShipCardTpl")
	arg0_9._cards = {}
	arg0_9._cards[TeamType.Main] = {}
	arg0_9._cards[TeamType.Vanguard] = {}
	arg0_9._cards[TeamType.Submarine] = {}

	setActive(arg0_9._attrFrame, false)
	setActive(arg0_9._cardTpl, false)

	arg0_9.btnRegular = arg0_9._bottomPanel:Find("fleet_select/regular")
	arg0_9._regularEnFllet = arg0_9.btnRegular:Find("fleet/enFleet")
	arg0_9._regularNum = arg0_9.btnRegular:Find("fleet/num")
	arg0_9._regualrCnFleet = arg0_9.btnRegular:Find("fleet/CnFleet")
	arg0_9.btnSub = arg0_9._bottomPanel:Find("fleet_select/sub")
	arg0_9._subEnFllet = arg0_9.btnSub:Find("fleet/enFleet")
	arg0_9._subNum = arg0_9.btnSub:Find("fleet/num")
	arg0_9._subCnFleet = arg0_9.btnSub:Find("fleet/CnFleet")
	arg0_9.fleetToggleMask = arg0_9._tf:Find("blur_panel/list_mask")
	arg0_9.fleetToggleList = arg0_9.fleetToggleMask:Find("list")
	arg0_9.fleetToggles = {}

	for iter1_9 = 1, var0_0.MAX_FLEET_NUM do
		arg0_9.fleetToggles[iter1_9] = arg0_9.fleetToggleList:Find("item" .. iter1_9)
	end

	arg0_9._vanGSTxt = arg0_9._vanguardGS:Find("Text"):GetComponent("Text")
	arg0_9._mainGSTxt = arg0_9._mainGS:Find("Text"):GetComponent("Text")
	arg0_9._subGSTxt = arg0_9._subGS:Find("Text"):GetComponent("Text")
	arg0_9.prevMainGS = arg0_9.contextData.mainGS
	arg0_9.prevVanGS = arg0_9.contextData.vanGS
	arg0_9.prevSubGS = arg0_9.contextData.subGS
	arg0_9.mainGSInited = arg0_9.contextData.mainGS and true or false
	arg0_9.VanGSInited = arg0_9.contextData.vanGS and true or false
	arg0_9.SubGSInited = arg0_9.contextData.subGS and true or false
	arg0_9._vanGSTxt.text = arg0_9.prevVanGS or 0
	arg0_9._mainGSTxt.text = arg0_9.prevMainGS or 0
	arg0_9._subGSTxt.text = arg0_9.prevSubGS or 0
	arg0_9.commanderFormationPanel = CommanderFormationPage.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)
	arg0_9.index = {
		[FleetType.Normal] = 1,
		[FleetType.Submarine] = 1
	}

	setText(arg0_9._adapt:Find("gear_score/main/line/Image/text1"), i18n("pre_combat_main"))
	setText(arg0_9._adapt:Find("gear_score/vanguard/line/Image/text1"), i18n("pre_combat_vanguard"))
	setText(arg0_9._adapt:Find("gear_score/submarine/line/Image/text1"), i18n("pre_combat_submarine"))

	arg0_9.uiSuggestionBtn = arg0_9._tf:Find("blur_panel/suggestionBtn")

	setText(arg0_9.uiSuggestionBtn:Find("Text"), i18n("formation_suggestion"))
end

function var0_0.setShips(arg0_10, arg1_10)
	arg0_10.shipVOs = arg1_10

	arg0_10._formationLogic:SetShipVOs(arg0_10.shipVOs)
end

function var0_0.SetFleets(arg0_11, arg1_11)
	arg0_11._fleetVOs = _(arg1_11):chain():values():filter(function(arg0_12)
		return arg0_12:isRegularFleet()
	end):sort(function(arg0_13, arg1_13)
		return arg0_13.id < arg1_13.id
	end):value()

	if arg0_11._currentFleetVO then
		arg0_11._currentFleetVO = arg0_11:getFleetById(arg0_11._currentFleetVO.id)

		arg0_11._formationLogic:SetFleetVO(arg0_11._currentFleetVO)
	end
end

function var0_0.getFleetById(arg0_14, arg1_14)
	return _.detect(arg0_14._fleetVOs, function(arg0_15)
		return arg0_15.id == arg1_14
	end)
end

function var0_0.UpdateFleetView(arg0_16, arg1_16)
	local var0_16 = arg0_16:getFleetShipResList(arg0_16._currentFleetVO)

	SplitPackConst.DownloadByLuaArr(var0_16, function()
		if arg0_16.exited then
			return
		end

		arg0_16:updateFleetViewAfterResDownload(arg1_16)
	end)
end

function var0_0.updateFleetViewAfterResDownload(arg0_18, arg1_18)
	arg0_18:displayFleetInfo()
	arg0_18:updateFleetBg()
	arg0_18._formationLogic:UpdateGridVisibility()
	arg0_18._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0_18._formationLogic:ResetGrid(TeamType.Main)
	arg0_18._formationLogic:ResetGrid(TeamType.Submarine)
	arg0_18:resetFormationComponent()
	arg0_18:updateAttrFrame()
	arg0_18:updateFleetButton()

	if arg1_18 then
		arg0_18._formationLogic:LoadAllCharacter()
	else
		arg0_18._formationLogic:SetAllCharacterPos()
	end
end

function var0_0.updateFleetBg(arg0_19)
	local var0_19 = arg0_19._currentFleetVO:getFleetType()

	setActive(arg0_19._bgFleet, var0_19 == FleetType.Normal)
	setActive(arg0_19._bgSub, var0_19 == FleetType.Submarine)
end

function var0_0.updateFleetButton(arg0_20)
	local var0_20
	local var1_20 = arg0_20._currentFleetVO:getFleetType()

	arg0_20.index[var1_20] = arg0_20._currentFleetVO:getIndex()

	local var2_20 = arg0_20.index[FleetType.Normal]

	setText(arg0_20._regularEnFllet, var0_0.TeamNum[var2_20] .. " FLEET")
	setText(arg0_20._regualrCnFleet, Fleet.DEFAULT_NAME[var2_20])
	setText(arg0_20._regularNum, var2_20)

	local var3_20 = arg0_20.index[FleetType.Submarine]

	setText(arg0_20._subEnFllet, var0_0.TeamNum[var3_20] .. " FLEET")
	setText(arg0_20._subCnFleet, Fleet.DEFAULT_NAME[var3_20])
	setText(arg0_20._subNum, var3_20)
	setActive(arg0_20.btnRegular:Find("on"), var1_20 == FleetType.Normal)
	setActive(arg0_20.btnRegular:Find("off"), var1_20 ~= FleetType.Normal)
	setActive(arg0_20.btnSub:Find("on"), var1_20 == FleetType.Submarine)
	setActive(arg0_20.btnSub:Find("off"), var1_20 ~= FleetType.Submarine)
end

function var0_0.SetFleetNameLabel(arg0_21)
	setText(arg0_21._fleetNameText, arg0_21.defaultFleetName(arg0_21._currentFleetVO))
end

function var0_0.ForceDropChar(arg0_22)
	arg0_22._formationLogic:ForceDropChar()

	if arg0_22._currentDragDelegate then
		arg0_22._forceDropCharacter = true

		LuaHelper.triggerEndDrag(arg0_22._currentDragDelegate)
	end
end

function var0_0.quickExitFunc(arg0_23)
	arg0_23:ForceDropChar()

	local function var0_23()
		GetOrAddComponent(arg0_23._tf, typeof(CanvasGroup)).interactable = false

		arg0_23:emit(var0_0.ON_HOME)
	end

	arg0_23:emit(FormationMediator.COMMIT_FLEET, var0_23)
end

function var0_0.OnVisible(arg0_25)
	if arg0_25._currentFleetVO then
		arg0_25:UpdateFleetView(true)
	end
end

function var0_0.didEnter(arg0_26)
	arg0_26.isOpenCommander = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_26.player.level, "CommanderCatMediator") and not LOCK_COMMANDER

	local var0_26 = getProxy(ActivityProxy):getBuffShipList()

	arg0_26._formationLogic:AddHeroInfoModify(function(arg0_27, arg1_27)
		local var0_27 = arg1_27:getConfigTable()
		local var1_27 = pg.ship_data_template[arg1_27.configId]
		local var2_27 = findTF(arg0_27, "info")
		local var3_27 = findTF(var2_27, "stars")
		local var4_27 = findTF(var2_27, "energy")
		local var5_27 = arg1_27:getStar()

		for iter0_27 = 1, var5_27 do
			cloneTplTo(arg0_26._starTpl, var3_27)
		end

		local var6_27 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_27:getShipType()))

		if not var6_27 then
			warning("找不到船形, shipConfigId: " .. arg1_27.configId)
		end

		setImageSprite(findTF(var2_27, "type"), var6_27, true)
		setText(findTF(var2_27, "frame/lv_contain/lv"), arg1_27.level)

		if arg1_27.energy <= Ship.ENERGY_MID then
			local var7_27 = GetSpriteFromAtlas("energy", arg1_27:getEnergyPrint())

			setImageSprite(var4_27, var7_27)
			setActive(var4_27, true)
		end

		local var8_27 = var0_26[arg1_27:getGroupId()]
		local var9_27 = var2_27:Find("expbuff")

		setActive(var9_27, var8_27 ~= nil)

		if var8_27 then
			local var10_27 = var8_27 / 100
			local var11_27 = var8_27 % 100
			local var12_27 = tostring(var10_27)

			if var11_27 > 0 then
				var12_27 = var12_27 .. "." .. tostring(var11_27)
			end

			setText(var9_27:Find("text"), string.format("EXP +%s%%", var12_27))
		end
	end)
	arg0_26._formationLogic:AddLongPress(function(arg0_28, arg1_28, arg2_28)
		arg0_26:emit(FormationMediator.OPEN_SHIP_INFO, arg1_28.id, arg0_26._currentFleetVO, var0_0.TOGGLE_FORMATION)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_26._formationLogic:AddClick(function(arg0_29, arg1_29)
		arg0_26:emit(FormationMediator.CHANGE_FLEET_SHIP, arg0_29, arg0_26._currentFleetVO, var0_0.TOGGLE_FORMATION, arg1_29)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_26._formationLogic:AddBeginDrag(function(arg0_30)
		local var0_30 = findTF(arg0_30, "info")

		SetActive(var0_30, false)
	end)
	arg0_26._formationLogic:AddEndDrag(function(arg0_31)
		local var0_31 = findTF(arg0_31, "info")

		SetActive(var0_31, true)
	end)
	arg0_26._formationLogic:AddShiftOnly(function(arg0_32)
		arg0_26:emit(FormationMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_32)
	end)
	arg0_26._formationLogic:AddRemoveShip(function(arg0_33, arg1_33)
		arg0_26:emit(FormationMediator.REMOVE_SHIP, arg0_33, arg1_33)
	end)
	arg0_26._formationLogic:AddCheckRemove(function(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
		if not arg3_34:canRemove(arg2_34) then
			local var0_34, var1_34 = arg3_34:getShipPos(arg2_34)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2_34:getConfigTable().name, arg3_34.name, Fleet.C_TEAM_NAME[var1_34]))
			arg0_34()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				zIndex = -30,
				hideNo = false,
				content = i18n("ship_formationUI_quest_remove", arg2_34:getName()),
				onYes = arg1_34,
				onNo = arg0_34
			})
		end
	end)
	arg0_26._formationLogic:AddGridTipClick(function(arg0_35, arg1_35)
		arg0_26:emit(FormationMediator.CHANGE_FLEET_SHIP, nil, arg1_35, var0_0.TOGGLE_FORMATION, arg0_35)
	end)
	onButton(arg0_26, arg0_26.backBtn, function()
		arg0_26:ForceDropChar()

		if arg0_26._attrFrame.gameObject.activeSelf then
			triggerToggle(arg0_26._formationToggle, true)
		else
			local function var0_36()
				GetOrAddComponent(arg0_26._tf, typeof(CanvasGroup)).interactable = false

				arg0_26:emit(var0_0.ON_BACK)
			end

			arg0_26:emit(FormationMediator.COMMIT_FLEET, var0_36)
		end
	end, SOUND_BACK)

	arg0_26._stamp = arg0_26._adapt:Find("stamp")

	setActive(arg0_26._stamp, not LOCK_CLICK_MINGSHI and (BATTLE_DEBUG or getProxy(TaskProxy):mingshiTouchFlagEnabled()))
	onButton(arg0_26, arg0_26._stamp, function()
		if BATTLE_DEBUG then
			print(arg0_26._currentFleetVO:genRobotDataString())
		end

		getProxy(TaskProxy):dealMingshiTouchFlag(6)
	end, SFX_CONFIRM)
	onButton(arg0_26, arg0_26._fleetNameEditBtn, function()
		arg0_26:DisplayRenamePanel(true)
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26._renameConfirmBtn, function()
		local var0_40 = getInputText(findTF(arg0_26._renamePanel, "frame/name_field"))

		arg0_26:emit(FormationMediator.CHANGE_FLEET_NAME, arg0_26._currentFleetVO.id, var0_40)
	end, SFX_CONFIRM)
	onButton(arg0_26, arg0_26._renameCancelBtn, function()
		arg0_26:DisplayRenamePanel(false)
	end, SFX_CANCEL)
	onToggle(arg0_26, arg0_26._detailToggle, function(arg0_42)
		arg0_26:ForceDropChar()

		if arg0_42 then
			arg0_26:displayAttrFrame()
		end
	end, SFX_PANEL)
	onToggle(arg0_26, arg0_26._formationToggle, function(arg0_43)
		arg0_26:ForceDropChar()

		if arg0_43 then
			arg0_26:hideAttrFrame()
		end
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26._attrFrame, function()
		triggerToggle(arg0_26._formationToggle, true)
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26.fleetToggleMask, function()
		setActive(arg0_26.fleetToggleMask, false)
		arg0_26:tweenTabArrow(true)
	end, SFX_CANCEL)
	onButton(arg0_26, arg0_26.btnRegular, function()
		arg0_26:updateToggleList(_.filter(arg0_26._fleetVOs, function(arg0_47)
			return arg0_47:getFleetType() == FleetType.Normal
		end))

		local var0_46 = arg0_26._currentFleetVO:getFleetType() == FleetType.Normal
		local var1_46 = arg0_26.index[FleetType.Normal]

		triggerToggle(arg0_26.fleetToggles[var1_46], true)

		if var0_46 then
			setActive(arg0_26.fleetToggleMask, true)
			arg0_26:tweenTabArrow(false)
			setAnchoredPosition(arg0_26.fleetToggleList, Vector3.New(209, 129))
		end
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26.btnSub, function()
		arg0_26:updateToggleList(_.filter(arg0_26._fleetVOs, function(arg0_49)
			return arg0_49:getFleetType() == FleetType.Submarine
		end))

		local var0_48 = arg0_26._currentFleetVO:getFleetType() == FleetType.Submarine
		local var1_48 = arg0_26.index[FleetType.Submarine]

		triggerToggle(arg0_26.fleetToggles[var1_48], true)

		if var0_48 then
			setActive(arg0_26.fleetToggleMask, true)
			arg0_26:tweenTabArrow(false)
			setAnchoredPosition(arg0_26.fleetToggleList, Vector3.New(755, 129))
		end
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26._prevPage, function()
		local var0_50 = arg0_26:selectFleetByStep(-1)

		arg0_26:ForceDropChar()
		arg0_26:emit(FormationMediator.ON_CHANGE_FLEET, var0_50)
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26._nextPage, function()
		local var0_51 = arg0_26:selectFleetByStep(1)

		arg0_26:ForceDropChar()
		arg0_26:emit(FormationMediator.ON_CHANGE_FLEET, var0_51)
	end, SFX_PANEL)

	local var1_26 = defaultValue(arg0_26.contextData.number, 1)

	arg0_26:SetCurrentFleetID(var1_26)

	if arg0_26.isOpenCommander then
		arg0_26.commanderFormationPanel:ActionInvoke("Show")
	end

	arg0_26:UpdateFleetView(true)
	triggerToggle(arg0_26[arg0_26.contextData.toggle or var0_0.TOGGLE_FORMATION], true)
	arg0_26:tweenTabArrow(true)
	onButton(arg0_26, arg0_26._vanguardGS:Find("SonarTip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26.uiSuggestionBtn, function()
		arg0_26:emit(BaseUI.ON_GO_SCENE, SCENE.FORMATION_SUGGESTION)
	end, SFX_PANEL)
	setActive(arg0_26.uiSuggestionBtn, LevelTools.HasUnlockSuggestionMap())
end

function var0_0.SetCurrentFleetID(arg0_54, arg1_54)
	arg0_54._currentFleetVO = arg0_54:getFleetById(arg1_54)

	arg0_54._formationLogic:SetFleetVO(arg0_54._currentFleetVO)
	arg0_54:updateCommanderFormation()
end

function var0_0.updateCommanderFormation(arg0_55)
	if arg0_55.isOpenCommander then
		arg0_55.commanderFormationPanel:Load()
		arg0_55.commanderFormationPanel:ActionInvoke("Update", arg0_55._currentFleetVO, arg0_55.commanderPrefabFleets)
	end
end

function var0_0.selectFleetByStep(arg0_56, arg1_56)
	local var0_56 = table.indexof(arg0_56._fleetVOs, arg0_56._currentFleetVO)

	while true do
		var0_56 = var0_56 + arg1_56

		if var0_56 < 1 or var0_56 > #arg0_56._fleetVOs then
			break
		end

		local var1_56 = arg0_56._fleetVOs[var0_56]

		if var1_56:isUnlock() then
			return var1_56.id
		end
	end
end

function var0_0.updateToggleList(arg0_57, arg1_57)
	local var0_57 = arg0_57.fleetToggleList:GetComponent(typeof(ToggleGroup))

	var0_57.allowSwitchOff = true

	local var1_57 = arg0_57._currentFleetVO.id

	for iter0_57 = 1, #arg0_57.fleetToggles do
		local var2_57 = arg0_57.fleetToggles[iter0_57]
		local var3_57 = arg1_57[iter0_57]

		setActive(var2_57, var3_57)

		if var3_57 then
			local var4_57 = var2_57:GetComponent(typeof(Toggle))
			local var5_57 = var2_57:Find("lock")
			local var6_57, var7_57 = var3_57:isUnlock()

			setToggleEnabled(var2_57, var6_57)
			setActive(var5_57, not var6_57)
			setActive(var2_57:Find("on"), var6_57 and var1_57 == var3_57.id)
			setActive(var2_57:Find("off"), var6_57 and var1_57 ~= var3_57.id)

			if var6_57 then
				var4_57.isOn = var3_57.id == var1_57

				onToggle(arg0_57, var2_57, function(arg0_58)
					if arg0_58 then
						setActive(arg0_57.fleetToggleMask, false)
						arg0_57:tweenTabArrow(true)

						if var3_57.id ~= var1_57 then
							arg0_57:ForceDropChar()
							arg0_57:emit(FormationMediator.ON_CHANGE_FLEET, var3_57.id)
						end
					end
				end, SFX_UI_TAG)
			else
				onButton(arg0_57, var5_57, function()
					pg.TipsMgr.GetInstance():ShowTips(var7_57)
				end, SFX_UI_CLICK)
			end
		end
	end

	var0_57.allowSwitchOff = false
end

function var0_0.resetFormationComponent(arg0_60)
	SetActive(arg0_60._gridTFs.main[1]:Find("flag"), #arg0_60._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
	SetActive(arg0_60._gridTFs.submarine[1]:Find("flag"), #arg0_60._currentFleetVO:getTeamByName(TeamType.Submarine) ~= 0)
end

function var0_0.sortCardSiblingIndex(arg0_61)
	local var0_61 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0_61, function(arg0_62)
		local var0_62 = arg0_61._cards[arg0_62]

		if #var0_62 > 0 then
			for iter0_62 = 1, #var0_62 do
				var0_62[iter0_62].tr:SetSiblingIndex(iter0_62 - 1)
			end
		end
	end)
end

function var0_0.displayFleetInfo(arg0_63)
	SetActive(arg0_63._prevPage, arg0_63:selectFleetByStep(-1))
	SetActive(arg0_63._nextPage, arg0_63:selectFleetByStep(1))
	setActive(arg0_63._adapt:Find("gear_score"), true)
	setActive(arg0_63._vanguardGS, false)
	setActive(arg0_63._mainGS, false)
	setActive(arg0_63._subGS, false)

	local var0_63 = arg0_63._currentFleetVO:GetPropertiesSum()
	local var1_63 = math.floor(arg0_63._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2_63 = math.floor(arg0_63._currentFleetVO:GetGearScoreSum(TeamType.Main))
	local var3_63 = math.floor(arg0_63._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4_63 = arg0_63._currentFleetVO:GetCostSum()

	arg0_63.tweenNumText(arg0_63._cannonPower, var0_63.cannon)
	arg0_63.tweenNumText(arg0_63._torpedoPower, var0_63.torpedo)
	arg0_63.tweenNumText(arg0_63._AAPower, var0_63.antiAir)
	arg0_63.tweenNumText(arg0_63._airPower, var0_63.air)
	arg0_63.tweenNumText(arg0_63._cost, var4_63.oil)

	if OPEN_AIR_DOMINANCE then
		setActive(arg0_63._airDominance.parent, true)
		arg0_63.tweenNumText(arg0_63._airDominance, arg0_63._currentFleetVO:getFleetAirDominanceValue())
	else
		setActive(arg0_63._airDominance.parent, false)
	end

	local var5_63 = arg0_63._currentFleetVO:getFleetType()

	if var5_63 == FleetType.Normal then
		setActive(arg0_63._vanguardGS, true)
		setActive(arg0_63._mainGS, true)
		setActive(arg0_63._arrUpVan, false)
		setActive(arg0_63._arrDownVan, false)
		setActive(arg0_63._arrUpMain, false)
		setActive(arg0_63._arrDownMain, false)

		arg0_63.prevVanGS = tonumber(arg0_63._vanGSTxt.text)

		arg0_63.tweenNumText(arg0_63._vanguardGS:Find("Text"), var1_63)

		if arg0_63.VanGSInited then
			setActive(arg0_63._arrUpVan, var1_63 > arg0_63.prevVanGS)
			setActive(arg0_63._arrDownVan, var1_63 < arg0_63.prevVanGS)
		end

		arg0_63.prevMainGS = tonumber(arg0_63._mainGSTxt.text)

		arg0_63.tweenNumText(arg0_63._mainGS:Find("Text"), var2_63)

		if arg0_63.mainGSInited then
			setActive(arg0_63._arrUpMain, var2_63 > arg0_63.prevMainGS)
			setActive(arg0_63._arrDownMain, var2_63 < arg0_63.prevMainGS)
		end

		arg0_63.contextData.mainGS = var2_63
		arg0_63.contextData.vanGS = var1_63
		arg0_63.mainGSInited = true
		arg0_63.VanGSInited = true

		local var6_63 = arg0_63._currentFleetVO:GetFleetSonarRange()

		setActive(arg0_63._vanguardGS:Find("SonarActive"), var6_63 > 0)
		setActive(arg0_63._vanguardGS:Find("SonarInactive"), var6_63 <= 0)

		local function var7_63()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.fleet_antisub_range_tip.tip
			})
		end

		if var6_63 > 0 then
			setText(arg0_63._vanguardGS:Find("SonarActive/Text"), math.floor(var6_63))
			onButton(arg0_63, arg0_63._vanguardGS:Find("SonarActive"), var7_63, SFX_PANEL)
		else
			onButton(arg0_63, arg0_63._vanguardGS:Find("SonarInactive"), var7_63, SFX_PANEL)
		end
	elseif var5_63 == FleetType.Submarine then
		setActive(arg0_63._arrUpSub, false)
		setActive(arg0_63._arrDownSub, false)
		setActive(arg0_63._subGS, true)

		arg0_63.prevSubGS = tonumber(arg0_63._subGSTxt.text)

		arg0_63.tweenNumText(arg0_63._subGS:Find("Text"), var3_63)

		if arg0_63.SubGSInited then
			setActive(arg0_63._arrUpSub, var3_63 > arg0_63.prevSubGS)
			setActive(arg0_63._arrDownSub, var3_63 < arg0_63.prevSubGS)
		end

		arg0_63.contextData.subGS = var3_63
		arg0_63.SubGSInited = true
	end

	arg0_63:SetFleetNameLabel()
	setText(arg0_63._fleetNumText, arg0_63._currentFleetVO:getIndex())
end

function var0_0.DisplayRenamePanel(arg0_65, arg1_65)
	SetActive(arg0_65._renamePanel, arg1_65)

	if arg1_65 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_65._renamePanel)

		local var0_65 = getText(arg0_65._fleetNameText)

		setInputText(findTF(arg0_65._renamePanel, "frame/name_field"), var0_65)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_65._renamePanel, arg0_65._tf)
	end
end

function var0_0.hideAttrFrame(arg0_66)
	SetActive(arg0_66._attrFrame, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_66._blurLayer, arg0_66._tf)
end

function var0_0.displayAttrFrame(arg0_67)
	pg.UIMgr.GetInstance():BlurPanel(arg0_67._blurLayer)
	SetActive(arg0_67._attrFrame, true)
	arg0_67:initAttrFrame()
end

function var0_0.initAttrFrame(arg0_68)
	local var0_68 = {
		[TeamType.Main] = arg0_68._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_68._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0_68._currentFleetVO.subShips
	}
	local var1_68 = false

	for iter0_68, iter1_68 in pairs(var0_68) do
		local var2_68 = arg0_68._cards[iter0_68]

		if #var2_68 == 0 then
			local var3_68 = arg0_68._attrFrame:Find(iter0_68 .. "/list")

			for iter2_68 = 1, 3 do
				local var4_68 = cloneTplTo(arg0_68._cardTpl, var3_68).gameObject

				table.insert(var2_68, FormationDetailCard.New(var4_68))
			end

			var1_68 = true
		end
	end

	if var1_68 then
		arg0_68:updateAttrFrame()
	end
end

function var0_0.updateAttrFrame(arg0_69)
	local var0_69 = {
		[TeamType.Main] = arg0_69._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_69._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0_69._currentFleetVO.subShips
	}
	local var1_69 = arg0_69._currentFleetVO:getFleetType()

	for iter0_69, iter1_69 in pairs(var0_69) do
		local var2_69 = arg0_69._cards[iter0_69]

		if #var2_69 > 0 then
			local var3_69 = var1_69 == FleetType.Submarine and iter0_69 == TeamType.Vanguard

			for iter2_69 = 1, 3 do
				if iter2_69 <= #iter1_69 then
					local var4_69 = arg0_69.shipVOs[iter1_69[iter2_69]]

					var2_69[iter2_69]:update(var4_69, var3_69)
					var2_69[iter2_69]:updateProps(arg0_69:getCardAttrProps(var4_69))
				else
					var2_69[iter2_69]:update(nil, var3_69)
				end

				arg0_69:detachOnCardButton(var2_69[iter2_69])

				if not var3_69 then
					arg0_69:attachOnCardButton(var2_69[iter2_69], iter0_69)
				end
			end
		end
	end

	setActive(arg0_69._attrFrame:Find(TeamType.Main), var1_69 == FleetType.Normal)
	setActive(arg0_69._attrFrame:Find(TeamType.Submarine), var1_69 == FleetType.Submarine)
	setActive(arg0_69._attrFrame:Find(TeamType.Vanguard .. "/vanguard"), var1_69 ~= FleetType.Submarine)
	arg0_69:updateUltimateTitle()
end

function var0_0.updateUltimateTitle(arg0_70)
	local var0_70 = arg0_70._cards[TeamType.Main]
	local var1_70 = arg0_70._currentFleetVO.mainShips

	if #var0_70 > 0 then
		for iter0_70 = 1, #var0_70 do
			go(var0_70[iter0_70].shipState):SetActive(iter0_70 == 1)
		end
	end
end

function var0_0.getCardAttrProps(arg0_71, arg1_71)
	local var0_71 = arg1_71:getProperties()
	local var1_71 = arg1_71:getShipCombatPower()
	local var2_71 = arg1_71:getBattleTotalExpend()

	return {
		{
			i18n("word_attr_durability"),
			tostring(math.floor(var0_71.durability))
		},
		{
			i18n("word_attr_luck"),
			"" .. tostring(math.floor(var2_71))
		},
		{
			i18n("word_synthesize_power"),
			"<color=#ffff00>" .. var1_71 .. "</color>"
		}
	}
end

function var0_0.detachOnCardButton(arg0_72, arg1_72)
	local var0_72 = GetOrAddComponent(arg1_72.go, "EventTriggerListener")

	var0_72:RemovePointClickFunc()
	var0_72:RemoveBeginDragFunc()
	var0_72:RemoveDragFunc()
	var0_72:RemoveDragEndFunc()
end

function var0_0.attachOnCardButton(arg0_73, arg1_73, arg2_73)
	local var0_73 = GetOrAddComponent(arg1_73.go, "EventTriggerListener")

	arg0_73.eventTriggers[var0_73] = true

	var0_73:AddPointClickFunc(function(arg0_74, arg1_74)
		if not arg0_73.carddrag and arg0_74 == arg1_73.go then
			if arg1_73.shipVO then
				arg0_73:emit(FormationMediator.OPEN_SHIP_INFO, arg1_73.shipVO.id, arg0_73._currentFleetVO, var0_0.TOGGLE_DETAIL)
			else
				arg0_73:emit(FormationMediator.CHANGE_FLEET_SHIP, arg1_73.shipVO, arg0_73._currentFleetVO, var0_0.TOGGLE_DETAIL, arg2_73)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end)

	if arg1_73.shipVO then
		local var1_73 = arg0_73._cards[arg2_73]
		local var2_73 = arg1_73.tr.parent:GetComponent("ContentSizeFitter")
		local var3_73 = arg1_73.tr.parent:GetComponent("HorizontalLayoutGroup")
		local var4_73 = arg1_73.tr.rect.width * 0.5
		local var5_73 = {}

		var0_73:AddBeginDragFunc(function()
			if arg0_73.carddrag then
				return
			end

			arg0_73._currentDragDelegate = var0_73
			arg0_73.carddrag = arg1_73
			var2_73.enabled = false
			var3_73.enabled = false

			arg1_73.tr:SetSiblingIndex(#var1_73)

			for iter0_75 = 1, #var1_73 do
				if var1_73[iter0_75] == arg1_73 then
					arg0_73._shiftIndex = iter0_75
				end

				var5_73[iter0_75] = var1_73[iter0_75].tr.anchoredPosition
			end

			LeanTween.scale(arg1_73.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		end)
		var0_73:AddDragFunc(function(arg0_76, arg1_76)
			if arg0_73.carddrag ~= arg1_73 then
				return
			end

			local var0_76 = arg1_73.tr.localPosition

			var0_76.x = arg0_73:change2ScrPos(arg1_73.tr.parent, arg1_76.position).x
			arg1_73.tr.localPosition = var0_76

			local var1_76 = 1

			for iter0_76 = 1, #var1_73 do
				if var1_73[iter0_76] ~= arg1_73 and var1_73[iter0_76].shipVO and arg1_73.tr.localPosition.x > var1_73[iter0_76].tr.localPosition.x + (var1_76 < arg0_73._shiftIndex and 1.1 or -1.1) * var4_73 then
					var1_76 = var1_76 + 1
				end
			end

			if arg0_73._shiftIndex ~= var1_76 then
				arg0_73._formationLogic:Shift(arg0_73._shiftIndex, var1_76, arg2_73)
				arg0_73:shiftCard(arg0_73._shiftIndex, var1_76, arg2_73)

				for iter1_76 = 1, #var1_73 do
					if var1_73[iter1_76] and var1_73[iter1_76] ~= arg1_73 then
						var1_73[iter1_76].tr.anchoredPosition = var5_73[iter1_76]
					end
				end
			end
		end)
		var0_73:AddDragEndFunc(function(arg0_77, arg1_77)
			if arg0_73.carddrag ~= arg1_73 then
				return
			end

			function resetCard()
				for iter0_78 = 1, #var1_73 do
					var1_73[iter0_78].tr.anchoredPosition = var5_73[iter0_78]
				end

				var2_73.enabled = true
				var3_73.enabled = true
				arg0_73._shiftIndex = nil

				arg0_73:updateUltimateTitle()
				arg0_73._formationLogic:SortSiblingIndex()
				arg0_73:sortCardSiblingIndex()
				arg0_73:emit(FormationMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_73._currentFleetVO)

				var0_73.enabled = true
				arg0_73.carddrag = nil
			end

			local var0_77 = arg0_73._forceDropCharacter

			arg0_73._forceDropCharacter = nil
			arg0_73._currentDragDelegate = nil
			var0_73.enabled = false

			if var0_77 then
				resetCard()

				arg1_73.paintingTr.localScale = Vector3(1, 1, 0)
			else
				local var1_77 = math.min(math.abs(arg1_73.tr.anchoredPosition.x - var5_73[arg0_73._shiftIndex].x) / 200, 1) * 0.3

				LeanTween.value(arg1_73.go, arg1_73.tr.anchoredPosition.x, var5_73[arg0_73._shiftIndex].x, var1_77):setEase(LeanTweenType.easeOutCubic):setOnUpdate(System.Action_float(function(arg0_79)
					local var0_79 = arg1_73.tr.anchoredPosition

					var0_79.x = arg0_79
					arg1_73.tr.anchoredPosition = var0_79
				end)):setOnComplete(System.Action(function()
					resetCard()
					LeanTween.scale(arg1_73.paintingTr, Vector3(1, 1, 0), 0.3)
				end))
			end
		end)
	end
end

function var0_0.shiftCard(arg0_81, arg1_81, arg2_81, arg3_81)
	local var0_81 = arg0_81._cards[arg3_81]

	if #var0_81 > 0 then
		var0_81[arg1_81], var0_81[arg2_81] = var0_81[arg2_81], var0_81[arg1_81]
	end

	arg0_81._shiftIndex = arg2_81
end

function var0_0.change2ScrPos(arg0_82, arg1_82, arg2_82)
	local var0_82 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg1_82, arg2_82, var0_82))
end

function var0_0.tweenNumText(arg0_83, arg1_83, arg2_83, arg3_83, arg4_83)
	LeanTween.value(go(arg0_83), arg4_83 or 0, math.floor(arg1_83), arg2_83 or 0.7):setOnUpdate(System.Action_float(function(arg0_84)
		setText(arg0_83, math.floor(arg0_84))
	end)):setOnComplete(System.Action(function()
		if arg3_83 then
			arg3_83()
		end
	end))
end

function var0_0.defaultFleetName(arg0_86)
	if arg0_86.name == "" or arg0_86.name == nil then
		return Fleet.DEFAULT_NAME[arg0_86.id]
	else
		return arg0_86.name
	end
end

function var0_0.GetFleetCount(arg0_87)
	local var0_87 = 0

	for iter0_87, iter1_87 in pairs(arg0_87._fleetVOs) do
		var0_87 = var0_87 + 1
	end

	return var0_87
end

function var0_0.tweenTabArrow(arg0_88, arg1_88)
	local var0_88 = arg0_88.btnRegular:Find("arr")
	local var1_88 = arg0_88.btnSub:Find("arr")

	setActive(var0_88, arg1_88)
	setActive(var1_88, arg1_88)

	if arg1_88 then
		LeanTween.moveLocalY(go(var0_88), var0_88.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
		LeanTween.moveLocalY(go(var1_88), var1_88.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
	else
		LeanTween.cancel(go(var0_88))
		LeanTween.cancel(go(var1_88))

		local var2_88 = var0_88.localPosition

		var2_88.y = 80
		var0_88.localPosition = var2_88

		local var3_88 = var1_88.localPosition

		var3_88.y = 80
		var1_88.localPosition = var3_88
	end
end

function var0_0.recyclePainting(arg0_89)
	for iter0_89, iter1_89 in pairs(arg0_89._cards) do
		for iter2_89, iter3_89 in ipairs(iter1_89) do
			iter3_89:clear()
		end
	end
end

function var0_0.onBackPressed(arg0_90)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_90._renamePanel) then
		arg0_90:DisplayRenamePanel(false)
	else
		triggerButton(arg0_90.backBtn)
	end
end

function var0_0.willExit(arg0_91)
	arg0_91.commanderFormationPanel:Destroy()

	if arg0_91._attrFrame.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_91._blurLayer, arg0_91._tf)
	end

	arg0_91._formationLogic:Destroy()
	arg0_91:recyclePainting()
	arg0_91:DisplayRenamePanel(false)
	arg0_91:tweenTabArrow(false)

	if arg0_91.tweens then
		cancelTweens(arg0_91.tweens)
	end

	if arg0_91.eventTriggers then
		for iter0_91, iter1_91 in pairs(arg0_91.eventTriggers) do
			ClearEventTrigger(iter0_91)
		end

		arg0_91.eventTriggers = nil
	end
end

return var0_0
