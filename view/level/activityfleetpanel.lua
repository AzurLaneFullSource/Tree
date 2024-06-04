local var0 = class("ActivityFleetPanel", import("..level.LevelEliteFleetPanel"))

var0.ON_OPEN_DOCK = "ActivityFleetPanel:ON_OPEN_DOCK"
var0.ON_FLEET_RECOMMEND = "ActivityFleetPanel:ON_FLEET_RECOMMEND"
var0.ON_FLEET_CLEAR = "ActivityFleetPanel:ON_FLEET_CLEAR"

function var0.init(arg0)
	var0.super.init(arg0)
end

function var0.set(arg0, arg1, arg2)
	arg0.groupNum = arg1
	arg0.submarineNum = arg2

	setActive(arg0.tfLimitElite, false)
	setActive(arg0.tfLimitTips, false)
	setActive(arg0.tfLimit, false)
	onButton(arg0, arg0.btnGo, function()
		if arg0.onCombat then
			arg0.onCombat()
		end
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0, arg0.btnBack, function()
		if arg0.onCancel then
			arg0.onCancel()
		end

		if arg0.onCommit then
			arg0.onCommit()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf, function()
		if arg0.onCancel then
			arg0.onCancel()
		end

		if arg0.onCommit then
			arg0.onCommit()
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.toggleMask, function()
		arg0:hideToggleMask()
	end, SFX_CANCEL)
	onToggle(arg0, arg0.commanderBtn, function(arg0)
		arg0.parent.contextData.showCommander = arg0

		for iter0, iter1 in pairs(arg0.tfFleets) do
			for iter2 = 1, #iter1 do
				arg0:updateCommanderBtn(iter0, iter2)
			end
		end
	end, SFX_PANEL)
	triggerToggle(arg0.commanderBtn, arg0.parent.contextData.showCommander)
	setActive(arg0.commanderBtn, arg0.parent.openedCommanerSystem)
	arg0:clearFleets()
	arg0:updateFleets()
end

function var0.getLimitNums(arg0, arg1)
	local var0 = 0

	if arg1 == FleetType.Normal then
		var0 = arg0.groupNum
	elseif arg1 == FleetType.Submarine then
		var0 = arg0.submarineNum
	end

	return var0
end

function var0.updateFleets(arg0)
	for iter0, iter1 in pairs(arg0.tfFleets) do
		for iter2 = 1, #iter1 do
			arg0:updateFleet(iter0, iter2)
		end
	end
end

function var0.updateLimit(arg0)
	return
end

function var0.updateCommanderBtn(arg0, arg1, arg2)
	local var0 = arg2 <= arg0:getLimitNums(arg1)
	local var1 = arg0.fleets[arg1][arg2]
	local var2 = arg0.tfFleets[arg1][arg2]
	local var3 = arg0:findTF("btn_select", var2)
	local var4 = arg0:findTF("btn_clear", var2)
	local var5 = arg0:findTF("btn_recom", var2)
	local var6 = arg0:findTF("blank", var2)
	local var7 = arg0:findTF("commander", var2)

	setActive(var3, false)
	setActive(var4, var0 and not arg0.parent.contextData.showCommander)
	setActive(var5, var0 and not arg0.parent.contextData.showCommander)
	setActive(var6, not var0 or var0 and not var1 and arg0.parent.contextData.showCommander)
	setActive(var7, arg0.parent.contextData.showCommander and var0 and var1)
end

