local var0 = class("ActivityLevelConst")

function var0.getExtraChapterSocre(arg0, arg1, arg2, arg3)
	if not arg3 or arg3:isEnd() then
		return 0, 0
	end

	local var0 = arg3:getConfig("config_data")

	assert(var0, "miss config >>" .. arg0)

	local var1 = 0
	local var2 = 0

	if var0 then
		var1 = (var0[2] / math.pow(arg1 + var0[3], var0[4]) - math.pow(arg2, var0[5])) * var0[6]
		var1 = math.max(var1, 1)
	end

	local var3 = arg3:getData1() or 0

	return math.floor(var1), math.floor(var3)
end

function var0.getShipsPower(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0) do
		var0 = var0 + iter1:getShipCombatPower()
	end

	return var0
end

return var0
