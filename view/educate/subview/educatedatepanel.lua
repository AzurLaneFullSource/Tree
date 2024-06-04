local var0 = class("EducateDatePanel", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "EducateDatePanel"
end

function var0.OnInit(arg0)
	arg0.timeTF = arg0:findTF("content/top/time")
	arg0.weekTF = arg0:findTF("week", arg0.timeTF)
	arg0.dayTF = arg0:findTF("day", arg0.timeTF)
	arg0.homeTF = arg0:findTF("content/top/home")

	setText(arg0:findTF("Text", arg0.homeTF), i18n("child_date_text1"))

	arg0.schoolTF = arg0:findTF("content/top/school")

	setText(arg0:findTF("Text", arg0.schoolTF), i18n("child_date_text2"))

	arg0.upgradeTF = arg0:findTF("content/top/upgrade")

	setText(arg0:findTF("Text", arg0.upgradeTF), i18n("child_date_text3"))

	arg0.dataTF = arg0:findTF("content/top/data")

	setText(arg0:findTF("Text", arg0.dataTF), i18n("child_date_text4"))

	arg0.newsBtn = arg0:findTF("content/bottom")

	onButton(arg0, arg0.newsBtn, function()
		arg0:emit(EducateBaseUI.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateNewsMediator,
			viewComponent = EducateNewsLayer
		}))
	end, SFX_PANEL)

	arg0.targetSetDays = getProxy(EducateProxy):GetTaskProxy():GetTargetSetDays()

	arg0:Flush()
end

function var0.Flush(arg0)
	if not arg0:GetLoaded() then
		return
	end

	arg0.curTime = getProxy(EducateProxy):GetCurTime()
	arg0.status = getProxy(EducateProxy):GetGameStatus()

	setActive(arg0.homeTF, arg0:isHomeShow())
	setActive(arg0.schoolTF, arg0:isSchoolShow())
	setActive(arg0.upgradeTF, arg0:isUpgradeShow())
	setActive(arg0.dataTF, arg0.status == EducateConst.STATUES_RESET)

	local var0 = arg0:isTimeShow()

	setActive(arg0.timeTF, var0)

	if var0 then
		local var1 = arg0.curTime.month
		local var2 = EducateHelper.GetShowMonthNumber(var1) .. i18n("word_month") .. i18n("word_which_week", arg0.curTime.week)

		setText(arg0.weekTF, var2)
		setText(arg0.dayTF, EducateHelper.GetWeekStrByNumber(arg0.curTime.day))
	end
end

function var0.UpdateWeekDay(arg0, arg1)
	if not arg0:GetLoaded() then
		return
	end

	local var0 = EducateHelper.GetTimeAfterWeeks(getProxy(EducateProxy):GetCurTime(), 1)
	local var1 = EducateHelper.GetShowMonthNumber(var0.month) .. i18n("word_month") .. i18n("word_which_week", var0.week)

	setText(arg0.weekTF, var1)
	setText(arg0.dayTF, EducateHelper.GetWeekStrByNumber(arg1))
end

function var0.isHomeShow(arg0)
	return EducateHelper.IsSameDay(arg0.curTime, arg0.targetSetDays[1])
end

function var0.isSchoolShow(arg0)
	return EducateHelper.IsSameDay(arg0.curTime, arg0.targetSetDays[2])
end

function var0.isUpgradeShow(arg0)
	return EducateHelper.IsSameDay(arg0.curTime, arg0.targetSetDays[3]) or EducateHelper.IsSameDay(arg0.curTime, arg0.targetSetDays[4])
end

function var0.isTimeShow(arg0)
	return not isActive(arg0.homeTF) and not isActive(arg0.schoolTF) and not isActive(arg0.upgradeTF) and not isActive(arg0.dataTF)
end

return var0
