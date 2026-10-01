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

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = {
		"shiptype",
		"energy",
		"shipframeb",
		"ui/proposeshipcard"
	}

	return table.insertto(var0_3, var0_0.super.getResource(arg0_3, arg1_3))
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
end

function var0_0.SetCurrentFleetID(arg0_53, arg1_53)
	arg0_53._currentFleetVO = arg0_53:getFleetById(arg1_53)

	arg0_53._formationLogic:SetFleetVO(arg0_53._currentFleetVO)
	arg0_53:updateCommanderFormation()
end

function var0_0.updateCommanderFormation(arg0_54)
	if arg0_54.isOpenCommander then
		arg0_54.commanderFormationPanel:Load()
		arg0_54.commanderFormationPanel:ActionInvoke("Update", arg0_54._currentFleetVO, arg0_54.commanderPrefabFleets)
	end
end

function var0_0.selectFleetByStep(arg0_55, arg1_55)
	local var0_55 = table.indexof(arg0_55._fleetVOs, arg0_55._currentFleetVO)

	while true do
		var0_55 = var0_55 + arg1_55

		if var0_55 < 1 or var0_55 > #arg0_55._fleetVOs then
			break
		end

		local var1_55 = arg0_55._fleetVOs[var0_55]

		if var1_55:isUnlock() then
			return var1_55.id
		end
	end
end

function var0_0.updateToggleList(arg0_56, arg1_56)
	local var0_56 = arg0_56.fleetToggleList:GetComponent(typeof(ToggleGroup))

	var0_56.allowSwitchOff = true

	local var1_56 = arg0_56._currentFleetVO.id

	for iter0_56 = 1, #arg0_56.fleetToggles do
		local var2_56 = arg0_56.fleetToggles[iter0_56]
		local var3_56 = arg1_56[iter0_56]

		setActive(var2_56, var3_56)

		if var3_56 then
			local var4_56 = var2_56:GetComponent(typeof(Toggle))
			local var5_56 = var2_56:Find("lock")
			local var6_56, var7_56 = var3_56:isUnlock()

			setToggleEnabled(var2_56, var6_56)
			setActive(var5_56, not var6_56)
			setActive(var2_56:Find("on"), var6_56 and var1_56 == var3_56.id)
			setActive(var2_56:Find("off"), var6_56 and var1_56 ~= var3_56.id)

			if var6_56 then
				var4_56.isOn = var3_56.id == var1_56

				onToggle(arg0_56, var2_56, function(arg0_57)
					if arg0_57 then
						setActive(arg0_56.fleetToggleMask, false)
						arg0_56:tweenTabArrow(true)

						if var3_56.id ~= var1_56 then
							arg0_56:ForceDropChar()
							arg0_56:emit(FormationMediator.ON_CHANGE_FLEET, var3_56.id)
						end
					end
				end, SFX_UI_TAG)
			else
				onButton(arg0_56, var5_56, function()
					pg.TipsMgr.GetInstance():ShowTips(var7_56)
				end, SFX_UI_CLICK)
			end
		end
	end

	var0_56.allowSwitchOff = false
end

