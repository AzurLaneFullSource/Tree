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

	if var4_1:isSubmitting(var2_1) then
		return
	else
		var4_1:addSubmittingTask(var2_1)
	end

	local var10_1 = {}

	if var9_1:IsOverflowShipExpItem() and not arg0_1:InTaskScene() then
		table.insert(var10_1, function(arg0_2)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("player_expResource_mail_fullBag"),
				onYes = arg0_2,
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
		}, 20006, function(arg0_5)
			var4_1:removeSubmittingTask(var2_1)

			if arg0_5.result == 0 then
				if var9_1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
					local var0_5 = tonumber(var9_1:getConfig("target_id"))
					local var1_5 = var9_1:getConfig("target_num")

					getProxy(BagProxy):removeItemById(tonumber(var0_5), tonumber(var1_5))
				elseif var9_1:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
					local var2_5 = tonumber(var9_1:getConfig("target_id"))
					local var3_5 = var9_1:getConfig("target_num")

					getProxy(ActivityProxy):removeVitemById(var2_5, var3_5)
				elseif var9_1:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
					local var4_5 = tonumber(var9_1:getConfig("target_id"))
					local var5_5 = var9_1:getConfig("target_num")
					local var6_5 = getProxy(PlayerProxy)
					local var7_5 = var6_5:getData()

					var7_5:consume({
						[id2res(var4_5)] = var5_5
					})
					var6_5:updatePlayer(var7_5)
				end

				var0_0.AddGuildLivness(var9_1)

				local var8_5 = PlayerConst.addTranDrop(arg0_5.award_list, {
					taskId = var9_1.id
				})

				if var9_1:getConfig("type") == Task.TYPE_REFLUX then
					getProxy(RefluxProxy):addPtAfterSubTasks({
						var9_1
					})
				end

				if var9_1:getConfig("type") ~= 8 then
					var4_1:removeTask(var9_1)
				else
					var9_1.submitTime = 1

					var4_1:updateTask(var9_1)
				end

				if not var5_1 then
					for iter0_5 = #var8_5, 1, -1 do
						if var8_5[iter0_5].type == DROP_TYPE_VITEM then
							table.remove(var8_5, iter0_5)
						end
					end
				end

				arg0_1:sendNotification(GAME.SUBMIT_TASK_DONE, var8_5, {
					var9_1.id
				})

				local var9_5 = getProxy(ActivityProxy)
				local var10_5 = var9_5:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

				if var10_5 and not var10_5:isEnd() then
					local var11_5 = var10_5:getConfig("config_data")[1] or {}

					if table.contains(var11_5, var9_1.id) then
						var9_5:monitorTaskList(var10_5)
					end
				end

				if var1_1 then
					var1_1(true)
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0_5.result))

				if var1_1 then
					var1_1(false)
				end
			end
		end)
	end)
end

function var0_0.AddGuildLivness(arg0_6)
	if arg0_6:IsGuildAddLivnessType() then
		local var0_6 = getProxy(GuildProxy)
		local var1_6 = var0_6:getData()
		local var2_6 = 0
		local var3_6 = false

		if var1_6 and arg0_6:isGuildTask() then
			var1_6:setWeeklyTaskFlag(1)

			local var4_6 = var1_6:getWeeklyTask()

			if var4_6 then
				var2_6 = var4_6:GetLivenessAddition()
			end

			var3_6 = true
		elseif arg0_6:IsRoutineType() then
			var2_6 = pg.guildset.new_daily_task_guild_active.key_value
		elseif arg0_6:IsWeeklyType() then
			var2_6 = pg.guildset.new_weekly_task_guild_active.key_value
		end

		if var1_6 and var2_6 and var2_6 > 0 then
			var1_6:getMemberById(getProxy(PlayerProxy):getRawData().id):AddLiveness(var2_6)

			var3_6 = true
		end

		if var3_6 then
			var0_6:updateGuild(var1_6)
		end
	end
end

function var0_0.InTaskScene(arg0_7)
	return getProxy(ContextProxy):getCurrentContext().mediator == TaskMediator
end

return var0_0
