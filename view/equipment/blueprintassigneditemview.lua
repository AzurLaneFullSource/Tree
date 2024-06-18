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

		if not arg0_2.isAllNeedZero and var2_4 < var1_4 then
			table.insert(var3_4, function(arg0_5)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("blueprint_select_overflow_tip", var0_4:getConfig("name"), var1_4 - var2_4),
					onYes = arg0_5
				})
			end)
		end

		seriesAsync(var3_4, function()
			arg0_2:emit(EquipmentMediator.ON_USE_ITEM, arg0_2.itemVO.id, arg0_2.count, arg0_2.itemVO:getConfig("usage_arg")[arg0_2.selectedIndex])
			arg0_2:Hide()
		end)
	end, SFX_PANEL)

	arg0_2.toggleSwitch = arg0_2._tf:Find("operate/got/top/switch_btn")

	setText(arg0_2.toggleSwitch:Find("Text_off"), i18n("show_design_demand_count"))
	setText(arg0_2.toggleSwitch:Find("Text_on"), i18n("show_fate_demand_count"))
	onToggle(arg0_2, arg0_2.toggleSwitch, function(arg0_7)
		arg0_2.isSwitch = arg0_7

		arg0_2:updateValue()
	end, SFX_PANEL)
end

function var0_0.GetBlueprintNeed(arg0_8, arg1_8)
	arg0_8.technologyProxy = arg0_8.technologyProxy or getProxy(TechnologyProxy)

	local var0_8 = arg0_8.technologyProxy:getBluePrintById(arg0_8.technologyProxy:GetBlueprint4Item(arg1_8))

	arg0_8.bagProxy = arg0_8.bagProxy or getProxy(BagProxy)

	return math.max(var0_8:getUseageMaxItem() + (arg0_8.isSwitch and var0_8:getFateMaxLeftOver() or 0) - arg0_8.bagProxy:getItemCountById(var0_8:getItemId()), 0)
end

function var0_0.checkBlueprintIsUnlock(arg0_9, arg1_9)
	arg0_9.technologyProxy = arg0_9.technologyProxy or getProxy(TechnologyProxy)

	return arg0_9.technologyProxy:getBluePrintById(arg0_9.technologyProxy:GetBlueprint4Item(arg1_9)):isUnlock()
end

function var0_0.updateValue(arg0_10)
	arg0_10.isAllNeedZero = underscore.all(arg0_10.displayDrops, function(arg0_11)
		return arg0_10:GetBlueprintNeed(arg0_11.id) == 0
	end)

	arg0_10:updateCountText()
	arg0_10.ulist:each(function(arg0_12, arg1_12)
		if not isActive(arg1_12) then
			return
		end

		arg0_12 = arg0_12 + 1

		local var0_12 = arg0_10.displayDrops[arg0_12]
		local var1_12 = arg0_10.count * var0_12.count
		local var2_12 = arg0_10:GetBlueprintNeed(var0_12.id)

		setText(arg1_12:Find("item/icon_bg/count"), setColorStr(var1_12, not arg0_10.isAllNeedZero and var2_12 < var1_12 and "#FF5A5A" or "#FFEC6E") .. "/" .. var2_12)
	end)
end

function var0_0.updateCountText(arg0_13)
	local var0_13 = arg0_13.displayDrops[arg0_13.selectedIndex]
	local var1_13 = arg0_13.count * var0_13.count
	local var2_13 = arg0_13:GetBlueprintNeed(var0_13.id)

	setText(arg0_13.valueText, not arg0_13.isAllNeedZero and var2_13 < var1_13 and setColorStr(arg0_13.count, "#FF5A5A") or arg0_13.count)
	setActive(arg0_13.countOver, not arg0_13.isAllNeedZero and var2_13 < var1_13)
end

function var0_0.update(arg0_14, arg1_14)
	arg0_14.count = 1
	arg0_14.selectedIndex = nil
	arg0_14.selectedItem = nil
	arg0_14.isSwitch = false
	arg0_14.itemVO = arg1_14
	arg0_14.displayDrops = underscore.map(arg1_14:getConfig("display_icon"), function(arg0_15)
		return {
			type = arg0_15[1],
			id = arg0_15[2],
			count = arg0_15[3]
		}
	end)

	arg0_14.ulist:make(function(arg0_16, arg1_16, arg2_16)
		arg1_16 = arg1_16 + 1

		if arg0_16 == UIItemList.EventUpdate then
			updateDrop(arg2_16:Find("item"), arg0_14.displayDrops[arg1_16])
			onToggle(arg0_14, arg2_16, function(arg0_17)
				if arg0_17 then
					arg0_14.selectedIndex = arg1_16
					arg0_14.selectedItem = arg2_16

					arg0_14:updateCountText()
				end
			end, SFX_PANEL)
			triggerToggle(arg2_16, arg1_16 == 1)
			setScrollText(arg2_16:Find("name_bg/Text"), arg0_14.displayDrops[arg1_16]:getConfig("name"))

			arg0_14.selectedItem = arg0_14.selectedItem or arg2_16

			setText(arg2_16:Find("item/tip/Text"), i18n("tech_character_get"))
			setActive(arg2_16:Find("item/tip"), arg0_14:checkBlueprintIsUnlock(arg0_14.displayDrops[arg1_16].id))
		end
	end)
	arg0_14.ulist:align(#arg0_14.displayDrops)
	triggerToggle(arg0_14.selectedItem, true)
	triggerToggle(arg0_14.toggleSwitch, true)

	local var0_14 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = arg1_14.id,
		count = arg1_14.count
	})

	updateDrop(arg0_14.itemTF:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = var0_14
	}))
	UpdateOwnDisplay(arg0_14.itemTF:Find("left/own"), var0_14)
	setText(arg0_14.nameTF, arg1_14:getConfig("name"))
	setText(arg0_14.descTF, arg1_14:getConfig("display"))
end

return var0_0
