ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = class("BattleSkillFireSupport", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillFireSupport = var3_0
var3_0.__name = "BattleSkillFireSupport"

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._weaponID = arg0_1._tempData.arg_list.weapon_id
	arg0_1._supportTargetFilter = arg0_1._tempData.arg_list.supportTarget.targetChoice
	arg0_1._supportTargetArgList = arg0_1._tempData.arg_list.supportTarget.arg_list
end

function var3_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	if arg0_2._weapon == nil then
		local var0_2

		for iter0_2, iter1_2 in ipairs(arg0_2._supportTargetFilter) do
			var0_2 = var0_0.Battle.BattleTargetChoise[iter1_2](arg1_2, arg0_2._supportTargetArgList, var0_2)
		end

		local var1_2 = var0_2[1]

		arg0_2._weapon = var0_0.Battle.BattleDataFunction.CreateWeaponUnit(arg0_2._weaponID, arg1_2)

		if BATTLE_DEBUG and (arg0_2._weapon:GetType() == var2_0.EquipmentType.INTERCEPT_AIRCRAFT or arg0_2._weapon:GetType() == var2_0.EquipmentType.STRIKE_AIRCRAFT) then
			arg0_2._weapon:GetATKAircraftList()
		end

		if var1_2 then
			arg0_2._weapon:SetStandHost(var1_2)
		end

		local var2_2 = {
			weapon = arg0_2._weapon
		}
		local var3_2 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, var2_2)

		arg1_2:DispatchEvent(var3_2)
	end

	local function var4_2()
		arg0_2._weapon:Clear()
	end

	arg0_2._weapon:updateMovementInfo()
	arg0_2._weapon:SingleFire(arg2_2, arg0_2._emitter, var4_2)
end

function var3_0.DoDataEffectWithoutTarget(arg0_4, arg1_4)
	arg0_4:DoDataEffect(arg1_4)
end

function var3_0.Clear(arg0_5)
	var3_0.super.Clear(arg0_5)

	if arg0_5._weapon and not arg0_5._weapon:GetHost():IsAlive() then
		arg0_5._weapon:Clear()
	end
end

function var3_0.Interrupt(arg0_6)
	var3_0.super.Interrupt(arg0_6)

	if arg0_6._weapon then
		arg0_6._weapon:Cease()
		arg0_6._weapon:Clear()
	end
end

function var3_0.GetDamageSum(arg0_7)
	local var0_7 = 0

	if not arg0_7._weapon then
		var0_7 = 0
	elseif arg0_7._weapon:GetType() == var2_0.EquipmentType.INTERCEPT_AIRCRAFT or arg0_7._weapon:GetType() == var2_0.EquipmentType.STRIKE_AIRCRAFT then
		for iter0_7, iter1_7 in ipairs(arg0_7._weapon:GetATKAircraftList()) do
			local var1_7 = iter1_7:GetWeapon()

			for iter2_7, iter3_7 in ipairs(var1_7) do
				var0_7 = var0_7 + iter3_7:GetDamageSUM()
			end
		end
	else
		var0_7 = arg0_7._weapon:GetDamageSUM()
	end

	return var0_7
end
