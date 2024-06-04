local var0 = class("CommissionInfoClassItem", import(".CommissionInfoItem"))

function var0.OnFlush(arg0)
	local var0 = getProxy(NavalAcademyProxy):getStudents()
	local var1 = getProxy(NavalAcademyProxy):getSkillClassNum()
	local var2 = table.getCount(var0)
	local var3 = 0

	_.each(_.values(var0), function(arg0)
		if arg0:getFinishTime() <= pg.TimeMgr.GetInstance():GetServerTime() then
			var3 = var3 + 1
		end
	end)

	arg0.finishedCounter.text = var3
	arg0.ongoingCounter.text = var2 - var3
	arg0.leisureCounter.text = var1 - var2

	setActive(arg0.finishedCounterContainer, var3 > 0)
	setActive(arg0.ongoingCounterContainer, var3 < var2)
	setActive(arg0.leisureCounterContainer, var2 < var1)
	setActive(arg0.goBtn, var3 == 0)
	setActive(arg0.finishedBtn, var3 > 0)

	arg0.list = var0
end

function var0.UpdateListItem(arg0, arg1, arg2, arg3)
	local var0 = arg2
	local var1 = arg3:Find("unlock/name_bg")

	if var0 then
		arg0:UpdateStudent(var0, arg3)

		var1.sizeDelta = Vector2(267, 45)
	else
		arg0:UpdateEmpty(arg3)

		var1.sizeDelta = Vector2(400, 45)
	end

	local var2 = var0 and var0:getFinishTime() <= pg.TimeMgr.GetInstance():GetServerTime()

	setActive(arg3:Find("unlock"), true)
	setActive(arg3:Find("lock"), false)
	setActive(arg3:Find("unlock/leisure"), not var0)
	setActive(arg3:Find("unlock/ongoging"), var0 and not var2)
	setActive(arg3:Find("unlock/finished"), var0 and var2)
end

function var0.UpdateStudent(arg0, arg1, arg2)
	local var0 = arg1:getFinishTime()
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = arg1:getShipVO()
	local var3

	setText(arg2:Find("unlock/name_bg/Text"), arg1:getSkillName())

	if var1 < var0 then
		arg0:AddTimer(arg1, arg2)

		var3 = arg2:Find("unlock/ongoging/shipicon")
	else
		onButton(arg0, arg2:Find("unlock/finished/finish_btn"), function()
			arg0:emit(CommissionInfoMediator.FINISH_CLASS, arg1.id, Student.CANCEL_TYPE_AUTO)
		end, SFX_PANEL)
		onButton(arg0, arg2, function()
			triggerButton(arg2:Find("unlock/finished/finish_btn"))
		end, SFX_PANEL)

		var3 = arg2:Find("unlock/finished/shipicon")
	end

	updateShip(var3, var2)
end

function var0.AddTimer(arg0, arg1, arg2)
	arg0:RemoveTimer(arg1)

	local var0 = arg2:Find("unlock/ongoging/time"):GetComponent(typeof(Text))
	local var1 = arg1:getFinishTime()

	arg0.timers[arg1.id] = Timer.New(function()
		local var0 = var1 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 <= 0 then
			arg0:RemoveTimer(arg1)
			arg0:Update()
		else
			var0.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
		end
	end, 1, -1)

	arg0.timers[arg1.id]:Start()
	arg0.timers[arg1.id]:func()
end

function var0.RemoveTimer(arg0, arg1)
	if arg0.timers[arg1.id] then
		arg0.timers[arg1.id]:Stop()

		arg0.timers[arg1.id] = nil
	end
end

function var0.UpdateEmpty(arg0, arg1)
	setText(arg1:Find("unlock/name_bg/Text"), i18n("commission_idle"))
	onButton(arg0, arg1:Find("unlock/leisure/go_btn"), function()
		arg0:emit(CommissionInfoMediator.ON_ACTIVE_CLASS)
	end, SFX_PANEL)
	onButton(arg0, arg1, function()
		arg0:OnSkip()
	end, SFX_PANEL)
end

function var0.GetList(arg0)
	local var0 = getProxy(NavalAcademyProxy):getSkillClassNum()

	return arg0.list, var0
end

function var0.OnSkip(arg0)
	arg0:emit(CommissionInfoMediator.ON_ACTIVE_CLASS)
end

function var0.OnFinishAll(arg0)
	arg0:emit(CommissionInfoMediator.FINISH_CLASS_ALL)
end

return var0
