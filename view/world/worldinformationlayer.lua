local var0_0 = class("WorldInformationLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "WorldInformationUI"
end

var0_0.Listeners = {
	onUpdateDailyTask = "OnUpdateDailyTask",
	onUpdateTask = "OnUpdateTask"
}

function var0_0.init(arg0_2)
	for iter0_2, iter1_2 in pairs(var0_0.Listeners) do
		arg0_2[iter0_2] = function(...)
			var0_0[iter1_2](arg0_2, ...)
		end
	end

	arg0_2.rtLeftPanel = arg0_2:findTF("adapt/left_panel")

	setText(arg0_2.rtLeftPanel:Find("title/Text"), i18n("world_map_title_tips"))
	setText(arg0_2.rtLeftPanel:Find("title/Text_en"), i18n("world_map_title_tips_en"))

	arg0_2.wsWorldInfo = WSWorldInfo.New()
	arg0_2.wsWorldInfo.transform = arg0_2.rtLeftPanel:Find("world_info")

	arg0_2.wsWorldInfo:Setup()
	setText(arg0_2.wsWorldInfo.transform:Find("power/bg/Word"), i18n("world_total_power"))
	setText(arg0_2.wsWorldInfo.transform:Find("explore/mileage/Text"), i18n("world_mileage"))
	setText(arg0_2.wsWorldInfo.transform:Find("explore/pressing/Text"), i18n("world_pressing"))

	arg0_2.rtRightPanel = arg0_2:findTF("adapt/right_panel")
	arg0_2.rtNothingTip = arg0_2.rtRightPanel:Find("nothing_tip")
	arg0_2.btnClose = arg0_2.rtRightPanel:Find("title/close_btn")
	arg0_2.toggleAll = arg0_2.rtRightPanel:Find("title/task_all")
	arg0_2.toggleMain = arg0_2.rtRightPanel:Find("title/task_main")
	arg0_2.rtContainer = arg0_2.rtRightPanel:Find("main/viewport/content")
	arg0_2.taskItemList = UIItemList.New(arg0_2.rtContainer, arg0_2.rtContainer:Find("task_tpl"))

	arg0_2.taskItemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_2:UpdateTaskTpl(arg2_4, arg0_2.filterTaskList[arg1_4 + 1])
		end
	end)

	arg0_2.btnDailyTask = arg0_2.rtLeftPanel:Find("world_info/task_btn")
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.btnClose, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5:findTF("bg"), function()
		triggerButton(arg0_5.btnClose)
	end, SFX_CANCEL)
	onToggle(arg0_5, arg0_5.toggleAll, function(arg0_8)
		if arg0_8 then
			arg0_5.filterType = nil

			arg0_5:UpdateFilterTaskList()
		end

		setTextColor(arg0_5.toggleAll, arg0_8 and Color.white or Color.New(0.486274509803922, 0.52156862745098, 0.643137254901961))
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.toggleMain, function(arg0_9)
		if arg0_9 then
			arg0_5.filterType = 0

			arg0_5:UpdateFilterTaskList()
		end

		setTextColor(arg0_5.toggleMain, arg0_9 and Color.white or Color.New(0.486274509803922, 0.52156862745098, 0.643137254901961))
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.btnDailyTask, function()
		if nowWorld():IsSystemOpen(WorldConst.SystemDailyTask) then
			arg0_5:emit(WorldInformationMediator.OnOpenDailyTaskPanel)
		else
			pg.TipsMgr.GetInstance(i18n("world_daily_task_lock"))
		end
	end, SFX_PANEL)
	arg0_5:OnUpdateDailyTask()
	triggerToggle(arg0_5.toggleAll, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf, false)
end

function var0_0.willExit(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf)
	arg0_11.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateTask, arg0_11.onUpdateTask)
	arg0_11.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0_11.onUpdateDailyTask)
	arg0_11.wsWorldInfo:Dispose()
end

function var0_0.setWorldTaskProxy(arg0_12, arg1_12)
	arg0_12.taskProxy = arg1_12

	arg0_12.taskProxy:AddListener(WorldTaskProxy.EventUpdateTask, arg0_12.onUpdateTask)
	arg0_12.taskProxy:AddListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0_12.onUpdateDailyTask)

	arg0_12.taskList = arg0_12.taskProxy:getDoingTaskVOs()
end

