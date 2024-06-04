local var0 = class("FormationUI", import("..base.BaseUI"))

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
var0.TeamNum = {
	"FIRST",
	"SECOND",
	"THIRD",
	"FOURTH",
	"FIFTH",
	"SIXTH"
}

function var0.getUIName(arg0)
	return "FormationUI"
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.setCommanderPrefabFleet(arg0, arg1)
	arg0.commanderPrefabFleets = arg1
end

function var0.init(arg0)
	arg0.eventTriggers = {}
	arg0._blurLayer = arg0:findTF("blur_panel")
	arg0.backBtn = arg0:findTF("top/back_btn", arg0._blurLayer)
	arg0._bgFleet = arg0:findTF("bg_fleet")
	arg0._bgSub = arg0:findTF("bg_sub")
	arg0._bottomPanel = arg0:findTF("bottom", arg0._blurLayer)
	arg0._detailToggle = arg0:findTF("toggle_list/detail_toggle", arg0._bottomPanel)
	arg0._formationToggle = arg0:findTF("toggle_list/formation_toggle", arg0._bottomPanel)
	arg0._nextPage = arg0:findTF("nextPage")
	arg0._prevPage = arg0:findTF("prevPage")
	arg0._starTpl = arg0:findTF("star_tpl")
	arg0._heroInfoTpl = arg0:findTF("heroInfo")
	arg0.topPanel = arg0:findTF("top", arg0._blurLayer)
	arg0._gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0._gridFrame = arg0:findTF("GridFrame")

	for iter0 = 1, 3 do
		arg0._gridTFs[TeamType.Main][iter0] = arg0._gridFrame:Find("main_" .. iter0)
		arg0._gridTFs[TeamType.Vanguard][iter0] = arg0._gridFrame:Find("vanguard_" .. iter0)
		arg0._gridTFs[TeamType.Submarine][iter0] = arg0._gridFrame:Find("submarine_" .. iter0)
	end

	arg0._heroContainer = arg0:findTF("HeroContainer")
	arg0._formationLogic = BaseFormation.New(arg0._tf, arg0._heroContainer, arg0._heroInfoTpl, arg0._gridTFs)
	arg0._fleetInfo = arg0:findTF("fleet_info", arg0._blurLayer)
	arg0._fleetNumText = arg0:findTF("fleet_number", arg0._fleetInfo)
	arg0._fleetNameText = arg0:findTF("fleet_name/Text", arg0._fleetInfo)
	arg0._fleetNameEditBtn = arg0:findTF("edit_btn", arg0._fleetInfo)
	arg0._renamePanel = arg0:findTF("changeName_panel")
	arg0._renameConfirmBtn = arg0._renamePanel:Find("frame/queren")
	arg0._renameCancelBtn = arg0._renamePanel:Find("frame/cancel")

	setLocalPosition(arg0._renamePanel, {
		z = -45
	})

	arg0._propertyFrame = arg0:findTF("property_frame", arg0._blurLayer)
	arg0._cannonPower = arg0:findTF("cannon/Text", arg0._propertyFrame)
	arg0._torpedoPower = arg0:findTF("torpedo/Text", arg0._propertyFrame)
	arg0._AAPower = arg0:findTF("antiaircraft/Text", arg0._propertyFrame)
	arg0._airPower = arg0:findTF("air/Text", arg0._propertyFrame)
	arg0._airDominance = arg0:findTF("ac/Text", arg0._propertyFrame)
	arg0._cost = arg0:findTF("cost/Text", arg0._propertyFrame)
	arg0._mainGS = arg0:findTF("gear_score/main")
	arg0._vanguardGS = arg0:findTF("gear_score/vanguard")
	arg0._subGS = arg0:findTF("gear_score/submarine")
	arg0._arrUpVan = arg0._vanguardGS:Find("up")
	arg0._arrDownVan = arg0._vanguardGS:Find("down")
	arg0._arrUpMain = arg0._mainGS:Find("up")
	arg0._arrDownMain = arg0._mainGS:Find("down")
	arg0._arrUpSub = arg0._subGS:Find("up")
	arg0._arrDownSub = arg0._subGS:Find("down")
	arg0._attrFrame = arg0:findTF("blur_panel/attr_frame")
	arg0._cardTpl = arg0._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0._cards = {}
	arg0._cards[TeamType.Main] = {}
	arg0._cards[TeamType.Vanguard] = {}
	arg0._cards[TeamType.Submarine] = {}

	setActive(arg0._attrFrame, false)
	setActive(arg0._cardTpl, false)

	arg0.btnRegular = arg0:findTF("fleet_select/regular", arg0._bottomPanel)
	arg0._regularEnFllet = arg0:findTF("fleet/enFleet", arg0.btnRegular)
	arg0._regularNum = arg0:findTF("fleet/num", arg0.btnRegular)
	arg0._regualrCnFleet = arg0:findTF("fleet/CnFleet", arg0.btnRegular)
	arg0.btnSub = arg0:findTF("fleet_select/sub", arg0._bottomPanel)
	arg0._subEnFllet = arg0:findTF("fleet/enFleet", arg0.btnSub)
	arg0._subNum = arg0:findTF("fleet/num", arg0.btnSub)
	arg0._subCnFleet = arg0:findTF("fleet/CnFleet", arg0.btnSub)
	arg0.fleetToggleMask = arg0:findTF("blur_panel/list_mask")
	arg0.fleetToggleList = arg0:findTF("list", arg0.fleetToggleMask)
	arg0.fleetToggles = {}

	for iter1 = 1, var0.MAX_FLEET_NUM do
		arg0.fleetToggles[iter1] = arg0:findTF("item" .. iter1, arg0.fleetToggleList)
	end

	arg0._vanGSTxt = arg0._vanguardGS:Find("Text"):GetComponent("Text")
	arg0._mainGSTxt = arg0._mainGS:Find("Text"):GetComponent("Text")
	arg0._subGSTxt = arg0._subGS:Find("Text"):GetComponent("Text")
	arg0.prevMainGS = arg0.contextData.mainGS
	arg0.prevVanGS = arg0.contextData.vanGS
	arg0.prevSubGS = arg0.contextData.subGS
	arg0.mainGSInited = arg0.contextData.mainGS and true or false
	arg0.VanGSInited = arg0.contextData.vanGS and true or false
	arg0.SubGSInited = arg0.contextData.subGS and true or false
	arg0._vanGSTxt.text = arg0.prevVanGS or 0
	arg0._mainGSTxt.text = arg0.prevMainGS or 0
	arg0._subGSTxt.text = arg0.prevSubGS or 0
	arg0.commanderFormationPanel = CommanderFormationPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.index = {
		[FleetType.Normal] = 1,
		[FleetType.Submarine] = 1
	}

	setText(findTF(arg0._tf, "gear_score/main/line/Image/text1"), i18n("pre_combat_main"))
	setText(findTF(arg0._tf, "gear_score/vanguard/line/Image/text1"), i18n("pre_combat_vanguard"))
	setText(findTF(arg0._tf, "gear_score/submarine/line/Image/text1"), i18n("pre_combat_submarine"))
