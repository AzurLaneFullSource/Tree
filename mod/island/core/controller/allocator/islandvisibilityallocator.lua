local var0_0 = class("IslandVisibilityAllocator", import(".IslandComparableAllocator"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.lockNpcList = {}

	var0_0.super.Ctor(arg0_1, arg1_1)
end

function var0_0.OnInitFlags(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg0_2.controller.sceneData.unitList) do
		if not arg0_2:IsLockNpc(iter1_2.id, IslandConst.UNIT_LIST_OBJ) then
			arg0_2.flags[iter1_2.id] = not iter1_2.isDynamic

			arg0_2:ApplyCondition(iter1_2)
		elseif arg1_2 then
			arg0_2.flags[iter1_2.id] = arg1_2[iter1_2.id] or not iter1_2.isDynamic
		end
	end
end

function var0_0.OnCompareSample(arg0_3, arg1_3, arg2_3)
	for iter0_3, iter1_3 in pairs(arg1_3) do
		local var0_3 = iter1_3
		local var1_3 = arg2_3[iter0_3]

		if var0_3 ~= nil and var1_3 ~= nil and var0_3 ~= var1_3 then
			if var0_3 == true and var1_3 == false then
				arg0_3:RemoveUnit(IslandConst.UNIT_LIST_OBJ, iter0_3)
			elseif var0_3 == false and var1_3 == true then
				local var2_3 = arg0_3:GetUnitData(iter0_3)

				if var2_3 then
					arg0_3:GenUnit(var2_3)
				end
			end
		end
	end
end

function var0_0.GetUnitData(arg0_4, arg1_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.controller.sceneData.unitList) do
		if iter1_4.id == arg1_4 then
			return iter1_4
		end
	end

	return nil
end

function var0_0.ApplyCondition(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetShowCondition()
	local var1_5 = arg1_5:GetHideCondition()

	if #var0_5 == 0 and #var1_5 == 0 then
		return
	end

	local var2_5 = arg0_5.controller.island:GetTaskAgency()
	local var3_5 = var2_5:GetTraceId()
	local var4_5 = var2_5:GetMainTraceId()
	local var5_5 = arg0_5:CollectAllTaskStatus(var2_5)
	local var6_5 = pg.NewStoryMgr.GetInstance():GetPlayedList()
	local var7_5 = arg0_5.flags[arg1_5.id]
	local var8_5 = arg0_5:GetCondition(var5_5, var6_5, var3_5, var4_5, var0_5)
	local var9_5 = arg0_5:GetCondition(var5_5, var6_5, var3_5, var4_5, var1_5)

	if #var0_5 > 0 and #var1_5 == 0 then
		if var8_5 then
			var7_5 = true
		end
	elseif #var0_5 == 0 and #var1_5 > 0 then
		if var9_5 then
			var7_5 = false
		end
	elseif #var0_5 > 0 and #var1_5 > 0 then
		var7_5 = arg0_5:SortCondition(arg1_5, var3_5, var4_5, var8_5, var9_5)
	end

	arg0_5.flags[arg1_5.id] = var7_5
end

function var0_0.SortCondition(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6, arg5_6)
	if not arg4_6 and not arg5_6 then
		return false
	elseif arg4_6 and not arg5_6 then
		return true
	elseif not arg4_6 and arg5_6 then
		return false
	end

	if arg0_6:IsTaskType(arg4_6) and arg0_6:IsTaskType(arg5_6) then
		return arg0_6:SortTaskCondition(arg2_6, arg3_6, arg4_6, arg5_6)
	elseif arg0_6:IsStoryType(arg4_6) and arg0_6:IsStoryType(arg5_6) then
		return arg0_6:SortStoryCondition(arg4_6, arg5_6)
	elseif arg4_6[3] == arg5_6[3] then
		if arg0_6:IsStoryType(arg4_6) then
			return true
		end

		if arg0_6:IsStoryType(arg5_6) then
			return false
		end

		return true
	else
		return arg4_6[3] > arg5_6[3]
	end
end

function var0_0.SortStoryCondition(arg0_7, arg1_7, arg2_7)
	if arg1_7[3] == arg2_7[3] then
		local var0_7 = {
			arg1_7[2],
			arg2_7[2]
		}

		table.sort(var0_7, function(arg0_8, arg1_8)
			return arg1_8 < arg0_8
		end)

		return var0_7[1] == arg1_7[2]
	else
		return arg1_7[3] > arg2_7[3]
	end
end

function var0_0.SortTaskCondition(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9)
	if arg3_9[2] == arg1_9 and arg4_9[2] == arg1_9 or arg3_9[2] == arg2_9 and arg4_9[2] == arg2_9 then
		if arg3_9[3] == arg4_9[3] then
			local var0_9 = {
				arg3_9[2],
				arg4_9[2]
			}

			table.sort(var0_9, CompareFuncs({
				function(arg0_10)
					return -1 * pg.island_task[arg0_10].type
				end,
				function(arg0_11)
					return arg0_11
				end
			}))

			return var0_9[1] == arg3_9[2]
		else
			return arg3_9[3] > arg4_9[3]
		end
	else
		return arg3_9[2] == arg1_9 or arg3_9[2] == arg2_9
	end
end

function var0_0.CollectAllTaskStatus(arg0_12, arg1_12)
	local var0_12 = {}
	local var1_12 = arg1_12:GetTasks()

	for iter0_12, iter1_12 in pairs(var1_12) do
		var0_12[iter1_12.id] = IslandConst.UNIT_SHOW_TYPE_ACCEPT_TASK

		if iter1_12:IsFinish() then
			var0_12[iter1_12.id] = IslandConst.UNIT_SHOW_TYPE_FINISH_TASK
		end
	end

	for iter2_12, iter3_12 in ipairs(arg1_12.finishedIds) do
		var0_12[iter3_12] = IslandConst.UNIT_SHOW_TYPE_RECIVE_TASK
	end

	return var0_12
end

function var0_0.IsTaskType(arg0_13, arg1_13)
	local var0_13 = arg1_13[1]

	return var0_13 == IslandConst.UNIT_SHOW_TYPE_ACCEPT_TASK or var0_13 == IslandConst.UNIT_SHOW_TYPE_FINISH_TASK or var0_13 == IslandConst.UNIT_SHOW_TYPE_RECIVE_TASK
end

function var0_0.IsStoryType(arg0_14, arg1_14)
	return arg1_14[1] == IslandConst.UNIT_SHOW_TYPE_STORY_PLAYED
end

function var0_0.GetCondition(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15, arg5_15)
	local var0_15 = {}
	local var1_15 = {}

	for iter0_15, iter1_15 in ipairs(arg5_15) do
		if arg0_15:IsTaskType(iter1_15) then
			table.insert(var0_15, iter1_15)
		elseif arg0_15:IsStoryType(iter1_15) then
			table.insert(var1_15, iter1_15)
		end
	end

	local var2_15 = arg0_15:GetTaskCondition(var0_15, arg3_15, arg4_15, arg1_15)
	local var3_15 = arg0_15:GetStoryCondition(arg2_15, var1_15)

	if var2_15 and var3_15 then
		return var3_15[3] >= var2_15[3] and var3_15 or var2_15
	elseif var2_15 and not var3_15 then
		return var2_15
	elseif var3_15 and not var2_15 then
		return var3_15
	end

	return nil
end

function var0_0.GetTaskCondition(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16)
	table.sort(arg1_16, CompareFuncs({
		function(arg0_17)
			return (arg0_17[2] == arg2_16 or arg0_17[2] == arg3_16) and 1 or 0
		end,
		function(arg0_18)
			return arg0_18[3]
		end
	}))

	for iter0_16, iter1_16 in ipairs(arg1_16) do
		local var0_16 = iter1_16[1]

		if arg4_16[iter1_16[2]] == var0_16 then
			return iter1_16
		end
	end

	return nil
end

function var0_0.GetStoryCondition(arg0_19, arg1_19, arg2_19)
	table.sort(arg2_19, CompareFuncs({
		function(arg0_20)
			return arg0_20[3]
		end
	}))

	for iter0_19, iter1_19 in ipairs(arg2_19) do
		if arg1_19[iter1_19[2]] == true then
			return iter1_19
		end
	end

	return nil
end

function var0_0.IsVisible(arg0_21, arg1_21)
	return arg0_21.flags[arg1_21] == true
end

function var0_0.IsLockNpc(arg0_22, arg1_22, arg2_22)
	return _.any(arg0_22.lockNpcList or {}, function(arg0_23)
		return arg0_23[1] == arg1_22 and arg0_23[2] == arg2_22
	end)
end

function var0_0.LockNpc(arg0_24, arg1_24, arg2_24)
	table.insert(arg0_24.lockNpcList, {
		arg1_24,
		arg2_24
	})
end

function var0_0.ReleaseNpc(arg0_25, arg1_25, arg2_25)
	for iter0_25 = #arg0_25.lockNpcList, 1, -1 do
		local var0_25 = arg0_25.lockNpcList[iter0_25]

		if var0_25[1] == arg1_25 and var0_25[2] == arg2_25 then
			table.remove(arg0_25.lockNpcList, iter0_25)
		end
	end
end

return var0_0
