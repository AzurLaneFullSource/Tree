local var0_0 = class("SubmitTaskCommand", pm.SimpleCommand)

function var0_0.GetSubmitActivityTask(arg0_1)
	return GAME.SUBMIT_ACTIVITY_TASK
end

function var0_0.GetSubmitTaskDone(arg0_2)
	return GAME.SUBMIT_TASK_DONE
end

function var0_0.GetSubmitTaskAwardDone(arg0_3)
	return GAME.SUBMIT_TASK_AWARD_DOWN
end

function var0_0.execute(arg0_4, arg1_4)
	local var0_4 = arg1_4:getBody()
	local var1_4 = arg1_4:getType()
	local var2_4
	local var3_4 = {}
	local var4_4 = getProxy(TaskProxy)
	local var5_4 = true

	if type(var0_4) == "number" or type(var0_4) == "string" then
		var2_4 = var0_4
	elseif type(var0_4) == "table" then
		if var0_4.normal_submit then
			var5_4 = var0_4.virtual ~= nil and var0_4.virtual
			var2_4 = var0_4.taskId
		else
			var2_4 = var0_4.taskId

			local var6_4 = var0_4.index
			local var7_4 = var4_4:getTaskById(var2_4)

			assert(var7_4:isSelectable())

			local var8_4 = var7_4:getConfig("award_choice")[var6_4]

			for iter0_4, iter1_4 in ipairs(var8_4) do
				table.insert(var3_4, {
					type = iter1_4[1],
					id = iter1_4[2],
					number = iter1_4[3]
				})
			end
		end
	end

	local var9_4 = var4_4:getTaskById(var2_4)

	if not var9_4 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_is_not_existence", var2_4))

		if var1_4 then
			var1_4(false)
		end

		return
	end

	if not var9_4:isFinish() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_notFinish"))

		if var1_4 then
			var1_4(false)
		end

		return
	end

	if var9_4:isActivityTask() then
		pg.m02:sendNotification(arg0_4:GetSubmitActivityTask(), {
			act_id = var9_4:getActId(),
			task_ids = {
				var2_4
			},
			callback = function(arg0_5, arg1_5)
				if arg0_5 and var1_4 then
					var1_4(arg0_5)
				end
			end
		})

		return
	end

	if var4_4:isSubmitting(var2_4) then
		return
	else
		var4_4:addSubmittingTask(var2_4)
	end

	local var10_4 = {}

	if var9_4:IsOverflowShipExpItem() and not arg0_4:InTaskScene() then
		table.insert(var10_4, function(arg0_6)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("player_expResource_mail_fullBag"),
				onYes = arg0_6,
				onNo = function()
					var4_4:removeSubmittingTask(var2_4)

					if var1_4 then
						var1_4(false)
					end
				end
			})
		end)
	end

	seriesAsync(var10_4, function()
		pg.ConnectionMgr.GetInstance():Send(20005, {
			id = var9_4.id,
			choice_award = var3_4
		}, 20006, function(arg0_9)
			var4_4:removeSubmittingTask(var2_4)

			if arg0_9.result == 0 then
				local var0_9 = PlayerConst.addTranDrop(arg0_9.award_list, {
					taskId = var9_4.id
				})

				if not var5_4 then
					for iter0_9 = #var0_9, 1, -1 do
						if var0_9[iter0_9].type == DROP_TYPE_VITEM then
							table.remove(var0_9, iter0_9)
						end
					end
				end

				var0_0.OnSubmitSuccess(var9_4, var1_4)
				pg.m02:sendNotification(arg0_4:GetSubmitTaskDone(), var0_9, {
					var9_4.id
				})
				pg.m02:sendNotification(arg0_4:GetSubmitTaskAwardDone(), {
					awards = var0_9
				}, {
					var9_4.id
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0_9.result))

				if var1_4 then
					var1_4(false)
				end
			end
		end)
	end)
end

function var0_0.OnSubmitSuccess(arg0_10, arg1_10)
	var0_0.CheckTaskSub(arg0_10)
	var0_0.AddGuildLivness(arg0_10)
	var0_0.CheckTaskType(arg0_10)
	var0_0.UpdateActivity(arg0_10)

	if arg1_10 then
		arg1_10(true)
	end
end

function var0_0.CheckTaskSub(arg0_11)
	if arg0_11:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
		local var0_11 = tonumber(arg0_11:getConfig("target_id"))
		local var1_11 = arg0_11:getConfig("target_num")

		getProxy(BagProxy):removeItemById(tonumber(var0_11), tonumber(var1_11))
	elseif arg0_11:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
		local var2_11 = tonumber(arg0_11:getConfig("target_id"))
		local var3_11 = arg0_11:getConfig("target_num")

		getProxy(ActivityProxy):removeVitemById(var2_11, var3_11)
	elseif arg0_11:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
		local var4_11 = tonumber(arg0_11:getConfig("target_id"))
		local var5_11 = arg0_11:getConfig("target_num")
		local var6_11 = getProxy(PlayerProxy)
		local var7_11 = var6_11:getData()

		var7_11:consume({
			[id2res(var4_11)] = var5_11
		})
		var6_11:updatePlayer(var7_11)
	end
end

function var0_0.CheckTaskType(arg0_12)
	local var0_12 = arg0_12:getConfig("type")

	if var0_12 == Task.TYPE_REFLUX then
		getProxy(RefluxProxy):addPtAfterSubTasks({
			arg0_12
		})
	end

	if var0_12 == Task.TYPE_REPEATABLE then
		-- block empty
	elseif var0_12 == 8 then
		arg0_12.submitTime = 1

		getProxy(TaskProxy):updateTask(arg0_12)
	else
		getProxy(TaskProxy):removeTask(arg0_12)
	end
end

function var0_0.AddGuildLivness(arg0_13)
	if arg0_13:IsGuildAddLivnessType() then
		local var0_13 = getProxy(GuildProxy)
		local var1_13 = var0_13:getData()
		local var2_13 = 0
		local var3_13 = false

		if var1_13 and arg0_13:isGuildTask() then
			var1_13:setWeeklyTaskFlag(1)

			local var4_13 = var1_13:getWeeklyTask()

			if var4_13 then
				var2_13 = var4_13:GetLivenessAddition()
			end

			var3_13 = true
		elseif arg0_13:IsRoutineType() then
			var2_13 = pg.guildset.new_daily_task_guild_active.key_value
		elseif arg0_13:IsWeeklyType() then
			var2_13 = pg.guildset.new_weekly_task_guild_active.key_value
		end

		if var1_13 and var2_13 and var2_13 > 0 then
			var1_13:getMemberById(getProxy(PlayerProxy):getRawData().id):AddLiveness(var2_13)

			var3_13 = true
		end

		if var3_13 then
			var0_13:updateGuild(var1_13)
		end
	end
end

function var0_0.UpdateActivity(arg0_14)
	local var0_14 = getProxy(ActivityProxy)
	local var1_14 = var0_14:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

	if var1_14 and not var1_14:isEnd() then
		local var2_14 = var1_14:getConfig("config_data")[1] or {}

		if table.contains(var2_14, arg0_14.id) then
			var0_14:monitorTaskList(var1_14)
		end
	end
end

function var0_0.InTaskScene(arg0_15)
	return getProxy(ContextProxy):getCurrentContext().mediator == TaskMediator
end

return var0_0