end

function var0.setShips(arg0, arg1)
	arg0.shipVOs = arg1

	arg0._formationLogic:SetShipVOs(arg0.shipVOs)
end

function var0.SetFleets(arg0, arg1)
	arg0._fleetVOs = _(arg1):chain():values():filter(function(arg0)
		return arg0:isRegularFleet()
	end):sort(function(arg0, arg1)
		return arg0.id < arg1.id
	end):value()

	if arg0._currentFleetVO then
		arg0._currentFleetVO = arg0:getFleetById(arg0._currentFleetVO.id)

		arg0._formationLogic:SetFleetVO(arg0._currentFleetVO)
	end
end

function var0.getFleetById(arg0, arg1)
	return _.detect(arg0._fleetVOs, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.UpdateFleetView(arg0, arg1)
	arg0:displayFleetInfo()
	arg0:updateFleetBg()
	arg0._formationLogic:UpdateGridVisibility()
	arg0._formationLogic:ResetGrid(TeamType.Vanguard)
	arg0._formationLogic:ResetGrid(TeamType.Main)
	arg0._formationLogic:ResetGrid(TeamType.Submarine)
	arg0:resetFormationComponent()
	arg0:updateAttrFrame()
	arg0:updateFleetButton()

	if arg1 then
		arg0._formationLogic:LoadAllCharacter()
	else
		arg0._formationLogic:SetAllCharacterPos()
	end
end

function var0.updateFleetBg(arg0)
	local var0 = arg0._currentFleetVO:getFleetType()

	setActive(arg0._bgFleet, var0 == FleetType.Normal)
	setActive(arg0._bgSub, var0 == FleetType.Submarine)
end

function var0.updateFleetButton(arg0)
	local var0
	local var1 = arg0._currentFleetVO:getFleetType()

	arg0.index[var1] = arg0._currentFleetVO:getIndex()

	local var2 = arg0.index[FleetType.Normal]

	setText(arg0._regularEnFllet, var0.TeamNum[var2] .. " FLEET")
	setText(arg0._regualrCnFleet, Fleet.DEFAULT_NAME[var2])
	setText(arg0._regularNum, var2)

	local var3 = arg0.index[FleetType.Submarine]

	setText(arg0._subEnFllet, var0.TeamNum[var3] .. " FLEET")
	setText(arg0._subCnFleet, Fleet.DEFAULT_NAME[var3])
	setText(arg0._subNum, var3)
	setActive(arg0.btnRegular:Find("on"), var1 == FleetType.Normal)
	setActive(arg0.btnRegular:Find("off"), var1 ~= FleetType.Normal)
	setActive(arg0.btnSub:Find("on"), var1 == FleetType.Submarine)
	setActive(arg0.btnSub:Find("off"), var1 ~= FleetType.Submarine)
end

function var0.SetFleetNameLabel(arg0)
	setText(arg0._fleetNameText, arg0.defaultFleetName(arg0._currentFleetVO))
end

function var0.ForceDropChar(arg0)
	arg0._formationLogic:ForceDropChar()

	if arg0._currentDragDelegate then
		arg0._forceDropCharacter = true

		LuaHelper.triggerEndDrag(arg0._currentDragDelegate)
	end
end

function var0.quickExitFunc(arg0)
	arg0:ForceDropChar()

	local var0 = function()
		GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

		arg0:emit(var0.ON_HOME)
	end

	arg0:emit(FormationMediator.COMMIT_FLEET, var0)
end

function var0.didEnter(arg0)
	arg0.isOpenCommander = pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.player.level, "CommanderCatMediator") and not LOCK_COMMANDER

	local var0 = getProxy(ActivityProxy):getBuffShipList()

	arg0._formationLogic:AddHeroInfoModify(function(arg0, arg1)
		local var0 = arg1:getConfigTable()
		local var1 = pg.ship_data_template[arg1.configId]
		local var2 = findTF(arg0, "info")
		local var3 = findTF(var2, "stars")
		local var4 = findTF(var2, "energy")
		local var5 = arg1:getStar()

		for iter0 = 1, var5 do
			cloneTplTo(arg0._starTpl, var3)
		end

		local var6 = GetSpriteFromAtlas("shiptype", shipType2print(arg1:getShipType()))

		if not var6 then
			warning("找不到船形, shipConfigId: " .. arg1.configId)
		end

		setImageSprite(findTF(var2, "type"), var6, true)
		setText(findTF(var2, "frame/lv_contain/lv"), arg1.level)

		if arg1.energy <= Ship.ENERGY_MID then
			local var7 = GetSpriteFromAtlas("energy", arg1:getEnergyPrint())

			setImageSprite(var4, var7)
			setActive(var4, true)
		end

		local var8 = var0[arg1:getGroupId()]
		local var9 = var2:Find("expbuff")

		setActive(var9, var8 ~= nil)

		if var8 then
			local var10 = var8 / 100
			local var11 = var8 % 100
			local var12 = tostring(var10)

			if var11 > 0 then
				var12 = var12 .. "." .. tostring(var11)
			end

			setText(var9:Find("text"), string.format("EXP +%s%%", var12))
		end
	end)
	arg0._formationLogic:AddLongPress(function(arg0, arg1, arg2)
		arg0:emit(FormationMediator.OPEN_SHIP_INFO, arg1.id, arg0._currentFleetVO, var0.TOGGLE_FORMATION)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0._formationLogic:AddClick(function(arg0, arg1)
		arg0:emit(FormationMediator.CHANGE_FLEET_SHIP, arg0, arg0._currentFleetVO, var0.TOGGLE_FORMATION, arg1)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
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
		arg0:emit(FormationMediator.CHANGE_FLEET_SHIPS_ORDER, arg0)
	end)
	arg0._formationLogic:AddRemoveShip(function(arg0, arg1)
		arg0:emit(FormationMediator.REMOVE_SHIP, arg0, arg1)
	end)
	arg0._formationLogic:AddCheckRemove(function(arg0, arg1, arg2, arg3, arg4)
		if not arg3:canRemove(arg2) then
			local var0, var1 = arg3:getShipPos(arg2)

			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_formationUI_removeError_onlyShip", arg2:getConfigTable().name, arg3.name, Fleet.C_TEAM_NAME[var1]))
			arg0()
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
		arg0:emit(FormationMediator.CHANGE_FLEET_SHIP, nil, arg1, var0.TOGGLE_FORMATION, arg0)
	end)
	onButton(arg0, arg0.backBtn, function()
		arg0:ForceDropChar()

		if arg0._attrFrame.gameObject.activeSelf then
			triggerToggle(arg0._formationToggle, true)
		else
			local var0 = function()
				GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).interactable = false

				arg0:emit(var0.ON_BACK)
			end

			arg0:emit(FormationMediator.COMMIT_FLEET, var0)
		end
	end, SOUND_BACK)
	setActive(arg0:findTF("stamp"), BATTLE_DEBUG or getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0:findTF("stamp"), false)
	end

	onButton(arg0, arg0:findTF("stamp"), function()
		if BATTLE_DEBUG then
			print(arg0._currentFleetVO:genRobotDataString())
		end

		getProxy(TaskProxy):dealMingshiTouchFlag(6)
	end, SFX_CONFIRM)
	onButton(arg0, arg0._fleetNameEditBtn, function()
		arg0:DisplayRenamePanel(true)
	end, SFX_PANEL)
	onButton(arg0, arg0._renameConfirmBtn, function()
		local var0 = getInputText(findTF(arg0._renamePanel, "frame/name_field"))

		arg0:emit(FormationMediator.CHANGE_FLEET_NAME, arg0._currentFleetVO.id, var0)
	end, SFX_CONFIRM)
	onButton(arg0, arg0._renameCancelBtn, function()
		arg0:DisplayRenamePanel(false)
	end, SFX_CANCEL)
	onToggle(arg0, arg0._detailToggle, function(arg0)
		arg0:ForceDropChar()

		if arg0 then
			arg0:displayAttrFrame()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0._formationToggle, function(arg0)
		arg0:ForceDropChar()

		if arg0 then
			arg0:hideAttrFrame()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0._attrFrame, function()
		triggerToggle(arg0._formationToggle, true)
	end, SFX_PANEL)
	onButton(arg0, arg0.fleetToggleMask, function()
		setActive(arg0.fleetToggleMask, false)
		arg0:tweenTabArrow(true)
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnRegular, function()
		arg0:updateToggleList(_.filter(arg0._fleetVOs, function(arg0)
			return arg0:getFleetType() == FleetType.Normal
		end))

		local var0 = arg0._currentFleetVO:getFleetType() == FleetType.Normal
		local var1 = arg0.index[FleetType.Normal]

		triggerToggle(arg0.fleetToggles[var1], true)

		if var0 then
			setActive(arg0.fleetToggleMask, true)
			arg0:tweenTabArrow(false)
			setAnchoredPosition(arg0.fleetToggleList, Vector3.New(209, 129))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.btnSub, function()
		arg0:updateToggleList(_.filter(arg0._fleetVOs, function(arg0)
			return arg0:getFleetType() == FleetType.Submarine
		end))

		local var0 = arg0._currentFleetVO:getFleetType() == FleetType.Submarine
		local var1 = arg0.index[FleetType.Submarine]

		triggerToggle(arg0.fleetToggles[var1], true)

		if var0 then
			setActive(arg0.fleetToggleMask, true)
			arg0:tweenTabArrow(false)
			setAnchoredPosition(arg0.fleetToggleList, Vector3.New(755, 129))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0._prevPage, function()
		local var0 = arg0:selectFleetByStep(-1)

		arg0:ForceDropChar()
		arg0:emit(FormationMediator.ON_CHANGE_FLEET, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0._nextPage, function()
		local var0 = arg0:selectFleetByStep(1)

		arg0:ForceDropChar()
		arg0:emit(FormationMediator.ON_CHANGE_FLEET, var0)
	end, SFX_PANEL)

	local var1 = defaultValue(arg0.contextData.number, 1)

	arg0:SetCurrentFleetID(var1)

	if arg0.isOpenCommander then
		arg0.commanderFormationPanel:ActionInvoke("Show")
	end

	arg0:UpdateFleetView(true)
	triggerToggle(arg0[arg0.contextData.toggle or var0.TOGGLE_FORMATION], true)
	arg0:tweenTabArrow(true)
	onButton(arg0, arg0._vanguardGS:Find("SonarTip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.fleet_antisub_range_tip.tip
		})
	end, SFX_PANEL)
