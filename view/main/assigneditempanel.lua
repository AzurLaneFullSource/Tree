local var0_0 = class("AssignedItemPanel")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = tf(arg1_1)
	arg0_1.isInited = false
	arg0_1.selectedVO = nil
	arg0_1.count = 1
	arg0_1.view = arg2_1
end

function var0_0.show(arg0_2)
	setActive(arg0_2._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
end

function var0_0.hide(arg0_3)
	setActive(arg0_3._tf, false)

	arg0_3.selectedVO = nil
	arg0_3.itemVO = nil
	arg0_3.count = 1

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_3._tf, arg0_3.view._tf)

	if arg0_3.selectedItem then
		triggerToggle(arg0_3.selectedItem, false)
	end

	arg0_3.selectedItem = nil
end

function var0_0.init(arg0_4)
	arg0_4.isInited = true
	arg0_4.ulist = UIItemList.New(arg0_4._tf:Find("got/bottom/scroll/list"), arg0_4._tf:Find("got/bottom/scroll/list/tpl"))
	arg0_4.confirmBtn = arg0_4._tf:Find("calc/confirm")
	arg0_4.rightArr = arg0_4._tf:Find("calc/value_bg/add")
	arg0_4.leftArr = arg0_4._tf:Find("calc/value_bg/mius")
	arg0_4.maxBtn = arg0_4._tf:Find("calc/max")
	arg0_4.valueText = arg0_4._tf:Find("calc/value_bg/Text")
	arg0_4.itemTF = arg0_4._tf:Find("item/bottom/item")
	arg0_4.nameTF = arg0_4._tf:Find("item/bottom/name_bg/name")
	arg0_4.descTF = arg0_4._tf:Find("item/bottom/desc")

	onButton(arg0_4, arg0_4._tf, function()
		arg0_4:hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.rightArr, function()
		if not arg0_4.itemVO then
			return
		end

		arg0_4.count = math.min(arg0_4.count + 1, arg0_4.itemVO.count)

		arg0_4:updateValue()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.leftArr, function()
		if not arg0_4.itemVO then
			return
		end

		arg0_4.count = math.max(arg0_4.count - 1, 1)

		arg0_4:updateValue()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.maxBtn, function()
		if not arg0_4.itemVO then
			return
		end

		arg0_4.count = arg0_4.itemVO.count

		arg0_4:updateValue()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.confirmBtn, function()
		if not arg0_4.selectedVO or not arg0_4.itemVO or arg0_4.count <= 0 then
			return
		end

		arg0_4.view:emit(EquipmentMediator.ON_USE_ITEM, arg0_4.itemVO.id, arg0_4.count, arg0_4.selectedVO)
		arg0_4:hide()
	end, SFX_PANEL)
end

function var0_0.updateValue(arg0_10)
	setText(arg0_10.valueText, arg0_10.count)
	arg0_10.ulist:each(function(arg0_11, arg1_11)
		setText(arg1_11:Find("item/bg/icon_bg/count"), arg0_10.count)
	end)
end

function var0_0.update(arg0_12, arg1_12)
	arg0_12.itemVO = arg1_12

	if not arg0_12.isInited then
		arg0_12:init()
	end

	local var0_12 = arg1_12:getConfig("display_icon")

	arg0_12.selectedItem = nil

	arg0_12.ulist:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = var0_12[arg1_13 + 1]
			local var1_13 = {
				type = var0_13[1],
				id = var0_13[2],
				count = var0_13[3]
			}

			updateDrop(arg2_13:Find("item/bg"), var1_13)

			local var2_13 = arg2_13:Find("item/bg/icon_bg/count")

			onToggle(arg0_12, arg2_13, function(arg0_14)
				if arg0_14 then
					arg0_12.selectedVO = arg1_12:getConfig("usage_arg")[arg1_13 + 1]

					setText(var2_13, arg0_12.count * var0_13[3])

					arg0_12.selectedItem = arg2_13
				end
			end, SFX_PANEL)
			setScrollText(arg2_13:Find("name_bg/Text"), var1_13:getConfig("name"))
		end
	end)
	arg0_12.ulist:align(#var0_12)
	arg0_12:updateValue()
	updateDrop(arg0_12.itemTF:Find("bg"), {
		type = DROP_TYPE_ITEM,
		id = arg1_12.id,
		count = arg1_12.count
	})
	setText(arg0_12.nameTF, arg1_12:getConfig("name"))
	setText(arg0_12.descTF, arg1_12:getConfig("display"))
end

function var0_0.dispose(arg0_15)
	pg.DelegateInfo.Dispose(arg0_15)
end

return var0_0
