local var0_0 = class("IslandGamePtTemplatePage", import("Mod.Island.View.page.activity.IslandBaseActivityPage"))

function var0_0.OnLoaded(arg0_1)
	local var0_1 = arg0_1._tf:GetComponent("ItemList").prefabItem:ToTable()

	_.each(var0_1, function(arg0_2)
		arg0_1[arg0_2.name] = arg0_2.transform
	end)
end

function var0_0.OnDataSetting(arg0_3)
	arg0_3.config = pg.island_activity_pt_page[arg0_3.activity:getIslandConfig("config_id")]
	arg0_3.targetActivity = getProxy(ActivityProxy):getActivityById(arg0_3.config.activity_id)

	arg0_3:BuildAllTask()
end

function var0_0.BuildAllTask(arg0_4)
	arg0_4.taskList = {}

	_.each(arg0_4.config.task_id, function(arg0_5)
		local var0_5 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg0_5) or IslandTask.BuildFakeTask(arg0_5)

		table.insert(arg0_4.taskList, var0_5)
	end)
end

function var0_0.GetFirstUncompletedTaskIndex(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.taskList) do
		if not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(iter1_6.id) then
			return iter0_6
		end
	end

	return 1
end

function var0_0.GetAllAvailableTaskIds(arg0_7)
	local var0_7 = {}

	_.each(arg0_7.taskList, function(arg0_8)
		if arg0_8:IsFinish() and not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(arg0_8.id) then
			table.insert(var0_7, arg0_8.id)
		end
	end)

	return var0_7
end

