local var0_0 = class("ActivityFleetPanel", import("..level.LevelEliteFleetPanel"))

var0_0.ON_OPEN_DOCK = "ActivityFleetPanel:ON_OPEN_DOCK"
var0_0.ON_FLEET_RECOMMEND = "ActivityFleetPanel:ON_FLEET_RECOMMEND"
var0_0.ON_FLEET_CLEAR = "ActivityFleetPanel:ON_FLEET_CLEAR"

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)
end

function var0_0.set(arg0_2, arg1_2, arg2_2)
	arg0_2.groupNum = arg1_2
	arg0_2.submarineNum = arg2_2

	setActive(arg0_2.tfLimitElite, false)
	setActive(arg0_2.tfLimitTips, false)
	setActive(arg0_2.tfLimit, false)
	onButton(arg0_2, arg0_2.btnGo, function()
		if arg0_2.onCombat then
			arg0_2.onCombat()
		end
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_2, arg0_2.btnBack, function()
		if arg0_2.onCancel then
			arg0_2.onCancel()
		end

		if arg0_2.onCommit then
			arg0_2.onCommit()
		end
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2._tf, function()
		if arg0_2.onCancel then
			arg0_2.onCancel()
		end

		if arg0_2.onCommit then
			arg0_2.onCommit()
		end
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.toggleMask, function()
		arg0_2:hideToggleMask()
	end, SFX_CANCEL)
	onToggle(arg0_2, arg0_2.commanderBtn, function(arg0_7)
		arg0_2.parent.contextData.showCommander = arg0_7

		for iter0_7, iter1_7 in pairs(arg0_2.tfFleets) do
			for iter2_7 = 1, #iter1_7 do
				arg0_2:updateCommanderBtn(iter0_7, iter2_7)
			end
		end
	end, SFX_PANEL)
	triggerToggle(arg0_2.commanderBtn, arg0_2.parent.contextData.showCommander)
	setActive(arg0_2.commanderBtn, arg0_2.parent.openedCommanerSystem)
	arg0_2:clearFleets()
	arg0_2:updateFleets()
end

function var0_0.getLimitNums(arg0_8, arg1_8)
	local var0_8 = 0

	if arg1_8 == FleetType.Normal then
		var0_8 = arg0_8.groupNum
	elseif arg1_8 == FleetType.Submarine then
		var0_8 = arg0_8.submarineNum
	end

	return var0_8
end

function var0_0.updateFleets(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.tfFleets) do
		for iter2_9 = 1, #iter1_9 do
			arg0_9:updateFleet(iter0_9, iter2_9)
		end
	end
end

function var0_0.updateLimit(arg0_10)
	return
end

