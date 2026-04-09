local var0_0 = class("SubmitActiveTaskCommand", pm.SimpleCommand)
local var1_0 = {
	59599
}

function var0_0.GetSubmitActivityTaskDone(arg0_1)
	return GAME.SUBMIT_ACTIVITY_TASK_DONE
end

function var0_0.GetSubMitActivityAwardDown(arg0_2)
	return GAME.SUBMIT_TASK_AWARD_DOWN
end

function var0_0.execute(arg0_3, arg1_3)
	local var0_3 = arg1_3:getBody() or {}
	local var1_3 = var0_3.callback
	local var2_3 = pg.activity_template[var0_3.act_id].type
	local var3_3 = {}

	if table.contains(TotalTaskProxy.avatar_task_type, var2_3) then
		-- block empty
	elseif table.contains(TotalTaskProxy.activity_task_type, var2_3) then
		for iter0_3, iter1_3 in ipairs(var0_3.task_ids) do
			local var4_3 = getProxy(ActivityTaskProxy):getTaskVo(var0_3.act_id, iter1_3)

			if var4_3 then
				table.insert(var3_3, var4_3)
			end
		end
	elseif table.contains(TotalTaskProxy.normal_task_type, var2_3) then
		for iter2_3, iter3_3 in ipairs(var0_3.task_ids) do
			local var5_3 = getProxy(TaskProxy):getTaskById(iter3_3)

			if getProxy(TaskProxy):isSubmitting(iter3_3) then
				-- block empty
			else
				getProxy(TaskProxy):addSubmittingTask(iter3_3)
				table.insert(var3_3, var5_3)
			end
		end
	end

	if not arg0_3:InTaskScene() then
		local var6_3, var7_3 = arg0_3:filterOverflowTaskVOList(var3_3)

		if var7_3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("player_expResource_mail_fullBag"),
				onYes = function()
					arg0_3:submitActivity(var0_3, var3_3, var2_3, var1_3)
				end,
				onNo = function()
					if var1_3 then
						var1_3(false)
					end
				end
			})

			return
		end
	end

	arg0_3:submitActivity(var0_3, var3_3, var2_3, var1_3)
end

function var0_0.submitActivity(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	pg.ConnectionMgr.GetInstance():Send(20205, {
		act_id = arg1_6.act_id,
		task_ids = arg1_6.task_ids
	}, 20206, function(arg0_7)
		if arg0_7.result == 0 then
			local var0_7 = {}

			if table.contains(TotalTaskProxy.avatar_task_type, arg3_6) then
				local var1_7 = pg.activity_template[arg1_6.act_id].config_id
				local var2_7 = pg.activity_event_avatarframe[var1_7]
				local var3_7 = Clone(var2_7.award_display)[1]
				local var4_7 = 0

				for iter0_7, iter1_7 in ipairs(arg1_6.task_ids) do
					var4_7 = var4_7 + arg0_6:getAwardNum(var2_7, iter1_7)
				end

				local var5_7 = getProxy(ActivityProxy):RawGetActivityById(arg1_6.act_id)

				if var5_7 then
					var5_7.data1 = var5_7.data1 + var4_7
				end

				var3_7[3] = var4_7

				local var6_7 = Drop.Create(var3_7)

				table.insert(var0_7, var6_7)
				arg0_6:sendNotification(GAME.SUBMIT_AVATAR_TASK_DONE, {
					awards = var0_7
				})
			elseif table.contains(TotalTaskProxy.activity_task_type, arg3_6) then
				for iter2_7, iter3_7 in ipairs(arg2_6) do
					arg0_6:updateTaskActivityData(iter3_7.id, arg1_6.act_id)
					arg0_6:updateTaskBagData(iter3_7.id, arg1_6.act_id)
					SubmitTaskCommand.OnSubmitSuccess(iter3_7)
				end

				if arg1_6.inIsland then
					local var7_7 = IslandDropHelper.AddItems({
						drop_list = arg0_7.award_list
					})

					arg0_6:sendNotification(GAME.SUBMIT_ACTIVITY_TASK_IN_ISLAND_DONE, {
						dropData = var7_7,
						actId = arg1_6.act_id
					})
				else
					var0_7 = PlayerConst.addTranDrop(arg0_7.award_list, {})

					arg0_6:sendNotification(arg0_6:GetSubmitActivityTaskDone(), {
						awards = var0_7
					}, arg1_6.task_ids)
				end
			elseif table.contains(TotalTaskProxy.normal_task_type, arg3_6) then
				var0_7 = PlayerConst.addTranDrop(arg0_7.award_list, {})

				for iter4_7 = #var0_7, 1, -1 do
					if table.contains(var1_0, var0_7[iter4_7].id) then
						table.remove(var0_7, iter4_7)
					end
				end

				for iter5_7, iter6_7 in ipairs(arg2_6) do
					arg0_6:updateTaskBagData(iter6_7.id, arg1_6.act_id)
					SubmitTaskCommand.OnSubmitSuccess(iter6_7)
					getProxy(TaskProxy):removeSubmittingTask(iter6_7.id)
				end

				arg0_6:sendNotification(arg0_6:GetSubmitActivityTaskDone(), {
					awards = var0_7
				}, arg1_6.task_ids)
			end

			arg0_6:sendNotification(arg0_6:GetSubMitActivityAwardDown(), {
				awards = var0_7
			}, arg1_6.task_ids)

			if arg4_6 then
				arg4_6(true)
			end
		else
			if arg4_6 then
				arg4_6(false)
			end

			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_7.result))
		end
	end)
