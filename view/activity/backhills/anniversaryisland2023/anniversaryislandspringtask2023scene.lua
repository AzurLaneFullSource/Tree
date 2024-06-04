local var0 = class("AnniversaryIslandSpringTask2023Scene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "AnniversaryIslandSpringTask2023UI"
end

function var0.init(arg0)
	local var0 = arg0._tf:Find("TaskList/ScrollView")

	arg0.taskListRect = GetComponent(var0, "LScrollRect")

	function arg0.taskListRect.onUpdateItem(arg0, arg1)
		arg0:UpdateTaskListItem(arg0, arg1)
	end

	setText(arg0._tf:Find("Desc/Text"), i18n("springtask_tip"))
	setActive(arg0._tf:Find("Top/Help"), false)
end

function var0.BuildTaskVOs(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)
	local var1 = var0:GetUnlockTaskIds()
	local var2 = var0:GetConfigID()

	arg0.activityId = var2

	local var3 = getProxy(ActivityTaskProxy):getTaskVOsByActId(var2)

	arg0.lockTasks = {}
	arg0.taskVOs = _.map(var1, function(arg0)
		local var0 = _.detect(var3, function(arg0)
			return arg0:GetConfigID() == arg0
		end)

		if not var0 then
			var0 = ActivityTask.New(var2, {
				id = arg0
			})
			arg0.lockTasks[var0] = true
		end

		return var0
	end)

	local var4 = CompareFuncs({
		function(arg0)
			return arg0:isOver() and 1 or 0
		end,
		function(arg0)
			return arg0.lockTasks[arg0] and 1 or 0
		end,
		function(arg0)
			return arg0:GetConfigID()
		end
	})

	table.sort(arg0.taskVOs, var4)
end

function var0.UpdateTaskListItem(arg0, arg1, arg2)
	arg1 = arg1 + 1

	local var0 = tf(arg2)
	local var1 = arg0.taskVOs[arg1]
	local var2 = var1:GetConfigID()
	local var3 = pg.task_data_template[var2]
	local var4 = var1:isFinish()
	local var5 = var1:isOver()
	local var6 = var1:isSubmit()
	local var7 = var3.award_display
	local var8 = var1:getProgress()
	local var9 = var1:getTargetNumber()

	setActive(var0:Find("Lock"), arg0.lockTasks[var1])
	setText(var0:Find("BG/Progress"), var8 .. "/" .. var9)
	setSlider(var0:Find("BG/ProgressBar"), 0, var9, var8)
	changeToScrollText(var0:Find("BG/Name/Text"), var3.name)
	setActive(var0:Find("BG/Go"), not var5 and not var4)
	setActive(var0:Find("BG/Commit"), not var5 and var4 and var6)
	setActive(var0:Find("BG/Reward"), not var5 and var4 and not var6)
	setActive(var0:Find("BG/Got"), var5)
	UIItemList.StaticAlign(var0:Find("BG/Items"), var0:Find("BG/Items"):GetChild(0), #var7, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var7[arg1 + 1]
		local var1 = {
			type = var0[1],
			id = var0[2],
			count = var0[3]
		}

		updateDrop(arg2:Find("Icon"), var1)
		onButton(arg0, arg2, function()
			arg0:emit(BaseUI.ON_DROP, var1)
		end)
		setActive(arg2:Find("Completed"), var5)
	end)
	onButton(arg0, var0:Find("BG/Go"), function()
		arg0:emit(AnniversaryIslandSpringTask2023Mediator.TASK_GO, {
			taskVO = var1
		})
	end, SFX_PANEL)
	onButton(arg0, var0:Find("BG/Commit"), function()
		arg0:emit(AnniversaryIslandSpringTask2023Mediator.SHOW_SUBMIT_WINDOW, var1)
	end, SFX_PANEL)
	onButton(arg0, var0:Find("BG/Reward"), function()
		arg0:emit(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK, var1)
	end, SFX_PANEL)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Top/Back"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Top/Home"), function()
		arg0:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("springtask_help")
		})
	end, SFX_PANEL)
	arg0:BuildTaskVOs()
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	arg0.taskListRect:SetTotalCount(#arg0.taskVOs)
end

function var0.willExit(arg0)
	return
end

return var0
