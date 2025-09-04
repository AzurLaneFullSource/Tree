local var0_0 = class("IslandVisibilityAllocator", import(".IslandComparableAllocator"))

function var0_0.OnInitFlags(arg0_1)
	for iter0_1, iter1_1 in ipairs(arg0_1.controller.sceneData.unitList) do
		arg0_1.flags[iter1_1.id] = not iter1_1.isDynamic

		arg0_1:ApplyCondition(iter1_1)
	end
end

function var0_0.OnCompareSample(arg0_2, arg1_2, arg2_2)
	for iter0_2, iter1_2 in pairs(arg1_2) do
		local var0_2 = iter1_2
		local var1_2 = arg2_2[iter0_2]

		if var0_2 ~= nil and var1_2 ~= nil and var0_2 ~= var1_2 then
			if var0_2 == true and var1_2 == false then
				arg0_2:RemoveUnit(IslandConst.UNIT_LIST_OBJ, iter0_2)
			elseif var0_2 == false and var1_2 == true then
				local var2_2 = arg0_2:GetUnitData(iter0_2)

				if var2_2 then
					arg0_2:GenUnit(var2_2)
				end
			end
		end
	end
end

function var0_0.GetUnitData(arg0_3, arg1_3)
	for iter0_3, iter1_3 in ipairs(arg0_3.controller.sceneData.unitList) do
		if iter1_3.id == arg1_3 then
			return iter1_3
		end
	end

	return nil
end

