function GetBattleCheck()
	return 0
end

function GetBattleCheckResult(arg0, arg1, arg2)
	local var0 = 2621
	local var1 = 3527
	local var2 = GetBattleCheck()

	arg0 = math.floor(arg0 % var0 * (arg1 % var0) % var0 + arg2)

	local var3 = tostring(math.floor(var2 % var1 * (arg1 % var1) % (var1 + arg0)))

	return arg0, var3
end

ys.BattleShipLevelVertify = {}
