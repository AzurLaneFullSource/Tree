local var0_0 = class("CultivatingPlantScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CultivatingPlantPartUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SFX_CANCLE)
	onButton(arg0_2, arg0_2.uiCultivatingBtn, function()
		arg0_2:emit(CultivatingPlantMediator.GO_SCENE)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiIslandBtn, function()
		local var0_5 = getProxy(TaskProxy):getTaskVO(arg0_2.taskList[arg0_2.index])

		if var0_5 == nil or not var0_5:isFinish() then
			return
		end

		if not var0_5:isReceive() then
			arg0_2:emit(CultivatingPlantMediator.ON_TASK_SUBMIT, var0_5)
		else
			arg0_2:OpenLiveArea()
		end
	end, SFX_PANEL)

	for iter0_2 = 1, arg0_2.uiList.childCount do
		local var0_2 = arg0_2.uiList:GetChild(iter0_2 - 1)

		onButton(arg0_2, var0_2, function()
			arg0_2:SelectPage(iter0_2)
		end, SFX_PANEL)
	end

	setText(arg0_2.uiTaskTitle, i18n("cultivating_plant_task_title"))
	setText(arg0_2.uiIslandText, i18n("cultivating_plant_island_task"))
end

function var0_0.didEnter(arg0_7)
	arg0_7:BlurPanel(arg0_7._tf)

	arg0_7.taskList = CultivatingPlantTools.GetTaskIDList()

	arg0_7:SelectPage(arg0_7.contextData.id and arg0_7.contextData.id + 1 or 1)
end

function var0_0.willExit(arg0_8)
	arg0_8:UnOverlayPanel(arg0_8._tf)

	if arg0_8.liveAreaPage then
		arg0_8.liveAreaPage:Destroy()

		arg0_8.liveAreaPage = nil
	end
end

function var0_0.SelectPage(arg0_9, arg1_9)
	if arg0_9.index == arg1_9 then
		return
	end

	local var0_9 = 216
	local var1_9 = 1238

	arg0_9.index = arg1_9

	for iter0_9 = 1, arg0_9.uiList.childCount do
		local var2_9 = arg0_9.uiList:GetChild(iter0_9 - 1)

		var2_9:GetComponent(typeof(LayoutElement)).preferredWidth = iter0_9 == arg1_9 and var1_9 or var0_9

		setActive(var2_9:Find("Image"), iter0_9 ~= arg1_9)
		setActive(var2_9:Find("main"), iter0_9 == arg1_9)

		local var3_9 = getProxy(TaskProxy):getTaskVO(arg0_9.taskList[iter0_9])
		local var4_9 = var3_9 and var3_9:isFinish() or false

		setActive(var2_9:Find("Image/got"), var4_9)
		setActive(var2_9:Find("main/got"), var4_9)
	end

	arg0_9:RefreshTask()
	setText(arg0_9.uiCultivatingText, i18n(string.format("cultivating_plant_part_" .. arg0_9.index)))
end

function var0_0.RefreshTask(arg0_10)
	local var0_10 = arg0_10.taskList[arg0_10.index]
	local var1_10 = pg.task_data_template[var0_10]
	local var2_10 = getProxy(TaskProxy):getTaskVO(arg0_10.taskList[arg0_10.index])
	local var3_10 = Drop.Create(var1_10.award_display[1])

	updateDrop(arg0_10.uiRewardItem, var3_10)
	onButton(arg0_10, arg0_10.uiRewardItem, function()
		arg0_10:emit(BaseUI.ON_DROP, var3_10)
	end, SFX_PANEL)

	local var4_10 = var2_10 and var2_10:isReceive() or false
	local var5_10 = var2_10 and var2_10:isFinish() or false

	setActive(arg0_10.uiRewardGot, var4_10)
	setActive(arg0_10.uiRed, var5_10 and not var4_10)
	setGray(arg0_10.uiIslandBtn, not var5_10)
	setText(arg0_10.uiTaskDesc, var1_10.desc)

	local var6_10 = var2_10 and var2_10:getProgress() or 0

	setText(arg0_10.uiTaskCnt, string.format("<color=#268BC5>%s</color>/%s", var6_10, var1_10.target_num))

	arg0_10.uiSlider.fillAmount = var6_10 / var1_10.target_num

	setActive(arg0_10.uiTask, false)
	setActive(arg0_10.uiTask, true)
end

function var0_0.OpenLiveArea(arg0_12)
	if arg0_12.liveAreaPage == nil then
		arg0_12.liveAreaPage = MainLiveAreaPage.New(arg0_12._parentTf, arg0_12.event)
	end

	arg0_12.liveAreaPage:ExecuteAction("Show", true, function()
		return
	end)
end

function var0_0.RefreshSubmitTaskDone(arg0_14)
	setActive(arg0_14.uiRewardGot, true)
	setActive(arg0_14.uiRed, false)
	arg0_14:OpenLiveArea()
end

function var0_0.onBackPressed(arg0_15)
	if arg0_15.liveAreaPage and arg0_15.liveAreaPage:GetLoaded() and arg0_15.liveAreaPage:isShowing() then
		arg0_15.liveAreaPage:Hide()

		return true
	end

	return false
end

return var0_0