function var0_0.UpdateFilterTaskList(arg0_13)
	arg0_13.filterTaskList = _.filter(arg0_13.taskList, function(arg0_14)
		return not arg0_13.filterType or arg0_14.config.type == arg0_13.filterType
	end)

	table.sort(arg0_13.filterTaskList, CompareFuncs(WorldTask.sortDic))
	arg0_13.taskItemList:align(#arg0_13.filterTaskList)
	setActive(arg0_13.rtNothingTip, #arg0_13.filterTaskList == 0)
end

function var0_0.UpdateTaskTpl(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg1_15:Find("base_panel")

	GetImageSpriteFromAtlasAsync("ui/worldtaskfloatui_atlas", pg.WorldToastMgr.Type2PictrueName[arg2_15.config.type], var0_15:Find("type"), true)
	setText(var0_15:Find("extend_show/title/Text"), arg2_15.config.name)
	setText(var0_15:Find("base_show/title/Text"), arg2_15.config.name)
	setText(var0_15:Find("base_show/desc"), arg2_15.config.description)

	local var1_15 = var0_15:Find("base_show/IconTpl")
	local var2_15 = var0_15:Find("base_show/award")

	removeAllChildren(var2_15)

	local var3_15 = arg2_15.config.show

	for iter0_15 = 1, math.min(#var3_15, 2) do
		local var4_15 = var3_15[iter0_15]
		local var5_15 = cloneTplTo(var1_15, var2_15)
		local var6_15 = {
			type = var4_15[1],
			id = var4_15[2],
			count = var4_15[3]
		}

		updateDrop(var5_15, var6_15)
		onButton(arg0_15, var5_15, function()
			arg0_15:emit(var0_0.ON_DROP, var6_15)
		end, SFX_PANEL)
		setActive(var5_15, true)
	end

	setActive(var1_15, false)
	setSlider(var0_15:Find("base_show/title/progress"), 0, arg2_15:getMaxProgress(), arg2_15:getProgress())

	local var7_15 = var0_15:Find("btn_go")

	onButton(arg0_15, var7_15, function()
		arg0_15:emit(WorldInformationMediator.OnTaskGoto, arg2_15.id)
		arg0_15:closeView()
	end, SFX_PANEL)
	setButtonEnabled(var7_15, tobool(arg2_15:GetFollowingAreaId() or arg2_15:GetFollowingEntrance()))

	local var8_15 = var0_15:Find("btn_get")

	onButton(arg0_15, var8_15, function()
		arg0_15:emit(WorldInformationMediator.OnSubmitTask, arg2_15)
	end, SFX_CONFIRM)

	local var9_15 = arg2_15:getState()

	setActive(var7_15, var9_15 == WorldTask.STATE_ONGOING)
	setActive(var8_15, var9_15 == WorldTask.STATE_FINISHED)

	local var10_15 = arg1_15:Find("extend_panel")
	local var11_15 = arg2_15.config.rare_task_icon

	if #var11_15 > 0 then
		GetImageSpriteFromAtlasAsync("shipyardicon/" .. var11_15, "", var10_15:Find("card"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/worldinformationui_atlas", "nobody", var10_15:Find("card"), true)
	end

	setText(var10_15:Find("content/desc"), arg2_15.config.rare_task_text)
	setText(var10_15:Find("content/slider_progress/Text"), arg2_15:getProgress() .. "/" .. arg2_15:getMaxProgress())
	setSlider(var10_15:Find("content/slider"), 0, arg2_15:getMaxProgress(), arg2_15:getProgress())

	local var12_15 = var10_15:Find("content/item_tpl")
	local var13_15 = var10_15:Find("content/award_bg/panel/content")
	local var14_15 = arg2_15.config.show

	removeAllChildren(var13_15)

	for iter1_15, iter2_15 in ipairs(var14_15) do
		local var15_15 = cloneTplTo(var12_15, var13_15)
		local var16_15 = {
			type = iter2_15[1],
			id = iter2_15[2],
			count = iter2_15[3]
		}

		updateDrop(var15_15, var16_15)
		onButton(arg0_15, var15_15, function()
			arg0_15:emit(var0_0.ON_DROP, var16_15)
		end, SFX_PANEL)
		setActive(var15_15, true)
	end

	setActive(var12_15, false)
	setActive(var10_15:Find("content/award_bg/arror"), #var14_15 > 3)
end

function var0_0.OnUpdateTask(arg0_20)
	arg0_20.taskList = arg0_20.taskProxy:getDoingTaskVOs()

	arg0_20:UpdateFilterTaskList()
end

function var0_0.OnUpdateDailyTask(arg0_21)
	setActive(arg0_21.btnDailyTask:Find("tip"), arg0_21.taskProxy:canAcceptDailyTask())
	setActive(arg0_21.btnDailyTask:Find("locked"), not nowWorld():IsSystemOpen(WorldConst.SystemDailyTask))
end

return var0_0
