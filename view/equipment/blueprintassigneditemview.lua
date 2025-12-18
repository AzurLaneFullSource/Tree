local var0_0 = class("BlueprintAssignedItemView", import(".AssignedItemView"))

function var0_0.getUIName(arg0_1)
	return "BlueprintItemAssignedView"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)

	arg0_2.countOver = arg0_2._tf:Find("operate/calc/value_bg/over_count")

	setText(arg0_2.countOver, i18n("blueprint_select_overflow"))
	onButton(arg0_2, arg0_2.maxBtn, function()
		if not arg0_2.itemVO or not arg0_2.selectedIndex then
			return
		end

		local var0_3 = arg0_2.displayDrops[arg0_2.selectedIndex]
		local var1_3 = arg0_2.count * var0_3.count
		local var2_3 = arg0_2:GetBlueprintNeed(var0_3.id)

		if var1_3 < var2_3 then
			arg0_2.count = math.floor((var2_3 + var0_3.count - 1) / var0_3.count)
			arg0_2.count = math.min(arg0_2.count, arg0_2.itemVO.count)
		else
			arg0_2.count = arg0_2.itemVO.count
		end

		arg0_2:updateValue()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.confirmBtn, function()
		if not arg0_2.selectedIndex or not arg0_2.itemVO or arg0_2.count <= 0 then
			return
		end

		local var0_4 = arg0_2.displayDrops[arg0_2.selectedIndex]
		local var1_4 = arg0_2.count * var0_4.count
		local var2_4 = arg0_2:GetBlueprintNeed(var0_4.id)
		local var3_4 = {}

		if arg0_2.isSwitch and not arg0_2:checkBlueprintIsFate(var0_4.id) then
			if var1_4 <= var2_4 then
				table.insert(var3_4, function(arg0_5)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("blueprint_exchange_fate_unlock"),
						onYes = arg0_5
					})
				end)
			else
				table.insert(var3_4, function(arg0_6)
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						content = i18n("blueprint_exchange_fate_unlock_over", var0_4:getConfig("name"), var1_4 - var2_4),
						onYes = arg0_6
					})
				end)
			end
		elseif not arg0_2.isAllNeedZero and var2_4 < var1_4 then
			table.insert(var3_4, function(arg0_7)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("blueprint_select_overflow_tip", var0_4:getConfig("name"), var1_4 - var2_4),
					onYes = arg0_7
				})
			end)
		end

		seriesAsync(var3_4, function()
			arg0_2:emit(EquipmentMediator.ON_USE_ITEM, arg0_2.itemVO.id, arg0_2.count, arg0_2.itemVO:getConfig("usage_arg")[arg0_2.selectedIndex])
			arg0_2:Hide()
		end)
	end, SFX_PANEL)

	arg0_2.toggleSwitch = arg0_2._tf:Find("operate/got/top/switch_btn")

	setText(arg0_2.toggleSwitch:Find("Text_off"), i18n("show_fate_demand_count"))
	setText(arg0_2.toggleSwitch:Find("Text_on"), i18n("show_design_demand_count"))
	onToggle(arg0_2, arg0_2.toggleSwitch, function(arg0_9)
		arg0_2.isSwitch = arg0_9

		arg0_2:updateValue()
	end, SFX_PANEL)
	setText(arg0_2._tf:Find("operate/got/top/info/Text"), i18n("fate_unlock_icon_desc"))
end

function var0_0.GetBlueprintNeed(arg0_10, arg1_10)
	arg0_10.technologyProxy = arg0_10.technologyProxy or getProxy(TechnologyProxy)

	local var0_10 = arg0_10.technologyProxy:getBluePrintById(arg0_10.technologyProxy:GetBlueprint4Item(arg1_10))

	arg0_10.bagProxy = arg0_10.bagProxy or getProxy(BagProxy)

	warning(arg0_10.isSwitch)

	return math.max(var0_10:getUseageMaxItem() + (arg0_10.isSwitch and var0_10:getFateMaxLeftOver() or 0) - arg0_10.bagProxy:getItemCountById(var0_10:getItemId()), 0)
end

function var0_0.checkBlueprintIsUnlock(arg0_11, arg1_11)
	arg0_11.technologyProxy = arg0_11.technologyProxy or getProxy(TechnologyProxy)

	return arg0_11.technologyProxy:getBluePrintById(arg0_11.technologyProxy:GetBlueprint4Item(arg1_11)):isUnlock()
