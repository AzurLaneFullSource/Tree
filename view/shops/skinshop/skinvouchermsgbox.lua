local var0 = class("SkinVoucherMsgBox", import(".SkinCouponMsgBox"))

function var0.getUIName(arg0)
	return "SkinVoucherMsgBoxUI"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)
	setActive(arg0.confirmBtn, false)

	arg0.realPriceBtn = arg0:findTF("window/button_container/real_price")
	arg0.discountPriceBtn = arg0:findTF("window/button_container/discount_price")

	setText(arg0._tf:Find("window/top/bg/infomation/title"), i18n("title_info"))
end

function var0.RegisterBtn(arg0, arg1)
	onButton(arg0, arg0.discountPriceBtn, function()
		if not arg0.prevSelId then
			return
		end

		if arg1.onYes then
			arg1.onYes(arg0.prevSelId)
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.realPriceBtn, function()
		if arg1.onYes then
			arg1.onYes()
		end

		arg0:Hide()
	end, SFX_PANEL)
end

function var0.UpdateContent(arg0, arg1)
	local var0 = arg1.skinName
	local var1 = arg1.price

	if arg0.prevSelId then
		local var2 = pg.item_data_statistics[arg0.prevSelId]
		local var3 = var2.usage_arg[2]
		local var4 = math.max(0, var1 - var3)

		arg0.label1.text = i18n(var4 > 0 and "skin_purchase_confirm" or "skin_purchase_over_price", var2.name, var4, var0)
	else
		arg0.label1.text = i18n("charge_scene_buy_confirm", var1, var0)
	end

	setActive(arg0.realPriceBtn, not arg0.prevSelId)
	setActive(arg0.discountPriceBtn, arg0.prevSelId)
end

function var0.UpdateItem(arg0, arg1)
	arg0.itemTrs = {}

	local var0 = table.mergeArray({
		0
	}, arg1.itemList or {})

	UIItemList.StaticAlign(arg0:findTF("window/frame/list"), arg0:findTF("window/frame/left"), #var0, function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:FlushItem(var0[arg1 + 1], arg2)
		end
	end)
	triggerToggle(arg0:findTF("window/frame/list/none"), true)
end

function var0.FlushItem(arg0, arg1, arg2)
	if arg1 == 0 then
		setText(arg2:Find("name_bg/Text"), i18n("not_use_ticket_to_buy_skin"))
	else
		updateDrop(arg2, {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = arg1
		})

		local var0 = pg.item_data_statistics[arg1].name

		setText(arg2:Find("name_bg/Text"), var0)
	end

	onToggle(arg0, arg2, function(arg0)
		if arg0 then
			if arg1 == 0 then
				arg0.prevSelId = nil

				arg0:UpdateContent(arg0.settings)
			else
				arg0:ClearPrevSel()

				arg0.prevSelId = arg1

				arg0:UpdateContent(arg0.settings)
			end
		end
	end, SFX_PANEL)

	arg0.itemTrs[arg1] = arg2
end

function var0.ClearPrevSel(arg0)
	arg0.prevSelId = nil
end

function var0.Hide(arg0)
	arg0.settings = nil

	setActive(arg0._tf, false)
	arg0:ClearPrevSel()

	for iter0, iter1 in pairs(arg0.itemTrs) do
		removeOnToggle(iter1)
		triggerToggle(iter1, false)
	end
end

return var0
