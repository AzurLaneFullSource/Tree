local var0 = class("ActivityBossBattleFleetSelectSubPanel", import("view.base.BaseSubPanel"))

function var0.getUIName(arg0)
	return "ActivityBossFleetSelectView"
end

function var0.OnInit(arg0)
	arg0.tfShipTpl = arg0:findTF("panel/shiptpl")
	arg0.tfEmptyTpl = arg0:findTF("panel/emptytpl")
	arg0.tfFleets = {
		[FleetType.Normal] = {
			arg0:findTF("panel/fleet/1"),
			arg0:findTF("panel/fleet/2")
		},
		[FleetType.Submarine] = {
			arg0:findTF("panel/sub/1")
		}
	}
	arg0.tfLimit = arg0:findTF("panel/limit_list/limit")
	arg0.tfLimitTips = arg0:findTF("panel/limit_list/limit_tip")
	arg0.tfLimitElite = arg0:findTF("panel/limit_list/limit_elite")
	arg0.tfLimitContainer = arg0:findTF("panel/limit_list/limit_elite/limit_list")
	arg0.rtCostLimit = arg0._tf:Find("panel/limit_list/cost_limit")
	arg0.btnBack = arg0:findTF("panel/btnBack")
	arg0.btnGo = arg0:findTF("panel/start_button")
	arg0.btnTry = arg0:findTF("panel/try_button")
	arg0.btnASHelp = arg0:findTF("panel/title/ASvalue")
	arg0.commanderToggle = arg0:findTF("panel/commander_btn")
	arg0.formationToggle = arg0:findTF("panel/formation_btn")
	arg0.toggleMask = arg0:findTF("mask")
	arg0.toggleList = arg0:findTF("mask/list")
	arg0.toggles = {}

	for iter0 = 0, arg0.toggleList.childCount - 1 do
		table.insert(arg0.toggles, arg0.toggleList:Find("item" .. iter0 + 1))
	end

	arg0.btnSp = arg0:findTF("panel/sp")
	arg0.spMask = arg0:findTF("mask_sp")

	setActive(arg0.tfShipTpl, false)
	setActive(arg0.tfEmptyTpl, false)
	setActive(arg0.toggleMask, false)
	setActive(arg0.btnSp, false)
	setActive(arg0.spMask, false)
	setActive(arg0.tfLimitElite, false)
	setActive(arg0.tfLimitTips, false)
	setActive(arg0.tfLimit, false)
	setActive(arg0:findTF("panel/title/ASvalue"), false)
	setText(arg0:findTF("panel/formation_btn/text"), i18n("autofight_formation"))
	setText(arg0:findTF("panel/commander_btn/text"), i18n("autofight_cat"))
	setText(arg0._tf:Find("panel/title/Image/text"), i18n("fleet_select_title"))
	arg0:InitInteractable()
end

function var0.InitInteractable(arg0)
	onButton(arg0, arg0.btnGo, function()
		arg0:OnCombat()
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0, arg0.btnTry, function()
		arg0:OnTrybat()
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0, arg0.btnBack, function()
		arg0:OnCancel()
		arg0:OnCommit()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf, function()
		arg0:OnCancel()
		arg0:OnCommit()
	end, SFX_CANCEL)
	onToggle(arg0, arg0.commanderToggle, function(arg0)
		if arg0 then
			arg0.viewParent.contextData.showCommander = arg0

			for iter0, iter1 in pairs(arg0.tfFleets) do
				for iter2 = 1, #iter1 do
					arg0:updateCommanderBtn(iter0, iter2)
				end
			end
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.formationToggle, function(arg0)
		if arg0 then
			arg0.viewParent.contextData.showCommander = not arg0

			for iter0, iter1 in pairs(arg0.tfFleets) do
				for iter2 = 1, #iter1 do
					arg0:updateCommanderBtn(iter0, iter2)
				end
			end
		end
	end, SFX_PANEL)
end

function var0.SetFleets(arg0, arg1)
	arg0.fleets = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0, iter1 in pairs(arg1) do
		iter1:RemoveUnusedItems()

		if iter1:isSubmarineFleet() then
			if #arg0.fleets[FleetType.Submarine] < arg0:getLimitNums(FleetType.Submarine) then
				table.insert(arg0.fleets[FleetType.Submarine], iter1)
			end
		elseif #arg0.fleets[FleetType.Normal] < arg0:getLimitNums(FleetType.Normal) then
			table.insert(arg0.fleets[FleetType.Normal], iter1)
		end
	end
