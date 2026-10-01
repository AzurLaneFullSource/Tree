local var0_0 = class("TaskScene", import("..base.BaseUI"))

var0_0.PAGE_TYPE_SCENARIO = "scenario"
var0_0.PAGE_TYPE_BRANCH = "branch"
var0_0.PAGE_TYPE_ROUTINE = "routine"
var0_0.PAGE_TYPE_WEEKLY = "weekly"
var0_0.PAGE_TYPE_ALL = "all"
var0_0.PAGE_TYPE_ACT = "activity"

local var1_0 = {
	[var0_0.PAGE_TYPE_SCENARIO] = {
		[1] = true
	},
	[var0_0.PAGE_TYPE_BRANCH] = {
		nil,
		true,
		nil,
		nil,
		true,
		true
	},
	[var0_0.PAGE_TYPE_ROUTINE] = {
		[3] = true,
		[36] = true
	},
	[var0_0.PAGE_TYPE_WEEKLY] = {
		[4] = true,
		[13] = true
	},
	[var0_0.PAGE_TYPE_ALL] = {
		true,
		true,
		true,
		true,
		true,
		true,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		true,
		[36] = true,
		[26] = true
	},
	[var0_0.PAGE_TYPE_ACT] = {
		[36] = true,
		[6] = true,
		[26] = true,
		[16] = true
	}
}

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {
		"ui/taskui_atlas",
		"ui/iconcolorful",
		"ui/TaskEmptyListUI",
		"ui/TaskListPage",
		"ui/TaskListForWeekPage",
		"ui/ActivitybonusWindow"
	}

	table.insertto(var0_1, arg0_1:GetTaskResourceList())

	return table.insertto(var0_1, var0_0.super.getResource(arg0_1, arg1_1))
end

function var0_0.GetTaskResourceList(arg0_2)
	local var0_2 = {}
	local var1_2 = getProxy(TaskProxy)

	for iter0_2, iter1_2 in ipairs(var1_2:getTasks()) do
		local var2_2 = arg0_2:GetTaskResource(iter1_2)

		if var2_2 and not table.contains(var0_2, var2_2) then
			table.insert(var0_2, var2_2)
		end
	end

	for iter2_2, iter3_2 in ipairs(var1_2:getFinishTasks()) do
		local var3_2 = arg0_2:GetTaskResource(iter3_2)

		if var3_2 and not table.contains(var0_2, var3_2) then
			table.insert(var0_2, var3_2)
		end
	end

	local var4_2 = getProxy(AvatarFrameProxy):getAllAvatarFrame()

	for iter4_2, iter5_2 in ipairs(var4_2) do
		local var5_2 = iter5_2.tasks

		for iter6_2, iter7_2 in ipairs(var5_2) do
			local var6_2 = arg0_2:GetTaskResource(iter7_2)

			if var6_2 and not table.contains(var0_2, var6_2) then
				table.insert(var0_2, var6_2)
			end
		end
	end

	return var0_2
end

function var0_0.GetTaskResource(arg0_3, arg1_3)
	local var0_3 = arg1_3:getConfig("story_id")

	if var0_3 and var0_3 ~= "" then
		local var1_3 = arg1_3:getConfig("story_icon")

		if not var1_3 or var1_3 == "" then
			return "memoryicon/task_icon_default"
		else
			return "shipmodels/" .. var1_3
		end
	end
end

function var0_0.getUIName(arg0_4)
	return "TaskScene"
end

function var0_0.setTaskVOs(arg0_5, arg1_5)
	arg0_5.contextData.taskVOsById = arg1_5
end

function var0_0.SetWeekTaskProgressInfo(arg0_6, arg1_6)
	arg0_6.contextData.weekTaskProgressInfo = arg1_6
end

function var0_0.init(arg0_7)
	arg0_7._topPanel = arg0_7._tf:Find("blur_panel/adapt/top")
	arg0_7._backBtn = arg0_7._topPanel:Find("back_btn")
	arg0_7._leftLength = arg0_7._tf:Find("blur_panel/adapt/left_length")
	arg0_7._tagRoot = arg0_7._tf:Find("blur_panel/adapt/left_length/frame/tagRoot")
	arg0_7.taskIconTpl = arg0_7._tf:Find("taskTagOb/task_icon_default")
	arg0_7.weekTip = arg0_7._tagRoot:Find("weekly/tip")
	arg0_7.oneStepBtn = arg0_7._tf:Find("blur_panel/adapt/top/GetAllButton")
	arg0_7.contextData.viewComponent = arg0_7
	arg0_7.pageTF = arg0_7._tf:Find("pages")
end

