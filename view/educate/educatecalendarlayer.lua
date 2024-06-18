local var0_0 = class("EducateCalendarLayer", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateCalendarUI"
end

function var0_0.init(arg0_2)
	arg0_2.calendarTF = arg0_2:findTF("anim_root/calendar")
	arg0_2.monthTF = arg0_2:findTF("month", arg0_2.calendarTF)

	setText(arg0_2:findTF("Text", arg0_2.monthTF), i18n("word_month"))

	arg0_2.weekTF = arg0_2:findTF("week/week", arg0_2.calendarTF)
	arg0_2.curTime = getProxy(EducateProxy):GetCurTime()
	arg0_2.anim = arg0_2:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_2.animEvent = arg0_2:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_2.animEvent:SetEndEvent(function()
		arg0_2:emit(var0_0.ON_CLOSE)
	end)
	arg0_2.animEvent:SetTriggerEvent(function()
		local var0_4 = EducateHelper.GetTimeAfterWeeks(arg0_2.curTime, 1)
		local var1_4 = EducateHelper.GetShowMonthNumber(var0_4.month)
		local var2_4 = i18n("word_which_week", var0_4.week)

		setText(arg0_2.monthTF, var1_4)
		setText(arg0_2.weekTF, var2_4)
	end)
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf, {
		groupName = arg0_5:getGroupNameFromData(),
		weight = arg0_5:getWeightFromData() + 1
	})

	local var0_5 = EducateHelper.GetShowMonthNumber(arg0_5.curTime.month)
	local var1_5 = i18n("word_which_week", arg0_5.curTime.week)

	setText(arg0_5.monthTF, var0_5)
	setText(arg0_5.weekTF, var1_5)
end

function var0_0.onBackPressed(arg0_6)
	return
end

function var0_0.willExit(arg0_7)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_7._tf)

	if arg0_7.contextData.onExit then
		arg0_7.contextData.onExit()
	end
end

return var0_0
