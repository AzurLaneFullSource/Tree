ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleDataFunction
local var3_0 = class("BattleBuffNewWeapon", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffNewWeapon = var3_0
var3_0.__name = "BattleBuffNewWeapon"

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)
end

function var3_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._weaponID = arg0_2._tempData.arg_list.weapon_id
	arg0_2._reverse = arg0_2._tempData.arg_list.reverse
end

function var3_0.onAttach(arg0_3, arg1_3, arg2_3)
	if arg0_3._reverse then
		arg1_3:RemoveAutoWeaponByWeaponID(arg0_3._weaponID)
	elseif var2_0.GetWeaponPropertyDataFromID(arg0_3._weaponID).type == var1_0.EquipmentType.FLEET_ANTI_AIR then
		arg1_3:AddWeapon(arg0_3._weaponID)
		arg1_3:GetFleetVO():GetFleetAntiAirWeapon():FlushCrewUnit(arg1_3)
	else
		arg0_3._weapon = arg1_3:AddNewAutoWeapon(arg0_3._weaponID)
	end
end

function var3_0.onRemove(arg0_4, arg1_4, arg2_4)
	if arg0_4._reverse then
		arg1_4:AddNewAutoWeapon(arg0_4._weaponID)
	elseif arg0_4._weapon then
		if var2_0.GetWeaponPropertyDataFromID(arg0_4._weaponID).type == var1_0.EquipmentType.FLEET_ANTI_AIR then
			arg1_4:RemoveWeapon(arg0_4._weaponID)
			arg1_4:RemoveFleetAntiAirWeapon(arg0_4._weapon)
			arg1_4:GetFleetVO():GetFleetAntiAirWeapon():FlushCrewUnit(arg1_4)
		else
			arg0_4._weapon:Clear()
			arg1_4:RemoveAutoWeapon(arg0_4._weapon)
		end
	end
end

function var3_0.Dispose(arg0_5)
	var3_0.super.Dispose(arg0_5)

	arg0_5._weapon = nil
end
