local var0_0 = class("WorldCruiseTaskPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldCruiseTaskPage"
end

function var0_0.UpdateActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2 or getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	for iter0_2, iter1_2 in pairs(arg0_2.activity:GetCrusingInfo()) do
		arg0_2[iter0_2] = iter1_2
	end

	arg0_2.taskGroupList = {}

	local var0_2 = pg.TimeMgr.GetInstance():GetServerOverWeek(arg0_2.activity:getStartTime())

	for iter2_2, iter3_2 in ipairs(arg0_2.activity:getConfig("config_data")) do
		local var1_2 = pg.battlepass_task_group[iter3_2]

		arg0_2.taskGroupList[var1_2.group_mask] = {
			task_group = var1_2.task_group,
			isLock = var0_2 < var1_2.group_mask
		}
	end

	updateCrusingActivityTask(arg0_2.activity)

	arg0_2.finishAll = arg0_2.phase == #arg0_2.awardList
end

function var0_0.OnLoaded(arg0_3)
	arg0_3:UpdateActivity()

	local var0_3 = arg0_3._tf:Find("frame")

	arg0_3.togglesTF = var0_3:Find("week_list")

	local var1_3 = var0_3:Find("view/content")
	local var2_3 = var1_3:Find("tpl")

	setText(var2_3:Find("info/go/Text"), i18n("task_go"))
	setText(var2_3:Find("info/get/Text"), i18n("task_get"))
	setText(var2_3:Find("info/got/Image/Text"), i18n("task_got"))

	local var3_3 = var2_3:Find("content/extend_tpl")

	setText(var3_3:Find("go/Text"), i18n("task_go"))
	setText(var3_3:Find("get/Text"), i18n("task_get"))
	setText(var3_3:Find("got/Image/Text"), i18n("task_got"))

	arg0_3.taskGroupItemList = UIItemList.New(var1_3, var2_3)
end

function var0_0.OnInit(arg0_4)
	arg0_4.taskGroupItemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateTaskGroup(arg2_5, arg0_4.tempTaskGroup[arg1_5])
		end
	end)
end

