local var0_0 = class("StoreUpgradeWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MailStoreExtendMsgboxUI"
end

function var0_0.OnInit(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.closeBtn = arg0_2:findTF("window/top/btnBack")

	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.btnDiamond = arg0_2:findTF("window/button_container/btn_diamond")

	onButton(arg0_2, arg0_2.btnDiamond, function()
		arg0_2:emit(MailMediator.ON_EXTEND_STORE, true)
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.btnGold = arg0_2:findTF("window/button_container/btn_gold")

	onButton(arg0_2, arg0_2.btnGold, function()
		arg0_2:emit(MailMediator.ON_EXTEND_STORE, false)
		arg0_2:Hide()
	end, SFX_PANEL)
	setText(arg0_2._tf:Find("window/top/bg/infomation/title"), i18n("mail_boxroom_extend_title"))
	setText(arg0_2._tf:Find("window/frame/tip/Text"), i18n("mail_boxroom_extend_tips"))
	setText(arg0_2.btnGold:Find("Text"), i18n("mail_buy_button"))
	setText(arg0_2.btnDiamond:Find("Text"), i18n("mail_buy_button"))
	setText(arg0_2._tf:Find("window/frame/price/Text"), i18n("mail_all_price"))
end

function var0_0.UpdateInfo(arg0_7)
	local var0_7 = arg0_7._tf:Find("window/frame")
	local var1_7 = getProxy(PlayerProxy):getRawData()
	local var2_7 = pg.mail_storeroom[var1_7.mailStoreLevel]
	local var3_7 = pg.mail_storeroom[var1_7.mailStoreLevel + 1]
	local var4_7, var5_7 = var1_7:GetExtendStoreCost()

	setText(var0_7:Find("gold/before"), var2_7.gold_store)
	setText(var0_7:Find("gold/after"), var3_7.gold_store)
	setText(var0_7:Find("oil/before"), var2_7.oil_store)
	setText(var0_7:Find("oil/after"), var3_7.oil_store)
	setText(var0_7:Find("oil/name"), i18n("mail_oil_res"))
	setText(var0_7:Find("gold/name"), i18n("mail_gold_res"))
	setActive(var0_7:Find("price/price_diamond"), var4_7)
	setText(var0_7:Find("price/price_diamond/Text"), var4_7 and var4_7.count or 0)
	setActive(var0_7:Find("price/price_gold"), var5_7)
	setText(var0_7:Find("price/price_gold/Text"), var5_7 and var5_7.count or 0)
	setActive(var0_7:Find("price/line"), var4_7 and var5_7)
	setActive(arg0_7.btnDiamond, var4_7)
	setActive(arg0_7.btnGold, var5_7)
end

function var0_0.Show(arg0_8)
	var0_0.super.Show(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)
	arg0_8:UpdateInfo()
end

function var0_0.Hide(arg0_9)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_9._tf, arg0_9._parentTf)
	var0_0.super.Hide(arg0_9)
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10:isShowing() then
		arg0_10:Hide()
	end
end

return var0_0
