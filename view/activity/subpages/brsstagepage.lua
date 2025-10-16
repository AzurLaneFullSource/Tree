local var0_0 = class("BRSStagePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("panel")

	setText(arg0_1.bg:Find("hint"), i18n("brs_expedition_tip"))

	arg0_1.chainTFList = {}
	arg0_1.stageTFList = {}

	local var0_1 = arg0_1.bg:Find("stages")
	local var1_1 = arg0_1.bg:Find("progress_chain")

	for iter0_1 = 1, 3 do
		table.insert(arg0_1.stageTFList, var0_1:Find("stage_" .. iter0_1))
		table.insert(arg0_1.chainTFList, var1_1:Find("chain_mark_" .. iter0_1))
	end
end

function var0_0.OnDataSetting(arg0_2)
	return
end

function var0_0.flushTaskData(arg0_3)
	arg0_3._taskList = {}

	local var0_3 = arg0_3.activity:getConfig("config_client").task

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var1_3 = getProxy(TaskProxy):getTaskById(iter1_3) or getProxy(TaskProxy):getFinishTaskById(iter1_3)

		table.insert(arg0_3._taskList, var1_3)
	end
end

function var0_0.OnFirstFlush(arg0_4)
	local var0_4 = arg0_4.activity:getConfig("config_data")
	local var1_4 = {}

	for iter0_4, iter1_4 in ipairs(arg0_4.activity.data2_list) do
		table.insert(var1_4, arg0_4.activity:GetEnemyDataByStageId(iter1_4).id)
	end

	arg0_4:flushTaskData()

	local var2_4 = 1

	for iter2_4, iter3_4 in ipairs(arg0_4.stageTFList) do
		local var3_4 = arg0_4.activity:GetEnemyDataById(var0_4[iter2_4])

		setText(iter3_4:Find("name/text"), var3_4:getConfig("name"))
		setText(iter3_4:Find("level"), var3_4:getConfig("level"))

		local var4_4 = iter3_4:Find("award")
		local var5_4 = arg0_4._taskList[iter2_4]
		local var6_4 = var5_4:getConfig("award_display")[1]
		local var7_4 = {
			type = var6_4[1],
			id = var6_4[2],
			count = var6_4[3]
		}

		updateDrop(findTF(var4_4, "mask"), var7_4)

		local var8_4 = var5_4:getTaskStatus()

		setActive(var4_4:Find("claimed"), var5_4:getTaskStatus() == 2)
		onButton(arg0_4, var4_4, function()
			arg0_4:emit(BaseUI.ON_DROP, var7_4)
		end)

		if var3_4:GetPreChapterId() == 0 or table.contains(var1_4, var3_4:GetPreChapterId()) then
			setActive(iter3_4:Find("lock"), false)
			onButton(arg0_4, iter3_4, function()
				arg0_4.fleetEditPanel = arg0_4:GetFleetEditPanel()

				local var0_6 = getProxy(FleetProxy):GetRegularFleets()

				arg0_4.fleetEditPanel.buffer:SetFleets(var0_6)
				arg0_4.fleetEditPanel.buffer:SetSettings(1, 0, var3_4:GetExpeditionId(), SYSTEM_REWARD_PERFORM, arg0_4.activity.configId)
				arg0_4.fleetEditPanel.buffer:UpdateView()
				arg0_4.fleetEditPanel.buffer:Show()
			end)
			setActive(arg0_4.chainTFList[iter2_4]:Find("finish"), true)
			setActive(arg0_4.chainTFList[iter2_4]:Find("unfinish"), false)

			iter3_4:Find("name/text"):GetComponent(typeof(Text)).color = Color.white
			var2_4 = iter2_4
		else
			setActive(arg0_4.chainTFList[iter2_4]:Find("finish"), false)
			setActive(arg0_4.chainTFList[iter2_4]:Find("unfinish"), true)
			setActive(iter3_4:Find("lock"), true)
		end
	end

	triggerToggle(arg0_4.stageTFList[var2_4]:Find("bg"), true)

	local var9_4 = pg.NewStoryMgr.GetInstance()

	if #arg0_4.activity.data2_list == 0 then
		var9_4:Play(arg0_4.activity:getConfig("config_client").story[1][1])
	end
end

function var0_0.GetFleetEditPanel(arg0_7)
	if not arg0_7.fleetEditPanel then
		arg0_7.fleetEditPanel = BossSingleBattleFleetSelectSubPanelLite.New(arg0_7)

		arg0_7.fleetEditPanel:Load()
	end

	return arg0_7.fleetEditPanel
end

function var0_0.OnUpdateFlush(arg0_8)
	arg0_8:flushTaskData()

	for iter0_8, iter1_8 in ipairs(arg0_8._taskList) do
		local var0_8 = iter1_8:getTaskStatus()

		setActive(arg0_8.stageTFList[iter0_8]:Find("award/claimed"), var0_8 == 2)

		if iter0_8 == 3 then
			if var0_8 == 1 then
				local var1_8 = pg.NewStoryMgr.GetInstance()
				local var2_8 = arg0_8.activity:getConfig("config_client").story[2][1]
				local var3_8 = arg0_8.activity:getConfig("config_client").story[3][1]
				local var4_8 = var1_8:StoryName2StoryId(var2_8)
				local var5_8 = var1_8:StoryName2StoryId(var3_8)

				if not var1_8:IsPlayed(var2_8) then
					arg0_8:emit(ActivityMediator.GO_PERFORM_COMBAT, {
						stageId = var4_8
					})
				elseif not var1_8:IsPlayed(var3_8) then
					arg0_8:emit(ActivityMediator.GO_PERFORM_COMBAT, {
						stageId = var5_8
					})
				else
					arg0_8:emit(ActivityMediator.ON_TASK_SUBMIT, iter1_8)
				end
			end
		elseif var0_8 == 1 then
			arg0_8:emit(ActivityMediator.ON_TASK_SUBMIT, iter1_8)
		end
	end
end

function var0_0.OnDestroy(arg0_9)
	if arg0_9.fleetEditPanel then
		arg0_9.fleetEditPanel:OnHide()
	end
end

return var0_0
