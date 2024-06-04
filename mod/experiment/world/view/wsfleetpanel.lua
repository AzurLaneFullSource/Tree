local var0 = class("WSFleetPanel", import("...BaseEntity"))

var0.Fields = {
	map = "table",
	onCancel = "function",
	btnGo = "userdata",
	rtLimitTips = "userdata",
	toggles = "table",
	btnBack = "userdata",
	rtEmptyTpl = "userdata",
	fleets = "table",
	toggleMask = "userdata",
	rtShipTpl = "userdata",
	transform = "userdata",
	toggleList = "userdata",
	onConfirm = "function",
	rtFleets = "table",
	rtLimitElite = "userdata",
	rtLimit = "userdata",
	selectIds = "table"
}

function var0.Setup(arg0)
	pg.DelegateInfo.New(arg0)
	arg0:Init()
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.transform

	arg0.rtShipTpl = var0:Find("panel/shiptpl")
	arg0.rtEmptyTpl = var0:Find("panel/emptytpl")
	arg0.rtFleets = {
		[FleetType.Normal] = {
			var0:Find("panel/bg/content/fleet/1"),
			var0:Find("panel/bg/content/fleet/2"),
			var0:Find("panel/bg/content/fleet/3"),
			var0:Find("panel/bg/content/fleet/4")
		},
		[FleetType.Submarine] = {
			var0:Find("panel/bg/content/sub/1")
		}
	}
	arg0.rtLimit = var0:Find("panel/limit")
	arg0.rtLimitElite = var0:Find("panel/limit_elite")
	arg0.rtLimitTips = var0:Find("panel/limit_tip")
	arg0.btnBack = var0:Find("panel/btnBack")
	arg0.btnGo = var0:Find("panel/start_button")
	arg0.toggleMask = var0:Find("mask")
	arg0.toggleList = var0:Find("mask/list")
	arg0.toggles = {}

	for iter0 = 0, arg0.toggleList.childCount - 1 do
		table.insert(arg0.toggles, arg0.toggleList:Find("item" .. iter0 + 1))
	end

	setActive(arg0.rtShipTpl, false)
	setActive(arg0.rtEmptyTpl, false)
	setActive(arg0.toggleMask, false)
end

function var0.UpdateMulti(arg0, arg1, arg2, arg3)
	arg0.map = arg1
	arg0.fleets = _(_.values(arg2)):chain():filter(function(arg0)
		return arg0:isRegularFleet()
	end):sort(function(arg0, arg1)
		return arg0.id < arg1.id
	end):value()
	arg0.selectIds = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0, iter1 in ipairs(arg3 or {}) do
		local var0 = arg0:getFleetById(iter1)

		if var0 then
			local var1 = var0:getFleetType()
			local var2 = arg0.selectIds[var1]

			if #var2 < arg0:getLimitNums(var1) then
				table.insert(var2, iter1)
			end
		end
	end

	setActive(arg0.rtLimitElite, false)
	setActive(arg0.rtLimitTips, false)
	setActive(arg0.rtLimit, true)
	onButton(arg0, arg0.btnGo, function()
		arg0.onConfirm(arg0:getSelectIds())
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0, arg0.btnBack, function()
		arg0.onCancel()
	end, SFX_CANCEL)
	onButton(arg0, arg0.transform, function()
		arg0.onCancel()
	end, SFX_CANCEL)
	onButton(arg0, arg0.toggleMask, function()
		arg0:hideToggleMask()
	end, SFX_CANCEL)
	arg0:clearFleets()
	arg0:updateFleets()
	arg0:updateLimit()
end

function var0.getFleetById(arg0, arg1)
	return _.detect(arg0.fleets, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.getLimitNums(arg0, arg1)
	local var0 = 0

	if arg1 == FleetType.Normal then
		var0 = 4
	elseif arg1 == FleetType.Submarine then
		var0 = 1
	end

	return var0
end

function var0.getSelectIds(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.selectIds) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3 > 0 then
				table.insert(var0, iter3)
			end
		end
	end

	_.sort(var0, function(arg0, arg1)
		return arg0 < arg1
	end)

	return var0
end

function var0.updateFleets(arg0)
	for iter0, iter1 in pairs(arg0.rtFleets) do
		for iter2 = 1, #iter1 do
			arg0:updateFleet(iter0, iter2)
		end
	end
end

function var0.updateLimit(arg0)
	local var0 = #_.filter(arg0.selectIds[FleetType.Normal], function(arg0)
		return arg0 > 0
	end)
	local var1 = #_.filter(arg0.selectIds[FleetType.Submarine], function(arg0)
		return arg0 > 0
	end)
	local var2 = arg0:getLimitNums(FleetType.Normal)

	setText(arg0.rtLimit:Find("number"), string.format("%d/%d", var0, var2))

	local var3 = arg0:getLimitNums(FleetType.Submarine)

	setText(arg0.rtLimit:Find("number_sub"), string.format("%d/%d", var1, var3))
