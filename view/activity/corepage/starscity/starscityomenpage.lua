local var0_0 = class("StarsCityOmenPage", import("view.activity.CorePage.CoreLoginTemplatePage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("bg")
	arg0_1.dayTF = arg0_1.bg:Find("total_progress/day")
	arg0_1.maxDayTF = arg0_1.bg:Find("total_progress/max_day")
	arg0_1.item = arg0_1.bg:Find("item")
	arg0_1.items = arg0_1.bg:Find("items")
	arg0_1.uilist = UIItemList.New(arg0_1.items, arg0_1.item)
	arg0_1.btnDetail = arg0_1.bg:Find("btn_detail")
	arg0_1.txtDetail = arg0_1.btnDetail:Find("detail")
	arg0_1.ruleTxt = arg0_1.bg:Find("rule_get")
	arg0_1.btnStory = arg0_1.bg:Find("btn_story")
	arg0_1.scenario = arg0_1:GetOutPostScenarioPage().New(arg0_1._tf, arg0_1.event)

	arg0_1.scenario:SetCoreStoryPage(arg0_1)
	arg0_1.scenario:RegisterView(arg0_1.coreActivityUI)

	arg0_1.taskWindow = StarsCityOmenTaskWindow.New(arg0_1._tf, arg0_1.event)

	setActive(arg0_1.item, false)

	arg0_1.progressLabel = arg0_1.bg:Find("total_progress/label")

	setText(arg0_1.progressLabel, i18n("Outpost_20250904_Progress"))
	setText(arg0_1.txtDetail, i18n("Outpost_20260514_Detail"))
	setText(arg0_1.ruleTxt, i18n("Outpost_20260806_rule"))
end

function var0_0.GetOutPostScenarioPage(arg0_2)
	return OutPostScenarioPage_260806
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

function var0_0.UpdateTask(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12 + 1
	local var1_12 = arg2_12:Find("item")
	local var2_12 = arg0_12.taskGroup[arg0_12.nday][var0_12]
	local var3_12 = arg0_12.taskProxy:getTaskById(var2_12) or arg0_12.taskProxy:getFinishTaskById(var2_12)

	assert(var3_12, "without this task by id: " .. var2_12)

	local var4_12 = Drop.Create(var3_12:getConfig("award_display")[1])

	updateDrop(var1_12, var4_12)
	onButton(arg0_12, var1_12, function()
		arg0_12:emit(BaseUI.ON_DROP, var4_12)
	end, SFX_PANEL)

	local var5_12 = var3_12:getProgress()
	local var6_12 = var3_12:getConfig("target_num")

	setScrollText(arg2_12:Find("mask/description"), var3_12:getConfig("desc"))

	local var7_12, var8_12 = arg0_12:GetProgressColor()
	local var9_12

	var9_12 = var7_12 and setColorStr(var5_12, var7_12) or var5_12

	local var10_12

	var10_12 = var8_12 and setColorStr("/" .. var6_12, var8_12) or "/" .. var6_12

	setText(arg2_12:Find("progressText"), var9_12 .. var10_12)
	setSlider(arg2_12:Find("progress"), 0, var6_12, var5_12)

	local var11_12 = arg2_12:Find("go_btn")
	local var12_12 = arg2_12:Find("get_btn")
	local var13_12 = arg2_12:Find("got_btn")

	arg0_12:SetBtnLocal(arg2_12)

	local var14_12 = var3_12:getTaskStatus()

	setActive(var11_12, var14_12 == 0)
	setActive(var12_12, var14_12 == 1)
	setActive(var13_12, var14_12 == 2)
	onButton(arg0_12, var11_12, function()
		arg0_12:emit(ActivityMediator.ON_TASK_GO, var3_12)
	end, SFX_PANEL)
	onButton(arg0_12, var12_12, function()
		local var0_15 = {}
		local var1_15 = var3_12:getConfig("award_display")
		local var2_15 = getProxy(PlayerProxy):getRawData()
		local var3_15 = pg.gameset.urpt_chapter_max.description[1]
		local var4_15 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_15)
		local var5_15, var6_15 = Task.StaticJudgeOverflow(var2_15.gold, var2_15.oil, var4_15, true, true, var1_15)

		if var5_15 then
			table.insert(var0_15, function(arg0_16)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_15,
					onYes = arg0_16
				})
			end)
		end

		seriesAsync(var0_15, function()
			arg0_12:emit(ActivityMediator.ON_TASK_SUBMIT, var3_12)
		end)
	end, SFX_PANEL)
end

function var0_0.getTaskIdx(arg0_18, arg1_18)
	local var0_18 = 1
	local var1_18 = arg1_18:getNDay()
	local var2_18 = #arg0_18.taskGroup
	local var3_18 = math.min(var1_18, var2_18)
	local var4_18 = true

	for iter0_18 = 1, var3_18 do
		if not var4_18 then
			break
		end

		var0_18 = iter0_18

		if iter0_18 < var3_18 then
			for iter1_18, iter2_18 in ipairs(arg0_18.taskGroup[iter0_18]) do
				if not arg0_18:isTaskFinished(iter2_18) then
					var4_18 = false

					break
				end
			end
		end
	end

	return math.min(var0_18, var2_18)
end

function var0_0.isTaskFinished(arg0_19, arg1_19)
	if not arg0_19.taskProxy then
		arg0_19.taskProxy = getProxy(TaskProxy)
	end

	local var0_19 = arg0_19.taskProxy:getTaskById(arg1_19) or arg0_19.taskProxy:getFinishTaskById(arg1_19)

	return var0_19 and var0_19:getTaskStatus() == 2
end

function var0_0.GetProgressColor(arg0_20)
	return "#FFFFFF", "#C3C3C3"
end

function var0_0.SetBtnLocal(arg0_21, arg1_21)
	local var0_21 = arg1_21:Find("get_btn")
	local var1_21 = arg1_21:Find("go_btn")
	local var2_21 = arg1_21:Find("got_btn")

	setText(var0_21:Find("Text"), i18n("LiquorFloorTaskUI_get"))
	setText(var1_21:Find("Text"), i18n("LiquorFloorTaskUI_go"))
	setText(var2_21:Find("Text"), i18n("LiquorFloorTaskUI_got"))
end

function var0_0.OnHideFlush(arg0_22)
	if arg0_22.taskWindow:isShowing() then
		arg0_22.taskWindow:Hide()
	end
end

function var0_0.OnDestroy(arg0_23)
	if arg0_23.taskWindow then
		arg0_23.taskWindow:Hide()
		arg0_23.taskWindow:Destroy()

		arg0_23.taskWindow = nil
	end

	if arg0_23.scenario then
		if arg0_23.scenario:isShowing() then
			arg0_23.scenario:Hide()
		end

		arg0_23.scenario:Destroy()
	end
end

return var0_0