end

function var0.SetOilLimit(arg0, arg1)
	local var0 = _.any(arg1, function(arg0)
		return arg0 > 0
	end)

	setActive(arg0.rtCostLimit, var0)
	setText(arg0.rtCostLimit:Find("text"), i18n("formationScene_use_oil_limit_tip_worldboss"))

	if var0 then
		local var1 = 0
		local var2 = arg1[1]

		setActive(arg0.rtCostLimit:Find("cost_noraml/Text"), var2 > 0)

		if var2 > 0 then
			setText(arg0.rtCostLimit:Find("cost_noraml/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_surface"), var2))
		end

		local var3 = 0

		setActive(arg0.rtCostLimit:Find("cost_boss/Text"), var3 > 0)

		local var4 = arg1[2]

		setActive(arg0.rtCostLimit:Find("cost_sub/Text"), var4 > 0)

		if var4 > 0 then
			setText(arg0.rtCostLimit:Find("cost_sub/Text"), string.format("%s(%d)", i18n("formationScene_use_oil_limit_submarine"), var4))
		end
	end
end

function var0.SetSettings(arg0, arg1, arg2, arg3)
	arg0.groupNum = arg1
	arg0.submarineNum = arg2
	arg0.showTryBtn = arg3
end

function var0.UpdateView(arg0)
	arg0:clearFleets()
	arg0:UpdateFleets()

	local var0 = not LOCK_COMMANDER and pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "CommanderCatMediator")

	triggerToggle(arg0.viewParent.contextData.showCommander and var0 and arg0.commanderToggle or arg0.formationToggle, true)
	setActive(arg0.commanderToggle, var0)
	setActive(arg0.btnTry, arg0.showTryBtn)
end

function var0.getLimitNums(arg0, arg1)
	local var0 = 0

	if arg1 == FleetType.Normal then
		var0 = arg0.groupNum
	elseif arg1 == FleetType.Submarine then
		var0 = arg0.submarineNum
	end

	return var0 or 0
end

function var0.UpdateFleets(arg0)
	for iter0, iter1 in pairs(arg0.tfFleets) do
		for iter2 = 1, #iter1 do
			arg0:updateFleet(iter0, iter2)
		end
	end
end

function var0.updateFleet(arg0, arg1, arg2)
	arg0:updateCommanderBtn(arg1, arg2)

	local var0 = arg2 <= arg0:getLimitNums(arg1)
	local var1 = var0 and arg0.fleets[arg1][arg2]
	local var2 = arg0.tfFleets[arg1][arg2]
	local var3 = findTF(var2, "bg/name")
	local var4 = arg0:findTF(TeamType.Main, var2)
	local var5 = arg0:findTF(TeamType.Vanguard, var2)
	local var6 = arg0:findTF(TeamType.Submarine, var2)
	local var7 = arg0:findTF("btn_recom", var2)
	local var8 = arg0:findTF("btn_clear", var2)
	local var9 = arg0:findTF("selected", var2)
	local var10 = arg0:findTF("commander", var2)

	setActive(var9, false)
	setText(var3, "")

	if var4 then
		setActive(var4, var0 and var1)
	end

	if var5 then
		setActive(var5, var0 and var1)
	end

	if var6 then
		setActive(var6, var0 and var1)
	end

	if var0 and var1 then
		setText(var3, Fleet.DEFAULT_NAME_BOSS_ACT[var1.id] or "")

		if arg1 == FleetType.Submarine then
			arg0:updateShips(var6, var1.subShips, var1.id, TeamType.Submarine)
		else
			arg0:updateShips(var4, var1.mainShips, var1.id, TeamType.Main)
			arg0:updateShips(var5, var1.vanguardShips, var1.id, TeamType.Vanguard)
		end

		arg0:updateCommanders(var10, var1)
		onButton(arg0, var7, function()
			arg0:emit(arg0.viewParent.contextData.mediatorClass.ON_FLEET_RECOMMEND, var1.id)
		end)
		onButton(arg0, var8, function()
			arg0:emit(arg0.viewParent.contextData.mediatorClass.ON_FLEET_CLEAR, var1.id)
		end, SFX_UI_CLICK)
	end
end

