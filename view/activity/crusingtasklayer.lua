local var0_0 = class("CrusingTaskLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CrusingTaskUI"
end

function var0_0.tempCache(arg0_2)
	return true
end

function var0_0.init(arg0_3)
	arg0_3.rtBg = arg0_3._tf:Find("bg")

	local var0_3 = arg0_3._tf:Find("window")

	arg0_3.itemQuick = var0_3:Find("item_quick")
	arg0_3.btnBack = var0_3:Find("btn_back")
	arg0_3.btnHelp = var0_3:Find("btn_help")
	arg0_3.textPhase = var0_3:Find("text_phase")
	arg0_3.sliderPt = var0_3:Find("Slider")
	arg0_3.textComplete = var0_3:Find("text_complete")

	local var1_3 = var0_3:Find("view/content")

	arg0_3.taskGroupItemList = UIItemList.New(var1_3, var1_3:Find("tpl"))

	arg0_3.taskGroupItemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			arg0_3:updateTaskGroup(arg2_4, arg0_3.tempTaskGroup[arg1_4])
		end
	end)

	arg0_3.rtWeekToggles = var0_3:Find("week_list")
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf)
	onButton(arg0_5, arg0_5.rtBg, function()
		arg0_5:emit(CrusingTaskMediator.ON_EXIT)
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.btnBack, function()
		arg0_5:emit(CrusingTaskMediator.ON_EXIT)
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("cruise_task_help_" .. pg.battlepass_event_pt[arg0_5.activity.id].map_name)
		})
	end, SFX_PANEL)

	local var0_5 = getProxy(TaskProxy)

	for iter0_5, iter1_5 in pairs(arg0_5.taskGroupList) do
		local var1_5 = arg0_5.rtWeekToggles:Find(iter0_5)

		if iter0_5 > 0 then
			setText(var1_5:Find("off/Text"), i18n("cruise_task_week", iter0_5))
			setText(var1_5:Find("on/Text"), i18n("cruise_task_week", iter0_5))
		end

		setActive(var1_5:Find("tip"), not iter1_5.isLock and PlayerPrefs.GetInt(string.format("cursing_%d_task_week_%d", arg0_5.activity.id, iter0_5), 0) == 0)
		onToggle(arg0_5, var1_5, function(arg0_9)
			if arg0_9 then
				setActive(var1_5:Find("tip"), false)
				PlayerPrefs.SetInt(string.format("cursing_%d_task_week_%d", arg0_5.activity.id, iter0_5), 1)

				arg0_5.weekToggle = iter0_5
				arg0_5.contextData.weekToggle = iter0_5
				arg0_5.tempTaskGroup = underscore.map(iter1_5.task_group, function(arg0_10)
					return underscore.map(arg0_10, function(arg0_11)
						assert(var0_5:getTaskVO(arg0_11), "without this task:" .. arg0_11)

						return var0_5:getTaskVO(arg0_11)
					end)
				end)

				table.sort(arg0_5.tempTaskGroup, CompareFuncs({
					function(arg0_12)
						return underscore.all(arg0_12, function(arg0_13)
							return arg0_13:isReceive()
						end) and 1 or 0
					end,
					function(arg0_14)
						return arg0_14[1].id
					end
				}))
				arg0_5.taskGroupItemList:align(#arg0_5.tempTaskGroup)
				arg0_5:updateTaskInfo()
			end
		end, SFX_PANEL)

		if var1_5:Find("mask") then
			setActive(var1_5:Find("mask"), iter1_5.isLock)
		end
	end

	local var2_5 = underscore.keys(arg0_5.taskGroupList)

	table.sort(var2_5, function(arg0_15, arg1_15)
		return arg0_15 < arg1_15
	end)

	if arg0_5.contextData.weekToggle and not arg0_5.taskGroupList[arg0_5.contextData.weekToggle].isLock then
		arg0_5.weekToggle = arg0_5.contextData.weekToggle
		arg0_5.contextData.weekToggle = nil
	else
		arg0_5.weekToggle = table.remove(var2_5, 1)

		for iter2_5, iter3_5 in ipairs(var2_5) do
			local var3_5 = arg0_5.taskGroupList[iter3_5]

			if var3_5.isLock then
				break
			elseif underscore.any(underscore.flatten(var3_5.task_group), function(arg0_16)
				local var0_16 = var0_5:getTaskVO(arg0_16)

				return var0_16 and not var0_16:isReceive()
			end) then
				arg0_5.weekToggle = iter3_5

				break
			end
		end
	end

	triggerToggle(arg0_5.rtWeekToggles:Find(arg0_5.weekToggle), true)

	for iter4_5, iter5_5 in ipairs(arg0_5.taskGroupList) do
		local var4_5 = arg0_5.rtWeekToggles:Find(iter4_5)

		SetCompomentEnabled(var4_5, typeof(Toggle), not iter5_5.isLock)

		if not iter5_5.isLock then
			setGray(var4_5, underscore.all(underscore.flatten(iter5_5.task_group), function(arg0_17)
				local var0_17 = var0_5:getTaskVO(arg0_17)

				return var0_17 and var0_17:isReceive()
			end))
		end
	end

	arg0_5:updatePhaseInfo()
	LoadImageSpriteAtlasAsync(Drop.New({
		type = DROP_TYPE_VITEM,
		id = arg0_5.ptId
	}):getIcon(), "", arg0_5.sliderPt:Find("icon"), true)
	onButton(arg0_5, arg0_5.itemQuick, function()
		arg0_5:emit(var0_0.ON_DROP, {
			count = 1,
			type = DROP_TYPE_ITEM,
			id = Item.QUICK_TASK_PASS_TICKET_ID
		})
	end, SFX_PANEL)
	LoadImageSpriteAtlasAsync(Drop.New({
		type = DROP_TYPE_ITEM,
		id = Item.QUICK_TASK_PASS_TICKET_ID
	}):getIcon(), "", arg0_5.itemQuick:Find("icon"), true)
	onButton(arg0_5, arg0_5.itemQuick:Find("plus"), function()
		shoppingBatch(61017, {
			id = Item.QUICK_TASK_PASS_TICKET_ID
		}, 20, "build_ship_quickly_buy_stone")
	end)
	arg0_5:updateItemInfo()
	setText(arg0_5.textComplete:Find("Text"), i18n("cruise_task_tips"))
end

function var0_0.willExit(arg0_20)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_20._tf)
end

