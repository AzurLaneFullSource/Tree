local var0_0 = class("BlackFridayGoodsCard", import(".NewServerGoodsCard"))

function var0_0.Flush(arg0_1)
	arg0_1.cntTxt.text = arg0_1.commodity:GetCanPurchaseCnt() .. "/" .. arg0_1.commodity:GetCanPurchaseMaxCnt()

	setActive(arg0_1.sellOutMaskTF, not arg0_1.commodity:CanPurchase())
	setActive(arg0_1.discountTF, arg0_1.commodity:GetDiscount() ~= 0 and arg0_1.commodity:CanPurchase())
end

function var0_0.Init(arg0_2)
	var0_0.super.Init(arg0_2)
	setActive(arg0_2.discountTF, false)

	if arg0_2.commodity:GetDiscount() ~= 0 and arg0_2.commodity:CanPurchase() then
		setActive(arg0_2.discountTF, true)

		arg0_2.consumeTxtTF.text = arg0_2.commodity:GetSalesPrice()

		setText(arg0_2.discountTF:Find("Text"), arg0_2.commodity:GetOffPercent() .. "%")
	end
end

return var0_0
