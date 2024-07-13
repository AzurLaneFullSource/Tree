local var0_0 = class("AnniversaryIslandSpringTask2023Scene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AnniversaryIslandSpringTask2023UI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2._tf:Find("TaskList/ScrollView")

	arg0_2.taskListRect = GetComponent(var0_2, "LScrollRect")

	function arg0_2.taskListRect.onUpdateItem(arg0_3, arg1_3)
		arg0_2:UpdateTaskListItem(arg0_3, arg1_3)
	end

	setText(arg0_2._tf:Find("Desc/Text"), i18n("springtask_tip"))
	setActive(arg0_2._tf:Find("Top/Help"), false)
end

function var0_0.BuildTaskVOs(arg0_4)
	local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)
	local var1_4 = var0_4:GetUnlockTaskIds()
	local var2_4 = var0_4:GetConfigID()

	arg0_4.activityId = var2_4

	local var3_4 = getProxy(ActivityTaskProxy):getTaskVOsByActId(var2_4)

	arg0_4.lockTasks = {}
	arg0_4.taskVOs = _.map(var1_4, function(arg0_5)
		local var0_5 = _.detect(var3_4, function(arg0_6)
			return arg0_6:GetConfigID() == arg0_5
		end)

		if not var0_5 then
			var0_5 = ActivityTask.New(var2_4, {
				id = arg0_5
			})
			arg0_4.lockTasks[var0_5] = true
		end

		return var0_5
	end)

	local var4_4 = CompareFuncs({
		function(arg0_7)
			return arg0_7:isOver() and 1 or 0
		end,
		function(arg0_8)
			return arg0_4.lockTasks[arg0_8] and 1 or 0
		end,
		function(arg0_9)
			return arg0_9:GetConfigID()
		end
	})

	table.sort(arg0_4.taskVOs, var4_4)
end

function var0_0.UpdateTaskListItem(arg0_10, arg1_10, arg2_10)
	arg1_10 = arg1_10 + 1

	local var0_10 = tf(arg2_10)
	local var1_10 = arg0_10.taskVOs[arg1_10]
	local var2_10 = var1_10:GetConfigID()
	local var3_10 = pg.task_data_template[var2_10]
	local var4_10 = var1_10:isFinish()
	local var5_10 = var1_10:isOver()
	local var6_10 = var1_10:isSubmit()
	local var7_10 = var3_10.award_display
	local var8_10 = var1_10:getProgress()
	local var9_10 = var1_10:getTargetNumber()

	setActive(var0_10:Find("Lock"), arg0_10.lockTasks[var1_10])
	setText(var0_10:Find("BG/Progress"), var8_10 .. "/" .. var9_10)
	setSlider(var0_10:Find("BG/ProgressBar"), 0, var9_10, var8_10)
	changeToScrollText(var0_10:Find("BG/Name/Text"), var3_10.name)
	setActive(var0_10:Find("BG/Go"), not var5_10 and not var4_10)
	setActive(var0_10:Find("BG/Commit"), not var5_10 and var4_10 and var6_10)
	setActive(var0_10:Find("BG/Reward"), not var5_10 and var4_10 and not var6_10)
	setActive(var0_10:Find("BG/Got"), var5_10)
	UIItemList.StaticAlign(var0_10:Find("BG/Items"), var0_10:Find("BG/Items"):GetChild(0), #var7_10, function(arg0_11, arg1_11, arg2_11)
		if arg0_11 ~= UIItemList.EventUpdate then
			return
		end

		local var0_11 = var7_10[arg1_11 + 1]
		local var1_11 = {
			type = var0_11[1],
			id = var0_11[2],
			count = var0_11[3]
		}

		updateDrop(arg2_11:Find("Icon"), var1_11)
		onButton(arg0_10, arg2_11, function()
			arg0_10:emit(BaseUI.ON_DROP, var1_11)
		end)
		setActive(arg2_11:Find("Completed"), var5_10)
	end)
	onButton(arg0_10, var0_10:Find("BG/Go"), function()
		arg0_10:emit(AnniversaryIslandSpringTask2023Mediator.TASK_GO, {
			taskVO = var1_10
		})
	end, SFX_PANEL)
	onButton(arg0_10, var0_10:Find("BG/Commit"), function()
		arg0_10:emit(AnniversaryIslandSpringTask2023Mediator.SHOW_SUBMIT_WINDOW, var1_10)
	end, SFX_PANEL)
	onButton(arg0_10, var0_10:Find("BG/Reward"), function()
		arg0_10:emit(AnniversaryIslandSpringTask2023Mediator.SUBMIT_TASK, var1_10)
	end, SFX_PANEL)
end

function var0_0.didEnter(arg0_16)
	onButton(arg0_16, arg0_16._tf:Find("Top/Back"), function()
		arg0_16:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16._tf:Find("Top/Home"), function()
		arg0_16:quickExitFunc()
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("springtask_help")
		})
	end, SFX_PANEL)
	arg0_16:BuildTaskVOs()
	arg0_16:UpdateView()
end

function var0_0.UpdateView(arg0_20)
	arg0_20.taskListRect:SetTotalCount(#arg0_20.taskVOs)
end

function var0_0.willExit(arg0_21)
	return
end

return var0_0
