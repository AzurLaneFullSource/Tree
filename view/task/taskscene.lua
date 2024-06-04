local var0 = class("TaskScene", import("..base.BaseUI"))

var0.PAGE_TYPE_SCENARIO = "scenario"
var0.PAGE_TYPE_BRANCH = "branch"
var0.PAGE_TYPE_ROUTINE = "routine"
var0.PAGE_TYPE_WEEKLY = "weekly"
var0.PAGE_TYPE_ALL = "all"
var0.PAGE_TYPE_ACT = "activity"

local var1 = {
	[var0.PAGE_TYPE_SCENARIO] = {
		[1] = true
	},
	[var0.PAGE_TYPE_BRANCH] = {
		nil,
		true,
		nil,
		nil,
		true,
		true
	},
	[var0.PAGE_TYPE_ROUTINE] = {
		[3] = true,
		[36] = true
	},
	[var0.PAGE_TYPE_WEEKLY] = {
		[4] = true,
		[13] = true
	},
	[var0.PAGE_TYPE_ALL] = {
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
	[var0.PAGE_TYPE_ACT] = {
		[36] = true,
		[6] = true,
		[26] = true
	}
}

function var0.getUIName(arg0)
	return "TaskScene"
end

function var0.setTaskVOs(arg0, arg1)
	arg0.contextData.taskVOsById = arg1
end

function var0.SetWeekTaskProgressInfo(arg0, arg1)
	arg0.contextData.weekTaskProgressInfo = arg1
end

function var0.init(arg0)
	arg0._topPanel = arg0:findTF("blur_panel/adapt/top")
	arg0._backBtn = arg0._topPanel:Find("back_btn")
	arg0._leftLength = arg0:findTF("blur_panel/adapt/left_length")
	arg0._tagRoot = arg0:findTF("blur_panel/adapt/left_length/frame/tagRoot")
	arg0.taskIconTpl = arg0:findTF("taskTagOb/task_icon_default")
	arg0.weekTip = arg0:findTF("weekly/tip", arg0._tagRoot)
	arg0.oneStepBtn = arg0:findTF("blur_panel/adapt/top/GetAllButton")
	arg0.contextData.viewComponent = arg0
	arg0.pageTF = arg0:findTF("pages")
end

function var0.IsNewStyleTime()
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

function var0.IsPassScenario()
	local var0 = pg.gameset.task_first_daily_pre_id.key_value
	local var1 = getProxy(TaskProxy):getData()
	local var2 = _.select(_.values(var1), function(arg0)
		return arg0:getConfig("type") == 1
	end)

	if #var2 > 0 then
		table.sort(var2, function(arg0, arg1)
			return arg0.id < arg1.id
		end)

		return var0 < var2[1].id
	else
		return true
	end
end

function var0.didEnter(arg0)
	local var0 = TaskCommonPage.New(arg0.pageTF, arg0.event, arg0.contextData)
	local var1 = var0.IsNewStyleTime() and not arg0.contextData.weekTaskProgressInfo:IsMaximum() and TaskWeekPage.New(arg0.pageTF, arg0.event, arg0.contextData) or var0

	arg0.emptyPage = TaskEmptyListPage.New(arg0._tf, arg0.event)
	arg0.pages = {
		[var0.PAGE_TYPE_SCENARIO] = var0,
		[var0.PAGE_TYPE_BRANCH] = var0,
		[var0.PAGE_TYPE_ROUTINE] = var0,
		[var0.PAGE_TYPE_WEEKLY] = var1,
		[var0.PAGE_TYPE_ALL] = var0,
		[var0.PAGE_TYPE_ACT] = var0
	}
	arg0.contextData.ptAwardWindow = TaskPtAwardPage.New(arg0._tf, arg0.event, arg0.contextData)

	onButton(arg0, arg0._backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	setActive(arg0:findTF("stamp"), getProxy(TaskProxy):mingshiTouchFlagEnabled())

	if LOCK_CLICK_MINGSHI then
		setActive(arg0:findTF("stamp"), false)
	end

	onButton(arg0, arg0:findTF("stamp"), function()
		getProxy(TaskProxy):dealMingshiTouchFlag(5)
	end, SFX_CONFIRM)

	arg0.toggles = {}

	for iter0, iter1 in pairs(var1) do
		local var2 = arg0:findTF(iter0, arg0._tagRoot)

		onToggle(arg0, var2, function(arg0)
			if arg0 then
				arg0:UpdatePage(iter0)
			end
		end, SFX_PANEL)

		arg0.toggles[iter0] = var2
	end

	local var3 = arg0.toggles[arg0.contextData.page or var0.PAGE_TYPE_ALL]

	if arg0.toggles and var3 then
		triggerToggle(var3, true)
	end

	arg0:UpdateWeekTip()
end

function var0.refreshPage(arg0)
	arg0:UpdatePage(arg0._currentToggleType)
end

function var0.UpdatePage(arg0, arg1)
	local var0 = var1[arg1]

	local function var1(arg0, arg1)
		if #arg1 <= 0 then
			arg0.emptyPage:ExecuteAction("ShowOrHide", true)
		elseif #arg1 > 0 and arg0.emptyPage:GetLoaded() then
			arg0.emptyPage:ExecuteAction("ShowOrHide", false)
		end

		arg0:updateOneStepBtn(arg0)
	end

	if arg0._currentToggleType and arg0._currentToggleType ~= arg1 then
		arg0.pages[arg0._currentToggleType]:ExecuteAction("Hide")
	end

	local var2 = arg0.pages[arg1]

	var2:ExecuteAction("Update", arg1, var0, function(arg0)
		var1(var2, arg0)
	end)

	arg0._currentToggleType = arg1
	arg0.contextData.page = arg1
end

function var0.addTask(arg0, arg1)
	print("add task " .. arg1.id)

	arg0.contextData.taskVOsById[arg1.id] = arg1

	arg0:UpdatePage(arg0._currentToggleType)
end

function var0.removeTask(arg0, arg1)
	print("revemo task " .. arg1.id)

	arg0.contextData.taskVOsById[arg1.id] = nil

	arg0:UpdatePage(arg0._currentToggleType)
end

function var0.updateTask(arg0, arg1)
	arg0:addTask(arg1)
end

function var0.ResetWeekTaskPage(arg0)
	local var0 = arg0.pages[var0.PAGE_TYPE_WEEKLY]

	if var0.IsNewStyleTime() and isa(var0, TaskCommonPage) then
		if var0:GetLoaded() and var0:isShowing() then
			var0:Hide()
		end

		local var1 = TaskWeekPage.New(arg0.pageTF, arg0.event, arg0.contextData)

		arg0.pages[var0.PAGE_TYPE_WEEKLY] = var1
	end

	arg0:RefreshWeekTaskPage()

	if arg0._currentToggleType ~= var0.PAGE_TYPE_WEEKLY then
		arg0:UpdatePage(arg0._currentToggleType)
	end
end

function var0.RefreshWeekTaskPage(arg0)
	if arg0._currentToggleType == var0.PAGE_TYPE_WEEKLY then
		arg0:UpdatePage(arg0._currentToggleType)
		arg0:UpdateWeekTip()
	end
end

function var0.RefreshWeekTaskPageBefore(arg0, arg1)
	if arg0._currentToggleType == var0.PAGE_TYPE_WEEKLY then
		arg0.pages[arg0._currentToggleType]:RefreshWeekTaskPageBefore(arg1)
	end
end

function var0.RefreshWeekTaskProgress(arg0)
	local var0 = arg0.pages[arg0._currentToggleType]

	if isa(var0, TaskWeekPage) and arg0.contextData.weekTaskProgressInfo:IsMaximum() then
		var0:Destroy()

		arg0.pages[var0.PAGE_TYPE_WEEKLY] = arg0.pages[var0.PAGE_TYPE_SCENARIO]

		arg0:UpdatePage(var0.PAGE_TYPE_WEEKLY)
	elseif arg0._currentToggleType == var0.PAGE_TYPE_WEEKLY and isa(var0, TaskWeekPage) then
		var0:ExecuteAction("RefreshWeekProgress")
		arg0:UpdateWeekTip()
	end
end

function var0.UpdateWeekTip(arg0)
	local var0 = false

	if var0.IsPassScenario() and var0.IsNewStyleTime() then
		for iter0, iter1 in pairs(arg0.contextData.taskVOsById) do
			if (iter1:getConfig("type") == 4 or iter1:getConfig("type") == 13) and iter1:isFinish() and not iter1:isReceive() and iter1:ShowOnTaskScene() then
				var0 = true

				break
			end
		end

		if not var0 then
			local var1 = arg0.contextData.weekTaskProgressInfo

			if var1:CanUpgrade() or var1:AnySubTaskCanSubmit() then
				var0 = true
			end
		end
	end

	setActive(arg0.weekTip, var0)
end

function var0.GoToFilter(arg0, arg1)
	local var0 = arg0:findTF(arg1, arg0._tagRoot)

	triggerToggle(var0, true)
end

function var0.onSubmit(arg0, arg1)
	if arg0.onShowAwards then
		return
	end

	arg0:emit(TaskMediator.ON_TASK_SUBMIT, arg1)
end

function var0.onSubmitForWeek(arg0, arg1)
	if arg0.onShowAwards then
		return
	end

	arg0:emit(TaskMediator.ON_SUBMIT_WEEK_TASK, arg1)
end

function var0.onSubmitForAvatar(arg0, arg1)
	if arg0.onShowAwards then
		return
	end

	arg0:emit(TaskMediator.ON_SUBMIT_AVATAR_TASK, arg1)
end

function var0.onGo(arg0, arg1)
	if arg0.onShowAwards then
		return
	end

	if isa(arg1, AvatarFrameTask) and arg1:IsActEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	arg0:emit(TaskMediator.ON_TASK_GO, arg1)
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.pages) do
		iter1:Destroy()
	end

	if arg0.emptyPage then
		arg0.emptyPage:Destroy()

		arg0.emptyPage = nil
	end

	arg0.pages = nil

	arg0.contextData.ptAwardWindow:Destroy()

	arg0.contextData.ptAwardWindow = nil
	arg0.contextData.taskVOsById = nil
	arg0.contextData.weekTaskProgressInfo = nil
	arg0.contextData.viewComponent = nil
end

function var0.updateOneStepBtn(arg0, arg1)
	arg1 = arg1 or arg0.pages[arg0._currentToggleType]

	local var0 = #arg1:GetWaitToCheckList() >= 2

	if var0 then
		onButton(arg0, arg0.oneStepBtn, function()
			arg1:ExecuteOneStepSubmit()
		end, SFX_PANEL)
	else
		removeOnButton(arg0.oneStepBtn)
	end

	setActive(arg0.oneStepBtn, var0)
end

return var0