function var0_0.updateCommanderBtn(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg2_11 <= arg0_11:getLimitNums(arg1_11)
	local var1_11 = arg0_11.fleets[arg1_11][arg2_11]
	local var2_11 = arg0_11.tfFleets[arg1_11][arg2_11]
	local var3_11 = arg0_11:findTF("btn_select", var2_11)
	local var4_11 = arg0_11:findTF("btn_clear", var2_11)
	local var5_11 = arg0_11:findTF("btn_recom", var2_11)
	local var6_11 = arg0_11:findTF("blank", var2_11)
	local var7_11 = arg0_11:findTF("commander", var2_11)

	setActive(var3_11, false)
	setActive(var4_11, var0_11 and not arg0_11.parent.contextData.showCommander)
	setActive(var5_11, var0_11 and not arg0_11.parent.contextData.showCommander)
	setActive(var6_11, not var0_11 or var0_11 and not var1_11 and arg0_11.parent.contextData.showCommander)
	setActive(var7_11, arg0_11.parent.contextData.showCommander and var0_11 and var1_11)
end

function var0_0.updateFleet(arg0_12, arg1_12, arg2_12)
	arg0_12:updateCommanderBtn(arg1_12, arg2_12)

	local var0_12 = arg0_12.fleets[arg1_12][arg2_12]
	local var1_12 = arg2_12 <= arg0_12:getLimitNums(arg1_12)
	local var2_12 = arg0_12.tfFleets[arg1_12][arg2_12]
	local var3_12 = findTF(var2_12, "bg/name")
	local var4_12 = arg0_12:findTF(TeamType.Main, var2_12)
	local var5_12 = arg0_12:findTF(TeamType.Vanguard, var2_12)
	local var6_12 = arg0_12:findTF(TeamType.Submarine, var2_12)
	local var7_12 = arg0_12:findTF("btn_select", var2_12)
	local var8_12 = arg0_12:findTF("btn_recom", var2_12)
	local var9_12 = arg0_12:findTF("btn_clear", var2_12)
	local var10_12 = arg0_12:findTF("blank", var2_12)
	local var11_12 = arg0_12:findTF("selected", var2_12)
	local var12_12 = arg0_12:findTF("commander", var2_12)

	setActive(var11_12, false)
	setText(var3_12, "")

	if var4_12 then
		setActive(var4_12, var1_12 and var0_12)
	end

	if var5_12 then
		setActive(var5_12, var1_12 and var0_12)
	end

	if var6_12 then
		setActive(var6_12, var1_12 and var0_12)
	end

	if var1_12 then
		if var0_12 then
			setText(var3_12, var0_12.name == "" and Fleet.DEFAULT_NAME[var0_12.id] or var0_12.name)

			if arg1_12 == FleetType.Submarine then
				arg0_12:updateShips(var6_12, var0_12.subShips, var0_12.id, TeamType.Submarine, var0_12)
			else
				arg0_12:updateShips(var4_12, var0_12.mainShips, var0_12.id, TeamType.Main, var0_12)
				arg0_12:updateShips(var5_12, var0_12.vanguardShips, var0_12.id, TeamType.Vanguard, var0_12)
			end

			arg0_12:updateCommanders(var12_12, var0_12)
		end

		onButton(arg0_12, var8_12, function()
			arg0_12.parent:emit(var0_0.ON_FLEET_RECOMMEND, var0_12.id)
		end)
		onButton(arg0_12, var9_12, function()
			arg0_12.parent:emit(var0_0.ON_FLEET_CLEAR, var0_12.id)
		end, SFX_UI_CLICK)
	end
end

function var0_0.updateCommanders(arg0_15, arg1_15, arg2_15)
	for iter0_15 = 1, 2 do
		local var0_15 = arg2_15:getCommanderByPos(iter0_15)
		local var1_15 = arg1_15:Find("pos" .. iter0_15)
		local var2_15 = var1_15:Find("add")
		local var3_15 = var1_15:Find("info")

		setActive(var2_15, not var0_15)
		setActive(var3_15, var0_15)

		if var0_15 then
			local var4_15 = Commander.rarity2Frame(var0_15:getRarity())

			setImageSprite(var3_15:Find("frame"), GetSpriteFromAtlas("weaponframes", "commander_" .. var4_15))
			GetImageSpriteFromAtlasAsync("CommanderHrz/" .. var0_15:getPainting(), "", var3_15:Find("mask/icon"))
		end

		onButton(arg0_15, var2_15, function()
			arg0_15.parent:openCommanderPanel(arg2_15, arg2_15.id)
		end, SFX_PANEL)
		onButton(arg0_15, var3_15, function()
			arg0_15.parent:openCommanderPanel(arg2_15, arg2_15.id)
		end, SFX_PANEL)
	end
end

function var0_0.updateShips(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18, arg5_18)
	local var0_18 = UIItemList.New(arg1_18, arg0_18.tfShipTpl)

	var0_18:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = getProxy(BayProxy)
			local var1_19 = var0_19:getShipById(arg2_18[arg1_19 + 1])

			if var1_19 then
				setActive(arg2_19:Find("icon_bg"), true)
				setActive(arg2_19:Find("empty"), false)
				updateShip(arg2_19, var1_19)
			else
				setActive(arg2_19:Find("icon_bg"), false)
				setActive(arg2_19:Find("empty"), true)
			end

			setActive(findTF(arg2_19, "ship_type"), false)

			local var2_19 = GetOrAddComponent(arg2_19, typeof(UILongPressTrigger))

			local function var3_19()
				arg0_18.onCancel()
				arg0_18.parent:emit(var0_0.ON_OPEN_DOCK, {
					shipType = 0,
					fleet = arg2_18,
					shipVO = var1_19,
					fleetIndex = arg3_18,
					teamType = arg4_18
				})
			end

			var2_19.onReleased:RemoveAllListeners()
			var2_19.onLongPressed:RemoveAllListeners()
			var2_19.onReleased:AddListener(function()
				var3_19()
			end)
			var2_19.onLongPressed:AddListener(function()
				if var1_19 then
					arg0_18.onCancel()
					arg0_18.onLongPressShip(var1_19.id, _.map(arg5_18:getShipIds(), function(arg0_23)
						return var0_19:getShipById(arg0_23)
					end))
				else
					var3_19()
				end
			end)
		end
	end)
	var0_18:align(3)