function var0_0.setActivity(arg0_21, arg1_21)
	arg0_21.activity = arg1_21

	for iter0_21, iter1_21 in pairs(arg1_21:GetCrusingInfo()) do
		arg0_21[iter0_21] = iter1_21
	end

	arg0_21.taskGroupList = {}

	local var0_21 = arg1_21:getNDay()

	for iter2_21, iter3_21 in ipairs(arg1_21:getConfig("config_data")) do
		local var1_21 = pg.battlepass_task_group[iter3_21]

		arg0_21.taskGroupList[var1_21.group_mask] = {
			task_group = var1_21.task_group,
			isLock = var0_21 < var1_21.time
		}
	end
end

function var0_0.updatePhaseInfo(arg0_22)
	setText(arg0_22.textPhase, i18n("cruise_task_phase", arg0_22.phase))

	if arg0_22.phase < #arg0_22.awardList then
		local var0_22 = arg0_22.phase == 0 and 0 or arg0_22.awardList[arg0_22.phase].pt
		local var1_22 = arg0_22.pt - var0_22
		local var2_22 = arg0_22.awardList[arg0_22.phase + 1].pt - var0_22

		setSlider(arg0_22.sliderPt, 0, var2_22, var1_22)
		setText(arg0_22.sliderPt:Find("Text"), var1_22 .. "/" .. var2_22)
	else
		setSlider(arg0_22.sliderPt, 0, 1, 1)
		setText(arg0_22.sliderPt:Find("Text"), "MAX")
	end
end

function var0_0.updateTaskInfo(arg0_23)
	local var0_23 = 0
	local var1_23 = 0

	underscore.each(arg0_23.tempTaskGroup, function(arg0_24)
		underscore.each(arg0_24, function(arg0_25)
			var1_23 = var1_23 + 1

			if arg0_25:isReceive() then
				var0_23 = var0_23 + 1
			end
		end)
	end)
	setText(arg0_23.textComplete, var0_23 .. "/" .. var1_23)
end

function var0_0.updateItemInfo(arg0_26)
	setText(arg0_26.itemQuick, getProxy(BagProxy):getItemCountById(Item.QUICK_TASK_PASS_TICKET_ID))
