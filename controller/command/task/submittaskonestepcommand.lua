local var0_0 = class("SubmitTaskOneStepCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.dontSendMsg
	local var3_1 = var0_1.resultList
	local var4_1 = {}
	local var5_1 = {}
	local var6_1 = getProxy(TaskProxy)

	for iter0_1, iter1_1 in ipairs(var3_1) do
		local var7_1 = iter1_1.id
		local var8_1 = {}

		if iter1_1.choiceItemList then
			for iter2_1, iter3_1 in ipairs(iter1_1.choiceItemList) do
				table.insert(var8_1, iter3_1)
			end
		end

		local var9_1 = var6_1:getTaskById(var7_1)

		if not var9_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("task_is_not_existence", var7_1))

			return
		end

		if not var9_1:isFinish() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_notFinish"))

			return
		end

		table.insert(var4_1, var7_1)
	end

	pg.ConnectionMgr.GetInstance():Send(20011, {
		id_list = var4_1
	}, 20012, function(arg0_2)
		local var0_2 = arg0_2.id_list

		for iter0_2, iter1_2 in ipairs(var0_2) do
			local var1_2 = var6_1:getTaskById(iter1_2)

			if var1_2:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
				local var2_2 = tonumber(var1_2:getConfig("target_id"))
				local var3_2 = var1_2:getConfig("target_num")

				getProxy(BagProxy):removeItemById(tonumber(var2_2), tonumber(var3_2))
			elseif var1_2:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
				local var4_2 = tonumber(var1_2:getConfig("target_id"))
				local var5_2 = var1_2:getConfig("target_num")

				getProxy(ActivityProxy):removeVitemById(var4_2, var5_2)
			elseif var1_2:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
				local var6_2 = tonumber(var1_2:getConfig("target_id"))
				local var7_2 = var1_2:getConfig("target_num")
				local var8_2 = getProxy(PlayerProxy)
				local var9_2 = var8_2:getData()

				var9_2:consume({
					[id2res(var6_2)] = var7_2
				})
				var8_2:updatePlayer(var9_2)
			end

			SubmitTaskCommand.AddGuildLivness(var1_2)

			if var1_2:getConfig("type") == Task.TYPE_REFLUX then
				getProxy(RefluxProxy):addPtAfterSubTasks({
					var1_2
				})
			end

			if var1_2:getConfig("type") ~= 8 then
				var6_1:removeTask(var1_2)
			else
				var1_2.submitTime = 1

				var6_1:updateTask(var1_2)
			end

			local var10_2 = getProxy(ActivityProxy)
			local var11_2 = var10_2:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

			if var11_2 and not var11_2:isEnd() then
				local var12_2 = var11_2:getConfig("config_data")[1] or {}

				if table.contains(var12_2, var1_2.id) then
					var10_2:monitorTaskList(var11_2)
				end
			end
		end

		var5_1 = PlayerConst.addTranDrop(arg0_2.award_list)

		if not var2_1 then
			arg0_1:sendNotification(GAME.SUBMIT_TASK_DONE, var5_1, _.map(var3_1, function(arg0_3)
				return arg0_3.id
			end))
		end

		if var1_1 then
			var1_1(var5_1)
		end
	end)
end

return var0_0