end

function var0.selectFleet(arg0, arg1, arg2, arg3)
	if fleetId ~= arg3 then
		local var0 = arg0.selectIds[arg1]

		if arg3 > 0 and table.contains(var0, arg3) then
			return
		end

		if arg1 == FleetType.Normal and arg0:getLimitNums(arg1) > 0 and arg3 == 0 and #_.filter(var0, function(arg0)
			return arg0 > 0
		end) == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_lease_one_ship"))

			return
		end

		local var1 = arg0:getFleetById(arg3)

		if var1 then
			if not var1:isUnlock() then
				return
			end

			if var1:isLegalToFight() ~= true then
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_not_enough"))

				return
			end
		end

		var0[arg2] = arg3

		arg0:updateFleet(arg1, arg2)
		arg0:updateLimit()
	end
end

function var0.updateFleet(arg0, arg1, arg2)
	local var0 = arg0.selectIds[arg1][arg2]
	local var1 = arg0:getFleetById(var0)
	local var2 = arg2 <= arg0:getLimitNums(arg1)
	local var3 = arg0.rtFleets[arg1][arg2]
	local var4 = var3:Find("bg/name")
	local var5 = var3:Find("main")
	local var6 = var3:Find("vanguard")
	local var7 = var3:Find("sub")
	local var8 = var3:Find("btn_select")
	local var9 = var3:Find("btn_recom")
	local var10 = var3:Find("btn_clear")
	local var11 = var3:Find("blank")
	local var12 = var3:Find("selected")

	setText(var4, "")
	setActive(var12, false)
	setActive(var8, var2)
	setActive(var10, var2)
	setActive(var9, false)
	setActive(var11, not var2)

	if var5 then
		setActive(var5, var2 and var1)
	end

	if var6 then
		setActive(var6, var2 and var1)
	end

	if var7 then
		setActive(var7, var2 and var1)
	end

	if var2 then
		if var1 then
			setText(var4, var1.name == "" and Fleet.DEFAULT_NAME[var1.id] or var1.name)

			if arg1 == FleetType.Submarine then
				arg0:updateShips(var7, var1.subShips)
			else
				arg0:updateShips(var5, var1.mainShips)
				arg0:updateShips(var6, var1.vanguardShips)
			end
		end

		onButton(arg0, var8, function()
			arg0.toggleList.position = (var8.position + var10.position) / 2
			arg0.toggleList.anchoredPosition = arg0.toggleList.anchoredPosition + Vector2(-arg0.toggleList.rect.width / 2, -var8.rect.height / 2)

			arg0:showToggleMask(arg1, function(arg0)
				arg0:hideToggleMask()
				arg0:selectFleet(arg1, arg2, arg0)
			end)
		end, SFX_UI_CLICK)
		onButton(arg0, var10, function()
			arg0:selectFleet(arg1, arg2, 0)
		end, SFX_UI_CLICK)
	end
end

function var0.updateShips(arg0, arg1, arg2)
	local var0 = UIItemList.New(arg1, arg0.rtShipTpl)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = getProxy(BayProxy):getShipById(arg2[arg1 + 1])

			updateShip(arg2, var0)

			local var1 = arg2:Find("icon_bg/energy")
			local var2 = var0:getEnergeConfig()

			if var2 and var2.id <= 2 then
				setActive(var1, true)
				GetImageSpriteFromAtlasAsync("energy", var2.icon, var1)
			else
				setActive(var1, false)
			end
		end
	end)
	var0:align(#arg2)
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

				setActive(iter1:Find("selected"), var5)
				setActive(iter1:Find("text"), not var5)
				setActive(iter1:Find("text_selected"), var5)
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

function var0.clearFleets(arg0)
	for iter0, iter1 in pairs(arg0.rtFleets) do
		_.each(iter1, function(arg0)
			arg0:clearFleet(arg0)
		end)
	end
end

function var0.clearFleet(arg0, arg1)
	local var0 = arg1:Find("main")
	local var1 = arg1:Find("vanguard")
	local var2 = arg1:Find("sub")

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

return var0
