local var0_0 = class("WorldDailyTaskLayer", import("view.base.BaseUI"))

var0_0.Listeners = {
	onUpdateTasks = "OnUpdateTasks"
}
var0_0.optionsPath = {
	"blur_panel/adapt/top/title/option"
}

function var0_0.getUIName(arg0_1)
	return "WorldDailyTaskUI"
end

function var0_0.init(arg0_2)
	for iter0_2, iter1_2 in pairs(var0_0.Listeners) do
		arg0_2[iter0_2] = function(...)
			var0_0[iter1_2](arg0_2, ...)
		end
	end

	arg0_2.rtBg = arg0_2:findTF("bg")
	arg0_2.rtBlurPanel = arg0_2:findTF("blur_panel")
	arg0_2.rtTasks = arg0_2.rtBlurPanel:Find("adapt/tasks")

	setText(arg0_2.rtTasks:Find("frame/empty/Text"), i18n("world_daily_task_none"))
	setText(arg0_2.rtTasks:Find("frame/empty/Text_en"), i18n("world_daily_task_none_2"))

	arg0_2.rtTop = arg0_2.rtBlurPanel:Find("adapt/top")
	arg0_2.btnBack = arg0_2.rtTop:Find("title/back_button")
	arg0_2.btnAllAccept = arg0_2.rtTop:Find("title/btn_accept_all")
	arg0_2.rtTopTitle = arg0_2.rtTop:Find("title")
	arg0_2.rtImageTitle = arg0_2.rtTopTitle:Find("print/title")
	arg0_2.rtImageTitleTask = arg0_2.rtTopTitle:Find("print/title_task")
	arg0_2.rtImageTitleShop = arg0_2.rtTopTitle:Find("print/title_shop")
	arg0_2.rtTaskWindow = arg0_2:findTF("task_window")
	arg0_2.wsTasks = {}

	local var0_2 = arg0_2.rtTasks:Find("frame/viewport/content")
	local var1_2 = var0_2:GetChild(0)

	arg0_2.taskItemList = UIItemList.New(var0_2, var1_2)

	arg0_2.taskItemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_2.wsTasks[arg1_4]

			if not var0_4 then
				var0_4 = WSPortTask.New(arg2_4)

				onButton(arg0_2, var0_4.btnInactive, function()
					local var0_5, var1_5 = WorldTask.canTrigger(var0_4.task.id)

					if var0_5 then
						arg0_2:emit(WorldDailyTaskMediator.OnAccepetTask, {
							var0_4.task.id
						})
					else
						pg.TipsMgr.GetInstance():ShowTips(var1_5)
					end
				end, SFX_PANEL)
				onButton(arg0_2, var0_4.btnOnGoing, function()
					arg0_2:showTaskWindow(var0_4.task)
				end, SFX_PANEL)
				onButton(arg0_2, var0_4.btnFinished, function()
					arg0_2:emit(WorldDailyTaskMediator.OnSubmitTask, var0_4.task)
				end, SFX_PANEL)

				function var0_4.onDrop(arg0_8)
					arg0_2:emit(var0_0.ON_DROP, arg0_8)
				end

				arg0_2.wsTasks[arg1_4] = var0_4
			end

			var0_4:Setup(arg0_2.taskVOs[arg1_4])
		end
	end)
end

function var0_0.didEnter(arg0_9)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf, {
		groupName = arg0_9:getGroupNameFromData()
	})
	pg.UIMgr.GetInstance():BlurPanel(arg0_9.rtBlurPanel, false, {
		blurLevelCamera = true
	})
	onButton(arg0_9, arg0_9.btnBack, function()
		arg0_9:closeView()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.btnAllAccept, function()
		arg0_9:emit(WorldDailyTaskMediator.OnAccepetTask, underscore.map(arg0_9.taskVOs, function(arg0_12)
			return arg0_12.id
		end))
	end, SFX_CONFIRM)
	arg0_9:OnUpdateTasks()
end

function var0_0.onBackPressed(arg0_13)
	triggerButton(arg0_13.btnBack)
end

