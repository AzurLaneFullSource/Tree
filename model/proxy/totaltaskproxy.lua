local var0_0 = class("TotalTaskProxy", import(".NetProxy"))

var0_0.TOTAL_TASK_UPDATED = "total task updated"
var0_0.avatar_task_type = {
	ActivityConst.ACTIVITY_TYPE_PT_OTHER
}
var0_0.activity_task_type = {
	ActivityConst.ACTIVITY_TYPE_TASK_RYZA,
	ActivityConst.ACTIVITY_TYPE_HOTSPRING_2
}
var0_0.normal_task_type = {
	ActivityConst.ACTIVITY_TYPE_TASKS
}

function var0_0.register(arg0_1)
	arg0_1.avatarFrames = {}
	arg0_1.actTasks = {}

	arg0_1:on(20201, function(arg0_2)
		for iter0_2, iter1_2 in ipairs(arg0_2.info) do
			local var0_2 = iter1_2.act_id
			local var1_2 = iter1_2.tasks
			local var2_2 = pg.activity_template[var0_2].type

			if table.contains(TotalTaskProxy.avatar_task_type, var2_2) then
				getProxy(AvatarFrameProxy):initListData(var0_2, var1_2)
			elseif table.contains(TotalTaskProxy.activity_task_type, var2_2) then
				getProxy(ActivityTaskProxy):initActList(var0_2, var1_2)
			elseif table.contains(TotalTaskProxy.normal_task_type, var2_2) then
				getProxy(TaskProxy):initActData(var0_2, var1_2)
			end
		end
	end)
	arg0_1:on(20202, function(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3.info) do
			local var0_3 = iter1_3.act_id
			local var1_3 = iter1_3.tasks
			local var2_3 = pg.activity_template[var0_3].type

			if table.contains(TotalTaskProxy.avatar_task_type, var2_3) then
				getProxy(AvatarFrameProxy):update(var0_3, var1_3)
			elseif table.contains(TotalTaskProxy.activity_task_type, var2_3) then
				getProxy(ActivityTaskProxy):updateActList(var0_3, var1_3)
			elseif table.contains(TotalTaskProxy.normal_task_type, var2_3) then
				getProxy(TaskProxy):updateActProgress(var0_3, var1_3)
			end
		end

		arg0_1.facade:sendNotification(var0_0.TOTAL_TASK_UPDATED)
	end)
	arg0_1:on(20203, function(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4.info) do
			local var0_4 = iter1_4.act_id
			local var1_4 = iter1_4.tasks
			local var2_4 = pg.activity_template[var0_4].type

			if table.contains(TotalTaskProxy.avatar_task_type, var2_4) then
				getProxy(AvatarFrameProxy):addData(var0_4, var1_4)
			elseif table.contains(TotalTaskProxy.activity_task_type, var2_4) then
				getProxy(ActivityTaskProxy):addActList(var0_4, var1_4)
			elseif table.contains(TotalTaskProxy.normal_task_type, var2_4) then
				getProxy(TaskProxy):addActData(var0_4, var1_4)
			end
		end

		arg0_1.facade:sendNotification(var0_0.TOTAL_TASK_UPDATED)
	end)
	arg0_1:on(20204, function(arg0_5)
		for iter0_5, iter1_5 in ipairs(arg0_5.info) do
			local var0_5 = iter1_5.act_id
			local var1_5 = iter1_5.tasks
			local var2_5 = pg.activity_template[var0_5].type

			if table.contains(TotalTaskProxy.avatar_task_type, var2_5) then
				getProxy(AvatarFrameProxy):removeData(var0_5, var1_5)
			elseif table.contains(TotalTaskProxy.activity_task_type, var2_5) then
				getProxy(ActivityTaskProxy):removeActList(var0_5, var1_5)
			elseif table.contains(TotalTaskProxy.normal_task_type, var2_5) then
				getProxy(TaskProxy):removeActData(var0_5, var1_5)
			end
		end

		arg0_1.facade:sendNotification(var0_0.TOTAL_TASK_UPDATED)
	end)
end

function var0_0.timeCall(arg0_6)
	return {
		[ProxyRegister.DayCall] = function(arg0_7)
			arg0_6:clearTimeOut()
		end
	}
end

function var0_0.clearTimeOut(arg0_8)
	getProxy(AvatarFrameProxy):clearTimeOut()
	getProxy(TaskProxy):clearTimeOut()
end

return var0_0
