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
	if arg1_3 and (not arg0_3.activity or arg0_3.activity.id ~= arg1_3.id) then
		SetActive(arg0_3.huanyingmituzhe_lan, arg1_3.id ~= 5984)
		SetActive(arg0_3.huanyingmituzhe_lv, arg1_3.id == 5984)

		local var0_3 = arg0_3.pageDic[arg1_3.id]

		assert(var0_3, "找不到id:" .. arg1_3.id .. "的活动页，请检查")
		var0_3:Load()
		var0_3:ActionInvoke("Flush", arg1_3)
		var0_3:ActionInvoke("ShowOrHide", true)

		if arg0_3.activity and arg0_3.activity.id ~= arg1_3.id then
			arg0_3.pageDic[arg0_3.activity.id]:ActionInvoke("ShowOrHide", false)
		end

		arg0_3.activity = arg1_3
		arg0_3.contextData.id = arg1_3.id
	end
end

return var0_0
