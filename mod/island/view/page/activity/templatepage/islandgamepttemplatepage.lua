local var0_0 = class("IslandGamePtTemplatePage", import("Mod.Island.View.page.activity.IslandBaseActivityPage"))

function var0_0.OnDataSetting(arg0_1)
	arg0_1.config = pg.island_activity_pt_page[arg0_1.activity:getIslandConfig("config_id")]
	arg0_1.targetActivity = getProxy(ActivityProxy):getActivityById(arg0_1.config.activity_id)

	arg0_1:BuildAllTask()
end

function var0_0.BuildAllTask(arg0_2)
	arg0_2.taskList = {}

	_.each(arg0_2.config.task_id, function(arg0_3)
		local var0_3 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg0_3) or IslandTask.BuildFakeTask(arg0_3)

		table.insert(arg0_2.taskList, var0_3)
	end)
end

function var0_0.GetFirstUncompletedTaskIndex(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.taskList) do
		if not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(iter1_4.id) then
			return iter0_4
		end
	end

	return 1
end

function var0_0.GetAllAvailableTaskIds(arg0_5)
	local var0_5 = {}

	_.each(arg0_5.taskList, function(arg0_6)
		if arg0_6:IsFinish() and not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(arg0_6.id) then
			table.insert(var0_5, arg0_6.id)
		end
	end)

	return var0_5
end