end

function var0_0.checkBlueprintIsFate(arg0_12, arg1_12)
	arg0_12.technologyProxy = arg0_12.technologyProxy or getProxy(TechnologyProxy)

	return arg0_12.technologyProxy:getBluePrintById(arg0_12.technologyProxy:GetBlueprint4Item(arg1_12)):IsFate()
end

function var0_0.updateValue(arg0_13)
	arg0_13.isAllNeedZero = underscore.all(arg0_13.displayDrops, function(arg0_14)
		return arg0_13:GetBlueprintNeed(arg0_14.id) == 0
	end)

	arg0_13:updateCountText()
	arg0_13.ulist:each(function(arg0_15, arg1_15)
		if not isActive(arg1_15) then
			return
		end

		arg0_15 = arg0_15 + 1

		local var0_15 = arg0_13.displayDrops[arg0_15]
		local var1_15 = arg0_13.count * var0_15.count
		local var2_15 = arg0_13:GetBlueprintNeed(var0_15.id)

		setText(arg1_15:Find("item/icon_bg/count"), setColorStr(var1_15, not arg0_13.isAllNeedZero and var2_15 < var1_15 and "#FF5A5A" or "#FFEC6E") .. "/" .. var2_15)
	end)
end

function var0_0.updateCountText(arg0_16)
	local var0_16 = arg0_16.displayDrops[arg0_16.selectedIndex]
	local var1_16 = arg0_16.count * var0_16.count
	local var2_16 = arg0_16:GetBlueprintNeed(var0_16.id)

	setText(arg0_16.valueText, not arg0_16.isAllNeedZero and var2_16 < var1_16 and setColorStr(arg0_16.count, "#FF5A5A") or arg0_16.count)
	setActive(arg0_16.countOver, not arg0_16.isAllNeedZero and var2_16 < var1_16)
end

function var0_0.update(arg0_17, arg1_17)
	arg0_17.count = 1
	arg0_17.selectedIndex = nil
	arg0_17.selectedItem = nil
	arg0_17.isSwitch = false
	arg0_17.itemVO = arg1_17
	arg0_17.displayDrops = underscore.map(arg1_17:getConfig("display_icon"), function(arg0_18)
		return {
			type = arg0_18[1],
			id = arg0_18[2],
			count = arg0_18[3]
		}
	end)

	arg0_17.ulist:make(function(arg0_19, arg1_19, arg2_19)
		arg1_19 = arg1_19 + 1

		if arg0_19 == UIItemList.EventUpdate then
			updateDrop(arg2_19:Find("item"), arg0_17.displayDrops[arg1_19])
			onToggle(arg0_17, arg2_19, function(arg0_20)
				if arg0_20 then
					arg0_17.selectedIndex = arg1_19
					arg0_17.selectedItem = arg2_19

					arg0_17:updateCountText()
				end
			end, SFX_PANEL)
			triggerToggle(arg2_19, arg1_19 == 1)
			setScrollText(arg2_19:Find("name_bg/Text"), arg0_17.displayDrops[arg1_19]:getConfig("name"))

			arg0_17.selectedItem = arg0_17.selectedItem or arg2_19

			setText(arg2_19:Find("item/tip/Text"), i18n("tech_character_get"))
			setActive(arg2_19:Find("item/tip"), arg0_17:checkBlueprintIsUnlock(arg0_17.displayDrops[arg1_19].id))
			setActive(arg2_19:Find("fateFlag"), arg0_17:checkBlueprintIsFate(arg0_17.displayDrops[arg1_19].id))
		end
	end)
	arg0_17.ulist:align(#arg0_17.displayDrops)
	triggerToggle(arg0_17.selectedItem, true)
	triggerToggle(arg0_17.toggleSwitch, false)

	local var0_17 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = arg1_17.id,
		count = arg1_17.count
	})

	updateDrop(arg0_17.itemTF:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = var0_17
	}))
	UpdateOwnDisplay(arg0_17.itemTF:Find("left/own"), var0_17)
	setText(arg0_17.nameTF, arg1_17:getConfig("name"))
	setText(arg0_17.descTF, arg1_17:getConfig("display"))
end

return var0_0
