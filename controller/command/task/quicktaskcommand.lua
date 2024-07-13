local var0_0 = class("QuickTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = arg1_1:getType()
	local var2_1
	local var3_1 = var0_1
	local var4_1 = getProxy(TaskProxy)
	local var5_1 = var4_1:getTaskById(var3_1)

	if not var5_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_is_not_existence", var3_1))

		if var1_1 then
			var1_1(false)
		end

		return
	end

	if var5_1:getConfig("quick_finish") > getProxy(BagProxy):getItemCountById(Item.QUICK_TASK_PASS_TICKET_ID) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		if var1_1 then
			var1_1(false)
		end

		return
	end

	if var4_1:isSubmitting(var3_1) then
		return
	else
		var4_1:addSubmittingTask(var3_1)
	end

	local var6_1 = {}

	if var5_1:IsOverflowShipExpItem() then
		table.insert(var6_1, function(arg0_2)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("player_expResource_mail_fullBag"),
				onYes = arg0_2,
				onNo = function()
					var4_1:removeSubmittingTask(var3_1)

					if var1_1 then
						var1_1(false)
					end
				end
			})
		end)
	end

	seriesAsync(var6_1, function()
		pg.ConnectionMgr.GetInstance():Send(20013, {
			id = var5_1.id,
			item_cost = var5_1:getConfig("quick_finish")
		}, 20014, function(arg0_5)
			var4_1:removeSubmittingTask(var3_1)

			if arg0_5.result == 0 then
				local var0_5 = Item.QUICK_TASK_PASS_TICKET_ID
				local var1_5 = var5_1:getConfig("quick_finish")

				getProxy(BagProxy):removeItemById(tonumber(var0_5), tonumber(var1_5))
				var0_0.AddGuildLivness(var5_1)

				local var2_5 = PlayerConst.addTranDrop(arg0_5.award_list, {
					taskId = var5_1.id
				})

				if var5_1:getConfig("type") ~= 8 then
					var4_1:removeTask(var5_1)
				else
					var5_1.submitTime = 1

					var4_1:updateTask(var5_1)
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("battlepass_task_quickfinish3"))
				arg0_1:sendNotification(GAME.SUBMIT_TASK_DONE, var2_5, {
					var5_1.id
				})

				local var3_5 = getProxy(ActivityProxy)
				local var4_5 = var3_5:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

				if var4_5 and not var4_5:isEnd() then
					local var5_5 = var4_5:getConfig("config_data")[1] or {}

					if table.contains(var5_5, var5_1.id) then
						var3_5:monitorTaskList(var4_5)
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

return var0_0
