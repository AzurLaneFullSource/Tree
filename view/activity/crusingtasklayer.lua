local var0 = class("CrusingTaskLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "CrusingTaskUI"
end

function var0.tempCache(arg0)
	return true
end

function var0.init(arg0)
	arg0.rtBg = arg0._tf:Find("bg")

	local var0 = arg0._tf:Find("window")

	arg0.itemQuick = var0:Find("item_quick")
	arg0.btnBack = var0:Find("btn_back")
	arg0.btnHelp = var0:Find("btn_help")
	arg0.textPhase = var0:Find("text_phase")
	arg0.sliderPt = var0:Find("Slider")
	arg0.textComplete = var0:Find("text_complete")

	local var1 = var0:Find("view/content")

	arg0.taskGroupItemList = UIItemList.New(var1, var1:Find("tpl"))

	arg0.taskGroupItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			arg0:updateTaskGroup(arg2, arg0.tempTaskGroup[arg1])
		end
	end)

	arg0.rtWeekToggles = var0:Find("week_list")
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	onButton(arg0, arg0.rtBg, function()
		arg0:emit(CrusingTaskMediator.ON_EXIT)
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnBack, function()
		arg0:emit(CrusingTaskMediator.ON_EXIT)
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n(arg0.activity:getConfig("config_client").tips[3])
		})
	end, SFX_PANEL)

	local var0 = getProxy(TaskProxy)

	for iter0, iter1 in pairs(arg0.taskGroupList) do
		local var1 = arg0.rtWeekToggles:Find(iter0)

		if iter0 > 0 then
			setText(var1:Find("off/Text"), i18n("cruise_task_week", iter0))
			setText(var1:Find("on/Text"), i18n("cruise_task_week", iter0))
		end

		setActive(var1:Find("tip"), not iter1.isLock and PlayerPrefs.GetInt(string.format("cursing_%d_task_week_%d", arg0.activity.id, iter0), 0) == 0)
		onToggle(arg0, var1, function(arg0)
			if arg0 then
				setActive(var1:Find("tip"), false)
				PlayerPrefs.SetInt(string.format("cursing_%d_task_week_%d", arg0.activity.id, iter0), 1)

				arg0.weekToggle = iter0
				arg0.contextData.weekToggle = iter0
				arg0.tempTaskGroup = underscore.map(iter1.task_group, function(arg0)
					return underscore.map(arg0, function(arg0)
						assert(var0:getTaskVO(arg0), "without this task:" .. arg0)

						return var0:getTaskVO(arg0)
					end)
				end)

				table.sort(arg0.tempTaskGroup, CompareFuncs({
					function(arg0)
						return underscore.all(arg0, function(arg0)
							return arg0:isReceive()
						end) and 1 or 0
					end,
					function(arg0)
						return arg0[1].id
					end
				}))
				arg0.taskGroupItemList:align(#arg0.tempTaskGroup)
				arg0:updateTaskInfo()
			end
		end, SFX_PANEL)

		if var1:Find("mask") then
			setActive(var1:Find("mask"), iter1.isLock)
		end
	end

	local var2 = underscore.keys(arg0.taskGroupList)

	table.sort(var2, function(arg0, arg1)
		return arg0 < arg1
	end)

	if arg0.contextData.weekToggle and not arg0.taskGroupList[arg0.contextData.weekToggle].isLock then
		arg0.weekToggle = arg0.contextData.weekToggle
		arg0.contextData.weekToggle = nil
	else
		arg0.weekToggle = table.remove(var2, 1)

		for iter2, iter3 in ipairs(var2) do
			local var3 = arg0.taskGroupList[iter3]

			if var3.isLock then
				break
			elseif underscore.any(underscore.flatten(var3.task_group), function(arg0)
				local var0 = var0:getTaskVO(arg0)

				return var0 and not var0:isReceive()
			end) then
				arg0.weekToggle = iter3

				break
			end
		end
	end

	triggerToggle(arg0.rtWeekToggles:Find(arg0.weekToggle), true)

	for iter4, iter5 in ipairs(arg0.taskGroupList) do
		local var4 = arg0.rtWeekToggles:Find(iter4)

		SetCompomentEnabled(var4, typeof(Toggle), not iter5.isLock)

		if not iter5.isLock then
			setGray(var4, underscore.all(underscore.flatten(iter5.task_group), function(arg0)
				local var0 = var0:getTaskVO(arg0)

				return var0 and var0:isReceive()
			end))
		end
	end

	arg0:updatePhaseInfo()
	LoadImageSpriteAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg0.ptId
	}):getIcon(), "", arg0.sliderPt:Find("icon"), true)
	onButton(arg0, arg0.itemQuick, function()
		arg0:emit(var0.ON_DROP, {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = Item.QUICK_TASK_PASS_TICKET_ID
		})
	end, SFX_PANEL)
	LoadImageSpriteAtlasAsync(Drop.New({
		type = DROP_TYPE_ITEM,
		id = Item.QUICK_TASK_PASS_TICKET_ID
	}):getIcon(), "", arg0.itemQuick:Find("icon"), true)
	onButton(arg0, arg0.itemQuick:Find("plus"), function()
		shoppingBatch(61017, {
			id = Item.QUICK_TASK_PASS_TICKET_ID
		}, 20, "build_ship_quickly_buy_stone")
	end)
	arg0:updateItemInfo()
	setText(arg0.textComplete:Find("Text"), i18n("cruise_task_tips"))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.setActivity(arg0, arg1)
	arg0.activity = arg1

	for iter0, iter1 in pairs(arg1:GetCrusingInfo()) do
		arg0[iter0] = iter1
	end

	arg0.taskGroupList = {}

	local var0 = arg1:getNDay()

	for iter2, iter3 in ipairs(arg1:getConfig("config_data")) do
		local var1 = pg.battlepass_task_group[iter3]

		arg0.taskGroupList[var1.group_mask] = {
			task_group = var1.task_group,
			isLock = var0 < var1.time
		}
	end
