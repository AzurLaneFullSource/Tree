ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillManualWeaponReloadBoost", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillManualWeaponReloadBoost = var1
var1.__name = "BattleSkillManualWeaponReloadBoost"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1, lv)

	arg0._weaponType = arg0._tempData.arg_list.weaponType
	arg0._boostValue = arg0._tempData.arg_list.value
	arg0._boostRate = arg0._tempData.arg_list.rate
end

function var1.DoDataEffect(arg0, arg1, arg2)
	local var0 = arg0.getWeaponQueueByType(arg1, arg0._weaponType)

	if var0 then
		local var1 = var0:GetCoolDownList()

		if arg0._boostValue then
			local var2 = arg0._boostValue * -1

			for iter0, iter1 in ipairs(var1) do
				iter1:AppendReloadBoost(var2)
			end
		elseif arg0._boostRate then
			for iter2, iter3 in ipairs(var1) do
				boostValue = iter3:GetReloadTimeByRate(arg0._boostRate) * -1

				iter3:AppendReloadBoost(boostValue)
			end
		end
	end
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:DoDataEffect(arg1, nil)
end

function var1.getWeaponQueueByType(arg0, arg1)
	local var0

	if arg1 == "ChargeWeapon" then
		var0 = arg0:GetChargeQueue()
	elseif arg1 == "TorpedoWeapon" then
		var0 = arg0:GetTorpedoQueue()
	elseif arg1 == "AirAssist" then
		var0 = arg0:GetAirAssistQueue()
	end

	return var0
end
