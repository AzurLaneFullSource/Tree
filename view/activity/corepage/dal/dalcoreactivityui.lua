local var0_0 = class("DALCoreActivityUI", import("view.activity.CorePage.SailingShip3.SailingShip3CoreActivityUI"))

var0_0.finishtime = 50256

function var0_0.getUIName(arg0_1)
	return "DALCoreActivityUI"
end

function var0_0.loadingQueue(arg0_2)
	return
end

function var0_0.init(arg0_3, ...)
	var0_0.super.init(arg0_3, ...)
	arg0_3:OnSetTime()
end

function var0_0.didEnter(arg0_4)
	var0_0.super.didEnter(arg0_4)

	if not arg0_4.contextData.activeScenario then
		arg0_4._tf:GetComponent(typeof(Animation)).enabled = true
	end

	onButton(arg0_4, arg0_4.btnBack, function()
		local var0_5 = arg0_4.pageDic[arg0_4.activity.id]

		if var0_5:IsShowingPopWindow() then
			var0_5:ClosePopWindow()
		else
			arg0_4:emit(var0_0.ON_BACK)
		end
	end, SOUND_BACK)
end

function var0_0.ONToggleName(arg0_6, arg1_6, arg2_6)
	setText(arg1_6:Find("on/name"), i18n("dal_main_sheet" .. arg2_6:getConfig("is_show")))
	setText(arg1_6:Find("off/name"), i18n("dal_main_sheet" .. arg2_6:getConfig("is_show")))
	setText(arg1_6:Find("on/name_1"), i18n("dal_main_sheet" .. arg2_6:getConfig("is_show") .. "_en"))
	setText(arg1_6:Find("off/name_1"), i18n("dal_main_sheet" .. arg2_6:getConfig("is_show") .. "_en"))
end

function var0_0.selectActivity(arg0_7, arg1_7)
	var0_0.super.selectActivity(arg0_7, arg1_7)
	SetActive(arg0_7._tf:Find("adapt/Main"), arg1_7.id == 50241)
	SetActive(arg0_7._tf:Find("adapt/tab_bg"), arg1_7.id ~= 50253)
	SetActive(arg0_7._tf:Find("adapt/Favorability_tan_bg"), arg1_7.id == 50253)
end

function var0_0.OnplayAnimation(arg0_8, arg1_8)
	return
end

function var0_0.OnSetTime(arg0_9)
	local var0_9 = getProxy(ActivityProxy):getActivityById(arg0_9.finishtime).stopTime - pg.TimeMgr.GetInstance():GetServerTime()

	setText(arg0_9._tf:Find("adapt/top/btn_home/text_tip/timetext"), i18n("activity_remain_time"))
	setText(arg0_9._tf:Find("adapt/top/btn_home/text_tip/time"), math.floor(var0_9 / 86400) .. i18n("word_date"))
end

return var0_0
