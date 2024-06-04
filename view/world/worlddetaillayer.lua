local var0 = class("WorldDetailLayer", import("..base.BaseUI"))
local var1 = import("..ship.FormationUI")

function var0.getUIName(arg0)
	return "WorldDetailUI"
end

var0.TOGGLE_DETAIL = "detailToggle"
var0.TOGGLE_FORMATION = "formationToggle"

function var0.init(arg0)
	arg0.eventTriggers = {}
	arg0.rtMain = arg0:findTF("main")
	arg0.bgFleet = arg0.rtMain:Find("bg_fleet")
	arg0.bgSub = arg0.rtMain:Find("bg_sub")
	arg0.vanguardGS = arg0.rtMain:Find("gear_score/vanguard")
	arg0.vanguardUpGS = arg0.vanguardGS:Find("up")
	arg0.vanguardDownGS = arg0.vanguardGS:Find("down")
	arg0.mainGS = arg0.rtMain:Find("gear_score/main")
	arg0.mainUpGS = arg0.mainGS:Find("up")
	arg0.mainDownGS = arg0.mainGS:Find("down")
	arg0.subGS = arg0.rtMain:Find("gear_score/submarine")
	arg0.subUpGS = arg0.subGS:Find("up")
	arg0.subDownGS = arg0.subGS:Find("down")

	setText(arg0.mainGS:Find("Text"), arg0.contextData.mainGS or 0)
	setText(arg0.vanguardGS:Find("Text"), arg0.contextData.vanGS or 0)
	setText(arg0.subGS:Find("Text"), arg0.contextData.subGS or 0)

	arg0.gridTFs = {
		[TeamType.Vanguard] = {},
		[TeamType.Main] = {},
		[TeamType.Submarine] = {}
	}
	arg0.gridFrame = arg0.rtMain:Find("GridFrame")

	for iter0 = 1, 3 do
		arg0.gridTFs[TeamType.Vanguard][iter0] = arg0.gridFrame:Find("vanguard_" .. iter0)
		arg0.gridTFs[TeamType.Main][iter0] = arg0.gridFrame:Find("main_" .. iter0)
		arg0.gridTFs[TeamType.Submarine][iter0] = arg0.gridFrame:Find("submarine_" .. iter0)
	end

	arg0.nextPage = arg0.rtMain:Find("nextPage")
	arg0.prevPage = arg0.rtMain:Find("prevPage")
	arg0.heroContainer = arg0.rtMain:Find("HeroContainer")
	arg0.blurLayer = arg0:findTF("blur_container")
	arg0.top = arg0.blurLayer:Find("top")
	arg0.backBtn = arg0.top:Find("back_btn")
	arg0.playerResOb = arg0.top:Find("res")
	arg0.resPanel = WorldResource.New()

	tf(arg0.resPanel._go):SetParent(tf(arg0.playerResOb), false)

	arg0.fleetToggleList = arg0.blurLayer:Find("bottom/fleet_select/panel")
	arg0.detailToggle = arg0.blurLayer:Find("bottom/toggle_list/detail_toggle")
	arg0.formationToggle = arg0.blurLayer:Find("bottom/toggle_list/formation_toggle")
	arg0.attrFrame = arg0.blurLayer:Find("attr_frame")
	arg0.cardTpl = arg0._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0.cards = {}
	arg0.cards[TeamType.Main] = {}
	arg0.cards[TeamType.Vanguard] = {}
	arg0.cards[TeamType.Submarine] = {}

	setActive(arg0.attrFrame, false)
	setActive(arg0.cardTpl, false)

	arg0.heroInfo = arg0:findTF("heroInfo")
	arg0.starTpl = arg0:findTF("star_tpl")
	arg0.commanderFormationPanel = WorldCommanderFormationPage.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.fleetIndex = 1
	arg0.formationLogic = BaseFormation.New(arg0._tf, arg0.heroContainer, arg0.heroInfo, arg0.gridTFs)

	arg0.formationLogic:DisableTip()
	arg0:Register()
end

