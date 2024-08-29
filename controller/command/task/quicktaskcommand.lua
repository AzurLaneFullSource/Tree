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
		local var0_4 = false
		local var1_4

		if var5_1:isActivityTask() then
			var1_4 = var5_1:getActId()

			local var2_4 = pg.activity_template[var1_4].type

			if table.contains(TotalTaskProxy.normal_task_type, var2_4) then
				var0_4 = true
			end
		end

		if var0_4 then
			pg.ConnectionMgr.GetInstance():Send(20207, {
				act_id = var1_4,
				task_id = var5_1.id,
				item_cost = var5_1:getConfig("quick_finish")
			}, 20208, function(arg0_5)
				QuickTaskCommand.OnQuickTaskComplete(arg0_5, var5_1, var1_1)
			end)
		else
			pg.ConnectionMgr.GetInstance():Send(20013, {
				id = var5_1.id,
				item_cost = var5_1:getConfig("quick_finish")
			}, 20014, function(arg0_6)
				QuickTaskCommand.OnQuickTaskComplete(arg0_6, var5_1, var1_1)
			end)
		end
	end)
end

function var0_0.OnQuickTaskComplete(arg0_7, arg1_7, arg2_7)
	local var0_7 = getProxy(TaskProxy)

	var0_7:removeSubmittingTask(arg1_7.id)

	if arg0_7.result == 0 then
		local var1_7 = Item.QUICK_TASK_PASS_TICKET_ID
		local var2_7 = arg1_7:getConfig("quick_finish")

		getProxy(BagProxy):removeItemById(tonumber(var1_7), tonumber(var2_7))
		QuickTaskCommand.AddGuildLivness(arg1_7)

		local var3_7 = PlayerConst.addTranDrop(arg0_7.award_list, {
			taskId = arg1_7.id
		})

		if arg1_7:getConfig("type") ~= 8 then
			var0_7:removeTask(arg1_7)
		else
			arg1_7.submitTime = 1

			var0_7:updateTask(arg1_7)
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("battlepass_task_quickfinish3"))
		pg.m02:sendNotification(GAME.SUBMIT_TASK_DONE, var3_7, {
			arg1_7.id
		})

		local var4_7 = getProxy(ActivityProxy)
		local var5_7 = var4_7:getActivityByType(ActivityConst.ACTIVITY_TYPE_TASK_LIST_MONITOR)

		if var5_7 and not var5_7:isEnd() then
			local var6_7 = var5_7:getConfig("config_data")[1] or {}

			if table.contains(var6_7, arg1_7.id) then
				var4_7:monitorTaskList(var5_7)
			end
		end

		if arg2_7 then
			arg2_7(true)
		end
	else
		pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", arg0_7.result))

		if arg2_7 then
			arg2_7(false)
		end
	end
end

function var0_0.AddGuildLivness(arg0_8)
	if arg0_8:IsGuildAddLivnessType() then
		local var0_8 = getProxy(GuildProxy)
		local var1_8 = var0_8:getData()
		local var2_8 = 0
		local var3_8 = false

		if var1_8 and arg0_8:isGuildTask() then
			var1_8:setWeeklyTaskFlag(1)

			local var4_8 = var1_8:getWeeklyTask()

			if var4_8 then
				var2_8 = var4_8:GetLivenessAddition()
			end

			var3_8 = true
		elseif arg0_8:IsRoutineType() then
			var2_8 = pg.guildset.new_daily_task_guild_active.key_value
		elseif arg0_8:IsWeeklyType() then
			var2_8 = pg.guildset.new_weekly_task_guild_active.key_value
		end

		if var1_8 and var2_8 and var2_8 > 0 then
			var1_8:getMemberById(getProxy(PlayerProxy):getRawData().id):AddLiveness(var2_8)

			var3_8 = true
		end

		if var3_8 then
			var0_8:updateGuild(var1_8)
		end
	end
end

return var0_0
