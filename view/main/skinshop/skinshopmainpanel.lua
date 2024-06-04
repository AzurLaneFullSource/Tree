local var0 = class("SkinShopMainPanel")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.nameTxt = findTF("name_bg/name", arg0._tf):GetComponent(typeof(Text))
	arg0.skinNameTxt = findTF("name_bg/skin_name", arg0._tf):GetComponent(typeof(Text))
	arg0.charParent = findTF("char/char", arg0._tf)
	arg0.paintingTF = findTF("paint", arg0._tf)
	arg0.charBg = findTF("char/char_info", arg0._tf)
	arg0.tags = findTF("char/char_info/tags", arg0._tf)
	arg0.limitTxt = findTF("name_bg/limit_time/Text", arg0._tf):GetComponent(typeof(Text))
	arg0.commonPanel = findTF("char/common", arg0._tf)
	arg0.buyBtn = findTF("buy_btn", arg0.commonPanel)
	arg0.activityBtn = findTF("activty_btn", arg0.commonPanel)
	arg0.gotBtn = findTF("got_btn", arg0.commonPanel)
	arg0.priceTxt = findTF("consume/Text", arg0.commonPanel):GetComponent(typeof(Text))
	arg0.originalPriceTxt = findTF("consume/originalprice/Text", arg0.commonPanel):GetComponent(typeof(Text))
	arg0.timelimtPanel = findTF("char/timelimt", arg0._tf)
	arg0.timelimitBtn = findTF("timelimit_btn", arg0.timelimtPanel)
	arg0.timelimitPriceTxt = findTF("consume/Text", arg0.timelimtPanel):GetComponent(typeof(Text))
	arg0.bg1 = findTF("bg/bg_1")
	arg0.bg2 = findTF("bg/bg_2")
	arg0.bgType = false
	arg0.defaultBg = arg0.bg1:GetComponent(typeof(Image)).sprite
end

return var0
