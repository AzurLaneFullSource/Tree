local var0 = class("EducateCalendarLayer", import(".base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateCalendarUI"
end

function var0.init(arg0)
	arg0.calendarTF = arg0:findTF("anim_root/calendar")
	arg0.monthTF = arg0:findTF("month", arg0.calendarTF)

	setText(arg0:findTF("Text", arg0.monthTF), i18n("word_month"))

	arg0.weekTF = arg0:findTF("week/week", arg0.calendarTF)
	arg0.curTime = getProxy(EducateProxy):GetCurTime()
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)
	arg0.animEvent:SetTriggerEvent(function()
		local var0 = EducateHelper.GetTimeAfterWeeks(arg0.curTime, 1)
		local var1 = EducateHelper.GetShowMonthNumber(var0.month)
		local var2 = i18n("word_which_week", var0.week)

		setText(arg0.monthTF, var1)
		setText(arg0.weekTF, var2)
	end)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 1
	})

	local var0 = EducateHelper.GetShowMonthNumber(arg0.curTime.month)
	local var1 = i18n("word_which_week", arg0.curTime.week)

	setText(arg0.monthTF, var0)
	setText(arg0.weekTF, var1)
end

function var0.onBackPressed(arg0)
	return
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)

	if arg0.contextData.onExit then
		arg0.contextData.onExit()
	end
end

return var0