function var0.updateShips(arg0, arg1, arg2, arg3, arg4)
	removeAllChildren(arg1)

	local var0 = getProxy(BayProxy)

	for iter0 = 1, 3 do
		local var1 = var0:getShipById(arg2[iter0])
		local var2 = var1 and arg0.tfShipTpl or arg0.tfEmptyTpl
		local var3 = cloneTplTo(var2, arg1)

		setActive(var3, true)

		if var1 then
			updateShip(var3, var1)
			setActive(var3:Find("event_block"), var1:getFlag("inEvent"))
		end

		setActive(arg0:findTF("ship_type", var3), false)

		local var4 = GetOrAddComponent(var3, typeof(UILongPressTrigger))

		var4.onLongPressed:RemoveAllListeners()

		local function var5()
			arg0:emit(arg0.viewParent.contextData.mediatorClass.ON_OPEN_DOCK, {
				fleet = arg2,
				shipVO = var1,
				fleetIndex = arg3,
				teamType = arg4
			})
		end

		onButton(arg0, var3, var5)
		var4.onLongPressed:AddListener(function()
			if var1 then
				arg0:OnLongPressShip(arg2[iter0], arg3)
			else
				var5()
			end
		end)
	end
end

function var0.updateCommanderBtn(arg0, arg1, arg2)
	local var0 = arg2 <= arg0:getLimitNums(arg1)
	local var1 = var0 and arg0.fleets[arg1][arg2]
	local var2 = arg0.tfFleets[arg1][arg2]
	local var3 = arg0:findTF("btn_select", var2)
	local var4 = arg0:findTF("btn_clear", var2)
	local var5 = arg0:findTF("btn_recom", var2)
	local var6 = arg0:findTF("blank", var2)
	local var7 = arg0:findTF("commander", var2)

	setActive(var3, false)
	setActive(var4, var0 and not arg0.viewParent.contextData.showCommander)
	setActive(var5, var0 and not arg0.viewParent.contextData.showCommander)
	setActive(var7, var0 and var1 and arg0.viewParent.contextData.showCommander)
	setActive(var6, not var0 or var0 and not var1 and arg0.viewParent.contextData.showCommander)
end

function var0.updateCommanders(arg0, arg1, arg2)
	for iter0 = 1, 2 do
		local var0 = arg2:getCommanderByPos(iter0)
		local var1 = arg1:Find("pos" .. iter0)
		local var2 = var1:Find("add")
		local var3 = var1:Find("info")

		setActive(var2, not var0)
		setActive(var3, var0)

		if var0 then
			local var4 = Commander.rarity2Frame(var0:getRarity())

			setImageSprite(var3:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var4))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var0:getPainting(), "", var3:Find("mask/icon"))
		end

		onButton(arg0, var2, function()
			arg0:InvokeParent("openCommanderPanel", arg2, arg2.id)
		end, SFX_PANEL)
		onButton(arg0, var3, function()
			arg0:InvokeParent("openCommanderPanel", arg2, arg2.id)
		end, SFX_PANEL)
	end
end

function var0.clearFleets(arg0)
	for iter0, iter1 in pairs(arg0.tfFleets) do
		_.each(iter1, function(arg0)
			arg0:clearFleet(arg0)
		end)
	end
end

function var0.clearFleet(arg0, arg1)
	local var0 = arg0:findTF(TeamType.Main, arg1)
	local var1 = arg0:findTF(TeamType.Vanguard, arg1)
	local var2 = arg0:findTF(TeamType.Submarine, arg1)

	if var0 then
		removeAllChildren(var0)
	end

	if var1 then
		removeAllChildren(var1)
	end

	if var2 then
		removeAllChildren(var2)
	end
end

function var0.OnShow(arg0)
	local var0 = #getProxy(ContextProxy):getCurrentContext().children > 0 and LayerWeightConst.LOWER_LAYER or nil

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, nil, {
		groupName = LayerWeightConst.GROUP_FORMATION_PAGE,
		weight = var0
	})
end

function var0.OnHide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.viewParent._tf)
	triggerToggle(arg0.commanderToggle, false)
end

function var0.OnCancel(arg0)
	arg0:InvokeParent("hideFleetEdit")
end

function var0.OnCommit(arg0)
	arg0:InvokeParent("commitEdit")
end

function var0.OnCombat(arg0)
	arg0:InvokeParent("commitEdit")
	arg0:InvokeParent("commitCombat")
end

function var0.OnTrybat(arg0)
	arg0:InvokeParent("commitEdit")
	arg0:InvokeParent("commitTrybat")
end

function var0.OnLongPressShip(arg0, arg1, arg2)
	arg0:InvokeParent("openShipInfo", arg1, arg2)
end

return var0