function var0_0.Flush(arg0_6, arg1_6)
	if arg1_6 then
		arg0_6:UpdateActivity(arg1_6)
	end

	local var0_6 = getProxy(TaskProxy)

	for iter0_6, iter1_6 in pairs(arg0_6.taskGroupList) do
		local var1_6 = arg0_6.togglesTF:Find(iter0_6)

		if iter0_6 > 0 then
			setText(var1_6:Find("off/Text"), i18n("cruise_task_week", iter0_6))
			setText(var1_6:Find("on/Text"), i18n("cruise_task_week", iter0_6))
		end

		setActive(var1_6:Find("tip"), not iter1_6.isLock and PlayerPrefs.GetInt(string.format("cursing_%d_task_week_%d", arg0_6.activity.id, iter0_6), 0) == 0)
		onToggle(arg0_6, var1_6, function(arg0_7)
			if arg0_7 then
				setActive(var1_6:Find("tip"), false)
				PlayerPrefs.SetInt(string.format("cursing_%d_task_week_%d", arg0_6.activity.id, iter0_6), 1)

				arg0_6.weekToggle = iter0_6
				arg0_6.contextData.weekToggle = iter0_6
				arg0_6.tempTaskGroup = underscore.map(iter1_6.task_group, function(arg0_8)
					return underscore.map(arg0_8, function(arg0_9)
						assert(var0_6:getTaskVO(arg0_9), "without this task:" .. arg0_9)

						return var0_6:getTaskVO(arg0_9)
					end)
				end)

				table.sort(arg0_6.tempTaskGroup, CompareFuncs({
					function(arg0_10)
						return underscore.all(arg0_10, function(arg0_11)
							return arg0_11:isReceive()
						end) and 1 or 0
					end,
					function(arg0_12)
						return arg0_12[1].id
					end
				}))
				arg0_6.taskGroupItemList:align(#arg0_6.tempTaskGroup)
			end
		end, SFX_PANEL)

		if var1_6:Find("mask") then
			setActive(var1_6:Find("mask"), iter1_6.isLock)
		end
	end

	local var2_6 = underscore.keys(arg0_6.taskGroupList)

	table.sort(var2_6, function(arg0_13, arg1_13)
		return arg0_13 < arg1_13
	end)

	if arg0_6.contextData.weekToggle and not arg0_6.taskGroupList[arg0_6.contextData.weekToggle].isLock then
		arg0_6.weekToggle = arg0_6.contextData.weekToggle
		arg0_6.contextData.weekToggle = nil
	else
		arg0_6.weekToggle = table.remove(var2_6, 1)

		for iter2_6, iter3_6 in ipairs(var2_6) do
			local var3_6 = arg0_6.taskGroupList[iter3_6]

			if var3_6.isLock then
				break
			elseif underscore.any(underscore.flatten(var3_6.task_group), function(arg0_14)
				local var0_14 = var0_6:getTaskVO(arg0_14)

				return var0_14 and not var0_14:isReceive()
			end) then
				arg0_6.weekToggle = iter3_6

				break
			end
		end
	end

	triggerToggle(arg0_6.togglesTF:Find(arg0_6.weekToggle), true)

	for iter4_6, iter5_6 in ipairs(arg0_6.taskGroupList) do
		local var4_6 = arg0_6.togglesTF:Find(iter4_6)

		SetCompomentEnabled(var4_6, typeof(Toggle), not iter5_6.isLock)

		if not iter5_6.isLock then
			setGray(var4_6, underscore.all(underscore.flatten(iter5_6.task_group), function(arg0_15)
				local var0_15 = var0_6:getTaskVO(arg0_15)

				return var0_15 and var0_15:isReceive()
			end))
		end
	end

	arg0_6:Show()
end

function var0_0.UpdateTaskGroup(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg1_16:Find("info")

	LoadImageSpriteAtlasAsync("ui/worldcruiseui_atlas", tostring(arg0_16.weekToggle), var0_16:Find("week"), true)

	local var1_16 = {}

	for iter0_16, iter1_16 in ipairs(arg2_16) do
		if not iter1_16:isReceive() then
			table.insert(var1_16, iter1_16)
		end
	end

	triggerToggle(var0_16, false)

	local var2_16 = #var1_16 > 0 and table.remove(var1_16, 1) or arg2_16[#arg2_16]

	SetCompomentEnabled(var0_16, typeof(Toggle), #var1_16 > 0)
	arg0_16:UpdateTaskDisplay(var0_16, var2_16)
	setActive(var0_16:Find("quick"), var2_16:getConfig("quick_finish") > 0 and var2_16:getTaskStatus() == 0)
	onButton(arg0_16, var0_16:Find("quick"), function()
		arg0_16:OnQuickClick(var2_16)
	end, SFX_CONFIRM)
	setActive(var0_16:Find("toggle_mark"), #var1_16 > 0)

	if #var1_16 > 0 then
		local var3_16 = arg1_16:Find("content")
		local var4_16 = UIItemList.New(var3_16, var3_16:Find("extend_tpl"))

		var4_16:make(function(arg0_18, arg1_18, arg2_18)
			arg1_18 = arg1_18 + 1

			if arg0_18 == UIItemList.EventUpdate then
				arg0_16:UpdateTaskDisplay(arg2_18, var1_16[arg1_18])
			end
		end)
		var4_16:align(#var1_16)
	end
end

function var0_0.UpdateTaskDisplay(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg2_19:getProgress()
	local var1_19 = arg2_19:getConfig("target_num")

	setSlider(arg1_19:Find("Slider"), 0, var1_19, var0_19)
	setText(arg1_19:Find("desc"), string.format("%s(%d/%d)", arg2_19:getConfig("desc"), var0_19, var1_19))

	local var2_19 = Drop.Create(arg2_19:getConfig("award_display")[1])

	updateDrop(arg1_19:Find("outline/mask/IconTpl"), var2_19)
	onButton(arg0_19, arg1_19:Find("outline/mask/IconTpl"), function()
		arg0_19:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var2_19
		})
	end, SFX_PANEL)

	local var3_19 = arg0_19.finishAll and 2 or arg2_19:getTaskStatus()

	setActive(arg1_19:Find("go"), var3_19 == 0)
	setActive(arg1_19:Find("get"), var3_19 == 1)
	setActive(arg1_19:Find("got"), var3_19 == 2)
	setActive(arg1_19:Find("outline/mask/IconTpl/mask"), var3_19 == 2)
	onButton(arg0_19, arg1_19:Find("go"), function()
		arg0_19:emit(WorldCruiseMediator.ON_TASK_GO, arg2_19)
	end, SFX_PANEL)
	onButton(arg0_19, arg1_19:Find("get"), function()
		arg0_19:emit(WorldCruiseMediator.ON_TASK_SUBMIT, arg2_19)
	end, SFX_CONFIRM)
	setActive(arg1_19:Find("quick"), arg2_19:getConfig("quick_finish") > 0 and arg2_19:getTaskStatus() == 0)
	onButton(arg0_19, arg1_19:Find("quick"), function()
		arg0_19:OnQuickClick(arg2_19)
	end, SFX_CONFIRM)
end

function var0_0.OnQuickClick(arg0_24, arg1_24)
	local var0_24 = getProxy(BagProxy):getItemCountById(Item.QUICK_TASK_PASS_TICKET_ID)
	local var1_24 = arg1_24:getConfig("quick_finish")

	if var0_24 < var1_24 then
		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
			contentText = i18n("battlepass_task_quickfinish2", var1_24 - var0_24),
			onConfirm = function()
				shoppingBatchNewStyle(Goods.CRUISE_QUICK_TASK_TICKET_ID, {
					id = Item.QUICK_TASK_PASS_TICKET_ID
				}, 20, "build_ship_quickly_buy_stone")
			end
		})
	else
		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
			contentText = i18n("battlepass_task_quickfinish1", var1_24, var0_24),
			onConfirm = function()
				arg0_24:emit(WorldCruiseMediator.ON_TASK_QUICK_SUBMIT, arg1_24)
			end
		})
	end
end

function var0_0.OnDestroy(arg0_27)
	return
end

return var0_0