function var0_0.OnFirstFlush(arg0_7)
	PlayerPrefs.SetInt(var0_0.GetTipKey(arg0_7.activity.id), 1)
	setText(arg0_7.importGot:Find("Text"), i18n("island_activity_pt_got_all"))
	setText(arg0_7.scoreTipText, i18n("island_activity_pt_point"))
	setText(arg0_7.getText, i18n("island_activity_pt_get_oneclick"))
	onButton(arg0_7, arg0_7.getButton, function()
		local var0_8 = arg0_7:GetAllAvailableTaskIds()

		if #var0_8 == 0 then
			return
		end

		arg0_7:emit(IslandMediator.ON_SUBMIT_TASK_ONE_STEP, var0_8, function()
			arg0_7:OnUpdateFlush()
		end)
	end, SFX_PANEL)
	_.each(arg0_7.config.btn_param, function(arg0_10)
		local var0_10 = arg0_7[arg0_10[1]]

		if not var0_10 then
			errorMsg("不存在节点或ItemList未绑定节点" .. arg0_10[1])

			return
		end

		setText(var0_10:Find("Text"), i18n(arg0_10[2]))
		onButton(arg0_7, var0_10, function()
			arg0_7:emit(IslandMediator.OPEN_PAGE, arg0_10[3][1], arg0_10[3][2])
		end, SFX_PANEL)
		arg0_7:CheckBtnSkip(var0_10, arg0_10[4] or {})
	end)

	arg0_7.scrollCom = arg0_7.taskRoot:GetComponent("LScrollRect")

	function arg0_7.scrollCom.onUpdateItem(arg0_12, arg1_12)
		arg0_7:UpdateTaskList(arg0_12, tf(arg1_12))
	end

	arg0_7.scrollCom:SetTotalCount(#arg0_7.config.task_id)
end

function var0_0.CheckBtnSkip(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg2_13[1]
	local var1_13 = arg2_13[2]

	if not var0_13 then
		return true
	end

	return switch(var0_13, {
		function()
			local var0_14 = var1_13[1]
			local var1_14 = getProxy(ActivityProxy):getActivityById(var0_14)

			setActive(arg1_13, var1_14 and not var1_14:isEnd())
		end
	}, function()
		assert(false, "未定义的按钮拦截type: ", var0_13)
	end)
end

function var0_0.GetShowPTCount(arg0_16, arg1_16)
	return switch(arg1_16, {
		function()
			return arg0_16.targetActivity.data1
		end,
		function()
			return arg0_16.targetActivity.data2
		end
	})
end

function var0_0.OnUpdateFlush(arg0_19)
	arg0_19.targetActivity = getProxy(ActivityProxy):getActivityById(arg0_19.config.activity_id)

	setText(arg0_19.scoreText, arg0_19:GetShowPTCount(arg0_19.config.point_type))

	local var0_19 = arg0_19:GetFirstUncompletedTaskIndex()

	onNextTick(function()
		arg0_19.scrollCom:ScrollTo(arg0_19.scrollCom:HeadIndexToValue(var0_19 - 1))
	end)

	local var1_19 = #arg0_19:GetAllAvailableTaskIds() > 0

	setActive(arg0_19.getButton:Find("red"), var1_19)
	setGray(arg0_19.getButton, not var1_19, true)
	arg0_19:UpdateImport()
end

function var0_0.UpdateTaskList(arg0_21, arg1_21, arg2_21)
	arg1_21 = arg1_21 + 1

	local var0_21 = arg0_21.config.task_id[arg1_21]
	local var1_21 = arg0_21.taskList[arg1_21]
	local var2_21 = getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var0_21)
	local var3_21 = var1_21:GetTargetList()[1]
	local var4_21 = var1_21:IsFinish() and not var2_21

	setText(arg2_21:Find("bg/name"), var1_21:GetName())
	setText(arg2_21:Find("bg/count"), var3_21:GetProgress() .. "/" .. var3_21:GetTargetNum())
	setText(arg2_21:Find("bg/desc"), var3_21:GetName())

	local var5_21 = var1_21:GetAwards()
	local var6_21 = arg2_21:Find("bg/items")

	UIItemList.StaticAlign(var6_21, var6_21:Find("IslandItemTpl"), #var5_21, function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var5_21[arg1_22 + 1]

			updateCustomDrop(arg2_22, var0_22)
			onButton(arg0_21, arg2_22, function()
				arg0_21:emit(IslandMediator.SHOW_MSG_BOX, {
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var0_22
				})
			end, SFX_PANEL)
		end
	end)
	setActive(arg2_21:Find("got"), var2_21)
	setActive(arg2_21:Find("get"), var4_21)
	setActive(arg2_21:Find("red"), var4_21)
	onButton(arg0_21, arg2_21:Find("get"), function()
		arg0_21:emit(IslandMediator.ON_SUBMIT_TASK, var0_21, function()
			arg0_21:OnUpdateFlush()
		end)
	end, SFX_PANEL)
end

function var0_0.GetAtlasName(arg0_26)
	assert(false, "override")
end

function var0_0.GetShowImportInfo(arg0_27)
	local var0_27 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
	local var1_27 = arg0_27.config.import

	for iter0_27, iter1_27 in ipairs(var1_27) do
		if not var0_27:IsFinishTask(iter1_27[1]) then
			return iter0_27, false
		end
	end

	return #var1_27, true
end

function var0_0.UpdateImport(arg0_28)
	local var0_28, var1_28 = arg0_28:GetShowImportInfo()

	setActive(arg0_28.importGot, var1_28)
	setImageAlpha(arg0_28.importIcon, var1_28 and 0.6 or 1)

	local var2_28 = arg0_28.config.import[var0_28]

	GetImageSpriteFromAtlasAsync(arg0_28:GetAtlasName(), var0_28, arg0_28.importIcon, true)
	setText(arg0_28.goTipText, i18n(var2_28[2]))

	local var3_28 = IslandTask.GetAwardsStatic(var2_28[1])

	onButton(arg0_28, arg0_28.viewButton, function()
		if not var3_28[1] then
			return
		end

		arg0_28:emit(IslandMediator.SHOW_MSG_BOX, {
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var3_28[1]
		})
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_30)
	ClearLScrollrect(arg0_30.scrollCom)
	bindComponent(arg0_30, arg0_30._tf, true)
end

function var0_0.GetTipKey(arg0_31)
	return "island_game_pt_template_page_tip_" .. arg0_31 .. "_" .. getProxy(PlayerProxy):getData().id
end

function var0_0.ShouldFirstTip(arg0_32)
	local var0_32 = var0_0.GetTipKey(arg0_32)

	return PlayerPrefs.GetInt(var0_32, 0) == 0
end

return var0_0
