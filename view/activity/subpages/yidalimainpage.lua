local var0 = class("YidaliMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	arg0:initUI()
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	arg0.fight = arg0:findTF("fight", arg0.btnList)

	onButton(arg0, arg0.fight, function()
		arg0:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)

	arg0.build = arg0:findTF("build", arg0.btnList)

	onButton(arg0, arg0.build, function()
		local var0
		local var1

		if arg0.activity:getConfig("config_client") ~= "" then
			var0 = arg0.activity:getConfig("config_client").linkActID

			if var0 then
				var1 = getProxy(ActivityProxy):getActivityById(var0)
			end
		end

		if not var0 then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		elseif var1 and not var1:isEnd() then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end, SFX_PANEL)
	arg0:initData()
	arg0:submitFinishedTask()
end

function var0.OnUpdateFlush(arg0)
	arg0:updateAwardBtn()
end

function var0.initData(arg0)
	arg0.finalTaskID = arg0.activity:getConfig("config_client")[1]
	arg0.YDLtaskIDList = arg0.activity:getConfig("config_data")
	arg0.taskIDList = Clone(pg.task_data_template[arg0.finalTaskID].target_id)
	arg0.taskProxy = getProxy(TaskProxy)
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

	print("final taskid:" .. arg0.finalTaskID)
	print("task status:" .. var0)

	if var0 == 0 then
		setActive(arg0.activeTF, true)
		setActive(arg0.finishedTF, false)
		setActive(arg0.achievedTF, false)
	elseif var0 == 1 then
		setActive(arg0.activeTF, false)
		setActive(arg0.finishedTF, true)
		setActive(arg0.achievedTF, false)
		onButton(arg0, arg0.awardTF, function()
			local var0 = arg0.taskProxy:getTaskVO(arg0.finalTaskID)

			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)
		end, SFX_PANEL)
	elseif var0 == 2 then
		setActive(arg0.activeTF, false)
		setActive(arg0.finishedTF, false)
		setActive(arg0.achievedTF, true)
		onButton(arg0, arg0.awardTF, function()
			return
		end, SFX_PANEL)
	end
end

function var0.submitFinishedTask(arg0)
	for iter0, iter1 in ipairs(arg0.YDLtaskIDList) do
		local var0 = arg0.taskProxy:getTaskById(iter1)

		if var0 and var0:isFinish() and not var0:isReceive() then
			print("!!!!!!!!!!!!!20190907!!!!!!!YDLtaskIDList emit:" .. iter1)
			arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)
		end
	end
end

function var0.getFinalTaskStatus(arg0)
	return arg0.taskProxy:getTaskVO(arg0.finalTaskID):getTaskStatus()
end

return var0
