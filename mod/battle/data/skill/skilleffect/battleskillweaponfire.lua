ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillWeaponFire", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillWeaponFire = var1
var1.__name = "BattleSkillWeaponFire"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1, lv)

	arg0._weaponType = arg0._tempData.arg_list.weaponType
	arg0._useTempBullet = arg0._tempData.arg_list.preShiftBullet
end

function var1.DoDataEffect(arg0, arg1, arg2)
	local var0 = arg0:_GetWeapon(arg1)

	for iter0, iter1 in ipairs(var0) do
		iter1:SingleFire(arg2, nil, nil, arg0._useTempBullet)
	end
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:DoDataEffect(arg1, nil)
end

function var1._GetWeapon(arg0, arg1)
	local var0 = {}

	if arg0._weaponType == "ChargeWeapon" then
		table.insert(var0, arg1:GetChargeList()[1])
	elseif arg0._weaponType == "TorpedoWeapon" then
		table.insert(var0, arg1:GetTorpedoList()[1])
	elseif arg0._weaponType == "AirAssist" then
		table.insert(var0, arg1:GetAirAssistList()[1])
	elseif arg0._weaponType == "Aircraft" then
		local var1 = arg1:GetHiveList()

		for iter0, iter1 in ipairs(var1) do
			table.insert(var0, iter1)
		end
	else
		table.insert(var0, arg1:GetAutoWeapons()[1])
	end

	return var0
end
