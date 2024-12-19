local var0_0 = class("SkinVoucherMsgBox", import(".SkinCouponMsgBox"))
local var1_0 = 0
local var2_0 = 1

function var0_0.getUIName(arg0_1)
	return "SkinVoucherMsgBoxUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)
	setActive(arg0_2.confirmBtn, false)

	arg0_2.realPriceBtn = arg0_2:findTF("window/button_container/real_price")
	arg0_2.discountPriceBtn = arg0_2:findTF("window/button_container/discount_price")

	setText(arg0_2._tf:Find("window/top/bg/infomation/title"), i18n("title_info"))

	arg0_2.nonUseBtn = arg0_2:findTF("window/frame/option/nonuse")
	arg0_2.useBtn = arg0_2:findTF("window/frame/option/use")
	arg0_2.scrollrect = arg0_2:findTF("window/frame/scrollrect")
	arg0_2.optionTr = arg0_2:findTF("window/frame/option")
	arg0_2.switchBtn = arg0_2:findTF("window/frame/option/use/link")
	arg0_2.tipBar = arg0_2:findTF("window/frame/tipBar")
	arg0_2.tipText = arg0_2:findTF("Text", arg0_2.tipBar)
	arg0_2.linkText = arg0_2:findTF("window/frame/option/use/link/Text"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("window/frame/option/nonuse/Text"), i18n("skin_shop_nonuse_label"))
	setText(arg0_2:findTF("window/frame/option/use/Text"), i18n("skin_shop_use_label"))
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
			arg0_3.prevSelId = nil

			arg0_3:UpdateContent(arg0_3.settings)
			arg0_3:UpdateStyle(arg0_3.style)
		end
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.useBtn, function(arg0_10)
		if arg0_10 then
			arg0_3.prevSelId = arg0_3:GetDefaultItem()

			arg0_3:UpdateContent(arg0_3.settings)
			arg0_3:UpdateStyle(arg0_3.style)
		end
	end, SFX_PANEL)
end

function var0_0.GetDefaultItem(arg0_11)
	local function var0_11()
		local var0_12 = _.map(arg0_11.settings.itemList, function(arg0_13)
			local var0_13 = pg.item_data_statistics[arg0_13].usage_arg[2] or 0

			return {
				gem = var0_13,
				id = arg0_13,
				time = pg.item_data_statistics[arg0_13].time_limit
			}
		end)

		if #var0_12 == 0 then
			return nil
		end

		table.sort(var0_12, function(arg0_14, arg1_14)
			if arg0_14.time ~= arg1_14.time then
				return arg0_14.time > arg1_14.time
			else
				return arg0_14.gem > arg1_14.gem
			end
		end)

		return var0_12[1].id
	end

	arg0_11.selectedItemId = arg0_11.selectedItemId or var0_11()

	return arg0_11.selectedItemId
end

function var0_0.UpdateContent(arg0_15, arg1_15)
	local var0_15 = arg1_15.skinName
	local var1_15 = arg1_15.price

	if arg0_15.prevSelId then
		local var2_15 = pg.item_data_statistics[arg0_15.prevSelId]
		local var3_15 = var2_15.usage_arg[2]
		local var4_15 = math.max(0, var1_15 - var3_15)

		arg0_15.label1.text = i18n(var4_15 > 0 and "skin_purchase_confirm" or "skin_purchase_over_price", var2_15.name, var4_15, var0_15)
	else
		arg0_15.label1.text = i18n("charge_scene_buy_confirm", var1_15, var0_15)
	end

	arg0_15:UpdateLink()
	arg0_15:SetTipText(arg1_15.skinId)
end

function var0_0.UpdateLink(arg0_16)
	local var0_16 = arg0_16:GetDefaultItem()
	local var1_16 = pg.item_data_statistics[var0_16].usage_arg[2] or 0

	arg0_16.linkText.text = i18n("skin_shop_discount_item_link", var1_16)
end

function var0_0.UpdateItem(arg0_17, arg1_17)
	arg0_17.itemTrs = {}

	local var0_17 = arg1_17.itemList

	UIItemList.StaticAlign(arg0_17:findTF("window/frame/scrollrect/list"), arg0_17:findTF("window/frame/left"), #var0_17, function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			arg0_17:FlushItem(var0_17[arg1_18 + 1], arg2_18)
		end
	end)
end

function var0_0.FlushItem(arg0_19, arg1_19, arg2_19)
	updateDrop(arg2_19, {
		count = 1,
		type = DROP_TYPE_ITEM,
		id = arg1_19
	})

	local var0_19 = pg.item_data_statistics[arg1_19].name

	setText(arg2_19:Find("name_bg/Text"), var0_19)
	onToggle(arg0_19, arg2_19, function(arg0_20)
		if arg0_20 then
			arg0_19.selectedItemId = arg1_19
		end
	end, SFX_PANEL)

	arg0_19.itemTrs[arg1_19] = arg2_19
end

function var0_0.ClearPrevSel(arg0_21)
	arg0_21.prevSelId = nil
end

function var0_0.Show(arg0_22, arg1_22)
	setActive(arg0_22._tf, true)

	arg0_22.settings = arg1_22

	arg0_22:UpdateItem(arg1_22)
	arg0_22:RegisterBtn(arg1_22)
	arg0_22:UpdateContent(arg1_22)
	arg0_22:UpdateStyle(var1_0)
	triggerToggle(arg0_22.useBtn, true)
end

function var0_0.UpdateStyle(arg0_23, arg1_23)
	setActive(arg0_23.label1, arg1_23 == var1_0)
	setActive(arg0_23.optionTr, arg1_23 == var1_0)
	setActive(arg0_23.realPriceBtn, arg1_23 == var1_0 and not arg0_23.prevSelId)
	setActive(arg0_23.discountPriceBtn, arg1_23 == var1_0 and arg0_23.prevSelId)
	setActive(arg0_23.confirmBtn, arg1_23 == var2_0)
	setActive(arg0_23.scrollrect, arg1_23 == var2_0)

	local var0_23 = arg0_23:GetDefaultItem()

	triggerToggle(arg0_23.itemTrs[var0_23], true)

	arg0_23.style = arg1_23
end

function var0_0.Hide(arg0_24)
	arg0_24.settings = nil
	arg0_24.selectedItemId = nil

	setActive(arg0_24._tf, false)
	arg0_24:ClearPrevSel()

	for iter0_24, iter1_24 in pairs(arg0_24.itemTrs) do
		removeOnToggle(iter1_24)
		triggerToggle(iter1_24, false)
	end
end

function var0_0.SetTipText(arg0_25, arg1_25)
	local var0_25 = pg.ship_skin_template[arg1_25].ship_group
	local var1_25 = pg.gameset.no_share_skin_tip.description
	local var2_25
	local var3_25

	for iter0_25, iter1_25 in ipairs(var1_25) do
		for iter2_25, iter3_25 in ipairs(iter1_25) do
			if var0_25 == iter3_25[1] then
				var2_25 = iter1_25
				var3_25 = iter2_25

				break
			end
		end
	end

	setActive(arg0_25.tipBar, var3_25)

	if var3_25 then
		local var4_25 = ""

		for iter4_25, iter5_25 in ipairs(var2_25) do
			if iter4_25 ~= var3_25 then
				if var4_25 == "" then
					var4_25 = i18n(iter5_25[2])
				else
					var4_25 = var4_25 .. "、" .. i18n(iter5_25[2])
				end
			end
		end

		setText(arg0_25.tipText, i18n("no_share_skin_gametip", i18n(var2_25[var3_25][2]), var4_25))
	end
end

return var0_0
