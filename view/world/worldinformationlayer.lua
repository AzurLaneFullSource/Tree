local var0 = class("WorldInformationLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "WorldInformationUI"
end

var0.Listeners = {
	onUpdateDailyTask = "OnUpdateDailyTask",
	onUpdateTask = "OnUpdateTask"
}

function var0.init(arg0)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0.rtLeftPanel = arg0:findTF("adapt/left_panel")

	setText(arg0.rtLeftPanel:Find("title/Text"), i18n("world_map_title_tips"))
	setText(arg0.rtLeftPanel:Find("title/Text_en"), i18n("world_map_title_tips_en"))

	arg0.wsWorldInfo = WSWorldInfo.New()
	arg0.wsWorldInfo.transform = arg0.rtLeftPanel:Find("world_info")

	arg0.wsWorldInfo:Setup()
	setText(arg0.wsWorldInfo.transform:Find("power/bg/Word"), i18n("world_total_power"))
	setText(arg0.wsWorldInfo.transform:Find("explore/mileage/Text"), i18n("world_mileage"))
	setText(arg0.wsWorldInfo.transform:Find("explore/pressing/Text"), i18n("world_pressing"))

	arg0.rtRightPanel = arg0:findTF("adapt/right_panel")
	arg0.rtNothingTip = arg0.rtRightPanel:Find("nothing_tip")
	arg0.btnClose = arg0.rtRightPanel:Find("title/close_btn")
	arg0.toggleAll = arg0.rtRightPanel:Find("title/task_all")
	arg0.toggleMain = arg0.rtRightPanel:Find("title/task_main")
	arg0.rtContainer = arg0.rtRightPanel:Find("main/viewport/content")
	arg0.taskItemList = UIItemList.New(arg0.rtContainer, arg0.rtContainer:Find("task_tpl"))

	arg0.taskItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateTaskTpl(arg2, arg0.filterTaskList[arg1 + 1])
		end
	end)

	arg0.btnDailyTask = arg0.rtLeftPanel:Find("world_info/task_btn")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.btnClose, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("bg"), function()
		triggerButton(arg0.btnClose)
	end, SFX_CANCEL)
	onToggle(arg0, arg0.toggleAll, function(arg0)
		if arg0 then
			arg0.filterType = nil

			arg0:UpdateFilterTaskList()
		end

		setTextColor(arg0.toggleAll, arg0 and Color.white or Color.New(0.486274509803922, 0.52156862745098, 0.643137254901961))
	end, SFX_PANEL)
	onToggle(arg0, arg0.toggleMain, function(arg0)
		if arg0 then
			arg0.filterType = 0

			arg0:UpdateFilterTaskList()
		end

		setTextColor(arg0.toggleMain, arg0 and Color.white or Color.New(0.486274509803922, 0.52156862745098, 0.643137254901961))
	end, SFX_PANEL)
	onButton(arg0, arg0.btnDailyTask, function()
		if nowWorld():IsSystemOpen(WorldConst.SystemDailyTask) then
			arg0:emit(WorldInformationMediator.OnOpenDailyTaskPanel)
		else
			pg.TipsMgr.GetInstance(i18n("world_daily_task_lock"))
		end
	end, SFX_PANEL)
	arg0:OnUpdateDailyTask()
	triggerToggle(arg0.toggleAll, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateTask, arg0.onUpdateTask)
	arg0.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0.onUpdateDailyTask)
	arg0.wsWorldInfo:Dispose()
end

function var0.setWorldTaskProxy(arg0, arg1)
	arg0.taskProxy = arg1

	arg0.taskProxy:AddListener(WorldTaskProxy.EventUpdateTask, arg0.onUpdateTask)
	arg0.taskProxy:AddListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0.onUpdateDailyTask)

	arg0.taskList = arg0.taskProxy:getDoingTaskVOs()
end

