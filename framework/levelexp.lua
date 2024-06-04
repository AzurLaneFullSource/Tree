function prepareLevelExpConfig(arg0, arg1)
	arg1 = arg1 or "exp"

	local var0

	for iter0, iter1 in ipairs(arg0.all) do
		local var1 = arg0[iter1]

		var1.level0 = iter0 - 1
		var1.level1 = iter0

		if not var0 then
			var1[arg1 .. "_start"] = 0
		else
			var1[arg1 .. "_start"] = var0[arg1 .. "_start"] + var0[arg1 .. "_interval"]
		end

		var1[arg1 .. "_interval"] = var1[arg1]
		var1[arg1 .. "_end"] = var1[arg1 .. "_start"] + var1[arg1] - 1
		var0 = var1
	end
end

function getConfigFromTotalExp(arg0, arg1, arg2)
	arg2 = arg2 or "exp"

	local var0

	for iter0, iter1 in ipairs(arg0.all) do
		var0 = arg0[iter1]

		if arg1 < var0[arg2 .. "_end"] then
			return var0
		end
	end

	return var0
end

function getConfigFromLevel0(arg0, arg1)
	return arg0[arg1 + 1] or arg0[#arg0]
end

function getConfigFromLevel1(arg0, arg1)
	return arg0[arg1] or arg0[#arg0]
end

function getExpByRarityFromLv1(arg0, arg1)
	local var0 = getConfigFromLevel1(pg.ship_level, arg1)

	if arg0 >= ShipRarity.SSR then
		return var0.exp_ur
	else
		return var0.exp
	end
end

prepareLevelExpConfig(pg.user_level)
prepareLevelExpConfig(pg.ship_level)
prepareLevelExpConfig(pg.ship_level, "exp_ur")