function var0_0.OnFirstFlush(arg0_9)
	PlayerPrefs.SetInt(var0_0.GetTipKey(arg0_9.activity.id), 1)
	setText(arg0_9.importGot:Find("Text"), i18n("island_activity_pt_got_all"))
	setText(arg0_9.scoreTipText, i18n("island_activity_pt_point"))
	setText(arg0_9.getText, i18n("island_activity_pt_get_oneclick"))
	onButton(arg0_9, arg0_9.getButton, function()
		local var0_10 = arg0_9:GetAllAvailableTaskIds()

		if #var0_10 == 0 then
			return
		end

		arg0_9:emit(IslandMediator.ON_SUBMIT_TASK_ONE_STEP, var0_10, function()
			arg0_9:OnUpdateFlush()
		end)
	end, SFX_PANEL)
	_.each(arg0_9.config.btn_param, function(arg0_12)
		local var0_12 = arg0_9[arg0_12[1]]

		if not var0_12 then
			errorMsg("不存在节点或ItemList未绑定节点" .. arg0_12[1])

			return
		end

		setText(var0_12:Find("Text"), i18n(arg0_12[2]))
		onButton(arg0_9, var0_12, function()
			arg0_9:emit(IslandMediator.OPEN_PAGE, arg0_12[3][1], arg0_12[3][2])
		end, SFX_PANEL)
		arg0_9:CheckBtnSkip(var0_12, arg0_12[4] or {})
	end)

	arg0_9.scrollCom = arg0_9.taskRoot:GetComponent("LScrollRect")

	function arg0_9.scrollCom.onUpdateItem(arg0_14, arg1_14)
		arg0_9:UpdateTaskList(arg0_14, tf(arg1_14))
	end

	arg0_9.scrollCom:SetTotalCount(#arg0_9.config.task_id)
end

function var0_0.CheckBtnSkip(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg2_15[1]
	local var1_15 = arg2_15[2]

	if not var0_15 then
		return true
	end

	return switch(var0_15, {
		function()
			local var0_16 = var1_15[1]
			local var1_16 = getProxy(ActivityProxy):getActivityById(var0_16)

			setActive(arg1_15, var1_16 and not var1_16:isEnd())
		end
	}, function()
		assert(false, "未定义的按钮拦截type: ", var0_15)
	end)
end

function var0_0.GetShowPTCount(arg0_18, arg1_18)
	return switch(arg1_18, {
		function()
			return arg0_18.targetActivity.data1
		end,
		function()
			return arg0_18.targetActivity.data2
		end
	})
end

function var0_0.OnUpdateFlush(arg0_21)
	arg0_21.targetActivity = getProxy(ActivityProxy):getActivityById(arg0_21.config.activity_id)

	setText(arg0_21.scoreText, arg0_21:GetShowPTCount(arg0_21.config.point_type))

	local var0_21 = arg0_21:GetFirstUncompletedTaskIndex()

	onNextTick(function()
		arg0_21.scrollCom:ScrollTo(arg0_21.scrollCom:HeadIndexToValue(var0_21 - 1))
	end)

	local var1_21 = #arg0_21:GetAllAvailableTaskIds() > 0

	setActive(arg0_21.getButton:Find("red"), var1_21)
	setGray(arg0_21.getButton, not var1_21, true)
	arg0_21:UpdateImport()
end

function var0_0.UpdateTaskList(arg0_23, arg1_23, arg2_23)
	arg1_23 = arg1_23 + 1

	local var0_23 = arg0_23.config.task_id[arg1_23]
	local var1_23 = arg0_23.taskList[arg1_23]
	local var2_23 = getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var0_23)
	local var3_23 = var1_23:GetTargetList()[1]
	local var4_23 = var1_23:IsFinish() and not var2_23

	setText(arg2_23:Find("bg/name"), var1_23:GetName())
	setText(arg2_23:Find("bg/count"), var3_23:GetProgress() .. "/" .. var3_23:GetTargetNum())
	setText(arg2_23:Find("bg/desc"), var3_23:GetName())

	local var5_23 = var1_23:GetAwards()
	local var6_23 = arg2_23:Find("bg/items")

	UIItemList.StaticAlign(var6_23, var6_23:Find("IslandItemTpl"), #var5_23, function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			local var0_24 = var5_23[arg1_24 + 1]

			updateCustomDrop(arg2_24, var0_24)
			onButton(arg0_23, arg2_24, function()
				arg0_23:emit(IslandMediator.SHOW_MSG_BOX, {
					title = i18n("island_word_desc"),
					type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
					dropData = var0_24
				})
			end, SFX_PANEL)
		end
	end)
	setActive(arg2_23:Find("got"), var2_23)
	setActive(arg2_23:Find("get"), var4_23)
	setActive(arg2_23:Find("red"), var4_23)
	onButton(arg0_23, arg2_23:Find("get"), function()
		arg0_23:emit(IslandMediator.ON_SUBMIT_TASK, var0_23, function()
			arg0_23:OnUpdateFlush()
		end)
	end, SFX_PANEL)
end

function var0_0.GetAtlasName(arg0_28)
	assert(false, "override")
end

function var0_0.GetShowImportInfo(arg0_29)
	local var0_29 = getProxy(IslandProxy):GetIsland():GetTaskAgency()
	local var1_29 = arg0_29.config.import

	for iter0_29, iter1_29 in ipairs(var1_29) do
		if not var0_29:IsFinishTask(iter1_29[1]) then
			return iter0_29, false
		end
	end

	return #var1_29, true
end

function var0_0.UpdateImport(arg0_30)
	local var0_30, var1_30 = arg0_30:GetShowImportInfo()

	setActive(arg0_30.importGot, var1_30)
	setImageAlpha(arg0_30.importIcon, var1_30 and 0.6 or 1)

	local var2_30 = arg0_30.config.import[var0_30]

	GetImageSpriteFromAtlasAsync(arg0_30:GetAtlasName(), var0_30, arg0_30.importIcon, true)
	setText(arg0_30.goTipText, i18n(var2_30[2]))

	local var3_30 = IslandTask.GetAwardsStatic(var2_30[1])

	onButton(arg0_30, arg0_30.viewButton, function()
		if not var3_30[1] then
			return
		end

		arg0_30:emit(IslandMediator.SHOW_MSG_BOX, {
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var3_30[1]
		})
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_32)
	ClearLScrollrect(arg0_32.scrollCom)
end

function var0_0.GetTipKey(arg0_33)
	return "island_game_pt_template_page_tip_" .. arg0_33 .. "_" .. getProxy(PlayerProxy):getData().id
end

function var0_0.ShouldFirstTip(arg0_34)
	local var0_34 = var0_0.GetTipKey(arg0_34)

	return PlayerPrefs.GetInt(var0_34, 0) == 0
end

return var0_0
