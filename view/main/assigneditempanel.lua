local var0 = class("AssignedItemPanel")

function var0.Ctor(arg0, arg1, arg2)
	pg.DelegateInfo.New(arg0)

	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.isInited = false
	arg0.selectedVO = nil
	arg0.count = 1
	arg0.view = arg2
end

function var0.findTF(arg0, arg1)
	return findTF(arg0._tf, arg1)
end

function var0.show(arg0)
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.hide(arg0)
	setActive(arg0._tf, false)

	arg0.selectedVO = nil
	arg0.itemVO = nil
	arg0.count = 1

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.view._tf)

	if arg0.selectedItem then
		triggerToggle(arg0.selectedItem, false)
	end

	arg0.selectedItem = nil
end

function var0.init(arg0)
	arg0.isInited = true
	arg0.ulist = UIItemList.New(arg0:findTF("got/bottom/scroll/list"), arg0:findTF("got/bottom/scroll/list/tpl"))
	arg0.confirmBtn = arg0:findTF("calc/confirm")
	arg0.rightArr = arg0:findTF("calc/value_bg/add")
	arg0.leftArr = arg0:findTF("calc/value_bg/mius")
	arg0.maxBtn = arg0:findTF("calc/max")
	arg0.valueText = arg0:findTF("calc/value_bg/Text")
	arg0.itemTF = arg0:findTF("item/bottom/item")
	arg0.nameTF = arg0:findTF("item/bottom/name_bg/name")
	arg0.descTF = arg0:findTF("item/bottom/desc")

	onButton(arg0, arg0._tf, function()
		arg0:hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.rightArr, function()
		if not arg0.itemVO then
			return
		end

		arg0.count = math.min(arg0.count + 1, arg0.itemVO.count)

		arg0:updateValue()
	end, SFX_PANEL)
	onButton(arg0, arg0.leftArr, function()
		if not arg0.itemVO then
			return
		end

		arg0.count = math.max(arg0.count - 1, 1)

		arg0:updateValue()
	end, SFX_PANEL)
	onButton(arg0, arg0.maxBtn, function()
		if not arg0.itemVO then
			return
		end

		arg0.count = arg0.itemVO.count

		arg0:updateValue()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if not arg0.selectedVO or not arg0.itemVO or arg0.count <= 0 then
			return
		end

		arg0.view:emit(EquipmentMediator.ON_USE_ITEM, arg0.itemVO.id, arg0.count, arg0.selectedVO)
		arg0:hide()
	end, SFX_PANEL)
end

function var0.updateValue(arg0)
	setText(arg0.valueText, arg0.count)
	arg0.ulist:each(function(arg0, arg1)
		setText(arg1:Find("item/bg/icon_bg/count"), arg0.count)
	end)
end

function var0.update(arg0, arg1)
	arg0.itemVO = arg1

	if not arg0.isInited then
		arg0:init()
	end

	local var0 = arg1:getConfig("display_icon")

	arg0.selectedItem = nil

	arg0.ulist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2:Find("item/bg"), var1)

			local var2 = arg2:Find("item/bg/icon_bg/count")

			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0.selectedVO = arg1:getConfig("usage_arg")[arg1 + 1]

					setText(var2, arg0.count * var0[3])

					arg0.selectedItem = arg2
				end
			end, SFX_PANEL)
			setScrollText(arg2:Find("name_bg/Text"), var1:getConfig("name"))
		end
	end)
	arg0.ulist:align(#var0)
	arg0:updateValue()
	updateDrop(arg0.itemTF:Find("bg"), {
		type = DROP_TYPE_ITEM,
		id = arg1.id,
		count = arg1.count
	})
	setText(arg0.nameTF, arg1:getConfig("name"))
	setText(arg0.descTF, arg1:getConfig("display"))
end

function var0.dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

return var0
