local var0_0 = class("Live2DExtend")
local var1_0 = {
	{
		1,
		2,
		3
	},
	{
		4,
		5,
		6
	},
	{
		7,
		8,
		9
	},
	{
		1,
		4,
		7
	},
	{
		2,
		5,
		8
	},
	{
		3,
		6,
		9
	},
	{
		1,
		5,
		9
	},
	{
		3,
		5,
		7
	}
}

function var0_0.CheckXiaQiFirst(arg0_1)
	local var0_1 = Live2DExtend.GetXiaQiDrags(arg0_1)

	if #var0_1 > 0 then
		local var1_1, var2_1 = Live2DExtend.GetXiaQiState(var0_1)

		if var1_1 == var2_1 or var1_1 < var2_1 then
			return true
		end
	end

	return false
end

function var0_0.CheckXiaQiLast(arg0_2)
	local var0_2 = Live2DExtend.GetXiaQiDrags(arg0_2)

	if #var0_2 > 0 then
		local var1_2, var2_2 = Live2DExtend.GetXiaQiState(var0_2)

		if var2_2 < var1_2 then
			return true
		end
	end

	return false
end

function var0_0.GetXiaQiDrags(arg0_3, arg1_3)
	local var0_3 = {}

	for iter0_3 = 1, #arg0_3.drags do
		local var1_3 = arg0_3.drags[iter0_3]

		if var1_3 and var1_3.actionTrigger and var1_3.actionTrigger.type == Live2DPainting.DRAG_GAME_XIAQI then
			if arg1_3 then
				if table.contains(arg1_3, var1_3:getParameterTarget()) then
					table.insert(var0_3, var1_3)
				end
			else
				table.insert(var0_3, var1_3)
			end
		end
	end

	return var0_3
end

function var0_0.GetXiaQiState(arg0_4)
	local var0_4 = 0
	local var1_4 = 0

	for iter0_4 = 1, #arg0_4 do
		local var2_4 = arg0_4[iter0_4]:getParameterTarget()

		if var2_4 < 0 then
			var1_4 = var1_4 + 1
		elseif var2_4 > 0 then
			var0_4 = var0_4 + 1
		end
	end

	return var0_4, var1_4
end

function var0_0.GetXiaQiLastDrag(arg0_5)
	local var0_5 = Live2DExtend.GetXiaQiDrags(arg0_5, {
		0
	})

	if var0_5 and #var0_5 then
		return var0_5[math.random(1, #var0_5)]
	end

	return nil
end

function var0_0.CheckXiaQiFinish(arg0_6)
	local var0_6 = Live2DExtend.GetXiaQiMatchsIndex(arg0_6, {
		1
	})
	local var1_6 = Live2DExtend.GetXiaQiMatchsIndex(arg0_6, {
		-1
	})

	for iter0_6, iter1_6 in ipairs(var1_0) do
		local var2_6 = true
		local var3_6 = true

		for iter2_6, iter3_6 in ipairs(iter1_6) do
			if not table.contains(var0_6, iter3_6) then
				var2_6 = false
			end

			if not table.contains(var1_6, iter3_6) then
				var3_6 = false
			end
		end

		if var2_6 or var3_6 then
			return true, var2_6
		end
	end

	if #var0_6 + #var1_6 >= 9 then
		return true, true
	end

	return false, false
end

function var0_0.GetXiaQiMatchsIndex(arg0_7, arg1_7)
	local var0_7 = Live2DExtend.GetXiaQiDrags(arg0_7, arg1_7)
	local var1_7 = {}

	for iter0_7, iter1_7 in ipairs(var0_7) do
		local var2_7 = iter1_7.actionTrigger.index

		table.insert(var1_7, var2_7)
	end

	return var1_7
end

function var0_0.CustomSmoothValue(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8)
	if arg2_8 == nil or arg2_8 <= 0 then
		return arg1_8, 0
	end

	arg3_8 = arg3_8 or 0
	arg4_8 = arg4_8 or Time.deltaTime
	arg3_8 = math.min(math.max(arg3_8 + arg4_8, 0), arg2_8)

	local var0_8 = arg3_8 / arg2_8

	return arg0_8 + (arg1_8 - arg0_8) * var0_8, arg3_8
end

return var0_0
