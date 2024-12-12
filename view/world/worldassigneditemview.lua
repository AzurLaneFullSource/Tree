local var0_0 = class("WorldAssignedItemView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "StoreHouseItemAssignedView"
end

function var0_0.OnInit(arg0_2)
	local var0_2 = arg0_2._tf:Find("operate")

	arg0_2.ulist = UIItemList.New(var0_2:Find("got/bottom/list"), var0_2:Find("got/bottom/list/tpl"))
	arg0_2.confirmBtn = var0_2:Find("action/confirm")

	setText(arg0_2.confirmBtn, i18n("text_confirm"))

	arg0_2.cancelBtn = var0_2:Find("action/cancel")

	setText(arg0_2.cancelBtn, i18n("text_cancel"))

	arg0_2.rightArr = var0_2:Find("calc/value_bg/add")
	arg0_2.leftArr = var0_2:Find("calc/value_bg/mius")
	arg0_2.maxBtn = var0_2:Find("calc/max")
	arg0_2.valueText = var0_2:Find("calc/value_bg/Text")
	arg0_2.itemTF = var0_2:Find("item/left/IconTpl")
	arg0_2.nameTF = arg0_2:findTF("item/display_panel/name_container/name")
	arg0_2.descTF = arg0_2:findTF("item/display_panel/desc/Text")

	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.cancelBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)
	pressPersistTrigger(arg0_2.rightArr, 0.5, function(arg0_5)
		if not arg0_2.itemVO then
			arg0_5()

			return
		end

		arg0_2.count = math.min(arg0_2.count + 1, arg0_2.itemVO.count)

		arg0_2:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_2.leftArr, 0.5, function(arg0_6)
		if not arg0_2.itemVO then
			arg0_6()

			return
		end

		arg0_2.count = math.max(arg0_2.count - 1, 1)

		arg0_2:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_2, arg0_2.maxBtn, function()
		if not arg0_2.itemVO then
			return
		end

		arg0_2.count = arg0_2.itemVO.count

		arg0_2:updateValue()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.confirmBtn, function()
		if not arg0_2.selectedIndex or not arg0_2.itemVO or arg0_2.count <= 0 then
			return
		end

		arg0_2:emit(WorldInventoryMediator.OnUseItem, arg0_2.itemVO.id, arg0_2.count, arg0_2.itemVO:getConfig("usage_arg")[arg0_2.selectedIndex])
		arg0_2:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_9)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)
	setActive(arg0_9._tf, true)
end

function var0_0.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, arg0_10._parentTf)
	setActive(arg0_10._tf, false)
end

function var0_0.updateValue(arg0_11)
	setText(arg0_11.valueText, arg0_11.count)
	arg0_11.ulist:each(function(arg0_12, arg1_12)
		if not isActive(arg1_12) then
			return
		end

		setText(arg1_12:Find("item/bg/icon_bg/count"), arg0_11.count)
	end)
end

function var0_0.update(arg0_13, arg1_13)
	arg0_13.count = 1
	arg0_13.selectedIndex = nil
	arg0_13.selectedItem = nil
	arg0_13.itemVO = arg1_13
	arg0_13.displayDrops = underscore.map(arg1_13:getConfig("usage_arg"), function(arg0_14)
		return {
			type = arg0_14[1],
			id = arg0_14[2],
			count = arg0_14[3]
		}
	end)

	arg0_13.ulist:make(function(arg0_15, arg1_15, arg2_15)
		arg1_15 = arg1_15 + 1

		if arg0_15 == UIItemList.EventUpdate then
			updateDrop(arg2_15:Find("item/bg"), arg0_13.displayDrops[arg1_15])

			local var0_15 = arg2_15:Find("item/bg/icon_bg/count")

			onToggle(arg0_13, arg2_15, function(arg0_16)
				if arg0_16 then
					arg0_13.selectedIndex = arg1_15
					arg0_13.selectedItem = arg2_15
				elseif arg0_13.selectedIndex == arg1_15 then
					arg0_13.selectedIndex = nil
					arg0_13.selectedItem = nil
				end
			end, SFX_PANEL)
			setScrollText(arg2_15:Find("name_bg/Text"), arg0_13.displayDrops[arg1_15]:getConfig("name"))

			arg0_13.selectedItem = arg0_13.selectedItem or arg2_15
		end
	end)
	arg0_13.ulist:align(#arg0_13.displayDrops)
	triggerToggle(arg0_13.selectedItem, true)
	arg0_13:updateValue()

	local var0_13 = {
		type = arg1_13.type,
		id = arg1_13.id,
		count = arg1_13.count
	}

	updateDrop(arg0_13.itemTF:Find("left/IconTpl"), setmetatable({
		count = 0
	}, {
		__index = var0_13
	}))
	UpdateOwnDisplay(arg0_13.itemTF:Find("left/own"), var0_13)
	setText(arg0_13.nameTF, arg1_13:getConfig("name"))
	setText(arg0_13.descTF, arg1_13:getConfig("display"))
end

return var0_0
