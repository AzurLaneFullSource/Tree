local var0_0 = class("YidaliMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	arg0_1:initUI()
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)

	arg0_2.fight = arg0_2:findTF("fight", arg0_2.btnList)

	onButton(arg0_2, arg0_2.fight, function()
		arg0_2:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)

	arg0_2.build = arg0_2:findTF("build", arg0_2.btnList)

	onButton(arg0_2, arg0_2.build, function()
		local var0_4
		local var1_4

		if arg0_2.activity:getConfig("config_client") ~= "" then
			var0_4 = arg0_2.activity:getConfig("config_client").linkActID

			if var0_4 then
				var1_4 = getProxy(ActivityProxy):getActivityById(var0_4)
			end
		end

		if not var0_4 then
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		elseif var1_4 and not var1_4:isEnd() then
			arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	arg0_2:initData()
	arg0_2:submitFinishedTask()
end

function var0_0.OnUpdateFlush(arg0_5)
	arg0_5:updateAwardBtn()
end

function var0_0.initData(arg0_6)
	arg0_6.finalTaskID = arg0_6.activity:getConfig("config_client")[1]
	arg0_6.YDLtaskIDList = arg0_6.activity:getConfig("config_data")
	arg0_6.taskIDList = Clone(pg.task_data_template[arg0_6.finalTaskID].target_id)
	arg0_6.taskProxy = getProxy(TaskProxy)
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

	print("final taskid:" .. arg0_8.finalTaskID)
	print("task status:" .. var0_8)

	if var0_8 == 0 then
		setActive(arg0_8.activeTF, true)
		setActive(arg0_8.finishedTF, false)
		setActive(arg0_8.achievedTF, false)
	elseif var0_8 == 1 then
		setActive(arg0_8.activeTF, false)
		setActive(arg0_8.finishedTF, true)
		setActive(arg0_8.achievedTF, false)
		onButton(arg0_8, arg0_8.awardTF, function()
			local var0_9 = arg0_8.taskProxy:getTaskVO(arg0_8.finalTaskID)

			arg0_8:emit(ActivityMediator.ON_TASK_SUBMIT, var0_9)
		end, SFX_PANEL)
	elseif var0_8 == 2 then
		setActive(arg0_8.activeTF, false)
		setActive(arg0_8.finishedTF, false)
		setActive(arg0_8.achievedTF, true)
		onButton(arg0_8, arg0_8.awardTF, function()
			return
		end, SFX_PANEL)
	end
end

function var0_0.submitFinishedTask(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.YDLtaskIDList) do
		local var0_11 = arg0_11.taskProxy:getTaskById(iter1_11)

		if var0_11 and var0_11:isFinish() and not var0_11:isReceive() then
			print("!!!!!!!!!!!!!20190907!!!!!!!YDLtaskIDList emit:" .. iter1_11)
			arg0_11:emit(ActivityMediator.ON_TASK_SUBMIT, var0_11)
		end
	end
end

function var0_0.getFinalTaskStatus(arg0_12)
	return arg0_12.taskProxy:getTaskVO(arg0_12.finalTaskID):getTaskStatus()
end

return var0_0
