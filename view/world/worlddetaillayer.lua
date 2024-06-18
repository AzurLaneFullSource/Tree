local var0_0 = class("WorldDetailLayer", import("..base.BaseUI"))
local var1_0 = import("..ship.FormationUI")

function var0_0.getUIName(arg0_1)
	return "WorldDetailUI"
end

var0_0.TOGGLE_DETAIL = "detailToggle"
var0_0.TOGGLE_FORMATION = "formationToggle"

function var0_0.init(arg0_2)
	arg0_2.eventTriggers = {}
	arg0_2.rtMain = arg0_2:findTF("main")
	arg0_2.bgFleet = arg0_2.rtMain:Find("bg_fleet")
	arg0_2.bgSub = arg0_2.rtMain:Find("bg_sub")
	arg0_2.vanguardGS = arg0_2.rtMain:Find("gear_score/vanguard")
	arg0_2.vanguardUpGS = arg0_2.vanguardGS:Find("up")
	arg0_2.vanguardDownGS = arg0_2.vanguardGS:Find("down")
	arg0_2.mainGS = arg0_2.rtMain:Find("gear_score/main")
	arg0_2.mainUpGS = arg0_2.mainGS:Find("up")
	arg0_2.mainDownGS = arg0_2.mainGS:Find("down")
	arg0_2.subGS = arg0_2.rtMain:Find("gear_score/submarine")
	arg0_2.subUpGS = arg0_2.subGS:Find("up")
	arg0_2.subDownGS = arg0_2.subGS:Find("down")

	setText(arg0_2.mainGS:Find("Text"), arg0_2.contextData.mainGS or 0)
	setText(arg0_2.vanguardGS:Find("Text"), arg0_2.contextData.vanGS or 0)
	setText(arg0_2.subGS:Find("Text"), arg0_2.contextData.subGS or 0)

	arg0_2.gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0_2.gridFrame = arg0_2.rtMain:Find("GridFrame")

	for iter0_2 = 1, 3 do
		arg0_2.gridTFs[TeamType.Vanguard][iter0_2] = arg0_2.gridFrame:Find("vanguard_" .. iter0_2)
		arg0_2.gridTFs[TeamType.Main][iter0_2] = arg0_2.gridFrame:Find("main_" .. iter0_2)
		arg0_2.gridTFs[TeamType.Submarine][iter0_2] = arg0_2.gridFrame:Find("submarine_" .. iter0_2)
	end

	arg0_2.nextPage = arg0_2.rtMain:Find("nextPage")
	arg0_2.prevPage = arg0_2.rtMain:Find("prevPage")
	arg0_2.heroContainer = arg0_2.rtMain:Find("HeroContainer")
	arg0_2.blurLayer = arg0_2:findTF("blur_container")
	arg0_2.top = arg0_2.blurLayer:Find("top")
	arg0_2.backBtn = arg0_2.top:Find("back_btn")
	arg0_2.playerResOb = arg0_2.top:Find("res")
	arg0_2.resPanel = WorldResource.New()

	tf(arg0_2.resPanel._go):SetParent(tf(arg0_2.playerResOb), false)

	arg0_2.fleetToggleList = arg0_2.blurLayer:Find("bottom/fleet_select/panel")
	arg0_2.detailToggle = arg0_2.blurLayer:Find("bottom/toggle_list/detail_toggle")
	arg0_2.formationToggle = arg0_2.blurLayer:Find("bottom/toggle_list/formation_toggle")
	arg0_2.attrFrame = arg0_2.blurLayer:Find("attr_frame")
	arg0_2.cardTpl = arg0_2._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0_2.cards = {}
	arg0_2.cards[TeamType.Main] = {}
	arg0_2.cards[TeamType.Vanguard] = {}
	arg0_2.cards[TeamType.Submarine] = {}

	setActive(arg0_2.attrFrame, false)
	setActive(arg0_2.cardTpl, false)

	arg0_2.heroInfo = arg0_2:findTF("heroInfo")
	arg0_2.starTpl = arg0_2:findTF("star_tpl")
	arg0_2.commanderFormationPanel = WorldCommanderFormationPage.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.fleetIndex = 1
	arg0_2.formationLogic = BaseFormation.New(arg0_2._tf, arg0_2.heroContainer, arg0_2.heroInfo, arg0_2.gridTFs)

	arg0_2.formationLogic:DisableTip()
	arg0_2:Register()
