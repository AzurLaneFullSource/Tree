local var0_0 = class("NieRAutomataCoreActivityUI", import("view.activity.CorePage.CoreAdaptActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "NieRAutomataCoreActivityUI"
end

var0_0.optionsPath = {
	"adapt/TopPage/top/btn_home"
}

function var0_0.CustomInit(arg0_2)
	arg0_2.resTime = arg0_2._tf:Find("adapt/TopPage/top/time/Text")

	setActive(arg0_2.upper, true)
	onButton(arg0_2, arg0_2._tf:Find("adapt/shopbtn"), function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end, SFX_PANEL)
end

function var0_0.GetButtonNameText(arg0_4, arg1_4)
	local var0_4 = arg1_4:getConfig("title_res_tag")

	return i18n(var0_4)
end

function var0_0.OnClickBtn(arg0_5, arg1_5, arg2_5)
	local var0_5 = getProxy(ActivityProxy):getActivityById(arg2_5)

	arg0_5:refreshTime(var0_5)
end

function var0_0.refreshTime(arg0_6, arg1_6)
	local var0_6 = arg1_6.stopTime - pg.TimeMgr.GetInstance():GetServerTime()

	setText(arg0_6.resTime, i18n("nier_core_countdown", math.floor(var0_6 / 86400), math.floor(var0_6 % 86400 / 3600)))
end

function var0_0.UpdateAdapt(arg0_7)
	var0_0.super.UpdateAdapt(arg0_7)
end

return var0_0
