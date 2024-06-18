local var0_0 = class("AvatarFrameAwardCommand", pm.SimpleCommand)
local var1_0

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody() or {}
	local var1_1 = var0_1.callback
	local var2_1 = pg.activity_template[var0_1.act_id].type

	pg.ConnectionMgr.GetInstance():Send(20205, {
		act_id = var0_1.act_id,
		task_ids = var0_1.task_ids
	}, 20206, function(arg0_2)
		if arg0_2.result == 0 then
			if var2_1 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				local var0_2 = pg.activity_template[var0_1.act_id].config_id
				local var1_2 = pg.activity_event_avatarframe[var0_2]
				local var2_2 = Clone(var1_2.award_display)[1]
				local var3_2 = 0

				for iter0_2, iter1_2 in ipairs(var0_1.task_ids) do
					var3_2 = var3_2 + arg0_1:getAwardNum(var1_2, iter1_2)
				end

				local var4_2 = getProxy(ActivityProxy):RawGetActivityById(var0_1.act_id)

				if var4_2 then
					var4_2.data1 = var4_2.data1 + var3_2
				end

				var2_2[3] = var3_2

				local var5_2 = Drop.Create(var2_2)

				arg0_1:sendNotification(GAME.SUBMIT_AVATAR_TASK_DONE, {
					awards = {
						var5_2
					},
					callback = var1_1
				})
			else
				local var6_2 = PlayerConst.addTranDrop(arg0_2.award_list)
				local var7_2 = {}

				for iter2_2 = 1, #var0_1.task_ids do
					local var8_2 = var0_1.task_ids[iter2_2]
					local var9_2 = pg.task_data_template[var8_2]
					local var10_2 = var9_2.award_display
					local var11_2 = var9_2.type
					local var12_2 = var9_2.sub_type
					local var13_2 = tonumber(var9_2.target_id)
					local var14_2 = tonumber(var9_2.target_id_2)
					local var15_2 = var9_2.target_num

					if var11_2 == 6 then
						local var16_2 = getProxy(ActivityProxy):getActivityById(var0_1.act_id)

						assert(var16_2)

						local var17_2 = var16_2:GetFinishedTaskIds()

						if not table.contains(var17_2, var8_2) then
							table.insert(var17_2, var8_2)
							getProxy(ActivityProxy):updateActivity(var16_2)
						end
					end

					if var11_2 == 6 and var12_2 == 1006 and pg.activity_drop_type[var13_2] then
						local var18_2 = pg.activity_drop_type[var13_2].activity_id
						local var19_2 = getProxy(ActivityProxy):getActivityById(var18_2)

						if var19_2 then
							var19_2:subVitemNumber(var14_2, var15_2)
							getProxy(ActivityProxy):updateActivity(var19_2)
						end
					end
				end

				for iter3_2, iter4_2 in ipairs(arg0_2.award_list) do
					local var20_2 = Drop.New({
						type = iter4_2.type,
						id = iter4_2.id,
						count = iter4_2.number
					})

					table.insert(var7_2, var20_2)
				end

				arg0_1:sendNotification(GAME.SUBMIT_AVATAR_TASK_DONE, {
					awards = var7_2,
					callback = var1_1
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

function var0_0.getAwardNum(arg0_3, arg1_3, arg2_3)
	for iter0_3 = 1, #AvatarFrameTask.fillter_task_type do
		local var0_3 = AvatarFrameTask.fillter_task_type[iter0_3]
		local var1_3 = arg1_3[var0_3]

		for iter1_3, iter2_3 in ipairs(var1_3) do
			if arg2_3 == iter2_3[1] then
				if var0_3 == AvatarFrameTask.type_task_level then
					return iter2_3[6]
				elseif var0_3 == AvatarFrameTask.type_task_ship then
					return iter2_3[4]
				end
			end
		end
	end

	print("找不到taskId:" .. arg2_3)

	return 0
end

return var0_0
