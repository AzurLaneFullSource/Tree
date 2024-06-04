local var0 = class("OrientedPathFinding", PathFinding)

OrientedPathFinding = var0

function var0.Find(arg0, arg1, arg2)
	arg1 = {
		row = arg1.row,
		column = arg1.column
	}
	arg2 = {
		row = arg2.row,
		column = arg2.column
	}

	if arg0.cells[arg1.row][arg1.column].priority < 0 or arg0.cells[arg2.row][arg2.column].priority < 0 then
		return 0, {}
	else
		return arg0:_Find(arg1, arg2)
	end
end

local var1 = {
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

function var0._Find(arg0, arg1, arg2)
	local var0 = var0.PrioForbidden
	local var1 = {}
	local var2 = {
		arg1
	}
	local var3 = {}
	local var4 = {
		[arg1.row] = {
			[arg1.column] = {
				priority = 0,
				path = {}
			}
		}
	}

	while #var2 > 0 do
		local var5 = table.remove(var2, 1)

		if var5.row == arg2.row and var5.column == arg2.column then
			local var6 = var4[var5.row][var5.column]

			var0 = var6.priority
			var1 = var6.path

			break
		end

		table.insert(var3, var5)
		_.each(var1, function(arg0)
			local var0 = {
				row = var5.row + arg0[1],
				column = var5.column + arg0[2]
			}

			if not (_.any(var2, function(arg0)
				return arg0.row == var0.row and arg0.column == var0.column
			end) or _.any(var3, function(arg0)
				return arg0.row == var0.row and arg0.column == var0.column
			end)) and var0.row >= 0 and var0.row < arg0.rows and var0.column >= 0 and var0.column < arg0.columns and not var0.IsDirectionForbidden(arg0.cells[var5.row][var5.column], arg0[1], arg0[2]) then
				local var1 = var4[var5.row][var5.column]
				local var2 = var1.priority + arg0.cells[var0.row][var0.column].priority

				if var2 < var0.PrioObstacle then
					local var3 = Clone(var1)

					table.insert(var3.path, var0)

					var3.priority = var2
					var4[var0.row] = var4[var0.row] or {}
					var4[var0.row][var0.column] = var3

					local var4 = 0

					for iter0 = #var2, 1, -1 do
						local var5 = var2[iter0]
						local var6 = var4[var5.row][var5.column]

						if var3.priority >= var6.priority then
							var4 = iter0

							break
						end
					end

					table.insert(var2, var4 + 1, var0)
				else
					var0 = math.min(var0, var2)
				end
			end
		end)
	end

	if var0 >= var0.PrioObstacle then
		local var7 = 1000000
		local var8 = var0.PrioForbidden

		for iter0, iter1 in pairs(var4) do
			for iter2, iter3 in pairs(iter1) do
				local var9 = math.abs(arg2.row - iter0) + math.abs(arg2.column - iter2)

				if var9 < var7 or var9 == var7 and var8 > iter3.priority then
					var7 = var9
					var8 = iter3.priority
					var1 = iter3.path
				end
			end
		end
	end

	return var0, var1
end

function var0.IsDirectionForbidden(arg0, arg1, arg2)
	if arg0.forbiddens == ChapterConst.ForbiddenNone then
		return
	end

	local var0

	if arg1 ~= 0 then
		var0 = arg1 < 0 and ChapterConst.ForbiddenUp or ChapterConst.ForbiddenDown
	else
		var0 = arg2 < 0 and ChapterConst.ForbiddenLeft or ChapterConst.ForbiddenRight
	end

	return bit.band(var0, arg0.forbiddens) > 0
end

return var0
