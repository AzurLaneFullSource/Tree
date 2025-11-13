local var0_0 = class("SkinCouponMultiMsgBox", import("view.shops.skinShop.SkinCouponMsgBox"))
local var1_0 = 0
local var2_0 = 1

function var0_0.getUIName(arg0_1)
	return "SkinVoucherMsgBoxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2._tf:Find("window/top/btnBack")
	arg0_2.cancelBtn = arg0_2._tf:Find("window/button_container/cancel")
	arg0_2.confirmBtn = arg0_2._tf:Find("window/button_container/confirm")
	arg0_2.label1 = arg0_2._tf:Find("window/frame/Text"):GetComponent(typeof(Text))
	arg0_2.leftItemTr = arg0_2._tf:Find("window/frame/left")
	arg0_2.nameTxt = arg0_2.leftItemTr:Find("name_bg/Text"):GetComponent(typeof(Text))

	setText(arg0_2.cancelBtn:Find("pic"), i18n("msgbox_text_cancel"))
	setText(arg0_2.confirmBtn:Find("pic"), i18n("msgbox_text_confirm"))
	setText(arg0_2._tf:Find("window/top/bg/infomation/title"), i18n("words_information"))
	setActive(arg0_2.confirmBtn, false)

	arg0_2.realPriceBtn = arg0_2._tf:Find("window/button_container/real_price")
	arg0_2.discountPriceBtn = arg0_2._tf:Find("window/button_container/discount_price")

	setText(arg0_2._tf:Find("window/top/bg/infomation/title"), i18n("title_info"))

	arg0_2.nonUseBtn = arg0_2._tf:Find("window/frame/option/nonuse")
	arg0_2.useBtn = arg0_2._tf:Find("window/frame/option/use")
	arg0_2.scrollrect = arg0_2._tf:Find("window/frame/scrollrect")
	arg0_2.optionTr = arg0_2._tf:Find("window/frame/option")
	arg0_2.switchBtn = arg0_2._tf:Find("window/frame/option/use/link")
	arg0_2.tipBar = arg0_2._tf:Find("window/frame/tipBar")
	arg0_2.tipText = arg0_2.tipBar:Find("Text")
	arg0_2.linkText = arg0_2._tf:Find("window/frame/option/use/link/Text"):GetComponent(typeof(Text))

	setText(arg0_2._tf:Find("window/frame/option/nonuse/Text"), i18n("skin_shop_nonuse_label"))
	setText(arg0_2._tf:Find("window/frame/option/use/Text"), i18n("skin_shop_use_label"))
end

function var0_0.RegisterBtn(arg0_3, arg1_3)
	onButton(arg0_3, arg0_3.discountPriceBtn, function()
		if not arg0_3.prevSelected then
			return
		end

		if arg1_3.onYes then
			arg1_3.onYes(arg0_3.prevSelected)
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.realPriceBtn, function()
		if arg1_3.onYes then
			arg1_3.onYes()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.switchBtn, function()
		arg0_3:UpdateStyle(1 - arg0_3.style)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		arg0_3:UpdateStyle(1 - arg0_3.style)
		triggerToggle(arg0_3.useBtn, true)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		if arg0_3.style == var2_0 then
			arg0_3:UpdateStyle(1 - arg0_3.style)
		else
			arg0_3:Hide()
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.nonUseBtn, function(arg0_9)
		if arg0_9 then
			arg0_3.prevSelected = nil

			arg0_3:UpdateContent(arg0_3.settings)
			arg0_3:UpdateStyle(arg0_3.style)
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.useBtn, function(arg0_10)
		if arg0_10 then
			arg0_3.prevSelected = arg0_3:GetDefaultItem()

			arg0_3:UpdateContent(arg0_3.settings)
			arg0_3:UpdateStyle(arg0_3.style)
		end
	end, SFX_PANEL)
end

function var0_0.GetDefaultItem(arg0_11)
	arg0_11.selectedItem = arg0_11.selectedItem or arg0_11.settings.itemList[1]

	return arg0_11.selectedItem
end

