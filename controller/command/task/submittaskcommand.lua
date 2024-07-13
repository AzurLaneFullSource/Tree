local var0_0 = class("SubmitTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = arg1_1:getType()
	local var2_1
	local var3_1 = {}
	local var4_1 = getProxy(TaskProxy)
	local var5_1 = true

	if type(var0_1) == "number" or type(var0_1) == "string" then
		var2_1 = var0_1
	elseif type(var0_1) == "table" then
		if var0_1.normal_submit then
			var5_1 = var0_1.virtual ~= nil and var0_1.virtual
			var2_1 = var0_1.taskId
		else
			var2_1 = var0_1.taskId

			local var6_1 = var0_1.index
			local var7_1 = var4_1:getTaskById(var2_1)

			assert(var7_1:isSelectable())

			local var8_1 = var7_1:getConfig("award_choice")[var6_1]

			for iter0_1, iter1_1 in ipairs(var8_1) do
				table.insert(var3_1, {
					type = iter1_1[1],
					id = iter1_1[2],
					number = iter1_1[3]
				})
			end
		end
	end

	local var9_1 = var4_1:getTaskById(var2_1)

	if not var9_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_is_not_existence", var2_1))

		if var1_1 then
			var1_1(false)
		end

		return
	end

	if not var9_1:isFinish() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_notFinish"))

		if var1_1 then
			var1_1(false)
		end

		return
	end

	if var9_1:isActivityTask() then
		pg.m02:sendNotification(GAME.SUBMIT_ACTIVITY_TASK, {
			act_id = var9_1:getActId(),
			task_ids = {
				var2_1
			},
			callback = function(arg0_2, arg1_2)
				if arg0_2 and var1_1 then
					var1_1(arg0_2)
				end
			end
		})

		return
	end

	if var4_1:isSubmitting(var2_1) then
		return
	else
		var4_1:addSubmittingTask(var2_1)
	end

	local var10_1 = {}

	if var9_1:IsOverflowShipExpItem() and not arg0_1:InTaskScene() then
		table.insert(var10_1, function(arg0_3)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("player_expResource_mail_fullBag"),
				onYes = arg0_3,
				onNo = function()
					var4_1:removeSubmittingTask(var2_1)

					if var1_1 then
						var1_1(false)
					end
				end
			})
		end)
	end

	seriesAsync(var10_1, function()
		pg.ConnectionMgr.GetInstance():Send(20005, {
			id = var9_1.id,
			choice_award = var3_1
		}, 20006, function(arg0_6)
			var4_1:removeSubmittingTask(var2_1)

			if arg0_6.result == 0 then
				local var0_6 = PlayerConst.addTranDrop(arg0_6.award_list, {
					taskId = var9_1.id
				})

				if not var5_1 then
					for iter0_6 = #var0_6, 1, -1 do
						if var0_6[iter0_6].type == DROP_TYPE_VITEM then
							table.remove(var0_6, iter0_6)
						end
					end
				end

				var0_0.OnSubmitSuccess(var9_1, var1_1)
				pg.m02:sendNotification(GAME.SUBMIT_TASK_DONE, var0_6, {
					var9_1.id
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0_6.result))

				if var1_1 then
					var1_1(false)
				end
			end
		end)
	end)
end

function var0_0.OnSubmitSuccess(arg0_7, arg1_7)
	var0_0.CheckTaskSub(arg0_7)
	var0_0.AddGuildLivness(arg0_7)
	var0_0.CheckTaskType(arg0_7)
	var0_0.UpdateActivity(arg0_7)

	if arg1_7 then
		arg1_7(true)
	end
end

function var0_0.CheckTaskSub(arg0_8)
	if arg0_8:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
		local var0_8 = tonumber(arg0_8:getConfig("target_id"))
		local var1_8 = arg0_8:getConfig("target_num")

		getProxy(BagProxy):removeItemById(tonumber(var0_8), tonumber(var1_8))
	elseif arg0_8:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
		local var2_8 = tonumber(arg0_8:getConfig("target_id"))
		local var3_8 = arg0_8:getConfig("target_num")

		getProxy(ActivityProxy):removeVitemById(var2_8, var3_8)
	elseif arg0_8:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
		local var4_8 = tonumber(arg0_8:getConfig("target_id"))
		local var5_8 = arg0_8:getConfig("target_num")
		local var6_8 = getProxy(PlayerProxy)
		local var7_8 = var6_8:getData()

		var7_8:consume({
			[id2res(var4_8)] = var5_8
		})
		var6_8:updatePlayer(var7_8)
	end
end

function var0_0.CheckTaskType(arg0_9)
	if arg0_9:getConfig("type") == Task.TYPE_REFLUX then
		getProxy(RefluxProxy):addPtAfterSubTasks({
			arg0_9
		})
	end

	if arg0_9:getConfig("type") ~= 8 then
		getProxy(TaskProxy):removeTask(arg0_9)
	else
		arg0_9.submitTime = 1

		getProxy(TaskProxy):updateTask(arg0_9)
	end
end

function var0_0.AddGuildLivness(arg0_10)
	if arg0_10:IsGuildAddLivnessType() then
		local var0_10 = getProxy(GuildProxy)
		local var1_10 = var0_10:getData()
		local var2_10 = 0
		local var3_10 = false

		if var1_10 and arg0_10:isGuildTask() then
			var1_10:setWeeklyTaskFlag(1)

			local var4_10 = var1_10:getWeeklyTask()

			if var4_10 then
				var2_10 = var4_10:GetLivenessAddition()
			end

			var3_10 = true
		elseif arg0_10:IsRoutineType() then
			var2_10 = pg.guildset.new_daily_task_guild_active.key_value
		elseif arg0_10:IsWeeklyType() then
			var2_10 = pg.guildset.new_weekly_task_guild_active.key_value
		end

		if var1_10 and var2_10 and var2_10 > 0 then
			var1_10:getMemberById(getProxy(PlayerProxy):getRawData().id):AddLiveness(var2_10)

			var3_10 = true
		end

		if var3_10 then
			var0_10:updateGuild(var1_10)
		end
	end
end

function var0_0.UpdateActivity(arg0_11)
	local var0_11 = getProxy(ActivityProxy)
	local var1_11 = var0_11:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

	if var1_11 and not var1_11:isEnd() then
		local var2_11 = var1_11:getConfig("config_data")[1] or {}

		if table.contains(var2_11, arg0_11.id) then
			var0_11:monitorTaskList(var1_11)
		end
	end
end

function var0_0.InTaskScene(arg0_12)
	return getProxy(ContextProxy):getCurrentContext().mediator == TaskMediator
end

return var0_0