end

function var0_0.updateTaskGroup(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg1_27:Find("info")

	LoadImageSpriteAtlasAsync("ui/crusingtaskui_atlas", tostring(arg0_27.weekToggle), var0_27:Find("week"), true)

	local var1_27 = {}

	for iter0_27, iter1_27 in ipairs(arg2_27) do
		if not iter1_27:isReceive() then
			table.insert(var1_27, iter1_27)
		end
	end

	triggerToggle(var0_27, false)

	local var2_27 = #var1_27 > 0 and table.remove(var1_27, 1) or arg2_27[#arg2_27]

	SetCompomentEnabled(var0_27, typeof(Toggle), #var1_27 > 0)
	arg0_27:updateTaskDisplay(var0_27, var2_27)
	setActive(var0_27:Find("quick"), var2_27:getConfig("quick_finish") > 0 and var2_27:getTaskStatus() == 0)
	onButton(arg0_27, var0_27:Find("quick"), function()
		local var0_28 = getProxy(BagProxy):getItemCountById(Item.QUICK_TASK_PASS_TICKET_ID)
		local var1_28 = var2_27:getConfig("quick_finish")

		if var0_28 < var1_28 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("battlepass_task_quickfinish2", var1_28 - var0_28),
				onYes = function()
					shoppingBatch(61017, {
						id = Item.QUICK_TASK_PASS_TICKET_ID
					}, 20, "build_ship_quickly_buy_stone")
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("battlepass_task_quickfinish1", var1_28, var0_28),
				onYes = function()
					arg0_27:emit(CrusingTaskMediator.ON_TASK_QUICK_SUBMIT, var2_27)
				end
			})
		end
	end, SFX_CONFIRM)
	setActive(var0_27:Find("toggle_mark"), #var1_27 > 0)

	if #var1_27 > 0 then
		local var3_27 = arg1_27:Find("content")
		local var4_27 = UIItemList.New(var3_27, var3_27:Find("extend_tpl"))

		var4_27:make(function(arg0_31, arg1_31, arg2_31)
			arg1_31 = arg1_31 + 1

			if arg0_31 == UIItemList.EventUpdate then
				arg0_27:updateTaskDisplay(arg2_31, var1_27[arg1_31])
			end
		end)
		var4_27:align(#var1_27)
	end
end

function var0_0.updateTaskDisplay(arg0_32, arg1_32, arg2_32)
	setText(arg1_32:Find("desc"), arg2_32:getConfig("desc"))

	local var0_32 = arg2_32:getProgress()
	local var1_32 = arg2_32:getConfig("target_num")

	setSlider(arg1_32:Find("Slider"), 0, var1_32, var0_32)
	setText(arg1_32:Find("Slider/Text"), var0_32 .. "/" .. var1_32)

	local var2_32 = arg2_32:getConfig("award_display")[1]
	local var3_32 = {
		type = var2_32[1],
		id = var2_32[2],
		count = var2_32[3]
	}

	updateDrop(arg1_32:Find("IconTpl"), var3_32)
	onButton(arg0_32, arg1_32:Find("IconTpl"), function()
		arg0_32:emit(var0_0.ON_DROP, var3_32)
	end, SFX_PANEL)

	local var4_32 = arg2_32:getTaskStatus()

	setActive(arg1_32:Find("go"), var4_32 == 0)
	setActive(arg1_32:Find("get"), var4_32 == 1)
	setActive(arg1_32:Find("got"), var4_32 == 2)
	setActive(arg1_32:Find("IconTpl/mask"), var4_32 == 2)
	setActive(arg1_32:Find("IconTpl/mark"), var4_32 == 2)
	onButton(arg0_32, arg1_32:Find("go"), function()
		arg0_32:emit(CrusingTaskMediator.ON_TASK_GO, arg2_32)
	end, SFX_PANEL)
	onButton(arg0_32, arg1_32:Find("get"), function()
		arg0_32:emit(CrusingTaskMediator.ON_TASK_SUBMIT, arg2_32)
	end, SFX_CONFIRM)
end

function var0_0.updateCurrentTaskGroup(arg0_36)
	triggerToggle(arg0_36.rtWeekToggles:Find(arg0_36.weekToggle), true)
end

return var0_0