function var0_0.resetFormationComponent(arg0_59)
	SetActive(arg0_59._gridTFs.main[1]:Find("flag"), #arg0_59._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
	SetActive(arg0_59._gridTFs.submarine[1]:Find("flag"), #arg0_59._currentFleetVO:getTeamByName(TeamType.Submarine) ~= 0)
end

function var0_0.sortCardSiblingIndex(arg0_60)
	local var0_60 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0_60, function(arg0_61)
		local var0_61 = arg0_60._cards[arg0_61]

		if #var0_61 > 0 then
			for iter0_61 = 1, #var0_61 do
				var0_61[iter0_61].tr:SetSiblingIndex(iter0_61 - 1)
			end
		end
	end)
end

function var0_0.displayFleetInfo(arg0_62)
	SetActive(arg0_62._prevPage, arg0_62:selectFleetByStep(-1))
	SetActive(arg0_62._nextPage, arg0_62:selectFleetByStep(1))
	setActive(arg0_62._adapt:Find("gear_score"), true)
	setActive(arg0_62._vanguardGS, false)
	setActive(arg0_62._mainGS, false)
	setActive(arg0_62._subGS, false)

	local var0_62 = arg0_62._currentFleetVO:GetPropertiesSum()
	local var1_62 = math.floor(arg0_62._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2_62 = math.floor(arg0_62._currentFleetVO:GetGearScoreSum(TeamType.Main))
	local var3_62 = math.floor(arg0_62._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4_62 = arg0_62._currentFleetVO:GetCostSum()

	arg0_62.tweenNumText(arg0_62._cannonPower, var0_62.cannon)
	arg0_62.tweenNumText(arg0_62._torpedoPower, var0_62.torpedo)
	arg0_62.tweenNumText(arg0_62._AAPower, var0_62.antiAir)
	arg0_62.tweenNumText(arg0_62._airPower, var0_62.air)
	arg0_62.tweenNumText(arg0_62._cost, var4_62.oil)

	if OPEN_AIR_DOMINANCE then
		setActive(arg0_62._airDominance.parent, true)
		arg0_62.tweenNumText(arg0_62._airDominance, arg0_62._currentFleetVO:getFleetAirDominanceValue())
	else
		setActive(arg0_62._airDominance.parent, false)
	end

	local var5_62 = arg0_62._currentFleetVO:getFleetType()

	if var5_62 == FleetType.Normal then
		setActive(arg0_62._vanguardGS, true)
		setActive(arg0_62._mainGS, true)
		setActive(arg0_62._arrUpVan, false)
		setActive(arg0_62._arrDownVan, false)
		setActive(arg0_62._arrUpMain, false)
		setActive(arg0_62._arrDownMain, false)

		arg0_62.prevVanGS = tonumber(arg0_62._vanGSTxt.text)

		arg0_62.tweenNumText(arg0_62._vanguardGS:Find("Text"), var1_62)

		if arg0_62.VanGSInited then
			setActive(arg0_62._arrUpVan, var1_62 > arg0_62.prevVanGS)
			setActive(arg0_62._arrDownVan, var1_62 < arg0_62.prevVanGS)
		end

		arg0_62.prevMainGS = tonumber(arg0_62._mainGSTxt.text)

		arg0_62.tweenNumText(arg0_62._mainGS:Find("Text"), var2_62)

		if arg0_62.mainGSInited then
			setActive(arg0_62._arrUpMain, var2_62 > arg0_62.prevMainGS)
			setActive(arg0_62._arrDownMain, var2_62 < arg0_62.prevMainGS)
		end

		arg0_62.contextData.mainGS = var2_62
		arg0_62.contextData.vanGS = var1_62
		arg0_62.mainGSInited = true
		arg0_62.VanGSInited = true

		local var6_62 = arg0_62._currentFleetVO:GetFleetSonarRange()

		setActive(arg0_62._vanguardGS:Find("SonarActive"), var6_62 > 0)
		setActive(arg0_62._vanguardGS:Find("SonarInactive"), var6_62 <= 0)

		local function var7_62()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.fleet_antisub_range_tip.tip
			})
		end

		if var6_62 > 0 then
			setText(arg0_62._vanguardGS:Find("SonarActive/Text"), math.floor(var6_62))
			onButton(arg0_62, arg0_62._vanguardGS:Find("SonarActive"), var7_62, SFX_PANEL)
		else
			onButton(arg0_62, arg0_62._vanguardGS:Find("SonarInactive"), var7_62, SFX_PANEL)
		end
	elseif var5_62 == FleetType.Submarine then
		setActive(arg0_62._arrUpSub, false)
		setActive(arg0_62._arrDownSub, false)
		setActive(arg0_62._subGS, true)

		arg0_62.prevSubGS = tonumber(arg0_62._subGSTxt.text)

		arg0_62.tweenNumText(arg0_62._subGS:Find("Text"), var3_62)

		if arg0_62.SubGSInited then
			setActive(arg0_62._arrUpSub, var3_62 > arg0_62.prevSubGS)
			setActive(arg0_62._arrDownSub, var3_62 < arg0_62.prevSubGS)
		end

		arg0_62.contextData.subGS = var3_62
		arg0_62.SubGSInited = true
	end

	arg0_62:SetFleetNameLabel()
	setText(arg0_62._fleetNumText, arg0_62._currentFleetVO:getIndex())
end

function var0_0.DisplayRenamePanel(arg0_64, arg1_64)
	SetActive(arg0_64._renamePanel, arg1_64)

	if arg1_64 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_64._renamePanel)

		local var0_64 = getText(arg0_64._fleetNameText)

		setInputText(findTF(arg0_64._renamePanel, "frame/name_field"), var0_64)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_64._renamePanel, arg0_64._tf)
	end
