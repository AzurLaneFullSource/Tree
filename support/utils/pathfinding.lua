local var0_0 = class("PathFinding")

PathFinding = var0_0
var0_0.PrioNormal = 1
var0_0.PrioObstacle = 1000
var0_0.PrioForbidden = 1000000

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.cells = arg1_1
	arg0_1.rows = arg2_1
	arg0_1.columns = arg3_1
end

function var0_0.Find(arg0_2, arg1_2, arg2_2)
	arg1_2 = {
		row = arg1_2.row,
		column = arg1_2.column
	}
	arg2_2 = {
		row = arg2_2.row,
		column = arg2_2.column
	}

	if arg0_2.cells[arg1_2.row][arg1_2.column] < 0 or arg0_2.cells[arg2_2.row][arg2_2.column] < 0 then
		return 0, {}
	else
		return arg0_2:_Find(arg1_2, arg2_2)
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

function var0_0._Find(arg0_3, arg1_3, arg2_3)
	local var0_3 = var0_0.PrioForbidden
	local var1_3 = {}
	local var2_3 = {
		arg1_3
	}
	local var3_3 = {}
	local var4_3 = {
		[arg1_3.row] = {
			[arg1_3.column] = {
				priority = 0,
				path = {}
			}
		}
	}

	while #var2_3 > 0 do
		local var5_3 = table.remove(var2_3, 1)

		if var5_3.row == arg2_3.row and var5_3.column == arg2_3.column then
			local var6_3 = var4_3[var5_3.row][var5_3.column]

			var0_3 = var6_3.priority
			var1_3 = var6_3.path

			break
		end

		table.insert(var3_3, var5_3)
		_.each(var1_0, function(arg0_4)
			local var0_4 = {
				row = var5_3.row + arg0_4[1],
				column = var5_3.column + arg0_4[2]
			}

			if not (_.any(var2_3, function(arg0_5)
				return arg0_5.row == var0_4.row and arg0_5.column == var0_4.column
			end) or _.any(var3_3, function(arg0_6)
				return arg0_6.row == var0_4.row and arg0_6.column == var0_4.column
			end)) and var0_4.row >= 0 and var0_4.row < arg0_3.rows and var0_4.column >= 0 and var0_4.column < arg0_3.columns then
				local var1_4 = var4_3[var5_3.row][var5_3.column]
				local var2_4 = var1_4.priority + arg0_3.cells[var0_4.row][var0_4.column]

				if var2_4 < var0_0.PrioObstacle then
					local var3_4 = Clone(var1_4)

					table.insert(var3_4.path, var0_4)

					var3_4.priority = var2_4
					var4_3[var0_4.row] = var4_3[var0_4.row] or {}
					var4_3[var0_4.row][var0_4.column] = var3_4

					local var4_4 = 0

					for iter0_4 = #var2_3, 1, -1 do
						local var5_4 = var2_3[iter0_4]
						local var6_4 = var4_3[var5_4.row][var5_4.column]

						if var3_4.priority >= var6_4.priority then
							var4_4 = iter0_4

							break
						end
					end

					table.insert(var2_3, var4_4 + 1, var0_4)
				else
					var0_3 = math.min(var0_3, var2_4)
				end
			end
		end)
	end

	if var0_3 >= var0_0.PrioObstacle then
		local var7_3 = 1000000
		local var8_3 = var0_0.PrioForbidden

		for iter0_3, iter1_3 in pairs(var4_3) do
			for iter2_3, iter3_3 in pairs(iter1_3) do
				local var9_3 = math.abs(arg2_3.row - iter0_3) + math.abs(arg2_3.column - iter2_3)

				if var9_3 < var7_3 or var9_3 == var7_3 and var8_3 > iter3_3.priority then
					var7_3 = var9_3
					var8_3 = iter3_3.priority
					var1_3 = iter3_3.path
				end
			end
		end
	end

	return var0_3, var1_3
end

return var0_0
