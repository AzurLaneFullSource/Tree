local var0_0 = class("OrientedPathFinding", PathFinding)

OrientedPathFinding = var0_0

function var0_0.Find(arg0_1, arg1_1, arg2_1)
	arg1_1 = {
		row = arg1_1.row,
		column = arg1_1.column
	}
	arg2_1 = {
		row = arg2_1.row,
		column = arg2_1.column
	}

	if arg0_1.cells[arg1_1.row][arg1_1.column].priority < 0 or arg0_1.cells[arg2_1.row][arg2_1.column].priority < 0 then
		return 0, {}
	else
		return arg0_1:_Find(arg1_1, arg2_1)
	end
end

local var1_0 = {
	{
		1,
		0
	},
	{
		-1,
		0
	},
	{
		0,
		1
	},
	{
		0,
		-1
	}
}

function var0_0._Find(arg0_2, arg1_2, arg2_2)
	local var0_2 = var0_0.PrioForbidden
	local var1_2 = {}
	local var2_2 = {
		arg1_2
	}
	local var3_2 = {}
	local var4_2 = {
		[arg1_2.row] = {
			[arg1_2.column] = {
				priority = 0,
				path = {}
			}
		}
	}

	while #var2_2 > 0 do
		local var5_2 = table.remove(var2_2, 1)

		if var5_2.row == arg2_2.row and var5_2.column == arg2_2.column then
			local var6_2 = var4_2[var5_2.row][var5_2.column]

			var0_2 = var6_2.priority
			var1_2 = var6_2.path

			break
		end

		table.insert(var3_2, var5_2)
		_.each(var1_0, function(arg0_3)
			local var0_3 = {
				row = var5_2.row + arg0_3[1],
				column = var5_2.column + arg0_3[2]
			}

			if not (_.any(var2_2, function(arg0_4)
				return arg0_4.row == var0_3.row and arg0_4.column == var0_3.column
			end) or _.any(var3_2, function(arg0_5)
				return arg0_5.row == var0_3.row and arg0_5.column == var0_3.column
			end)) and var0_3.row >= 0 and var0_3.row < arg0_2.rows and var0_3.column >= 0 and var0_3.column < arg0_2.columns and not var0_0.IsDirectionForbidden(arg0_2.cells[var5_2.row][var5_2.column], arg0_3[1], arg0_3[2]) then
				local var1_3 = var4_2[var5_2.row][var5_2.column]
				local var2_3 = var1_3.priority + arg0_2.cells[var0_3.row][var0_3.column].priority

				if var2_3 < var0_0.PrioObstacle then
					local var3_3 = Clone(var1_3)

					table.insert(var3_3.path, var0_3)

					var3_3.priority = var2_3
					var4_2[var0_3.row] = var4_2[var0_3.row] or {}
					var4_2[var0_3.row][var0_3.column] = var3_3

					local var4_3 = 0

					for iter0_3 = #var2_2, 1, -1 do
						local var5_3 = var2_2[iter0_3]
						local var6_3 = var4_2[var5_3.row][var5_3.column]

						if var3_3.priority >= var6_3.priority then
							var4_3 = iter0_3

							break
						end
					end

					table.insert(var2_2, var4_3 + 1, var0_3)
				else
					var0_2 = math.min(var0_2, var2_3)
				end
			end
		end)
	end

	if var0_2 >= var0_0.PrioObstacle then
		local var7_2 = 1000000
		local var8_2 = var0_0.PrioForbidden

		for iter0_2, iter1_2 in pairs(var4_2) do
			for iter2_2, iter3_2 in pairs(iter1_2) do
				local var9_2 = math.abs(arg2_2.row - iter0_2) + math.abs(arg2_2.column - iter2_2)

				if var9_2 < var7_2 or var9_2 == var7_2 and var8_2 > iter3_2.priority then
					var7_2 = var9_2
					var8_2 = iter3_2.priority
					var1_2 = iter3_2.path
				end
			end
		end
	end

	return var0_2, var1_2
end

function var0_0.IsDirectionForbidden(arg0_6, arg1_6, arg2_6)
	if arg0_6.forbiddens == ChapterConst.ForbiddenNone then
		return
	end

	local var0_6

	if arg1_6 ~= 0 then
		var0_6 = arg1_6 < 0 and ChapterConst.ForbiddenUp or ChapterConst.ForbiddenDown
	else
		var0_6 = arg2_6 < 0 and ChapterConst.ForbiddenLeft or ChapterConst.ForbiddenRight
	end

	return bit.band(var0_6, arg0_6.forbiddens) > 0
end

return var0_0
