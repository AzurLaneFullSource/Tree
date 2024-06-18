function prepareLevelExpConfig(arg0_1, arg1_1)
	arg1_1 = arg1_1 or "exp"

	local var0_1

	for iter0_1, iter1_1 in ipairs(arg0_1.all) do
		local var1_1 = arg0_1[iter1_1]

		var1_1.level0 = iter0_1 - 1
		var1_1.level1 = iter0_1

		if not var0_1 then
			var1_1[arg1_1 .. "_start"] = 0
		else
			var1_1[arg1_1 .. "_start"] = var0_1[arg1_1 .. "_start"] + var0_1[arg1_1 .. "_interval"]
		end

		var1_1[arg1_1 .. "_interval"] = var1_1[arg1_1]
		var1_1[arg1_1 .. "_end"] = var1_1[arg1_1 .. "_start"] + var1_1[arg1_1] - 1
		var0_1 = var1_1
	end
end

function getConfigFromTotalExp(arg0_2, arg1_2, arg2_2)
	arg2_2 = arg2_2 or "exp"

	local var0_2

	for iter0_2, iter1_2 in ipairs(arg0_2.all) do
		var0_2 = arg0_2[iter1_2]

		if arg1_2 < var0_2[arg2_2 .. "_end"] then
			return var0_2
		end
	end

	return var0_2
end

function getConfigFromLevel0(arg0_3, arg1_3)
	return arg0_3[arg1_3 + 1] or arg0_3[#arg0_3]
end

function getConfigFromLevel1(arg0_4, arg1_4)
	return arg0_4[arg1_4] or arg0_4[#arg0_4]
end

function getExpByRarityFromLv1(arg0_5, arg1_5)
	local var0_5 = getConfigFromLevel1(pg.ship_level, arg1_5)

	if arg0_5 >= ShipRarity.SSR then
		return var0_5.exp_ur
	else
		return var0_5.exp
	end
end

prepareLevelExpConfig(pg.user_level)
prepareLevelExpConfig(pg.ship_level)
prepareLevelExpConfig(pg.ship_level, "exp_ur")