end

function var0_0.hideAttrFrame(arg0_65)
	SetActive(arg0_65._attrFrame, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_65._blurLayer, arg0_65._tf)
end

function var0_0.displayAttrFrame(arg0_66)
	pg.UIMgr.GetInstance():BlurPanel(arg0_66._blurLayer)
	SetActive(arg0_66._attrFrame, true)
	arg0_66:initAttrFrame()
end

function var0_0.initAttrFrame(arg0_67)
	local var0_67 = {
		[TeamType.Main] = arg0_67._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_67._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0_67._currentFleetVO.subShips
	}
	local var1_67 = false

	for iter0_67, iter1_67 in pairs(var0_67) do
		local var2_67 = arg0_67._cards[iter0_67]

		if #var2_67 == 0 then
			local var3_67 = arg0_67._attrFrame:Find(iter0_67 .. "/list")

			for iter2_67 = 1, 3 do
				local var4_67 = cloneTplTo(arg0_67._cardTpl, var3_67).gameObject

				table.insert(var2_67, FormationDetailCard.New(var4_67))
			end

			var1_67 = true
		end
	end

	if var1_67 then
		arg0_67:updateAttrFrame()
	end
end

function var0_0.updateAttrFrame(arg0_68)
	local var0_68 = {
		[TeamType.Main] = arg0_68._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_68._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0_68._currentFleetVO.subShips
	}
	local var1_68 = arg0_68._currentFleetVO:getFleetType()

	for iter0_68, iter1_68 in pairs(var0_68) do
		local var2_68 = arg0_68._cards[iter0_68]

		if #var2_68 > 0 then
			local var3_68 = var1_68 == FleetType.Submarine and iter0_68 == TeamType.Vanguard

			for iter2_68 = 1, 3 do
				if iter2_68 <= #iter1_68 then
					local var4_68 = arg0_68.shipVOs[iter1_68[iter2_68]]

					var2_68[iter2_68]:update(var4_68, var3_68)
					var2_68[iter2_68]:updateProps(arg0_68:getCardAttrProps(var4_68))
				else
					var2_68[iter2_68]:update(nil, var3_68)
				end

				arg0_68:detachOnCardButton(var2_68[iter2_68])

				if not var3_68 then
					arg0_68:attachOnCardButton(var2_68[iter2_68], iter0_68)
				end
			end
		end
	end

	setActive(arg0_68._attrFrame:Find(TeamType.Main), var1_68 == FleetType.Normal)
	setActive(arg0_68._attrFrame:Find(TeamType.Submarine), var1_68 == FleetType.Submarine)
	setActive(arg0_68._attrFrame:Find(TeamType.Vanguard .. "/vanguard"), var1_68 ~= FleetType.Submarine)
	arg0_68:updateUltimateTitle()
end

function var0_0.updateUltimateTitle(arg0_69)
	local var0_69 = arg0_69._cards[TeamType.Main]
	local var1_69 = arg0_69._currentFleetVO.mainShips

	if #var0_69 > 0 then
		for iter0_69 = 1, #var0_69 do
			go(var0_69[iter0_69].shipState):SetActive(iter0_69 == 1)
		end
	end
end

function var0_0.getCardAttrProps(arg0_70, arg1_70)
	local var0_70 = arg1_70:getProperties()
	local var1_70 = arg1_70:getShipCombatPower()
	local var2_70 = arg1_70:getBattleTotalExpend()

	return {
		{
			i18n("word_attr_durability"),
			tostring(math.floor(var0_70.durability))
		},
		{
			i18n("word_attr_luck"),
			"" .. tostring(math.floor(var2_70))
		},
		{
			i18n("word_synthesize_power"),
			"<color=#ffff00>" .. var1_70 .. "</color>"
		}
	}
end

function var0_0.detachOnCardButton(arg0_71, arg1_71)
	local var0_71 = GetOrAddComponent(arg1_71.go, "EventTriggerListener")

	var0_71:RemovePointClickFunc()
	var0_71:RemoveBeginDragFunc()
	var0_71:RemoveDragFunc()
	var0_71:RemoveDragEndFunc()