function var0_0.UpdateContent(arg0_12, arg1_12)
	local var0_12 = arg1_12.skinName
	local var1_12 = arg1_12.price

	if arg0_12.prevSelected then
		local var2_12 = arg0_12.prevSelected.discount
		local var3_12 = math.max(0, var1_12 - var2_12)

		arg0_12.label1.text = i18n(var3_12 > 0 and "skin_purchase_confirm" or "skin_purchase_over_price", arg0_12.prevSelected.drop:getName(), var3_12, var0_12)
	else
		arg0_12.label1.text = i18n("charge_scene_buy_confirm", var1_12, var0_12)
	end

	arg0_12:UpdateLink()
	arg0_12:SetTipText(arg1_12.skinId)
end

function var0_0.UpdateLink(arg0_13)
	arg0_13.linkText.text = i18n("skin_shop_discount_item_link", arg0_13:GetDefaultItem().discount)
end

function var0_0.UpdateItem(arg0_14, arg1_14)
	arg0_14.itemTrs = {}

	local var0_14 = arg1_14.itemList

	UIItemList.StaticAlign(arg0_14._tf:Find("window/frame/scrollrect/list"), arg0_14._tf:Find("window/frame/left"), #var0_14, function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			arg0_14:FlushItem(var0_14[arg1_15 + 1], arg2_15)
		end
	end)
end

function var0_0.FlushItem(arg0_16, arg1_16, arg2_16)
	updateDrop(arg2_16, arg1_16.drop)
	setText(arg2_16:Find("name_bg/Text"), arg1_16.drop:getName())
	onToggle(arg0_16, arg2_16, function(arg0_17)
		if arg0_17 then
			arg0_16.selectedItem = arg1_16
		end
	end, SFX_PANEL)

	arg0_16.itemTrs[arg1_16] = arg2_16
end

function var0_0.ClearPrevSel(arg0_18)
	arg0_18.prevSelected = nil
end

function var0_0.Show(arg0_19, arg1_19)
	setActive(arg0_19._tf, true)

	arg0_19.settings = arg1_19

	arg0_19:UpdateItem(arg1_19)
	arg0_19:RegisterBtn(arg1_19)
	arg0_19:UpdateContent(arg1_19)
	arg0_19:UpdateStyle(var1_0)
	setActive(arg0_19.nonUseBtn, false)
	triggerToggle(arg0_19.useBtn, true)
end

function var0_0.UpdateStyle(arg0_20, arg1_20)
	setActive(arg0_20.label1, arg1_20 == var1_0)
	setActive(arg0_20.optionTr, arg1_20 == var1_0)
	setActive(arg0_20.realPriceBtn, arg1_20 == var1_0 and not arg0_20.prevSelected)
	setActive(arg0_20.discountPriceBtn, arg1_20 == var1_0 and arg0_20.prevSelected)
	setActive(arg0_20.confirmBtn, arg1_20 == var2_0)
	setActive(arg0_20.scrollrect, arg1_20 == var2_0)

	local var0_20 = arg0_20:GetDefaultItem()

	triggerToggle(arg0_20.itemTrs[var0_20], true)

	arg0_20.style = arg1_20
end

function var0_0.Hide(arg0_21)
	arg0_21.settings = nil
	arg0_21.selectedItem = nil

	setActive(arg0_21._tf, false)
	arg0_21:ClearPrevSel()

	for iter0_21, iter1_21 in pairs(arg0_21.itemTrs) do
		removeOnToggle(iter1_21)
		triggerToggle(iter1_21, false)
	end
end

function var0_0.SetTipText(arg0_22, arg1_22)
	local var0_22 = pg.ship_skin_template[arg1_22].ship_group
	local var1_22 = pg.gameset.no_share_skin_tip.description
	local var2_22
	local var3_22

	for iter0_22, iter1_22 in ipairs(var1_22) do
		for iter2_22, iter3_22 in ipairs(iter1_22) do
			if var0_22 == iter3_22[1] then
				var2_22 = iter1_22
				var3_22 = iter2_22

				break
			end
		end
	end

	setActive(arg0_22.tipBar, var3_22)

	if var3_22 then
		local var4_22 = ""

		for iter4_22, iter5_22 in ipairs(var2_22) do
			if iter4_22 ~= var3_22 then
				if var4_22 == "" then
					var4_22 = i18n(iter5_22[2])
				else
					var4_22 = var4_22 .. "、" .. i18n(iter5_22[2])
				end
			end
		end

		setText(arg0_22.tipText, i18n("no_share_skin_gametip", i18n(var2_22[var3_22][2]), var4_22))
	end
end

return var0_0