end

function var0.updatePhaseInfo(arg0)
	setText(arg0.textPhase, i18n("cruise_task_phase", arg0.phase))

	if arg0.phase < #arg0.awardList then
		local var0 = arg0.phase == 0 and 0 or arg0.awardList[arg0.phase].pt
		local var1 = arg0.pt - var0
		local var2 = arg0.awardList[arg0.phase + 1].pt - var0

		setSlider(arg0.sliderPt, 0, var2, var1)
		setText(arg0.sliderPt:Find("Text"), var1 .. "/" .. var2)
	else
		setSlider(arg0.sliderPt, 0, 1, 1)
		setText(arg0.sliderPt:Find("Text"), "MAX")
	end
end

function var0.updateTaskInfo(arg0)
	local var0 = 0
	local var1 = 0

	underscore.each(arg0.tempTaskGroup, function(arg0)
		underscore.each(arg0, function(arg0)
			var1 = var1 + 1

			if arg0:isReceive() then
				var0 = var0 + 1
			end
		end)
	end)
	setText(arg0.textComplete, var0 .. "/" .. var1)
end

function var0.updateItemInfo(arg0)
	setText(arg0.itemQuick, getProxy(BagProxy):getItemCountById(Item.QUICK_TASK_PASS_TICKET_ID))
end

function var0.updateTaskGroup(arg0, arg1, arg2)
	local var0 = arg1:Find("info")

	LoadImageSpriteAtlasAsync("ui/crusingtaskui_atlas", tostring(arg0.weekToggle), var0:Find("week"), true)

	local var1 = {}

	for iter0, iter1 in ipairs(arg2) do
		if not iter1:isReceive() then
			table.insert(var1, iter1)
		end
	end

	triggerToggle(var0, false)

	local var2 = #var1 > 0 and table.remove(var1, 1) or arg2[#arg2]

	SetCompomentEnabled(var0, typeof(Toggle), #var1 > 0)
	arg0:updateTaskDisplay(var0, var2)
	setActive(var0:Find("quick"), var2:getConfig("quick_finish") > 0 and var2:getTaskStatus() == 0)
	onButton(arg0, var0:Find("quick"), function()
		local var0 = getProxy(BagProxy):getItemCountById(Item.QUICK_TASK_PASS_TICKET_ID)
		local var1 = var2:getConfig("quick_finish")

		if var0 < var1 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("battlepass_task_quickfinish2", var1 - var0),
				onYes = function()
					shoppingBatch(61017, {
						id = Item.QUICK_TASK_PASS_TICKET_ID
					}, 20, "build_ship_quickly_buy_stone")
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("battlepass_task_quickfinish1", var1, var0),
				onYes = function()
					arg0:emit(CrusingTaskMediator.ON_TASK_QUICK_SUBMIT, var2)
				end
			})
		end
	end, SFX_CONFIRM)
	setActive(var0:Find("toggle_mark"), #var1 > 0)

	if #var1 > 0 then
		local var3 = arg1:Find("content")
		local var4 = UIItemList.New(var3, var3:Find("extend_tpl"))

		var4:make(function(arg0, arg1, arg2)
			arg1 = arg1 + 1

			if arg0 == UIItemList.EventUpdate then
				arg0:updateTaskDisplay(arg2, var1[arg1])
			end
		end)
		var4:align(#var1)
	end
end

function var0.updateTaskDisplay(arg0, arg1, arg2)
	setText(arg1:Find("desc"), arg2:getConfig("desc"))

	local var0 = arg2:getProgress()
	local var1 = arg2:getConfig("target_num")

	setSlider(arg1:Find("Slider"), 0, var1, var0)
	setText(arg1:Find("Slider/Text"), var0 .. "/" .. var1)

	local var2 = arg2:getConfig("award_display")[1]
	local var3 = {
		type = var2[1],
		id = var2[2],
		count = var2[3]
	}

	updateDrop(arg1:Find("IconTpl"), var3)
	onButton(arg0, arg1:Find("IconTpl"), function()
		arg0:emit(var0.ON_DROP, var3)
	end, SFX_PANEL)

	local var4 = arg2:getTaskStatus()

	setActive(arg1:Find("go"), var4 == 0)
	setActive(arg1:Find("get"), var4 == 1)
	setActive(arg1:Find("got"), var4 == 2)
	setActive(arg1:Find("IconTpl/mask"), var4 == 2)
	setActive(arg1:Find("IconTpl/mark"), var4 == 2)
	onButton(arg0, arg1:Find("go"), function()
		arg0:emit(CrusingTaskMediator.ON_TASK_GO, arg2)
	end, SFX_PANEL)
	onButton(arg0, arg1:Find("get"), function()
		arg0:emit(CrusingTaskMediator.ON_TASK_SUBMIT, arg2)
	end, SFX_CONFIRM)
end

function var0.updateCurrentTaskGroup(arg0)
	triggerToggle(arg0.rtWeekToggles:Find(arg0.weekToggle), true)
end

return var0
