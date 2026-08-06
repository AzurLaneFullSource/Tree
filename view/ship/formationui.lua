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

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.player = arg1_3
end

function var0_0.setCommanderPrefabFleet(arg0_4, arg1_4)
	arg0_4.commanderPrefabFleets = arg1_4
end

function var0_0.init(arg0_5)
	arg0_5.eventTriggers = {}
	arg0_5.backBtn = arg0_5._blurLayer:Find("top/back_btn")
	arg0_5._bgFleet = arg0_5._adapt:Find("bg_fleet")
	arg0_5._bgSub = arg0_5._adapt:Find("bg_sub")
	arg0_5._bottomPanel = arg0_5._blurLayer:Find("bottom")
	arg0_5._detailToggle = arg0_5._bottomPanel:Find("toggle_list/detail_toggle")
	arg0_5._formationToggle = arg0_5._bottomPanel:Find("toggle_list/formation_toggle")
	arg0_5._nextPage = arg0_5._adapt:Find("nextPage")
	arg0_5._prevPage = arg0_5._adapt:Find("prevPage")
	arg0_5._starTpl = arg0_5._tf:Find("star_tpl")
	arg0_5._heroInfoTpl = arg0_5._tf:Find("heroInfo")
	arg0_5.topPanel = arg0_5._blurLayer:Find("top")
	arg0_5._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0_5._gridFrame = arg0_5._adapt:Find("GridFrame")

	for iter0_5 = 1, 3 do
		arg0_5._gridTFs[TeamType.Main][iter0_5] = arg0_5._gridFrame:Find("main_" .. iter0_5)
		arg0_5._gridTFs[TeamType.Vanguard][iter0_5] = arg0_5._gridFrame:Find("vanguard_" .. iter0_5)
		arg0_5._gridTFs[TeamType.Submarine][iter0_5] = arg0_5._gridFrame:Find("submarine_" .. iter0_5)
	end

	arg0_5._heroContainer = arg0_5._adapt:Find("HeroContainer")
	arg0_5._formationLogic = BaseFormation.New(arg0_5._tf, arg0_5._heroContainer, arg0_5._heroInfoTpl, arg0_5._gridTFs)
	arg0_5._fleetInfo = arg0_5._blurLayer:Find("fleet_info")
	arg0_5._fleetNumText = arg0_5._fleetInfo:Find("fleet_number")
	arg0_5._fleetNameText = arg0_5._fleetInfo:Find("fleet_name/Text")
	arg0_5._fleetNameEditBtn = arg0_5._fleetInfo:Find("edit_btn")
	arg0_5._renamePanel = arg0_5._tf:Find("changeName_panel")
	arg0_5._renameConfirmBtn = arg0_5._renamePanel:Find("frame/queren")
	arg0_5._renameCancelBtn = arg0_5._renamePanel:Find("frame/cancel")

	setLocalPosition(arg0_5._renamePanel, {
		z = -45
	})

	arg0_5._propertyFrame = arg0_5._blurLayer:Find("property_frame")
	arg0_5._cannonPower = arg0_5._propertyFrame:Find("cannon/Text")
	arg0_5._torpedoPower = arg0_5._propertyFrame:Find("torpedo/Text")
	arg0_5._AAPower = arg0_5._propertyFrame:Find("antiaircraft/Text")
	arg0_5._airPower = arg0_5._propertyFrame:Find("air/Text")
	arg0_5._airDominance = arg0_5._propertyFrame:Find("ac/Text")
	arg0_5._cost = arg0_5._propertyFrame:Find("cost/Text")
	arg0_5._mainGS = arg0_5._adapt:Find("gear_score/main")
	arg0_5._vanguardGS = arg0_5._adapt:Find("gear_score/vanguard")
	arg0_5._subGS = arg0_5._adapt:Find("gear_score/submarine")
	arg0_5._arrUpVan = arg0_5._vanguardGS:Find("up")
	arg0_5._arrDownVan = arg0_5._vanguardGS:Find("down")
	arg0_5._arrUpMain = arg0_5._mainGS:Find("up")
	arg0_5._arrDownMain = arg0_5._mainGS:Find("down")
	arg0_5._arrUpSub = arg0_5._subGS:Find("up")
	arg0_5._arrDownSub = arg0_5._subGS:Find("down")
	arg0_5._attrFrame = arg0_5._blurLayer:Find("attr_frame")
	arg0_5._cardTpl = arg0_5._tf:Find("RectShipCardTpl")
	arg0_5._cards = {}
	arg0_5._cards[TeamType.Main] = {}
	arg0_5._cards[TeamType.Vanguard] = {}
	arg0_5._cards[TeamType.Submarine] = {}

	setActive(arg0_5._attrFrame, false)
	setActive(arg0_5._cardTpl, false)

	arg0_5.btnRegular = arg0_5._bottomPanel:Find("fleet_select/regular")
	arg0_5._regularEnFllet = arg0_5.btnRegular:Find("fleet/enFleet")
	arg0_5._regularNum = arg0_5.btnRegular:Find("fleet/num")
	arg0_5._regualrCnFleet = arg0_5.btnRegular:Find("fleet/CnFleet")
	arg0_5.btnSub = arg0_5._bottomPanel:Find("fleet_select/sub")
	arg0_5._subEnFllet = arg0_5.btnSub:Find("fleet/enFleet")
	arg0_5._subNum = arg0_5.btnSub:Find("fleet/num")
	arg0_5._subCnFleet = arg0_5.btnSub:Find("fleet/CnFleet")
	arg0_5.fleetToggleMask = arg0_5._tf:Find("blur_panel/list_mask")
	arg0_5.fleetToggleList = arg0_5.fleetToggleMask:Find("list")
	arg0_5.fleetToggles = {}

	for iter1_5 = 1, var0_0.MAX_FLEET_NUM do
		arg0_5.fleetToggles[iter1_5] = arg0_5.fleetToggleList:Find("item" .. iter1_5)
	end

	arg0_5._vanGSTxt = arg0_5._vanguardGS:Find("Text"):GetComponent("Text")
	arg0_5._mainGSTxt = arg0_5._mainGS:Find("Text"):GetComponent("Text")
	arg0_5._subGSTxt = arg0_5._subGS:Find("Text"):GetComponent("Text")
	arg0_5.prevMainGS = arg0_5.contextData.mainGS
	arg0_5.prevVanGS = arg0_5.contextData.vanGS
	arg0_5.prevSubGS = arg0_5.contextData.subGS
	arg0_5.mainGSInited = arg0_5.contextData.mainGS and true or false
	arg0_5.VanGSInited = arg0_5.contextData.vanGS and true or false
	arg0_5.SubGSInited = arg0_5.contextData.subGS and true or false
	arg0_5._vanGSTxt.text = arg0_5.prevVanGS or 0
	arg0_5._mainGSTxt.text = arg0_5.prevMainGS or 0
	arg0_5._subGSTxt.text = arg0_5.prevSubGS or 0
	arg0_5.commanderFormationPanel = CommanderFormationPage.New(arg0_5._tf, arg0_5.event, arg0_5.contextData)
	arg0_5.index = {
		[FleetType.Normal] = 1,
		[FleetType.Submarine] = 1
	}

	setText(arg0_5._adapt:Find("gear_score/main/line/Image/text1"), i18n("pre_combat_main"))
	setText(arg0_5._adapt:Find("gear_score/vanguard/line/Image/text1"), i18n("pre_combat_vanguard"))
	setText(arg0_5._adapt:Find("gear_score/submarine/line/Image/text1"), i18n("pre_combat_submarine"))
