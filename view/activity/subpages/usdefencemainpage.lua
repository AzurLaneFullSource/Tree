local var0_0 = class("USDefenceMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	arg0_1:initUI()
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	arg0_2:initData()
	arg0_2:submitFinishedTask()
end

function var0_0.OnDataSetting(arg0_3)
	return
end

function var0_0.OnUpdateFlush(arg0_4)
	arg0_4:updateAwardBtn()
end

function var0_0.OnDestroy(arg0_5)
	return
end

function var0_0.initData(arg0_6)
	arg0_6.finalTaskID = arg0_6.activity:getConfig("config_client")[1]
	arg0_6.taskIDList = Clone(pg.task_data_template[arg0_6.finalTaskID].target_id)
	arg0_6.taskProxy = getProxy(TaskProxy)
	arg0_6.taskListView = USDefTaskWindowView.New(arg0_6.subViewContainer, arg0_6.event, arg0_6.activity)
end

function var0_0.initUI(arg0_7)
	arg0_7.awardTF = arg0_7:findTF("Item", arg0_7.bg)
	arg0_7.activeTF = arg0_7:findTF("Active", arg0_7.awardTF)
	arg0_7.finishedTF = arg0_7:findTF("Finished", arg0_7.awardTF)
	arg0_7.achievedTF = arg0_7:findTF("Achieved", arg0_7.awardTF)

	setActive(arg0_7.activeTF, false)
	setActive(arg0_7.finishedTF, false)
	setActive(arg0_7.achievedTF, false)

	arg0_7.achievementBtn = arg0_7:findTF("AchieveMentBtn", arg0_7.bg)
	arg0_7.subViewContainer = arg0_7:findTF("SubViewContainer")
end

function var0_0.updateAwardBtn(arg0_8)
	local var0_8 = arg0_8:getFinalTaskStatus()

	if var0_8 == 0 then
		setActive(arg0_8.activeTF, true)
		setActive(arg0_8.finishedTF, false)
		setActive(arg0_8.achievedTF, false)
		onButton(arg0_8, arg0_8.awardTF, function()
			arg0_8.taskListView:Load()
		end, SFX_PANEL)
		onButton(arg0_8, arg0_8.achievementBtn, function()
			arg0_8.taskListView:Load()
		end, SFX_PANEL)
	elseif var0_8 == 1 then
		setActive(arg0_8.activeTF, false)
		setActive(arg0_8.finishedTF, true)
		setActive(arg0_8.achievedTF, false)
		onButton(arg0_8, arg0_8.awardTF, function()
			local var0_11 = arg0_8.taskProxy:getTaskVO(arg0_8.finalTaskID)

			arg0_8:emit(ActivityMediator.ON_TASK_SUBMIT, var0_11)
		end, SFX_PANEL)
		onButton(arg0_8, arg0_8.achievementBtn, function()
			local var0_12 = arg0_8.taskProxy:getTaskVO(arg0_8.finalTaskID)

			arg0_8:emit(ActivityMediator.ON_TASK_SUBMIT, var0_12)
		end, SFX_PANEL)
	elseif var0_8 == 2 then
		setActive(arg0_8.activeTF, false)
		setActive(arg0_8.finishedTF, false)
		setActive(arg0_8.achievedTF, true)
		setButtonEnabled(arg0_8.awardTF, false)
		setButtonEnabled(arg0_8.achievementBtn, false)
	end
end

function var0_0.submitFinishedTask(arg0_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.taskIDList) do
		local var0_13 = arg0_13.taskProxy:getTaskById(iter1_13)

		if var0_13 and var0_13:isFinish() then
			arg0_13:emit(ActivityMediator.ON_TASK_SUBMIT, var0_13)
		end
	end
end

function var0_0.getFinalTaskStatus(arg0_14)
	return arg0_14.taskProxy:getTaskVO(arg0_14.finalTaskID):getTaskStatus()
end

return var0_0
