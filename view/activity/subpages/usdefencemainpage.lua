local var0 = class("USDefenceMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	arg0:initUI()
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	arg0:initData()
	arg0:submitFinishedTask()
end

function var0.OnDataSetting(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	arg0:updateAwardBtn()
end

function var0.OnDestroy(arg0)
	return
end

function var0.initData(arg0)
	arg0.finalTaskID = arg0.activity:getConfig("config_client")[1]
	arg0.taskIDList = Clone(pg.task_data_template[arg0.finalTaskID].target_id)
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskListView = USDefTaskWindowView.New(arg0.subViewContainer, arg0.event, arg0.activity)
end

function var0.initUI(arg0)
	arg0.awardTF = arg0:findTF("Item", arg0.bg)
	arg0.activeTF = arg0:findTF("Active", arg0.awardTF)
	arg0.finishedTF = arg0:findTF("Finished", arg0.awardTF)
	arg0.achievedTF = arg0:findTF("Achieved", arg0.awardTF)

	setActive(arg0.activeTF, false)
	setActive(arg0.finishedTF, false)
	setActive(arg0.achievedTF, false)

	arg0.achievementBtn = arg0:findTF("AchieveMentBtn", arg0.bg)
	arg0.subViewContainer = arg0:findTF("SubViewContainer")
end

function var0.updateAwardBtn(arg0)
	local var0 = arg0:getFinalTaskStatus()

	if var0 == 0 then
		setActive(arg0.activeTF, true)
		setActive(arg0.finishedTF, false)
		setActive(arg0.achievedTF, false)
		onButton(arg0, arg0.awardTF, function()
			arg0.taskListView:Load()
		end, SFX_PANEL)
		onButton(arg0, arg0.achievementBtn, function()
			arg0.taskListView:Load()
		end, SFX_PANEL)
	elseif var0 == 1 then
		setActive(arg0.activeTF, false)
		setActive(arg0.finishedTF, true)
		setActive(arg0.achievedTF, false)
		onButton(arg0, arg0.awardTF, function()
			local var0 = arg0.taskProxy:getTaskVO(arg0.finalTaskID)

			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)
		end, SFX_PANEL)
		onButton(arg0, arg0.achievementBtn, function()
			local var0 = arg0.taskProxy:getTaskVO(arg0.finalTaskID)

			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)
		end, SFX_PANEL)
	elseif var0 == 2 then
		setActive(arg0.activeTF, false)
		setActive(arg0.finishedTF, false)
		setActive(arg0.achievedTF, true)
		setButtonEnabled(arg0.awardTF, false)
		setButtonEnabled(arg0.achievementBtn, false)
	end
end

function var0.submitFinishedTask(arg0)
	for iter0, iter1 in ipairs(arg0.taskIDList) do
		local var0 = arg0.taskProxy:getTaskById(iter1)

		if var0 and var0:isFinish() then
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)
		end
	end
end

function var0.getFinalTaskStatus(arg0)
	return arg0.taskProxy:getTaskVO(arg0.finalTaskID):getTaskStatus()
end

return var0
