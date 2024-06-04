local var0 = class("SubmitTaskOneStepCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.callback
	local var2 = var0.dontSendMsg
	local var3 = var0.resultList
	local var4 = {}
	local var5 = {}
	local var6 = getProxy(TaskProxy)

	for iter0, iter1 in ipairs(var3) do
		local var7 = iter1.id
		local var8 = {}

		if iter1.choiceItemList then
			for iter2, iter3 in ipairs(iter1.choiceItemList) do
				table.insert(var8, iter3)
			end
		end

		local var9 = var6:getTaskById(var7)

		if not var9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("task_is_not_existence", var7))

			return
		end

		if not var9:isFinish() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_notFinish"))

			return
		end

		table.insert(var4, var7)
	end

	pg.ConnectionMgr.GetInstance():Send(20011, {
		id_list = var4
	}, 20012, function(arg0)
		local var0 = arg0.id_list

		for iter0, iter1 in ipairs(var0) do
			local var1 = var6:getTaskById(iter1)

			if var1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
				local var2 = tonumber(var1:getConfig("target_id"))
				local var3 = var1:getConfig("target_num")

				getProxy(BagProxy):removeItemById(tonumber(var2), tonumber(var3))
			elseif var1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
				local var4 = tonumber(var1:getConfig("target_id"))
				local var5 = var1:getConfig("target_num")

				getProxy(ActivityProxy):removeVitemById(var4, var5)
			elseif var1:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
				local var6 = tonumber(var1:getConfig("target_id"))
				local var7 = var1:getConfig("target_num")
				local var8 = getProxy(PlayerProxy)
				local var9 = var8:getData()

				var9:consume({
					[id2res(var6)] = var7
				})
				var8:updatePlayer(var9)
			end

			SubmitTaskCommand.AddGuildLivness(var1)

			if var1:getConfig("type") == Task.TYPE_REFLUX then
				getProxy(RefluxProxy):addPtAfterSubTasks({
					var1
				})
			end

			if var1:getConfig("type") ~= 8 then
				var6:removeTask(var1)
			else
				var1.submitTime = 1

				var6:updateTask(var1)
			end

			local var10 = getProxy(ActivityProxy)
			local var11 = var10:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

			if var11 and not var11:isEnd() then
				local var12 = var11:getConfig("config_data")[1] or {}

				if table.contains(var12, var1.id) then
					var10:monitorTaskList(var11)
				end
			end
		end

		var5 = PlayerConst.addTranDrop(arg0.award_list)

		if not var2 then
			arg0:sendNotification(GAME.SUBMIT_TASK_DONE, var5, _.map(var3, function(arg0)
				return arg0.id
			end))
		end

		if var1 then
			var1(var5)
		end
	end)
end

return var0