end

function var0.SetCurrentFleetID(arg0, arg1)
	arg0._currentFleetVO = arg0:getFleetById(arg1)

	arg0._formationLogic:SetFleetVO(arg0._currentFleetVO)
	arg0:updateCommanderFormation()
end

function var0.updateCommanderFormation(arg0)
	if arg0.isOpenCommander then
		arg0.commanderFormationPanel:Load()
		arg0.commanderFormationPanel:ActionInvoke("Update", arg0._currentFleetVO, arg0.commanderPrefabFleets)
	end
end

function var0.selectFleetByStep(arg0, arg1)
	local var0 = table.indexof(arg0._fleetVOs, arg0._currentFleetVO)

	while true do
		var0 = var0 + arg1

		if var0 < 1 or var0 > #arg0._fleetVOs then
			break
		end

		local var1 = arg0._fleetVOs[var0]

		if var1:isUnlock() then
			return var1.id
		end
	end
end

function var0.updateToggleList(arg0, arg1)
	local var0 = arg0.fleetToggleList:GetComponent(typeof(ToggleGroup))

	var0.allowSwitchOff = true

	local var1 = arg0._currentFleetVO.id

	for iter0 = 1, #arg0.fleetToggles do
		local var2 = arg0.fleetToggles[iter0]
		local var3 = arg1[iter0]

		setActive(var2, var3)

		if var3 then
			local var4 = var2:GetComponent(typeof(Toggle))
			local var5 = var2:Find("lock")
			local var6, var7 = var3:isUnlock()

			setToggleEnabled(var2, var6)
			setActive(var5, not var6)
			setActive(var2:Find("on"), var6 and var1 == var3.id)
			setActive(var2:Find("off"), var6 and var1 ~= var3.id)

			if var6 then
				var4.isOn = var3.id == var1

				onToggle(arg0, var2, function(arg0)
					if arg0 then
						setActive(arg0.fleetToggleMask, false)
						arg0:tweenTabArrow(true)

						if var3.id ~= var1 then
							arg0:ForceDropChar()
							arg0:emit(FormationMediator.ON_CHANGE_FLEET, var3.id)
						end
					end
				end, SFX_UI_TAG)
			else
				onButton(arg0, var5, function()
					pg.TipsMgr.GetInstance():ShowTips(var7)
				end, SFX_UI_CLICK)
			end
		end
	end

	var0.allowSwitchOff = false
