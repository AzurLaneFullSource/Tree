local var0_0 = class("BRSCoreActivityUI", import("view.activity.CorePage.CoreActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "BRSCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)
	setText(arg0_2._tf:Find("adapt/top/btn_home/text_tip/Text (Legacy)"), i18n("brs_main_tip"))

	arg0_2.huanyingmituzhe_lan = arg0_2._tf:Find("adapt/mark/huanyingmituzhe_lan")
	arg0_2.huanyingmituzhe_lv = arg0_2._tf:Find("adapt/mark/huanyingmituzhe_lv")
end

function var0_0.selectActivity(arg0_3, arg1_3)
	var0_0.super.selectActivity(arg0_3, arg1_3)
	SetActive(arg0_3.huanyingmituzhe_lan, arg1_3.id ~= 5984)
	SetActive(arg0_3.huanyingmituzhe_lv, arg1_3.id == 5984)
end

return var0_0
