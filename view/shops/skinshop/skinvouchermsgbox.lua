local var0_0 = class("SkinVoucherMsgBox", import(".SkinCouponMsgBox"))

function var0_0.getUIName(arg0_1)
	return "SkinVoucherMsgBoxUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)
	setActive(arg0_2.confirmBtn, false)

	arg0_2.realPriceBtn = arg0_2:findTF("window/button_container/real_price")
	arg0_2.discountPriceBtn = arg0_2:findTF("window/button_container/discount_price")

	setText(arg0_2._tf:Find("window/top/bg/infomation/title"), i18n("title_info"))

	arg0_2.tipBar = arg0_2:findTF("window/frame/tipBar")
	arg0_2.tipText = arg0_2:findTF("Text", arg0_2.tipBar)
end

function var0_0.RegisterBtn(arg0_3, arg1_3)
	onButton(arg0_3, arg0_3.discountPriceBtn, function()
		if not arg0_3.prevSelId then
			return
		end

		if arg1_3.onYes then
			arg1_3.onYes(arg0_3.prevSelId)
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.realPriceBtn, function()
		if arg1_3.onYes then
			arg1_3.onYes()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.UpdateContent(arg0_6, arg1_6)
	local var0_6 = arg1_6.skinName
	local var1_6 = arg1_6.price

	if arg0_6.prevSelId then
		local var2_6 = pg.item_data_statistics[arg0_6.prevSelId]
		local var3_6 = var2_6.usage_arg[2]
		local var4_6 = math.max(0, var1_6 - var3_6)

		arg0_6.label1.text = i18n(var4_6 > 0 and "skin_purchase_confirm" or "skin_purchase_over_price", var2_6.name, var4_6, var0_6)
	else
		arg0_6.label1.text = i18n("charge_scene_buy_confirm", var1_6, var0_6)
	end

	setActive(arg0_6.realPriceBtn, not arg0_6.prevSelId)
	setActive(arg0_6.discountPriceBtn, arg0_6.prevSelId)
	arg0_6:SetTipText(arg1_6.skinId)
end

function var0_0.UpdateItem(arg0_7, arg1_7)
	arg0_7.itemTrs = {}

	local var0_7 = table.mergeArray({
		0
	}, arg1_7.itemList or {})

	UIItemList.StaticAlign(arg0_7:findTF("window/frame/list"), arg0_7:findTF("window/frame/left"), #var0_7, function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_7:FlushItem(var0_7[arg1_8 + 1], arg2_8)
		end
	end)
	triggerToggle(arg0_7:findTF("window/frame/list/none"), true)
end

function var0_0.FlushItem(arg0_9, arg1_9, arg2_9)
	if arg1_9 == 0 then
		setText(arg2_9:Find("name_bg/Text"), i18n("not_use_ticket_to_buy_skin"))
	else
		updateDrop(arg2_9, {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = arg1_9
		})

		local var0_9 = pg.item_data_statistics[arg1_9].name

		setText(arg2_9:Find("name_bg/Text"), var0_9)
	end

	onToggle(arg0_9, arg2_9, function(arg0_10)
		if arg0_10 then
			if arg1_9 == 0 then
				arg0_9.prevSelId = nil

				arg0_9:UpdateContent(arg0_9.settings)
			else
				arg0_9:ClearPrevSel()

				arg0_9.prevSelId = arg1_9

				arg0_9:UpdateContent(arg0_9.settings)
			end
		end
	end, SFX_PANEL)

	arg0_9.itemTrs[arg1_9] = arg2_9
end

function var0_0.ClearPrevSel(arg0_11)
	arg0_11.prevSelId = nil
end

function var0_0.Hide(arg0_12)
	arg0_12.settings = nil

	setActive(arg0_12._tf, false)
	arg0_12:ClearPrevSel()

	for iter0_12, iter1_12 in pairs(arg0_12.itemTrs) do
		removeOnToggle(iter1_12)
		triggerToggle(iter1_12, false)
	end
end

function var0_0.SetTipText(arg0_13, arg1_13)
	local var0_13 = pg.ship_skin_template[arg1_13].ship_group
	local var1_13 = pg.gameset.no_share_skin_tip.description
	local var2_13
	local var3_13

	for iter0_13, iter1_13 in ipairs(var1_13) do
		for iter2_13, iter3_13 in ipairs(iter1_13) do
			if var0_13 == iter3_13[1] then
				var2_13 = iter1_13
				var3_13 = iter2_13

				break
			end
		end
	end

	setActive(arg0_13.tipBar, var3_13)

	if var3_13 then
		local var4_13 = ""

		for iter4_13, iter5_13 in ipairs(var2_13) do
			if iter4_13 ~= var3_13 then
				if var4_13 == "" then
					var4_13 = i18n(iter5_13[2])
				else
					var4_13 = var4_13 .. "、" .. i18n(iter5_13[2])
				end
			end
		end

		setText(arg0_13.tipText, i18n("no_share_skin_gametip", i18n(var2_13[var3_13][2]), var4_13))
	end
end

return var0_0
