local var0 = class("StoreUpgradeWindow", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "MailStoreExtendMsgboxUI"
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.closeBtn = arg0:findTF("window/top/btnBack")

	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.btnDiamond = arg0:findTF("window/button_container/btn_diamond")

	onButton(arg0, arg0.btnDiamond, function()
		arg0:emit(MailMediator.ON_EXTEND_STORE, true)
		arg0:Hide()
	end, SFX_PANEL)

	arg0.btnGold = arg0:findTF("window/button_container/btn_gold")

	onButton(arg0, arg0.btnGold, function()
		arg0:emit(MailMediator.ON_EXTEND_STORE, false)
		arg0:Hide()
	end, SFX_PANEL)
	setText(arg0._tf:Find("window/top/bg/infomation/title"), i18n("mail_boxroom_extend_title"))
	setText(arg0._tf:Find("window/frame/tip/Text"), i18n("mail_boxroom_extend_tips"))
	setText(arg0.btnGold:Find("Text"), i18n("mail_buy_button"))
	setText(arg0.btnDiamond:Find("Text"), i18n("mail_buy_button"))
	setText(arg0._tf:Find("window/frame/price/Text"), i18n("mail_all_price"))
end

function var0.UpdateInfo(arg0)
	local var0 = arg0._tf:Find("window/frame")
	local var1 = getProxy(PlayerProxy):getRawData()
	local var2 = pg.mail_storeroom[var1.mailStoreLevel]
	local var3 = pg.mail_storeroom[var1.mailStoreLevel + 1]
	local var4, var5 = var1:GetExtendStoreCost()

	setText(var0:Find("gold/before"), var2.gold_store)
	setText(var0:Find("gold/after"), var3.gold_store)
	setText(var0:Find("oil/before"), var2.oil_store)
	setText(var0:Find("oil/after"), var3.oil_store)
	setText(var0:Find("oil/name"), i18n("mail_oil_res"))
	setText(var0:Find("gold/name"), i18n("mail_gold_res"))
	setActive(var0:Find("price/price_diamond"), var4)
	setText(var0:Find("price/price_diamond/Text"), var4 and var4.count or 0)
	setActive(var0:Find("price/price_gold"), var5)
	setText(var0:Find("price/price_gold/Text"), var5 and var5.count or 0)
	setActive(var0:Find("price/line"), var4 and var5)
	setActive(arg0.btnDiamond, var4)
	setActive(arg0.btnGold, var5)
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0:UpdateInfo()
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
