ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillWeaponFire", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillWeaponFire = var1_0
var1_0.__name = "BattleSkillWeaponFire"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._weaponType = arg0_1._tempData.arg_list.weaponType
	arg0_1._useTempBullet = arg0_1._tempData.arg_list.preShiftBullet
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:_GetWeapon(arg1_2)

	for iter0_2, iter1_2 in ipairs(var0_2) do
		iter1_2:SingleFire(arg2_2, nil, nil, arg0_2._useTempBullet)
	end
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:DoDataEffect(arg1_3, nil)
end

function var1_0._GetWeapon(arg0_4, arg1_4)
	local var0_4 = {}

	if arg0_4._weaponType == "ChargeWeapon" then
		table.insert(var0_4, arg1_4:GetChargeList()[1])
	elseif arg0_4._weaponType == "TorpedoWeapon" then
		table.insert(var0_4, arg1_4:GetTorpedoList()[1])
	elseif arg0_4._weaponType == "AirAssist" then
		table.insert(var0_4, arg1_4:GetAirAssistList()[1])
	elseif arg0_4._weaponType == "Aircraft" then
		local var1_4 = arg1_4:GetHiveList()

		for iter0_4, iter1_4 in ipairs(var1_4) do
			table.insert(var0_4, iter1_4)
		end
	else
		table.insert(var0_4, arg1_4:GetAutoWeapons()[1])
	end

	return var0_4
end
