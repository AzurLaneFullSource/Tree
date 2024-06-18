local var0_0 = class("CommissionInfoTechnologyItem", import(".CommissionInfoItem"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.commingTF = arg0_1._tf:Find("comming")
	arg0_1.techFrame = arg0_1._tf:Find("frame")
	arg0_1.lockTF = arg0_1._tf:Find("lock")

	setActive(arg0_1.lockTF, false)
	setText(arg0_1.lockTF:Find("Text"), i18n("commission_label_unlock_tech_tip"))
end

function var0_0.CanOpen(arg0_2)
	return getProxy(PlayerProxy):getData().level >= 30 and not LOCK_TECHNOLOGY
end

function var0_0.Init(arg0_3)
	if LOCK_TECHNOLOGY then
		setActive(arg0_3._tf:Find("frame"), false)
		setActive(arg0_3.lockTF, false)
		setActive(arg0_3.commingTF, true)
	else
		setActive(arg0_3._tf:Find("frame"), true)
		setActive(arg0_3.lockTF, false)
		setActive(arg0_3.commingTF, false)

		local var0_3 = arg0_3:CanOpen()

		setActive(arg0_3.lockTF, not var0_3)
		setGray(arg0_3.toggle, not var0_3, true)
		setActive(arg0_3.foldFlag, false)
		setActive(arg0_3.goBtn, var0_3)
		var0_0.super.Init(arg0_3)
	end
end

function var0_0.OnFlush(arg0_4)
	local var0_4 = getProxy(TechnologyProxy):getPlanningTechnologys()

	arg0_4.list = {}

	local var1_4 = {
		ongoing = 0,
		finished = 0,
		leisure = TechnologyConst.QUEUE_TOTAL_COUNT + 1
	}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		if iter1_4:isCompleted() then
			var1_4.leisure = var1_4.leisure - 1
			var1_4.finished = var1_4.finished + 1
		elseif iter1_4:isActivate() then
			var1_4.leisure = var1_4.leisure - 1
			var1_4.ongoing = var1_4.ongoing + 1
		end
	end

	eachChild(arg0_4._tf:Find("frame/counter"), function(arg0_5)
		setActive(arg0_5, var1_4[arg0_5.name] > 0)
		setText(arg0_5:Find("Text"), var1_4[arg0_5.name])
	end)
	setActive(arg0_4.goBtn, var1_4.finished == 0)
	setActive(arg0_4.finishedBtn, var1_4.finished > 0)
end

function var0_0.UpdateListItem(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg2_6
	local var1_6 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_6 = var0_6:getConfig("time")
	local var3_6 = var0_6.time

	if var3_6 == 0 then
		setText(arg3_6:Find("unlock/desc/name_bg/Text"), i18n("commission_idle"))
		onButton(arg0_6, arg3_6:Find("unlock/leisure/go_btn"), function()
			arg0_6:OnSkip()
		end, SFX_PANEL)
		onButton(arg0_6, arg3_6, function()
			arg0_6:OnSkip()
		end, SFX_PANEL)
	elseif var1_6 < var3_6 - var2_6 then
		arg0_6:UpdateTechnology(arg3_6, var0_6)
		setText(arg3_6:Find("unlock/ongoging/time"), pg.TimeMgr.GetInstance():DescCDTime(var2_6))
	elseif var1_6 < var3_6 then
		arg0_6:UpdateTechnology(arg3_6, var0_6)
		arg0_6:AddTimer(var0_6, arg3_6)
	else
		arg0_6:UpdateTechnology(arg3_6, var0_6)

		if var0_6:finishCondition() then
			local var4_6 = arg3_6:Find("unlock/finished/finish_btn")

			onButton(arg0_6, var4_6, function()
				arg0_6:emit(CommissionInfoMediator.ON_TECH_FINISHED, {
					id = var0_6.id,
					pool_id = var0_6.poolId
				})
			end, SFX_PANEL)
			onButton(arg0_6, arg3_6, function()
				triggerButton(var4_6)
			end, SFX_PANEL)
		else
			setText(arg3_6:Find("unlock/ongoging/time"), "00:00:00")
		end
	end

	setActive(arg3_6:Find("unlock"), true)
	setActive(arg3_6:Find("lock"), false)
	setActive(arg3_6:Find("unlock/leisure"), not var0_6:isActivate())
	setActive(arg3_6:Find("unlock/ongoging"), var0_6:isActivate() and not var0_6:isCompleted())
	setActive(arg3_6:Find("unlock/finished"), var0_6:isCompleted())
	setActive(arg3_6:Find("unlock/desc/task_bg"), var0_6:isActivate() and var0_6:getConfig("condition") > 0)
end

function var0_0.AddTimer(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg2_11:Find("unlock/ongoging/time"):GetComponent(typeof(Text))

	arg0_11.timers[arg1_11.id] = Timer.New(function()
		local var0_12 = arg1_11:getFinishTime() - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_12 > 0 then
			var0_11.text = pg.TimeMgr.GetInstance():DescCDTime(var0_12)
		else
			arg0_11:RemoveTimer(arg1_11)
			arg0_11:OnFlush()
			arg0_11:UpdateList()
		end
	end, 1, -1)

	arg0_11.timers[arg1_11.id]:Start()
	arg0_11.timers[arg1_11.id].func()
end

function var0_0.RemoveTimer(arg0_13, arg1_13)
	if arg0_13.timers[arg1_13.id] then
		arg0_13.timers[arg1_13.id]:Stop()

		arg0_13.timers[arg1_13.id] = nil
	end
end

function var0_0.UpdateTechnology(arg0_14, arg1_14, arg2_14)
	setText(arg1_14:Find("unlock/desc/name_bg/Text"), arg2_14:getConfig("name"))

	local var0_14 = arg2_14:getConfig("condition")

	if var0_14 > 0 then
		local var1_14 = getProxy(TaskProxy):getTaskVO(var0_14)
		local var2_14 = var1_14:getConfig("desc") .. "(" .. var1_14:getProgress() .. "/" .. var1_14:getConfig("target_num") .. ")"

		setText(arg1_14:Find("unlock/desc/task_bg/Text"), shortenString(var2_14, 10))
	end
end

function var0_0.GetList(arg0_15)
	local var0_15 = getProxy(PlayerProxy):getRawData()
	local var1_15 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_15.level, "TechnologyMediator")

	return arg0_15.list, var1_15 and TechnologyConst.QUEUE_TOTAL_COUNT + 1 or 0
end

function var0_0.OnSkip(arg0_16)
	arg0_16:emit(CommissionInfoMediator.ON_ACTIVE_TECH)
end

function var0_0.OnFinishAll(arg0_17)
	local var0_17 = getProxy(TechnologyProxy)

	if var0_17.queue[1] and var0_17.queue[1]:isCompleted() then
		arg0_17:emit(CommissionInfoMediator.ON_TECH_QUEUE_FINISH)
	else
		local var1_17 = var0_17:getActivateTechnology()

		arg0_17:emit(CommissionInfoMediator.ON_TECH_FINISHED, {
			id = var1_17.id,
			pool_id = var1_17.poolId
		})
	end
end

return var0_0
