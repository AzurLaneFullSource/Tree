local var0_0 = class("ActivityBossBattleFleetSelectSubPanel", import("view.base.BaseSubPanel"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossFleetSelectView"
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
		arg0_3:OnCombat()
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_3, arg0_3.btnTry, function()
		arg0_3:OnTrybat()
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_3, arg0_3.btnBack, function()
		arg0_3:OnCancel()
		arg0_3:OnCommit()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:OnCancel()
		arg0_3:OnCommit()
	end, SFX_CANCEL)
	onToggle(arg0_3, arg0_3.commanderToggle, function(arg0_8)
		if arg0_8 then
			arg0_3.viewParent.contextData.showCommander = arg0_8

			for iter0_8, iter1_8 in pairs(arg0_3.tfFleets) do
				for iter2_8 = 1, #iter1_8 do
					arg0_3:updateCommanderBtn(iter0_8, iter2_8)
				end
			end
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.formationToggle, function(arg0_9)
		if arg0_9 then
			arg0_3.viewParent.contextData.showCommander = not arg0_9

			for iter0_9, iter1_9 in pairs(arg0_3.tfFleets) do
				for iter2_9 = 1, #iter1_9 do
					arg0_3:updateCommanderBtn(iter0_9, iter2_9)
				end
			end
		end
	end, SFX_PANEL)
end

function var0_0.SetFleets(arg0_10, arg1_10)
	arg0_10.fleets = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0_10, iter1_10 in pairs(arg1_10) do
		iter1_10:RemoveUnusedItems()

		if iter1_10:isSubmarineFleet() then
			if #arg0_10.fleets[FleetType.Submarine] < arg0_10:getLimitNums(FleetType.Submarine) then
				table.insert(arg0_10.fleets[FleetType.Submarine], iter1_10)
			end
		elseif #arg0_10.fleets[FleetType.Normal] < arg0_10:getLimitNums(FleetType.Normal) then
			table.insert(arg0_10.fleets[FleetType.Normal], iter1_10)
		end
	end
end

function var0_0.SetOilLimit(arg0_11, arg1_11)
	local var0_11 = _.any(arg1_11, function(arg0_12)
		return arg0_12 > 0
	end)

	setActive(arg0_11.rtCostLimit, var0_11)
	setText(arg0_11.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip_worldboss"))

	if var0_11 then
		local var1_11 = 0
		local var2_11 = arg1_11[1]

		setActive(arg0_11.rtCostLimit:Find("cost_noraml/Text"), var2_11 > 0)

		if var2_11 > 0 then
			setText(arg0_11.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_surface"), var2_11))
		end

		local var3_11 = 0

		setActive(arg0_11.rtCostLimit:Find("cost_boss/Text"), var3_11 > 0)

		local var4_11 = arg1_11[2]

		setActive(arg0_11.rtCostLimit:Find("cost_sub/Text"), var4_11 > 0)

		if var4_11 > 0 then
			setText(arg0_11.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var4_11))
		end
	end
end

function var0_0.SetSettings(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13.groupNum = arg1_13
	arg0_13.submarineNum = arg2_13
	arg0_13.showTryBtn = arg3_13
end

function var0_0.UpdateView(arg0_14)
	arg0_14:clearFleets()
	arg0_14:UpdateFleets()

	local var0_14 = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "CommanderCatMediator")

	triggerToggle(arg0_14.viewParent.contextData.showCommander and var0_14 and arg0_14.commanderToggle or arg0_14.formationToggle, true)
	setActive(arg0_14.commanderToggle, var0_14)
	setActive(arg0_14.btnTry, arg0_14.showTryBtn)
end

function var0_0.getLimitNums(arg0_15, arg1_15)
	local var0_15 = 0

	if arg1_15 == FleetType.Normal then
		var0_15 = arg0_15.groupNum
	elseif arg1_15 == FleetType.Submarine then
		var0_15 = arg0_15.submarineNum
	end

	return var0_15 or 0
end

function var0_0.UpdateFleets(arg0_16)
	for iter0_16, iter1_16 in pairs(arg0_16.tfFleets) do
		for iter2_16 = 1, #iter1_16 do
			arg0_16:updateFleet(iter0_16, iter2_16)
		end
	end
end

function var0_0.updateFleet(arg0_17, arg1_17, arg2_17)
	arg0_17:updateCommanderBtn(arg1_17, arg2_17)

	local var0_17 = arg2_17 <= arg0_17:getLimitNums(arg1_17)
	local var1_17 = var0_17 and arg0_17.fleets[arg1_17][arg2_17]
	local var2_17 = arg0_17.tfFleets[arg1_17][arg2_17]
	local var3_17 = findTF(var2_17, "bg/name")
	local var4_17 = arg0_17:findTF(TeamType.Main, var2_17)
	local var5_17 = arg0_17:findTF(TeamType.Vanguard, var2_17)
	local var6_17 = arg0_17:findTF(TeamType.Submarine, var2_17)
	local var7_17 = arg0_17:findTF("btn_recom", var2_17)
	local var8_17 = arg0_17:findTF("btn_clear", var2_17)
	local var9_17 = arg0_17:findTF("selected", var2_17)
	local var10_17 = arg0_17:findTF("commander", var2_17)

	setActive(var9_17, false)
	setText(var3_17, "")

	if var4_17 then
		setActive(var4_17, var0_17 and var1_17)
	end

	if var5_17 then
		setActive(var5_17, var0_17 and var1_17)
	end

	if var6_17 then
		setActive(var6_17, var0_17 and var1_17)
	end

	if var0_17 and var1_17 then
		setText(var3_17, Fleet.DEFAULT_NAME_BOSS_ACT[var1_17.id] or "")

		if arg1_17 == FleetType.Submarine then
			arg0_17:updateShips(var6_17, var1_17.subShips, var1_17.id, TeamType.Submarine)
		else
			arg0_17:updateShips(var4_17, var1_17.mainShips, var1_17.id, TeamType.Main)
			arg0_17:updateShips(var5_17, var1_17.vanguardShips, var1_17.id, TeamType.Vanguard)
		end

		arg0_17:updateCommanders(var10_17, var1_17)
		onButton(arg0_17, var7_17, function()
			arg0_17:emit(arg0_17.viewParent.contextData.mediatorClass.ON_FLEET_RECOMMEND, var1_17.id)
		end)
		onButton(arg0_17, var8_17, function()
			arg0_17:emit(arg0_17.viewParent.contextData.mediatorClass.ON_FLEET_CLEAR, var1_17.id)
		end, SFX_UI_CLICK)
	end
end

function var0_0.updateShips(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	removeAllChildren(arg1_20)

	local var0_20 = getProxy(BayProxy)

	for iter0_20 = 1, 3 do
		local var1_20 = var0_20:getShipById(arg2_20[iter0_20])
		local var2_20 = var1_20 and arg0_20.tfShipTpl or arg0_20.tfEmptyTpl
		local var3_20 = cloneTplTo(var2_20, arg1_20)

		setActive(var3_20, true)

		if var1_20 then
			updateShip(var3_20, var1_20)
			setActive(var3_20:Find("event_block"), var1_20:getFlag("inEvent"))
		end

		setActive(arg0_20:findTF("ship_type", var3_20), false)

		local var4_20 = GetOrAddComponent(var3_20, typeof(UILongPressTrigger))

		var4_20.onLongPressed:RemoveAllListeners()

		local function var5_20()
			arg0_20:emit(arg0_20.viewParent.contextData.mediatorClass.ON_OPEN_DOCK, {
				fleet = arg2_20,
				shipVO = var1_20,
				fleetIndex = arg3_20,
				teamType = arg4_20
			})
		end

		onButton(arg0_20, var3_20, var5_20)
		var4_20.onLongPressed:AddListener(function()
			if var1_20 then
				arg0_20:OnLongPressShip(arg2_20[iter0_20], arg3_20)
			else
				var5_20()
			end
		end)
	end
end

function var0_0.updateCommanderBtn(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg2_23 <= arg0_23:getLimitNums(arg1_23)
	local var1_23 = var0_23 and arg0_23.fleets[arg1_23][arg2_23]
	local var2_23 = arg0_23.tfFleets[arg1_23][arg2_23]
	local var3_23 = arg0_23:findTF("btn_select", var2_23)
	local var4_23 = arg0_23:findTF("btn_clear", var2_23)
	local var5_23 = arg0_23:findTF("btn_recom", var2_23)
	local var6_23 = arg0_23:findTF("blank", var2_23)
	local var7_23 = arg0_23:findTF("commander", var2_23)

	setActive(var3_23, false)
	setActive(var4_23, var0_23 and not arg0_23.viewParent.contextData.showCommander)
	setActive(var5_23, var0_23 and not arg0_23.viewParent.contextData.showCommander)
	setActive(var7_23, var0_23 and var1_23 and arg0_23.viewParent.contextData.showCommander)
	setActive(var6_23, not var0_23 or var0_23 and not var1_23 and arg0_23.viewParent.contextData.showCommander)
end

function var0_0.updateCommanders(arg0_24, arg1_24, arg2_24)
	for iter0_24 = 1, 2 do
		local var0_24 = arg2_24:getCommanderByPos(iter0_24)
		local var1_24 = arg1_24:Find("pos" .. iter0_24)
		local var2_24 = var1_24:Find("add")
		local var3_24 = var1_24:Find("info")

		setActive(var2_24, not var0_24)
		setActive(var3_24, var0_24)

		if var0_24 then
			local var4_24 = Commander.rarity2Frame(var0_24:getRarity())

			setImageSprite(var3_24:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var4_24))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var0_24:getPainting(), "", var3_24:Find("mask/icon"))
		end

		onButton(arg0_24, var2_24, function()
			arg0_24:InvokeParent("openCommanderPanel", arg2_24, arg2_24.id)
		end, SFX_PANEL)
		onButton(arg0_24, var3_24, function()
			arg0_24:InvokeParent("openCommanderPanel", arg2_24, arg2_24.id)
		end, SFX_PANEL)
	end
end

function var0_0.clearFleets(arg0_27)
	for iter0_27, iter1_27 in pairs(arg0_27.tfFleets) do
		_.each(iter1_27, function(arg0_28)
			arg0_27:clearFleet(arg0_28)
		end)
	end
end

function var0_0.clearFleet(arg0_29, arg1_29)
	local var0_29 = arg0_29:findTF(TeamType.Main, arg1_29)
	local var1_29 = arg0_29:findTF(TeamType.Vanguard, arg1_29)
	local var2_29 = arg0_29:findTF(TeamType.Submarine, arg1_29)

	if var0_29 then
		removeAllChildren(var0_29)
	end

	if var1_29 then
		removeAllChildren(var1_29)
	end

	if var2_29 then
		removeAllChildren(var2_29)
	end
end

function var0_0.OnShow(arg0_30)
	local var0_30 = #getProxy(ContextProxy):getCurrentContext().children > 0 and LayerWeightConst.LOWER_LAYER or nil

	pg.UIMgr.GetInstance():BlurPanel(arg0_30._tf, nil, {
		groupName = LayerWeightConst.GROUP_FORMATION_PAGE,
		weight = var0_30
	})
end

function var0_0.OnHide(arg0_31)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_31._tf, arg0_31.viewParent._tf)
	triggerToggle(arg0_31.commanderToggle, false)
end

function var0_0.OnCancel(arg0_32)
	arg0_32:InvokeParent("hideFleetEdit")
end

function var0_0.OnCommit(arg0_33)
	arg0_33:InvokeParent("commitEdit")
end

function var0_0.OnCombat(arg0_34)
	arg0_34:InvokeParent("commitEdit")
	arg0_34:InvokeParent("commitCombat")
end

function var0_0.OnTrybat(arg0_35)
	arg0_35:InvokeParent("commitEdit")
	arg0_35:InvokeParent("commitTrybat")
end

function var0_0.OnLongPressShip(arg0_36, arg1_36, arg2_36)
	arg0_36:InvokeParent("openShipInfo", arg1_36, arg2_36)
end

return var0_0
