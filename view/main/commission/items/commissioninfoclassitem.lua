local var0_0 = class("CommissionInfoClassItem", import(".CommissionInfoItem"))

function var0_0.OnFlush(arg0_1)
	local var0_1 = getProxy(NavalAcademyProxy):getStudents()
	local var1_1 = getProxy(NavalAcademyProxy):getSkillClassNum()
	local var2_1 = table.getCount(var0_1)
	local var3_1 = 0

	_.each(_.values(var0_1), function(arg0_2)
		if arg0_2:getFinishTime() <= pg.TimeMgr.GetInstance():GetServerTime() then
			var3_1 = var3_1 + 1
		end
	end)

	arg0_1.finishedCounter.text = var3_1
	arg0_1.ongoingCounter.text = var2_1 - var3_1
	arg0_1.leisureCounter.text = var1_1 - var2_1

	setActive(arg0_1.finishedCounterContainer, var3_1 > 0)
	setActive(arg0_1.ongoingCounterContainer, var3_1 < var2_1)
	setActive(arg0_1.leisureCounterContainer, var2_1 < var1_1)
	setActive(arg0_1.goBtn, var3_1 == 0)
	setActive(arg0_1.finishedBtn, var3_1 > 0)

	arg0_1.list = var0_1
end

function var0_0.UpdateListItem(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg2_3
	local var1_3 = arg3_3:Find("unlock/name_bg")

	if var0_3 then
		arg0_3:UpdateStudent(var0_3, arg3_3)

		var1_3.sizeDelta = Vector2(267, 45)
	else
		arg0_3:UpdateEmpty(arg3_3)

		var1_3.sizeDelta = Vector2(400, 45)
	end

	local var2_3 = var0_3 and var0_3:getFinishTime() <= pg.TimeMgr.GetInstance():GetServerTime()

	setActive(arg3_3:Find("unlock"), true)
	setActive(arg3_3:Find("lock"), false)
	setActive(arg3_3:Find("unlock/leisure"), not var0_3)
	setActive(arg3_3:Find("unlock/ongoging"), var0_3 and not var2_3)
	setActive(arg3_3:Find("unlock/finished"), var0_3 and var2_3)
end

function var0_0.UpdateStudent(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg1_4:getFinishTime()
	local var1_4 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_4 = arg1_4:getShipVO()
	local var3_4

	setText(arg2_4:Find("unlock/name_bg/Text"), shortenString(arg1_4:getSkillName(), 7))

	if var1_4 < var0_4 then
		arg0_4:AddTimer(arg1_4, arg2_4)

		var3_4 = arg2_4:Find("unlock/ongoging/shipicon")
	else
		onButton(arg0_4, arg2_4:Find("unlock/finished/finish_btn"), function()
			arg0_4:emit(CommissionInfoMediator.FINISH_CLASS, arg1_4.id, Student.CANCEL_TYPE_AUTO)
		end, SFX_PANEL)
		onButton(arg0_4, arg2_4, function()
			triggerButton(arg2_4:Find("unlock/finished/finish_btn"))
		end, SFX_PANEL)

		var3_4 = arg2_4:Find("unlock/finished/shipicon")
	end

	updateShip(var3_4, var2_4)
end

function var0_0.AddTimer(arg0_7, arg1_7, arg2_7)
	arg0_7:RemoveTimer(arg1_7)

	local var0_7 = arg2_7:Find("unlock/ongoging/time"):GetComponent(typeof(Text))
	local var1_7 = arg1_7:getFinishTime()

	arg0_7.timers[arg1_7.id] = Timer.New(function()
		local var0_8 = var1_7 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_8 <= 0 then
			arg0_7:RemoveTimer(arg1_7)
			arg0_7:Update()
		else
			var0_7.text = pg.TimeMgr.GetInstance():DescCDTime(var0_8)
		end
	end, 1, -1)

	arg0_7.timers[arg1_7.id]:Start()
	arg0_7.timers[arg1_7.id]:func()
end

function var0_0.RemoveTimer(arg0_9, arg1_9)
	if arg0_9.timers[arg1_9.id] then
		arg0_9.timers[arg1_9.id]:Stop()

		arg0_9.timers[arg1_9.id] = nil
	end
end

function var0_0.UpdateEmpty(arg0_10, arg1_10)
	setText(arg1_10:Find("unlock/name_bg/Text"), i18n("commission_idle"))
	onButton(arg0_10, arg1_10:Find("unlock/leisure/go_btn"), function()
		arg0_10:emit(CommissionInfoMediator.ON_ACTIVE_CLASS)
	end, SFX_PANEL)
	onButton(arg0_10, arg1_10, function()
		arg0_10:OnSkip()
	end, SFX_PANEL)
end

function var0_0.GetList(arg0_13)
	local var0_13 = getProxy(NavalAcademyProxy):getSkillClassNum()

	return arg0_13.list, var0_13
end

function var0_0.OnSkip(arg0_14)
	arg0_14:emit(CommissionInfoMediator.ON_ACTIVE_CLASS)
end

function var0_0.OnFinishAll(arg0_15)
	arg0_15:emit(CommissionInfoMediator.FINISH_CLASS_ALL)
end

return var0_0
