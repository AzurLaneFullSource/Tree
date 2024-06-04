local var0 = class("CommissionInfoTechnologyItem", import(".CommissionInfoItem"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.commingTF = arg0._tf:Find("comming")
	arg0.techFrame = arg0._tf:Find("frame")
	arg0.lockTF = arg0._tf:Find("lock")

	setActive(arg0.lockTF, false)
	setText(arg0.lockTF:Find("Text"), i18n("commission_label_unlock_tech_tip"))
end

function var0.CanOpen(arg0)
	return getProxy(PlayerProxy):getData().level >= 30 and not LOCK_TECHNOLOGY
end

function var0.Init(arg0)
	if LOCK_TECHNOLOGY then
		setActive(arg0._tf:Find("frame"), false)
		setActive(arg0.lockTF, false)
		setActive(arg0.commingTF, true)
	else
		setActive(arg0._tf:Find("frame"), true)
		setActive(arg0.lockTF, false)
		setActive(arg0.commingTF, false)

		local var0 = arg0:CanOpen()

		setActive(arg0.lockTF, not var0)
		setGray(arg0.toggle, not var0, true)
		setActive(arg0.foldFlag, false)
		setActive(arg0.goBtn, var0)
		var0.super.Init(arg0)
	end
end

function var0.OnFlush(arg0)
	local var0 = getProxy(TechnologyProxy):getPlanningTechnologys()

	arg0.list = {}

	local var1 = {
		ongoing = 0,
		finished = 0,
		leisure = TechnologyConst.QUEUE_TOTAL_COUNT + 1
	}

	for iter0, iter1 in ipairs(var0) do
		if iter1:isCompleted() then
			var1.leisure = var1.leisure - 1
			var1.finished = var1.finished + 1
		elseif iter1:isActivate() then
			var1.leisure = var1.leisure - 1
			var1.ongoing = var1.ongoing + 1
		end
	end

	eachChild(arg0._tf:Find("frame/counter"), function(arg0)
		setActive(arg0, var1[arg0.name] > 0)
		setText(arg0:Find("Text"), var1[arg0.name])
	end)
	setActive(arg0.goBtn, var1.finished == 0)
	setActive(arg0.finishedBtn, var1.finished > 0)
end

function var0.UpdateListItem(arg0, arg1, arg2, arg3)
	local var0 = arg2
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = var0:getConfig("time")
	local var3 = var0.time

	if var3 == 0 then
		setText(arg3:Find("unlock/desc/name_bg/Text"), i18n("commission_idle"))
		onButton(arg0, arg3:Find("unlock/leisure/go_btn"), function()
			arg0:OnSkip()
		end, SFX_PANEL)
		onButton(arg0, arg3, function()
			arg0:OnSkip()
		end, SFX_PANEL)
	elseif var1 < var3 - var2 then
		arg0:UpdateTechnology(arg3, var0)
		setText(arg3:Find("unlock/ongoging/time"), pg.TimeMgr.GetInstance():DescCDTime(var2))
	elseif var1 < var3 then
		arg0:UpdateTechnology(arg3, var0)
		arg0:AddTimer(var0, arg3)
	else
		arg0:UpdateTechnology(arg3, var0)

		if var0:finishCondition() then
			local var4 = arg3:Find("unlock/finished/finish_btn")

			onButton(arg0, var4, function()
				arg0:emit(CommissionInfoMediator.ON_TECH_FINISHED, {
					id = var0.id,
					pool_id = var0.poolId
				})
			end, SFX_PANEL)
			onButton(arg0, arg3, function()
				triggerButton(var4)
			end, SFX_PANEL)
		else
			setText(arg3:Find("unlock/ongoging/time"), "00:00:00")
		end
	end

	setActive(arg3:Find("unlock"), true)
	setActive(arg3:Find("lock"), false)
	setActive(arg3:Find("unlock/leisure"), not var0:isActivate())
	setActive(arg3:Find("unlock/ongoging"), var0:isActivate() and not var0:isCompleted())
	setActive(arg3:Find("unlock/finished"), var0:isCompleted())
	setActive(arg3:Find("unlock/desc/task_bg"), var0:isActivate() and var0:getConfig("condition") > 0)
end

function var0.AddTimer(arg0, arg1, arg2)
	local var0 = arg2:Find("unlock/ongoging/time"):GetComponent(typeof(Text))

	arg0.timers[arg1.id] = Timer.New(function()
		local var0 = arg1:getFinishTime() - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 > 0 then
			var0.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
		else
			arg0:RemoveTimer(arg1)
			arg0:OnFlush()
			arg0:UpdateList()
		end
	end, 1, -1)

	arg0.timers[arg1.id]:Start()
	arg0.timers[arg1.id].func()
end

function var0.RemoveTimer(arg0, arg1)
	if arg0.timers[arg1.id] then
		arg0.timers[arg1.id]:Stop()

		arg0.timers[arg1.id] = nil
	end
end

function var0.UpdateTechnology(arg0, arg1, arg2)
	setText(arg1:Find("unlock/desc/name_bg/Text"), arg2:getConfig("name"))

	local var0 = arg2:getConfig("condition")

	if var0 > 0 then
		local var1 = getProxy(TaskProxy):getTaskVO(var0)
		local var2 = var1:getConfig("desc") .. "(" .. var1:getProgress() .. "/" .. var1:getConfig("target_num") .. ")"

		setText(arg1:Find("unlock/desc/task_bg/Text"), shortenString(var2, 10))
	end
end

function var0.GetList(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0.level, "TechnologyMediator")

	return arg0.list, var1 and TechnologyConst.QUEUE_TOTAL_COUNT + 1 or 0
end

function var0.OnSkip(arg0)
	arg0:emit(CommissionInfoMediator.ON_ACTIVE_TECH)
end

function var0.OnFinishAll(arg0)
	local var0 = getProxy(TechnologyProxy)

	if var0.queue[1] and var0.queue[1]:isCompleted() then
		arg0:emit(CommissionInfoMediator.ON_TECH_QUEUE_FINISH)
	else
		local var1 = var0:getActivateTechnology()

		arg0:emit(CommissionInfoMediator.ON_TECH_FINISHED, {
			id = var1.id,
			pool_id = var1.poolId
		})
	end
end

return var0
