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
	arg0_1.scenario = arg0_1:GetOutPostScenarioPage().New(arg0_1._tf, arg0_1.event)

	arg0_1.scenario:SetCoreStoryPage(arg0_1)
	arg0_1.scenario:RegisterView(arg0_1.coreActivityUI)

	arg0_1.taskWindow = OutPostOmenTaskWindow.New(arg0_1._tf, arg0_1.event)

	setActive(arg0_1.item, false)

	arg0_1.progressLabel = arg0_1.bg:Find("total_progress/label")

	setText(arg0_1.progressLabel, i18n("Outpost_20250904_Progress"))
	setText(arg0_1.txtDetail, i18n("Outpost_20260514_Detail"))
end

function var0_0.GetOutPostScenarioPage(arg0_2)
	return OutPostScenarioPage
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.nday = 0
	arg0_3.taskProxy = getProxy(TaskProxy)
	arg0_3.taskGroup = arg0_3.activity:getConfig("config_client").unlock_task

	return updateActivityTaskStatus(arg0_3.activity)
end

function var0_0.OnFirstFlush(arg0_4)
	var0_0.super.OnFirstFlush(arg0_4)
	setActive(arg0_4.maxTF, #arg0_4.taskGroup)
	onButton(arg0_4, arg0_4.btnDetail, function()
		arg0_4.taskWindow:ExecuteAction("Show", arg0_4.activity)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnStory, function()
		if arg0_4.scenario then
			arg0_4.scenario:Load()
			arg0_4.scenario:SetActivity(arg0_4.activity)
			arg0_4.scenario:UpdateStoryTask()
			arg0_4.scenario:ActionInvoke("UpdateView")
			arg0_4:ShowScenarioLayer(true)
		end
	end, SFX_PANEL)
end

function var0_0.OnShowFlush(arg0_7)
	var0_0.super.OnShowFlush(arg0_7)
end

function var0_0.ShowScenarioLayer(arg0_8, arg1_8)
	if arg1_8 then
		arg0_8.coreActivityUI:ActiveScenarioLayer(true)

		if arg0_8.scenario then
			arg0_8.scenario:ActionInvoke("Show")
		end
	else
		if arg0_8.scenario then
			arg0_8.scenario:Hide()
		end

		arg0_8.coreActivityUI:ActiveScenarioLayer(false)
	end
end

function var0_0.IsShowingPopWindow(arg0_9)
	if arg0_9.scenario then
		return arg0_9.scenario:isShowing()
	end
end

function var0_0.ClosePopWindow(arg0_10)
	if arg0_10.scenario then
		arg0_10.scenario:Hide()
		arg0_10:ShowScenarioLayer(false)
	end
end

function var0_0.OnUpdateFlush(arg0_11)
	local var0_11 = #arg0_11.taskGroup

	arg0_11.nday = arg0_11:getTaskIdx(arg0_11.activity)

	arg0_11:PlayStory()

	if arg0_11.dayTF then
		setText(arg0_11.dayTF, "DAY " .. arg0_11.nday)
		setText(arg0_11.maxDayTF, "/" .. var0_11)
	end

	arg0_11.uilist:align(#arg0_11.taskGroup[arg0_11.nday])

	if arg0_11.taskWindow:isShowing() then
		arg0_11.taskWindow:ExecuteAction("Show", arg0_11.activity)
	end
end

function var0_0.getTaskIdx(arg0_12, arg1_12)
	local var0_12 = 1
	local var1_12 = arg1_12:getNDay()
	local var2_12 = #arg0_12.taskGroup
	local var3_12 = math.min(var1_12, var2_12)
	local var4_12 = true

	for iter0_12 = 1, var3_12 do
		if not var4_12 then
			break
		end

		var0_12 = iter0_12

		if iter0_12 < var3_12 then
			for iter1_12, iter2_12 in ipairs(arg0_12.taskGroup[iter0_12]) do
				if not arg0_12:isTaskFinished(iter2_12) then
					var4_12 = false

					break
				end
			end
		end
	end

	return math.min(var0_12, var2_12)
end

function var0_0.isTaskFinished(arg0_13, arg1_13)
	if not arg0_13.taskProxy then
		arg0_13.taskProxy = getProxy(TaskProxy)
	end

	local var0_13 = arg0_13.taskProxy:getTaskById(arg1_13) or arg0_13.taskProxy:getFinishTaskById(arg1_13)

	return var0_13 and var0_13:getTaskStatus() == 2
end

function var0_0.OnHideFlush(arg0_14)
	if arg0_14.taskWindow:isShowing() then
		arg0_14.taskWindow:Hide()
	end
end

function var0_0.OnDestroy(arg0_15)
	if arg0_15.taskWindow then
		arg0_15.taskWindow:Hide()
		arg0_15.taskWindow:Destroy()

		arg0_15.taskWindow = nil
	end

	if arg0_15.scenario then
		if arg0_15.scenario:isShowing() then
			arg0_15.scenario:Hide()
		end

		arg0_15.scenario:Destroy()
	end
end

return var0_0
