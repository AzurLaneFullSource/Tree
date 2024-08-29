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
		[26] = true
	}
}

function var0_0.getUIName(arg0_1)
	return "TaskScene"
end

function var0_0.setTaskVOs(arg0_2, arg1_2)
	arg0_2.contextData.taskVOsById = arg1_2
end

function var0_0.SetWeekTaskProgressInfo(arg0_3, arg1_3)
	arg0_3.contextData.weekTaskProgressInfo = arg1_3
end

function var0_0.init(arg0_4)
	arg0_4._topPanel = arg0_4:findTF("blur_panel/adapt/top")
	arg0_4._backBtn = arg0_4._topPanel:Find("back_btn")
	arg0_4._leftLength = arg0_4:findTF("blur_panel/adapt/left_length")
	arg0_4._tagRoot = arg0_4:findTF("blur_panel/adapt/left_length/frame/tagRoot")
	arg0_4.taskIconTpl = arg0_4:findTF("taskTagOb/task_icon_default")
	arg0_4.weekTip = arg0_4:findTF("weekly/tip", arg0_4._tagRoot)
	arg0_4.oneStepBtn = arg0_4:findTF("blur_panel/adapt/top/GetAllButton")
	arg0_4.contextData.viewComponent = arg0_4
	arg0_4.pageTF = arg0_4:findTF("pages")
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
	local var0_6 = pg.gameset.task_first_daily_pre_id.key_value
	local var1_6 = getProxy(TaskProxy):getData()
	local var2_6 = _.select(_.values(var1_6), function(arg0_7)
		return arg0_7:getConfig("type") == 1
	end)

	if #var2_6 > 0 then
		table.sort(var2_6, function(arg0_8, arg1_8)
			return arg0_8.id < arg1_8.id
		end)

		return var0_6 < var2_6[1].id
	else
		return true
	end
end

