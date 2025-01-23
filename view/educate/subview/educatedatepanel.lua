local var0_0 = class("EducateDatePanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "EducateDatePanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.timeTF = arg0_2:findTF("content/top/time")
	arg0_2.weekTF = arg0_2:findTF("week", arg0_2.timeTF)
	arg0_2.dayTF = arg0_2:findTF("day", arg0_2.timeTF)
	arg0_2.homeTF = arg0_2:findTF("content/top/home")

	setText(arg0_2:findTF("Text", arg0_2.homeTF), i18n("child_date_text1"))

	arg0_2.schoolTF = arg0_2:findTF("content/top/school")

	setText(arg0_2:findTF("Text", arg0_2.schoolTF), i18n("child_date_text2"))

	arg0_2.upgradeTF = arg0_2:findTF("content/top/upgrade")

	setText(arg0_2:findTF("Text", arg0_2.upgradeTF), i18n("child_date_text3"))

	arg0_2.dataTF = arg0_2:findTF("content/top/data")

	setText(arg0_2:findTF("Text", arg0_2.dataTF), i18n("child_date_text4"))

	arg0_2.newsBtn = arg0_2:findTF("content/bottom")

	onButton(arg0_2, arg0_2.newsBtn, function()
		arg0_2:emit(EducateBaseUI.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateNewsMediator,
			viewComponent = EducateNewsLayer
		}))
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf:Find("content/back"), function()
		arg0_2:emit(EducateBaseUI.ON_BACK)
	end, SFX_PANEL)

	arg0_2.targetSetDays = getProxy(EducateProxy):GetTaskProxy():GetTargetSetDays()

	arg0_2:Flush()
end

function var0_0.Flush(arg0_5)
	if not arg0_5:GetLoaded() then
		return
	end

	arg0_5.curTime = getProxy(EducateProxy):GetCurTime()
	arg0_5.status = getProxy(EducateProxy):GetGameStatus()

	setActive(arg0_5.homeTF, arg0_5:isHomeShow())
	setActive(arg0_5.schoolTF, arg0_5:isSchoolShow())
	setActive(arg0_5.upgradeTF, arg0_5:isUpgradeShow())
	setActive(arg0_5.dataTF, arg0_5.status == EducateConst.STATUES_RESET)

	local var0_5 = arg0_5:isTimeShow()

	setActive(arg0_5.timeTF, var0_5)

	if var0_5 then
		local var1_5 = arg0_5.curTime.month
		local var2_5 = EducateHelper.GetShowMonthNumber(var1_5) .. i18n("word_month") .. i18n("word_which_week", arg0_5.curTime.week)

		setText(arg0_5.weekTF, var2_5)
		setText(arg0_5.dayTF, EducateHelper.GetWeekStrByNumber(arg0_5.curTime.day))
	end
end

function var0_0.UpdateWeekDay(arg0_6, arg1_6)
	if not arg0_6:GetLoaded() then
		return
	end

	local var0_6 = EducateHelper.GetTimeAfterWeeks(getProxy(EducateProxy):GetCurTime(), 1)
	local var1_6 = EducateHelper.GetShowMonthNumber(var0_6.month) .. i18n("word_month") .. i18n("word_which_week", var0_6.week)

	setText(arg0_6.weekTF, var1_6)
	setText(arg0_6.dayTF, EducateHelper.GetWeekStrByNumber(arg1_6))
end

function var0_0.isHomeShow(arg0_7)
	return EducateHelper.IsSameDay(arg0_7.curTime, arg0_7.targetSetDays[1])
end

function var0_0.isSchoolShow(arg0_8)
	return EducateHelper.IsSameDay(arg0_8.curTime, arg0_8.targetSetDays[2])
end

function var0_0.isUpgradeShow(arg0_9)
	return EducateHelper.IsSameDay(arg0_9.curTime, arg0_9.targetSetDays[3]) or EducateHelper.IsSameDay(arg0_9.curTime, arg0_9.targetSetDays[4])
end

function var0_0.isTimeShow(arg0_10)
	return not isActive(arg0_10.homeTF) and not isActive(arg0_10.schoolTF) and not isActive(arg0_10.upgradeTF) and not isActive(arg0_10.dataTF)
end

return var0_0
