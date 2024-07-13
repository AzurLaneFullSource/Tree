function GetBattleCheck()
	return 0
end

function GetBattleCheckResult(arg0_2, arg1_2, arg2_2)
	local var0_2 = 2621
	local var1_2 = 3527
	local var2_2 = GetBattleCheck()

	arg0_2 = math.floor(arg0_2 % var0_2 * (arg1_2 % var0_2) % var0_2 + arg2_2)

	local var3_2 = tostring(math.floor(var2_2 % var1_2 * (arg1_2 % var1_2) % (var1_2 + arg0_2)))

	return arg0_2, var3_2
end

ys.BattleShipLevelVertify = {}