end

function var0_0.updateTaskActivityData(arg0_8, arg1_8, arg2_8)
	local var0_8 = getProxy(ActivityProxy):getActivityById(arg2_8)

	if var0_8 then
		getProxy(ActivityTaskProxy):finishActTask(arg2_8, arg1_8)
		arg0_8:sendNotification(ActivityProxy.ACTIVITY_UPDATED, var0_8)
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
local var3_0 = {
	{
		6,
		1007
	},
	{
		16,
		1007
	}
}

function var0_0.updateTaskBagData(arg0_9, arg1_9, arg2_9)
	local var0_9 = pg.task_data_template[arg1_9]
	local var1_9 = tonumber(var0_9.target_id)
	local var2_9 = var0_9.type
	local var3_9 = var0_9.sub_type

	if pg.activity_drop_type[var1_9] then
		for iter0_9, iter1_9 in ipairs(var2_0) do
			if var2_9 == iter1_9[1] and var3_9 == iter1_9[2] then
				local var4_9 = tonumber(var0_9.target_id_2)
				local var5_9 = var0_9.target_num
				local var6_9 = pg.activity_drop_type[var1_9].activity_id
				local var7_9 = getProxy(ActivityProxy):getActivityById(var6_9)

				if var7_9 then
					var7_9:subVitemNumber(var4_9, var5_9)
					getProxy(ActivityProxy):updateActivity(var7_9)
				end
			end
		end

		for iter2_9, iter3_9 in ipairs(var3_0) do
			if var2_9 == iter3_9[1] and var3_9 == iter3_9[2] then
				local var8_9 = pg.activity_drop_type[var1_9].activity_id
				local var9_9 = getProxy(ActivityProxy):getActivityById(var8_9)

				if var9_9 then
					local var10_9 = var0_9.target_id_2

					for iter4_9, iter5_9 in ipairs(var10_9) do
						local var11_9 = iter5_9[1]
						local var12_9 = iter5_9[2]

						var9_9:subVitemNumber(var11_9, var12_9)
					end

					getProxy(ActivityProxy):updateActivity(var9_9)
				end
			end
		end
	end
end

function var0_0.filterOverflowTaskVOList(arg0_10, arg1_10)
	local var0_10 = {}
	local var1_10 = getProxy(PlayerProxy):getData()
	local var2_10 = pg.gameset.urpt_chapter_max.description[1]
	local var3_10 = var1_10.gold
	local var4_10 = var1_10.oil
	local var5_10 = not LOCK_UR_SHIP and getProxy(BagProxy):GetLimitCntById(var2_10) or 0
	local var6_10 = pg.gameset.max_gold.key_value
	local var7_10 = pg.gameset.max_oil.key_value

	if LOCK_UR_SHIP or not pg.gameset.urpt_chapter_max.description[2] then
		local var8_10 = 0
	end

	local var9_10 = false

	for iter0_10, iter1_10 in pairs(arg1_10) do
		local var10_10 = iter1_10:judgeOverflow(var3_10, var4_10, var5_10)

		if not var10_10 then
			table.insert(var0_10, iter1_10)
		end

		if var10_10 then
			var9_10 = true
		end
	end

	return var0_10, var9_10
end

function var0_0.getAwardNum(arg0_11, arg1_11, arg2_11)
	for iter0_11 = 1, #AvatarFrameTask.fillter_task_type do
		local var0_11 = AvatarFrameTask.fillter_task_type[iter0_11]
		local var1_11 = arg1_11[var0_11]

		for iter1_11, iter2_11 in ipairs(var1_11) do
			if arg2_11 == iter2_11[1] then
				if var0_11 == AvatarFrameTask.type_task_level then
					return iter2_11[6]
				elseif var0_11 == AvatarFrameTask.type_task_ship then
					return iter2_11[4]
				end
			end
		end
	end

	print("找不到taskId:" .. arg2_11)

	return 0
end

function var0_0.InTaskScene(arg0_12)
	return getProxy(ContextProxy):getCurrentContext().mediator == TaskMediator
end

return var0_0