end

function var0_0.attachOnCardButton(arg0_72, arg1_72, arg2_72)
	local var0_72 = GetOrAddComponent(arg1_72.go, "EventTriggerListener")

	arg0_72.eventTriggers[var0_72] = true

	var0_72:AddPointClickFunc(function(arg0_73, arg1_73)
		if not arg0_72.carddrag and arg0_73 == arg1_72.go then
			if arg1_72.shipVO then
				arg0_72:emit(FormationMediator.OPEN_SHIP_INFO, arg1_72.shipVO.id, arg0_72._currentFleetVO, var0_0.TOGGLE_DETAIL)
			else
				arg0_72:emit(FormationMediator.CHANGE_FLEET_SHIP, arg1_72.shipVO, arg0_72._currentFleetVO, var0_0.TOGGLE_DETAIL, arg2_72)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end)

	if arg1_72.shipVO then
		local var1_72 = arg0_72._cards[arg2_72]
		local var2_72 = arg1_72.tr.parent:GetComponent("ContentSizeFitter")
		local var3_72 = arg1_72.tr.parent:GetComponent("HorizontalLayoutGroup")
		local var4_72 = arg1_72.tr.rect.width * 0.5
		local var5_72 = {}

		var0_72:AddBeginDragFunc(function()
			if arg0_72.carddrag then
				return
			end

			arg0_72._currentDragDelegate = var0_72
			arg0_72.carddrag = arg1_72
			var2_72.enabled = false
			var3_72.enabled = false

			arg1_72.tr:SetSiblingIndex(#var1_72)

			for iter0_74 = 1, #var1_72 do
				if var1_72[iter0_74] == arg1_72 then
					arg0_72._shiftIndex = iter0_74
				end

				var5_72[iter0_74] = var1_72[iter0_74].tr.anchoredPosition
			end

			LeanTween.scale(arg1_72.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		end)
		var0_72:AddDragFunc(function(arg0_75, arg1_75)
			if arg0_72.carddrag ~= arg1_72 then
				return
			end

			local var0_75 = arg1_72.tr.localPosition

			var0_75.x = arg0_72:change2ScrPos(arg1_72.tr.parent, arg1_75.position).x
			arg1_72.tr.localPosition = var0_75

			local var1_75 = 1

			for iter0_75 = 1, #var1_72 do
				if var1_72[iter0_75] ~= arg1_72 and var1_72[iter0_75].shipVO and arg1_72.tr.localPosition.x > var1_72[iter0_75].tr.localPosition.x + (var1_75 < arg0_72._shiftIndex and 1.1 or -1.1) * var4_72 then
					var1_75 = var1_75 + 1
				end
			end

			if arg0_72._shiftIndex ~= var1_75 then
				arg0_72._formationLogic:Shift(arg0_72._shiftIndex, var1_75, arg2_72)
				arg0_72:shiftCard(arg0_72._shiftIndex, var1_75, arg2_72)

				for iter1_75 = 1, #var1_72 do
					if var1_72[iter1_75] and var1_72[iter1_75] ~= arg1_72 then
						var1_72[iter1_75].tr.anchoredPosition = var5_72[iter1_75]
					end
				end
			end
		end)
		var0_72:AddDragEndFunc(function(arg0_76, arg1_76)
			if arg0_72.carddrag ~= arg1_72 then
				return
			end

			function resetCard()
				for iter0_77 = 1, #var1_72 do
					var1_72[iter0_77].tr.anchoredPosition = var5_72[iter0_77]
				end

				var2_72.enabled = true
				var3_72.enabled = true
				arg0_72._shiftIndex = nil

				arg0_72:updateUltimateTitle()
				arg0_72._formationLogic:SortSiblingIndex()
				arg0_72:sortCardSiblingIndex()
				arg0_72:emit(FormationMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_72._currentFleetVO)

				var0_72.enabled = true
				arg0_72.carddrag = nil
			end

			local var0_76 = arg0_72._forceDropCharacter

			arg0_72._forceDropCharacter = nil
			arg0_72._currentDragDelegate = nil
			var0_72.enabled = false

			if var0_76 then
				resetCard()

				arg1_72.paintingTr.localScale = Vector3(1, 1, 0)
			else
				local var1_76 = math.min(math.abs(arg1_72.tr.anchoredPosition.x - var5_72[arg0_72._shiftIndex].x) / 200, 1) * 0.3

				LeanTween.value(arg1_72.go, arg1_72.tr.anchoredPosition.x, var5_72[arg0_72._shiftIndex].x, var1_76):setEase(LeanTweenType.easeOutCubic):setOnUpdate(System.Action_float(function(arg0_78)
					local var0_78 = arg1_72.tr.anchoredPosition

					var0_78.x = arg0_78
					arg1_72.tr.anchoredPosition = var0_78
				end)):setOnComplete(System.Action(function()
					resetCard()
					LeanTween.scale(arg1_72.paintingTr, Vector3(1, 1, 0), 0.3)
				end))
			end
		end)
	end
end

function var0_0.shiftCard(arg0_80, arg1_80, arg2_80, arg3_80)
	local var0_80 = arg0_80._cards[arg3_80]

	if #var0_80 > 0 then
		var0_80[arg1_80], var0_80[arg2_80] = var0_80[arg2_80], var0_80[arg1_80]
	end

	arg0_80._shiftIndex = arg2_80
end

function var0_0.change2ScrPos(arg0_81, arg1_81, arg2_81)
	local var0_81 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg1_81, arg2_81, var0_81))