function var0_0.IsNewStyleTime()
	return pg.TimeMgr.GetInstance():parseTimeFromConfig({
		{
			2021,
			6,
			14
		},
		{
			0,
			0,
			0
		}
	}) <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.IsPassScenario()
	local var0_9 = pg.gameset.task_first_daily_pre_id.key_value
	local var1_9 = getProxy(TaskProxy):getData()
	local var2_9 = _.select(_.values(var1_9), function(arg0_10)
		return arg0_10:getConfig("type") == 1
	end)

	if #var2_9 > 0 then
		table.sort(var2_9, function(arg0_11, arg1_11)
			return arg0_11.id < arg1_11.id
		end)

		return var0_9 < var2_9[1].id
	else
		return true
	end
end

function var0_0.didEnter(arg0_12)
	local var0_12 = TaskCommonPage.New(arg0_12.pageTF, arg0_12.event, arg0_12.contextData)
	local var1_12 = var0_0.IsNewStyleTime() and not arg0_12.contextData.weekTaskProgressInfo:IsMaximum() and TaskWeekPage.New(arg0_12.pageTF, arg0_12.event, arg0_12.contextData) or var0_12

	arg0_12.emptyPage = TaskEmptyListPage.New(arg0_12._tf, arg0_12.event)
	arg0_12.pages = {
		[var0_0.PAGE_TYPE_SCENARIO] = var0_12,
		[var0_0.PAGE_TYPE_BRANCH] = var0_12,
		[var0_0.PAGE_TYPE_ROUTINE] = var0_12,
		[var0_0.PAGE_TYPE_WEEKLY] = var1_12,
		[var0_0.PAGE_TYPE_ALL] = var0_12,
		[var0_0.PAGE_TYPE_ACT] = var0_12
	}
	arg0_12.contextData.ptAwardWindow = TaskPtAwardPage.New(arg0_12._tf, arg0_12.event, arg0_12.contextData)

	onButton(arg0_12, arg0_12._backBtn, function()
		arg0_12:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	setActive(arg0_12._tf:Find("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_12._tf:Find("stamp"), false)
	end

	onButton(arg0_12, arg0_12._tf:Find("stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(5)
	end, SFX_CONFIRM)

	arg0_12.toggles = {}

	for iter0_12, iter1_12 in pairs(var1_0) do
		local var2_12 = arg0_12._tagRoot:Find(iter0_12)

		onToggle(arg0_12, var2_12, function(arg0_15)
			if arg0_15 then
				arg0_12:UpdatePage(iter0_12)
			end
		end, SFX_PANEL)

		arg0_12.toggles[iter0_12] = var2_12
	end

	local var3_12 = arg0_12.toggles[arg0_12.contextData.page or var0_0.PAGE_TYPE_ALL]

	if arg0_12.toggles and var3_12 then
		triggerToggle(var3_12, true)
	end

	arg0_12:UpdateWeekTip()
end

function var0_0.refreshPage(arg0_16)
	arg0_16:UpdatePage(arg0_16._currentToggleType)
end

function var0_0.UpdatePage(arg0_17, arg1_17)
	local var0_17 = var1_0[arg1_17]

	local function var1_17(arg0_18, arg1_18)
		if #arg1_18 <= 0 then
			arg0_17.emptyPage:ExecuteAction("ShowOrHide", true)
		elseif #arg1_18 > 0 and arg0_17.emptyPage:GetLoaded() then
			arg0_17.emptyPage:ExecuteAction("ShowOrHide", false)
		end

		arg0_17:updateOneStepBtn(arg0_18)
	end

	if arg0_17._currentToggleType and arg0_17._currentToggleType ~= arg1_17 then
		arg0_17.pages[arg0_17._currentToggleType]:ExecuteAction("Hide")
	end

	local var2_17 = arg0_17.pages[arg1_17]

	var2_17:ExecuteAction("Update", arg1_17, var0_17, function(arg0_19)
		var1_17(var2_17, arg0_19)
	end)

	arg0_17._currentToggleType = arg1_17
	arg0_17.contextData.page = arg1_17
end

function var0_0.addTask(arg0_20, arg1_20)
	arg0_20.contextData.taskVOsById[arg1_20.id] = arg1_20

	arg0_20:UpdatePage(arg0_20._currentToggleType)
end

function var0_0.removeTask(arg0_21, arg1_21)
	arg0_21.contextData.taskVOsById[arg1_21.id] = nil

	arg0_21:UpdatePage(arg0_21._currentToggleType)
end

function var0_0.updateTask(arg0_22, arg1_22)
	arg0_22:addTask(arg1_22)
end

function var0_0.ResetWeekTaskPage(arg0_23)
	local var0_23 = arg0_23.pages[var0_0.PAGE_TYPE_WEEKLY]

	if var0_0.IsNewStyleTime() and isa(var0_23, TaskCommonPage) then
		if var0_23:GetLoaded() and var0_23:isShowing() then
			var0_23:Hide()
		end

		local var1_23 = TaskWeekPage.New(arg0_23.pageTF, arg0_23.event, arg0_23.contextData)

		arg0_23.pages[var0_0.PAGE_TYPE_WEEKLY] = var1_23
	end

	arg0_23:RefreshWeekTaskPage()

	if arg0_23._currentToggleType ~= var0_0.PAGE_TYPE_WEEKLY then
		arg0_23:UpdatePage(arg0_23._currentToggleType)
	end
end

function var0_0.RefreshWeekTaskPage(arg0_24)
	if arg0_24._currentToggleType == var0_0.PAGE_TYPE_WEEKLY then
		arg0_24:UpdatePage(arg0_24._currentToggleType)
		arg0_24:UpdateWeekTip()
	end
end

function var0_0.RefreshWeekTaskPageBefore(arg0_25, arg1_25)
	if arg0_25._currentToggleType == var0_0.PAGE_TYPE_WEEKLY then
		arg0_25.pages[arg0_25._currentToggleType]:RefreshWeekTaskPageBefore(arg1_25)
	end
end

function var0_0.RefreshWeekTaskProgress(arg0_26)
	local var0_26 = arg0_26.pages[arg0_26._currentToggleType]

	if isa(var0_26, TaskWeekPage) and arg0_26.contextData.weekTaskProgressInfo:IsMaximum() then
		var0_26:Destroy()

		arg0_26.pages[var0_0.PAGE_TYPE_WEEKLY] = arg0_26.pages[var0_0.PAGE_TYPE_SCENARIO]

		arg0_26:UpdatePage(var0_0.PAGE_TYPE_WEEKLY)
	elseif arg0_26._currentToggleType == var0_0.PAGE_TYPE_WEEKLY and isa(var0_26, TaskWeekPage) then
		var0_26:ExecuteAction("RefreshWeekProgress")
		arg0_26:UpdateWeekTip()
	end
end

function var0_0.UpdateWeekTip(arg0_27)
	local var0_27 = false

	if var0_0.IsPassScenario() and var0_0.IsNewStyleTime() then
		for iter0_27, iter1_27 in pairs(arg0_27.contextData.taskVOsById) do
			if (iter1_27:getConfig("type") == 4 or iter1_27:getConfig("type") == 13) and iter1_27:isFinish() and not iter1_27:isReceive() and iter1_27:ShowOnTaskScene() then
				var0_27 = true

				break
			end
		end

		if not var0_27 then
			local var1_27 = arg0_27.contextData.weekTaskProgressInfo

			if var1_27:CanUpgrade() or var1_27:AnySubTaskCanSubmit() then
				var0_27 = true
			end
		end
	end

	setActive(arg0_27.weekTip, var0_27)
end

function var0_0.GoToFilter(arg0_28, arg1_28)
	local var0_28 = arg0_28._tagRoot:Find(arg1_28)

	triggerToggle(var0_28, true)
end

function var0_0.onSubmit(arg0_29, arg1_29)
	if arg0_29.onShowAwards then
		return
	end

	arg0_29:emit(TaskMediator.ON_TASK_SUBMIT, arg1_29)
end

function var0_0.onSubmitForWeek(arg0_30, arg1_30)
	if arg0_30.onShowAwards then
		return
	end

	arg0_30:emit(TaskMediator.ON_SUBMIT_WEEK_TASK, arg1_30)
end

function var0_0.onSubmitForAvatar(arg0_31, arg1_31)
	if arg0_31.onShowAwards then
		return
	end

	arg0_31:emit(TaskMediator.ON_SUBMIT_AVATAR_TASK, arg1_31)
end

function var0_0.onGo(arg0_32, arg1_32)
	if arg0_32.onShowAwards then
		return
	end

	if isa(arg1_32, AvatarFrameTask) and arg1_32:IsActEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	arg0_32:emit(TaskMediator.ON_TASK_GO, arg1_32)
end

function var0_0.willExit(arg0_33)
	for iter0_33, iter1_33 in pairs(arg0_33.pages) do
		iter1_33:Destroy()
	end

	if arg0_33.emptyPage then
		arg0_33.emptyPage:Destroy()

		arg0_33.emptyPage = nil
	end

	arg0_33.pages = nil

	arg0_33.contextData.ptAwardWindow:Destroy()

	arg0_33.contextData.ptAwardWindow = nil
	arg0_33.contextData.taskVOsById = nil
	arg0_33.contextData.weekTaskProgressInfo = nil
	arg0_33.contextData.viewComponent = nil
end

function var0_0.updateOneStepBtn(arg0_34, arg1_34)
	arg1_34 = arg1_34 or arg0_34.pages[arg0_34._currentToggleType]

	local var0_34 = #arg1_34:GetWaitToCheckList() >= 2

	if var0_34 then
		onButton(arg0_34, arg0_34.oneStepBtn, function()
			arg1_34:ExecuteOneStepSubmit()
		end, SFX_PANEL)
	else
		removeOnButton(arg0_34.oneStepBtn)
	end

	setActive(arg0_34.oneStepBtn, var0_34)
end

return var0_0