end

function var0_0.setShips(arg0_6, arg1_6)
	arg0_6.shipVOs = arg1_6

	arg0_6._formationLogic:SetShipVOs(arg0_6.shipVOs)
end

function var0_0.SetFleets(arg0_7, arg1_7)
	arg0_7._fleetVOs = _(arg1_7):chain():values():filter(function(arg0_8)
		return arg0_8:isRegularFleet()
	end):sort(function(arg0_9, arg1_9)
		return arg0_9.id < arg1_9.id
	end):value()

	if arg0_7._currentFleetVO then
		arg0_7._currentFleetVO = arg0_7:getFleetById(arg0_7._currentFleetVO.id)

		arg0_7._formationLogic:SetFleetVO(arg0_7._currentFleetVO)
	end
end

function var0_0.getFleetById(arg0_10, arg1_10)
	return _.detect(arg0_10._fleetVOs, function(arg0_11)
		return arg0_11.id == arg1_10
	end)
end

function var0_0.UpdateFleetView(arg0_12, arg1_12)
	arg0_12:displayFleetInfo()
	arg0_12:updateFleetBg()
	arg0_12._formationLogic:UpdateGridVisibility()
	arg0_12._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0_12._formationLogic:ResetGrid(TeamType.Main)
	arg0_12._formationLogic:ResetGrid(TeamType.Submarine)
	arg0_12:resetFormationComponent()
	arg0_12:updateAttrFrame()
	arg0_12:updateFleetButton()

	if arg1_12 then
		arg0_12._formationLogic:LoadAllCharacter()
	else
		arg0_12._formationLogic:SetAllCharacterPos()
	end
end

function var0_0.updateFleetBg(arg0_13)
	local var0_13 = arg0_13._currentFleetVO:getFleetType()

	setActive(arg0_13._bgFleet, var0_13 == FleetType.Normal)
	setActive(arg0_13._bgSub, var0_13 == FleetType.Submarine)
end

function var0_0.updateFleetButton(arg0_14)
	local var0_14
	local var1_14 = arg0_14._currentFleetVO:getFleetType()

	arg0_14.index[var1_14] = arg0_14._currentFleetVO:getIndex()

	local var2_14 = arg0_14.index[FleetType.Normal]

	setText(arg0_14._regularEnFllet, var0_0.TeamNum[var2_14] .. " FLEET")
	setText(arg0_14._regualrCnFleet, Fleet.DEFAULT_NAME[var2_14])
	setText(arg0_14._regularNum, var2_14)

	local var3_14 = arg0_14.index[FleetType.Submarine]

	setText(arg0_14._subEnFllet, var0_0.TeamNum[var3_14] .. " FLEET")
	setText(arg0_14._subCnFleet, Fleet.DEFAULT_NAME[var3_14])
	setText(arg0_14._subNum, var3_14)
	setActive(arg0_14.btnRegular:Find("on"), var1_14 == FleetType.Normal)
	setActive(arg0_14.btnRegular:Find("off"), var1_14 ~= FleetType.Normal)
	setActive(arg0_14.btnSub:Find("on"), var1_14 == FleetType.Submarine)
	setActive(arg0_14.btnSub:Find("off"), var1_14 ~= FleetType.Submarine)