function var0_0.didEnter(arg0_9)
	local var0_9 = TaskCommonPage.New(arg0_9.pageTF, arg0_9.event, arg0_9.contextData)
	local var1_9 = var0_0.IsNewStyleTime() and not arg0_9.contextData.weekTaskProgressInfo:IsMaximum() and TaskWeekPage.New(arg0_9.pageTF, arg0_9.event, arg0_9.contextData) or var0_9

	arg0_9.emptyPage = TaskEmptyListPage.New(arg0_9._tf, arg0_9.event)
	arg0_9.pages = {
		[var0_0.PAGE_TYPE_SCENARIO] = var0_9,
		[var0_0.PAGE_TYPE_BRANCH] = var0_9,
		[var0_0.PAGE_TYPE_ROUTINE] = var0_9,
		[var0_0.PAGE_TYPE_WEEKLY] = var1_9,
		[var0_0.PAGE_TYPE_ALL] = var0_9,
		[var0_0.PAGE_TYPE_ACT] = var0_9
	}
	arg0_9.contextData.ptAwardWindow = TaskPtAwardPage.New(arg0_9._tf, arg0_9.event, arg0_9.contextData)

	onButton(arg0_9, arg0_9._backBtn, function()
		arg0_9:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	setActive(arg0_9:findTF("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0_9:findTF("stamp"), false)
	end

	onButton(arg0_9, arg0_9:findTF("stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(5)
	end, SFX_CONFIRM)

	arg0_9.toggles = {}

	for iter0_9, iter1_9 in pairs(var1_0) do
		local var2_9 = arg0_9:findTF(iter0_9, arg0_9._tagRoot)

		onToggle(arg0_9, var2_9, function(arg0_12)
			if arg0_12 then
				arg0_9:UpdatePage(iter0_9)
			end
		end, SFX_PANEL)

		arg0_9.toggles[iter0_9] = var2_9
	end

	local var3_9 = arg0_9.toggles[arg0_9.contextData.page or var0_0.PAGE_TYPE_ALL]

	if arg0_9.toggles and var3_9 then
		triggerToggle(var3_9, true)
	end

	arg0_9:UpdateWeekTip()
end

function var0_0.refreshPage(arg0_13)
	arg0_13:UpdatePage(arg0_13._currentToggleType)
end

function var0_0.UpdatePage(arg0_14, arg1_14)
	local var0_14 = var1_0[arg1_14]

	local function var1_14(arg0_15, arg1_15)
		if #arg1_15 <= 0 then
			arg0_14.emptyPage:ExecuteAction("ShowOrHide", true)
		elseif #arg1_15 > 0 and arg0_14.emptyPage:GetLoaded() then
			arg0_14.emptyPage:ExecuteAction("ShowOrHide", false)
		end

		arg0_14:updateOneStepBtn(arg0_15)
	end

	if arg0_14._currentToggleType and arg0_14._currentToggleType ~= arg1_14 then
		arg0_14.pages[arg0_14._currentToggleType]:ExecuteAction("Hide")
	end

	local var2_14 = arg0_14.pages[arg1_14]

	var2_14:ExecuteAction("Update", arg1_14, var0_14, function(arg0_16)
		var1_14(var2_14, arg0_16)
	end)

	arg0_14._currentToggleType = arg1_14
	arg0_14.contextData.page = arg1_14
end

function var0_0.addTask(arg0_17, arg1_17)
	arg0_17.contextData.taskVOsById[arg1_17.id] = arg1_17

	arg0_17:UpdatePage(arg0_17._currentToggleType)
end

function var0_0.removeTask(arg0_18, arg1_18)
	arg0_18.contextData.taskVOsById[arg1_18.id] = nil

	arg0_18:UpdatePage(arg0_18._currentToggleType)
end

function var0_0.updateTask(arg0_19, arg1_19)
	arg0_19:addTask(arg1_19)
end

function var0_0.ResetWeekTaskPage(arg0_20)
	local var0_20 = arg0_20.pages[var0_0.PAGE_TYPE_WEEKLY]

	if var0_0.IsNewStyleTime() and isa(var0_20, TaskCommonPage) then
		if var0_20:GetLoaded() and var0_20:isShowing() then
			var0_20:Hide()
		end

		local var1_20 = TaskWeekPage.New(arg0_20.pageTF, arg0_20.event, arg0_20.contextData)

		arg0_20.pages[var0_0.PAGE_TYPE_WEEKLY] = var1_20
	end

	arg0_20:RefreshWeekTaskPage()

	if arg0_20._currentToggleType ~= var0_0.PAGE_TYPE_WEEKLY then
		arg0_20:UpdatePage(arg0_20._currentToggleType)
	end
end

function var0_0.RefreshWeekTaskPage(arg0_21)
	if arg0_21._currentToggleType == var0_0.PAGE_TYPE_WEEKLY then
		arg0_21:UpdatePage(arg0_21._currentToggleType)
		arg0_21:UpdateWeekTip()
	end
end

function var0_0.RefreshWeekTaskPageBefore(arg0_22, arg1_22)
	if arg0_22._currentToggleType == var0_0.PAGE_TYPE_WEEKLY then
		arg0_22.pages[arg0_22._currentToggleType]:RefreshWeekTaskPageBefore(arg1_22)
	end
end

function var0_0.RefreshWeekTaskProgress(arg0_23)
	local var0_23 = arg0_23.pages[arg0_23._currentToggleType]

	if isa(var0_23, TaskWeekPage) and arg0_23.contextData.weekTaskProgressInfo:IsMaximum() then
		var0_23:Destroy()

		arg0_23.pages[var0_0.PAGE_TYPE_WEEKLY] = arg0_23.pages[var0_0.PAGE_TYPE_SCENARIO]

		arg0_23:UpdatePage(var0_0.PAGE_TYPE_WEEKLY)
	elseif arg0_23._currentToggleType == var0_0.PAGE_TYPE_WEEKLY and isa(var0_23, TaskWeekPage) then
		var0_23:ExecuteAction("RefreshWeekProgress")
		arg0_23:UpdateWeekTip()
	end
end

function var0_0.UpdateWeekTip(arg0_24)
	local var0_24 = false

	if var0_0.IsPassScenario() and var0_0.IsNewStyleTime() then
		for iter0_24, iter1_24 in pairs(arg0_24.contextData.taskVOsById) do
			if (iter1_24:getConfig("type") == 4 or iter1_24:getConfig("type") == 13) and iter1_24:isFinish() and not iter1_24:isReceive() and iter1_24:ShowOnTaskScene() then
				var0_24 = true

				break
			end
		end

		if not var0_24 then
			local var1_24 = arg0_24.contextData.weekTaskProgressInfo

			if var1_24:CanUpgrade() or var1_24:AnySubTaskCanSubmit() then
				var0_24 = true
			end
		end
	end

	setActive(arg0_24.weekTip, var0_24)
end

function var0_0.GoToFilter(arg0_25, arg1_25)
	local var0_25 = arg0_25:findTF(arg1_25, arg0_25._tagRoot)

	triggerToggle(var0_25, true)
end

function var0_0.onSubmit(arg0_26, arg1_26)
	if arg0_26.onShowAwards then
		return
	end

	arg0_26:emit(TaskMediator.ON_TASK_SUBMIT, arg1_26)
end

function var0_0.onSubmitForWeek(arg0_27, arg1_27)
	if arg0_27.onShowAwards then
		return
	end

	arg0_27:emit(TaskMediator.ON_SUBMIT_WEEK_TASK, arg1_27)
end

function var0_0.onSubmitForAvatar(arg0_28, arg1_28)
	if arg0_28.onShowAwards then
		return
	end

	arg0_28:emit(TaskMediator.ON_SUBMIT_AVATAR_TASK, arg1_28)
end

function var0_0.onGo(arg0_29, arg1_29)
	if arg0_29.onShowAwards then
		return
	end

	if isa(arg1_29, AvatarFrameTask) and arg1_29:IsActEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	arg0_29:emit(TaskMediator.ON_TASK_GO, arg1_29)
end

function var0_0.willExit(arg0_30)
	for iter0_30, iter1_30 in pairs(arg0_30.pages) do
		iter1_30:Destroy()
	end

	if arg0_30.emptyPage then
		arg0_30.emptyPage:Destroy()

		arg0_30.emptyPage = nil
	end

	arg0_30.pages = nil

	arg0_30.contextData.ptAwardWindow:Destroy()

	arg0_30.contextData.ptAwardWindow = nil
	arg0_30.contextData.taskVOsById = nil
	arg0_30.contextData.weekTaskProgressInfo = nil
	arg0_30.contextData.viewComponent = nil
end

function var0_0.updateOneStepBtn(arg0_31, arg1_31)
	arg1_31 = arg1_31 or arg0_31.pages[arg0_31._currentToggleType]

	local var0_31 = #arg1_31:GetWaitToCheckList() >= 2

	if var0_31 then
		onButton(arg0_31, arg0_31.oneStepBtn, function()
			arg1_31:ExecuteOneStepSubmit()
		end, SFX_PANEL)
	else
		removeOnButton(arg0_31.oneStepBtn)
	end

	setActive(arg0_31.oneStepBtn, var0_31)
end

return var0_0