function var0_0.willExit(arg0_14)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_14.rtBlurPanel, arg0_14._tf)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_14._tf)
	arg0_14:DisposeTasks()
	arg0_14.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0_14.onUpdateTasks)

	arg0_14.taskProxy = nil
end

function var0_0.SetTaskProxy(arg0_15, arg1_15)
	arg0_15.taskProxy = arg1_15

	arg0_15.taskProxy:AddListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0_15.onUpdateTasks)
end

function var0_0.OnUpdateTasks(arg0_16)
	arg0_16.taskVOs = underscore.map(arg0_16.taskProxy:getDailyTaskIds(), function(arg0_17)
		return WorldTask.New({
			id = arg0_17
		})
	end)

	table.sort(arg0_16.taskVOs, CompareFuncs(WorldTask.sortDic))
	arg0_16.taskItemList:align(#arg0_16.taskVOs)

	local var0_16 = arg0_16.rtTasks:Find("frame/empty")

	setActive(var0_16, #arg0_16.taskVOs == 0)
	setActive(arg0_16.btnAllAccept, arg0_16.taskProxy:canAcceptDailyTask())
end

function var0_0.DisposeTasks(arg0_18)
	_.each(arg0_18.wsTasks, function(arg0_19)
		arg0_19:Dispose()
	end)

	arg0_18.wsTasks = nil
end

function var0_0.showTaskWindow(arg0_20, arg1_20)
	local var0_20 = arg1_20.config.rare_task_icon
	local var1_20 = arg0_20.rtTaskWindow:Find("main_window/left_panel")

	setActive(var1_20:Find("bg"), arg1_20:IsSpecialType())

	if #var0_20 > 0 then
		GetImageSpriteFromAtlasAsync("shipyardicon/" .. var0_20, "", var1_20:Find("card"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/worldportui_atlas", "nobody", var1_20:Find("card"), true)
	end

	local var2_20 = arg0_20.rtTaskWindow:Find("main_window/right_panel")

	setText(var2_20:Find("title/Text"), arg1_20.config.name)
	setText(var2_20:Find("content/desc"), arg1_20.config.rare_task_text)
	setText(var2_20:Find("content/slider_progress/Text"), arg1_20:getProgress() .. "/" .. arg1_20:getMaxProgress())
	setSlider(var2_20:Find("content/slider"), 0, arg1_20:getMaxProgress(), arg1_20:getProgress())

	local var3_20 = var2_20:Find("content/item_tpl")
	local var4_20 = var2_20:Find("content/award_bg/panel/content")
	local var5_20 = arg1_20.config.show

	removeAllChildren(var4_20)

	for iter0_20, iter1_20 in ipairs(var5_20) do
		local var6_20 = cloneTplTo(var3_20, var4_20)
		local var7_20 = {
			type = iter1_20[1],
			id = iter1_20[2],
			count = iter1_20[3]
		}

		updateDrop(var6_20, var7_20)
		onButton(arg0_20, var6_20, function()
			arg0_20:emit(var0_0.ON_DROP, var7_20)
		end, SFX_PANEL)
		setActive(var6_20, true)
	end

	setActive(var3_20, false)
	setActive(var2_20:Find("content/award_bg/arror"), #var5_20 > 3)
	onButton(arg0_20, var2_20:Find("btn_close"), function()
		arg0_20:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(arg0_20, arg0_20.rtTaskWindow:Find("bg"), function()
		arg0_20:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(arg0_20, var2_20:Find("btn_go"), function()
		arg0_20:hideTaskWindow()
		arg0_20:emit(WorldDailyTaskMediator.OnTaskGoto, arg1_20.id)
	end, SFX_PANEL)
	setButtonEnabled(var2_20:Find("btn_go"), arg1_20:GetFollowingAreaId() or arg1_20:GetFollowingEntrance())
	setActive(arg0_20.rtTaskWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_20.rtTaskWindow, arg0_20._tf)
end

function var0_0.hideTaskWindow(arg0_25)
	setActive(arg0_25.rtTaskWindow, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_25.rtTaskWindow, arg0_25._tf)
end

return var0_0