end

function var0.resetFormationComponent(arg0)
	SetActive(arg0._gridTFs.main[1]:Find("flag"), #arg0._currentFleetVO:getTeamByName(TeamType.Main) ~= 0)
	SetActive(arg0._gridTFs.submarine[1]:Find("flag"), #arg0._currentFleetVO:getTeamByName(TeamType.Submarine) ~= 0)
end

function var0.sortCardSiblingIndex(arg0)
	local var0 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0, function(arg0)
		local var0 = arg0._cards[arg0]

		if #var0 > 0 then
			for iter0 = 1, #var0 do
				var0[iter0].tr:SetSiblingIndex(iter0 - 1)
			end
		end
	end)
end

function var0.displayFleetInfo(arg0)
	SetActive(arg0._prevPage, arg0:selectFleetByStep(-1))
	SetActive(arg0._nextPage, arg0:selectFleetByStep(1))
	setActive(arg0:findTF("gear_score"), true)
	setActive(arg0._vanguardGS, false)
	setActive(arg0._mainGS, false)
	setActive(arg0._subGS, false)

	local var0 = arg0._currentFleetVO:GetPropertiesSum()
	local var1 = math.floor(arg0._currentFleetVO:GetGearScoreSum(TeamType.Vanguard))
	local var2 = math.floor(arg0._currentFleetVO:GetGearScoreSum(TeamType.Main))
	local var3 = math.floor(arg0._currentFleetVO:GetGearScoreSum(TeamType.Submarine))
	local var4 = arg0._currentFleetVO:GetCostSum()

	arg0.tweenNumText(arg0._cannonPower, var0.cannon)
	arg0.tweenNumText(arg0._torpedoPower, var0.torpedo)
	arg0.tweenNumText(arg0._AAPower, var0.antiAir)
	arg0.tweenNumText(arg0._airPower, var0.air)
	arg0.tweenNumText(arg0._cost, var4.oil)

	if OPEN_AIR_DOMINANCE then
		setActive(arg0._airDominance.parent, true)
		arg0.tweenNumText(arg0._airDominance, arg0._currentFleetVO:getFleetAirDominanceValue())
	else
		setActive(arg0._airDominance.parent, false)
	end

	local var5 = arg0._currentFleetVO:getFleetType()

	if var5 == FleetType.Normal then
		setActive(arg0._vanguardGS, true)
		setActive(arg0._mainGS, true)
		setActive(arg0._arrUpVan, false)
		setActive(arg0._arrDownVan, false)
		setActive(arg0._arrUpMain, false)
		setActive(arg0._arrDownMain, false)

		arg0.prevVanGS = tonumber(arg0._vanGSTxt.text)

		arg0.tweenNumText(arg0._vanguardGS:Find("Text"), var1)

		if arg0.VanGSInited then
			setActive(arg0._arrUpVan, var1 > arg0.prevVanGS)
			setActive(arg0._arrDownVan, var1 < arg0.prevVanGS)
		end

		arg0.prevMainGS = tonumber(arg0._mainGSTxt.text)

		arg0.tweenNumText(arg0._mainGS:Find("Text"), var2)

		if arg0.mainGSInited then
			setActive(arg0._arrUpMain, var2 > arg0.prevMainGS)
			setActive(arg0._arrDownMain, var2 < arg0.prevMainGS)
		end

		arg0.contextData.mainGS = var2
		arg0.contextData.vanGS = var1
		arg0.mainGSInited = true
		arg0.VanGSInited = true

		local var6 = arg0._currentFleetVO:GetFleetSonarRange()

		setActive(arg0._vanguardGS:Find("SonarActive"), var6 > 0)
		setActive(arg0._vanguardGS:Find("SonarInactive"), var6 <= 0)

		local function var7()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.fleet_antisub_range_tip.tip
			})
		end

		if var6 > 0 then
			setText(arg0._vanguardGS:Find("SonarActive/Text"), math.floor(var6))
			onButton(arg0, arg0._vanguardGS:Find("SonarActive"), var7, SFX_PANEL)
		else
			onButton(arg0, arg0._vanguardGS:Find("SonarInactive"), var7, SFX_PANEL)
		end
	elseif var5 == FleetType.Submarine then
		setActive(arg0._arrUpSub, false)
		setActive(arg0._arrDownSub, false)
		setActive(arg0._subGS, true)

		arg0.prevSubGS = tonumber(arg0._subGSTxt.text)

		arg0.tweenNumText(arg0._subGS:Find("Text"), var3)

		if arg0.SubGSInited then
			setActive(arg0._arrUpSub, var3 > arg0.prevSubGS)
			setActive(arg0._arrDownSub, var3 < arg0.prevSubGS)
		end

		arg0.contextData.subGS = var3
		arg0.SubGSInited = true
	end

	arg0:SetFleetNameLabel()
	setText(arg0._fleetNumText, arg0._currentFleetVO:getIndex())
