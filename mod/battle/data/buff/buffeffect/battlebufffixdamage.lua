ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffFixDamage = class("BattleBuffFixDamage", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffFixDamage.__name = "BattleBuffFixDamage"

local var1 = var0.Battle.BattleBuffFixDamage

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._fixProb = arg0._tempData.arg_list.rant or 10000
	arg0._fixValue = arg0._tempData.arg_list.value
	arg0._fixRate = arg0._tempData.arg_list.rate
end

function var1.onBeforeTakeDamage(arg0, arg1, arg2, arg3)
	if not arg0:damageCheck(arg3) then
		return
	end

	local var0 = arg3.damage
	local var1 = arg3.damage

	if (arg0._fixProb >= 10000 or var0.Battle.BattleFormulas.IsHappen(arg0._fixProb)) and (arg0._fixValue or arg0._fixRate) then
		if arg0._fixRate then
			var1 = math.max(1, var0 * arg0._fixRate)
			arg3.fixFlag = true
		elseif var0 > arg0._fixValue then
			var1 = arg0._fixValue
			arg3.fixFlag = true
		end
	end

	local var2 = arg0._tempData.arg_list
	local var3
	local var4, var5 = arg1:GetHP()

	if var2.cap_value then
		var3 = var2.cap_value
	elseif var2.cap_hp_rate then
		var3 = math.floor(var4 * var2.cap_hp_rate)
	elseif var2.cap_hp_rate_max then
		var3 = math.floor(var5 * var2.cap_hp_rate_max)
	end

	if var3 then
		if var2.cap_ceiling then
			var3 = math.max(var3, var2.cap_ceiling)
		elseif var2.cap_ceiling_rate then
			var3 = math.max(var3, math.floor(var2.cap_ceiling_rate * var5))
		end

		if var3 < var1 then
			arg3.capFlag = true
			var1 = var3
		end
	end

	arg3.damage = var1
end
