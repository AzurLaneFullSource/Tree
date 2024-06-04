local var0 = class("AvatarFrameAwardCommand", pm.SimpleCommand)
local var1

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody() or {}
	local var1 = var0.callback
	local var2 = pg.activity_template[var0.act_id].type

	pg.ConnectionMgr.GetInstance():Send(20205, {
		act_id = var0.act_id,
		task_ids = var0.task_ids
	}, 20206, function(arg0)
		if arg0.result == 0 then
			if var2 == ActivityConst.ACTIVITY_TYPE_PT_OTHER then
				local var0 = pg.activity_template[var0.act_id].config_id
				local var1 = pg.activity_event_avatarframe[var0]
				local var2 = Clone(var1.award_display)[1]
				local var3 = 0

				for iter0, iter1 in ipairs(var0.task_ids) do
					var3 = var3 + arg0:getAwardNum(var1, iter1)
				end

				local var4 = getProxy(ActivityProxy):RawGetActivityById(var0.act_id)

				if var4 then
					var4.data1 = var4.data1 + var3
				end

				var2[3] = var3

				local var5 = Drop.Create(var2)

				arg0:sendNotification(GAME.SUBMIT_AVATAR_TASK_DONE, {
					awards = {
						var5
					},
					callback = var1
				})
			else
				local var6 = PlayerConst.addTranDrop(arg0.award_list)
				local var7 = {}

				for iter2 = 1, #var0.task_ids do
					local var8 = var0.task_ids[iter2]
					local var9 = pg.task_data_template[var8]
					local var10 = var9.award_display
					local var11 = var9.type
					local var12 = var9.sub_type
					local var13 = tonumber(var9.target_id)
					local var14 = tonumber(var9.target_id_2)
					local var15 = var9.target_num

					if var11 == 6 then
						local var16 = getProxy(ActivityProxy):getActivityById(var0.act_id)

						assert(var16)

						local var17 = var16:GetFinishedTaskIds()

						if not table.contains(var17, var8) then
							table.insert(var17, var8)
							getProxy(ActivityProxy):updateActivity(var16)
						end
					end

					if var11 == 6 and var12 == 1006 and pg.activity_drop_type[var13] then
						local var18 = pg.activity_drop_type[var13].activity_id
						local var19 = getProxy(ActivityProxy):getActivityById(var18)

						if var19 then
							var19:subVitemNumber(var14, var15)
							getProxy(ActivityProxy):updateActivity(var19)
						end
					end
				end

				for iter3, iter4 in ipairs(arg0.award_list) do
					local var20 = Drop.New({
						type = iter4.type,
						id = iter4.id,
						count = iter4.number
					})

					table.insert(var7, var20)
				end

				arg0:sendNotification(GAME.SUBMIT_AVATAR_TASK_DONE, {
					awards = var7,
					callback = var1
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

function var0.getAwardNum(arg0, arg1, arg2)
	for iter0 = 1, #AvatarFrameTask.fillter_task_type do
		local var0 = AvatarFrameTask.fillter_task_type[iter0]
		local var1 = arg1[var0]

		for iter1, iter2 in ipairs(var1) do
			if arg2 == iter2[1] then
				if var0 == AvatarFrameTask.type_task_level then
					return iter2[6]
				elseif var0 == AvatarFrameTask.type_task_ship then
					return iter2[4]
				end
			end
		end
	end

	print("找不到taskId:" .. arg2)

	return 0
end

return var0
