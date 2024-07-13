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

function var0_0.findTF(arg0_2, arg1_2)
	return findTF(arg0_2._tf, arg1_2)
end

function var0_0.show(arg0_3)
	setActive(arg0_3._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.hide(arg0_4)
	setActive(arg0_4._tf, false)

	arg0_4.selectedVO = nil
	arg0_4.itemVO = nil
	arg0_4.count = 1

	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf, arg0_4.view._tf)

	if arg0_4.selectedItem then
		triggerToggle(arg0_4.selectedItem, false)
	end

	arg0_4.selectedItem = nil
end

function var0_0.init(arg0_5)
	arg0_5.isInited = true
	arg0_5.ulist = UIItemList.New(arg0_5:findTF("got/bottom/scroll/list"), arg0_5:findTF("got/bottom/scroll/list/tpl"))
	arg0_5.confirmBtn = arg0_5:findTF("calc/confirm")
	arg0_5.rightArr = arg0_5:findTF("calc/value_bg/add")
	arg0_5.leftArr = arg0_5:findTF("calc/value_bg/mius")
	arg0_5.maxBtn = arg0_5:findTF("calc/max")
	arg0_5.valueText = arg0_5:findTF("calc/value_bg/Text")
	arg0_5.itemTF = arg0_5:findTF("item/bottom/item")
	arg0_5.nameTF = arg0_5:findTF("item/bottom/name_bg/name")
	arg0_5.descTF = arg0_5:findTF("item/bottom/desc")

	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.rightArr, function()
		if not arg0_5.itemVO then
			return
		end

		arg0_5.count = math.min(arg0_5.count + 1, arg0_5.itemVO.count)

		arg0_5:updateValue()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.leftArr, function()
		if not arg0_5.itemVO then
			return
		end

		arg0_5.count = math.max(arg0_5.count - 1, 1)

		arg0_5:updateValue()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.maxBtn, function()
		if not arg0_5.itemVO then
			return
		end

		arg0_5.count = arg0_5.itemVO.count

		arg0_5:updateValue()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.confirmBtn, function()
		if not arg0_5.selectedVO or not arg0_5.itemVO or arg0_5.count <= 0 then
			return
		end

		arg0_5.view:emit(EquipmentMediator.ON_USE_ITEM, arg0_5.itemVO.id, arg0_5.count, arg0_5.selectedVO)
		arg0_5:hide()
	end, SFX_PANEL)
end

function var0_0.updateValue(arg0_11)
	setText(arg0_11.valueText, arg0_11.count)
	arg0_11.ulist:each(function(arg0_12, arg1_12)
		setText(arg1_12:Find("item/bg/icon_bg/count"), arg0_11.count)
	end)
end

function var0_0.update(arg0_13, arg1_13)
	arg0_13.itemVO = arg1_13

	if not arg0_13.isInited then
		arg0_13:init()
	end

	local var0_13 = arg1_13:getConfig("display_icon")

	arg0_13.selectedItem = nil

	arg0_13.ulist:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14 + 1]
			local var1_14 = {
				type = var0_14[1],
				id = var0_14[2],
				count = var0_14[3]
			}

			updateDrop(arg2_14:Find("item/bg"), var1_14)

			local var2_14 = arg2_14:Find("item/bg/icon_bg/count")

			onToggle(arg0_13, arg2_14, function(arg0_15)
				if arg0_15 then
					arg0_13.selectedVO = arg1_13:getConfig("usage_arg")[arg1_14 + 1]

					setText(var2_14, arg0_13.count * var0_14[3])

					arg0_13.selectedItem = arg2_14
				end
			end, SFX_PANEL)
			setScrollText(arg2_14:Find("name_bg/Text"), var1_14:getConfig("name"))
		end
	end)
	arg0_13.ulist:align(#var0_13)
	arg0_13:updateValue()
	updateDrop(arg0_13.itemTF:Find("bg"), {
		type = DROP_TYPE_ITEM,
		id = arg1_13.id,
		count = arg1_13.count
	})
	setText(arg0_13.nameTF, arg1_13:getConfig("name"))
	setText(arg0_13.descTF, arg1_13:getConfig("display"))
end

function var0_0.dispose(arg0_16)
	pg.DelegateInfo.Dispose(arg0_16)
end

return var0_0