function var0_0.ApplyCondition(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetShowCondition()
	local var1_4 = arg1_4:GetHideCondition()

	if #var0_4 == 0 and #var1_4 == 0 then
		return
	end

	local var2_4 = arg0_4.controller.island:GetTaskAgency()
	local var3_4 = var2_4:GetTraceId()
	local var4_4 = arg0_4:CollectAllTaskStatus(var2_4)
	local var5_4 = pg.NewStoryMgr.GetInstance():GetPlayedList()
	local var6_4 = arg0_4.flags[arg1_4.id]
	local var7_4 = arg0_4:GetCondition(var4_4, var5_4, var3_4, var0_4)
	local var8_4 = arg0_4:GetCondition(var4_4, var5_4, var3_4, var1_4)

	if #var0_4 > 0 and #var1_4 == 0 then
		if var7_4 then
			var6_4 = true
		end
	elseif #var0_4 == 0 and #var1_4 > 0 then
		if var8_4 then
			var6_4 = false
		end
	elseif #var0_4 > 0 and #var1_4 > 0 then
		var6_4 = arg0_4:SortCondition(arg1_4, var3_4, var7_4, var8_4)
	end

	arg0_4.flags[arg1_4.id] = var6_4
end

function var0_0.SortCondition(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	if not arg3_5 and not arg4_5 then
		return false
	elseif arg3_5 and not arg4_5 then
		return true
	elseif not arg3_5 and arg4_5 then
		return false
	end

	if arg0_5:IsTaskType(arg3_5) and arg0_5:IsTaskType(arg4_5) then
		return arg0_5:SortTaskCondition(arg2_5, arg3_5, arg4_5)
	elseif arg0_5:IsStoryType(arg3_5) and arg0_5:IsStoryType(arg4_5) then
		return arg0_5:SortStoryCondition(arg3_5, arg4_5)
	elseif arg3_5[3] == arg4_5[3] then
		if arg0_5:IsStoryType(arg3_5) then
			return true
		end

		if arg0_5:IsStoryType(arg4_5) then
			return false
		end

		return true
	else
		return arg3_5[3] > arg4_5[3]
	end
end

function var0_0.SortStoryCondition(arg0_6, arg1_6, arg2_6)
	if arg1_6[3] == arg2_6[3] then
		local var0_6 = {
			arg1_6[2],
			arg2_6[2]
		}

		table.sort(var0_6, function(arg0_7, arg1_7)
			return arg1_7 < arg0_7
		end)

		return var0_6[1] == arg1_6[2]
	else
		return arg1_6[3] > arg2_6[3]
	end
end

function var0_0.SortTaskCondition(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg2_8[2] == arg1_8 and arg3_8[2] == arg1_8 then
		if arg2_8[3] == arg3_8[3] then
			local var0_8 = {
				arg2_8[2],
				arg3_8[2]
			}

			table.sort(var0_8, CompareFuncs({
				function(arg0_9)
					return -1 * pg.island_task[arg0_9].type
				end,
				function(arg0_10)
					return arg0_10
				end
			}))

			return var0_8[1] == arg2_8[2]
		else
			return arg2_8[3] > arg3_8[3]
		end
	else
		return arg2_8[2] == arg1_8
	end
end

function var0_0.CollectAllTaskStatus(arg0_11, arg1_11)
	local var0_11 = {}
	local var1_11 = arg1_11:GetTasks()

	for iter0_11, iter1_11 in pairs(var1_11) do
		var0_11[iter1_11.id] = IslandConst.UNIT_SHOW_TYPE_ACCEPT_TASK

		if iter1_11:IsFinish() then
			var0_11[iter1_11.id] = IslandConst.UNIT_SHOW_TYPE_FINISH_TASK
		end
	end

	for iter2_11, iter3_11 in ipairs(arg1_11.finishedIds) do
		var0_11[iter3_11] = IslandConst.UNIT_SHOW_TYPE_RECIVE_TASK
	end

	return var0_11
end

function var0_0.IsTaskType(arg0_12, arg1_12)
	local var0_12 = arg1_12[1]

	return var0_12 == IslandConst.UNIT_SHOW_TYPE_ACCEPT_TASK or var0_12 == IslandConst.UNIT_SHOW_TYPE_FINISH_TASK or var0_12 == IslandConst.UNIT_SHOW_TYPE_RECIVE_TASK
end

function var0_0.IsStoryType(arg0_13, arg1_13)
	return arg1_13[1] == IslandConst.UNIT_SHOW_TYPE_STORY_PLAYED
end

function var0_0.GetCondition(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	local var0_14 = {}
	local var1_14 = {}

	for iter0_14, iter1_14 in ipairs(arg4_14) do
		if arg0_14:IsTaskType(iter1_14) then
			table.insert(var0_14, iter1_14)
		elseif arg0_14:IsStoryType(iter1_14) then
			table.insert(var1_14, iter1_14)
		end
	end

	local var2_14 = arg0_14:GetTaskCondition(var0_14, arg3_14, arg1_14)
	local var3_14 = arg0_14:GetStoryCondition(arg2_14, var1_14)

	if var2_14 and var3_14 then
		return var3_14[3] >= var2_14[3] and var3_14 or var2_14
	elseif var2_14 and not var3_14 then
		return var2_14
	elseif var3_14 and not var2_14 then
		return var3_14
	end

	return nil
end

function var0_0.GetTaskCondition(arg0_15, arg1_15, arg2_15, arg3_15)
	table.sort(arg1_15, CompareFuncs({
		function(arg0_16)
			return arg0_16[2] == arg2_15 and 1 or 0
		end,
		function(arg0_17)
			return arg0_17[3]
		end
	}))

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		local var0_15 = iter1_15[1]

		if arg3_15[iter1_15[2]] == var0_15 then
			return iter1_15
		end
	end

	return nil
end

function var0_0.GetStoryCondition(arg0_18, arg1_18, arg2_18)
	table.sort(arg2_18, CompareFuncs({
		function(arg0_19)
			return arg0_19[3]
		end
	}))

	for iter0_18, iter1_18 in ipairs(arg2_18) do
		if arg1_18[iter1_18[2]] == true then
			return iter1_18
		end
	end

	return nil
end

function var0_0.IsVisible(arg0_20, arg1_20)
	return arg0_20.flags[arg1_20] == true
end

return var0_0
