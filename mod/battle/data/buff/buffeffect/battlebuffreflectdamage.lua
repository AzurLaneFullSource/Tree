ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffReflectDamage = class("BattleBuffReflectDamage", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffReflectDamage.__name = "BattleBuffReflectDamage"

local var1_0 = var0_0.Battle.BattleBuffReflectDamage

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list

	arg0_2._triggerValve = var0_2.valve
	arg0_2._reflectRate = var0_2.reflectRate
	arg0_2._reflectTargetChoice = var0_2.reflectTarget.target_choise
	arg0_2._reflectTargetParam = var0_2.reflectTarget.arg_list
end

function var1_0.onDamageConclude(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg0_3:damageCheck(arg3_3) and not arg3_3.isReflect then
		local var0_3, var1_3 = arg1_3:GetHP()
		local var2_3 = -arg3_3.validDHP

		if var2_3 >= math.floor(var1_3 * arg0_3._triggerValve) then
			local var3_3 = var0_0.Battle.BattleDataProxy.GetInstance()
			local var4_3 = arg0_3:getTargetList(arg1_3, arg0_3._reflectTargetChoice, arg0_3._reflectTargetParam, {})

			if #var4_3 ~= 0 then
				local var5_3 = var4_3[1]
				local var6_3 = math.floor(arg0_3._reflectRate * var2_3)

				var3_3:HandleDirectDamage(var5_3, var6_3, arg1_3, nil, true)
			end
		end
	end
end