end

function var0_0.SetFleetNameLabel(arg0_15)
	setText(arg0_15._fleetNameText, arg0_15.defaultFleetName(arg0_15._currentFleetVO))
end

function var0_0.ForceDropChar(arg0_16)
	arg0_16._formationLogic:ForceDropChar()

	if arg0_16._currentDragDelegate then
		arg0_16._forceDropCharacter = true

		LuaHelper.triggerEndDrag(arg0_16._currentDragDelegate)
	end
end

function var0_0.quickExitFunc(arg0_17)
	arg0_17:ForceDropChar()

	local function var0_17()
		GetOrAddComponent(arg0_17._tf, typeof(CanvasGroup)).interactable = false

		arg0_17:emit(var0_0.ON_HOME)
	end

	arg0_17:emit(FormationMediator.COMMIT_FLEET, var0_17)
end

function var0_0.didEnter(arg0_19)
	arg0_19.isOpenCommander = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_19.player.level, "CommanderCatMediator") and not LOCK_COMMANDER

	local var0_19 = getProxy(ActivityProxy):getBuffShipList()

	arg0_19._formationLogic:AddHeroInfoModify(function(arg0_20, arg1_20)
		local var0_20 = arg1_20:getConfigTable()
		local var1_20 = pg.ship_data_template[arg1_20.configId]
		local var2_20 = findTF(arg0_20, "info")
		local var3_20 = findTF(var2_20, "stars")
		local var4_20 = findTF(var2_20, "energy")
		local var5_20 = arg1_20:getStar()

		for iter0_20 = 1, var5_20 do
			cloneTplTo(arg0_19._starTpl, var3_20)
		end

		local var6_20 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_20:getShipType()))

		if not var6_20 then
			warning("找不到船形, shipConfigId: " .. arg1_20.configId)
		end

		setImageSprite(findTF(var2_20, "type"), var6_20, true)
		setText(findTF(var2_20, "frame/lv_contain/lv"), arg1_20.level)

		if arg1_20.energy <= Ship.ENERGY_MID then
			local var7_20 = GetSpriteFromAtlas("energy", arg1_20:getEnergyPrint())

			setImageSprite(var4_20, var7_20)
			setActive(var4_20, true)
		end

		local var8_20 = var0_19[arg1_20:getGroupId()]
		local var9_20 = var2_20:Find("expbuff")

		setActive(var9_20, var8_20 ~= nil)

		if var8_20 then
			local var10_20 = var8_20 / 100
			local var11_20 = var8_20 % 100
			local var12_20 = tostring(var10_20)

			if var11_20 > 0 then
				var12_20 = var12_20 .. "." .. tostring(var11_20)
			end

			setText(var9_20:Find("text"), string.format("EXP +%s%%", var12_20))
		end
	end)
	arg0_19._formationLogic:AddLongPress(function(arg0_21, arg1_21, arg2_21)
		arg0_19:emit(FormationMediator.OPEN_SHIP_INFO, arg1_21.id, arg0_19._currentFleetVO, var0_0.TOGGLE_FORMATION)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_19._formationLogic:AddClick(function(arg0_22, arg1_22)
		arg0_19:emit(FormationMediator.CHANGE_FLEET_SHIP, arg0_22, arg0_19._currentFleetVO, var0_0.TOGGLE_FORMATION, arg1_22)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_19._formationLogic:AddBeginDrag(function(arg0_23)
		local var0_23 = findTF(arg0_23, "info")

		SetActive(var0_23, false)
	end)
	arg0_19._formationLogic:AddEndDrag(function(arg0_24)
		local var0_24 = findTF(arg0_24, "info")

		SetActive(var0_24, true)
	end)
	arg0_19._formationLogic:AddShiftOnly(function(arg0_25)
		arg0_19:emit(FormationMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_25)
	end)
	arg0_19._formationLogic:AddRemoveShip(function(arg0_26, arg1_26)
		arg0_19:emit(FormationMediator.REMOVE_SHIP, arg0_26, arg1_26)
	end)
	arg0_19._formationLogic:AddCheckRemove(function(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27)
		if not arg3_27:canRemove(arg2_27) then
			local var0_27, var1_27 = arg3_27:getShipPos(arg2_27)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2_27:getConfigTable().name, arg3_27.name, Fleet.C_TEAM_NAME[var1_27]))
			arg0_27()
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				zIndex = -30,
				hideNo = false,
				content = i18n("ship_formationUI_quest_remove", arg2_27:getName()),
				onYes = arg1_27,
				onNo = arg0_27
			})
		end
	end)
	arg0_19._formationLogic:AddGridTipClick(function(arg0_28, arg1_28)
		arg0_19:emit(FormationMediator.CHANGE_FLEET_SHIP, nil, arg1_28, var0_0.TOGGLE_FORMATION, arg0_28)
	end)
	onButton(arg0_19, arg0_19.backBtn, function()
		arg0_19:ForceDropChar()

		if arg0_19._attrFrame.gameObject.activeSelf then
			triggerToggle(arg0_19._formationToggle, true)
		else
			local function var0_29()
				GetOrAddComponent(arg0_19._tf, typeof(CanvasGroup)).interactable = false

				arg0_19:emit(var0_0.ON_BACK)
			end

			arg0_19:emit(FormationMediator.COMMIT_FLEET, var0_29)
		end
	end, SOUND_BACK)

	arg0_19._stamp = arg0_19._adapt:Find("stamp")

	setActive(arg0_19._stamp, not LOCK_CLICK_MINGSHI and (BATTLE_DEBUG or getProxy(TaskProxy):mingshiTouchFlagEnabled()))
	onButton(arg0_19, arg0_19._stamp, function()
		if BATTLE_DEBUG then
			print(arg0_19._currentFleetVO:genRobotDataString())
		end

		getProxy(TaskProxy):dealMingshiTouchFlag(6)
	end, SFX_CONFIRM)
	onButton(arg0_19, arg0_19._fleetNameEditBtn, function()
		arg0_19:DisplayRenamePanel(true)
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19._renameConfirmBtn, function()
		local var0_33 = getInputText(findTF(arg0_19._renamePanel, "frame/name_field"))

		arg0_19:emit(FormationMediator.CHANGE_FLEET_NAME, arg0_19._currentFleetVO.id, var0_33)
	end, SFX_CONFIRM)
	onButton(arg0_19, arg0_19._renameCancelBtn, function()
		arg0_19:DisplayRenamePanel(false)
	end, SFX_CANCEL)
	onToggle(arg0_19, arg0_19._detailToggle, function(arg0_35)
		arg0_19:ForceDropChar()

		if arg0_35 then
			arg0_19:displayAttrFrame()
		end
	end, SFX_PANEL)
	onToggle(arg0_19, arg0_19._formationToggle, function(arg0_36)
		arg0_19:ForceDropChar()

		if arg0_36 then
			arg0_19:hideAttrFrame()
		end
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19._attrFrame, function()
		triggerToggle(arg0_19._formationToggle, true)
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.fleetToggleMask, function()
		setActive(arg0_19.fleetToggleMask, false)
		arg0_19:tweenTabArrow(true)
	end, SFX_CANCEL)
	onButton(arg0_19, arg0_19.btnRegular, function()
		arg0_19:updateToggleList(_.filter(arg0_19._fleetVOs, function(arg0_40)
			return arg0_40:getFleetType() == FleetType.Normal
		end))

		local var0_39 = arg0_19._currentFleetVO:getFleetType() == FleetType.Normal
		local var1_39 = arg0_19.index[FleetType.Normal]

		triggerToggle(arg0_19.fleetToggles[var1_39], true)

		if var0_39 then
			setActive(arg0_19.fleetToggleMask, true)
			arg0_19:tweenTabArrow(false)
			setAnchoredPosition(arg0_19.fleetToggleList, Vector3.New(209, 129))
		end
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.btnSub, function()
		arg0_19:updateToggleList(_.filter(arg0_19._fleetVOs, function(arg0_42)
			return arg0_42:getFleetType() == FleetType.Submarine
		end))

		local var0_41 = arg0_19._currentFleetVO:getFleetType() == FleetType.Submarine
		local var1_41 = arg0_19.index[FleetType.Submarine]

		triggerToggle(arg0_19.fleetToggles[var1_41], true)

		if var0_41 then
			setActive(arg0_19.fleetToggleMask, true)
			arg0_19:tweenTabArrow(false)
			setAnchoredPosition(arg0_19.fleetToggleList, Vector3.New(755, 129))
		end
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19._prevPage, function()
		local var0_43 = arg0_19:selectFleetByStep(-1)

		arg0_19:ForceDropChar()
		arg0_19:emit(FormationMediator.ON_CHANGE_FLEET, var0_43)
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19._nextPage, function()
		local var0_44 = arg0_19:selectFleetByStep(1)

		arg0_19:ForceDropChar()
		arg0_19:emit(FormationMediator.ON_CHANGE_FLEET, var0_44)
	end, SFX_PANEL)

	local var1_19 = defaultValue(arg0_19.contextData.number, 1)

	arg0_19:SetCurrentFleetID(var1_19)

	if arg0_19.isOpenCommander then
		arg0_19.commanderFormationPanel:ActionInvoke("Show")
	end

	arg0_19:UpdateFleetView(true)
	triggerToggle(arg0_19[arg0_19.contextData.toggle or var0_0.TOGGLE_FORMATION], true)
	arg0_19:tweenTabArrow(true)
	onButton(arg0_19, arg0_19._vanguardGS:Find("SonarTip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
end

function var0_0.SetCurrentFleetID(arg0_46, arg1_46)
	arg0_46._currentFleetVO = arg0_46:getFleetById(arg1_46)

	arg0_46._formationLogic:SetFleetVO(arg0_46._currentFleetVO)
	arg0_46:updateCommanderFormation()
end

function var0_0.updateCommanderFormation(arg0_47)
	if arg0_47.isOpenCommander then
		arg0_47.commanderFormationPanel:Load()
		arg0_47.commanderFormationPanel:ActionInvoke("Update", arg0_47._currentFleetVO, arg0_47.commanderPrefabFleets)
	end
end

function var0_0.selectFleetByStep(arg0_48, arg1_48)
	local var0_48 = table.indexof(arg0_48._fleetVOs, arg0_48._currentFleetVO)

	while true do
		var0_48 = var0_48 + arg1_48

		if var0_48 < 1 or var0_48 > #arg0_48._fleetVOs then
			break
		end

		local var1_48 = arg0_48._fleetVOs[var0_48]

		if var1_48:isUnlock() then
			return var1_48.id
		end
	end
end

function var0_0.updateToggleList(arg0_49, arg1_49)
	local var0_49 = arg0_49.fleetToggleList:GetComponent(typeof(ToggleGroup))

	var0_49.allowSwitchOff = true

	local var1_49 = arg0_49._currentFleetVO.id

	for iter0_49 = 1, #arg0_49.fleetToggles do
		local var2_49 = arg0_49.fleetToggles[iter0_49]
		local var3_49 = arg1_49[iter0_49]

		setActive(var2_49, var3_49)

		if var3_49 then
			local var4_49 = var2_49:GetComponent(typeof(Toggle))
			local var5_49 = var2_49:Find("lock")
			local var6_49, var7_49 = var3_49:isUnlock()

			setToggleEnabled(var2_49, var6_49)
			setActive(var5_49, not var6_49)
			setActive(var2_49:Find("on"), var6_49 and var1_49 == var3_49.id)
			setActive(var2_49:Find("off"), var6_49 and var1_49 ~= var3_49.id)

			if var6_49 then
				var4_49.isOn = var3_49.id == var1_49

				onToggle(arg0_49, var2_49, function(arg0_50)
					if arg0_50 then
						setActive(arg0_49.fleetToggleMask, false)
						arg0_49:tweenTabArrow(true)

						if var3_49.id ~= var1_49 then
							arg0_49:ForceDropChar()
							arg0_49:emit(FormationMediator.ON_CHANGE_FLEET, var3_49.id)
						end
					end
				end, SFX_UI_TAG)
			else
				onButton(arg0_49, var5_49, function()
					pg.TipsMgr.GetInstance():ShowTips(var7_49)
				end, SFX_UI_CLICK)
			end
		end
	end

	var0_49.allowSwitchOff = false
end

function var0_0.resetFormationComponent(arg0_52)
	SetActive(arg0_52._gridTFs.main[1]:Find("flag"), #arg0_52._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
	SetActive(arg0_52._gridTFs.submarine[1]:Find("flag"), #arg0_52._currentFleetVO:getTeamByName(TeamType.Submarine) ~= 0)
end

function var0_0.sortCardSiblingIndex(arg0_53)
	local var0_53 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0_53, function(arg0_54)
		local var0_54 = arg0_53._cards[arg0_54]

		if #var0_54 > 0 then
			for iter0_54 = 1, #var0_54 do
				var0_54[iter0_54].tr:SetSiblingIndex(iter0_54 - 1)
			end
		end
	end)
end

function var0_0.displayFleetInfo(arg0_55)
	SetActive(arg0_55._prevPage, arg0_55:selectFleetByStep(-1))
	SetActive(arg0_55._nextPage, arg0_55:selectFleetByStep(1))
	setActive(arg0_55._adapt:Find("gear_score"), true)
	setActive(arg0_55._vanguardGS, false)
	setActive(arg0_55._mainGS, false)
	setActive(arg0_55._subGS, false)

	local var0_55 = arg0_55._currentFleetVO:GetPropertiesSum()
	local var1_55 = math.floor(arg0_55._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2_55 = math.floor(arg0_55._currentFleetVO:GetGearScoreSum(TeamType.Main))
	local var3_55 = math.floor(arg0_55._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4_55 = arg0_55._currentFleetVO:GetCostSum()

	arg0_55.tweenNumText(arg0_55._cannonPower, var0_55.cannon)
	arg0_55.tweenNumText(arg0_55._torpedoPower, var0_55.torpedo)
	arg0_55.tweenNumText(arg0_55._AAPower, var0_55.antiAir)
	arg0_55.tweenNumText(arg0_55._airPower, var0_55.air)
	arg0_55.tweenNumText(arg0_55._cost, var4_55.oil)

	if OPEN_AIR_DOMINANCE then
		setActive(arg0_55._airDominance.parent, true)
		arg0_55.tweenNumText(arg0_55._airDominance, arg0_55._currentFleetVO:getFleetAirDominanceValue())
	else
		setActive(arg0_55._airDominance.parent, false)
	end

	local var5_55 = arg0_55._currentFleetVO:getFleetType()

	if var5_55 == FleetType.Normal then
		setActive(arg0_55._vanguardGS, true)
		setActive(arg0_55._mainGS, true)
		setActive(arg0_55._arrUpVan, false)
		setActive(arg0_55._arrDownVan, false)
		setActive(arg0_55._arrUpMain, false)
		setActive(arg0_55._arrDownMain, false)

		arg0_55.prevVanGS = tonumber(arg0_55._vanGSTxt.text)

		arg0_55.tweenNumText(arg0_55._vanguardGS:Find("Text"), var1_55)

		if arg0_55.VanGSInited then
			setActive(arg0_55._arrUpVan, var1_55 > arg0_55.prevVanGS)
			setActive(arg0_55._arrDownVan, var1_55 < arg0_55.prevVanGS)
		end

		arg0_55.prevMainGS = tonumber(arg0_55._mainGSTxt.text)

		arg0_55.tweenNumText(arg0_55._mainGS:Find("Text"), var2_55)

		if arg0_55.mainGSInited then
			setActive(arg0_55._arrUpMain, var2_55 > arg0_55.prevMainGS)
			setActive(arg0_55._arrDownMain, var2_55 < arg0_55.prevMainGS)
		end

		arg0_55.contextData.mainGS = var2_55
		arg0_55.contextData.vanGS = var1_55
		arg0_55.mainGSInited = true
		arg0_55.VanGSInited = true

		local var6_55 = arg0_55._currentFleetVO:GetFleetSonarRange()

		setActive(arg0_55._vanguardGS:Find("SonarActive"), var6_55 > 0)
		setActive(arg0_55._vanguardGS:Find("SonarInactive"), var6_55 <= 0)

		local function var7_55()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.fleet_antisub_range_tip.tip
			})
		end

		if var6_55 > 0 then
			setText(arg0_55._vanguardGS:Find("SonarActive/Text"), math.floor(var6_55))
			onButton(arg0_55, arg0_55._vanguardGS:Find("SonarActive"), var7_55, SFX_PANEL)
		else
			onButton(arg0_55, arg0_55._vanguardGS:Find("SonarInactive"), var7_55, SFX_PANEL)
		end
	elseif var5_55 == FleetType.Submarine then
		setActive(arg0_55._arrUpSub, false)
		setActive(arg0_55._arrDownSub, false)
		setActive(arg0_55._subGS, true)

		arg0_55.prevSubGS = tonumber(arg0_55._subGSTxt.text)

		arg0_55.tweenNumText(arg0_55._subGS:Find("Text"), var3_55)

		if arg0_55.SubGSInited then
			setActive(arg0_55._arrUpSub, var3_55 > arg0_55.prevSubGS)
			setActive(arg0_55._arrDownSub, var3_55 < arg0_55.prevSubGS)
		end

		arg0_55.contextData.subGS = var3_55
		arg0_55.SubGSInited = true
	end

	arg0_55:SetFleetNameLabel()
	setText(arg0_55._fleetNumText, arg0_55._currentFleetVO:getIndex())
end

function var0_0.DisplayRenamePanel(arg0_57, arg1_57)
	SetActive(arg0_57._renamePanel, arg1_57)

	if arg1_57 then
		pg.UIMgr.GetInstance():BlurPanel(arg0_57._renamePanel)

		local var0_57 = getText(arg0_57._fleetNameText)

		setInputText(findTF(arg0_57._renamePanel, "frame/name_field"), var0_57)
	else
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_57._renamePanel, arg0_57._tf)
	end
end

function var0_0.hideAttrFrame(arg0_58)
	SetActive(arg0_58._attrFrame, false)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_58._blurLayer, arg0_58._tf)
end

function var0_0.displayAttrFrame(arg0_59)
	pg.UIMgr.GetInstance():BlurPanel(arg0_59._blurLayer)
	SetActive(arg0_59._attrFrame, true)
	arg0_59:initAttrFrame()
end

function var0_0.initAttrFrame(arg0_60)
	local var0_60 = {
		[TeamType.Main] = arg0_60._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_60._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0_60._currentFleetVO.subShips
	}
	local var1_60 = false

	for iter0_60, iter1_60 in pairs(var0_60) do
		local var2_60 = arg0_60._cards[iter0_60]

		if #var2_60 == 0 then
			local var3_60 = arg0_60._attrFrame:Find(iter0_60 .. "/list")

			for iter2_60 = 1, 3 do
				local var4_60 = cloneTplTo(arg0_60._cardTpl, var3_60).gameObject

				table.insert(var2_60, FormationDetailCard.New(var4_60))
			end

			var1_60 = true
		end
	end

	if var1_60 then
		arg0_60:updateAttrFrame()
	end
end

function var0_0.updateAttrFrame(arg0_61)
	local var0_61 = {
		[TeamType.Main] = arg0_61._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0_61._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0_61._currentFleetVO.subShips
	}
	local var1_61 = arg0_61._currentFleetVO:getFleetType()

	for iter0_61, iter1_61 in pairs(var0_61) do
		local var2_61 = arg0_61._cards[iter0_61]

		if #var2_61 > 0 then
			local var3_61 = var1_61 == FleetType.Submarine and iter0_61 == TeamType.Vanguard

			for iter2_61 = 1, 3 do
				if iter2_61 <= #iter1_61 then
					local var4_61 = arg0_61.shipVOs[iter1_61[iter2_61]]

					var2_61[iter2_61]:update(var4_61, var3_61)
					var2_61[iter2_61]:updateProps(arg0_61:getCardAttrProps(var4_61))
				else
					var2_61[iter2_61]:update(nil, var3_61)
				end

				arg0_61:detachOnCardButton(var2_61[iter2_61])

				if not var3_61 then
					arg0_61:attachOnCardButton(var2_61[iter2_61], iter0_61)
				end
			end
		end
	end

	setActive(arg0_61._attrFrame:Find(TeamType.Main), var1_61 == FleetType.Normal)
	setActive(arg0_61._attrFrame:Find(TeamType.Submarine), var1_61 == FleetType.Submarine)
	setActive(arg0_61._attrFrame:Find(TeamType.Vanguard .. "/vanguard"), var1_61 ~= FleetType.Submarine)
	arg0_61:updateUltimateTitle()
end

function var0_0.updateUltimateTitle(arg0_62)
	local var0_62 = arg0_62._cards[TeamType.Main]
	local var1_62 = arg0_62._currentFleetVO.mainShips

	if #var0_62 > 0 then
		for iter0_62 = 1, #var0_62 do
			go(var0_62[iter0_62].shipState):SetActive(iter0_62 == 1)
		end
	end
end

function var0_0.getCardAttrProps(arg0_63, arg1_63)
	local var0_63 = arg1_63:getProperties()
	local var1_63 = arg1_63:getShipCombatPower()
	local var2_63 = arg1_63:getBattleTotalExpend()

	return {
		{
			i18n("word_attr_durability"),
			tostring(math.floor(var0_63.durability))
		},
		{
			i18n("word_attr_luck"),
			"" .. tostring(math.floor(var2_63))
		},
		{
			i18n("word_synthesize_power"),
			"<color=#ffff00>" .. var1_63 .. "</color>"
		}
	}
end

function var0_0.detachOnCardButton(arg0_64, arg1_64)
	local var0_64 = GetOrAddComponent(arg1_64.go, "EventTriggerListener")

	var0_64:RemovePointClickFunc()
	var0_64:RemoveBeginDragFunc()
	var0_64:RemoveDragFunc()
	var0_64:RemoveDragEndFunc()
end

function var0_0.attachOnCardButton(arg0_65, arg1_65, arg2_65)
	local var0_65 = GetOrAddComponent(arg1_65.go, "EventTriggerListener")

	arg0_65.eventTriggers[var0_65] = true

	var0_65:AddPointClickFunc(function(arg0_66, arg1_66)
		if not arg0_65.carddrag and arg0_66 == arg1_65.go then
			if arg1_65.shipVO then
				arg0_65:emit(FormationMediator.OPEN_SHIP_INFO, arg1_65.shipVO.id, arg0_65._currentFleetVO, var0_0.TOGGLE_DETAIL)
			else
				arg0_65:emit(FormationMediator.CHANGE_FLEET_SHIP, arg1_65.shipVO, arg0_65._currentFleetVO, var0_0.TOGGLE_DETAIL, arg2_65)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end)

	if arg1_65.shipVO then
		local var1_65 = arg0_65._cards[arg2_65]
		local var2_65 = arg1_65.tr.parent:GetComponent("ContentSizeFitter")
		local var3_65 = arg1_65.tr.parent:GetComponent("HorizontalLayoutGroup")
		local var4_65 = arg1_65.tr.rect.width * 0.5
		local var5_65 = {}

		var0_65:AddBeginDragFunc(function()
			if arg0_65.carddrag then
				return
			end

			arg0_65._currentDragDelegate = var0_65
			arg0_65.carddrag = arg1_65
			var2_65.enabled = false
			var3_65.enabled = false

			arg1_65.tr:SetSiblingIndex(#var1_65)

			for iter0_67 = 1, #var1_65 do
				if var1_65[iter0_67] == arg1_65 then
					arg0_65._shiftIndex = iter0_67
				end

				var5_65[iter0_67] = var1_65[iter0_67].tr.anchoredPosition
			end

			LeanTween.scale(arg1_65.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		end)
		var0_65:AddDragFunc(function(arg0_68, arg1_68)
			if arg0_65.carddrag ~= arg1_65 then
				return
			end

			local var0_68 = arg1_65.tr.localPosition

			var0_68.x = arg0_65:change2ScrPos(arg1_65.tr.parent, arg1_68.position).x
			arg1_65.tr.localPosition = var0_68

			local var1_68 = 1

			for iter0_68 = 1, #var1_65 do
				if var1_65[iter0_68] ~= arg1_65 and var1_65[iter0_68].shipVO and arg1_65.tr.localPosition.x > var1_65[iter0_68].tr.localPosition.x + (var1_68 < arg0_65._shiftIndex and 1.1 or -1.1) * var4_65 then
					var1_68 = var1_68 + 1
				end
			end

			if arg0_65._shiftIndex ~= var1_68 then
				arg0_65._formationLogic:Shift(arg0_65._shiftIndex, var1_68, arg2_65)
				arg0_65:shiftCard(arg0_65._shiftIndex, var1_68, arg2_65)

				for iter1_68 = 1, #var1_65 do
					if var1_65[iter1_68] and var1_65[iter1_68] ~= arg1_65 then
						var1_65[iter1_68].tr.anchoredPosition = var5_65[iter1_68]
					end
				end
			end
		end)
		var0_65:AddDragEndFunc(function(arg0_69, arg1_69)
			if arg0_65.carddrag ~= arg1_65 then
				return
			end

			function resetCard()
				for iter0_70 = 1, #var1_65 do
					var1_65[iter0_70].tr.anchoredPosition = var5_65[iter0_70]
				end

				var2_65.enabled = true
				var3_65.enabled = true
				arg0_65._shiftIndex = nil

				arg0_65:updateUltimateTitle()
				arg0_65._formationLogic:SortSiblingIndex()
				arg0_65:sortCardSiblingIndex()
				arg0_65:emit(FormationMediator.CHANGE_FLEET_SHIPS_ORDER, arg0_65._currentFleetVO)

				var0_65.enabled = true
				arg0_65.carddrag = nil
			end

			local var0_69 = arg0_65._forceDropCharacter

			arg0_65._forceDropCharacter = nil
			arg0_65._currentDragDelegate = nil
			var0_65.enabled = false

			if var0_69 then
				resetCard()

				arg1_65.paintingTr.localScale = Vector3(1, 1, 0)
			else
				local var1_69 = math.min(math.abs(arg1_65.tr.anchoredPosition.x - var5_65[arg0_65._shiftIndex].x) / 200, 1) * 0.3

				LeanTween.value(arg1_65.go, arg1_65.tr.anchoredPosition.x, var5_65[arg0_65._shiftIndex].x, var1_69):setEase(LeanTweenType.easeOutCubic):setOnUpdate(System.Action_float(function(arg0_71)
					local var0_71 = arg1_65.tr.anchoredPosition

					var0_71.x = arg0_71
					arg1_65.tr.anchoredPosition = var0_71
				end)):setOnComplete(System.Action(function()
					resetCard()
					LeanTween.scale(arg1_65.paintingTr, Vector3(1, 1, 0), 0.3)
				end))
			end
		end)
	end
end

function var0_0.shiftCard(arg0_73, arg1_73, arg2_73, arg3_73)
	local var0_73 = arg0_73._cards[arg3_73]

	if #var0_73 > 0 then
		var0_73[arg1_73], var0_73[arg2_73] = var0_73[arg2_73], var0_73[arg1_73]
	end

	arg0_73._shiftIndex = arg2_73
end

function var0_0.change2ScrPos(arg0_74, arg1_74, arg2_74)
	local var0_74 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg1_74, arg2_74, var0_74))
end

function var0_0.tweenNumText(arg0_75, arg1_75, arg2_75, arg3_75, arg4_75)
	LeanTween.value(go(arg0_75), arg4_75 or 0, math.floor(arg1_75), arg2_75 or 0.7):setOnUpdate(System.Action_float(function(arg0_76)
		setText(arg0_75, math.floor(arg0_76))
	end)):setOnComplete(System.Action(function()
		if arg3_75 then
			arg3_75()
		end
	end))
end

function var0_0.defaultFleetName(arg0_78)
	if arg0_78.name == "" or arg0_78.name == nil then
		return Fleet.DEFAULT_NAME[arg0_78.id]
	else
		return arg0_78.name
	end
end

function var0_0.GetFleetCount(arg0_79)
	local var0_79 = 0

	for iter0_79, iter1_79 in pairs(arg0_79._fleetVOs) do
		var0_79 = var0_79 + 1
	end

	return var0_79
end

function var0_0.tweenTabArrow(arg0_80, arg1_80)
	local var0_80 = arg0_80.btnRegular:Find("arr")
	local var1_80 = arg0_80.btnSub:Find("arr")

	setActive(var0_80, arg1_80)
	setActive(var1_80, arg1_80)

	if arg1_80 then
		LeanTween.moveLocalY(go(var0_80), var0_80.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
		LeanTween.moveLocalY(go(var1_80), var1_80.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
	else
		LeanTween.cancel(go(var0_80))
		LeanTween.cancel(go(var1_80))

		local var2_80 = var0_80.localPosition

		var2_80.y = 80
		var0_80.localPosition = var2_80

		local var3_80 = var1_80.localPosition

		var3_80.y = 80
		var1_80.localPosition = var3_80
	end
end

function var0_0.recyclePainting(arg0_81)
	for iter0_81, iter1_81 in pairs(arg0_81._cards) do
		for iter2_81, iter3_81 in ipairs(iter1_81) do
			iter3_81:clear()
		end
	end
end

function var0_0.onBackPressed(arg0_82)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0_82._renamePanel) then
		arg0_82:DisplayRenamePanel(false)
	else
		triggerButton(arg0_82.backBtn)
	end
end

function var0_0.willExit(arg0_83)
	arg0_83.commanderFormationPanel:Destroy()

	if arg0_83._attrFrame.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_83._blurLayer, arg0_83._tf)
	end

	arg0_83._formationLogic:Destroy()
	arg0_83:recyclePainting()
	arg0_83:DisplayRenamePanel(false)
	arg0_83:tweenTabArrow(false)

	if arg0_83.tweens then
		cancelTweens(arg0_83.tweens)
	end

	if arg0_83.eventTriggers then
		for iter0_83, iter1_83 in pairs(arg0_83.eventTriggers) do
			ClearEventTrigger(iter0_83)
		end

		arg0_83.eventTriggers = nil
	end
end

return var0_0
