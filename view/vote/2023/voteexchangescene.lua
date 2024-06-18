local var0_0 = class("VoteExchangeScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "VoteExchangeUI"
end

function var0_0.init(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("blur_panel/adapt/top/back_btn")
	arg0_2.dailyTask = arg0_2:findTF("left/task/slider/bar")
	arg0_2.dailyTaskTxt = arg0_2:findTF("left/task/Text"):GetComponent(typeof(Text))
	arg0_2.timeTxt = arg0_2:findTF("right/title/Text/Text"):GetComponent(typeof(Text))
	arg0_2.dailyTaskGoBtn = arg0_2:findTF("left/go")
	arg0_2.totalCntTxt = arg0_2:findTF("right/total/Text"):GetComponent(typeof(Text))
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("right/view/content"), arg0_2:findTF("right/view/content/tpl"))
	arg0_2.taskContainer = arg0_2:findTF("right/view")
	arg0_2.emptyTr = arg0_2:findTF("right/empty")

	setText(arg0_2:findTF("left/bg/Text"), i18n("vote_lable_daily_task_title"))

	local var0_2 = string.split(i18n("vote_lable_daily_task_tip"), "$1")

	setText(arg0_2:findTF("left/task/desc/label1"), var0_2[1])
	setText(arg0_2:findTF("left/task/desc/labe2"), var0_2[2])
	setText(arg0_2:findTF("right/title/Text"), i18n("vote_lable_task_title"))
	setText(arg0_2.emptyTr:Find("Image/Text"), i18n("vote_lable_task_list_is_empty"))
end

function var0_0.didEnter(arg0_3)
	assert(arg0_3.contextData.voteGroup)
	onButton(arg0_3, arg0_3.dailyTaskGoBtn, function()
		arg0_3:emit(VoteExchangeMediator.GO_TASK)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)

	arg0_3.taskList = arg0_3:GetTaskList()
	arg0_3.dailyTaskList = arg0_3:GetDailyTaskList()

	arg0_3:Flush()
end

function var0_0.Flush(arg0_6)
	arg0_6:UpdateDailyTask()
	arg0_6:UpdateTitle()
	arg0_6:UpdateTicket()
	arg0_6:UpdateTaskList()
end

function var0_0.UpdateTitle(arg0_7)
	local var0_7 = arg0_7.contextData.voteGroup:getConfig("name")
	local var1_7 = arg0_7.contextData.voteGroup:getTimeDesc()

	arg0_7.timeTxt.text = var0_7 .. " " .. var1_7
end

function var0_0.GetActivity(arg0_8)
	local var0_8 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)
	local var1_8

	for iter0_8, iter1_8 in ipairs(var0_8) do
		if iter1_8:getConfig("config_id") == arg0_8.contextData.voteGroup.configId then
			var1_8 = iter1_8

			break
		end
	end

	return var1_8
end

function var0_0.UpdateTicket(arg0_9)
	local var0_9 = arg0_9:GetActivity()

	if var0_9 then
		local var1_9 = arg0_9.contextData.voteGroup:getConfig("ticket_period")

		arg0_9.totalCntTxt.text = var0_9.data3 .. "/" .. var1_9
	else
		arg0_9.totalCntTxt.text = ""
	end
end

function var0_0.GetTaskList(arg0_10)
	local var0_10 = arg0_10:GetActivity()

	if var0_10 and var0_10.data3 >= arg0_10.contextData.voteGroup:getConfig("ticket_period") then
		return {}
	end

	local var1_10 = Clone(arg0_10.contextData.voteGroup:getConfig("task_period"))
	local var2_10 = getProxy(TaskProxy)

	for iter0_10 = #var1_10, 1, -1 do
		local var3_10 = var1_10[iter0_10]

		for iter1_10 = #var3_10, 1, -1 do
			local var4_10 = var3_10[iter1_10]
			local var5_10 = var2_10:getTaskById(var4_10) or var2_10:getFinishTaskById(var4_10)

			if not var5_10 or var5_10:isFinish() and var5_10:isReceive() then
				table.remove(var3_10, iter1_10)
			end
		end

		if #var3_10 <= 0 then
			table.remove(var1_10, iter0_10)
		end
	end

	return var1_10