end

function var0_0.Register(arg0_3)
	local var0_3 = getProxy(ActivityProxy):getBuffShipList()

	arg0_3.formationLogic:AddLoadComplete(function()
		arg0_3:displayFleetInfo()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
	arg0_3.formationLogic:AddHeroInfoModify(function(arg0_5, arg1_5, arg2_5)
		local var0_5 = WorldConst.FetchWorldShip(arg1_5.id)
		local var1_5 = arg1_5:getConfigTable()
		local var2_5 = pg.ship_data_template[arg1_5.configId]
		local var3_5 = findTF(arg0_5, "info")
		local var4_5 = findTF(var3_5, "stars")
		local var5_5 = findTF(var3_5, "energy")
		local var6_5 = arg1_5:getStar()

		for iter0_5 = 1, var6_5 do
			cloneTplTo(arg0_3.starTpl, var4_5)
		end

		local var7_5 = arg1_5:getEnergy() <= Ship.ENERGY_MID
		local var8_5 = findTF(var3_5, "energy")

		if var7_5 then
			local var9_5, var10_5 = arg1_5:getEnergyPrint()
			local var11_5 = GetSpriteFromAtlas("energy", var9_5)

			if not var11_5 then
				warning("找不到疲劳")
			end

			setImageSprite(var8_5, var11_5)
		end

		setActive(var8_5, var7_5)

		local var12_5 = var0_3[arg1_5:getGroupId()]
		local var13_5 = var3_5:Find("expbuff")

		setActive(var13_5, var12_5 ~= nil)

		if var12_5 then
			local var14_5 = var12_5 / 100
			local var15_5 = var12_5 % 100
			local var16_5 = tostring(var14_5)

			if var15_5 > 0 then
				var16_5 = var16_5 .. "." .. tostring(var15_5)
			end

			setText(var13_5:Find("text"), string.format("EXP +%s%%", var16_5))
		end

		local var17_5 = GetSpriteFromAtlas("shiptype", shipType2print(arg1_5:getShipType()))

		if not var17_5 then
			warning("找不到船形, shipConfigId: " .. arg1_5.configId)
		end

		setImageSprite(findTF(var3_5, "type"), var17_5, true)
		setText(findTF(var3_5, "frame/lv_contain/lv"), arg1_5.level)

		local var18_5 = var0_5:IsHpSafe()
		local var19_5 = findTF(var3_5, "blood")
		local var20_5 = findTF(var19_5, "fillarea/green")
		local var21_5 = findTF(var19_5, "fillarea/red")

		setActive(var20_5, var18_5)
		setActive(var21_5, not var18_5)

		var19_5:GetComponent(typeof(Slider)).fillRect = var18_5 and var20_5 or var21_5

		setSlider(var19_5, 0, 10000, var0_5.hpRant)
		setActive(var19_5:Find("broken"), var0_5:IsBroken())
	end)
	arg0_3.formationLogic:AddCheckRemove(function(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
		arg0_6()
	end)
	arg0_3.formationLogic:AddLongPress(function(arg0_7, arg1_7, arg2_7)
		arg0_3:emit(WorldDetailMediator.OnShipInfo, arg1_7.id)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0_3.formationLogic:AddBeginDrag(function(arg0_8)
		local var0_8 = findTF(arg0_8, "info")

		SetActive(var0_8, false)
	end)
	arg0_3.formationLogic:AddEndDrag(function(arg0_9)
		local var0_9 = findTF(arg0_9, "info")

		SetActive(var0_9, true)
	end)
end

function var0_0.didEnter(arg0_10)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_10._tf, {
		groupName = arg0_10:getGroupNameFromData()
	})
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:onBackPressed()
	end, SFX_CANCEL)
	onToggle(arg0_10, arg0_10.detailToggle, function(arg0_12)
		if arg0_12 and not isActive(arg0_10.attrFrame) then
			arg0_10:displayAttrFrame()
		end
	end, SFX_PANEL)
	onToggle(arg0_10, arg0_10.formationToggle, function(arg0_13)
		if arg0_13 and isActive(arg0_10.attrFrame) then
			arg0_10:hideAttrFrame()
		end
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.attrFrame, function()
		triggerToggle(arg0_10.formationToggle, true)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.prevPage, function()
		local var0_15 = arg0_10:SelectFleetByStep(-1)

		if not var0_15 then
			return
		end

		triggerToggle(arg0_10.fleetToggleList:GetChild(var0_15 - 1), true)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.nextPage, function()
		local var0_16 = arg0_10:SelectFleetByStep(1)

		if not var0_16 then
			return
		end

		triggerToggle(arg0_10.fleetToggleList:GetChild(var0_16 - 1), true)
	end, SFX_PANEL)
	arg0_10:updateFleetIndex(arg0_10.fleetIndex)
	arg0_10:updateToggleList()
	arg0_10.commanderFormationPanel:ActionInvoke("Show")
	triggerToggle(arg0_10[arg0_10.contextData.toggle or var0_0.TOGGLE_FORMATION], true)
end

function var0_0.SelectFleetByStep(arg0_17, arg1_17)
	local var0_17 = arg0_17.fleetIndex + arg1_17

	return var0_17 >= 1 and var0_17 <= #arg0_17.fleets and arg0_17.fleets[var0_17].id
end

function var0_0.onBackPressed(arg0_18)
	if isActive(arg0_18.attrFrame) then
		triggerToggle(arg0_18.formationToggle, true)

		return
	end

	arg0_18:closeView()
end

function var0_0.updateFleetBg(arg0_19)
	local var0_19 = arg0_19:getCurrentFleet():GetFleetType()

	setActive(arg0_19.bgFleet, var0_19 == FleetType.Normal)
	setActive(arg0_19.bgSub, var0_19 == FleetType.Submarine)
end

function var0_0.updateToggleList(arg0_20)
	local var0_20

	for iter0_20 = 1, arg0_20.fleetToggleList.childCount do
		local var1_20 = arg0_20.fleetToggleList:GetChild(iter0_20 - 1)
		local var2_20 = arg0_20.fleets[iter0_20]
		local var3_20, var4_20, var5_20 = nowWorld():BuildFormationIds()

		setActive(var1_20, iter0_20 <= var5_20)
		setToggleEnabled(var1_20, tobool(var2_20))
		setActive(var1_20:Find("lock"), not tobool(var2_20))

		if var2_20 then
			onToggle(arg0_20, var1_20, function(arg0_21)
				if arg0_21 and var2_20.id ~= arg0_20.fleetIndex then
					arg0_20:updateFleetIndex(iter0_20)
				end
			end, SFX_UI_TAG)

			if var2_20.id == arg0_20.fleetIndex then
				var0_20 = var1_20
			end
		else
			onButton(arg0_20, var1_20:Find("lock"), function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_redeploy_tip"))
			end)
		end
	end

	triggerToggle(var0_20, true)
end

function var0_0.setPlayerInfo(arg0_23, arg1_23)
	arg0_23.resPanel:setPlayer(arg1_23)
	setActive(arg0_23.resPanel._tf, nowWorld():IsSystemOpen(WorldConst.SystemResource))
end

function var0_0.setFleets(arg0_24, arg1_24)
	arg0_24.fleets = arg1_24

	for iter0_24, iter1_24 in ipairs(arg0_24.fleets) do
		if iter1_24.id == arg0_24.contextData.fleetId then
			arg0_24.fleetIndex = iter0_24
		end
	end
end

function var0_0.getCurrentFleet(arg0_25)
	return arg0_25.fleets[arg0_25.fleetIndex]
end

function var0_0.updateFleetIndex(arg0_26, arg1_26)
	arg0_26.fleetIndex = arg1_26

	arg0_26:updateFormationData()
	arg0_26:updateFleetBg()
	arg0_26:updateCharacters()
	arg0_26:updatePageBtn()
	arg0_26:updateCommanderFormation()
end

function var0_0.updateFormationData(arg0_27)
	local var0_27 = {}
	local var1_27 = arg0_27:getCurrentFleet()

	arg0_27.formationLogic:SetShipVOs(var1_27:getShipVOsDic())
	arg0_27.formationLogic:SetFleetVO(arg0_27:getCurrentFleet())
end

function var0_0.updateCommanderFormation(arg0_28)
	arg0_28.commanderFormationPanel:Load()
	arg0_28.commanderFormationPanel:ActionInvoke("Update", arg0_28:getCurrentFleet())
end

function var0_0.updateCharacters(arg0_29)
	pg.UIMgr.GetInstance():LoadingOn()
	arg0_29.formationLogic:ResetGrid(TeamType.Vanguard, true)
	arg0_29.formationLogic:ResetGrid(TeamType.Main, true)
	arg0_29.formationLogic:ResetGrid(TeamType.Submarine, true)
	arg0_29:updateAttrFrame()
	arg0_29.formationLogic:LoadAllCharacter()
end

function var0_0.updatePageBtn(arg0_30)
	setActive(arg0_30.prevPage, arg0_30:SelectFleetByStep(-1))
	setActive(arg0_30.nextPage, arg0_30:SelectFleetByStep(1))
end

function var0_0.shiftCard(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = arg0_31.cards[arg3_31]

	if #var0_31 > 0 then
		var0_31[arg1_31], var0_31[arg2_31] = var0_31[arg2_31], var0_31[arg1_31]
	end

	arg0_31.shiftIndex = arg2_31

	arg0_31:sortCardSiblingIndex()
end

function var0_0.sortCardSiblingIndex(arg0_32)
	local var0_32 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0_32, function(arg0_33)
		local var0_33 = arg0_32.cards[arg0_33]

		if #var0_33 > 0 then
			for iter0_33 = 1, #var0_33 do
				var0_33[iter0_33].tr:SetSiblingIndex(iter0_33 - 1)
			end
		end
	end)
end

function var0_0.displayFleetInfo(arg0_34)
	local var0_34 = arg0_34:getCurrentFleet()

	setActive(arg0_34.vanguardGS, false)
	setActive(arg0_34.mainGS, false)
	setActive(arg0_34.subGS, false)

	local var1_34 = var0_34:GetFleetType()
	local var2_34 = _.reduce(var0_34:GetTeamShipVOs(TeamType.Vanguard, false), 0, function(arg0_35, arg1_35)
		return arg0_35 + arg1_35:getShipCombatPower()
	end)
	local var3_34 = _.reduce(var0_34:GetTeamShipVOs(TeamType.Main, false), 0, function(arg0_36, arg1_36)
		return arg0_36 + arg1_36:getShipCombatPower()
	end)
	local var4_34 = _.reduce(var0_34:GetTeamShipVOs(TeamType.Submarine, false), 0, function(arg0_37, arg1_37)
		return arg0_37 + arg1_37:getShipCombatPower()
	end)

	if var1_34 == FleetType.Normal then
		setActive(arg0_34.vanguardGS, true)
		setActive(arg0_34.vanguardUpGS, false)
		setActive(arg0_34.vanguardDownGS, false)
		setActive(arg0_34.mainGS, true)
		setActive(arg0_34.mainUpGS, false)
		setActive(arg0_34.mainDownGS, false)

		if arg0_34.contextData.vanGS then
			setActive(arg0_34.vanguardUpGS, var2_34 > arg0_34.contextData.vanGS)
			setActive(arg0_34.vanguardDownGS, var2_34 < arg0_34.contextData.vanGS)
		end

		var1_0.tweenNumText(arg0_34.vanguardGS:Find("Text"), var2_34)

		if arg0_34.contextData.mainGS then
			setActive(arg0_34.mainUpGS, var3_34 > arg0_34.contextData.mainGS)
			setActive(arg0_34.mainDownGS, var3_34 < arg0_34.contextData.mainGS)
		end

		var1_0.tweenNumText(arg0_34.mainGS:Find("Text"), var3_34)

		arg0_34.contextData.vanGS = var2_34
		arg0_34.contextData.mainGS = var3_34
	elseif var1_34 == FleetType.Submarine then
		setActive(arg0_34.subGS, true)
		setActive(arg0_34.subUpGS, false)
		setActive(arg0_34.subDownGS, false)

		if arg0_34.contextData.subGS then
			setActive(arg0_34.subUpGS, var4_34 > arg0_34.contextData.subGS)
			setActive(arg0_34.subDownGS, var4_34 < arg0_34.contextData.subGS)
		end

		var1_0.tweenNumText(arg0_34.subGS:Find("Text"), var4_34)

		arg0_34.contextData.subGS = var4_34
	end
end

function var0_0.displayAttrFrame(arg0_38)
	pg.UIMgr.GetInstance():BlurPanel(arg0_38.blurLayer, true)
	SetActive(arg0_38.attrFrame, true)
	arg0_38:initAttrFrame()
end

function var0_0.hideAttrFrame(arg0_39)
	SetActive(arg0_39.attrFrame, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_39.blurLayer, arg0_39._tf)
end

function var0_0.initAttrFrame(arg0_40)
	local var0_40 = {}
	local var1_40 = arg0_40:getCurrentFleet()

	var0_40[TeamType.Main] = var1_40[TeamType.Main]
	var0_40[TeamType.Vanguard] = var1_40[TeamType.Vanguard]
	var0_40[TeamType.Submarine] = var1_40[TeamType.Submarine]

	local var2_40 = false

	for iter0_40, iter1_40 in pairs(var0_40) do
		local var3_40 = arg0_40.cards[iter0_40]

		if #var3_40 == 0 then
			local var4_40 = arg0_40:findTF(iter0_40 .. "/list", arg0_40.attrFrame)

			for iter2_40 = 1, 3 do
				local var5_40 = cloneTplTo(arg0_40.cardTpl, var4_40).gameObject

				table.insert(var3_40, FormationDetailCard.New(var5_40))
			end

			var2_40 = true
		end
	end

	if var2_40 then
		arg0_40:updateAttrFrame()
	end
end

function var0_0.updateAttrFrame(arg0_41)
	local var0_41 = {}
	local var1_41 = arg0_41:getCurrentFleet()

	var0_41[TeamType.Main] = var1_41[TeamType.Main]
	var0_41[TeamType.Vanguard] = var1_41[TeamType.Vanguard]
	var0_41[TeamType.Submarine] = var1_41[TeamType.Submarine]

	local var2_41 = var1_41:GetFleetType()

	for iter0_41, iter1_41 in pairs(var0_41) do
		local var3_41 = arg0_41.cards[iter0_41]

		if #var3_41 > 0 then
			local var4_41 = var2_41 == FleetType.Submarine and iter0_41 == TeamType.Vanguard

			for iter2_41 = 1, 3 do
				if iter2_41 <= #iter1_41 then
					local var5_41 = WorldConst.FetchShipVO(iter1_41[iter2_41].id)

					var3_41[iter2_41]:update(var5_41, var4_41)
					var3_41[iter2_41]:updateProps(arg0_41:getCardAttrProps(var5_41))
				else
					var3_41[iter2_41]:update(nil, var4_41)
				end

				arg0_41:detachOnCardButton(var3_41[iter2_41])

				if not var4_41 then
					arg0_41:attachOnCardButton(var3_41[iter2_41], iter0_41)
				end
			end
		end
	end

	setActive(arg0_41:findTF(TeamType.Main, arg0_41.attrFrame), var2_41 == FleetType.Normal)
	setActive(arg0_41:findTF(TeamType.Submarine, arg0_41.attrFrame), var2_41 == FleetType.Submarine)
	setActive(arg0_41:findTF(TeamType.Vanguard .. "/vanguard", arg0_41.attrFrame), var2_41 ~= FleetType.Submarine)
	arg0_41:updateUltimateTitle()
end

function var0_0.updateUltimateTitle(arg0_42)
	local var0_42 = arg0_42.cards[TeamType.Main]

	if #var0_42 > 0 then
		for iter0_42 = 1, #var0_42 do
			go(var0_42[iter0_42].shipState):SetActive(iter0_42 == 1)
		end
	end
end

function var0_0.getCardAttrProps(arg0_43, arg1_43)
	local var0_43 = arg1_43:getProperties()
	local var1_43 = arg1_43:getShipCombatPower()
	local var2_43 = arg1_43:getBattleTotalExpend()

	return {
		{
			i18n("word_attr_durability"),
			tostring(math.floor(var0_43.durability))
		},
		{
			i18n("word_attr_luck"),
			"" .. tostring(math.floor(var2_43))
		},
		{
			i18n("word_synthesize_power"),
			"<color=#ffff00>" .. math.floor(var1_43) .. "</color>"
		}
	}
end

function var0_0.detachOnCardButton(arg0_44, arg1_44)
	local var0_44 = GetOrAddComponent(arg1_44.go, "EventTriggerListener")

	var0_44:RemovePointDownFunc()
	var0_44:RemovePointUpFunc()
	var0_44:RemoveBeginDragFunc()
	var0_44:RemoveDragFunc()
	var0_44:RemoveDragEndFunc()
end

function var0_0.attachOnCardButton(arg0_45, arg1_45, arg2_45)
	local var0_45 = GetOrAddComponent(arg1_45.go, "EventTriggerListener")

	arg0_45.eventTriggers[var0_45] = true

	var0_45:AddPointClickFunc(function(arg0_46, arg1_46)
		if not arg0_45.carddrag and arg0_46 == arg1_45.go then
			if arg1_45.shipVO then
				arg0_45:emit(WorldDetailMediator.OnShipInfo, arg1_45.shipVO.id, var0_0.TOGGLE_DETAIL)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end)

	if arg1_45.shipVO then
		local var1_45 = arg0_45.cards[arg2_45]
		local var2_45 = arg1_45.tr.parent:GetComponent("ContentSizeFitter")
		local var3_45 = arg1_45.tr.parent:GetComponent("HorizontalLayoutGroup")
		local var4_45 = arg1_45.tr.rect.width * 0.5
		local var5_45 = {}

		var0_45:AddBeginDragFunc(function()
			if arg0_45.carddrag then
				return
			end

			arg0_45.carddrag = arg1_45
			var2_45.enabled = false
			var3_45.enabled = false

			arg1_45.tr:SetSiblingIndex(#var1_45)

			for iter0_47 = 1, #var1_45 do
				if var1_45[iter0_47] == arg1_45 then
					arg0_45.shiftIndex = iter0_47
				end

				var5_45[iter0_47] = var1_45[iter0_47].tr.anchoredPosition
			end

			LeanTween.scale(arg1_45.paintingTr, Vector3(1.1, 1.1, 0), 0.3)
		end)
		var0_45:AddDragFunc(function(arg0_48, arg1_48)
			if arg0_45.carddrag ~= arg1_45 then
				return
			end

			local var0_48 = arg1_45.tr.localPosition

			var0_48.x = arg0_45:change2ScrPos(arg1_45.tr.parent, arg1_48.position).x
			arg1_45.tr.localPosition = var0_48

			local var1_48 = 1

			for iter0_48 = 1, #var1_45 do
				if var1_45[iter0_48] ~= arg1_45 and var1_45[iter0_48].shipVO and arg1_45.tr.localPosition.x > var1_45[iter0_48].tr.localPosition.x + (var1_48 < arg0_45.shiftIndex and 1.1 or -1.1) * var4_45 then
					var1_48 = var1_48 + 1
				end
			end

			if arg0_45.shiftIndex ~= var1_48 then
				arg0_45.formationLogic:Shift(arg0_45.shiftIndex, var1_48, arg2_45)
				arg0_45:shiftCard(arg0_45.shiftIndex, var1_48, arg2_45)

				for iter1_48 = 1, #var1_45 do
					if var1_45[iter1_48] and var1_45[iter1_48] ~= arg1_45 then
						var1_45[iter1_48].tr.anchoredPosition = var5_45[iter1_48]
					end
				end
			end
		end)
		var0_45:AddDragEndFunc(function(arg0_49, arg1_49)
			if arg0_45.carddrag ~= arg1_45 then
				return
			end

			local var0_49 = math.min(math.abs(arg1_45.tr.anchoredPosition.x - var5_45[arg0_45.shiftIndex].x) / 200, 1) * 0.3

			LeanTween.value(arg1_45.go, arg1_45.tr.anchoredPosition.x, var5_45[arg0_45.shiftIndex].x, var0_49):setEase(LeanTweenType.easeOutCubic):setOnUpdate(System.Action_float(function(arg0_50)
				local var0_50 = arg1_45.tr.anchoredPosition

				var0_50.x = arg0_50
				arg1_45.tr.anchoredPosition = var0_50
			end)):setOnComplete(System.Action(function()
				var2_45.enabled = true
				var3_45.enabled = true
				arg0_45.shiftIndex = nil

				arg0_45:updateUltimateTitle()
				arg0_45.formationLogic:SwitchToDisplayMode()
				arg0_45.formationLogic:SortSiblingIndex()
				arg0_45:sortCardSiblingIndex()

				arg0_45.carddrag = nil

				LeanTween.scale(arg1_45.paintingTr, Vector3(1, 1, 0), 0.3)
			end))
		end)
	end
end

function var0_0.change2ScrPos(arg0_52, arg1_52, arg2_52)
	local var0_52 = GameObject.Find("OverlayCamera"):GetComponent("Camera")

	return (LuaHelper.ScreenToLocal(arg1_52, arg2_52, var0_52))
end

function var0_0.recyclePainting(arg0_53)
	for iter0_53, iter1_53 in pairs(arg0_53.cards) do
		for iter2_53, iter3_53 in ipairs(iter1_53) do
			iter3_53:clear()
		end
	end
end

function var0_0.willExit(arg0_54)
	arg0_54.commanderFormationPanel:Destroy()

	if isActive(arg0_54.attrFrame) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_54.blurLayer, arg0_54._tf)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_54._tf)

	if arg0_54.resPanel then
		arg0_54.resPanel:exit()

		arg0_54.resPanel = nil
	end

	if arg0_54.eventTriggers then
		for iter0_54, iter1_54 in pairs(arg0_54.eventTriggers) do
			ClearEventTrigger(iter0_54)
		end

		arg0_54.eventTriggers = nil
	end

	local var0_54 = arg0_54:getCurrentFleet()

	arg0_54.formationLogic:Destroy()
	arg0_54:recyclePainting()
end

return var0_0