end

function var0.DisplayRenamePanel(arg0, arg1)
	SetActive(arg0._renamePanel, arg1)

	if arg1 then
		pg.UIMgr.GetInstance():BlurPanel(arg0._renamePanel, false)

		local var0 = getText(arg0._fleetNameText)

		setInputText(findTF(arg0._renamePanel, "frame/name_field"), var0)
	else
		pg.UIMgr.GetInstance():UnblurPanel(arg0._renamePanel, arg0._tf)
	end
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
		[TeamType.Main] = arg0._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0._currentFleetVO.subShips
	}
	local var1 = false

	for iter0, iter1 in pairs(var0) do
		local var2 = arg0._cards[iter0]

		if #var2 == 0 then
			local var3 = arg0:findTF(iter0 .. "/list", arg0._attrFrame)

			for iter2 = 1, 3 do
				local var4 = cloneTplTo(arg0._cardTpl, var3).gameObject

				table.insert(var2, FormationDetailCard.New(var4))
			end

			var1 = true
		end
	end

	if var1 then
		arg0:updateAttrFrame()
	end
end

function var0.updateAttrFrame(arg0)
	local var0 = {
		[TeamType.Main] = arg0._currentFleetVO.mainShips,
		[TeamType.Vanguard] = arg0._currentFleetVO.vanguardShips,
		[TeamType.Submarine] = arg0._currentFleetVO.subShips
	}
	local var1 = arg0._currentFleetVO:getFleetType()

	for iter0, iter1 in pairs(var0) do
		local var2 = arg0._cards[iter0]

		if #var2 > 0 then
			local var3 = var1 == FleetType.Submarine and iter0 == TeamType.Vanguard

			for iter2 = 1, 3 do
				if iter2 <= #iter1 then
					local var4 = arg0.shipVOs[iter1[iter2]]

					var2[iter2]:update(var4, var3)
					var2[iter2]:updateProps(arg0:getCardAttrProps(var4))
				else
					var2[iter2]:update(nil, var3)
				end

				arg0:detachOnCardButton(var2[iter2])

				if not var3 then
					arg0:attachOnCardButton(var2[iter2], iter0)
				end
			end
		end
	end

	setActive(arg0:findTF(TeamType.Main, arg0._attrFrame), var1 == FleetType.Normal)
	setActive(arg0:findTF(TeamType.Submarine, arg0._attrFrame), var1 == FleetType.Submarine)
	setActive(arg0:findTF(TeamType.Vanguard .. "/vanguard", arg0._attrFrame), var1 ~= FleetType.Submarine)
	arg0:updateUltimateTitle()
