local var0 = class("NewNavalTacticsUnlockSlotPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewNavalTacticsUnlockSlotPage"
end

function var0.OnLoaded(arg0)
	arg0.contentTxt = arg0:findTF("content/Text"):GetComponent(typeof(Text))
	arg0.discountDateTxt = arg0:findTF("content/discountDate"):GetComponent(typeof(Text))
	arg0.discountTxt = arg0:findTF("content/discountInfo/Text"):GetComponent(typeof(Text))
	arg0.confirmBtn = arg0:findTF("content/confirm_btn")
	arg0.cancelBtn = arg0:findTF("content/cancel_btn")
	arg0.closeBtn = arg0:findTF("content/btnBack")

	setText(arg0.confirmBtn:Find("pic"), i18n("word_ok"))
	setText(arg0.cancelBtn:Find("pic"), i18n("word_cancel"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.callback then
			arg0.callback()
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)

	arg0.callback = arg2

	local var0 = CommonCommodity.New({
		id = arg1
	}, Goods.TYPE_SHOPSTREET)

	arg0:Flush(var0)

	arg0.commodity = var0
end

function var0.Flush(arg0, arg1)
	arg0:RemoveTimer()

	local var0 = arg1:isDisCount()

	if var0 then
		arg0:UpdateDiscountView(arg1)
	else
		local var1 = arg1:GetPrice()

		arg0.contentTxt.text = i18n("open_skill_pos", var1)
	end

	setActive(arg0.discountDateTxt.gameObject, var0)
	setActive(arg0.discountTxt.gameObject.transform.parent, var0)
end

function var0.UpdateDiscountView(arg0, arg1)
	local var0, var1 = arg1:GetPrice()
	local var2 = arg1:GetDiscountEndTime()

	arg0:AddTimer(var2)

	arg0.discountTxt.text = var1 .. "%"

	local var3 = arg1:getConfig("resource_num")

	arg0.contentTxt.text = i18n("open_skill_pos_discount", var3, var0)

	onNextTick(function()
		local var0 = arg0.contentTxt.gameObject.transform
		local var1 = var0:GetChild(var0.childCount - 1)

		if not IsNil(var1) then
			setAnchoredPosition(var1, {
				y = var1.anchoredPosition.y + 15
			})
		end
	end)
end

function var0.AddTimer(arg0, arg1)
	arg0.timer = Timer.New(function()
		local var0 = pg.TimeMgr.GetInstance():GetServerTime()
		local var1 = arg1 - var0

		if var1 <= 0 then
			arg0.discountDateTxt.text = ""

			arg0:Flush(arg0.commodity)
		else
			local var2 = i18n("discount_time", arg0:WarpDateTip(var1) .. i18n("word_date"))

			if var2 ~= arg0.str then
				arg0.discountDateTxt.text = var2
				arg0.str = var2
			end
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.WarpDateTip(arg0, arg1)
	local var0 = ""

	if arg1 >= 86400 then
		var0 = math.floor(arg1 / 86400)
	elseif arg1 >= 3600 then
		var0 = math.floor(arg1 / 3600)
	else
		var0 = math.floor(arg1 / 60)
	end

	return var0
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Hide(arg0)
	arg0:RemoveTimer()
	var0.super.Hide(arg0)

	arg0.callback = nil
	arg0.commodity = nil
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
