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

function var0_0.initTplVar(arg0_3)
	arg0_3.btnGoText = "task_go"
	arg0_3.btnGetText = "task_get"
	arg0_3.taskDayText = "blackfriday_cruise_task_day"
	arg0_3.pticonAtlas = "ui/PSSHei5UI_atlas"
	arg0_3.pticonName = "battlepass_blackfriday"
end

function var0_0.OnLoaded(arg0_4)
	arg0_4:initTplVar()
	arg0_4:UpdateActivity()

	local var0_4 = arg0_4._tf:Find("frame")

	arg0_4.togglesTF = var0_4:Find("week_list")
	arg0_4.toggleCount = arg0_4.togglesTF:Find("count")

	local var1_4 = var0_4:Find("view/content")
	local var2_4 = var1_4:Find("tpl")

	setText(var2_4:Find("info/go/Text"), i18n(arg0_4.btnGoText))
	setText(var2_4:Find("info/get/Text"), i18n(arg0_4.btnGetText))
	setText(var2_4:Find("info/got/Text"), i18n("task_got"))

	arg0_4.taskGroupItemList = UIItemList.New(var1_4, var2_4)
end

function var0_0.OnInit(arg0_5)
	arg0_5.taskGroupItemList:make(function(arg0_6, arg1_6, arg2_6)
		arg1_6 = arg1_6 + 1

		if arg0_6 == UIItemList.EventUpdate then
			arg0_5:UpdateTaskGroup(arg2_6, arg0_5.tempTaskGroup[arg1_6])
		end
	end)
end

