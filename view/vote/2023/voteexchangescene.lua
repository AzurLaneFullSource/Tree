local var0 = class("VoteExchangeScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "VoteExchangeUI"
end

function var0.init(arg0)
	arg0.closeBtn = arg0:findTF("blur_panel/adapt/top/back_btn")
	arg0.dailyTask = arg0:findTF("left/task/slider/bar")
	arg0.dailyTaskTxt = arg0:findTF("left/task/Text"):GetComponent(typeof(Text))
	arg0.timeTxt = arg0:findTF("right/title/Text/Text"):GetComponent(typeof(Text))
	arg0.dailyTaskGoBtn = arg0:findTF("left/go")
	arg0.totalCntTxt = arg0:findTF("right/total/Text"):GetComponent(typeof(Text))
	arg0.uiItemList = UIItemList.New(arg0:findTF("right/view/content"), arg0:findTF("right/view/content/tpl"))
	arg0.taskContainer = arg0:findTF("right/view")
	arg0.emptyTr = arg0:findTF("right/empty")

	setText(arg0:findTF("left/bg/Text"), i18n("vote_lable_daily_task_title"))

	local var0 = string.split(i18n("vote_lable_daily_task_tip"), "$1")

	setText(arg0:findTF("left/task/desc/label1"), var0[1])
	setText(arg0:findTF("left/task/desc/labe2"), var0[2])
	setText(arg0:findTF("right/title/Text"), i18n("vote_lable_task_title"))
	setText(arg0.emptyTr:Find("Image/Text"), i18n("vote_lable_task_list_is_empty"))
end

function var0.didEnter(arg0)
	assert(arg0.contextData.voteGroup)
	onButton(arg0, arg0.dailyTaskGoBtn, function()
		arg0:emit(VoteExchangeMediator.GO_TASK)
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_PANEL)

	arg0.taskList = arg0:GetTaskList()
	arg0.dailyTaskList = arg0:GetDailyTaskList()

	arg0:Flush()
end

function var0.Flush(arg0)
	arg0:UpdateDailyTask()
	arg0:UpdateTitle()
	arg0:UpdateTicket()
	arg0:UpdateTaskList()
end

function var0.UpdateTitle(arg0)
	local var0 = arg0.contextData.voteGroup:getConfig("name")
	local var1 = arg0.contextData.voteGroup:getTimeDesc()

	arg0.timeTxt.text = var0 .. " " .. var1
end

function var0.GetActivity(arg0)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)
	local var1

	for iter0, iter1 in ipairs(var0) do
		if iter1:getConfig("config_id") == arg0.contextData.voteGroup.configId then
			var1 = iter1

			break
		end
	end

	return var1
end

function var0.UpdateTicket(arg0)
	local var0 = arg0:GetActivity()

	if var0 then
		local var1 = arg0.contextData.voteGroup:getConfig("ticket_period")

		arg0.totalCntTxt.text = var0.data3 .. "/" .. var1
	else
		arg0.totalCntTxt.text = ""
	end
end

function var0.GetTaskList(arg0)
	local var0 = arg0:GetActivity()

	if var0 and var0.data3 >= arg0.contextData.voteGroup:getConfig("ticket_period") then
		return {}
	end

	local var1 = Clone(arg0.contextData.voteGroup:getConfig("task_period"))
	local var2 = getProxy(TaskProxy)

	for iter0 = #var1, 1, -1 do
		local var3 = var1[iter0]

		for iter1 = #var3, 1, -1 do
			local var4 = var3[iter1]
			local var5 = var2:getTaskById(var4) or var2:getFinishTaskById(var4)

			if not var5 or var5:isFinish() and var5:isReceive() then
				table.remove(var3, iter1)
			end
		end

		if #var3 <= 0 then
			table.remove(var1, iter0)
		end
	end

	return var1
end

function var0.GetDailyTaskList(arg0)
	return (arg0.contextData.voteGroup:getConfig("task_daily"))
end

function var0.UpdateDailyTask(arg0)
	local var0 = 0
	local var1 = getProxy(TaskProxy)

	for iter0, iter1 in ipairs(arg0.dailyTaskList) do
		local var2 = var1:getTaskById(iter1) or var1:getFinishTaskById(iter1)

		if var2 and var2:isFinish() and var2:isReceive() then
			var0 = var0 + 1
		end
	end

	arg0.dailyTaskTxt.text = var0 .. "/" .. #arg0.dailyTaskList

	setFillAmount(arg0.dailyTask, var0 / #arg0.dailyTaskList)
end

function var0.UpdateTaskList(arg0)
	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTaskCard(arg0.taskList[arg1 + 1], arg2)
		end
	end)
	arg0.uiItemList:align(#arg0.taskList)

	local var0 = #arg0.taskList <= 0

	setActive(arg0.emptyTr, var0)
	setActive(arg0.taskContainer, not var0)
end

function var0.UpdateTaskCard(arg0, arg1, arg2)
	local var0 = UIItemList.New(arg2:Find("content"), arg2:Find("content/extend_tpl"))

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTaskDesc(arg1[arg1 + 2], arg2)
		end
	end)
	var0:align(#arg1 - 1)
	arg0:UpdateTaskDesc(arg1[1], arg2:Find("info"))
end

function var0.UpdateTaskDesc(arg0, arg1, arg2)
	local var0 = getProxy(TaskProxy):getTaskById(arg1) or getProxy(TaskProxy):getFinishTaskById(arg1)

	assert(var0, arg1)

	local var1 = var0:isFinish()
	local var2 = var0:isReceive()
	local var3 = arg2:Find("go")
	local var4 = arg2:Find("get")

	setActive(var3, not var1)
	setActive(arg2:Find("got"), var1 and var2)
	setActive(var4, var1 and not var2)

	local var5 = var0:getConfig("award_display")

	updateDrop(arg2:Find("IconTpl"), {
		type = var5[1][1],
		id = var5[1][2],
		count = var5[1][3]
	})

	local var6 = var0:getProgress()
	local var7 = var0:getConfig("target_num")

	setText(arg2:Find("Text"), var6 .. "/" .. var7)
	setText(arg2:Find("desc"), var0:getConfig("desc"))
	setFillAmount(arg2:Find("Slider/Fill"), var6 / var7)
	onButton(arg0, var3, function()
		arg0:emit(VoteExchangeMediator.SKIP_TASK, var0)
	end, SFX_PANEL)
	onButton(arg0, var4, function()
		arg0:emit(VoteExchangeMediator.SUBMIT_TASK, var0.id)
	end, SFX_PANEL)
end

function var0.onBackPressed(arg0)
	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	return
end

return var0
