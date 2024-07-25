local var0_0 = class("ActivityBossBattleFleetSelectSubPanel", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossFleetSelectView"
end

function var0_0.InvokeParent(arg0_2, arg1_2, ...)
	if arg0_2.viewParent then
		arg0_2.viewParent[arg1_2](arg0_2.viewParent, ...)
	end
end

function var0_0.OnInit(arg0_3)
	arg0_3.tfShipTpl = arg0_3:findTF("panel/shiptpl")
	arg0_3.tfEmptyTpl = arg0_3:findTF("panel/emptytpl")
	arg0_3.tfFleets = {
		[FleetType.Normal] = {
			arg0_3:findTF("panel/fleet/1"),
			arg0_3:findTF("panel/fleet/2")
		},
		[FleetType.Submarine] = {
			arg0_3:findTF("panel/sub/1")
		}
	}
	arg0_3.tfLimit = arg0_3:findTF("panel/limit_list/limit")
	arg0_3.tfLimitTips = arg0_3:findTF("panel/limit_list/limit_tip")
	arg0_3.tfLimitElite = arg0_3:findTF("panel/limit_list/limit_elite")
	arg0_3.tfLimitContainer = arg0_3:findTF("panel/limit_list/limit_elite/limit_list")
	arg0_3.rtCostLimit = arg0_3._tf:Find("panel/limit_list/cost_limit")
	arg0_3.btnBack = arg0_3:findTF("panel/btnBack")
	arg0_3.btnGo = arg0_3:findTF("panel/start_button")
	arg0_3.btnTry = arg0_3:findTF("panel/try_button")
	arg0_3.btnASHelp = arg0_3:findTF("panel/title/ASvalue")
	arg0_3.commanderToggle = arg0_3:findTF("panel/commander_btn")
	arg0_3.formationToggle = arg0_3:findTF("panel/formation_btn")
	arg0_3.toggleMask = arg0_3:findTF("mask")
	arg0_3.toggleList = arg0_3:findTF("mask/list")
	arg0_3.toggles = {}

	for iter0_3 = 0, arg0_3.toggleList.childCount - 1 do
		table.insert(arg0_3.toggles, arg0_3.toggleList:Find("item" .. iter0_3 + 1))
	end

	arg0_3.btnSp = arg0_3:findTF("panel/sp")
	arg0_3.spMask = arg0_3:findTF("mask_sp")

	setActive(arg0_3.tfShipTpl, false)
	setActive(arg0_3.tfEmptyTpl, false)
	setActive(arg0_3.toggleMask, false)
	setActive(arg0_3.btnSp, false)
	setActive(arg0_3.spMask, false)
	setActive(arg0_3.tfLimitElite, false)
	setActive(arg0_3.tfLimitTips, false)
	setActive(arg0_3.tfLimit, false)
	setActive(arg0_3:findTF("panel/title/ASvalue"), false)
	setText(arg0_3:findTF("panel/formation_btn/text"), i18n("autofight_formation"))
	setText(arg0_3:findTF("panel/commander_btn/text"), i18n("autofight_cat"))
	setText(arg0_3._tf:Find("panel/title/Image/text"), i18n("fleet_select_title"))
	arg0_3:InitInteractable()
end

function var0_0.InitInteractable(arg0_4)
	onButton(arg0_4, arg0_4.btnGo, function()
		arg0_4:OnCombat()
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_4, arg0_4.btnTry, function()
		arg0_4:OnTrybat()
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_4, arg0_4.btnBack, function()
		arg0_4:OnCancel()
		arg0_4:OnCommit()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:OnCancel()
		arg0_4:OnCommit()
	end, SFX_CANCEL)
	onToggle(arg0_4, arg0_4.commanderToggle, function(arg0_9)
		if arg0_9 then
			arg0_4.viewParent.contextData.showCommander = arg0_9

			for iter0_9, iter1_9 in pairs(arg0_4.tfFleets) do
				for iter2_9 = 1, #iter1_9 do
					arg0_4:updateCommanderBtn(iter0_9, iter2_9)
				end
			end
		end
	end, SFX_PANEL)
	onToggle(arg0_4, arg0_4.formationToggle, function(arg0_10)
		if arg0_10 then
			arg0_4.viewParent.contextData.showCommander = not arg0_10

			for iter0_10, iter1_10 in pairs(arg0_4.tfFleets) do
				for iter2_10 = 1, #iter1_10 do
					arg0_4:updateCommanderBtn(iter0_10, iter2_10)
				end
			end
		end
	end, SFX_PANEL)
end

function var0_0.SetFleets(arg0_11, arg1_11)
	arg0_11.fleets = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0_11, iter1_11 in pairs(arg1_11) do
		iter1_11:RemoveUnusedItems()

		if iter1_11:isSubmarineFleet() then
			if #arg0_11.fleets[FleetType.Submarine] < arg0_11:getLimitNums(FleetType.Submarine) then
				table.insert(arg0_11.fleets[FleetType.Submarine], iter1_11)
			end
		elseif #arg0_11.fleets[FleetType.Normal] < arg0_11:getLimitNums(FleetType.Normal) then
			table.insert(arg0_11.fleets[FleetType.Normal], iter1_11)
		end
	end
end

function var0_0.SetOilLimit(arg0_12, arg1_12)
	local var0_12 = _.any(arg1_12, function(arg0_13)
		return arg0_13 > 0
	end)

	setActive(arg0_12.rtCostLimit, var0_12)
	setText(arg0_12.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip_worldboss"))

	if var0_12 then
		local var1_12 = 0
		local var2_12 = arg1_12[1]

		setActive(arg0_12.rtCostLimit:Find("cost_noraml/Text"), var2_12 > 0)

		if var2_12 > 0 then
			setText(arg0_12.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_surface"), var2_12))
		end

		local var3_12 = 0

		setActive(arg0_12.rtCostLimit:Find("cost_boss/Text"), var3_12 > 0)

		local var4_12 = arg1_12[2]

		setActive(arg0_12.rtCostLimit:Find("cost_sub/Text"), var4_12 > 0)

		if var4_12 > 0 then
			setText(arg0_12.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var4_12))
		end
	end
end

function var0_0.SetSettings(arg0_14, arg1_14, arg2_14, arg3_14)
	arg0_14.groupNum = arg1_14
	arg0_14.submarineNum = arg2_14
	arg0_14.showTryBtn = arg3_14
end

function var0_0.UpdateView(arg0_15)
	arg0_15:clearFleets()
	arg0_15:UpdateFleets()

	local var0_15 = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "CommanderCatMediator")

	triggerToggle(arg0_15.viewParent.contextData.showCommander and var0_15 and arg0_15.commanderToggle or arg0_15.formationToggle, true)
	setActive(arg0_15.commanderToggle, var0_15)
	setActive(arg0_15.btnTry, arg0_15.showTryBtn)
end

function var0_0.getLimitNums(arg0_16, arg1_16)
	local var0_16 = 0

	if arg1_16 == FleetType.Normal then
		var0_16 = arg0_16.groupNum
	elseif arg1_16 == FleetType.Submarine then
		var0_16 = arg0_16.submarineNum
	end

	return var0_16 or 0
end

function var0_0.UpdateFleets(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.tfFleets) do
		for iter2_17 = 1, #iter1_17 do
			arg0_17:updateFleet(iter0_17, iter2_17)
		end
	end
end

function var0_0.updateFleet(arg0_18, arg1_18, arg2_18)
	arg0_18:updateCommanderBtn(arg1_18, arg2_18)

	local var0_18 = arg2_18 <= arg0_18:getLimitNums(arg1_18)
	local var1_18 = var0_18 and arg0_18.fleets[arg1_18][arg2_18]
	local var2_18 = arg0_18.tfFleets[arg1_18][arg2_18]
	local var3_18 = findTF(var2_18, "bg/name")
	local var4_18 = arg0_18:findTF(TeamType.Main, var2_18)
	local var5_18 = arg0_18:findTF(TeamType.Vanguard, var2_18)
	local var6_18 = arg0_18:findTF(TeamType.Submarine, var2_18)
	local var7_18 = arg0_18:findTF("btn_recom", var2_18)
	local var8_18 = arg0_18:findTF("btn_clear", var2_18)
	local var9_18 = arg0_18:findTF("selected", var2_18)
	local var10_18 = arg0_18:findTF("commander", var2_18)

	setActive(var9_18, false)
	setText(var3_18, "")

	if var4_18 then
		setActive(var4_18, var0_18 and var1_18)
	end

	if var5_18 then
		setActive(var5_18, var0_18 and var1_18)
	end

	if var6_18 then
		setActive(var6_18, var0_18 and var1_18)
	end

	if var0_18 and var1_18 then
		setText(var3_18, Fleet.DEFAULT_NAME_BOSS_ACT[var1_18.id] or "")

		if arg1_18 == FleetType.Submarine then
			arg0_18:updateShips(var6_18, var1_18.subShips, var1_18.id, TeamType.Submarine)
		else
			arg0_18:updateShips(var4_18, var1_18.mainShips, var1_18.id, TeamType.Main)
			arg0_18:updateShips(var5_18, var1_18.vanguardShips, var1_18.id, TeamType.Vanguard)
		end

		arg0_18:updateCommanders(var10_18, var1_18)
		onButton(arg0_18, var7_18, function()
			arg0_18:emit(arg0_18.viewParent.contextData.mediatorClass.ON_FLEET_RECOMMEND, var1_18.id)
		end)
		onButton(arg0_18, var8_18, function()
			arg0_18:emit(arg0_18.viewParent.contextData.mediatorClass.ON_FLEET_CLEAR, var1_18.id)
		end, SFX_UI_CLICK)
	end
end

function var0_0.updateShips(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
	removeAllChildren(arg1_21)

	local var0_21 = getProxy(BayProxy)

	for iter0_21 = 1, 3 do
		local var1_21 = var0_21:getShipById(arg2_21[iter0_21])
		local var2_21 = var1_21 and arg0_21.tfShipTpl or arg0_21.tfEmptyTpl
		local var3_21 = cloneTplTo(var2_21, arg1_21)

		setActive(var3_21, true)

		if var1_21 then
			updateShip(var3_21, var1_21)
			setActive(var3_21:Find("event_block"), var1_21:getFlag("inEvent"))
		end

		setActive(arg0_21:findTF("ship_type", var3_21), false)

		local var4_21 = GetOrAddComponent(var3_21, typeof(UILongPressTrigger))

		var4_21.onLongPressed:RemoveAllListeners()

		local function var5_21()
			arg0_21:emit(arg0_21.viewParent.contextData.mediatorClass.ON_OPEN_DOCK, {
				fleet = arg2_21,
				shipVO = var1_21,
				fleetIndex = arg3_21,
				teamType = arg4_21
			})
		end

		onButton(arg0_21, var3_21, var5_21)
		var4_21.onLongPressed:AddListener(function()
			if var1_21 then
				arg0_21:OnLongPressShip(arg2_21[iter0_21], arg3_21)
			else
				var5_21()
			end
		end)
	end
end

function var0_0.updateCommanderBtn(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg2_24 <= arg0_24:getLimitNums(arg1_24)
	local var1_24 = var0_24 and arg0_24.fleets[arg1_24][arg2_24]
	local var2_24 = arg0_24.tfFleets[arg1_24][arg2_24]
	local var3_24 = arg0_24:findTF("btn_select", var2_24)
	local var4_24 = arg0_24:findTF("btn_clear", var2_24)
	local var5_24 = arg0_24:findTF("btn_recom", var2_24)
	local var6_24 = arg0_24:findTF("blank", var2_24)
	local var7_24 = arg0_24:findTF("commander", var2_24)

	setActive(var3_24, false)
	setActive(var4_24, var0_24 and not arg0_24.viewParent.contextData.showCommander)
	setActive(var5_24, var0_24 and not arg0_24.viewParent.contextData.showCommander)
	setActive(var7_24, var0_24 and var1_24 and arg0_24.viewParent.contextData.showCommander)
	setActive(var6_24, not var0_24 or var0_24 and not var1_24 and arg0_24.viewParent.contextData.showCommander)
end

function var0_0.updateCommanders(arg0_25, arg1_25, arg2_25)
	for iter0_25 = 1, 2 do
		local var0_25 = arg2_25:getCommanderByPos(iter0_25)
		local var1_25 = arg1_25:Find("pos" .. iter0_25)
		local var2_25 = var1_25:Find("add")
		local var3_25 = var1_25:Find("info")

		setActive(var2_25, not var0_25)
		setActive(var3_25, var0_25)

		if var0_25 then
			local var4_25 = Commander.rarity2Frame(var0_25:getRarity())

			setImageSprite(var3_25:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var4_25))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var0_25:getPainting(), "", var3_25:Find("mask/icon"))
		end

		onButton(arg0_25, var2_25, function()
			arg0_25:InvokeParent("openCommanderPanel", arg2_25, arg2_25.id)
		end, SFX_PANEL)
		onButton(arg0_25, var3_25, function()
			arg0_25:InvokeParent("openCommanderPanel", arg2_25, arg2_25.id)
		end, SFX_PANEL)
	end
end

function var0_0.clearFleets(arg0_28)
	for iter0_28, iter1_28 in pairs(arg0_28.tfFleets) do
		_.each(iter1_28, function(arg0_29)
			arg0_28:clearFleet(arg0_29)
		end)
	end
end

function var0_0.clearFleet(arg0_30, arg1_30)
	local var0_30 = arg0_30:findTF(TeamType.Main, arg1_30)
	local var1_30 = arg0_30:findTF(TeamType.Vanguard, arg1_30)
	local var2_30 = arg0_30:findTF(TeamType.Submarine, arg1_30)

	if var0_30 then
		removeAllChildren(var0_30)
	end

	if var1_30 then
		removeAllChildren(var1_30)
	end

	if var2_30 then
		removeAllChildren(var2_30)
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

function var0_0.OnTrybat(arg0_36)
	arg0_36:InvokeParent("commitEdit")
	arg0_36:InvokeParent("commitTrybat")
end

function var0_0.OnLongPressShip(arg0_37, arg1_37, arg2_37)
	arg0_37:InvokeParent("openShipInfo", arg1_37, arg2_37)
end

return var0_0
