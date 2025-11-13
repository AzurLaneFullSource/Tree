local var0_0 = class("PSSHei5TaskPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PSSHei5TaskPage"
end

function var0_0.UpdateActivity(arg0_2, arg1_2)
	arg0_2.activity = arg1_2 or getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5)

	for iter0_2, iter1_2 in pairs(arg0_2.activity:GetHei5Info()) do
		arg0_2[iter0_2] = iter1_2
	end

	arg0_2.taskGroupList = {}

	local var0_2 = pg.TimeMgr.GetInstance():GetServerDay(arg0_2.activity:getStartTime())

	for iter2_2, iter3_2 in ipairs(arg0_2.activity:getConfig("config_data")) do
		local var1_2 = pg.black_friday_battlepass_task_group[iter3_2]

		arg0_2.taskGroupList[var1_2.group_mask] = {
			task_group = var1_2.task_group,
			isLock = var0_2 < var1_2.group_mask
		}
	end

	updateCrusingHei5ActivityTask(arg0_2.activity)

	arg0_2.finishAll = arg0_2.phase == #arg0_2.awardList
end

function var0_0.OnLoaded(arg0_3)
	arg0_3:UpdateActivity()

	local var0_3 = arg0_3._tf:Find("frame")

	arg0_3.togglesTF = var0_3:Find("week_list")
	arg0_3.toggleCount = arg0_3.togglesTF:Find("count")

	local var1_3 = var0_3:Find("view/content")
	local var2_3 = var1_3:Find("tpl")

	setText(var2_3:Find("info/go/Text"), i18n("task_go"))
	setText(var2_3:Find("info/get/Text"), i18n("task_get"))
	setText(var2_3:Find("info/got/Image/Text"), i18n("task_got"))

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
		local var1_6

		if iter0_6 == 0 then
			var1_6 = arg0_6._tf:Find("frame/" .. iter0_6)
		else
			var1_6 = arg0_6.toggleCount:Find(iter0_6)
		end

		if iter0_6 > 0 then
			setText(var1_6:Find("off/Text"), i18n("blackfriday_cruise_task_day", iter0_6))
			setText(var1_6:Find("on/Text"), i18n("blackfriday_cruise_task_day", iter0_6))
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

	if arg0_6.weekToggle == 0 then
		triggerToggle(arg0_6._tf:Find("frame/0"), true)
	else
		triggerToggle(arg0_6.toggleCount:Find(arg0_6.weekToggle), true)
	end

	for iter4_6, iter5_6 in ipairs(arg0_6.taskGroupList) do
		local var4_6 = arg0_6.toggleCount:Find(iter4_6)

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
	local var1_16 = {}

	for iter0_16, iter1_16 in ipairs(arg2_16) do
		if not iter1_16:isReceive() then
			table.insert(var1_16, iter1_16)
		end
	end

	local var2_16 = #var1_16 > 0 and table.remove(var1_16, 1) or arg2_16[#arg2_16]

	arg0_16:UpdateTaskDisplay(var0_16, var2_16)
end

function var0_0.UpdateTaskDisplay(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg2_17:getProgress()
	local var1_17 = arg2_17:getConfig("target_num")

	setText(arg1_17:Find("desc"), string.format("%s(%d/%d)", arg2_17:getConfig("desc"), var0_17, var1_17))

	local var2_17 = Drop.Create(arg2_17:getConfig("award_display")[1])
	local var3_17 = arg0_17.finishAll and 2 or arg2_17:getTaskStatus()

	setActive(arg1_17:Find("go"), var3_17 == 0)
	setActive(arg1_17:Find("get"), var3_17 == 1)
	setActive(arg1_17:Find("got"), var3_17 == 2)
	setText(arg1_17:Find("go/Text"), i18n("island_word_go"))
	setText(arg1_17:Find("get/Text"), i18n("handbook_research_final_task_btn_claim"))
	setText(arg1_17:Find("got/Image/Text"), i18n("handbook_research_final_task_btn_finished"))

	local var4_17 = Drop.Create(arg2_17:getConfig("award_display")[1])

	setText(arg1_17:Find("icon/num"), "X" .. arg2_17:getConfig("award_display")[1][3])
	setImageSprite(arg1_17:Find("icon"), LoadSprite("ui/PSSHei5UI_atlas", "battlepass_blackfriday"), false)
	onButton(arg0_17, arg1_17:Find("icon"), function()
		arg0_17:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var4_17
		})
	end, SFX_PANEL)
	onButton(arg0_17, arg1_17:Find("go"), function()
		arg0_17:emit(PSSHei5Mediator.ON_TASK_GO, arg2_17)
	end, SFX_PANEL)
	onButton(arg0_17, arg1_17:Find("get"), function()
		arg0_17:emit(PSSHei5Mediator.ON_TASK_SUBMIT, arg2_17)
	end, SFX_CONFIRM)
end

function var0_0.OnDestroy(arg0_21)
	return
end

return var0_0
