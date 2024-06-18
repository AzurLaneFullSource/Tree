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

function var0_0.setPlayer(arg0_2, arg1_2)
	arg0_2.player = arg1_2
end

function var0_0.setCommanderPrefabFleet(arg0_3, arg1_3)
	arg0_3.commanderPrefabFleets = arg1_3
end

function var0_0.init(arg0_4)
	arg0_4.eventTriggers = {}
	arg0_4._blurLayer = arg0_4:findTF("blur_panel")
	arg0_4.backBtn = arg0_4:findTF("top/back_btn", arg0_4._blurLayer)
	arg0_4._bgFleet = arg0_4:findTF("bg_fleet")
	arg0_4._bgSub = arg0_4:findTF("bg_sub")
	arg0_4._bottomPanel = arg0_4:findTF("bottom", arg0_4._blurLayer)
	arg0_4._detailToggle = arg0_4:findTF("toggle_list/detail_toggle", arg0_4._bottomPanel)
	arg0_4._formationToggle = arg0_4:findTF("toggle_list/formation_toggle", arg0_4._bottomPanel)
	arg0_4._nextPage = arg0_4:findTF("nextPage")
	arg0_4._prevPage = arg0_4:findTF("prevPage")
	arg0_4._starTpl = arg0_4:findTF("star_tpl")
	arg0_4._heroInfoTpl = arg0_4:findTF("heroInfo")
	arg0_4.topPanel = arg0_4:findTF("top", arg0_4._blurLayer)
	arg0_4._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0_4._gridFrame = arg0_4:findTF("GridFrame")

	for iter0_4 = 1, 3 do
		arg0_4._gridTFs[TeamType.Main][iter0_4] = arg0_4._gridFrame:Find("main_" .. iter0_4)
		arg0_4._gridTFs[TeamType.Vanguard][iter0_4] = arg0_4._gridFrame:Find("vanguard_" .. iter0_4)
		arg0_4._gridTFs[TeamType.Submarine][iter0_4] = arg0_4._gridFrame:Find("submarine_" .. iter0_4)
	end

	arg0_4._heroContainer = arg0_4:findTF("HeroContainer")
	arg0_4._formationLogic = BaseFormation.New(arg0_4._tf, arg0_4._heroContainer, arg0_4._heroInfoTpl, arg0_4._gridTFs)
	arg0_4._fleetInfo = arg0_4:findTF("fleet_info", arg0_4._blurLayer)
	arg0_4._fleetNumText = arg0_4:findTF("fleet_number", arg0_4._fleetInfo)
	arg0_4._fleetNameText = arg0_4:findTF("fleet_name/Text", arg0_4._fleetInfo)
	arg0_4._fleetNameEditBtn = arg0_4:findTF("edit_btn", arg0_4._fleetInfo)
	arg0_4._renamePanel = arg0_4:findTF("changeName_panel")
	arg0_4._renameConfirmBtn = arg0_4._renamePanel:Find("frame/queren")
	arg0_4._renameCancelBtn = arg0_4._renamePanel:Find("frame/cancel")

	setLocalPosition(arg0_4._renamePanel, {
		z = -45
	})

	arg0_4._propertyFrame = arg0_4:findTF("property_frame", arg0_4._blurLayer)
	arg0_4._cannonPower = arg0_4:findTF("cannon/Text", arg0_4._propertyFrame)
	arg0_4._torpedoPower = arg0_4:findTF("torpedo/Text", arg0_4._propertyFrame)
	arg0_4._AAPower = arg0_4:findTF("antiaircraft/Text", arg0_4._propertyFrame)
	arg0_4._airPower = arg0_4:findTF("air/Text", arg0_4._propertyFrame)
	arg0_4._airDominance = arg0_4:findTF("ac/Text", arg0_4._propertyFrame)
	arg0_4._cost = arg0_4:findTF("cost/Text", arg0_4._propertyFrame)
	arg0_4._mainGS = arg0_4:findTF("gear_score/main")
	arg0_4._vanguardGS = arg0_4:findTF("gear_score/vanguard")
	arg0_4._subGS = arg0_4:findTF("gear_score/submarine")
	arg0_4._arrUpVan = arg0_4._vanguardGS:Find("up")
	arg0_4._arrDownVan = arg0_4._vanguardGS:Find("down")
	arg0_4._arrUpMain = arg0_4._mainGS:Find("up")
	arg0_4._arrDownMain = arg0_4._mainGS:Find("down")
	arg0_4._arrUpSub = arg0_4._subGS:Find("up")
	arg0_4._arrDownSub = arg0_4._subGS:Find("down")
	arg0_4._attrFrame = arg0_4:findTF("blur_panel/attr_frame")
	arg0_4._cardTpl = arg0_4._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0_4._cards = {}
	arg0_4._cards[TeamType.Main] = {}
	arg0_4._cards[TeamType.Vanguard] = {}
	arg0_4._cards[TeamType.Submarine] = {}

	setActive(arg0_4._attrFrame, false)
	setActive(arg0_4._cardTpl, false)

	arg0_4.btnRegular = arg0_4:findTF("fleet_select/regular", arg0_4._bottomPanel)
	arg0_4._regularEnFllet = arg0_4:findTF("fleet/enFleet", arg0_4.btnRegular)
	arg0_4._regularNum = arg0_4:findTF("fleet/num", arg0_4.btnRegular)
	arg0_4._regualrCnFleet = arg0_4:findTF("fleet/CnFleet", arg0_4.btnRegular)
	arg0_4.btnSub = arg0_4:findTF("fleet_select/sub", arg0_4._bottomPanel)
	arg0_4._subEnFllet = arg0_4:findTF("fleet/enFleet", arg0_4.btnSub)
	arg0_4._subNum = arg0_4:findTF("fleet/num", arg0_4.btnSub)
	arg0_4._subCnFleet = arg0_4:findTF("fleet/CnFleet", arg0_4.btnSub)
	arg0_4.fleetToggleMask = arg0_4:findTF("blur_panel/list_mask")
	arg0_4.fleetToggleList = arg0_4:findTF("list", arg0_4.fleetToggleMask)
	arg0_4.fleetToggles = {}

	for iter1_4 = 1, var0_0.MAX_FLEET_NUM do
		arg0_4.fleetToggles[iter1_4] = arg0_4:findTF("item" .. iter1_4, arg0_4.fleetToggleList)
	end

	arg0_4._vanGSTxt = arg0_4._vanguardGS:Find("Text"):GetComponent("Text")
	arg0_4._mainGSTxt = arg0_4._mainGS:Find("Text"):GetComponent("Text")
	arg0_4._subGSTxt = arg0_4._subGS:Find("Text"):GetComponent("Text")
	arg0_4.prevMainGS = arg0_4.contextData.mainGS
	arg0_4.prevVanGS = arg0_4.contextData.vanGS
	arg0_4.prevSubGS = arg0_4.contextData.subGS
	arg0_4.mainGSInited = arg0_4.contextData.mainGS and true or false
	arg0_4.VanGSInited = arg0_4.contextData.vanGS and true or false
	arg0_4.SubGSInited = arg0_4.contextData.subGS and true or false
	arg0_4._vanGSTxt.text = arg0_4.prevVanGS or 0
	arg0_4._mainGSTxt.text = arg0_4.prevMainGS or 0
	arg0_4._subGSTxt.text = arg0_4.prevSubGS or 0
	arg0_4.commanderFormationPanel = CommanderFormationPage.New(arg0_4._tf, arg0_4.event, arg0_4.contextData)
	arg0_4.index = {
		[FleetType.Normal] = 1,
		[FleetType.Submarine] = 1
	}

	setText(findTF(arg0_4._tf, "gear_score/main/line/Image/text1"), i18n("pre_combat_main"))
	setText(findTF(arg0_4._tf, "gear_score/vanguard/line/Image/text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0_4._tf, "gear_score/submarine/line/Image/text1"), i18n("pre_combat_submarine"))
end

function var0_0.setShips(arg0_5, arg1_5)
	arg0_5.shipVOs = arg1_5

	arg0_5._formationLogic:SetShipVOs(arg0_5.shipVOs)
end

function var0_0.SetFleets(arg0_6, arg1_6)
	arg0_6._fleetVOs = _(arg1_6):chain():values():filter(function(arg0_7)
		return arg0_7:isRegularFleet()
	end):sort(function(arg0_8, arg1_8)
		return arg0_8.id < arg1_8.id
	end):value()

	if arg0_6._currentFleetVO then
		arg0_6._currentFleetVO = arg0_6:getFleetById(arg0_6._currentFleetVO.id)

		arg0_6._formationLogic:SetFleetVO(arg0_6._currentFleetVO)
	end
end

function var0_0.getFleetById(arg0_9, arg1_9)
	return _.detect(arg0_9._fleetVOs, function(arg0_10)
		return arg0_10.id == arg1_9
	end)
end

function var0_0.UpdateFleetView(arg0_11, arg1_11)
	arg0_11:displayFleetInfo()
	arg0_11:updateFleetBg()
	arg0_11._formationLogic:UpdateGridVisibility()
	arg0_11._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0_11._formationLogic:ResetGrid(TeamType.Main)
	arg0_11._formationLogic:ResetGrid(TeamType.Submarine)
	arg0_11:resetFormationComponent()
	arg0_11:updateAttrFrame()
	arg0_11:updateFleetButton()

	if arg1_11 then
		arg0_11._formationLogic:LoadAllCharacter()
	else
		arg0_11._formationLogic:SetAllCharacterPos()
	end
end

function var0_0.updateFleetBg(arg0_12)
	local var0_12 = arg0_12._currentFleetVO:getFleetType()

	setActive(arg0_12._bgFleet, var0_12 == FleetType.Normal)
	setActive(arg0_12._bgSub, var0_12 == FleetType.Submarine)
end

function var0_0.updateFleetButton(arg0_13)
	local var0_13
	local var1_13 = arg0_13._currentFleetVO:getFleetType()

	arg0_13.index[var1_13] = arg0_13._currentFleetVO:getIndex()

	local var2_13 = arg0_13.index[FleetType.Normal]

	setText(arg0_13._regularEnFllet, var0_0.TeamNum[var2_13] .. " FLEET")
	setText(arg0_13._regualrCnFleet, Fleet.DEFAULT_NAME[var2_13])
	setText(arg0_13._regularNum, var2_13)

	local var3_13 = arg0_13.index[FleetType.Submarine]

	setText(arg0_13._subEnFllet, var0_0.TeamNum[var3_13] .. " FLEET")
	setText(arg0_13._subCnFleet, Fleet.DEFAULT_NAME[var3_13])
	setText(arg0_13._subNum, var3_13)
	setActive(arg0_13.btnRegular:Find("on"), var1_13 == FleetType.Normal)
	setActive(arg0_13.btnRegular:Find("off"), var1_13 ~= FleetType.Normal)
	setActive(arg0_13.btnSub:Find("on"), var1_13 == FleetType.Submarine)
	setActive(arg0_13.btnSub:Find("off"), var1_13 ~= FleetType.Submarine)
end

function var0_0.SetFleetNameLabel(arg0_14)
	setText(arg0_14._fleetNameText, arg0_14.defaultFleetName(arg0_14._currentFleetVO))
end

function var0_0.ForceDropChar(arg0_15)
	arg0_15._formationLogic:ForceDropChar()

	if arg0_15._currentDragDelegate then
		arg0_15._forceDropCharacter = true

		LuaHelper.triggerEndDrag(arg0_15._currentDragDelegate)
	end
end

function var0_0.quickExitFunc(arg0_16)
	arg0_16:ForceDropChar()

	local function var0_16()
		GetOrAddComponent(arg0_16._tf, typeof(CanvasGroup)).interactable = false

		arg0_16:emit(var0_0.ON_HOME)
	end

	arg0_16:emit(FormationMediator.COMMIT_FLEET, var0_16)
end

function var0_0.didEnter(arg0_18)
	arg0_18.isOpenCommander = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_18.player.level, "CommanderCatMediator") and not LOCK_COMMANDER

	local var0_18 = getProxy(ActivityProxy):getBuffShipList()

	arg0_18._formationLogic:AddHeroInfoModify(function(arg0_19, arg1_19)
		local var0_19 = arg1_19:getConfigTable()
		local var1_19 = pg.ship_data_template[arg1_19.configId]
		local var2_19 = findTF(arg0_19, "info")
		local var3_19 = findTF(var2_19, "stars")
		local var4_19 = findTF(var2_19, "energy")
		local var5_19 = arg1_19:getStar()

		for iter0_19 = 1, var5_19 do
			cloneTplTo(arg0_18._starTpl, var3_19)
		end

		local var6_19 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_19:getShipType()))

		if not var6_19 then
			warning("找不到船形, shipConfigId: " .. arg1_19.configId)
		end

		setImageSprite(findTF(var2_19, "type"), var6_19, true)
		setText(findTF(var2_19, "frame/lv_contain/lv"), arg1_19.level)

		if arg1_19.energy <= Ship.ENERGY_MID then
			local var7_19 = GetSpriteFromAtlas("energy", arg1_19:getEnergyPrint())

			setImageSprite(var4_19, var7_19)
			setActive(var4_19, true)
		end

		local var8_19 = var0_18[arg1_19:getGroupId()]
		local var9_19 = var2_19:Find("expbuff")

		setActive(var9_19, var8_19 ~= nil)

		if var8_19 then
			local var10_19 = var8_19 / 100
			local var11_19 = var8_19 % 100
			local var12_19 = tostring(var10_19)

			if var11_19 > 0 then
				var12_19 = var12_19 .. "." .. tostring(var11_19)
			end

			setText(var9_19:Find("text"), string.format("EXP +%s%%", var12_19))
		end
	end)
	arg0_18._formationLogic:AddLongPress(function(arg0_20, arg1_20, arg2_20)
		arg0_18:emit(FormationMediator.OPEN_SHIP_INFO, arg1_20.id, arg0_18._currentFleetVO, var0_0.TOGGLE_FORMATION)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_18._formationLogic:AddClick(function(arg0_21, arg1_21)
		arg0_18:emit(FormationMediator.CHANGE_FLEET_SHIP, arg0_21, arg0_18._currentFleetVO, var0_0.TOGGLE_FORMATION, arg1_21)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_18._formationLogic:AddBeginDrag(function(arg0_22)
		local var0_22 = findTF(arg0_22, "info")

		SetActive(var0_22, false)
	end)
	arg0_18._formationLogic:AddEndDrag(function(arg0_23)
		local var0_23 = findTF(arg0_23, "info")

		SetActive(var0_23, true)
	end)
	arg0_18._formationLogic:AddShiftOnly(function(arg0_24)
		arg0_18:emit(FormationMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_24)
	end)
	arg0_18._formationLogic:AddRemoveShip(function(arg0_25, arg1_25)
		arg0_18:emit(FormationMediator.REMOVE_SHIP, arg0_25, arg1_25)
	end)
	arg0_18._formationLogic:AddCheckRemove(function(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
		if not arg3_26:canRemove(arg2_26) then
			local var0_26, var1_26 = arg3_26:getShipPos(arg2_26)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2_26:getConfigTable().name, arg3_26.name, Fleet.C_TEAM_NAME[var1_26]))
			arg0_26()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				zIndex = -30,
				hideNo = false,
				content = i18n("ship_formationUI_quest_remove", arg2_26:getName()),
				onYes = arg1_26,
				onNo = arg0_26
			})
		end
	end)
	arg0_18._formationLogic:AddGridTipClick(function(arg0_27, arg1_27)
		arg0_18:emit(FormationMediator.CHANGE_FLEET_SHIP, nil, arg1_27, var0_0.TOGGLE_FORMATION, arg0_27)
	end)
	onButton(arg0_18, arg0_18.backBtn, function()
		arg0_18:ForceDropChar()

		if arg0_18._attrFrame.gameObject.activeSelf then
			triggerToggle(arg0_18._formationToggle, true)
		else
			local function var0_28()
				GetOrAddComponent(arg0_18._tf, typeof(CanvasGroup)).interactable = false

				arg0_18:emit(var0_0.ON_BACK)
			end

			arg0_18:emit(FormationMediator.COMMIT_FLEET, var0_28)
		end
	end, SOUND_BACK)
	setActive(arg0_18:findTF("stamp"), BATTLE_DEBUG or getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_18:findTF("stamp"), false)
	end

	onButton(arg0_18, arg0_18:findTF("stamp"), function()
		if BATTLE_DEBUG then
			print(arg0_18._currentFleetVO:genRobotDataString())
		end

		getProxy(TaskProxy):dealMingshiTouchFlag(6)
	end, SFX_CONFIRM)
	onButton(arg0_18, arg0_18._fleetNameEditBtn, function()
		arg0_18:DisplayRenamePanel(true)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18._renameConfirmBtn, function()
		local var0_32 = getInputText(findTF(arg0_18._renamePanel, "frame/name_field"))

		arg0_18:emit(FormationMediator.CHANGE_FLEET_NAME, arg0_18._currentFleetVO.id, var0_32)
	end, SFX_CONFIRM)
	onButton(arg0_18, arg0_18._renameCancelBtn, function()
		arg0_18:DisplayRenamePanel(false)
	end, SFX_CANCEL)
	onToggle(arg0_18, arg0_18._detailToggle, function(arg0_34)
		arg0_18:ForceDropChar()

		if arg0_34 then
			arg0_18:displayAttrFrame()
		end
	end, SFX_PANEL)
	onToggle(arg0_18, arg0_18._formationToggle, function(arg0_35)
		arg0_18:ForceDropChar()

		if arg0_35 then
			arg0_18:hideAttrFrame()
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18._attrFrame, function()
		triggerToggle(arg0_18._formationToggle, true)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.fleetToggleMask, function()
		setActive(arg0_18.fleetToggleMask, false)
		arg0_18:tweenTabArrow(true)
	end, SFX_CANCEL)
	onButton(arg0_18, arg0_18.btnRegular, function()
		arg0_18:updateToggleList(_.filter(arg0_18._fleetVOs, function(arg0_39)
			return arg0_39:getFleetType() == FleetType.Normal
		end))

		local var0_38 = arg0_18._currentFleetVO:getFleetType() == FleetType.Normal
		local var1_38 = arg0_18.index[FleetType.Normal]

		triggerToggle(arg0_18.fleetToggles[var1_38], true)

		if var0_38 then
			setActive(arg0_18.fleetToggleMask, true)
			arg0_18:tweenTabArrow(false)
			setAnchoredPosition(arg0_18.fleetToggleList, Vector3.New(209, 129))
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.btnSub, function()
		arg0_18:updateToggleList(_.filter(arg0_18._fleetVOs, function(arg0_41)
			return arg0_41:getFleetType() == FleetType.Submarine
		end))

		local var0_40 = arg0_18._currentFleetVO:getFleetType() == FleetType.Submarine
		local var1_40 = arg0_18.index[FleetType.Submarine]

		triggerToggle(arg0_18.fleetToggles[var1_40], true)

		if var0_40 then
			setActive(arg0_18.fleetToggleMask, true)
			arg0_18:tweenTabArrow(false)
			setAnchoredPosition(arg0_18.fleetToggleList, Vector3.New(755, 129))
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18._prevPage, function()
		local var0_42 = arg0_18:selectFleetByStep(-1)

		arg0_18:ForceDropChar()
		arg0_18:emit(FormationMediator.ON_CHANGE_FLEET, var0_42)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18._nextPage, function()
		local var0_43 = arg0_18:selectFleetByStep(1)

		arg0_18:ForceDropChar()
		arg0_18:emit(FormationMediator.ON_CHANGE_FLEET, var0_43)
	end, SFX_PANEL)

	local var1_18 = defaultValue(arg0_18.contextData.number, 1)

	arg0_18:SetCurrentFleetID(var1_18)

	if arg0_18.isOpenCommander then
		arg0_18.commanderFormationPanel:ActionInvoke("Show")
	end

	arg0_18:UpdateFleetView(true)
	triggerToggle(arg0_18[arg0_18.contextData.toggle or var0_0.TOGGLE_FORMATION], true)
	arg0_18:tweenTabArrow(true)
	onButton(arg0_18, arg0_18._vanguardGS:Find("SonarTip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
end

function var0_0.SetCurrentFleetID(arg0_45, arg1_45)
	arg0_45._currentFleetVO = arg0_45:getFleetById(arg1_45)

	arg0_45._formationLogic:SetFleetVO(arg0_45._currentFleetVO)
	arg0_45:updateCommanderFormation()
end

function var0_0.updateCommanderFormation(arg0_46)
	if arg0_46.isOpenCommander then
		arg0_46.commanderFormationPanel:Load()
		arg0_46.commanderFormationPanel:ActionInvoke("Update", arg0_46._currentFleetVO, arg0_46.commanderPrefabFleets)
	end
end

function var0_0.selectFleetByStep(arg0_47, arg1_47)
	local var0_47 = table.indexof(arg0_47._fleetVOs, arg0_47._currentFleetVO)

	while true do
		var0_47 = var0_47 + arg1_47

		if var0_47 < 1 or var0_47 > #arg0_47._fleetVOs then
			break
		end

		local var1_47 = arg0_47._fleetVOs[var0_47]

		if var1_47:isUnlock() then
			return var1_47.id
		end
	end
end

function var0_0.updateToggleList(arg0_48, arg1_48)
	local var0_48 = arg0_48.fleetToggleList:GetComponent(typeof(ToggleGroup))

	var0_48.allowSwitchOff = true

	local var1_48 = arg0_48._currentFleetVO.id

	for iter0_48 = 1, #arg0_48.fleetToggles do
		local var2_48 = arg0_48.fleetToggles[iter0_48]
		local var3_48 = arg1_48[iter0_48]

		setActive(var2_48, var3_48)

		if var3_48 then
			local var4_48 = var2_48:GetComponent(typeof(Toggle))
			local var5_48 = var2_48:Find("lock")
			local var6_48, var7_48 = var3_48:isUnlock()

			setToggleEnabled(var2_48, var6_48)
			setActive(var5_48, not var6_48)
			setActive(var2_48:Find("on"), var6_48 and var1_48 == var3_48.id)
			setActive(var2_48:Find("off"), var6_48 and var1_48 ~= var3_48.id)

			if var6_48 then
				var4_48.isOn = var3_48.id == var1_48

				onToggle(arg0_48, var2_48, function(arg0_49)
					if arg0_49 then
						setActive(arg0_48.fleetToggleMask, false)
						arg0_48:tweenTabArrow(true)

						if var3_48.id ~= var1_48 then
							arg0_48:ForceDropChar()
							arg0_48:emit(FormationMediator.ON_CHANGE_FLEET, var3_48.id)
						end
					end
				end, SFX_UI_TAG)
			else
				onButton(arg0_48, var5_48, function()
					pg.TipsMgr.GetInstance():ShowTips(var7_48)
				end, SFX_UI_CLICK)
			end
		end
	end

	var0_48.allowSwitchOff = false
end

function var0_0.resetFormationComponent(arg0_51)
	SetActive(arg0_51._gridTFs.main[1]:Find("flag"), #arg0_51._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
	SetActive(arg0_51._gridTFs.submarine[1]:Find("flag"), #arg0_51._currentFleetVO:getTeamByName(TeamType.Submarine) ~= 0)
end

function var0_0.sortCardSiblingIndex(arg0_52)
	local var0_52 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0_52, function(arg0_53)
		local var0_53 = arg0_52._cards[arg0_53]

		if #var0_53 > 0 then
			for iter0_53 = 1, #var0_53 do
				var0_53[iter0_53].tr:SetSiblingIndex(iter0_53 - 1)
			end
		end
	end)
end

function var0_0.displayFleetInfo(arg0_54)
	SetActive(arg0_54._prevPage, arg0_54:selectFleetByStep(-1))
	SetActive(arg0_54._nextPage, arg0_54:selectFleetByStep(1))
	setActive(arg0_54:findTF("gear_score"), true)
	setActive(arg0_54._vanguardGS, false)
	setActive(arg0_54._mainGS, false)
	setActive(arg0_54._subGS, false)

	local var0_54 = arg0_54._currentFleetVO:GetPropertiesSum()
	local var1_54 = math.floor(arg0_54._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2_54 = math.floor(arg0_54._currentFleetVO:GetGearScoreSum(TeamType.Main))
	local var3_54 = math.floor(arg0_54._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4_54 = arg0_54._currentFleetVO:GetCostSum()

	arg0_54.tweenNumText(arg0_54._cannonPower, var0_54.cannon)
	arg0_54.tweenNumText(arg0_54._torpedoPower, var0_54.torpedo)
	arg0_54.tweenNumText(arg0_54._AAPower, var0_54.antiAir)
	arg0_54.tweenNumText(arg0_54._airPower, var0_54.air)
	arg0_54.tweenNumText(arg0_54._cost, var4_54.oil)

	if OPEN_AIR_DOMINANCE then
		setActive(arg0_54._airDominance.parent, true)
		arg0_54.tweenNumText(arg0_54._airDominance, arg0_54._currentFleetVO:getFleetAirDominanceValue())
	else
		setActive(arg0_54._airDominance.parent, false)
	end

	local var5_54 = arg0_54._currentFleetVO:getFleetType()

	if var5_54 == FleetType.Normal then
		setActive(arg0_54._vanguardGS, true)
		setActive(arg0_54._mainGS, true)
		setActive(arg0_54._arrUpVan, false)
		setActive(arg0_54._arrDownVan, false)
		setActive(arg0_54._arrUpMain, false)
		setActive(arg0_54._arrDownMain, false)

		arg0_54.prevVanGS = tonumber(arg0_54._vanGSTxt.text)

		arg0_54.tweenNumText(arg0_54._vanguardGS:Find("Text"), var1_54)

		if arg0_54.VanGSInited then
			setActive(arg0_54._arrUpVan, var1_54 > arg0_54.prevVanGS)
			setActive(arg0_54._arrDownVan, var1_54 < arg0_54.prevVanGS)
		end

		arg0_54.prevMainGS = tonumber(arg0_54._mainGSTxt.text)

		arg0_54.tweenNumText(arg0_54._mainGS:Find("Text"), var2_54)

		if arg0_54.mainGSInited then
			setActive(arg0_54._arrUpMain, var2_54 > arg0_54.prevMainGS)
			setActive(arg0_54._arrDownMain, var2_54 < arg0_54.prevMainGS)
		end

		arg0_54.contextData.mainGS = var2_54
		arg0_54.contextData.vanGS = var1_54
		arg0_54.mainGSInited = true
		arg0_54.VanGSInited = true

		local var6_54 = arg0_54._currentFleetVO:GetFleetSonarRange()

		setActive(arg0_54._vanguardGS:Find("SonarActive"), var6_54 > 0)
		setActive(arg0_54._vanguardGS:Find("SonarInactive"), var6_54 <= 0)

		local function var7_54()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.fleet_antisub_range_tip.tip
			})
		end

		if var6_54 > 0 then
			setText(arg0_54._vanguardGS:Find("SonarActive/Text"), math.floor(var6_54))
			onButton(arg0_54, arg0_54._vanguardGS:Find("SonarActive"), var7_54, SFX_PANEL)
		else
			onButton(arg0_54, arg0_54._vanguardGS:Find("SonarInactive"), var7_54, SFX_PANEL)
		end
	elseif var5_54 == FleetType.Submarine then
		setActive(arg0_54._arrUpSub, false)
		setActive(arg0_54._arrDownSub, false)
		setActive(arg0_54._subGS, true)

		arg0_54.prevSubGS = tonumber(arg0_54._subGSTxt.text)

		arg0_54.tweenNumText(arg0_54._subGS:Find("Text"), var3_54)

		if arg0_54.SubGSInited then
			setActive(arg0_54._arrUpSub, var3_54 > arg0_54.prevSubGS)
			setActive(arg0_54._arrDownSub, var3_54 < arg0_54.prevSubGS)
		end

		arg0_54.contextData.subGS = var3_54
		arg0_54.SubGSInited = true
	end

	arg0_54:SetFleetNameLabel()
	setText(arg0_54._fleetNumText, arg0_54._currentFleetVO:getIndex())
end

function var0_0.DisplayRenamePanel(arg0_56, arg1_56)
	SetActive(arg0_56._renamePanel, arg1_56)

	if arg1_56 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_56._renamePanel, false)

		local var0_56 = getText(arg0_56._fleetNameText)

		setInputText(findTF(arg0_56._renamePanel, "frame/name_field"), var0_56)
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0_56._renamePanel, arg0_56._tf)
	end
end

function var0_0.hideAttrFrame(arg0_57)
	SetActive(arg0_57._attrFrame, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_57._blurLayer, arg0_57._tf)
end

function var0_0.displayAttrFrame(arg0_58)
	pg.UIMgr.GetInstance():BlurPanel(arg0_58._blurLayer, false)
	SetActive(arg0_58._attrFrame, true)
	arg0_58:initAttrFrame()
end

function var0_0.initAttrFrame(arg0_59)
	local var0_59 = {
		[TeamType.Main] = arg0_59._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_59._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0_59._currentFleetVO.subShips
	}
	local var1_59 = false

	for iter0_59, iter1_59 in pairs(var0_59) do
		local var2_59 = arg0_59._cards[iter0_59]

		if #var2_59 == 0 then
			local var3_59 = arg0_59:findTF(iter0_59 .. "/list", arg0_59._attrFrame)

			for iter2_59 = 1, 3 do
				local var4_59 = cloneTplTo(arg0_59._cardTpl, var3_59).gameObject

				table.insert(var2_59, FormationDetailCard.New(var4_59))
			end

			var1_59 = true
		end
	end

	if var1_59 then
		arg0_59:updateAttrFrame()
	end
end

function var0_0.updateAttrFrame(arg0_60)
	local var0_60 = {
		[TeamType.Main] = arg0_60._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_60._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0_60._currentFleetVO.subShips
	}
	local var1_60 = arg0_60._currentFleetVO:getFleetType()

	for iter0_60, iter1_60 in pairs(var0_60) do
		local var2_60 = arg0_60._cards[iter0_60]

		if #var2_60 > 0 then
			local var3_60 = var1_60 == FleetType.Submarine and iter0_60 == TeamType.Vanguard

			for iter2_60 = 1, 3 do
				if iter2_60 <= #iter1_60 then
					local var4_60 = arg0_60.shipVOs[iter1_60[iter2_60]]

					var2_60[iter2_60]:update(var4_60, var3_60)
					var2_60[iter2_60]:updateProps(arg0_60:getCardAttrProps(var4_60))
				else
					var2_60[iter2_60]:update(nil, var3_60)
				end

				arg0_60:detachOnCardButton(var2_60[iter2_60])

				if not var3_60 then
					arg0_60:attachOnCardButton(var2_60[iter2_60], iter0_60)
				end
			end
		end
	end

	setActive(arg0_60:findTF(TeamType.Main, arg0_60._attrFrame), var1_60 == FleetType.Normal)
	setActive(arg0_60:findTF(TeamType.Submarine, arg0_60._attrFrame), var1_60 == FleetType.Submarine)
	setActive(arg0_60:findTF(TeamType.Vanguard .. "/vanguard", arg0_60._attrFrame), var1_60 ~= FleetType.Submarine)
	arg0_60:updateUltimateTitle()
end

function var0_0.updateUltimateTitle(arg0_61)
	local var0_61 = arg0_61._cards[TeamType.Main]
	local var1_61 = arg0_61._currentFleetVO.mainShips

	if #var0_61 > 0 then
		for iter0_61 = 1, #var0_61 do
			go(var0_61[iter0_61].shipState):SetActive(iter0_61 == 1)
		end
	end
end

function var0_0.getCardAttrProps(arg0_62, arg1_62)
	local var0_62 = arg1_62:getProperties()
	local var1_62 = arg1_62:getShipCombatPower()
	local var2_62 = arg1_62:getBattleTotalExpend()

	return {
		{
			i18n("word_attr_durability"),
			tostring(math.floor(var0_62.durability))
		},
		{
			i18n("word_attr_luck"),
			"" .. tostring(math.floor(var2_62))
		},
		{
			i18n("word_synthesize_power"),
			"<color=#ffff00>" .. var1_62 .. "</color>"
		}
	}
end

function var0_0.detachOnCardButton(arg0_63, arg1_63)
	local var0_63 = GetOrAddComponent(arg1_63.go, "EventTriggerListener")

	var0_63:RemovePointClickFunc()
	var0_63:RemoveBeginDragFunc()
	var0_63:RemoveDragFunc()
	var0_63:RemoveDragEndFunc()
end

function var0_0.attachOnCardButton(arg0_64, arg1_64, arg2_64)
	local var0_64 = GetOrAddComponent(arg1_64.go, "EventTriggerListener")

	arg0_64.eventTriggers[var0_64] = true

	var0_64:AddPointClickFunc(function(arg0_65, arg1_65)
		if not arg0_64.carddrag and arg0_65 == arg1_64.go then
			if arg1_64.shipVO then
				arg0_64:emit(FormationMediator.OPEN_SHIP_INFO, arg1_64.shipVO.id, arg0_64._currentFleetVO, var0_0.TOGGLE_DETAIL)
			else
				arg0_64:emit(FormationMediator.CHANGE_FLEET_SHIP, arg1_64.shipVO, arg0_64._currentFleetVO, var0_0.TOGGLE_DETAIL, arg2_64)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end)

	if arg1_64.shipVO then
		local var1_64 = arg0_64._cards[arg2_64]
		local var2_64 = arg1_64.tr.parent:GetComponent("ContentSizeFitter")
		local var3_64 = arg1_64.tr.parent:GetComponent("HorizontalLayoutGroup")
		local var4_64 = arg1_64.tr.rect.width * 0.5
		local var5_64 = {}

		var0_64:AddBeginDragFunc(function()
			if arg0_64.carddrag then
				return
			end

			arg0_64._currentDragDelegate = var0_64
			arg0_64.carddrag = arg1_64
			var2_64.enabled = false
			var3_64.enabled = false

			arg1_64.tr:SetSiblingIndex(#var1_64)

			for iter0_66 = 1, #var1_64 do
				if var1_64[iter0_66] == arg1_64 then
					arg0_64._shiftIndex = iter0_66
				end

				var5_64[iter0_66] = var1_64[iter0_66].tr.anchoredPosition
			end

			LeanTween.scale(arg1_64.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		end)
		var0_64:AddDragFunc(function(arg0_67, arg1_67)
			if arg0_64.carddrag ~= arg1_64 then
				return
			end

			local var0_67 = arg1_64.tr.localPosition

			var0_67.x = arg0_64:change2ScrPos(arg1_64.tr.parent, arg1_67.position).x
			arg1_64.tr.localPosition = var0_67

			local var1_67 = 1

			for iter0_67 = 1, #var1_64 do
				if var1_64[iter0_67] ~= arg1_64 and var1_64[iter0_67].shipVO and arg1_64.tr.localPosition.x > var1_64[iter0_67].tr.localPosition.x + (var1_67 < arg0_64._shiftIndex and 1.1 or -1.1) * var4_64 then
					var1_67 = var1_67 + 1
				end
			end

			if arg0_64._shiftIndex ~= var1_67 then
				arg0_64._formationLogic:Shift(arg0_64._shiftIndex, var1_67, arg2_64)
				arg0_64:shiftCard(arg0_64._shiftIndex, var1_67, arg2_64)

				for iter1_67 = 1, #var1_64 do
					if var1_64[iter1_67] and var1_64[iter1_67] ~= arg1_64 then
						var1_64[iter1_67].tr.anchoredPosition = var5_64[iter1_67]
					end
				end
			end
		end)
		var0_64:AddDragEndFunc(function(arg0_68, arg1_68)
			if arg0_64.carddrag ~= arg1_64 then
				return
			end

			function resetCard()
				for iter0_69 = 1, #var1_64 do
					var1_64[iter0_69].tr.anchoredPosition = var5_64[iter0_69]
				end

				var2_64.enabled = true
				var3_64.enabled = true
				arg0_64._shiftIndex = nil

				arg0_64:updateUltimateTitle()
				arg0_64._formationLogic:SortSiblingIndex()
				arg0_64:sortCardSiblingIndex()
				arg0_64:emit(FormationMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_64._currentFleetVO)

				var0_64.enabled = true
				arg0_64.carddrag = nil
			end

			local var0_68 = arg0_64._forceDropCharacter

			arg0_64._forceDropCharacter = nil
			arg0_64._currentDragDelegate = nil
			var0_64.enabled = false

			if var0_68 then
				resetCard()

				arg1_64.paintingTr.localScale = Vector3(1, 1, 0)
			else
				local var1_68 = math.min(math.abs(arg1_64.tr.anchoredPosition.x - var5_64[arg0_64._shiftIndex].x) / 200, 1) * 0.3

				LeanTween.value(arg1_64.go, arg1_64.tr.anchoredPosition.x, var5_64[arg0_64._shiftIndex].x, var1_68):setEase(LeanTweenType.easeOutCubic):setOnUpdate(System.Action_float(function(arg0_70)
					local var0_70 = arg1_64.tr.anchoredPosition

					var0_70.x = arg0_70
					arg1_64.tr.anchoredPosition = var0_70
				end)):setOnComplete(System.Action(function()
					resetCard()
					LeanTween.scale(arg1_64.paintingTr, Vector3(1, 1, 0), 0.3)
				end))
			end
		end)
	end
end

function var0_0.shiftCard(arg0_72, arg1_72, arg2_72, arg3_72)
	local var0_72 = arg0_72._cards[arg3_72]

	if #var0_72 > 0 then
		var0_72[arg1_72], var0_72[arg2_72] = var0_72[arg2_72], var0_72[arg1_72]
	end

	arg0_72._shiftIndex = arg2_72
end

function var0_0.change2ScrPos(arg0_73, arg1_73, arg2_73)
	local var0_73 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg1_73, arg2_73, var0_73))
end

function var0_0.tweenNumText(arg0_74, arg1_74, arg2_74, arg3_74, arg4_74)
	LeanTween.value(go(arg0_74), arg4_74 or 0, math.floor(arg1_74), arg2_74 or 0.7):setOnUpdate(System.Action_float(function(arg0_75)
		setText(arg0_74, math.floor(arg0_75))
	end)):setOnComplete(System.Action(function()
		if arg3_74 then
			arg3_74()
		end
	end))
end

function var0_0.defaultFleetName(arg0_77)
	if arg0_77.name == "" or arg0_77.name == nil then
		return Fleet.DEFAULT_NAME[arg0_77.id]
	else
		return arg0_77.name
	end
end

function var0_0.GetFleetCount(arg0_78)
	local var0_78 = 0

	for iter0_78, iter1_78 in pairs(arg0_78._fleetVOs) do
		var0_78 = var0_78 + 1
	end

	return var0_78
end

function var0_0.tweenTabArrow(arg0_79, arg1_79)
	local var0_79 = arg0_79.btnRegular:Find("arr")
	local var1_79 = arg0_79.btnSub:Find("arr")

	setActive(var0_79, arg1_79)
	setActive(var1_79, arg1_79)

	if arg1_79 then
		LeanTween.moveLocalY(go(var0_79), var0_79.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
		LeanTween.moveLocalY(go(var1_79), var1_79.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
	else
		LeanTween.cancel(go(var0_79))
		LeanTween.cancel(go(var1_79))

		local var2_79 = var0_79.localPosition

		var2_79.y = 80
		var0_79.localPosition = var2_79

		local var3_79 = var1_79.localPosition

		var3_79.y = 80
		var1_79.localPosition = var3_79
	end
end

function var0_0.recyclePainting(arg0_80)
	for iter0_80, iter1_80 in pairs(arg0_80._cards) do
		for iter2_80, iter3_80 in ipairs(iter1_80) do
			iter3_80:clear()
		end
	end
end

function var0_0.onBackPressed(arg0_81)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_81._renamePanel) then
		arg0_81:DisplayRenamePanel(false)
	else
		triggerButton(arg0_81.backBtn)
	end
end

function var0_0.willExit(arg0_82)
	arg0_82.commanderFormationPanel:Destroy()

	if arg0_82._attrFrame.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_82._blurLayer, arg0_82._tf)
	end

	arg0_82._formationLogic:Destroy()
	arg0_82:recyclePainting()
	arg0_82:DisplayRenamePanel(false)
	arg0_82:tweenTabArrow(false)

	if arg0_82.tweens then
		cancelTweens(arg0_82.tweens)
	end

	if arg0_82.eventTriggers then
		for iter0_82, iter1_82 in pairs(arg0_82.eventTriggers) do
			ClearEventTrigger(iter0_82)
		end

		arg0_82.eventTriggers = nil
	end
end

return var0_0