function var0.Register(arg0)
	local var0 = getProxy(ActivityProxy):getBuffShipList()

	arg0.formationLogic:AddLoadComplete(function()
		arg0:displayFleetInfo()
		pg.UIMgr.GetInstance():LoadingOff()
	end)
	arg0.formationLogic:AddHeroInfoModify(function(arg0, arg1, arg2)
		local var0 = WorldConst.FetchWorldShip(arg1.id)
		local var1 = arg1:getConfigTable()
		local var2 = pg.ship_data_template[arg1.configId]
		local var3 = findTF(arg0, "info")
		local var4 = findTF(var3, "stars")
		local var5 = findTF(var3, "energy")
		local var6 = arg1:getStar()

		for iter0 = 1, var6 do
			cloneTplTo(arg0.starTpl, var4)
		end

		local var7 = arg1:getEnergy() <= Ship.ENERGY_MID
		local var8 = findTF(var3, "energy")

		if var7 then
			local var9, var10 = arg1:getEnergyPrint()
			local var11 = GetSpriteFromAtlas("energy", var9)

			if not var11 then
				warning("找不到疲劳")
			end

			setImageSprite(var8, var11)
		end

		setActive(var8, var7)

		local var12 = var0[arg1:getGroupId()]
		local var13 = var3:Find("expbuff")

		setActive(var13, var12 ~= nil)

		if var12 then
			local var14 = var12 / 100
			local var15 = var12 % 100
			local var16 = tostring(var14)

			if var15 > 0 then
				var16 = var16 .. "." .. tostring(var15)
			end

			setText(var13:Find("text"), string.format("EXP +%s%%", var16))
		end

		local var17 = GetSpriteFromAtlas("shiptype", shipType2print(arg1:getShipType()))

		if not var17 then
			warning("找不到船形, shipConfigId: " .. arg1.configId)
		end

		setImageSprite(findTF(var3, "type"), var17, true)
		setText(findTF(var3, "frame/lv_contain/lv"), arg1.level)

		local var18 = var0:IsHpSafe()
		local var19 = findTF(var3, "blood")
		local var20 = findTF(var19, "fillarea/green")
		local var21 = findTF(var19, "fillarea/red")

		setActive(var20, var18)
		setActive(var21, not var18)

		var19:GetComponent(typeof(Slider)).fillRect = var18 and var20 or var21

		setSlider(var19, 0, 10000, var0.hpRant)
		setActive(var19:Find("broken"), var0:IsBroken())
	end)
	arg0.formationLogic:AddCheckRemove(function(arg0, arg1, arg2, arg3, arg4)
		arg0()
	end)
	arg0.formationLogic:AddLongPress(function(arg0, arg1, arg2)
		arg0:emit(WorldDetailMediator.OnShipInfo, arg1.id)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
	end)
	arg0.formationLogic:AddBeginDrag(function(arg0)
		local var0 = findTF(arg0, "info")

		SetActive(var0, false)
	end)
	arg0.formationLogic:AddEndDrag(function(arg0)
		local var0 = findTF(arg0, "info")

		SetActive(var0, true)
	end)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData()
	})
	onButton(arg0, arg0.backBtn, function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onToggle(arg0, arg0.detailToggle, function(arg0)
		if arg0 and not isActive(arg0.attrFrame) then
			arg0:displayAttrFrame()
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.formationToggle, function(arg0)
		if arg0 and isActive(arg0.attrFrame) then
			arg0:hideAttrFrame()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.attrFrame, function()
		triggerToggle(arg0.formationToggle, true)
	end, SFX_PANEL)
	onButton(arg0, arg0.prevPage, function()
		local var0 = arg0:SelectFleetByStep(-1)

		if not var0 then
			return
		end

		triggerToggle(arg0.fleetToggleList:GetChild(var0 - 1), true)
	end, SFX_PANEL)
	onButton(arg0, arg0.nextPage, function()
		local var0 = arg0:SelectFleetByStep(1)

		if not var0 then
			return
		end

		triggerToggle(arg0.fleetToggleList:GetChild(var0 - 1), true)
	end, SFX_PANEL)
	arg0:updateFleetIndex(arg0.fleetIndex)
	arg0:updateToggleList()
	arg0.commanderFormationPanel:ActionInvoke("Show")
	triggerToggle(arg0[arg0.contextData.toggle or var0.TOGGLE_FORMATION], true)
end

function var0.SelectFleetByStep(arg0, arg1)
	local var0 = arg0.fleetIndex + arg1

	return var0 >= 1 and var0 <= #arg0.fleets and arg0.fleets[var0].id
end

function var0.onBackPressed(arg0)
	if isActive(arg0.attrFrame) then
		triggerToggle(arg0.formationToggle, true)

		return
	end

	arg0:closeView()
end

function var0.updateFleetBg(arg0)
	local var0 = arg0:getCurrentFleet():GetFleetType()

	setActive(arg0.bgFleet, var0 == FleetType.Normal)
	setActive(arg0.bgSub, var0 == FleetType.Submarine)
end

function var0.updateToggleList(arg0)
	local var0

	for iter0 = 1, arg0.fleetToggleList.childCount do
		local var1 = arg0.fleetToggleList:GetChild(iter0 - 1)
		local var2 = arg0.fleets[iter0]
		local var3, var4, var5 = nowWorld():BuildFormationIds()

		setActive(var1, iter0 <= var5)
		setToggleEnabled(var1, tobool(var2))
		setActive(var1:Find("lock"), not tobool(var2))

		if var2 then
			onToggle(arg0, var1, function(arg0)
				if arg0 and var2.id ~= arg0.fleetIndex then
					arg0:updateFleetIndex(iter0)
				end
			end, SFX_UI_TAG)

			if var2.id == arg0.fleetIndex then
				var0 = var1
			end
		else
			onButton(arg0, var1:Find("lock"), function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_redeploy_tip"))
			end)
		end
	end

	triggerToggle(var0, true)
end

function var0.setPlayerInfo(arg0, arg1)
	arg0.resPanel:setPlayer(arg1)
	setActive(arg0.resPanel._tf, nowWorld():IsSystemOpen(WorldConst.SystemResource))
end

function var0.setFleets(arg0, arg1)
	arg0.fleets = arg1

	for iter0, iter1 in ipairs(arg0.fleets) do
		if iter1.id == arg0.contextData.fleetId then
			arg0.fleetIndex = iter0
		end
	end
end

function var0.getCurrentFleet(arg0)
	return arg0.fleets[arg0.fleetIndex]
end

function var0.updateFleetIndex(arg0, arg1)
	arg0.fleetIndex = arg1

	arg0:updateFormationData()
	arg0:updateFleetBg()
	arg0:updateCharacters()
	arg0:updatePageBtn()
	arg0:updateCommanderFormation()
end

function var0.updateFormationData(arg0)
	local var0 = {}
	local var1 = arg0:getCurrentFleet()

	arg0.formationLogic:SetShipVOs(var1:getShipVOsDic())
	arg0.formationLogic:SetFleetVO(arg0:getCurrentFleet())
end

function var0.updateCommanderFormation(arg0)
	arg0.commanderFormationPanel:Load()
	arg0.commanderFormationPanel:ActionInvoke("Update", arg0:getCurrentFleet())
end

function var0.updateCharacters(arg0)
	pg.UIMgr.GetInstance():LoadingOn()
	arg0.formationLogic:ResetGrid(TeamType.Vanguard, true)
	arg0.formationLogic:ResetGrid(TeamType.Main, true)
	arg0.formationLogic:ResetGrid(TeamType.Submarine, true)
	arg0:updateAttrFrame()
	arg0.formationLogic:LoadAllCharacter()
end

function var0.updatePageBtn(arg0)
	setActive(arg0.prevPage, arg0:SelectFleetByStep(-1))
	setActive(arg0.nextPage, arg0:SelectFleetByStep(1))
end

function var0.shiftCard(arg0, arg1, arg2, arg3)
	local var0 = arg0.cards[arg3]

	if #var0 > 0 then
		var0[arg1], var0[arg2] = var0[arg2], var0[arg1]
	end

	arg0.shiftIndex = arg2

	arg0:sortCardSiblingIndex()
end

function var0.sortCardSiblingIndex(arg0)
	local var0 = {
		TeamType.Main,
		TeamType.Vanguard,
		TeamType.Submarine
	}

	_.each(var0, function(arg0)
		local var0 = arg0.cards[arg0]

		if #var0 > 0 then
			for iter0 = 1, #var0 do
				var0[iter0].tr:SetSiblingIndex(iter0 - 1)
			end
		end
	end)
end

function var0.displayFleetInfo(arg0)
	local var0 = arg0:getCurrentFleet()

	setActive(arg0.vanguardGS, false)
	setActive(arg0.mainGS, false)
	setActive(arg0.subGS, false)

	local var1 = var0:GetFleetType()
	local var2 = _.reduce(var0:GetTeamShipVOs(TeamType.Vanguard, false), 0, function(arg0, arg1)
		return arg0 + arg1:getShipCombatPower()
	end)
	local var3 = _.reduce(var0:GetTeamShipVOs(TeamType.Main, false), 0, function(arg0, arg1)
		return arg0 + arg1:getShipCombatPower()
	end)
	local var4 = _.reduce(var0:GetTeamShipVOs(TeamType.Submarine, false), 0, function(arg0, arg1)
		return arg0 + arg1:getShipCombatPower()
	end)

	if var1 == FleetType.Normal then
		setActive(arg0.vanguardGS, true)
		setActive(arg0.vanguardUpGS, false)
		setActive(arg0.vanguardDownGS, false)
		setActive(arg0.mainGS, true)
		setActive(arg0.mainUpGS, false)
		setActive(arg0.mainDownGS, false)

		if arg0.contextData.vanGS then
			setActive(arg0.vanguardUpGS, var2 > arg0.contextData.vanGS)
			setActive(arg0.vanguardDownGS, var2 < arg0.contextData.vanGS)
		end

		var1.tweenNumText(arg0.vanguardGS:Find("Text"), var2)

		if arg0.contextData.mainGS then
			setActive(arg0.mainUpGS, var3 > arg0.contextData.mainGS)
			setActive(arg0.mainDownGS, var3 < arg0.contextData.mainGS)
		end

		var1.tweenNumText(arg0.mainGS:Find("Text"), var3)

		arg0.contextData.vanGS = var2
		arg0.contextData.mainGS = var3
	elseif var1 == FleetType.Submarine then
		setActive(arg0.subGS, true)
		setActive(arg0.subUpGS, false)
		setActive(arg0.subDownGS, false)

		if arg0.contextData.subGS then
			setActive(arg0.subUpGS, var4 > arg0.contextData.subGS)
			setActive(arg0.subDownGS, var4 < arg0.contextData.subGS)
		end

		var1.tweenNumText(arg0.subGS:Find("Text"), var4)

		arg0.contextData.subGS = var4
	end
end

function var0.displayAttrFrame(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0.blurLayer, true)
	SetActive(arg0.attrFrame, true)
	arg0:initAttrFrame()
end

function var0.hideAttrFrame(arg0)
	SetActive(arg0.attrFrame, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.blurLayer, arg0._tf)
end

function var0.initAttrFrame(arg0)
	local var0 = {}
	local var1 = arg0:getCurrentFleet()

	var0[TeamType.Main] = var1[TeamType.Main]
	var0[TeamType.Vanguard] = var1[TeamType.Vanguard]
	var0[TeamType.Submarine] = var1[TeamType.Submarine]

	local var2 = false

	for iter0, iter1 in pairs(var0) do
		local var3 = arg0.cards[iter0]

		if #var3 == 0 then
			local var4 = arg0:findTF(iter0 .. "/list", arg0.attrFrame)

			for iter2 = 1, 3 do
				local var5 = cloneTplTo(arg0.cardTpl, var4).gameObject

				table.insert(var3, FormationDetailCard.New(var5))
			end

			var2 = true
		end
	end

	if var2 then
		arg0:updateAttrFrame()
	end
end

function var0.updateAttrFrame(arg0)
	local var0 = {}
	local var1 = arg0:getCurrentFleet()

	var0[TeamType.Main] = var1[TeamType.Main]
	var0[TeamType.Vanguard] = var1[TeamType.Vanguard]
	var0[TeamType.Submarine] = var1[TeamType.Submarine]

	local var2 = var1:GetFleetType()

	for iter0, iter1 in pairs(var0) do
		local var3 = arg0.cards[iter0]

		if #var3 > 0 then
			local var4 = var2 == FleetType.Submarine and iter0 == TeamType.Vanguard

			for iter2 = 1, 3 do
				if iter2 <= #iter1 then
					local var5 = WorldConst.FetchShipVO(iter1[iter2].id)

					var3[iter2]:update(var5, var4)
					var3[iter2]:updateProps(arg0:getCardAttrProps(var5))
				else
					var3[iter2]:update(nil, var4)
				end

				arg0:detachOnCardButton(var3[iter2])

				if not var4 then
					arg0:attachOnCardButton(var3[iter2], iter0)
				end
			end
		end
	end

	setActive(arg0:findTF(TeamType.Main, arg0.attrFrame), var2 == FleetType.Normal)
	setActive(arg0:findTF(TeamType.Submarine, arg0.attrFrame), var2 == FleetType.Submarine)
	setActive(arg0:findTF(TeamType.Vanguard .. "/vanguard", arg0.attrFrame), var2 ~= FleetType.Submarine)
	arg0:updateUltimateTitle()
end

function var0.updateUltimateTitle(arg0)
	local var0 = arg0.cards[TeamType.Main]

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
			"<color=#ffff00>" .. math.floor(var1) .. "</color>"
		}
	}
