local var0_0 = class("BossSingleBattleFleetSelectSubPanel", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "BossSingleFleetSelectView"
end

function var0_0.OnInit(arg0_2)
	arg0_2.tfShipTpl = arg0_2:findTF("panel/shiptpl")
	arg0_2.tfEmptyTpl = arg0_2:findTF("panel/emptytpl")
	arg0_2.tfFleets = {
		[FleetType.Normal] = {
			arg0_2:findTF("panel/fleet/1"),
			arg0_2:findTF("panel/fleet/2")
		},
		[FleetType.Submarine] = {
			arg0_2:findTF("panel/sub/1")
		}
	}
	arg0_2.tfLimit = arg0_2:findTF("panel/limit_list/limit")
	arg0_2.tfLimitTips = arg0_2:findTF("panel/limit_list/limit_tip")
	arg0_2.tfLimitElite = arg0_2:findTF("panel/limit_list/limit_elite")

	setText(arg0_2:findTF("sub/Text", arg0_2.tfLimitElite), i18n("ship_limit_notice"))

	arg0_2.tfLimitContainer = arg0_2:findTF("panel/limit_list/limit_elite/limit_list")
	arg0_2.rtCostLimit = arg0_2._tf:Find("panel/limit_list/cost_limit")
	arg0_2.btnBack = arg0_2:findTF("panel/btnBack")
	arg0_2.btnGo = arg0_2:findTF("panel/start_button")
	arg0_2.btnTry = arg0_2:findTF("panel/try_button")
	arg0_2.btnASHelp = arg0_2:findTF("panel/title/ASvalue")
	arg0_2.commanderToggle = arg0_2:findTF("panel/commander_btn")
	arg0_2.formationToggle = arg0_2:findTF("panel/formation_btn")
	arg0_2.toggleMask = arg0_2:findTF("mask")
	arg0_2.toggleList = arg0_2:findTF("mask/list")
	arg0_2.toggles = {}

	for iter0_2 = 0, arg0_2.toggleList.childCount - 1 do
		table.insert(arg0_2.toggles, arg0_2.toggleList:Find("item" .. iter0_2 + 1))
	end

	arg0_2.btnSp = arg0_2:findTF("panel/sp")
	arg0_2.spMask = arg0_2:findTF("mask_sp")

	setActive(arg0_2.tfShipTpl, false)
	setActive(arg0_2.tfEmptyTpl, false)
	setActive(arg0_2.toggleMask, false)
	setActive(arg0_2.btnSp, false)
	setActive(arg0_2.spMask, false)
	setActive(arg0_2.tfLimitElite, false)
	setActive(arg0_2.tfLimitTips, false)
	setActive(arg0_2.tfLimit, false)
	setActive(arg0_2:findTF("panel/title/ASvalue"), false)
	setText(arg0_2:findTF("panel/formation_btn/text"), i18n("autofight_formation"))
	setText(arg0_2:findTF("panel/commander_btn/text"), i18n("autofight_cat"))
	setText(arg0_2._tf:Find("panel/title/Image/text"), i18n("fleet_select_title"))
	arg0_2:InitInteractable()
end

function var0_0.InitInteractable(arg0_3)
	onButton(arg0_3, arg0_3.btnGo, function()
		local var0_4, var1_4 = arg0_3:CheckValid()

		if var0_4 then
			arg0_3:OnCombat()
		else
			pg.TipsMgr.GetInstance():ShowTips(var1_4)
		end
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_3, arg0_3.btnBack, function()
		arg0_3:OnCancel()
		arg0_3:OnCommit()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:OnCancel()
		arg0_3:OnCommit()
	end, SFX_CANCEL)
	onToggle(arg0_3, arg0_3.commanderToggle, function(arg0_7)
		if arg0_7 then
			arg0_3.viewParent.contextData.showCommander = arg0_7

			for iter0_7, iter1_7 in pairs(arg0_3.tfFleets) do
				for iter2_7 = 1, #iter1_7 do
					arg0_3:updateCommanderBtn(iter0_7, iter2_7)
				end
			end
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.formationToggle, function(arg0_8)
		if arg0_8 then
			arg0_3.viewParent.contextData.showCommander = not arg0_8

			for iter0_8, iter1_8 in pairs(arg0_3.tfFleets) do
				for iter2_8 = 1, #iter1_8 do
					arg0_3:updateCommanderBtn(iter0_8, iter2_8)
				end
			end
		end
	end, SFX_PANEL)
end

function var0_0.SetFleets(arg0_9, arg1_9)
	arg0_9.fleets = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0_9, iter1_9 in pairs(arg1_9) do
		iter1_9:RemoveUnusedItems()

		if iter1_9:isSubmarineFleet() then
			if #arg0_9.fleets[FleetType.Submarine] < arg0_9:getLimitNums(FleetType.Submarine) then
				table.insert(arg0_9.fleets[FleetType.Submarine], iter1_9)
			end
		elseif #arg0_9.fleets[FleetType.Normal] < arg0_9:getLimitNums(FleetType.Normal) then
			table.insert(arg0_9.fleets[FleetType.Normal], iter1_9)
		end
	end
end

function var0_0.SetOilLimit(arg0_10, arg1_10)
	local var0_10 = _.any(arg1_10, function(arg0_11)
		return arg0_11 > 0
	end)

	setActive(arg0_10.rtCostLimit, var0_10)
	setText(arg0_10.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip_worldboss"))

	if var0_10 then
		local var1_10 = 0
		local var2_10 = arg1_10[1]

		setActive(arg0_10.rtCostLimit:Find("cost_noraml/Text"), var2_10 > 0)

		if var2_10 > 0 then
			setText(arg0_10.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_surface"), var2_10))
		end

		local var3_10 = 0

		setActive(arg0_10.rtCostLimit:Find("cost_boss/Text"), var3_10 > 0)

		local var4_10 = arg1_10[2]

		setActive(arg0_10.rtCostLimit:Find("cost_sub/Text"), var4_10 > 0)

		if var4_10 > 0 then
			setText(arg0_10.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var4_10))
		end
	end
end

function var0_0.SetSettings(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12, arg5_12)
	arg0_12.groupNum = arg1_12
	arg0_12.submarineNum = arg2_12
	arg0_12.showTryBtn = arg3_12
	arg0_12.propetyLimitation = arg4_12
	arg0_12.index = arg5_12
end

function var0_0.UpdateView(arg0_13)
	arg0_13:clearFleets()
	arg0_13:UpdateFleets()
	arg0_13:updatePropetyLimit()

	local var0_13 = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "CommanderCatMediator")

	triggerToggle(arg0_13.viewParent.contextData.showCommander and var0_13 and arg0_13.commanderToggle or arg0_13.formationToggle, true)
	setActive(arg0_13.commanderToggle, var0_13)
	setActive(arg0_13.btnTry, arg0_13.showTryBtn)
end

function var0_0.getLimitNums(arg0_14, arg1_14)
	local var0_14 = 0

	if arg1_14 == FleetType.Normal then
		var0_14 = arg0_14.groupNum
	elseif arg1_14 == FleetType.Submarine then
		var0_14 = arg0_14.submarineNum
	end

	return var0_14 or 0
end

function var0_0.UpdateFleets(arg0_15)
	for iter0_15, iter1_15 in pairs(arg0_15.tfFleets) do
		for iter2_15 = 1, #iter1_15 do
			arg0_15:updateFleet(iter0_15, iter2_15)
		end
	end
end

function var0_0.updateFleet(arg0_16, arg1_16, arg2_16)
	arg0_16:updateCommanderBtn(arg1_16, arg2_16)

	local var0_16 = arg2_16 <= arg0_16:getLimitNums(arg1_16)
	local var1_16 = var0_16 and arg0_16.fleets[arg1_16][arg2_16]
	local var2_16 = arg0_16.tfFleets[arg1_16][arg2_16]
	local var3_16 = findTF(var2_16, "bg/name")
	local var4_16 = arg0_16:findTF(TeamType.Main, var2_16)
	local var5_16 = arg0_16:findTF(TeamType.Vanguard, var2_16)
	local var6_16 = arg0_16:findTF(TeamType.Submarine, var2_16)
	local var7_16 = arg0_16:findTF("btn_recom", var2_16)
	local var8_16 = arg0_16:findTF("btn_clear", var2_16)
	local var9_16 = arg0_16:findTF("selected", var2_16)
	local var10_16 = arg0_16:findTF("commander", var2_16)

	setActive(var9_16, false)
	setText(var3_16, "")

	if var4_16 then
		setActive(var4_16, var0_16 and var1_16)
	end

	if var5_16 then
		setActive(var5_16, var0_16 and var1_16)
	end

	if var6_16 then
		setActive(var6_16, var0_16 and var1_16)
	end

	if var0_16 and var1_16 then
		setText(var3_16, Fleet.DEFAULT_NAME_BOSS_SINGLE_ACT[var1_16.id] or "")

		if arg1_16 == FleetType.Submarine then
			arg0_16:updateShips(var6_16, var1_16.subShips, var1_16.id, TeamType.Submarine)
		else
			arg0_16:updateShips(var4_16, var1_16.mainShips, var1_16.id, TeamType.Main)
			arg0_16:updateShips(var5_16, var1_16.vanguardShips, var1_16.id, TeamType.Vanguard)
		end

		arg0_16:updateCommanders(var10_16, var1_16)
		onButton(arg0_16, var7_16, function()
			arg0_16:emit(arg0_16.viewParent.contextData.mediatorClass.ON_FLEET_RECOMMEND, var1_16.id)
		end)
		onButton(arg0_16, var8_16, function()
			arg0_16:emit(arg0_16.viewParent.contextData.mediatorClass.ON_FLEET_CLEAR, var1_16.id)
		end, SFX_UI_CLICK)
	end
end

function var0_0.updateShips(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	removeAllChildren(arg1_19)

	local var0_19 = getProxy(BayProxy)

	for iter0_19 = 1, 3 do
		local var1_19 = var0_19:getShipById(arg2_19[iter0_19])
		local var2_19 = var1_19 and arg0_19.tfShipTpl or arg0_19.tfEmptyTpl
		local var3_19 = cloneTplTo(var2_19, arg1_19)

		setActive(var3_19, true)

		if var1_19 then
			updateShip(var3_19, var1_19)
			setActive(var3_19:Find("event_block"), var1_19:getFlag("inEvent"))
		end

		setActive(arg0_19:findTF("ship_type", var3_19), false)

		local var4_19 = GetOrAddComponent(var3_19, typeof(UILongPressTrigger))

		var4_19.onLongPressed:RemoveAllListeners()

		local function var5_19()
			arg0_19:emit(arg0_19.viewParent.contextData.mediatorClass.ON_OPEN_DOCK, {
				fleet = arg2_19,
				shipVO = var1_19,
				fleetIndex = arg3_19,
				teamType = arg4_19
			})
		end

		onButton(arg0_19, var3_19, var5_19)
		var4_19.onLongPressed:AddListener(function()
			if var1_19 then
				arg0_19:OnLongPressShip(arg2_19[iter0_19], arg3_19)
			else
				var5_19()
			end
		end)
	end
end

function var0_0.updateCommanderBtn(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg2_22 <= arg0_22:getLimitNums(arg1_22)
	local var1_22 = var0_22 and arg0_22.fleets[arg1_22][arg2_22]
	local var2_22 = arg0_22.tfFleets[arg1_22][arg2_22]
	local var3_22 = arg0_22:findTF("btn_select", var2_22)
	local var4_22 = arg0_22:findTF("btn_clear", var2_22)
	local var5_22 = arg0_22:findTF("btn_recom", var2_22)
	local var6_22 = arg0_22:findTF("blank", var2_22)
	local var7_22 = arg0_22:findTF("commander", var2_22)

	setActive(var3_22, false)
	setActive(var4_22, var0_22 and not arg0_22.viewParent.contextData.showCommander)
	setActive(var5_22, var0_22 and not arg0_22.viewParent.contextData.showCommander)
	setActive(var7_22, var0_22 and var1_22 and arg0_22.viewParent.contextData.showCommander)
	setActive(var6_22, not var0_22 or var0_22 and not var1_22 and arg0_22.viewParent.contextData.showCommander)
end

function var0_0.updateCommanders(arg0_23, arg1_23, arg2_23)
	for iter0_23 = 1, 2 do
		local var0_23 = arg2_23:getCommanderByPos(iter0_23)
		local var1_23 = arg1_23:Find("pos" .. iter0_23)
		local var2_23 = var1_23:Find("add")
		local var3_23 = var1_23:Find("info")

		setActive(var2_23, not var0_23)
		setActive(var3_23, var0_23)

		if var0_23 then
			local var4_23 = Commander.rarity2Frame(var0_23:getRarity())

			setImageSprite(var3_23:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var4_23))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var0_23:getPainting(), "", var3_23:Find("mask/icon"))
		end

		onButton(arg0_23, var2_23, function()
			arg0_23:InvokeParent("openCommanderPanel", arg2_23, arg2_23.id)
		end, SFX_PANEL)
		onButton(arg0_23, var3_23, function()
			arg0_23:InvokeParent("openCommanderPanel", arg2_23, arg2_23.id)
		end, SFX_PANEL)
	end
end

function var0_0.clearFleets(arg0_26)
	for iter0_26, iter1_26 in pairs(arg0_26.tfFleets) do
		_.each(iter1_26, function(arg0_27)
			arg0_26:clearFleet(arg0_27)
		end)
	end
end

function var0_0.clearFleet(arg0_28, arg1_28)
	local var0_28 = arg0_28:findTF(TeamType.Main, arg1_28)
	local var1_28 = arg0_28:findTF(TeamType.Vanguard, arg1_28)
	local var2_28 = arg0_28:findTF(TeamType.Submarine, arg1_28)

	if var0_28 then
		removeAllChildren(var0_28)
	end

	if var1_28 then
		removeAllChildren(var1_28)
	end

	if var2_28 then
		removeAllChildren(var2_28)
	end
end

function var0_0.updatePropetyLimit(arg0_29)
	setActive(arg0_29.toggleMask, false)
	setActive(arg0_29.tfLimit, false)
	setActive(arg0_29.tfLimitTips, false)
	setActive(arg0_29.tfLimitElite, #arg0_29.propetyLimitation > 0)

	if #arg0_29.propetyLimitation > 0 then
		local var0_29 = UIItemList.New(arg0_29.tfLimitContainer, arg0_29.tfLimitContainer:GetChild(0))
		local var1_29, var2_29 = arg0_29:IsPropertyLimitationSatisfy()

		var0_29:make(function(arg0_30, arg1_30, arg2_30)
			arg1_30 = arg1_30 + 1

			if arg0_30 == UIItemList.EventUpdate then
				local var0_30 = arg0_29.propetyLimitation[arg1_30]
				local var1_30, var2_30, var3_30, var4_30 = unpack(var0_30)

				if var1_29[arg1_30] == 1 then
					arg0_29:findTF("Text", arg2_30):GetComponent(typeof(Text)).color = Color.New(1, 0.96078431372549, 0.501960784313725)
				else
					arg0_29:findTF("Text", arg2_30):GetComponent(typeof(Text)).color = Color.New(0.956862745098039, 0.301960784313725, 0.301960784313725)
				end

				setActive(arg2_30, true)

				local var5_30 = AttributeType.EliteCondition2Name(var1_30, var4_30) .. AttributeType.eliteConditionCompareTip(var2_30) .. var3_30

				setText(arg0_29:findTF("Text", arg2_30), var5_30)
			end
		end)
		var0_29:align(#arg0_29.propetyLimitation)
	end
end

function var0_0.OnShow(arg0_31)
	local var0_31 = #getProxy(ContextProxy):getCurrentContext().children > 0 and LayerWeightConst.LOWER_LAYER or nil

	pg.UIMgr.GetInstance():BlurPanel(arg0_31._tf, nil, {
		groupName = LayerWeightConst.GROUP_FORMATION_PAGE,
		weight = var0_31
	})
end

function var0_0.OnHide(arg0_32)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_32._tf, arg0_32.viewParent._tf)
	triggerToggle(arg0_32.commanderToggle, false)
end

function var0_0.OnCancel(arg0_33)
	arg0_33:InvokeParent("hideFleetEdit")
end

function var0_0.OnCommit(arg0_34)
	arg0_34:InvokeParent("commitEdit")
end

function var0_0.OnCombat(arg0_35)
	arg0_35:InvokeParent("commitEdit")
	arg0_35:InvokeParent("commitCombat")
end

function var0_0.OnLongPressShip(arg0_36, arg1_36, arg2_36)
	arg0_36:InvokeParent("openShipInfo", arg1_36, arg2_36)
end

function var0_0.IsPropertyLimitationSatisfy(arg0_37)
	local var0_37 = getProxy(BayProxy):getRawData()
	local var1_37 = arg0_37.propetyLimitation
	local var2_37 = {}

	for iter0_37, iter1_37 in ipairs(var1_37) do
		var2_37[iter1_37[1]] = 0
	end

	local var3_37 = 0
	local var4_37 = {}

	for iter2_37 = 1, 2 do
		local var5_37 = arg0_37.fleets[FleetType.Normal][iter2_37]

		if var5_37 then
			for iter3_37, iter4_37 in pairs(var5_37.mainShips) do
				table.insert(var4_37, iter4_37)
			end

			for iter5_37, iter6_37 in pairs(var5_37.vanguardShips) do
				table.insert(var4_37, iter6_37)
			end
		end
	end

	local var6_37 = {}
	local var7_37 = {}

	for iter7_37, iter8_37 in ipairs(var1_37) do
		local var8_37, var9_37, var10_37, var11_37 = unpack(iter8_37)

		if string.sub(var8_37, 1, 5) == "fleet" then
			var6_37[var8_37] = 0
			var7_37[var8_37] = var11_37
		end
	end

	for iter9_37, iter10_37 in ipairs(var4_37) do
		local var12_37 = var0_37[iter10_37]

		var3_37 = var3_37 + 1

		local var13_37 = intProperties(var12_37:getProperties())

		for iter11_37, iter12_37 in pairs(var2_37) do
			if string.sub(iter11_37, 1, 5) == "fleet" then
				if iter11_37 == "fleet_totle_level" then
					var6_37[iter11_37] = var6_37[iter11_37] + var12_37.level
				end
			elseif iter11_37 == "level" then
				var2_37[iter11_37] = iter12_37 + var12_37.level
			else
				var2_37[iter11_37] = iter12_37 + var13_37[iter11_37]
			end
		end
	end

	for iter13_37, iter14_37 in pairs(var6_37) do
		if iter13_37 == "fleet_totle_level" and iter14_37 > var7_37[iter13_37] then
			var2_37[iter13_37] = var2_37[iter13_37] + 1
		end
	end

	local var14_37 = {}

	for iter15_37, iter16_37 in ipairs(var1_37) do
		local var15_37, var16_37, var17_37 = unpack(iter16_37)

		if var15_37 == "level" and var3_37 > 0 then
			var2_37[var15_37] = math.ceil(var2_37[var15_37] / var3_37)
		end

		var14_37[iter15_37] = AttributeType.EliteConditionCompare(var16_37, var2_37[var15_37], var17_37) and 1 or 0
	end

	return var14_37, var2_37
end

function var0_0.CheckValid(arg0_38)
	local var0_38, var1_38 = arg0_38.viewParent.contextData.bossActivity:CheckCntByIdx(arg0_38.index)

	if not var0_38 then
		return var0_38, var1_38
	end

	local var2_38, var3_38 = arg0_38:IsPropertyLimitationSatisfy()
	local var4_38 = 1

	for iter0_38, iter1_38 in ipairs(var2_38) do
		var4_38 = var4_38 * iter1_38
	end

	if var4_38 ~= 1 then
		return false, i18n("elite_disable_property_unsatisfied")
	end

	return true
end

return var0_0
