local var0_0 = class("MallAwardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MallAwardUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiInputBtn, function()
		arg0_2:emit(MallAwardMediator.INPUT_GOLD, arg0_2.activity.id, arg0_2.curGold)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiGetAllBtn, function()
		local var0_5 = arg0_2.ptData:GetCurrTarget()

		arg0_2:emit(MallAwardMediator.GET_PT_AWARD, {
			cmd = 4,
			activity_id = arg0_2.ptData:GetId(),
			arg1 = var0_5
		})
	end, SFX_PANEL)

	arg0_2.storyTaskUIList = UIItemList.New(arg0_2.uiStoryTaskTF, arg0_2.uiTaskTpl)

	arg0_2.storyTaskUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg0_2.storyTaskList[arg1_6 + 1]

			arg0_2:UpdateTaskTpl(var0_6, arg2_6)
		end
	end)

	arg0_2.dailyTaskUIList = UIItemList.New(arg0_2.uiDailyTaskTF, arg0_2.uiTaskTpl)

	arg0_2.dailyTaskUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg0_2.dailyTaskList[arg1_7 + 1]

			arg0_2:UpdateTaskTpl(var0_7, arg2_7)
		end
	end)

	arg0_2.awardUIList = UIItemList.New(arg0_2.uiAwardTF, arg0_2.uiAwardTF:Find("tpl"))

	arg0_2.awardUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			arg0_2:UpdateAwardTpl(arg1_8, arg2_8)
		end
	end)
	setText(arg0_2.uiInputHeaderText, i18n("mall_input_header"))
	setText(arg0_2.uiOwnHeaderText, i18n("common_already owned"))
	setText(arg0_2.uiGetAllBtnText, i18n("mall_get_all_btn"))
	setText(arg0_2.uiInputBtnText, i18n("mall_input_btn"))
	setActive(arg0_2.uiTaskTpl, false)
	setText(arg0_2.uiTaskTpl:Find("go/Text"), i18n("task_go"))
	setText(arg0_2.uiTaskTpl:Find("get/Text"), i18n("task_get"))
	setText(arg0_2.uiTaskTpl:Find("got/Text"), i18n("task_got"))
	setText(arg0_2.uiAwardTF:Find("tpl/target/icon/Text"), i18n("target_get_tip"))
	setText(arg0_2.uiAwardTF:Find("tpl/get/Text"), i18n("mall_award_can_get"))
	setText(arg0_2.uiAwardTF:Find("tpl/got/Text"), i18n("mall_award_got"))
end

function var0_0.didEnter(arg0_9)
	arg0_9:UpdateView()
end

function var0_0.UpdateView(arg0_10)
	arg0_10:UpdateData()
	arg0_10:UpdateAwardView()
	arg0_10:UpdateTaskView()
end

function var0_0.UpdateData(arg0_11)
	local var0_11 = getProxy(ActivityProxy)

	arg0_11.activity = var0_11:getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)
	arg0_11.curGold = arg0_11.activity:GetGold()
	arg0_11.ptActivity = var0_11:getActivityById(arg0_11.activity:getConfig("config_id"))
	arg0_11.ptData = ActivityPtData.New(arg0_11.ptActivity)
	arg0_11.ptDataUnlockStamps = arg0_11.ptData:GetDayUnlockStamps()
	arg0_11.inputGold = arg0_11.ptData.count
end