end

function var0.detachOnCardButton(arg0, arg1)
	local var0 = GetOrAddComponent(arg1.go, "EventTriggerListener")

	var0:RemovePointDownFunc()
	var0:RemovePointUpFunc()
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
				arg0:emit(WorldDetailMediator.OnShipInfo, arg1.shipVO.id, var0.TOGGLE_DETAIL)
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_PANEL)
		end
	end)

	if arg1.shipVO then
		local var1 = arg0.cards[arg2]
		local var2 = arg1.tr.parent:GetComponent("ContentSizeFitter")
		local var3 = arg1.tr.parent:GetComponent("HorizontalLayoutGroup")
		local var4 = arg1.tr.rect.width * 0.5
		local var5 = {}

		var0:AddBeginDragFunc(function()
			if arg0.carddrag then
				return
			end

			arg0.carddrag = arg1
			var2.enabled = false
			var3.enabled = false

			arg1.tr:SetSiblingIndex(#var1)

			for iter0 = 1, #var1 do
				if var1[iter0] == arg1 then
					arg0.shiftIndex = iter0
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
				if var1[iter0] ~= arg1 and var1[iter0].shipVO and arg1.tr.localPosition.x > var1[iter0].tr.localPosition.x + (var1 < arg0.shiftIndex and 1.1 or -1.1) * var4 then
					var1 = var1 + 1
				end
			end

			if arg0.shiftIndex ~= var1 then
				arg0.formationLogic:Shift(arg0.shiftIndex, var1, arg2)
				arg0:shiftCard(arg0.shiftIndex, var1, arg2)

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

			local var0 = math.min(math.abs(arg1.tr.anchoredPosition.x - var5[arg0.shiftIndex].x) / 200, 1) * 0.3

			LeanTween.value(arg1.go, arg1.tr.anchoredPosition.x, var5[arg0.shiftIndex].x, var0):setEase(LeanTweenType.easeOutCubic):setOnUpdate(System.Action_float(function(arg0)
				local var0 = arg1.tr.anchoredPosition

				var0.x = arg0
				arg1.tr.anchoredPosition = var0
			end)):setOnComplete(System.Action(function()
				var2.enabled = true
				var3.enabled = true
				arg0.shiftIndex = nil

				arg0:updateUltimateTitle()
				arg0.formationLogic:SwitchToDisplayMode()
				arg0.formationLogic:SortSiblingIndex()
				arg0:sortCardSiblingIndex()

				arg0.carddrag = nil

				LeanTween.scale(arg1.paintingTr, Vector3(1, 1, 0), 0.3)
			end))
		end)
	end
end

function var0.change2ScrPos(arg0, arg1, arg2)
	local var0 = GameObject.Find("OverlayCamera"):GetComponent("Camera")

	return (LuaHelper.ScreenToLocal(arg1, arg2, var0))
end

function var0.recyclePainting(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		for iter2, iter3 in ipairs(iter1) do
			iter3:clear()
		end
	end
end

function var0.willExit(arg0)
	arg0.commanderFormationPanel:Destroy()

	if isActive(arg0.attrFrame) then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.blurLayer, arg0._tf)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)

	if arg0.resPanel then
		arg0.resPanel:exit()

		arg0.resPanel = nil
	end

	if arg0.eventTriggers then
		for iter0, iter1 in pairs(arg0.eventTriggers) do
			ClearEventTrigger(iter0)
		end

		arg0.eventTriggers = nil
	end

	local var0 = arg0:getCurrentFleet()

	arg0.formationLogic:Destroy()
	arg0:recyclePainting()
end

return var0
