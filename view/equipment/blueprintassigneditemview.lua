local var0 = class("BlueprintAssignedItemView", import(".AssignedItemView"))

function var0.getUIName(arg0)
	return "BlueprintItemAssignedView"
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.countOver = arg0._tf:Find("operate/calc/value_bg/over_count")

	setText(arg0.countOver, i18n("blueprint_select_overflow"))
	onButton(arg0, arg0.maxBtn, function()
		if not arg0.itemVO or not arg0.selectedIndex then
			return
		end

		local var0 = arg0.displayDrops[arg0.selectedIndex]
		local var1 = arg0.count * var0.count
		local var2 = arg0:GetBlueprintNeed(var0.id)

		if var1 < var2 then
			arg0.count = math.floor((var2 + var0.count - 1) / var0.count)
			arg0.count = math.min(arg0.count, arg0.itemVO.count)
		else
			arg0.count = arg0.itemVO.count
		end

		arg0:updateValue()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if not arg0.selectedIndex or not arg0.itemVO or arg0.count <= 0 then
			return
		end

		local var0 = arg0.displayDrops[arg0.selectedIndex]
		local var1 = arg0.count * var0.count
		local var2 = arg0:GetBlueprintNeed(var0.id)
		local var3 = {}

		if not arg0.isAllNeedZero and var2 < var1 then
			table.insert(var3, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("blueprint_select_overflow_tip", var0:getConfig("name"), var1 - var2),
					onYes = arg0
				})
			end)
		end

		seriesAsync(var3, function()
			arg0:emit(EquipmentMediator.ON_USE_ITEM, arg0.itemVO.id, arg0.count, arg0.itemVO:getConfig("usage_arg")[arg0.selectedIndex])
			arg0:Hide()
		end)
	end, SFX_PANEL)

	arg0.toggleSwitch = arg0._tf:Find("operate/got/top/switch_btn")

	setText(arg0.toggleSwitch:Find("Text_off"), i18n("show_design_demand_count"))
	setText(arg0.toggleSwitch:Find("Text_on"), i18n("show_fate_demand_count"))
	onToggle(arg0, arg0.toggleSwitch, function(arg0)
		arg0.isSwitch = arg0

		arg0:updateValue()
	end, SFX_PANEL)
end

function var0.GetBlueprintNeed(arg0, arg1)
	arg0.technologyProxy = arg0.technologyProxy or getProxy(TechnologyProxy)

	local var0 = arg0.technologyProxy:getBluePrintById(arg0.technologyProxy:GetBlueprint4Item(arg1))

	arg0.bagProxy = arg0.bagProxy or getProxy(BagProxy)

	return math.max(var0:getUseageMaxItem() + (arg0.isSwitch and var0:getFateMaxLeftOver() or 0) - arg0.bagProxy:getItemCountById(var0:getItemId()), 0)
end

function var0.checkBlueprintIsUnlock(arg0, arg1)
	arg0.technologyProxy = arg0.technologyProxy or getProxy(TechnologyProxy)

	return arg0.technologyProxy:getBluePrintById(arg0.technologyProxy:GetBlueprint4Item(arg1)):isUnlock()
end

function var0.updateValue(arg0)
	arg0.isAllNeedZero = underscore.all(arg0.displayDrops, function(arg0)
		return arg0:GetBlueprintNeed(arg0.id) == 0
	end)

	arg0:updateCountText()
	arg0.ulist:each(function(arg0, arg1)
		if not isActive(arg1) then
			return
		end

		arg0 = arg0 + 1

		local var0 = arg0.displayDrops[arg0]
		local var1 = arg0.count * var0.count
		local var2 = arg0:GetBlueprintNeed(var0.id)

		setText(arg1:Find("item/icon_bg/count"), setColorStr(var1, not arg0.isAllNeedZero and var2 < var1 and "#FF5A5A" or "#FFEC6E") .. "/" .. var2)
	end)
end

function var0.updateCountText(arg0)
	local var0 = arg0.displayDrops[arg0.selectedIndex]
	local var1 = arg0.count * var0.count
	local var2 = arg0:GetBlueprintNeed(var0.id)

	setText(arg0.valueText, not arg0.isAllNeedZero and var2 < var1 and setColorStr(arg0.count, "#FF5A5A") or arg0.count)
	setActive(arg0.countOver, not arg0.isAllNeedZero and var2 < var1)
end

function var0.update(arg0, arg1)
	arg0.count = 1
	arg0.selectedIndex = nil
	arg0.selectedItem = nil
	arg0.isSwitch = false
	arg0.itemVO = arg1
	arg0.displayDrops = underscore.map(arg1:getConfig("display_icon"), function(arg0)
		return {
			type = arg0[1],
			id = arg0[2],
			count = arg0[3]
		}
	end)

	arg0.ulist:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			updateDrop(arg2:Find("item"), arg0.displayDrops[arg1])
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.selectedIndex = arg1
					arg0.selectedItem = arg2

					arg0:updateCountText()
				end
			end, SFX_PANEL)
			triggerToggle(arg2, arg1 == 1)
			setScrollText(arg2:Find("name_bg/Text"), arg0.displayDrops[arg1]:getConfig("name"))

			arg0.selectedItem = arg0.selectedItem or arg2

			setText(arg2:Find("item/tip/Text"), i18n("tech_character_get"))
			setActive(arg2:Find("item/tip"), arg0:checkBlueprintIsUnlock(arg0.displayDrops[arg1].id))
		end
	end)
	arg0.ulist:align(#arg0.displayDrops)
	triggerToggle(arg0.selectedItem, true)
	triggerToggle(arg0.toggleSwitch, true)

	local var0 = Drop.New({
		type = DROP_TYPE_ITEM,
		id = arg1.id,
		count = arg1.count
	})

	updateDrop(arg0.itemTF:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = var0
	}))
	UpdateOwnDisplay(arg0.itemTF:Find("left/own"), var0)
	setText(arg0.nameTF, arg1:getConfig("name"))
	setText(arg0.descTF, arg1:getConfig("display"))
end

return var0