end

function var0_0.tweenNumText(arg0_82, arg1_82, arg2_82, arg3_82, arg4_82)
	LeanTween.value(go(arg0_82), arg4_82 or 0, math.floor(arg1_82), arg2_82 or 0.7):setOnUpdate(System.Action_float(function(arg0_83)
		setText(arg0_82, math.floor(arg0_83))
	end)):setOnComplete(System.Action(function()
		if arg3_82 then
			arg3_82()
		end
	end))
end

function var0_0.defaultFleetName(arg0_85)
	if arg0_85.name == "" or arg0_85.name == nil then
		return Fleet.DEFAULT_NAME[arg0_85.id]
	else
		return arg0_85.name
	end
end

function var0_0.GetFleetCount(arg0_86)
	local var0_86 = 0

	for iter0_86, iter1_86 in pairs(arg0_86._fleetVOs) do
		var0_86 = var0_86 + 1
	end

	return var0_86
end

function var0_0.tweenTabArrow(arg0_87, arg1_87)
	local var0_87 = arg0_87.btnRegular:Find("arr")
	local var1_87 = arg0_87.btnSub:Find("arr")

	setActive(var0_87, arg1_87)
	setActive(var1_87, arg1_87)

	if arg1_87 then
		LeanTween.moveLocalY(go(var0_87), var0_87.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
		LeanTween.moveLocalY(go(var1_87), var1_87.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
	else
		LeanTween.cancel(go(var0_87))
		LeanTween.cancel(go(var1_87))

		local var2_87 = var0_87.localPosition

		var2_87.y = 80
		var0_87.localPosition = var2_87

		local var3_87 = var1_87.localPosition

		var3_87.y = 80
		var1_87.localPosition = var3_87
	end
end

function var0_0.recyclePainting(arg0_88)
	for iter0_88, iter1_88 in pairs(arg0_88._cards) do
		for iter2_88, iter3_88 in ipairs(iter1_88) do
			iter3_88:clear()
		end
	end
end

function var0_0.onBackPressed(arg0_89)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_89._renamePanel) then
		arg0_89:DisplayRenamePanel(false)
	else
		triggerButton(arg0_89.backBtn)
	end
end

function var0_0.willExit(arg0_90)
	arg0_90.commanderFormationPanel:Destroy()

	if arg0_90._attrFrame.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_90._blurLayer, arg0_90._tf)
	end

	arg0_90._formationLogic:Destroy()
	arg0_90:recyclePainting()
	arg0_90:DisplayRenamePanel(false)
	arg0_90:tweenTabArrow(false)

	if arg0_90.tweens then
		cancelTweens(arg0_90.tweens)
	end

	if arg0_90.eventTriggers then
		for iter0_90, iter1_90 in pairs(arg0_90.eventTriggers) do
			ClearEventTrigger(iter0_90)
		end

		arg0_90.eventTriggers = nil
	end
end

return var0_0
