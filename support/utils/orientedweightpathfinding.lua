local var0 = class("OrientedWeightPathFinding", OrientedPathFinding)

OrientedWeightPathFinding = var0

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

local function var2(arg0, arg1, arg2, arg3, arg4)
	local var0 = var0.PrioForbidden
	local var1 = {}
	local var2 = {
		arg3
	}
	local var3 = {}
	local var4 = {
		[arg3.row] = {
			[arg3.column] = {
				enemyCount = 0,
				priority = 0,
				path = {}
			}
		}
	}

	while #var2 > 0 do
		local var5 = table.remove(var2, 1)

		if var5.row == arg4.row and var5.column == arg4.column then
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

			if not _.any(var3, function(arg0)
				return arg0.row == var0.row and arg0.column == var0.column
			end) and var0.row >= 0 and var0.row < arg1 and var0.column >= 0 and var0.column < arg2 and not var0.IsDirectionForbidden(arg0[var5.row][var5.column], arg0[1], arg0[2]) then
				local var1 = var4[var5.row][var5.column]
				local var2 = arg0[var0.row][var0.column]
				local var3 = var1.priority + var2.priority
				local var4 = var1.enemyCount + (var2.isEnemy and 1 or 0)

				if var3 < var0.PrioObstacle then
					local var5 = Clone(var1)

					table.insert(var5.path, var0)

					var5.priority = var3
					var5.enemyCount = var1.enemyCount + var4

					local var6 = _.detect(var2, function(arg0)
						return arg0.row == var0.row and arg0.column == var0.column
					end)
					local var7 = not var6

					if var6 then
						local var8 = var4[var0.row][var0.column]

						var7 = var8.enemyCount > var5.enemyCount or var8.enemyCount == var5.enemyCount and var8.priority > var5.priority

						if var7 then
							table.removebyvalue(var2, var6)
						end
					end

					if var7 then
						var4[var0.row] = var4[var0.row] or {}
						var4[var0.row][var0.column] = var5

						local var9 = 0

						for iter0 = #var2, 1, -1 do
							local var10 = var2[iter0]
							local var11 = var4[var10.row][var10.column]

							if var5.enemyCount > var11.enemyCount or var5.enemyCount == var11.enemyCount and var5.priority >= var11.priority then
								var9 = iter0

								break
							end
						end

						table.insert(var2, var9 + 1, var0)
					end
				else
					var0 = math.min(var0, var3)
				end
			end
		end)
	end

	if var0 >= var0.PrioObstacle then
		local var7 = 1000000
		local var8 = var0.PrioForbidden

		for iter0, iter1 in pairs(var4) do
			for iter2, iter3 in pairs(iter1) do
				local var9 = math.abs(arg4.row - iter0) + math.abs(arg4.column - iter2)

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

function var0.StaticFind(arg0, arg1, arg2, arg3, arg4)
	arg3 = {
		row = arg3.row,
		column = arg3.column
	}
	arg4 = {
		row = arg4.row,
		column = arg4.column
	}

	if arg0[arg3.row][arg3.column].priority < 0 or arg0[arg4.row][arg4.column].priority < 0 then
		return 0, {}
	else
		return var2(arg0, arg1, arg2, arg3, arg4)
	end
end

return var0
