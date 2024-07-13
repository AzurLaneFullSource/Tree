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

	arg0_2.targetSetDays = getProxy(EducateProxy):GetTaskProxy():GetTargetSetDays()

	arg0_2:Flush()
end

function var0_0.Flush(arg0_4)
	if not arg0_4:GetLoaded() then
		return
	end

	arg0_4.curTime = getProxy(EducateProxy):GetCurTime()
	arg0_4.status = getProxy(EducateProxy):GetGameStatus()

	setActive(arg0_4.homeTF, arg0_4:isHomeShow())
	setActive(arg0_4.schoolTF, arg0_4:isSchoolShow())
	setActive(arg0_4.upgradeTF, arg0_4:isUpgradeShow())
	setActive(arg0_4.dataTF, arg0_4.status == EducateConst.STATUES_RESET)

	local var0_4 = arg0_4:isTimeShow()

	setActive(arg0_4.timeTF, var0_4)

	if var0_4 then
		local var1_4 = arg0_4.curTime.month
		local var2_4 = EducateHelper.GetShowMonthNumber(var1_4) .. i18n("word_month") .. i18n("word_which_week", arg0_4.curTime.week)

		setText(arg0_4.weekTF, var2_4)
		setText(arg0_4.dayTF, EducateHelper.GetWeekStrByNumber(arg0_4.curTime.day))
	end
end

function var0_0.UpdateWeekDay(arg0_5, arg1_5)
	if not arg0_5:GetLoaded() then
		return
	end

	local var0_5 = EducateHelper.GetTimeAfterWeeks(getProxy(EducateProxy):GetCurTime(), 1)
	local var1_5 = EducateHelper.GetShowMonthNumber(var0_5.month) .. i18n("word_month") .. i18n("word_which_week", var0_5.week)

	setText(arg0_5.weekTF, var1_5)
	setText(arg0_5.dayTF, EducateHelper.GetWeekStrByNumber(arg1_5))
end

function var0_0.isHomeShow(arg0_6)
	return EducateHelper.IsSameDay(arg0_6.curTime, arg0_6.targetSetDays[1])
end

function var0_0.isSchoolShow(arg0_7)
	return EducateHelper.IsSameDay(arg0_7.curTime, arg0_7.targetSetDays[2])
end

function var0_0.isUpgradeShow(arg0_8)
	return EducateHelper.IsSameDay(arg0_8.curTime, arg0_8.targetSetDays[3]) or EducateHelper.IsSameDay(arg0_8.curTime, arg0_8.targetSetDays[4])
end

function var0_0.isTimeShow(arg0_9)
	return not isActive(arg0_9.homeTF) and not isActive(arg0_9.schoolTF) and not isActive(arg0_9.upgradeTF) and not isActive(arg0_9.dataTF)
end

return var0_0
