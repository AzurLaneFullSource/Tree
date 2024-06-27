local var0_0 = class("SubmitActiveTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody() or {}
	local var1_1 = var0_1.callback
	local var2_1 = pg.activity_template[var0_1.act_id].type
	local var3_1 = {}

	if table.contains(TotalTaskProxy.avatar_task_type, var2_1) then
		-- block empty
	elseif table.contains(TotalTaskProxy.activity_task_type, var2_1) then
		for iter0_1, iter1_1 in ipairs(var0_1.task_ids) do
			local var4_1 = getProxy(ActivityTaskProxy):getTaskVo(var0_1.act_id, iter1_1)

			if var4_1 then
				table.insert(var3_1, var4_1)
			end
		end
	elseif table.contains(TotalTaskProxy.normal_task_type, var2_1) then
		for iter2_1, iter3_1 in ipairs(var0_1.task_ids) do
			local var5_1 = getProxy(TaskProxy):getTaskById(iter3_1)

			table.insert(var3_1, var5_1)
		end
	end

	if not arg0_1:InTaskScene() then
		local var6_1, var7_1 = arg0_1:filterOverflowTaskVOList(var3_1)

		if var7_1 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("player_expResource_mail_fullBag"),
				onYes = function()
					arg0_1:submitActivity(var0_1, var3_1, var2_1, var1_1)
				end,
				onNo = function()
					if var1_1 then
						var1_1(false)
					end
				end
			})

			return
		end
	end

	arg0_1:submitActivity(var0_1, var3_1, var2_1, var1_1)
end

function var0_0.submitActivity(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	pg.ConnectionMgr.GetInstance():Send(20205, {
		act_id = arg1_4.act_id,
		task_ids = arg1_4.task_ids
	}, 20206, function(arg0_5)
		if arg0_5.result == 0 then
			local var0_5 = {}

			if table.contains(TotalTaskProxy.avatar_task_type, arg3_4) then
				local var1_5 = pg.activity_template[arg1_4.act_id].config_id
				local var2_5 = pg.activity_event_avatarframe[var1_5]
				local var3_5 = Clone(var2_5.award_display)[1]
				local var4_5 = 0

				for iter0_5, iter1_5 in ipairs(arg1_4.task_ids) do
					var4_5 = var4_5 + arg0_4:getAwardNum(var2_5, iter1_5)
				end

				local var5_5 = getProxy(ActivityProxy):RawGetActivityById(arg1_4.act_id)

				if var5_5 then
					var5_5.data1 = var5_5.data1 + var4_5
				end

				var3_5[3] = var4_5

				local var6_5 = Drop.Create(var3_5)

				table.insert(var0_5, var6_5)
				arg0_4:sendNotification(GAME.SUBMIT_AVATAR_TASK_DONE, {
					awards = var0_5
				})
			elseif table.contains(TotalTaskProxy.activity_task_type, arg3_4) then
				local var7_5 = PlayerConst.addTranDrop(arg0_5.award_list, {
					taskId = task.id
				})

				for iter2_5 = 1, #arg1_4.task_ids do
					local var8_5 = arg1_4.task_ids[iter2_5]
					local var9_5 = pg.task_data_template[var8_5]
					local var10_5 = var9_5.award_display
					local var11_5 = var9_5.type
					local var12_5 = var9_5.sub_type
					local var13_5 = tonumber(var9_5.target_id)
					local var14_5 = tonumber(var9_5.target_id_2)
					local var15_5 = var9_5.target_num
					local var16_5 = getProxy(ActivityProxy):getActivityById(arg1_4.act_id)

					if var11_5 == 6 and var16_5 then
						assert(var16_5)

						local var17_5 = var16_5:GetFinishedTaskIds()

						if not table.contains(var17_5, var8_5) then
							table.insert(var17_5, var8_5)
							getProxy(ActivityProxy):updateActivity(var16_5)
						end
					end

					if var11_5 == 6 and var12_5 == 1006 and pg.activity_drop_type[var13_5] then
						local var18_5 = pg.activity_drop_type[var13_5].activity_id
						local var19_5 = getProxy(ActivityProxy):getActivityById(var18_5)

						if var19_5 then
							var19_5:subVitemNumber(var14_5, var15_5)
							getProxy(ActivityProxy):updateActivity(var19_5)
						end
					end
				end

				for iter3_5, iter4_5 in ipairs(arg2_4) do
					SubmitTaskCommand.OnSubmitSuccess(iter4_5)
				end

				arg0_4:sendNotification(GAME.SUBMIT_ACTIVITY_TASK_DONE, {
					awards = var7_5
				})
			elseif table.contains(TotalTaskProxy.normal_task_type, arg3_4) then
				local var20_5 = PlayerConst.addTranDrop(arg0_5.award_list, {})

				for iter5_5, iter6_5 in ipairs(arg2_4) do
					SubmitTaskCommand.OnSubmitSuccess(iter6_5)
				end

				arg0_4:sendNotification(GAME.SUBMIT_ACTIVITY_TASK_DONE, {
					awards = var20_5
				})
			end

			if arg4_4 then
				arg4_4(true)
			end
		else
			if arg4_4 then
				arg4_4(false)
			end

			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_5.result))
		end
	end)
end

function var0_0.filterOverflowTaskVOList(arg0_6, arg1_6)
	local var0_6 = {}
	local var1_6 = getProxy(PlayerProxy):getData()
	local var2_6 = pg.gameset.urpt_chapter_max.description[1]
	local var3_6 = var1_6.gold
	local var4_6 = var1_6.oil
	local var5_6 = not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var2_6) or 0
	local var6_6 = pg.gameset.max_gold.key_value
	local var7_6 = pg.gameset.max_oil.key_value

	if LOCK_UR_SHIP or not pg.gameset.urpt_chapter_max.description[2] then
		local var8_6 = 0
	end

	local var9_6 = false

	for iter0_6, iter1_6 in pairs(arg1_6) do
		local var10_6 = iter1_6:judgeOverflow(var3_6, var4_6, var5_6)

		if not var10_6 then
			table.insert(var0_6, iter1_6)
		end

		if var10_6 then
			var9_6 = true
		end
	end

	return var0_6, var9_6
end

function var0_0.getAwardNum(arg0_7, arg1_7, arg2_7)
	for iter0_7 = 1, #AvatarFrameTask.fillter_task_type do
		local var0_7 = AvatarFrameTask.fillter_task_type[iter0_7]
		local var1_7 = arg1_7[var0_7]

		for iter1_7, iter2_7 in ipairs(var1_7) do
			if arg2_7 == iter2_7[1] then
				if var0_7 == AvatarFrameTask.type_task_level then
					return iter2_7[6]
				elseif var0_7 == AvatarFrameTask.type_task_ship then
					return iter2_7[4]
				end
			end
		end
	end

	print("找不到taskId:" .. arg2_7)

	return 0
end

function var0_0.InTaskScene(arg0_8)
	return getProxy(ContextProxy):getCurrentContext().mediator == TaskMediator
end

return var0_0
