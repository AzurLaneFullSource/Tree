local var0 = class("QuickTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = arg1:getType()
	local var2
	local var3 = var0
	local var4 = getProxy(TaskProxy)
	local var5 = var4:getTaskById(var3)

	if not var5 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("task_is_not_existence", var3))

		if var1 then
			var1(false)
		end

		return
	end

	if var5:getConfig("quick_finish") > getProxy(BagProxy):getItemCountById(Item.QUICK_TASK_PASS_TICKET_ID) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

		if var1 then
			var1(false)
		end

		return
	end

	if var4:isSubmitting(var3) then
		return
	else
		var4:addSubmittingTask(var3)
	end

	local var6 = {}

	if var5:IsOverflowShipExpItem() then
		table.insert(var6, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("player_expResource_mail_fullBag"),
				onYes = arg0,
				onNo = function()
					var4:removeSubmittingTask(var3)

					if var1 then
						var1(false)
					end
				end
			})
		end)
	end

	seriesAsync(var6, function()
		pg.ConnectionMgr.GetInstance():Send(20013, {
			id = var5.id,
			item_cost = var5:getConfig("quick_finish")
		}, 20014, function(arg0)
			var4:removeSubmittingTask(var3)

			if arg0.result == 0 then
				local var0 = Item.QUICK_TASK_PASS_TICKET_ID
				local var1 = var5:getConfig("quick_finish")

				getProxy(BagProxy):removeItemById(tonumber(var0), tonumber(var1))
				var0.AddGuildLivness(var5)

				local var2 = PlayerConst.addTranDrop(arg0.award_list, {
					taskId = var5.id
				})

				if var5:getConfig("type") ~= 8 then
					var4:removeTask(var5)
				else
					var5.submitTime = 1

					var4:updateTask(var5)
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("battlepass_task_quickfinish3"))
				arg0:sendNotification(GAME.SUBMIT_TASK_DONE, var2, {
					var5.id
				})

				local var3 = getProxy(ActivityProxy)
				local var4 = var3:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

				if var4 and not var4:isEnd() then
					local var5 = var4:getConfig("config_data")[1] or {}

					if table.contains(var5, var5.id) then
						var3:monitorTaskList(var4)
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

return var0