end

function var0.updateUltimateTitle(arg0)
	local var0 = arg0._cards[TeamType.Main]
	local var1 = arg0._currentFleetVO.mainShips

	if #var0 > 0 then
		for iter0 = 1, #var0 do
			go(var0[iter0].shipState):SetActive(iter0 == 1)
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

function var0.detachOnCardButton(arg0, arg1)
	local var0 = GetOrAddComponent(arg1.go, "EventTriggerListener")

	var0:RemovePointClickFunc()
	var0:RemoveBeginDragFunc()
	var0:RemoveDragFunc()
	var0:RemoveDragEndFunc()
end

function var0.attachOnCardButton(arg0, arg1, arg2)
	local var0 = GetOrAddComponent(arg1.go, "EventTriggerListener")

	arg0.eventTriggers[var0] = true

	var0:AddPointClickFunc(function(arg0, arg1)
		if not arg0.carddrag and arg0 == arg1.go then
			if arg1.shipVO then
				arg0:emit(FormationMediator.OPEN_SHIP_INFO, arg1.shipVO.id, arg0._currentFleetVO, var0.TOGGLE_DETAIL)
			else
				arg0:emit(FormationMediator.CHANGE_FLEET_SHIP, arg1.shipVO, arg0._currentFleetVO, var0.TOGGLE_DETAIL, arg2)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end)

	if arg1.shipVO then
		local var1 = arg0._cards[arg2]
		local var2 = arg1.tr.parent:GetComponent("ContentSizeFitter")
		local var3 = arg1.tr.parent:GetComponent("HorizontalLayoutGroup")
		local var4 = arg1.tr.rect.width * 0.5
		local var5 = {}

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

				var5[iter0] = var1[iter0].tr.anchoredPosition
			end

			LeanTween.scale(arg1.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		end)
		var0:AddDragFunc(function(arg0, arg1)
			if arg0.carddrag ~= arg1 then
				return
			end

			local var0 = arg1.tr.localPosition

			var0.x = arg0:change2ScrPos(arg1.tr.parent, arg1.position).x
			arg1.tr.localPosition = var0

			local var1 = 1

			for iter0 = 1, #var1 do
				if var1[iter0] ~= arg1 and var1[iter0].shipVO and arg1.tr.localPosition.x > var1[iter0].tr.localPosition.x + (var1 < arg0._shiftIndex and 1.1 or -1.1) * var4 then
					var1 = var1 + 1
				end
			end

			if arg0._shiftIndex ~= var1 then
				arg0._formationLogic:Shift(arg0._shiftIndex, var1, arg2)
				arg0:shiftCard(arg0._shiftIndex, var1, arg2)

				for iter1 = 1, #var1 do
					if var1[iter1] and var1[iter1] ~= arg1 then
						var1[iter1].tr.anchoredPosition = var5[iter1]
					end
				end
			end
		end)
		var0:AddDragEndFunc(function(arg0, arg1)
			if arg0.carddrag ~= arg1 then
				return
			end

			function resetCard()
				for iter0 = 1, #var1 do
					var1[iter0].tr.anchoredPosition = var5[iter0]
				end

				var2.enabled = true
				var3.enabled = true
				arg0._shiftIndex = nil

				arg0:updateUltimateTitle()
				arg0._formationLogic:SortSiblingIndex()
				arg0:sortCardSiblingIndex()
				arg0:emit(FormationMediator.CHANGE_FLEET_SHIPS_ORDER, arg0._currentFleetVO)

				var0.enabled = true
				arg0.carddrag = nil
			end

			local var0 = arg0._forceDropCharacter

			arg0._forceDropCharacter = nil
			arg0._currentDragDelegate = nil
			var0.enabled = false

			if var0 then
				resetCard()

				arg1.paintingTr.localScale = Vector3(1, 1, 0)
			else
				local var1 = math.min(math.abs(arg1.tr.anchoredPosition.x - var5[arg0._shiftIndex].x) / 200, 1) * 0.3

				LeanTween.value(arg1.go, arg1.tr.anchoredPosition.x, var5[arg0._shiftIndex].x, var1):setEase(LeanTweenType.easeOutCubic):setOnUpdate(System.Action_float(function(arg0)
					local var0 = arg1.tr.anchoredPosition

					var0.x = arg0
					arg1.tr.anchoredPosition = var0
				end)):setOnComplete(System.Action(function()
					resetCard()
					LeanTween.scale(arg1.paintingTr, Vector3(1, 1, 0), 0.3)
				end))
			end
		end)
	end
