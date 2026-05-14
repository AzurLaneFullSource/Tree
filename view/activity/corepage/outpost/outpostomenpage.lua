local var0_0 = class("OutPostOmenPage", import("view.activity.CorePage.CoreLoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("bg")
	arg0_1.dayTF = arg0_1.bg:Find("total_progress/day")
	arg0_1.maxDayTF = arg0_1.bg:Find("total_progress/max_day")
	arg0_1.item = arg0_1.bg:Find("item")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.btnDetail = arg0_1.bg:Find("btn_detail")
	arg0_1.txtDetail = arg0_1.btnDetail:Find("detail")
	arg0_1.btnStory = arg0_1.bg:Find("btn_story")
	arg0_1.scenario = OutPostScenarioPage.New(arg0_1._tf, arg0_1.event)

	arg0_1.scenario:SetCoreStoryPage(arg0_1)
	arg0_1.scenario:RegisterView(arg0_1.coreActivityUI)

	arg0_1.taskWindow = OutPostOmenTaskWindow.New(arg0_1._tf, arg0_1.event)

	setActive(arg0_1.item, false)

	arg0_1.progressLabel = arg0_1.bg:Find("total_progress/label")

	setText(arg0_1.progressLabel, i18n("Outpost_20250904_Progress"))
	setText(arg0_1.txtDetail, i18n("Outpost_20260514_Detail"))
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.nday = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.activity:getConfig("config_client").unlock_task

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	var0_0.super.OnFirstFlush(arg0_3)
	setActive(arg0_3.maxTF, #arg0_3.taskGroup)
	onButton(arg0_3, arg0_3.btnDetail, function()
		arg0_3.taskWindow:ExecuteAction("Show", arg0_3.activity)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btnStory, function()
		arg0_3.scenario:Load()
		arg0_3.scenario:SetActivity(arg0_3.activity)
		arg0_3.scenario:UpdateStoryTask()
		arg0_3.scenario:ActionInvoke("UpdateView")
		arg0_3:ShowScenarioLayer(true)
	end, SFX_PANEL)
end

function var0_0.OnShowFlush(arg0_6)
	var0_0.super.OnShowFlush(arg0_6)
end

function var0_0.ShowScenarioLayer(arg0_7, arg1_7)
	if arg1_7 then
		arg0_7.coreActivityUI:ActiveScenarioLayer(true)
		arg0_7.scenario:ActionInvoke("Show")
	else
		arg0_7.scenario:Hide()
		arg0_7.coreActivityUI:ActiveScenarioLayer(false)
	end
end

function var0_0.IsShowingPopWindow(arg0_8)
	return arg0_8.scenario:isShowing()
end

function var0_0.ClosePopWindow(arg0_9)
	arg0_9.scenario:Hide()
	arg0_9:ShowScenarioLayer(false)
end

function var0_0.OnUpdateFlush(arg0_10)
	local var0_10 = #arg0_10.taskGroup

	arg0_10.nday = arg0_10:getTaskIdx(arg0_10.activity)

	arg0_10:PlayStory()

	if arg0_10.dayTF then
		setText(arg0_10.dayTF, "DAY " .. arg0_10.nday)
		setText(arg0_10.maxDayTF, "/" .. var0_10)
	end

	arg0_10.uilist:align(#arg0_10.taskGroup[arg0_10.nday])

	if arg0_10.taskWindow:isShowing() then
		arg0_10.taskWindow:ExecuteAction("Show", arg0_10.activity)
	end
end

function var0_0.getTaskIdx(arg0_11, arg1_11)
	local var0_11 = 1
	local var1_11 = arg1_11:getNDay()
	local var2_11 = #arg0_11.taskGroup
	local var3_11 = math.min(var1_11, var2_11)
	local var4_11 = true

	for iter0_11 = 1, var3_11 do
		if not var4_11 then
			break
		end

		var0_11 = iter0_11

		if iter0_11 < var3_11 then
			for iter1_11, iter2_11 in ipairs(arg0_11.taskGroup[iter0_11]) do
				if not arg0_11:isTaskFinished(iter2_11) then
					var4_11 = false

					break
				end
			end
		end
	end

	return math.min(var0_11, var2_11)
end

function var0_0.isTaskFinished(arg0_12, arg1_12)
	if not arg0_12.taskProxy then
		arg0_12.taskProxy = getProxy(TaskProxy)
	end

	local var0_12 = arg0_12.taskProxy:getTaskById(arg1_12) or arg0_12.taskProxy:getFinishTaskById(arg1_12)

	return var0_12 and var0_12:getTaskStatus() == 2
end

function var0_0.OnHideFlush(arg0_13)
	if arg0_13.taskWindow:isShowing() then
		arg0_13.taskWindow:Hide()
	end
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14.taskWindow then
		arg0_14.taskWindow:Hide()
		arg0_14.taskWindow:Destroy()

		arg0_14.taskWindow = nil
	end

	if arg0_14.scenario:isShowing() then
		arg0_14.scenario:Hide()
	end

	arg0_14.scenario:Destroy()
end

return var0_0