end

function var0_0.GetDailyTaskList(arg0_11)
	return (arg0_11.contextData.voteGroup:getConfig("task_daily"))
end

function var0_0.UpdateDailyTask(arg0_12)
	local var0_12 = 0
	local var1_12 = getProxy(TaskProxy)

	for iter0_12, iter1_12 in ipairs(arg0_12.dailyTaskList) do
		local var2_12 = var1_12:getTaskById(iter1_12) or var1_12:getFinishTaskById(iter1_12)

		if var2_12 and var2_12:isFinish() and var2_12:isReceive() then
			var0_12 = var0_12 + 1
		end
	end

	arg0_12.dailyTaskTxt.text = var0_12 .. "/" .. #arg0_12.dailyTaskList

	setFillAmount(arg0_12.dailyTask, var0_12 / #arg0_12.dailyTaskList)
end

function var0_0.UpdateTaskList(arg0_13)
	arg0_13.uiItemList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			arg0_13:UpdateTaskCard(arg0_13.taskList[arg1_14 + 1], arg2_14)
		end
	end)
	arg0_13.uiItemList:align(#arg0_13.taskList)

	local var0_13 = #arg0_13.taskList <= 0

	setActive(arg0_13.emptyTr, var0_13)
	setActive(arg0_13.taskContainer, not var0_13)
end

function var0_0.UpdateTaskCard(arg0_15, arg1_15, arg2_15)
	local var0_15 = UIItemList.New(arg2_15:Find("content"), arg2_15:Find("content/extend_tpl"))

	var0_15:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			arg0_15:UpdateTaskDesc(arg1_15[arg1_16 + 2], arg2_16)
		end
	end)
	var0_15:align(#arg1_15 - 1)
	arg0_15:UpdateTaskDesc(arg1_15[1], arg2_15:Find("info"))
end

function var0_0.UpdateTaskDesc(arg0_17, arg1_17, arg2_17)
	local var0_17 = getProxy(TaskProxy):getTaskById(arg1_17) or getProxy(TaskProxy):getFinishTaskById(arg1_17)

	assert(var0_17, arg1_17)

	local var1_17 = var0_17:isFinish()
	local var2_17 = var0_17:isReceive()
	local var3_17 = arg2_17:Find("go")
	local var4_17 = arg2_17:Find("get")

	setActive(var3_17, not var1_17)
	setActive(arg2_17:Find("got"), var1_17 and var2_17)
	setActive(var4_17, var1_17 and not var2_17)

	local var5_17 = var0_17:getConfig("award_display")

	updateDrop(arg2_17:Find("IconTpl"), {
		type = var5_17[1][1],
		id = var5_17[1][2],
		count = var5_17[1][3]
	})

	local var6_17 = var0_17:getProgress()
	local var7_17 = var0_17:getConfig("target_num")

	setText(arg2_17:Find("Text"), var6_17 .. "/" .. var7_17)
	setText(arg2_17:Find("desc"), var0_17:getConfig("desc"))
	setFillAmount(arg2_17:Find("Slider/Fill"), var6_17 / var7_17)
	onButton(arg0_17, var3_17, function()
		arg0_17:emit(VoteExchangeMediator.SKIP_TASK, var0_17)
	end, SFX_PANEL)
	onButton(arg0_17, var4_17, function()
		arg0_17:emit(VoteExchangeMediator.SUBMIT_TASK, var0_17.id)
	end, SFX_PANEL)
end

function var0_0.onBackPressed(arg0_20)
	var0_0.super.onBackPressed(arg0_20)
end

function var0_0.willExit(arg0_21)
	return
end

return var0_0