function var0_0.Flush(arg0_7, arg1_7)
	if arg1_7 then
		arg0_7:UpdateActivity(arg1_7)
	end

	local var0_7 = getProxy(TaskProxy)

	for iter0_7, iter1_7 in pairs(arg0_7.taskGroupList) do
		local var1_7

		if iter0_7 == 0 then
			var1_7 = arg0_7._tf:Find("frame/" .. iter0_7)
		else
			var1_7 = arg0_7.toggleCount:Find(iter0_7)
		end

		if iter0_7 > 0 then
			setText(var1_7:Find("off/Text"), i18n(arg0_7.taskDayText, iter0_7))
			setText(var1_7:Find("on/Text"), i18n(arg0_7.taskDayText, iter0_7))
		end

		setActive(var1_7:Find("tip"), not iter1_7.isLock and PlayerPrefs.GetInt(string.format("cursing_%d_task_week_%d", arg0_7.activity.id, iter0_7), 0) == 0)
		onToggle(arg0_7, var1_7, function(arg0_8)
			if arg0_8 then
				setActive(var1_7:Find("tip"), false)
				PlayerPrefs.SetInt(string.format("cursing_%d_task_week_%d", arg0_7.activity.id, iter0_7), 1)

				arg0_7.weekToggle = iter0_7
				arg0_7.contextData.weekToggle = iter0_7
				arg0_7.tempTaskGroup = underscore.map(iter1_7.task_group, function(arg0_9)
					return underscore.map(arg0_9, function(arg0_10)
						assert(var0_7:getTaskVO(arg0_10), "without this task:" .. arg0_10)

						return var0_7:getTaskVO(arg0_10)
					end)
				end)

				table.sort(arg0_7.tempTaskGroup, CompareFuncs({
					function(arg0_11)
						return underscore.all(arg0_11, function(arg0_12)
							return arg0_12:isReceive()
						end) and 1 or 0
					end,
					function(arg0_13)
						return arg0_13[1].id
					end
				}))
				arg0_7.taskGroupItemList:align(#arg0_7.tempTaskGroup)
			end
		end, SFX_PANEL)

		if var1_7:Find("mask") then
			setActive(var1_7:Find("mask"), iter1_7.isLock)
		end
	end

	local var2_7 = underscore.keys(arg0_7.taskGroupList)

	table.sort(var2_7, function(arg0_14, arg1_14)
		return arg0_14 < arg1_14
	end)

	if arg0_7.contextData.weekToggle and not arg0_7.taskGroupList[arg0_7.contextData.weekToggle].isLock then
		arg0_7.weekToggle = arg0_7.contextData.weekToggle
		arg0_7.contextData.weekToggle = nil
	else
		arg0_7.weekToggle = table.remove(var2_7, 1)

		for iter2_7, iter3_7 in ipairs(var2_7) do
			local var3_7 = arg0_7.taskGroupList[iter3_7]

			if var3_7.isLock then
				break
			elseif underscore.any(underscore.flatten(var3_7.task_group), function(arg0_15)
				local var0_15 = var0_7:getTaskVO(arg0_15)

				return var0_15 and not var0_15:isReceive()
			end) then
				arg0_7.weekToggle = iter3_7

				break
			end
		end
	end

	if arg0_7.weekToggle == 0 then
		triggerToggle(arg0_7._tf:Find("frame/0"), true)
	else
		triggerToggle(arg0_7.toggleCount:Find(arg0_7.weekToggle), true)
	end

	for iter4_7, iter5_7 in ipairs(arg0_7.taskGroupList) do
		local var4_7 = arg0_7.toggleCount:Find(iter4_7)

		SetCompomentEnabled(var4_7, typeof(Toggle), not iter5_7.isLock)

		if not iter5_7.isLock then
			setGray(var4_7, underscore.all(underscore.flatten(iter5_7.task_group), function(arg0_16)
				local var0_16 = var0_7:getTaskVO(arg0_16)

				return var0_16 and var0_16:isReceive()
			end))
		end
	end

	arg0_7:Show()
end

function var0_0.UpdateTaskGroup(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17:Find("info")
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(arg2_17) do
		if not iter1_17:isReceive() then
			table.insert(var1_17, iter1_17)
		end
	end

	local var2_17 = #var1_17 > 0 and table.remove(var1_17, 1) or arg2_17[#arg2_17]

	arg0_17:UpdateTaskDisplay(var0_17, var2_17)
end

function var0_0.UpdateTaskDisplay(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg2_18:getProgress()
	local var1_18 = arg2_18:getConfig("target_num")

	setText(arg1_18:Find("desc"), string.format("%s(%d/%d)", arg2_18:getConfig("desc"), var0_18, var1_18))

	local var2_18 = Drop.Create(arg2_18:getConfig("award_display")[1])
	local var3_18 = arg0_18.finishAll and 2 or arg2_18:getTaskStatus()

	setActive(arg1_18:Find("go"), var3_18 == 0)
	setActive(arg1_18:Find("get"), var3_18 == 1)
	setActive(arg1_18:Find("got"), var3_18 == 2)
	setText(arg1_18:Find("go/Text"), i18n("island_word_go"))
	setText(arg1_18:Find("get/Text"), i18n("handbook_research_final_task_btn_claim"))
	setText(arg1_18:Find("got/Text"), i18n("handbook_research_final_task_btn_finished"))

	local var4_18 = Drop.Create(arg2_18:getConfig("award_display")[1])

	setText(arg1_18:Find("icon/num"), "X" .. arg2_18:getConfig("award_display")[1][3])

	if arg0_18.pticonAtlas and arg0_18.pticonName then
		setImageSprite(arg1_18:Find("icon"), LoadSprite("ui/PSSHei5UI_atlas", "battlepass_blackfriday"), false)
	end

	onButton(arg0_18, arg1_18:Find("icon"), function()
		arg0_18:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var4_18
		})
	end, SFX_PANEL)
	onButton(arg0_18, arg1_18:Find("go"), function()
		arg0_18:emit(PSSHei5Mediator.ON_TASK_GO, arg2_18)
	end, SFX_PANEL)
	onButton(arg0_18, arg1_18:Find("get"), function()
		arg0_18:emit(PSSHei5Mediator.ON_TASK_SUBMIT, arg2_18)
	end, SFX_CONFIRM)
end

function var0_0.OnDestroy(arg0_22)
	return
end

return var0_0
