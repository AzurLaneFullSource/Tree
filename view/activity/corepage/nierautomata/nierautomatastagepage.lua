local var0_0 = class("NieRAutomataStagePage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("panel")
	arg0_1.chainTFList = {}
	arg0_1.stageTFList = {}

	local var0_1 = arg0_1.bg:Find("stages")
	local var1_1 = arg0_1.bg:Find("progress_chain")

	for iter0_1 = 1, 2 do
		table.insert(arg0_1.stageTFList, var0_1:Find("stage_" .. iter0_1))
		table.insert(arg0_1.chainTFList, var1_1:Find("chain_mark_" .. iter0_1))
	end

	table.insert(arg0_1.stageTFList, var0_1:Find("stage_3"))
end

function var0_0.flushTaskData(arg0_2)
	arg0_2._taskList = {}

	local var0_2 = arg0_2.activity:getConfig("config_client").task

	for iter0_2, iter1_2 in ipairs(var0_2) do
		local var1_2 = getProxy(TaskProxy):getTaskById(iter1_2) or getProxy(TaskProxy):getFinishTaskById(iter1_2)

		table.insert(arg0_2._taskList, var1_2)
	end
end

function var0_0.GetClearEnemyList(arg0_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.activity.data2_list) do
		table.insert(var0_3, arg0_3.activity:GetEnemyDataByStageId(iter1_3).id)
	end

	return var0_3
end

function var0_0.IsStageUnlock(arg0_4, arg1_4, arg2_4)
	return arg1_4:GetPreChapterId() == 0 or table.contains(arg2_4, arg1_4:GetPreChapterId())
end

function var0_0.UpdateAwardState(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg2_5:Find("award")
	local var1_5 = arg0_5._taskList[arg1_5]

	if not var1_5 then
		return
	end

	local var2_5 = var1_5:getConfig("award_display")[1]
	local var3_5 = {
		type = var2_5[1],
		id = var2_5[2],
		count = var2_5[3]
	}
	local var4_5 = var0_5:Find("bg")
	local var5_5 = var0_5:Find("got")
	local var6_5 = var1_5:getTaskStatus()

	updateDrop(findTF(var0_5, "mask"), var3_5)
	setActive(var4_5, arg3_5)

	if var5_5 then
		setActive(var5_5, arg3_5 and var6_5 == 2)
	end

	onButton(arg0_5, var0_5, function()
		arg0_5:emit(BaseUI.ON_DROP, var3_5)
	end)
end

function var0_0.RefreshAwardStates(arg0_7)
	local var0_7 = arg0_7.activity:getConfig("config_data")
	local var1_7 = arg0_7:GetClearEnemyList()

	for iter0_7, iter1_7 in ipairs(arg0_7.stageTFList) do
		local var2_7 = arg0_7.activity:GetEnemyDataById(var0_7[iter0_7])

		arg0_7:UpdateAwardState(iter0_7, iter1_7, arg0_7:IsStageUnlock(var2_7, var1_7))
	end
end

function var0_0.OnFirstFlush(arg0_8)
	local var0_8 = arg0_8.activity:getConfig("config_data")
	local var1_8 = arg0_8:GetClearEnemyList()

	arg0_8:flushTaskData()

	local var2_8 = 1

	for iter0_8, iter1_8 in ipairs(arg0_8.stageTFList) do
		local var3_8 = arg0_8.activity:GetEnemyDataById(var0_8[iter0_8])

		setText(iter1_8:Find("name/text"), var3_8:getConfig("name"))

		local var4_8 = arg0_8:IsStageUnlock(var3_8, var1_8)

		arg0_8:UpdateAwardState(iter0_8, iter1_8, var4_8)

		if var4_8 then
			setActive(iter1_8:Find("lock"), false)
			onButton(arg0_8, iter1_8, function()
				arg0_8.fleetEditPanel = arg0_8:GetFleetEditPanel()

				local var0_9 = getProxy(FleetProxy):GetRegularFleets()

				arg0_8.fleetEditPanel.buffer:SetFleets(var0_9)
				arg0_8.fleetEditPanel.buffer:SetSettings(1, 0, var3_8:GetExpeditionId(), SYSTEM_REWARD_PERFORM, arg0_8.activity.configId)
				arg0_8.fleetEditPanel.buffer:UpdateView()
				arg0_8.fleetEditPanel.buffer:Show()
			end)

			if arg0_8.chainTFList[iter0_8] then
				arg0_8:setChianMark(iter0_8, true)
			end

			local var5_8 = iter0_8
		else
			if arg0_8.chainTFList[iter0_8] then
				arg0_8:setChianMark(iter0_8, false)
			end

			setActive(iter1_8:Find("lock"), true)
		end
	end
end

function var0_0.GetFleetEditPanel(arg0_10)
	if not arg0_10.fleetEditPanel then
		arg0_10.fleetEditPanel = BossSingleBattleFleetSelectSubPanelLite.New(arg0_10)

		arg0_10.fleetEditPanel:Load()
	end

	return arg0_10.fleetEditPanel
end

function var0_0.setChianMark(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.chainTFList[arg1_11]

	setActive(var0_11:Find("finish"), arg2_11)
	setActive(var0_11:Find("unfinish"), not arg2_11)
end

function var0_0.OnUpdateFlush(arg0_12)
	arg0_12:flushTaskData()
	arg0_12:RefreshAwardStates()

	for iter0_12, iter1_12 in ipairs(arg0_12._taskList) do
		if iter1_12:getTaskStatus() == 1 then
			arg0_12:emit(ActivityMediator.ON_TASK_SUBMIT, iter1_12, function()
				arg0_12:flushTaskData()
				arg0_12:RefreshAwardStates()
			end)
		end
	end
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14.fleetEditPanel then
		arg0_14.fleetEditPanel:OnHide()
	end
end

return var0_0
