local var0_0 = class("ShipTaskLotteryPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.stepText = findTF(arg0_1._tf, "ad/step")
	arg0_1.progressSlider = findTF(arg0_1._tf, "ad/progressSlider")
	arg0_1.iconTf = findTF(arg0_1._tf, "ad/IconTpl")
	arg0_1.btnGet = findTF(arg0_1._tf, "ad/btnGet")
	arg0_1.btnGot = findTF(arg0_1._tf, "ad/btnGot")
	arg0_1.btnGo = findTF(arg0_1._tf, "ad/btnGo")
	arg0_1.taskDesc = findTF(arg0_1._tf, "ad/taskDesc")
	arg0_1.titleDesc = findTF(arg0_1._tf, "ad/titleDesc")
	arg0_1.progressDesc = findTF(arg0_1._tf, "ad/progressDesc")

	onButton(arg0_1, arg0_1.btnGet, function()
		if arg0_1.currentTask then
			arg0_1:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_1.currentTask)
		end
	end, SFX_CONFIRM)
	onButton(arg0_1, arg0_1.btnGo, function()
		if arg0_1.currentTask then
			arg0_1:emit(ActivityMediator.ON_TASK_GO, arg0_1.currentTask)
		end
	end, SFX_CONFIRM)
	onButton(arg0_1, arg0_1.iconTf, function()
		arg0_1:emit(BaseUI.ON_DROP, arg0_1.drop)
	end, SFX_PANEL)
	setText(arg0_1.titleDesc, i18n("ship_task_lottery_title"))
end

function var0_0.OnFirstFlush(arg0_5)
	arg0_5.taskIds = arg0_5.activity:getConfig("config_data")

	arg0_5:updateUI()
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6:updateUI()
end

function var0_0.updateUI(arg0_7)
	local var0_7

	for iter0_7 = 1, #arg0_7.taskIds do
		if not var0_7 then
			var0_7 = getProxy(TaskProxy):getTaskById(arg0_7.taskIds[iter0_7])

			if var0_7 then
				break
			end
		end
	end

	if not var0_7 then
		for iter1_7 = #arg0_7.taskIds, 1, -1 do
			var0_7 = getProxy(TaskProxy):getFinishTaskById(arg0_7.taskIds[iter1_7])

			if var0_7 then
				break
			end
		end
	end

	if var0_7 then
		arg0_7.currentTask = var0_7

		arg0_7:showTaskUI()
	end
end

function var0_0.showTaskUI(arg0_8)
	local var0_8 = arg0_8.currentTask:getConfig("award_display")

	arg0_8.drop = {
		type = var0_8[1][1],
		id = var0_8[1][2],
		count = var0_8[1][3]
	}

	updateDrop(arg0_8.iconTf, arg0_8.drop)
	setText(arg0_8.taskDesc, arg0_8.currentTask:getConfig("desc"))
	setText(arg0_8.progressDesc, arg0_8.currentTask:getProgress() .. "/" .. arg0_8.currentTask:getConfig("target_num"))
	setSlider(arg0_8.progressSlider, 0, arg0_8.currentTask:getConfig("target_num"), arg0_8.currentTask:getProgress())
	setActive(arg0_8.btnGet, arg0_8.currentTask:getTaskStatus() == 1)
	setActive(arg0_8.btnGo, arg0_8.currentTask:getTaskStatus() == 0)
	setActive(arg0_8.btnGot, arg0_8.currentTask:getTaskStatus() == 2)
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