function var0.UpdateFilterTaskList(arg0)
	arg0.filterTaskList = _.filter(arg0.taskList, function(arg0)
		return not arg0.filterType or arg0.config.type == arg0.filterType
	end)

	table.sort(arg0.filterTaskList, CompareFuncs(WorldTask.sortDic))
	arg0.taskItemList:align(#arg0.filterTaskList)
	setActive(arg0.rtNothingTip, #arg0.filterTaskList == 0)
end

function var0.UpdateTaskTpl(arg0, arg1, arg2)
	local var0 = arg1:Find("base_panel")

	GetImageSpriteFromAtlasAsync("ui/worldtaskfloatui_atlas", pg.WorldToastMgr.Type2PictrueName[arg2.config.type], var0:Find("type"), true)
	setText(var0:Find("extend_show/title/Text"), arg2.config.name)
	setText(var0:Find("base_show/title/Text"), arg2.config.name)
	setText(var0:Find("base_show/desc"), arg2.config.description)

	local var1 = var0:Find("base_show/IconTpl")
	local var2 = var0:Find("base_show/award")

	removeAllChildren(var2)

	local var3 = arg2.config.show

	for iter0 = 1, math.min(#var3, 2) do
		local var4 = var3[iter0]
		local var5 = cloneTplTo(var1, var2)
		local var6 = {
			type = var4[1],
			id = var4[2],
			count = var4[3]
		}

		updateDrop(var5, var6)
		onButton(arg0, var5, function()
			arg0:emit(var0.ON_DROP, var6)
		end, SFX_PANEL)
		setActive(var5, true)
	end

	setActive(var1, false)
	setSlider(var0:Find("base_show/title/progress"), 0, arg2:getMaxProgress(), arg2:getProgress())

	local var7 = var0:Find("btn_go")

	onButton(arg0, var7, function()
		arg0:emit(WorldInformationMediator.OnTaskGoto, arg2.id)
		arg0:closeView()
	end, SFX_PANEL)
	setButtonEnabled(var7, tobool(arg2:GetFollowingAreaId() or arg2:GetFollowingEntrance()))

	local var8 = var0:Find("btn_get")

	onButton(arg0, var8, function()
		arg0:emit(WorldInformationMediator.OnSubmitTask, arg2)
	end, SFX_CONFIRM)

	local var9 = arg2:getState()

	setActive(var7, var9 == WorldTask.STATE_ONGOING)
	setActive(var8, var9 == WorldTask.STATE_FINISHED)

	local var10 = arg1:Find("extend_panel")
	local var11 = arg2.config.rare_task_icon

	if #var11 > 0 then
		GetImageSpriteFromAtlasAsync("shipyardicon/" .. var11, "", var10:Find("card"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/worldinformationui_atlas", "nobody", var10:Find("card"), true)
	end

	setText(var10:Find("content/desc"), arg2.config.rare_task_text)
	setText(var10:Find("content/slider_progress/Text"), arg2:getProgress() .. "/" .. arg2:getMaxProgress())
	setSlider(var10:Find("content/slider"), 0, arg2:getMaxProgress(), arg2:getProgress())

	local var12 = var10:Find("content/item_tpl")
	local var13 = var10:Find("content/award_bg/panel/content")
	local var14 = arg2.config.show

	removeAllChildren(var13)

	for iter1, iter2 in ipairs(var14) do
		local var15 = cloneTplTo(var12, var13)
		local var16 = {
			type = iter2[1],
			id = iter2[2],
			count = iter2[3]
		}

		updateDrop(var15, var16)
		onButton(arg0, var15, function()
			arg0:emit(var0.ON_DROP, var16)
		end, SFX_PANEL)
		setActive(var15, true)
	end

	setActive(var12, false)
	setActive(var10:Find("content/award_bg/arror"), #var14 > 3)
end

function var0.OnUpdateTask(arg0)
	arg0.taskList = arg0.taskProxy:getDoingTaskVOs()

	arg0:UpdateFilterTaskList()
end

function var0.OnUpdateDailyTask(arg0)
	setActive(arg0.btnDailyTask:Find("tip"), arg0.taskProxy:canAcceptDailyTask())
	setActive(arg0.btnDailyTask:Find("locked"), not nowWorld():IsSystemOpen(WorldConst.SystemDailyTask))
end

return var0
