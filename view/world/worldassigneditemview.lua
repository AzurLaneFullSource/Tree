local var0 = class("WorldAssignedItemView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "StoreHouseItemAssignedView"
end

function var0.OnInit(arg0)
	local var0 = arg0._tf:Find("operate")

	arg0.ulist = UIItemList.New(var0:Find("got/bottom/list"), var0:Find("got/bottom/list/tpl"))
	arg0.confirmBtn = var0:Find("action/confirm")

	setText(arg0.confirmBtn, i18n("text_confirm"))

	arg0.cancelBtn = var0:Find("action/cancel")

	setText(arg0.cancelBtn, i18n("text_cancel"))

	arg0.rightArr = var0:Find("calc/value_bg/add")
	arg0.leftArr = var0:Find("calc/value_bg/mius")
	arg0.maxBtn = var0:Find("calc/max")
	arg0.valueText = var0:Find("calc/value_bg/Text")
	arg0.itemTF = var0:Find("item/left/IconTpl")
	arg0.nameTF = arg0:findTF("item/display_panel/name_container/name")
	arg0.descTF = arg0:findTF("item/display_panel/desc/Text")

	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	pressPersistTrigger(arg0.rightArr, 0.5, function(arg0)
		if not arg0.itemVO then
			arg0()

			return
		end

		arg0.count = math.min(arg0.count + 1, arg0.itemVO.count)

		arg0:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0.leftArr, 0.5, function(arg0)
		if not arg0.itemVO then
			arg0()

			return
		end

		arg0.count = math.max(arg0.count - 1, 1)

		arg0:updateValue()
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0, arg0.maxBtn, function()
		if not arg0.itemVO then
			return
		end

		arg0.count = arg0.itemVO.count

		arg0:updateValue()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if not arg0.selectedIndex or not arg0.itemVO or arg0.count <= 0 then
			return
		end

		arg0:emit(WorldInventoryMediator.OnUseItem, arg0.itemVO.id, arg0.count, arg0.itemVO:getConfig("usage_arg")[arg0.selectedIndex])
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setActive(arg0._tf, true)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)
end

function var0.updateValue(arg0)
	setText(arg0.valueText, arg0.count)
	arg0.ulist:each(function(arg0, arg1)
		if not isActive(arg1) then
			return
		end

		setText(arg1:Find("item/bg/icon_bg/count"), arg0.count)
	end)
end

function var0.update(arg0, arg1)
	arg0.count = 1
	arg0.selectedIndex = nil
	arg0.selectedItem = nil
	arg0.itemVO = arg1
	arg0.displayDrops = underscore.map(arg1:getConfig("usage_arg"), function(arg0)
		return {
			type = arg0[1],
			id = arg0[2],
			count = arg0[3]
		}
	end)

	arg0.ulist:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			updateDrop(arg2:Find("item/bg"), arg0.displayDrops[arg1])

			local var0 = arg2:Find("item/bg/icon_bg/count")

			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.selectedIndex = arg1
					arg0.selectedItem = arg2
				end
			end, SFX_PANEL)
			setScrollText(arg2:Find("name_bg/Text"), arg0.displayDrops[arg1]:getConfig("name"))

			arg0.selectedItem = arg0.selectedItem or arg2
		end
	end)
	arg0.ulist:align(#arg0.displayDrops)
	triggerToggle(arg0.selectedItem, true)
	arg0:updateValue()

	local var0 = {
		type = arg1.type,
		id = arg1.id,
		count = arg1.count
	}

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
