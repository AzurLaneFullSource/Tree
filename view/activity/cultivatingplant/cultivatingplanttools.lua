local var0_0 = {
	GetTaskIDList = function()
		local var0_1 = {}

		for iter0_1, iter1_1 in ipairs(pg.task_data_template.get_id_list_by_sub_type[1070]) do
			if table.keyof(pg.task_data_template.get_id_list_by_type[6], iter1_1) then
				table.insert(var0_1, iter1_1)
			end
		end

		for iter2_1, iter3_1 in ipairs(pg.task_data_template.get_id_list_by_sub_type[1071]) do
			if table.keyof(pg.task_data_template.get_id_list_by_type[6], iter3_1) then
				table.insert(var0_1, iter3_1)
			end
		end

		table.sort(var0_1, function(arg0_2, arg1_2)
			return arg0_2 < arg1_2
		end)

		return var0_1
	end
}

function var0_0.NeedShowRedPoint()
	local var0_3 = var0_0.GetTaskIDList()
	local var1_3 = getProxy(TaskProxy)

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var2_3 = var1_3:getTaskVO(iter1_3)

		if var2_3 then
			local var3_3 = var2_3:isReceive()

			if var2_3:isFinish() and not var3_3 then
				return true
			end
		end
	end

	return false
end

function var0_0.IsPopActivity(arg0_4)
	local var0_4 = var0_0.GetTaskIDList()
	local var1_4 = getProxy(TaskProxy)

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local var2_4 = var1_4:getTaskVO(iter1_4)

		if var2_4 and tonumber(var2_4:getConfig("target_id")) == arg0_4 then
			local var3_4 = var2_4:isReceive()

			if var2_4:isFinish() and not var3_4 then
				return true
			end
		end
	end

	return false
end

return var0_0