function var0.updateFleet(arg0, arg1, arg2)
	arg0:updateCommanderBtn(arg1, arg2)

	local var0 = arg0.fleets[arg1][arg2]
	local var1 = arg2 <= arg0:getLimitNums(arg1)
	local var2 = arg0.tfFleets[arg1][arg2]
	local var3 = findTF(var2, "bg/name")
	local var4 = arg0:findTF(TeamType.Main, var2)
	local var5 = arg0:findTF(TeamType.Vanguard, var2)
	local var6 = arg0:findTF(TeamType.Submarine, var2)
	local var7 = arg0:findTF("btn_select", var2)
	local var8 = arg0:findTF("btn_recom", var2)
	local var9 = arg0:findTF("btn_clear", var2)
	local var10 = arg0:findTF("blank", var2)
	local var11 = arg0:findTF("selected", var2)
	local var12 = arg0:findTF("commander", var2)

	setActive(var11, false)
	setText(var3, "")

	if var4 then
		setActive(var4, var1 and var0)
	end

	if var5 then
		setActive(var5, var1 and var0)
	end

	if var6 then
		setActive(var6, var1 and var0)
	end

	if var1 then
		if var0 then
			setText(var3, var0.name == "" and Fleet.DEFAULT_NAME[var0.id] or var0.name)

			if arg1 == FleetType.Submarine then
				arg0:updateShips(var6, var0.subShips, var0.id, TeamType.Submarine, var0)
			else
				arg0:updateShips(var4, var0.mainShips, var0.id, TeamType.Main, var0)
				arg0:updateShips(var5, var0.vanguardShips, var0.id, TeamType.Vanguard, var0)
			end

			arg0:updateCommanders(var12, var0)
		end

		onButton(arg0, var8, function()
			arg0.parent:emit(var0.ON_FLEET_RECOMMEND, var0.id)
		end)
		onButton(arg0, var9, function()
			arg0.parent:emit(var0.ON_FLEET_CLEAR, var0.id)
		end, SFX_UI_CLICK)
	end
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
			arg0.parent:openCommanderPanel(arg2, arg2.id)
		end, SFX_PANEL)
		onButton(arg0, var3, function()
			arg0.parent:openCommanderPanel(arg2, arg2.id)
		end, SFX_PANEL)
	end
end

function var0.updateShips(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = UIItemList.New(arg1, arg0.tfShipTpl)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = getProxy(BayProxy)
			local var1 = var0:getShipById(arg2[arg1 + 1])

			if var1 then
				setActive(arg2:Find("icon_bg"), true)
				setActive(arg2:Find("empty"), false)
				updateShip(arg2, var1)
			else
				setActive(arg2:Find("icon_bg"), false)
				setActive(arg2:Find("empty"), true)
			end

			setActive(findTF(arg2, "ship_type"), false)

			local var2 = GetOrAddComponent(arg2, typeof(UILongPressTrigger))

			local function var3()
				arg0.onCancel()
				arg0.parent:emit(var0.ON_OPEN_DOCK, {
					shipType = 0,
					fleet = arg2,
					shipVO = var1,
					fleetIndex = arg3,
					teamType = arg4
				})
			end

			var2.onReleased:RemoveAllListeners()
			var2.onLongPressed:RemoveAllListeners()
			var2.onReleased:AddListener(function()
				var3()
			end)
			var2.onLongPressed:AddListener(function()
				if var1 then
					arg0.onCancel()
					arg0.onLongPressShip(var1.id, _.map(arg5:getShipIds(), function(arg0)
						return var0:getShipById(arg0)
					end))
				else
					var3()
				end
			end)
		end
	end)
	var0:align(3)
end

function var0.showToggleMask(arg0, arg1, arg2)
	setActive(arg0.toggleMask, true)

	local var0 = _.filter(arg0.fleets, function(arg0)
		return arg0:getFleetType() == arg1
	end)

	for iter0, iter1 in ipairs(arg0.toggles) do
		local var1 = var0[iter0]

		setActive(iter1, var1)

		if var1 then
			local var2, var3 = var1:isUnlock()
			local var4 = iter1:Find("lock")

			setButtonEnabled(iter1, var2)
			setActive(var4, not var2)

			if var2 then
				local var5 = table.contains(arg0.selectIds[arg1], var1.id)

				setActive(findTF(iter1, "selected"), var5)
				setActive(findTF(iter1, "text"), not var5)
				setActive(findTF(iter1, "text_selected"), var5)
				onButton(arg0, iter1, function()
					arg2(var1.id)
				end, SFX_UI_TAG)
			else
				onButton(arg0, var4, function()
					pg.TipsMgr.GetInstance():ShowTips(var3)
				end, SFX_UI_CLICK)
			end
		end
	end
end

function var0.hideToggleMask(arg0)
	setActive(arg0.toggleMask, false)
end

function var0.setFleets(arg0, arg1)
	arg0.fleets = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0, iter1 in pairs(arg1) do
		if iter1:isSubmarineFleet() then
			table.insert(arg0.fleets[FleetType.Submarine], iter1)
		else
			table.insert(arg0.fleets[FleetType.Normal], iter1)
		end
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

function var0.clear(arg0)
	triggerToggle(arg0.commanderBtn, false)
end

return var0
