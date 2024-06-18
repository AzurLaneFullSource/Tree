ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffFixDamage = class("BattleBuffFixDamage", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffFixDamage.__name = "BattleBuffFixDamage"

local var1_0 = var0_0.Battle.BattleBuffFixDamage

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._fixProb = arg0_2._tempData.arg_list.rant or 10000
	arg0_2._fixValue = arg0_2._tempData.arg_list.value
	arg0_2._fixRate = arg0_2._tempData.arg_list.rate
end

function var1_0.onBeforeTakeDamage(arg0_3, arg1_3, arg2_3, arg3_3)
	if not arg0_3:damageCheck(arg3_3) then
		return
	end

	local var0_3 = arg3_3.damage
	local var1_3 = arg3_3.damage

	if (arg0_3._fixProb >= 10000 or var0_0.Battle.BattleFormulas.IsHappen(arg0_3._fixProb)) and (arg0_3._fixValue or arg0_3._fixRate) then
		if arg0_3._fixRate then
			var1_3 = math.max(1, var0_3 * arg0_3._fixRate)
			arg3_3.fixFlag = true
		elseif var0_3 > arg0_3._fixValue then
			var1_3 = arg0_3._fixValue
			arg3_3.fixFlag = true
		end
	end

	local var2_3 = arg0_3._tempData.arg_list
	local var3_3
	local var4_3, var5_3 = arg1_3:GetHP()

	if var2_3.cap_value then
		var3_3 = var2_3.cap_value
	elseif var2_3.cap_hp_rate then
		var3_3 = math.floor(var4_3 * var2_3.cap_hp_rate)
	elseif var2_3.cap_hp_rate_max then
		var3_3 = math.floor(var5_3 * var2_3.cap_hp_rate_max)
	end

	if var3_3 then
		if var2_3.cap_ceiling then
			var3_3 = math.max(var3_3, var2_3.cap_ceiling)
		elseif var2_3.cap_ceiling_rate then
			var3_3 = math.max(var3_3, math.floor(var2_3.cap_ceiling_rate * var5_3))
		end

		if var3_3 < var1_3 then
			arg3_3.capFlag = true
			var1_3 = var3_3
		end
	end

	arg3_3.damage = var1_3
end
