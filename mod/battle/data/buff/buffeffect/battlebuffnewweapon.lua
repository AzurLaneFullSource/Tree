ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleDataFunction
local var3 = class("BattleBuffNewWeapon", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffNewWeapon = var3
var3.__name = "BattleBuffNewWeapon"

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1)
end

function var3.SetArgs(arg0, arg1, arg2)
	arg0._weaponID = arg0._tempData.arg_list.weapon_id
	arg0._reverse = arg0._tempData.arg_list.reverse
end

function var3.onAttach(arg0, arg1, arg2)
	if arg0._reverse then
		arg1:RemoveAutoWeaponByWeaponID(arg0._weaponID)
	elseif var2.GetWeaponPropertyDataFromID(arg0._weaponID).type == var1.EquipmentType.FLEET_ANTI_AIR then
		arg1:AddWeapon(arg0._weaponID)
		arg1:GetFleetVO():GetFleetAntiAirWeapon():FlushCrewUnit(arg1)
	else
		arg0._weapon = arg1:AddNewAutoWeapon(arg0._weaponID)
	end
end

function var3.onRemove(arg0, arg1, arg2)
	if arg0._reverse then
		arg1:AddNewAutoWeapon(arg0._weaponID)
	elseif arg0._weapon then
		if var2.GetWeaponPropertyDataFromID(arg0._weaponID).type == var1.EquipmentType.FLEET_ANTI_AIR then
			arg1:RemoveWeapon(arg0._weaponID)
			arg1:RemoveFleetAntiAirWeapon(arg0._weapon)
			arg1:GetFleetVO():GetFleetAntiAirWeapon():FlushCrewUnit(arg1)
		else
			arg0._weapon:Clear()
			arg1:RemoveAutoWeapon(arg0._weapon)
		end
	end
end

function var3.Dispose(arg0)
	var3.super.Dispose(arg0)

	arg0._weapon = nil
end