function var0_0.UpdateAwardView(arg0_12)
	setActive(arg0_12.uiGetAllBtn, arg0_12.ptData:CanGetAward())
	setActive(arg0_12.uiInputBtn, arg0_12.curGold > 0)
	setActive(arg0_12.uiInputTip, var0_0.IsInputTip())
	setText(arg0_12.uiOwnText, arg0_12.curGold)
	setText(arg0_12.uiInputText, arg0_12.inputGold)
	arg0_12.awardUIList:align(#arg0_12.ptData.dropList)

	if arg0_12.ptData.level > 0 then
		scrollToIndex(arg0_12.awardUIList.container.parent, arg0_12.ptData.level)
	end
end

function var0_0.UpdateAwardTpl(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg1_13 + 1
	local var1_13 = arg0_13.ptData.dropList[var0_13]
	local var2_13 = arg0_13.ptData.targets[var0_13]

	setText(arg2_13:Find("target/Text"), var2_13)

	local var3_13 = Drop.Create(var1_13)

	updateDrop(arg2_13:Find("award"), var3_13)
	onButton(arg0_13, arg2_13:Find("award"), function()
		arg0_13:emit(BaseUI.ON_DROP, var3_13)
	end, SFX_PANEL)

	local var4_13 = var0_13 <= arg0_13.ptData.level

	setActive(arg2_13:Find("got"), var4_13)
	setActive(arg2_13:Find("get"), not var4_13 and var2_13 <= arg0_13.inputGold)

	local var5_13 = arg0_13.ptDataUnlockStamps[var0_13]

	setActive(arg2_13:Find("lock"), var5_13)

	if var5_13 then
		local var6_13 = pg.TimeMgr.GetInstance()

		setActive(arg2_13:Find("lock"), var5_13 > var6_13:GetServerTime())

		local var7_13 = var6_13:STimeDescS(var5_13, "%m")
		local var8_13 = var6_13:STimeDescS(var5_13, "%d")

		setText(arg2_13:Find("lock/Text"), i18n("mall_unlock_date_tip2", var7_13, var8_13))
	end
end

function var0_0.UpdateTaskView(arg0_15)
	arg0_15.storyTaskList, arg0_15.dailyTaskList = {}, {}

	local var0_15 = getProxy(TaskProxy)

	for iter0_15, iter1_15 in ipairs(arg0_15.activity:getConfig("config_client").story_task) do
		local var1_15 = var0_15:getTaskVO(iter1_15)

		table.insert(arg0_15.storyTaskList, var1_15)
	end

	for iter2_15, iter3_15 in ipairs(arg0_15.activity:getConfig("config_client").daily_task) do
		local var2_15 = var0_15:getTaskVO(iter3_15)

		table.insert(arg0_15.dailyTaskList, var2_15)
	end

	arg0_15:SortTaskList(arg0_15.storyTaskList)
	arg0_15:SortTaskList(arg0_15.dailyTaskList)
	arg0_15.storyTaskUIList:align(#arg0_15.storyTaskList)
	arg0_15.dailyTaskUIList:align(#arg0_15.dailyTaskList)
end

function var0_0.SortTaskList(arg0_16, arg1_16)
	table.sort(arg1_16, CompareFuncs({
		function(arg0_17)
			return arg0_17:isReceive() and 1 or 0
		end,
		function(arg0_18)
			return arg0_18:isFinish() and 0 or 1
		end,
		function(arg0_19)
			return arg0_19.id
		end
	}))
end

function var0_0.UpdateTaskTpl(arg0_20, arg1_20, arg2_20)
	setText(arg2_20:Find("slider/desc"), arg1_20:getConfig("desc"))

	local var0_20 = arg1_20:getProgress()
	local var1_20 = arg1_20:getConfig("target_num")

	setText(arg2_20:Find("slider/progress"), var0_20 .. "/" .. var1_20)
	setSlider(arg2_20:Find("slider"), 0, 1, var0_20 / var1_20)
	onButton(arg0_20, arg2_20:Find("go"), function()
		arg0_20:emit(MallAwardMediator.TASK_GO, arg1_20)
	end, SFX_PANEL)
	onButton(arg0_20, arg2_20:Find("get"), function()
		arg0_20:emit(MallAwardMediator.SUBMIT_TASK, arg1_20)
	end, SFX_PANEL)

	local var2_20 = arg1_20:getTaskStatus()

	setActive(arg2_20:Find("go"), var2_20 == 0)
	setActive(arg2_20:Find("get"), var2_20 == 1)
	setActive(arg2_20:Find("got"), var2_20 == 2)

	local var3_20 = arg1_20:getConfig("award_display")[1]

	setActive(arg2_20:Find("award"), var3_20)

	if var3_20 then
		local var4_20 = Drop.Create(var3_20)

		updateDrop(arg2_20:Find("award"), var4_20)
		onButton(arg0_20, arg2_20:Find("award"), function()
			arg0_20:emit(BaseUI.ON_DROP, var4_20)
		end, SFX_PANEL)
	end
end

function var0_0.willExit(arg0_24)
	existCall(arg0_24.contextData.onExit)

	arg0_24.contextData.onExit = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_24._tf)
end

function var0_0.IsAwardTip()
	local var0_25 = getProxy(ActivityProxy)
	local var1_25 = var0_25:getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)
	local var2_25 = var0_25:getActivityById(var1_25:getConfig("config_id"))

	return Activity.IsActivityReady(var2_25)
end

function var0_0.IsInputTip()
	local var0_26 = getProxy(ActivityProxy)
	local var1_26 = var0_26:getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)
	local var2_26 = var0_26:getActivityById(var1_26:getConfig("config_id"))
	local var3_26 = ActivityPtData.New(var2_26)
	local var4_26 = var1_26:GetGold()

	local function var5_26()
		local var0_27, var1_27, var2_27 = var3_26:GetResProgress()

		return var1_27 <= var0_27 + var4_26
	end

	return var3_26:CanGetNextAward() and var5_26()
end

function var0_0.IsTaskTip()
	local var0_28 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MALL)
	local var1_28 = table.mergeArray(var0_28:getConfig("config_client").story_task, var0_28:getConfig("config_client").daily_task)
	local var2_28 = getProxy(TaskProxy)

	return underscore.any(var1_28, function(arg0_29)
		local var0_29 = var2_28:getTaskById(arg0_29)

		return var0_29 and var0_29:isFinish() and not var0_29:isReceive()
	end)
end

return var0_0
