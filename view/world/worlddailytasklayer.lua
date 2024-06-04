local var0 = class("WorldDailyTaskLayer", import("view.base.BaseUI"))

var0.Listeners = {
	onUpdateTasks = "OnUpdateTasks"
}
var0.optionsPath = {
	"blur_panel/adapt/top/title/option"
}

function var0.getUIName(arg0)
	return "WorldDailyTaskUI"
end

function var0.init(arg0)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0.rtBg = arg0:findTF("bg")
	arg0.rtBlurPanel = arg0:findTF("blur_panel")
	arg0.rtTasks = arg0.rtBlurPanel:Find("adapt/tasks")

	setText(arg0.rtTasks:Find("frame/empty/Text"), i18n("world_daily_task_none"))
	setText(arg0.rtTasks:Find("frame/empty/Text_en"), i18n("world_daily_task_none_2"))

	arg0.rtTop = arg0.rtBlurPanel:Find("adapt/top")
	arg0.btnBack = arg0.rtTop:Find("title/back_button")
	arg0.btnAllAccept = arg0.rtTop:Find("title/btn_accept_all")
	arg0.rtTopTitle = arg0.rtTop:Find("title")
	arg0.rtImageTitle = arg0.rtTopTitle:Find("print/title")
	arg0.rtImageTitleTask = arg0.rtTopTitle:Find("print/title_task")
	arg0.rtImageTitleShop = arg0.rtTopTitle:Find("print/title_shop")
	arg0.rtTaskWindow = arg0:findTF("task_window")
	arg0.wsTasks = {}

	local var0 = arg0.rtTasks:Find("frame/viewport/content")
	local var1 = var0:GetChild(0)

	arg0.taskItemList = UIItemList.New(var0, var1)

	arg0.taskItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.wsTasks[arg1]

			if not var0 then
				var0 = WSPortTask.New(arg2)

				onButton(arg0, var0.btnInactive, function()
					local var0, var1 = WorldTask.canTrigger(var0.task.id)

					if var0 then
						arg0:emit(WorldDailyTaskMediator.OnAccepetTask, {
							var0.task.id
						})
					else
						pg.TipsMgr.GetInstance():ShowTips(var1)
					end
				end, SFX_PANEL)
				onButton(arg0, var0.btnOnGoing, function()
					arg0:showTaskWindow(var0.task)
				end, SFX_PANEL)
				onButton(arg0, var0.btnFinished, function()
					arg0:emit(WorldDailyTaskMediator.OnSubmitTask, var0.task)
				end, SFX_PANEL)

				function var0.onDrop(arg0)
					arg0:emit(var0.ON_DROP, arg0)
				end

				arg0.wsTasks[arg1] = var0
			end

			var0:Setup(arg0.taskVOs[arg1])
		end
	end)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData()
	})
	pg.UIMgr.GetInstance():BlurPanel(arg0.rtBlurPanel, false, {
		blurLevelCamera = true
	})
	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnAllAccept, function()
		arg0:emit(WorldDailyTaskMediator.OnAccepetTask, underscore.map(arg0.taskVOs, function(arg0)
			return arg0.id
		end))
	end, SFX_CONFIRM)
	arg0:OnUpdateTasks()
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.btnBack)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.rtBlurPanel, arg0._tf)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0:DisposeTasks()
	arg0.taskProxy:RemoveListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0.onUpdateTasks)

	arg0.taskProxy = nil
end

function var0.SetTaskProxy(arg0, arg1)
	arg0.taskProxy = arg1

	arg0.taskProxy:AddListener(WorldTaskProxy.EventUpdateDailyTaskIds, arg0.onUpdateTasks)
end

function var0.OnUpdateTasks(arg0)
	arg0.taskVOs = underscore.map(arg0.taskProxy:getDailyTaskIds(), function(arg0)
		return WorldTask.New({
			id = arg0
		})
	end)

	table.sort(arg0.taskVOs, CompareFuncs(WorldTask.sortDic))
	arg0.taskItemList:align(#arg0.taskVOs)

	local var0 = arg0.rtTasks:Find("frame/empty")

	setActive(var0, #arg0.taskVOs == 0)
	setActive(arg0.btnAllAccept, arg0.taskProxy:canAcceptDailyTask())
end

function var0.DisposeTasks(arg0)
	_.each(arg0.wsTasks, function(arg0)
		arg0:Dispose()
	end)

	arg0.wsTasks = nil
end

function var0.showTaskWindow(arg0, arg1)
	local var0 = arg1.config.rare_task_icon
	local var1 = arg0.rtTaskWindow:Find("main_window/left_panel")

	setActive(var1:Find("bg"), arg1:IsSpecialType())

	if #var0 > 0 then
		GetImageSpriteFromAtlasAsync("shipyardicon/" .. var0, "", var1:Find("card"), true)
	else
		GetImageSpriteFromAtlasAsync("ui/worldportui_atlas", "nobody", var1:Find("card"), true)
	end

	local var2 = arg0.rtTaskWindow:Find("main_window/right_panel")

	setText(var2:Find("title/Text"), arg1.config.name)
	setText(var2:Find("content/desc"), arg1.config.rare_task_text)
	setText(var2:Find("content/slider_progress/Text"), arg1:getProgress() .. "/" .. arg1:getMaxProgress())
	setSlider(var2:Find("content/slider"), 0, arg1:getMaxProgress(), arg1:getProgress())

	local var3 = var2:Find("content/item_tpl")
	local var4 = var2:Find("content/award_bg/panel/content")
	local var5 = arg1.config.show

	removeAllChildren(var4)

	for iter0, iter1 in ipairs(var5) do
		local var6 = cloneTplTo(var3, var4)
		local var7 = {
			type = iter1[1],
			id = iter1[2],
			count = iter1[3]
		}

		updateDrop(var6, var7)
		onButton(arg0, var6, function()
			arg0:emit(var0.ON_DROP, var7)
		end, SFX_PANEL)
		setActive(var6, true)
	end

	setActive(var3, false)
	setActive(var2:Find("content/award_bg/arror"), #var5 > 3)
	onButton(arg0, var2:Find("btn_close"), function()
		arg0:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(arg0, arg0.rtTaskWindow:Find("bg"), function()
		arg0:hideTaskWindow()
	end, SFX_CANCEL)
	onButton(arg0, var2:Find("btn_go"), function()
		arg0:hideTaskWindow()
		arg0:emit(WorldDailyTaskMediator.OnTaskGoto, arg1.id)
	end, SFX_PANEL)
	setButtonEnabled(var2:Find("btn_go"), arg1:GetFollowingAreaId() or arg1:GetFollowingEntrance())
	setActive(arg0.rtTaskWindow, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.rtTaskWindow, arg0._tf)
end

function var0.hideTaskWindow(arg0)
	setActive(arg0.rtTaskWindow, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.rtTaskWindow, arg0._tf)
end

return var0
