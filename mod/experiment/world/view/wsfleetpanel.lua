local var0_0 = class("WSFleetPanel", import("...BaseEntity"))

var0_0.Fields = {
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

function var0_0.Setup(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3.transform

	arg0_3.rtShipTpl = var0_3:Find("panel/shiptpl")
	arg0_3.rtEmptyTpl = var0_3:Find("panel/emptytpl")
	arg0_3.rtFleets = {
		[FleetType.Normal] = {
			var0_3:Find("panel/bg/content/fleet/1"),
			var0_3:Find("panel/bg/content/fleet/2"),
			var0_3:Find("panel/bg/content/fleet/3"),
			var0_3:Find("panel/bg/content/fleet/4")
		},
		[FleetType.Submarine] = {
			var0_3:Find("panel/bg/content/sub/1")
		}
	}
	arg0_3.rtLimit = var0_3:Find("panel/limit")
	arg0_3.rtLimitElite = var0_3:Find("panel/limit_elite")
	arg0_3.rtLimitTips = var0_3:Find("panel/limit_tip")
	arg0_3.btnBack = var0_3:Find("panel/btnBack")
	arg0_3.btnGo = var0_3:Find("panel/start_button")
	arg0_3.toggleMask = var0_3:Find("mask")
	arg0_3.toggleList = var0_3:Find("mask/list")
	arg0_3.toggles = {}

	for iter0_3 = 0, arg0_3.toggleList.childCount - 1 do
		table.insert(arg0_3.toggles, arg0_3.toggleList:Find("item" .. iter0_3 + 1))
	end

	setActive(arg0_3.rtShipTpl, false)
	setActive(arg0_3.rtEmptyTpl, false)
	setActive(arg0_3.toggleMask, false)
end

function var0_0.UpdateMulti(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4.map = arg1_4
	arg0_4.fleets = _(_.values(arg2_4)):chain():filter(function(arg0_5)
		return arg0_5:isRegularFleet()
	end):sort(function(arg0_6, arg1_6)
		return arg0_6.id < arg1_6.id
	end):value()
	arg0_4.selectIds = {
		[FleetType.Normal] = {},
		[FleetType.Submarine] = {}
	}

	for iter0_4, iter1_4 in ipairs(arg3_4 or {}) do
		local var0_4 = arg0_4:getFleetById(iter1_4)

		if var0_4 then
			local var1_4 = var0_4:getFleetType()
			local var2_4 = arg0_4.selectIds[var1_4]

			if #var2_4 < arg0_4:getLimitNums(var1_4) then
				table.insert(var2_4, iter1_4)
			end
		end
	end

	setActive(arg0_4.rtLimitElite, false)
	setActive(arg0_4.rtLimitTips, false)
	setActive(arg0_4.rtLimit, true)
	onButton(arg0_4, arg0_4.btnGo, function()
		arg0_4.onConfirm(arg0_4:getSelectIds())
	end, SFX_UI_WEIGHANCHOR_GO)
	onButton(arg0_4, arg0_4.btnBack, function()
		arg0_4.onCancel()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.transform, function()
		arg0_4.onCancel()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.toggleMask, function()
		arg0_4:hideToggleMask()
	end, SFX_CANCEL)
	arg0_4:clearFleets()
	arg0_4:updateFleets()
	arg0_4:updateLimit()
end

function var0_0.getFleetById(arg0_11, arg1_11)
	return _.detect(arg0_11.fleets, function(arg0_12)
		return arg0_12.id == arg1_11
	end)
end

function var0_0.getLimitNums(arg0_13, arg1_13)
	local var0_13 = 0

	if arg1_13 == FleetType.Normal then
		var0_13 = 4
	elseif arg1_13 == FleetType.Submarine then
		var0_13 = 1
	end

	return var0_13
end

function var0_0.getSelectIds(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in pairs(arg0_14.selectIds) do
		for iter2_14, iter3_14 in ipairs(iter1_14) do
			if iter3_14 > 0 then
				table.insert(var0_14, iter3_14)
			end
		end
	end

	_.sort(var0_14, function(arg0_15, arg1_15)
		return arg0_15 < arg1_15
	end)

	return var0_14
end

function var0_0.updateFleets(arg0_16)
	for iter0_16, iter1_16 in pairs(arg0_16.rtFleets) do
		for iter2_16 = 1, #iter1_16 do
			arg0_16:updateFleet(iter0_16, iter2_16)
		end
	end
end

function var0_0.updateLimit(arg0_17)
	local var0_17 = #_.filter(arg0_17.selectIds[FleetType.Normal], function(arg0_18)
		return arg0_18 > 0
	end)
	local var1_17 = #_.filter(arg0_17.selectIds[FleetType.Submarine], function(arg0_19)
		return arg0_19 > 0
	end)
	local var2_17 = arg0_17:getLimitNums(FleetType.Normal)

	setText(arg0_17.rtLimit:Find("number"), string.format("%d/%d", var0_17, var2_17))

	local var3_17 = arg0_17:getLimitNums(FleetType.Submarine)

	setText(arg0_17.rtLimit:Find("number_sub"), string.format("%d/%d", var1_17, var3_17))
end

function var0_0.selectFleet(arg0_20, arg1_20, arg2_20, arg3_20)
	if fleetId ~= arg3_20 then
		local var0_20 = arg0_20.selectIds[arg1_20]

		if arg3_20 > 0 and table.contains(var0_20, arg3_20) then
			return
		end

		if arg1_20 == FleetType.Normal and arg0_20:getLimitNums(arg1_20) > 0 and arg3_20 == 0 and #_.filter(var0_20, function(arg0_21)
			return arg0_21 > 0
		end) == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_lease_one_ship"))

			return
		end

		local var1_20 = arg0_20:getFleetById(arg3_20)

		if var1_20 then
			if not var1_20:isUnlock() then
				return
			end

			if var1_20:isLegalToFight() ~= true then
				pg.TipsMgr.GetInstance():ShowTips(i18n("level_fleet_not_enough"))

				return
			end
		end

		var0_20[arg2_20] = arg3_20

		arg0_20:updateFleet(arg1_20, arg2_20)
		arg0_20:updateLimit()
	end
end

function var0_0.updateFleet(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.selectIds[arg1_22][arg2_22]
	local var1_22 = arg0_22:getFleetById(var0_22)
	local var2_22 = arg2_22 <= arg0_22:getLimitNums(arg1_22)
	local var3_22 = arg0_22.rtFleets[arg1_22][arg2_22]
	local var4_22 = var3_22:Find("bg/name")
	local var5_22 = var3_22:Find("main")
	local var6_22 = var3_22:Find("vanguard")
	local var7_22 = var3_22:Find("sub")
	local var8_22 = var3_22:Find("btn_select")
	local var9_22 = var3_22:Find("btn_recom")
	local var10_22 = var3_22:Find("btn_clear")
	local var11_22 = var3_22:Find("blank")
	local var12_22 = var3_22:Find("selected")

	setText(var4_22, "")
	setActive(var12_22, false)
	setActive(var8_22, var2_22)
	setActive(var10_22, var2_22)
	setActive(var9_22, false)
	setActive(var11_22, not var2_22)

	if var5_22 then
		setActive(var5_22, var2_22 and var1_22)
	end

	if var6_22 then
		setActive(var6_22, var2_22 and var1_22)
	end

	if var7_22 then
		setActive(var7_22, var2_22 and var1_22)
	end

	if var2_22 then
		if var1_22 then
			setText(var4_22, var1_22.name == "" and Fleet.DEFAULT_NAME[var1_22.id] or var1_22.name)

			if arg1_22 == FleetType.Submarine then
				arg0_22:updateShips(var7_22, var1_22.subShips)
			else
				arg0_22:updateShips(var5_22, var1_22.mainShips)
				arg0_22:updateShips(var6_22, var1_22.vanguardShips)
			end
		end

		onButton(arg0_22, var8_22, function()
			arg0_22.toggleList.position = (var8_22.position + var10_22.position) / 2
			arg0_22.toggleList.anchoredPosition = arg0_22.toggleList.anchoredPosition + Vector2(-arg0_22.toggleList.rect.width / 2, -var8_22.rect.height / 2)

			arg0_22:showToggleMask(arg1_22, function(arg0_24)
				arg0_22:hideToggleMask()
				arg0_22:selectFleet(arg1_22, arg2_22, arg0_24)
			end)
		end, SFX_UI_CLICK)
		onButton(arg0_22, var10_22, function()
			arg0_22:selectFleet(arg1_22, arg2_22, 0)
		end, SFX_UI_CLICK)
	end
end

function var0_0.updateShips(arg0_26, arg1_26, arg2_26)
	local var0_26 = UIItemList.New(arg1_26, arg0_26.rtShipTpl)

	var0_26:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = getProxy(BayProxy):getShipById(arg2_26[arg1_27 + 1])

			updateShip(arg2_27, var0_27)

			local var1_27 = arg2_27:Find("icon_bg/energy")
			local var2_27 = var0_27:getEnergeConfig()

			if var2_27 and var2_27.id <= 2 then
				setActive(var1_27, true)
				GetImageSpriteFromAtlasAsync("energy", var2_27.icon, var1_27)
			else
				setActive(var1_27, false)
			end
		end
	end)
	var0_26:align(#arg2_26)
end

function var0_0.showToggleMask(arg0_28, arg1_28, arg2_28)
	setActive(arg0_28.toggleMask, true)

	local var0_28 = _.filter(arg0_28.fleets, function(arg0_29)
		return arg0_29:getFleetType() == arg1_28
	end)

	for iter0_28, iter1_28 in ipairs(arg0_28.toggles) do
		local var1_28 = var0_28[iter0_28]

		setActive(iter1_28, var1_28)

		if var1_28 then
			local var2_28, var3_28 = var1_28:isUnlock()
			local var4_28 = iter1_28:Find("lock")

			setButtonEnabled(iter1_28, var2_28)
			setActive(var4_28, not var2_28)

			if var2_28 then
				local var5_28 = table.contains(arg0_28.selectIds[arg1_28], var1_28.id)

				setActive(iter1_28:Find("selected"), var5_28)
				setActive(iter1_28:Find("text"), not var5_28)
				setActive(iter1_28:Find("text_selected"), var5_28)
				onButton(arg0_28, iter1_28, function()
					arg2_28(var1_28.id)
				end, SFX_UI_TAG)
			else
				onButton(arg0_28, var4_28, function()
					pg.TipsMgr.GetInstance():ShowTips(var3_28)
				end, SFX_UI_CLICK)
			end
		end
	end
end

function var0_0.hideToggleMask(arg0_32)
	setActive(arg0_32.toggleMask, false)
end

function var0_0.clearFleets(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33.rtFleets) do
		_.each(iter1_33, function(arg0_34)
			arg0_33:clearFleet(arg0_34)
		end)
	end
end

function var0_0.clearFleet(arg0_35, arg1_35)
	local var0_35 = arg1_35:Find("main")
	local var1_35 = arg1_35:Find("vanguard")
	local var2_35 = arg1_35:Find("sub")

	if var0_35 then
		removeAllChildren(var0_35)
	end

	if var1_35 then
		removeAllChildren(var1_35)
	end

	if var2_35 then
		removeAllChildren(var2_35)
	end
end

return var0_0