end

function var0_0.showToggleMask(arg0_24, arg1_24, arg2_24)
	setActive(arg0_24.toggleMask, true)

	local var0_24 = _.filter(arg0_24.fleets, function(arg0_25)
		return arg0_25:getFleetType() == arg1_24
	end)

	for iter0_24, iter1_24 in ipairs(arg0_24.toggles) do
		local var1_24 = var0_24[iter0_24]

		setActive(iter1_24, var1_24)

		if var1_24 then
			local var2_24, var3_24 = var1_24:isUnlock()
			local var4_24 = iter1_24:Find("lock")

			setButtonEnabled(iter1_24, var2_24)
			setActive(var4_24, not var2_24)

			if var2_24 then
				local var5_24 = table.contains(arg0_24.selectIds[arg1_24], var1_24.id)

				setActive(findTF(iter1_24, "selected"), var5_24)
				setActive(findTF(iter1_24, "text"), not var5_24)
				setActive(findTF(iter1_24, "text_selected"), var5_24)
				onButton(arg0_24, iter1_24, function()
					arg2_24(var1_24.id)
				end, SFX_UI_TAG)
			else
				onButton(arg0_24, var4_24, function()
					pg.TipsMgr.GetInstance():ShowTips(var3_24)
				end, SFX_UI_CLICK)
			end
		end
	end
end

function var0_0.hideToggleMask(arg0_28)
	setActive(arg0_28.toggleMask, false)
end

function var0_0.setFleets(arg0_29, arg1_29)
	arg0_29.fleets = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0_29, iter1_29 in pairs(arg1_29) do
		if iter1_29:isSubmarineFleet() then
			table.insert(arg0_29.fleets[FleetType.Submarine], iter1_29)
		else
			table.insert(arg0_29.fleets[FleetType.Normal], iter1_29)
		end
	end
end

function var0_0.clearFleets(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.tfFleets) do
		_.each(iter1_30, function(arg0_31)
			arg0_30:clearFleet(arg0_31)
		end)
	end
end

function var0_0.clearFleet(arg0_32, arg1_32)
	local var0_32 = arg0_32:findTF(TeamType.Main, arg1_32)
	local var1_32 = arg0_32:findTF(TeamType.Vanguard, arg1_32)
	local var2_32 = arg0_32:findTF(TeamType.Submarine, arg1_32)

	if var0_32 then
		removeAllChildren(var0_32)
	end

	if var1_32 then
		removeAllChildren(var1_32)
	end

	if var2_32 then
		removeAllChildren(var2_32)
	end
end

function var0_0.clear(arg0_33)
	triggerToggle(arg0_33.commanderBtn, false)
end

return var0_0
