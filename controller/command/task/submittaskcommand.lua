local var0 = class("SubmitTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = arg1:getType()
	local var2
	local var3 = {}
	local var4 = getProxy(TaskProxy)
	local var5 = true

	if type(var0) == "number" or type(var0) == "string" then
		var2 = var0
	elseif type(var0) == "table" then
		if var0.normal_submit then
			var5 = var0.virtual ~= nil and var0.virtual
			var2 = var0.taskId
		else
			var2 = var0.taskId

			local var6 = var0.index
			local var7 = var4:getTaskById(var2)

			assert(var7:isSelectable())

			local var8 = var7:getConfig("award_choice")[var6]

			for iter0, iter1 in ipairs(var8) do
				table.insert(var3, {
					type = iter1[1],
					id = iter1[2],
					number = iter1[3]
				})
			end
		end
	end

	local var9 = var4:getTaskById(var2)

	if not var9 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_is_not_existence", var2))

		if var1 then
			var1(false)
		end

		return
	end

	if not var9:isFinish() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_submitTask_error_notFinish"))

		if var1 then
			var1(false)
		end

		return
	end

	if var4:isSubmitting(var2) then
		return
	else
		var4:addSubmittingTask(var2)
	end

	local var10 = {}

	if var9:IsOverflowShipExpItem() and not arg0:InTaskScene() then
		table.insert(var10, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("player_expResource_mail_fullBag"),
				onYes = arg0,
				onNo = function()
					var4:removeSubmittingTask(var2)

					if var1 then
						var1(false)
					end
				end
			})
		end)
	end

	seriesAsync(var10, function()
		pg.ConnectionMgr.GetInstance():Send(20005, {
			id = var9.id,
			choice_award = var3
		}, 20006, function(arg0)
			var4:removeSubmittingTask(var2)

			if arg0.result == 0 then
				if var9:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_ITEM then
					local var0 = tonumber(var9:getConfig("target_id"))
					local var1 = var9:getConfig("target_num")

					getProxy(BagProxy):removeItemById(tonumber(var0), tonumber(var1))
				elseif var9:getConfig("sub_type") == TASK_SUB_TYPE_GIVE_VIRTUAL_ITEM then
					local var2 = tonumber(var9:getConfig("target_id"))
					local var3 = var9:getConfig("target_num")

					getProxy(ActivityProxy):removeVitemById(var2, var3)
				elseif var9:getConfig("sub_type") == TASK_SUB_TYPE_PLAYER_RES then
					local var4 = tonumber(var9:getConfig("target_id"))
					local var5 = var9:getConfig("target_num")
					local var6 = getProxy(PlayerProxy)
					local var7 = var6:getData()

					var7:consume({
						[id2res(var4)] = var5
					})
					var6:updatePlayer(var7)
				end

				var0.AddGuildLivness(var9)

				local var8 = PlayerConst.addTranDrop(arg0.award_list, {
					taskId = var9.id
				})

				if var9:getConfig("type") == Task.TYPE_REFLUX then
					getProxy(RefluxProxy):addPtAfterSubTasks({
						var9
					})
				end

				if var9:getConfig("type") ~= 8 then
					var4:removeTask(var9)
				else
					var9.submitTime = 1

					var4:updateTask(var9)
				end

				if not var5 then
					for iter0 = #var8, 1, -1 do
						if var8[iter0].type == DROP_TYPE_VITEM then
							table.remove(var8, iter0)
						end
					end
				end

				arg0:sendNotification(GAME.SUBMIT_TASK_DONE, var8, {
					var9.id
				})

				local var9 = getProxy(ActivityProxy)
				local var10 = var9:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

				if var10 and not var10:isEnd() then
					local var11 = var10:getConfig("config_data")[1] or {}

					if table.contains(var11, var9.id) then
						var9:monitorTaskList(var10)
					end
				end

				if var1 then
					var1(true)
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0.result))

				if var1 then
					var1(false)
				end
			end
		end)
	end)
end

function var0.AddGuildLivness(arg0)
	if arg0:IsGuildAddLivnessType() then
		local var0 = getProxy(GuildProxy)
		local var1 = var0:getData()
		local var2 = 0
		local var3 = false

		if var1 and arg0:isGuildTask() then
			var1:setWeeklyTaskFlag(1)

			local var4 = var1:getWeeklyTask()

			if var4 then
				var2 = var4:GetLivenessAddition()
			end

			var3 = true
		elseif arg0:IsRoutineType() then
			var2 = pg.guildset.new_daily_task_guild_active.key_value
		elseif arg0:IsWeeklyType() then
			var2 = pg.guildset.new_weekly_task_guild_active.key_value
		end

		if var1 and var2 and var2 > 0 then
			var1:getMemberById(getProxy(PlayerProxy):getRawData().id):AddLiveness(var2)

			var3 = true
		end

		if var3 then
			var0:updateGuild(var1)
		end
	end
end

function var0.InTaskScene(arg0)
	return getProxy(ContextProxy):getCurrentContext().mediator == TaskMediator
end

return var0
