local var0_0 = class("ActivityLevelConst")

function var0_0.getExtraChapterSocre(arg0_1, arg1_1, arg2_1, arg3_1)
	if not arg3_1 or arg3_1:isEnd() then
		return 0, 0
	end

	local var0_1 = arg3_1:getConfig("config_data")

	assert(var0_1, "miss config >>" .. arg0_1)

	local var1_1 = 0
	local var2_1 = 0

	if var0_1 then
		var1_1 = (var0_1[2] / math.pow(arg1_1 + var0_1[3], var0_1[4]) - math.pow(arg2_1, var0_1[5])) * var0_1[6]
		var1_1 = math.max(var1_1, 1)
	end

	local var3_1 = arg3_1:getData1() or 0

	return math.floor(var1_1), math.floor(var3_1)
end

function var0_0.getShipsPower(arg0_2)
	local var0_2 = 0

	for iter0_2, iter1_2 in pairs(arg0_2) do
		var0_2 = var0_2 + iter1_2:getShipCombatPower()
	end

	return var0_2
end

return var0_0
