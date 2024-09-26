local var0_0 = class("SubmitActiveTaskCommand", pm.SimpleCommand)
local var1_0 = {
	59599
}

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

			if getProxy(TaskProxy):isSubmitting(iter3_1) then
				-- block empty
			else
				getProxy(TaskProxy):addSubmittingTask(iter3_1)
				table.insert(var3_1, var5_1)
			end
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
				var0_5 = PlayerConst.addTranDrop(arg0_5.award_list, {})

				for iter2_5, iter3_5 in ipairs(arg2_4) do
					arg0_4:updateTaskActivityData(iter3_5.id, arg1_4.act_id)
					arg0_4:updateTaskBagData(iter3_5.id, arg1_4.act_id)
					SubmitTaskCommand.OnSubmitSuccess(iter3_5)
				end

				arg0_4:sendNotification(GAME.SUBMIT_ACTIVITY_TASK_DONE, {
					awards = var0_5
				}, arg1_4.task_ids)
			elseif table.contains(TotalTaskProxy.normal_task_type, arg3_4) then
				var0_5 = PlayerConst.addTranDrop(arg0_5.award_list, {})

				for iter4_5 = #var0_5, 1, -1 do
					if table.contains(var1_0, var0_5[iter4_5].id) then
						table.remove(var0_5, iter4_5)
					end
				end

				for iter5_5, iter6_5 in ipairs(arg2_4) do
					arg0_4:updateTaskBagData(iter6_5.id, arg1_4.act_id)
					SubmitTaskCommand.OnSubmitSuccess(iter6_5)
				end

				arg0_4:sendNotification(GAME.SUBMIT_ACTIVITY_TASK_DONE, {
					awards = var0_5
				}, arg1_4.task_ids)
			end

			if var0_5 and #var0_5 >= 0 then
				arg0_4:sendNotification(GAME.SUBMIT_TASK_AWARD_DOWN, {
					awards = var0_5
				}, arg1_4.task_ids)
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

function var0_0.updateTaskActivityData(arg0_6, arg1_6, arg2_6)
	local var0_6 = pg.task_data_template[arg1_6]
	local var1_6 = var0_6.type
	local var2_6 = var0_6.sub_type

	if getProxy(ActivityProxy):getActivityById(arg2_6) and var1_6 == 6 then
		getProxy(ActivityTaskProxy):finishActTask(arg2_6, arg1_6)
	end
end

local var2_0 = {
	{
		6,
		1006
	},
	{
		16,
		1006
	}
}

function var0_0.updateTaskBagData(arg0_7, arg1_7, arg2_7)
	local var0_7 = pg.task_data_template[arg1_7]
	local var1_7 = tonumber(var0_7.target_id)
	local var2_7 = tonumber(var0_7.target_id_2)
	local var3_7 = var0_7.target_num
	local var4_7 = var0_7.type
	local var5_7 = var0_7.sub_type

	if pg.activity_drop_type[var1_7] then
		for iter0_7, iter1_7 in ipairs(var2_0) do
			if var4_7 == iter1_7[1] and var5_7 == iter1_7[2] then
				local var6_7 = pg.activity_drop_type[var1_7].activity_id
				local var7_7 = getProxy(ActivityProxy):getActivityById(var6_7)

				if var7_7 then
					var7_7:subVitemNumber(var2_7, var3_7)
					getProxy(ActivityProxy):updateActivity(var7_7)
				end
			end
		end
	end
end

function var0_0.filterOverflowTaskVOList(arg0_8, arg1_8)
	local var0_8 = {}
	local var1_8 = getProxy(PlayerProxy):getData()
	local var2_8 = pg.gameset.urpt_chapter_max.description[1]
	local var3_8 = var1_8.gold
	local var4_8 = var1_8.oil
	local var5_8 = not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var2_8) or 0
	local var6_8 = pg.gameset.max_gold.key_value
	local var7_8 = pg.gameset.max_oil.key_value

	if LOCK_UR_SHIP or not pg.gameset.urpt_chapter_max.description[2] then
		local var8_8 = 0
	end

	local var9_8 = false

	for iter0_8, iter1_8 in pairs(arg1_8) do
		local var10_8 = iter1_8:judgeOverflow(var3_8, var4_8, var5_8)

		if not var10_8 then
			table.insert(var0_8, iter1_8)
		end

		if var10_8 then
			var9_8 = true
		end
	end

	return var0_8, var9_8
end

function var0_0.getAwardNum(arg0_9, arg1_9, arg2_9)
	for iter0_9 = 1, #AvatarFrameTask.fillter_task_type do
		local var0_9 = AvatarFrameTask.fillter_task_type[iter0_9]
		local var1_9 = arg1_9[var0_9]

		for iter1_9, iter2_9 in ipairs(var1_9) do
			if arg2_9 == iter2_9[1] then
				if var0_9 == AvatarFrameTask.type_task_level then
					return iter2_9[6]
				elseif var0_9 == AvatarFrameTask.type_task_ship then
					return iter2_9[4]
				end
			end
		end
	end

	print("找不到taskId:" .. arg2_9)

	return 0
end

function var0_0.InTaskScene(arg0_10)
	return getProxy(ContextProxy):getCurrentContext().mediator == TaskMediator
end

return var0_0
