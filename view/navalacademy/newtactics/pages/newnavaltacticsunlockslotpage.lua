local var0_0 = class("NewNavalTacticsUnlockSlotPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewNavalTacticsUnlockSlotPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.contentTxt = arg0_2:findTF("content/Text"):GetComponent(typeof(Text))
	arg0_2.discountDateTxt = arg0_2:findTF("content/discountDate"):GetComponent(typeof(Text))
	arg0_2.discountTxt = arg0_2:findTF("content/discountInfo/Text"):GetComponent(typeof(Text))
	arg0_2.confirmBtn = arg0_2:findTF("content/confirm_btn")
	arg0_2.cancelBtn = arg0_2:findTF("content/cancel_btn")
	arg0_2.closeBtn = arg0_2:findTF("content/btnBack")

	setText(arg0_2.confirmBtn:Find("pic"), i18n("word_ok"))
	setText(arg0_2.cancelBtn:Find("pic"), i18n("word_cancel"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.callback then
			arg0_3.callback()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_8, arg1_8, arg2_8)
	var0_0.super.Show(arg0_8)

	arg0_8.callback = arg2_8

	local var0_8 = CommonCommodity.New({
		id = arg1_8
	}, Goods.TYPE_SHOPSTREET)

	arg0_8:Flush(var0_8)

	arg0_8.commodity = var0_8
end

function var0_0.Flush(arg0_9, arg1_9)
	arg0_9:RemoveTimer()

	local var0_9 = arg1_9:isDisCount()

	if var0_9 then
		arg0_9:UpdateDiscountView(arg1_9)
	else
		local var1_9 = arg1_9:GetPrice()

		arg0_9.contentTxt.text = i18n("open_skill_pos", var1_9)
	end

	setActive(arg0_9.discountDateTxt.gameObject, var0_9)
	setActive(arg0_9.discountTxt.gameObject.transform.parent, var0_9)
end

function var0_0.UpdateDiscountView(arg0_10, arg1_10)
	local var0_10, var1_10 = arg1_10:GetPrice()
	local var2_10 = arg1_10:GetDiscountEndTime()

	arg0_10:AddTimer(var2_10)

	arg0_10.discountTxt.text = var1_10 .. "%"

	local var3_10 = arg1_10:getConfig("resource_num")

	arg0_10.contentTxt.text = i18n("open_skill_pos_discount", var3_10, var0_10)

	onNextTick(function()
		local var0_11 = arg0_10.contentTxt.gameObject.transform
		local var1_11 = var0_11:GetChild(var0_11.childCount - 1)

		if not IsNil(var1_11) then
			setAnchoredPosition(var1_11, {
				y = var1_11.anchoredPosition.y + 15
			})
		end
	end)
end

function var0_0.AddTimer(arg0_12, arg1_12)
	arg0_12.timer = Timer.New(function()
		local var0_13 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1_13 = arg1_12 - var0_13

		if var1_13 <= 0 then
			arg0_12.discountDateTxt.text = ""

			arg0_12:Flush(arg0_12.commodity)
		else
			local var2_13 = i18n("discount_time", arg0_12:WarpDateTip(var1_13) .. i18n("word_date"))

			if var2_13 ~= arg0_12.str then
				arg0_12.discountDateTxt.text = var2_13
				arg0_12.str = var2_13
			end
		end
	end, 1, -1)

	arg0_12.timer:Start()
	arg0_12.timer.func()
end

function var0_0.WarpDateTip(arg0_14, arg1_14)
	local var0_14 = ""

	if arg1_14 >= 86400 then
		var0_14 = math.floor(arg1_14 / 86400)
	elseif arg1_14 >= 3600 then
		var0_14 = math.floor(arg1_14 / 3600)
	else
		var0_14 = math.floor(arg1_14 / 60)
	end

	return var0_14
end

function var0_0.RemoveTimer(arg0_15)
	if arg0_15.timer then
		arg0_15.timer:Stop()

		arg0_15.timer = nil
	end
end

function var0_0.Hide(arg0_16)
	arg0_16:RemoveTimer()
	var0_0.super.Hide(arg0_16)

	arg0_16.callback = nil
	arg0_16.commodity = nil
end

function var0_0.OnDestroy(arg0_17)
	arg0_17:Hide()
end

return var0_0
