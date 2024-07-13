local var0_0 = class("SkinShopMainPanel")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.nameTxt = findTF("name_bg/name", arg0_1._tf):GetComponent(typeof(Text))
	arg0_1.skinNameTxt = findTF("name_bg/skin_name", arg0_1._tf):GetComponent(typeof(Text))
	arg0_1.charParent = findTF("char/char", arg0_1._tf)
	arg0_1.paintingTF = findTF("paint", arg0_1._tf)
	arg0_1.charBg = findTF("char/char_info", arg0_1._tf)
	arg0_1.tags = findTF("char/char_info/tags", arg0_1._tf)
	arg0_1.limitTxt = findTF("name_bg/limit_time/Text", arg0_1._tf):GetComponent(typeof(Text))
	arg0_1.commonPanel = findTF("char/common", arg0_1._tf)
	arg0_1.buyBtn = findTF("buy_btn", arg0_1.commonPanel)
	arg0_1.activityBtn = findTF("activty_btn", arg0_1.commonPanel)
	arg0_1.gotBtn = findTF("got_btn", arg0_1.commonPanel)
	arg0_1.priceTxt = findTF("consume/Text", arg0_1.commonPanel):GetComponent(typeof(Text))
	arg0_1.originalPriceTxt = findTF("consume/originalprice/Text", arg0_1.commonPanel):GetComponent(typeof(Text))
	arg0_1.timelimtPanel = findTF("char/timelimt", arg0_1._tf)
	arg0_1.timelimitBtn = findTF("timelimit_btn", arg0_1.timelimtPanel)
	arg0_1.timelimitPriceTxt = findTF("consume/Text", arg0_1.timelimtPanel):GetComponent(typeof(Text))
	arg0_1.bg1 = findTF("bg/bg_1")
	arg0_1.bg2 = findTF("bg/bg_2")
	arg0_1.bgType = false
	arg0_1.defaultBg = arg0_1.bg1:GetComponent(typeof(Image)).sprite
end

return var0_0
