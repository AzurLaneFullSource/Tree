ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillManualWeaponReloadBoost", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillManualWeaponReloadBoost = var1_0
var1_0.__name = "BattleSkillManualWeaponReloadBoost"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._weaponType = arg0_1._tempData.arg_list.weaponType
	arg0_1._boostValue = arg0_1._tempData.arg_list.value
	arg0_1._boostRate = arg0_1._tempData.arg_list.rate
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2.getWeaponQueueByType(arg1_2, arg0_2._weaponType)

	if var0_2 then
		local var1_2 = var0_2:GetCoolDownList()

		if arg0_2._boostValue then
			local var2_2 = arg0_2._boostValue * -1

			for iter0_2, iter1_2 in ipairs(var1_2) do
				iter1_2:AppendReloadBoost(var2_2)
			end
		elseif arg0_2._boostRate then
			for iter2_2, iter3_2 in ipairs(var1_2) do
				boostValue = iter3_2:GetReloadTimeByRate(arg0_2._boostRate) * -1

				iter3_2:AppendReloadBoost(boostValue)
			end
		end
	end
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:DoDataEffect(arg1_3, nil)
end

function var1_0.getWeaponQueueByType(arg0_4, arg1_4)
	local var0_4

	if arg1_4 == "ChargeWeapon" then
		var0_4 = arg0_4:GetChargeQueue()
	elseif arg1_4 == "TorpedoWeapon" then
		var0_4 = arg0_4:GetTorpedoQueue()
	elseif arg1_4 == "AirAssist" then
		var0_4 = arg0_4:GetAirAssistQueue()
	end

	return var0_4
end
