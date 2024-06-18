local var0_0 = class("OrientedWeightPathFinding", OrientedPathFinding)

OrientedWeightPathFinding = var0_0

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

local function var2_0(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	local var0_1 = var0_0.PrioForbidden
	local var1_1 = {}
	local var2_1 = {
		arg3_1
	}
	local var3_1 = {}
	local var4_1 = {
		[arg3_1.row] = {
			[arg3_1.column] = {
				enemyCount = 0,
				priority = 0,
				path = {}
			}
		}
	}

	while #var2_1 > 0 do
		local var5_1 = table.remove(var2_1, 1)

		if var5_1.row == arg4_1.row and var5_1.column == arg4_1.column then
			local var6_1 = var4_1[var5_1.row][var5_1.column]

			var0_1 = var6_1.priority
			var1_1 = var6_1.path

			break
		end

		table.insert(var3_1, var5_1)
		_.each(var1_0, function(arg0_2)
			local var0_2 = {
				row = var5_1.row + arg0_2[1],
				column = var5_1.column + arg0_2[2]
			}

			if not _.any(var3_1, function(arg0_3)
				return arg0_3.row == var0_2.row and arg0_3.column == var0_2.column
			end) and var0_2.row >= 0 and var0_2.row < arg1_1 and var0_2.column >= 0 and var0_2.column < arg2_1 and not var0_0.IsDirectionForbidden(arg0_1[var5_1.row][var5_1.column], arg0_2[1], arg0_2[2]) then
				local var1_2 = var4_1[var5_1.row][var5_1.column]
				local var2_2 = arg0_1[var0_2.row][var0_2.column]
				local var3_2 = var1_2.priority + var2_2.priority
				local var4_2 = var1_2.enemyCount + (var2_2.isEnemy and 1 or 0)

				if var3_2 < var0_0.PrioObstacle then
					local var5_2 = Clone(var1_2)

					table.insert(var5_2.path, var0_2)

					var5_2.priority = var3_2
					var5_2.enemyCount = var1_2.enemyCount + var4_2

					local var6_2 = _.detect(var2_1, function(arg0_4)
						return arg0_4.row == var0_2.row and arg0_4.column == var0_2.column
					end)
					local var7_2 = not var6_2

					if var6_2 then
						local var8_2 = var4_1[var0_2.row][var0_2.column]

						var7_2 = var8_2.enemyCount > var5_2.enemyCount or var8_2.enemyCount == var5_2.enemyCount and var8_2.priority > var5_2.priority

						if var7_2 then
							table.removebyvalue(var2_1, var6_2)
						end
					end

					if var7_2 then
						var4_1[var0_2.row] = var4_1[var0_2.row] or {}
						var4_1[var0_2.row][var0_2.column] = var5_2

						local var9_2 = 0

						for iter0_2 = #var2_1, 1, -1 do
							local var10_2 = var2_1[iter0_2]
							local var11_2 = var4_1[var10_2.row][var10_2.column]

							if var5_2.enemyCount > var11_2.enemyCount or var5_2.enemyCount == var11_2.enemyCount and var5_2.priority >= var11_2.priority then
								var9_2 = iter0_2

								break
							end
						end

						table.insert(var2_1, var9_2 + 1, var0_2)
					end
				else
					var0_1 = math.min(var0_1, var3_2)
				end
			end
		end)
	end

	if var0_1 >= var0_0.PrioObstacle then
		local var7_1 = 1000000
		local var8_1 = var0_0.PrioForbidden

		for iter0_1, iter1_1 in pairs(var4_1) do
			for iter2_1, iter3_1 in pairs(iter1_1) do
				local var9_1 = math.abs(arg4_1.row - iter0_1) + math.abs(arg4_1.column - iter2_1)

				if var9_1 < var7_1 or var9_1 == var7_1 and var8_1 > iter3_1.priority then
					var7_1 = var9_1
					var8_1 = iter3_1.priority
					var1_1 = iter3_1.path
				end
			end
		end
	end

	return var0_1, var1_1
end

function var0_0.StaticFind(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	arg3_5 = {
		row = arg3_5.row,
		column = arg3_5.column
	}
	arg4_5 = {
		row = arg4_5.row,
		column = arg4_5.column
	}

	if arg0_5[arg3_5.row][arg3_5.column].priority < 0 or arg0_5[arg4_5.row][arg4_5.column].priority < 0 then
		return 0, {}
	else
		return var2_0(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
	end
end

return var0_0