end

function var0.shiftCard(arg0, arg1, arg2, arg3)
	local var0 = arg0._cards[arg3]

	if #var0 > 0 then
		var0[arg1], var0[arg2] = var0[arg2], var0[arg1]
	end

	arg0._shiftIndex = arg2
end

function var0.change2ScrPos(arg0, arg1, arg2)
	local var0 = pg.UIMgr.GetInstance().overlayCameraComp

	return (LuaHelper.ScreenToLocal(arg1, arg2, var0))
end

function var0.tweenNumText(arg0, arg1, arg2, arg3, arg4)
	LeanTween.value(go(arg0), arg4 or 0, math.floor(arg1), arg2 or 0.7):setOnUpdate(System.Action_float(function(arg0)
		setText(arg0, math.floor(arg0))
	end)):setOnComplete(System.Action(function()
		if arg3 then
			arg3()
		end
	end))
end

function var0.defaultFleetName(arg0)
	if arg0.name == "" or arg0.name == nil then
		return Fleet.DEFAULT_NAME[arg0.id]
	else
		return arg0.name
	end
end

function var0.GetFleetCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0._fleetVOs) do
		var0 = var0 + 1
	end

	return var0
end

function var0.tweenTabArrow(arg0, arg1)
	local var0 = arg0.btnRegular:Find("arr")
	local var1 = arg0.btnSub:Find("arr")

	setActive(var0, arg1)
	setActive(var1, arg1)

	if arg1 then
		LeanTween.moveLocalY(go(var0), var0.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
		LeanTween.moveLocalY(go(var1), var1.localPosition.y + 8, 0.8):setEase(LeanTweenType.easeInOutSine):setLoopPingPong(-1)
	else
		LeanTween.cancel(go(var0))
		LeanTween.cancel(go(var1))

		local var2 = var0.localPosition

		var2.y = 80
		var0.localPosition = var2

		local var3 = var1.localPosition

		var3.y = 80
		var1.localPosition = var3
	end
end

function var0.recyclePainting(arg0)
	for iter0, iter1 in pairs(arg0._cards) do
		for iter2, iter3 in ipairs(iter1) do
			iter3:clear()
		end
	end
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if isActive(arg0._renamePanel) then
		arg0:DisplayRenamePanel(false)
	else
		triggerButton(arg0.backBtn)
	end
end

function var0.willExit(arg0)
	arg0.commanderFormationPanel:Destroy()

	if arg0._attrFrame.gameObject.activeSelf then
		pg.UIMgr.GetInstance():UnblurPanel(arg0._blurLayer, arg0._tf)
	end

	arg0._formationLogic:Destroy()
	arg0:recyclePainting()
	arg0:DisplayRenamePanel(false)
	arg0:tweenTabArrow(false)

	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end

	if arg0.eventTriggers then
		for iter0, iter1 in pairs(arg0.eventTriggers) do
			ClearEventTrigger(iter0)
		end

		arg0.eventTriggers = nil
	end
end

return var0
